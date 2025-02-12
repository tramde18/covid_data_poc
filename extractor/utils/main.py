# main.py

import os

from mage_ai_poc.utils.api.github_client import GitHubAPIClient
from mage_ai_poc.utils.config.config_manager import ConfigManager
from mage_ai_poc.utils.db.mysql_client import MySQLClient

CONFIG_FILE = os.environ.get("DATA_LOADER_CONFIG_PATH")


def main():
    """Main function to orchestrate the workflow."""

    # Initialize configuration manager
    config_mgr = ConfigManager(CONFIG_FILE)

    # Initialize GitHub API client
    github_api_url = config_mgr.get_github_api_url()
    github_client = GitHubAPIClient(github_api_url)

    # Fetch the list of files from GitHub
    files = github_client.fetch_files_list()

    # Get database configuration and initialize the MySQL client
    db_config = config_mgr.get_db_config()
    staging_table = config_mgr.get_staging_table_name()
    data_loader = MySQLClient(db_config, staging_table)

    # Filter and process CSV files
    for file in files:
        if file["name"].endswith(".csv"):
            print(f"Processing file: {file['name']}")

            # Download CSV data using the streaming method
            df = github_client.download_csv(file["download_url"])

            # Check if DataFrame is not empty before loading
            if not df.empty:
                # Load the data into the MySQL database
                data_loader.load_data(df)
            else:
                print(f"Skipped empty file: {file['name']}")


if __name__ == "__main__":
    main()
