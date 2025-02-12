import yaml


class ConfigManager:
    def __init__(self, config_file):
        """Initialize the configuration manager."""

        self.config_file = config_file

        # Load configuration
        self.load_config()

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
