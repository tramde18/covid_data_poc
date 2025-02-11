if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader

import subprocess

script_path = './mage_ai_poc/scripts/exec-data-loader.sh'

@data_loader
def exec_initial_load():
    try:
        result = subprocess.run([script_path], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Print the output from the script
        print("Script output:")
        print(result.stdout)
        
        # If there is any error output, print that as well
        if result.stderr:
            print("Script error output:")
            print(result.stderr)

    except subprocess.CalledProcessError as e:
        # Handle errors if the script fails
        print(f"Error executing script: {e}")
        print(f"Return code: {e.returncode}")
        print(f"Error output: {e.stderr}")
