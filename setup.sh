#! /bin/bash

cd Backend/dbms_project
cat dbms_app/customuser.py > dbms_app/models.py
python3 manage.py inspectdb >> dbms_app/models.py

python3 manage.py makemigrations

python3 manage.py migrate
