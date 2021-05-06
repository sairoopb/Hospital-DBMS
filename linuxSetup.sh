#! /bin/bash
cd SQL
sudo mysql < hospital.sql
sudo mysql < insertData.sql
sudo mysql < views.sql
sudo mysql hospital < functions.sql
sudo mysql hospital < triggers.sql
cd ..

cd Backend/dbms_project
cat dbms_app/customuser.py > dbms_app/models.py
python3 manage.py inspectdb >> dbms_app/models.py

python3 manage.py makemigrations

python3 manage.py migrate

python3 manage.py createsuperuser