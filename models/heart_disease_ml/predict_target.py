import logging
import joblib
import pandas as pd
import os
from snowflake.snowpark import types as T

DB_STAGE = 'MODELSTAGE'
version = '1.0'
# The name of the model file
model_file_path = 'heart_disease_'+version
model_file_packaged = 'heart_disease_'+version+'.joblib'

# Storing the various artifacts locally
LOCAL_TEMP_DIR = f'/tmp/heart_disease'
DOWNLOAD_DIR = os.path.join(LOCAL_TEMP_DIR, 'download')
TARGET_MODEL_DIR_PATH = os.path.join(LOCAL_TEMP_DIR, 'ml_model')
TARGET_LIB_PATH = os.path.join(LOCAL_TEMP_DIR, 'lib')

# The feature columns that were used during model training
FEATURE_COLS = [
        "AGE", 
        "SEX", 
        "CP", 
        "TRESTBPS", 
        "CHOL", 
        "FBS", 
        "RESTECG", 
        "THALACH", 
        "EXANG", 
        "OLDPEAK", 
        "SLOPE", 
        "CA", 
        "THAL"]

def register_udf_for_prediction(p_predictor ,p_session ,p_dbt):

# The prediction udf

    def predict_heart_disease(p_df: T.PandasDataFrame[int, int, int, int,
                                        int, int, int, int, int, int, int, int, int]) -> T.PandasSeries[int]:
        # Set the column names to the features that were used for training.
        p_df.columns = [*FEATURE_COLS]
        
        # Perform prediction
        pred_array = p_predictor.predict(p_df)
        # Convert to series
        df_predicted = pd.Series(pred_array)
        return df_predicted

    # The list of packages that will be used by UDF
    udf_packages = p_dbt.config.get('packages')

    predict_heart_disease_udf = p_session.udf.register(
        predict_heart_disease
        ,name=f'predict_heart_disease'
        ,packages = udf_packages
    )
    return predict_heart_disease_udf

def download_models_and_libs_from_stage(p_session):
    p_session.file.get(f'@{DB_STAGE}/{model_file_path}/{model_file_packaged}', DOWNLOAD_DIR)

def load_model(p_session):
    model_fl_path = os.path.join(DOWNLOAD_DIR, model_file_packaged)
    predictor = joblib.load(model_fl_path)
    return predictor


# -------------------------------
def model(dbt, session):
    dbt.config(
        packages = ['snowflake-snowpark-python' ,'scipy','scikit-learn' ,'pandas' ,'numpy'],
        materialized = "table",
        tags = "predict"
    )
    session.use_database("dbt")
    session.use_schema("heart_disease")

    session._use_scoped_temp_objects = False
    download_models_and_libs_from_stage(session)
    predictor = load_model(session)
    predict_heart_disease_udf = register_udf_for_prediction(predictor, session ,dbt)

    predict_df = dbt.ref("stg_heart_disease_predict")
    predict_df = predict_df.select(*FEATURE_COLS)


    new_predictions_df = predict_df.withColumn("predicted_heart_disease_flag"
        ,predict_heart_disease_udf(*FEATURE_COLS)
    )

    return new_predictions_df