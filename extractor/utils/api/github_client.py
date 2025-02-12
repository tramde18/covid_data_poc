# api/github_client.py

from io import StringIO

import pandas as pd
import requests


class GitHubAPIClient:
    """
    A client for interacting with the GitHub API to fetch files from a repository.
    """

    def __init__(self, api_url: str):
        """
        Initializes the GitHubAPIClient with the repository's API URL.

        Args:
            api_url (str): The base URL for the GitHub API repository contents.
        """
        self.api_url = api_url

    def fetch_files_list(self) -> list:
        """
        Fetches the list of files from the GitHub repository using the GitHub API.

        Returns:
            list: A list of dictionaries representing the files in the repository.
        """
        try:
            response = requests.get(self.api_url)
            response.raise_for_status()  # Raise an exception for 4xx/5xx errors

            # If the response is successful, return the list of files
            return response.json()

        except requests.exceptions.RequestException as e:
            print(f"Error fetching files from GitHub API: {e}")
            return []

    def download_csv(self, download_url: str):
        """
        Downloads and processes a CSV file from the GitHub repository using the provided download URL.
        This method streams the file in chunks to minimize memory usage.

        Args:
            download_url (str): The download URL for the CSV file.

        Returns:
            pd.DataFrame: A pandas DataFrame containing the CSV data.
        """
        try:
            # Make a streaming request to download the CSV data in chunks
            with requests.get(download_url, stream=True) as response:
                response.raise_for_status()  # Raise an exception for 4xx/5xx errors

                # Initialize a StringIO buffer to accumulate the streamed data
                buffer = StringIO()

                # Stream and write chunks of the CSV to the buffer
                for chunk in response.iter_lines(decode_unicode=True):
                    buffer.write(chunk + "\n")

                # Reset the buffer position to the start for reading
                buffer.seek(0)

                # Read the CSV data into a pandas DataFrame
                df = pd.read_csv(buffer)

                return df

        except requests.exceptions.RequestException as e:
            print(f"Error downloading CSV from GitHub: {e}")
            return pd.DataFrame()  # Return an empty DataFrame on error
