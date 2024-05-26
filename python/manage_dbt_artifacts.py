# manage_dbt_artifacts.py

import sys
import os
import snowflake.snowpark as snowpark
from helpers import connection_utils
import logging

def main():
    # Set up logging configuration
    logging.basicConfig(level=logging.INFO)

    # Check command-line arguments
    if len(sys.argv) != 2:
        logging.info("Usage: dbt_artifacts.py type")
        sys.exit(1)

    # Establish Snowflake session
    session = connection_utils.get_session()
    type = sys.argv[1]
    artifacts_stage = "@tech.dbt_artifacts"

    # Determine file path
    script_dir = os.path.dirname(os.path.abspath(__file__))
    dbt_project_dir = os.path.normpath(os.path.join(script_dir, '../../../transformation'))
    file_path = os.path.join(dbt_project_dir, 'target/manifest.json')

    # Perform action based on command-line argument
    if type == 'load':
        load_artifacts(session, artifacts_stage, file_path)
    elif type == 'download':
        unload_artifacts(session, artifacts_stage, dbt_project_dir)
    else:
        logging.error("Usage: dbt_artifacts.py type")
        raise ValueError("Incorrect value for type")

    session.close()

    return 'SUCCESS'


def load_artifacts(session: snowpark.Session, stage: str, file_path: str, ) -> None:
    try:
        _ = session.sql(f"create stage if not exists {stage[1:]} file_format = (type='JSON')").collect()
        logging.info(f"{stage} created successfully")

        _ = session.file.put(file_path, stage, auto_compress=False, overwrite=True)
        logging.info(f"{file_path} loaded successfully into {stage}")

    except snowpark.exceptions.SnowparkSQLException as err:
        logging.error(f"Unexpected {err=}, {type(err)=}")
        raise
    
    else:
        res = session.sql(f"ls {stage}").collect()
        logging.info(res)


def unload_artifacts(session: snowpark.Session, stage: str, target_directory: str) -> None:
    try:
        _ = session.file.get(stage, target_directory)
        logging.info(f"Files unloaded successfully into {target_directory}")

    except Exception as err:
        logging.error(f"Unexpected {err=}, {type(err)=}")
        raise
    
if __name__ == "__main__":
    main()