#!/bin/bash
mysql < /home/stepan/Desktop/example_database_creation.sql
mysqldump example > /home/stepan/Desktop/example_dump.sql
mysql -e 'CREATE DATABASE sample'
mysql --database sample < /home/stepan/Desktop/example_dump.sql
mysqldump  -w '1 limit 100' mysql help_keyword > help_keyword_dump.sql
