export CURRENT_DIR=$PWD
export DBT_PROFILES_DIR="${CURRENT_DIR}/dbt/"

cd ..
cd dbt

dbt run --profiles-dir="${DBT_PROFILES_DIR}" --target $1 --models $2