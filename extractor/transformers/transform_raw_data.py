if "transformer" not in globals():
    from mage_ai.data_preparation.decorators import transformer

import subprocess

script_path = "./mage_ai_poc/scripts/deploy-dbt.sh"


def exec_dbt_model(db, model):
    try:
        result = subprocess.run(
            [script_path, db, model],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

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


@transformer
def transform_raw_data(*args, **kwargs):
    exec_dbt_model("core", "core.*")
    exec_dbt_model("core_extensions", "core_extensions.*")
