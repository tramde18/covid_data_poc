#!/bin/bash

docker-compose up -d

until docker exec mysql-container mysql -h 127.0.0.1 -P 3306 -u root -padmin123 -e "SELECT 1" &>/dev/null; do
  echo "Waiting for MySQL to be ready..."
  sleep 3
done

echo "MySQL is ready! Now executing SQL commands."

docker exec -i mysql-container mysql -h 127.0.0.1 -P 3306 -u root -padmin123 <<EOF
CREATE DATABASE IF NOT EXISTS raw;
SET GLOBAL cte_max_recursion_depth=10000;
EOF

echo "MySQL setup completed."
exit 0
