### Project Setup Guide

#### Prerequisites
Ensure you have the following installed on your Windows machine:
1. Basic Understanding of the ff.
    - **Medallion Architecture**
    - **Python**
    - **DBT**
    - **Docker**
    - **MySQL**
2. **Gitbash**: [Download Gitbash](https://git-scm.com/downloads)
3. **Docker Desktop**: [Install Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
4. **VSCode (optional)**: Use any IDE for database management. VSCode with MySQL extensions is recommended.

---

#### MySQL Setup with Docker  
Follow these steps to set up and configure MySQL in Docker:

1. Pull the latest MySQL Docker image:
    ```bash
    docker pull mysql:latest
    ```
2. Run a MySQL container:
    ```bash
    docker run -d -p 3306:3306 --name mysql-container -e MYSQL_ROOT_PASSWORD=p@ssw0rd mysql:latest
    ```
3. Access the MySQL container’s terminal:
    ```bash
    docker exec -it mysql-container bash
    ```
4. Log into MySQL as the root user:
    ```bash
    mysql -u root -p
    ```
5. Create the required database:
    ```bash
    CREATE DATABASE raw;
    ```
6. Set the max recursion depth to avoid CTE issues:
    ```bash
    SET GLOBAL cte_max_recursion_depth=10000;
    ```

---

#### MySQL UI Access (Optional)
You can access MySQL using a UI tool like DBeaver or any other IDE.

- If you're using VSCode, install the MySQL extension from the VSCode Extensions Marketplace for easier database management.

---

#### Setting Up Python Environment
Follow these steps to set up your Python virtual environment and ensure you’re ready to run dbt commands:

1. Open Gitbash Terminal and navigate to your project directory.
2. Create a Python virtual environment:
    ```bash
    python -m venv venv
    ```
3. Activate the virtual environment:
    ```bash
    source venv/Scripts/activate
    ```

---

#### Verify DBT Connection to MySQL

1. Navigate to the local development directory:
    ```bash
    cd local-dev
    ```
2. Test the DBT connection:
    ```bash
    dbt debug --profiles-dir="${PWD}/dbt/" --project-dir='../dbt'
    ```

--- 

#### Running DBT Models

To run the DBT models, ensure your profiles.yml and dbt_project.yml are correctly configured.
To deploy a DBT model, use the following command:
```bash
./deploy-dbt-local.sh <database or schema> <dbt-model>
```

---

#### Additional Notes
- This setup guide is designed for a Windows environment using Docker and Gitbash.
- Make sure to customize configurations as per your project requirements.