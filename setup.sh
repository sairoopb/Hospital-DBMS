#! /bin/bash
sudo mysql < ./SQL/hospital.sql
sudo mysql < ./SQL/insertData.sql
sudo mysql < ./SQL/views.sql
sudo mysql < ./SQL/functions.sql
sudo mysql < ./SQL/triggers.sql

cd Backend/dbms_project
cat dbms_app/customuser.py > dbms_app/models.py
python3 manage.py inspectdb >> dbms_app/models.py

python3 manage.py makemigrations

python3 manage.py migrate
echo "from dbms_app.models import User; User.objects.create_superuser('dbms_admin', '', 'password')" | python3 manage.py shell
echo "from dbms_app.models import User; User.objects.create_superuser('accounts', '', 'accounts_pwd',user_type=1)" | python3 manage.py shell
echo "from dbms_app.models import User; User.objects.create_superuser('consultant', '', 'consultant_pwd', user_type=2)" | python3 manage.py shell
echo "from dbms_app.models import User; User.objects.create_superuser('doctor', '', 'doctor_pwd', user_type=3)" | python3 manage.py shell
echo "from dbms_app.models import User; User.objects.create_superuser('frontdesk', '', 'frontdesk_pwd', user_type=4)" | python3 manage.py shell
echo "from dbms_app.models import User; User.objects.create_superuser('pharmacist', '', 'pharmacist_pwd', user_type=5)" | python3 manage.py shell

python3 manage.py runserver
