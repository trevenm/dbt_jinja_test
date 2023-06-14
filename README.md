## Welcome to my project for experimentation and exploration!

I have created a couple of elements to get some practice using specific dbt functionality with Snowflake.

## Data Sources:
    Billboard Top 100 
        - Every week, Billboard releases "The Hot 100" chart of songs that were 
            trending on sales and airplay for that week. 
        - This dataset is a collection of all "The Hot 100" charts released since 
            its inception in 1958.
        - https://www.kaggle.com/datasets/dhruvildave/billboard-the-hot-100-songs

    Top 850 Guitar Tabs 
        - Description of a guitar tab instance from the list of the top rated guitar tabs.
        - https://www.kaggle.com/datasets/thomaskonstantin/top-850-guitar-tabs

    Heart Disease
        - This data set dates from 1988 and consists of four databases: Cleveland, Hungary, 
            Switzerland, and Long Beach V. It contains 76 attributes, including the predicted 
            attribute, but all published experiments refer to using a subset of 14 of them. 
        - The "target" field refers to the presence of heart disease in the patient. It is 
            integer valued 0 = no disease and 1 = disease.        
        - Portion of data set has been placed in a separate file to for use in prediction
        - https://www.kaggle.com/datasets/johnsmith88/heart-disease-dataset


## Macros
    mighty    
        - Simple macro to alter the band name "Van Halen" to "The Mighty Van Halen" 
        - Illustrates using a macro to facilitate a common transformation that can be 
            pointed to many data sources with a similar need
        - Implemented on the dim_artist model
## Tests
    assert_artist_not_van_halen
        -Singular test to validate that 'mighty' macro has been implemented
        
    assert_chart_movement_less_than_100
        -Singular test to validate that chart movement calculation is within a
            feasible range

    year_less_than_2022
        -Simple test created to demonstrate how to define a custom generic test

## SQL Models
    chart_movement
        - Identify which song had the largest movement in chart places from its lowest point 
            to its highest point in a period
        - Data is based on a "key_artist", which allows the date ranges to begin from the first 
            week the key_artist was on the charts
        - A loop is created to look at a rolling 12 week period for 100 weeks
        - Model is currently configured as Incremental for testing purposes

    dim_artist
        - Deliberately added a silly test for accepted values to illustrate the severity property 
            in the config

    tab_difficulty_by_artist__queried_set / tab_difficulty_by_artist
        - Demonstrating using Jinja to compile a repetitive case statement
        - Queried set version uses a macro to query unique column values as
            opposed to using a static list

## Python Models    
    train_test_target
        - Train simple ML model to predict "target" field in heart disease data set

    predict_target
        - Use trained model to predict "target" field in prediction data set
