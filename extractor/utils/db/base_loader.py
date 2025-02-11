# db/base_loader.py

from abc import ABC, abstractmethod


class DataLoaderBase(ABC):
    """
    Abstract base class for a data loader. Defines the interface for loading data into a database.
    """

    def __init__(self, db_config: dict, staging_table: str):
        """
        Initializes the data loader with database configuration and staging table name.

        Args:
            db_config (dict): Database connection configuration.
            staging_table (str): Name of the table where data will be inserted.
        """
        self.db_config = db_config
        self.staging_table = staging_table

    @abstractmethod
    def load_data(self, csv_data: str):
        """
        Loads the provided CSV data into the database. Must be implemented by subclasses.

        Args:
            csv_data (str): The CSV content as a string.
        """
        pass
