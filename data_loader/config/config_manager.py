import os
import yaml


class ConfigManager:
    def __init__(self, config_file):
        """Initialize the configuration manager."""

        # Dynamically resolve the absolute path to config.yml
        self.config_file = self.get_config_file_path(config_file)

        # Load configuration
        self.load_config()

    def get_config_file_path(self, config_file):
        """Get the absolute path to the configuration file."""
        # If the config file path is already absolute, return it
        if os.path.isabs(config_file):
            return config_file

        # If the path is relative, construct the absolute path based on where the script is located
        script_dir = os.path.dirname(
            os.path.abspath(__file__)
        )  # Get the directory of the current script
        return os.path.join(
            script_dir, "..", "..", "config", config_file
        )  # Go up two directories and look in 'config'

    def load_config(self):
        """Load configuration from the YAML file."""
        try:
            with open(self.config_file, "r") as file:
                self.config = yaml.safe_load(file)
            print(f"Configuration loaded from {self.config_file}")
        except FileNotFoundError as e:
            print(f"Error: Configuration file not found: {self.config_file}")
            raise e
        except Exception as e:
            print(f"Error loading configuration: {e}")
            raise e

    def get_github_api_url(self):
        """Get the GitHub API URL from the configuration."""
        return self.config["github_api"]["url"]

    def get_db_config(self):
        """Get the database configuration."""
        return self.config["database"]

    def get_staging_table_name(self):
        """Get the name of the staging table."""
        return self.config["staging_table"]
