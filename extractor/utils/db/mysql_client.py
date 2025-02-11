# db/mysql_loader.py

import pandas as pd
from sqlalchemy import create_engine
from io import StringIO
from .base_loader import DataLoaderBase
from urllib.parse import quote


class MySQLClient(DataLoaderBase):
    """
    A MySQL-specific implementation of the DataLoaderBase class, responsible for loading CSV data into MySQL.
    """

    def __init__(self, db_config: dict, staging_table: str):
        """
        Initializes the MySQLDataLoader with database configuration and staging table name.

        Args:
            db_config (dict): MySQL connection configuration.
            staging_table (str): The name of the table where data will be inserted.
        """
        super().__init__(db_config, staging_table)

        # URL-encode each parameter in db_config
        user = quote(db_config["user"])
        password = quote(db_config["password"])
        host = quote(db_config["host"])
        default_db = quote(db_config["default_db"])

        # Create MySQL connection engine using the encoded config
        self.engine = create_engine(
            f"mysql+mysqlconnector://{user}:{password}@{host}/{default_db}"
        )

    def load_data(self, pandas_df: pd.DataFrame):
        """
        Loads CSV data into the specified MySQL staging table.

        Args:
            csv_data (str): The CSV content as a string.
        """
        if pandas_df.empty:
            print("Error: The DataFrame is empty.")
            return

        try:
            # Insert the DataFrame into the MySQL table
            pandas_df.to_sql(
                self.staging_table, con=self.engine, if_exists="append", index=False
            )

            print(f"Successfully loaded data into {self.staging_table}.")

        except Exception as e:
            print(f"Error loading data into MySQL: {e}")
            raise
