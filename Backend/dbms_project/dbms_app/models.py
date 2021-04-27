# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Aftercare(models.Model):
    treatment = models.OneToOneField('Treatment', models.DO_NOTHING, primary_key=True)
    room_no = models.ForeignKey('Room', models.DO_NOTHING, db_column='room_no')
    start_date = models.DateField()
    end_date = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Aftercare'
        unique_together = (('treatment', 'room_no', 'start_date'),)


class Appointment(models.Model):
    doctor = models.OneToOneField('Doctor', models.DO_NOTHING, primary_key=True)
    patient = models.ForeignKey('Patient', models.DO_NOTHING)
    date = models.DateField()
    start_time = models.TimeField()

    class Meta:
        managed = False
        db_table = 'Appointment'
        unique_together = (('doctor', 'patient', 'date', 'start_time'),)


class Bill(models.Model):
    bill_number = models.IntegerField(primary_key=True)
    bill_type = models.IntegerField(blank=True, null=True)
    total = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    taxes = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    paid = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Bill'


class BillDiag(models.Model):
    bill_number = models.ForeignKey(Bill, models.DO_NOTHING, db_column='bill_number', blank=True, null=True)
    diagnosis = models.OneToOneField('Diagnosis', models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Bill_Diag'


class Consists(models.Model):
    procedure = models.OneToOneField('Procedure', models.DO_NOTHING, primary_key=True)
    treatment = models.ForeignKey('Treatment', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Consists'
        unique_together = (('procedure', 'treatment'),)


class DiagPresc(models.Model):
    prescription = models.ForeignKey('Prescription', models.DO_NOTHING, blank=True, null=True)
    diagnosis = models.OneToOneField('Diagnosis', models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Diag_Presc'


class Diagnosis(models.Model):
    diagnosis_id = models.IntegerField(primary_key=True)
    results = models.CharField(max_length=150, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Diagnosis'


class Doctor(models.Model):
    doctor_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=30, blank=True, null=True)
    last_name = models.CharField(max_length=30, blank=True, null=True)
    contact_no = models.CharField(unique=True, max_length=15, blank=True, null=True)
    address = models.CharField(max_length=50, blank=True, null=True)
    salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    specialization = models.CharField(max_length=30, blank=True, null=True)
    role = models.CharField(max_length=30, blank=True, null=True)
    room_no = models.ForeignKey('Room', models.DO_NOTHING, db_column='room_no')

    class Meta:
        managed = False
        db_table = 'Doctor'


class DoneIn(models.Model):
    treatment = models.OneToOneField('Treatment', models.DO_NOTHING, primary_key=True)
    room_no = models.ForeignKey('Room', models.DO_NOTHING, db_column='room_no')

    class Meta:
        managed = False
        db_table = 'Done_In'


class Employee(models.Model):
    employee_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=30, blank=True, null=True)
    last_name = models.CharField(max_length=30, blank=True, null=True)
    contact_no = models.CharField(unique=True, max_length=15, blank=True, null=True)
    occupation = models.CharField(max_length=30, blank=True, null=True)
    address = models.CharField(max_length=50, blank=True, null=True)
    salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Employee'


class Implies(models.Model):
    diagnosis = models.OneToOneField(Diagnosis, models.DO_NOTHING, primary_key=True)
    treatment = models.ForeignKey('Treatment', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Implies'


class Includes(models.Model):
    medicine = models.OneToOneField('Medicine', models.DO_NOTHING, primary_key=True)
    prescription = models.ForeignKey('Prescription', models.DO_NOTHING)
    unit = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Includes'
        unique_together = (('medicine', 'prescription'),)


class Involves(models.Model):
    diagnosis = models.OneToOneField(Diagnosis, models.DO_NOTHING, primary_key=True)
    test = models.ForeignKey('Test', models.DO_NOTHING)
    results = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Involves'
        unique_together = (('diagnosis', 'test'),)


class MedicalBill(models.Model):
    prescription = models.OneToOneField('Prescription', models.DO_NOTHING, primary_key=True)
    bill_number = models.ForeignKey(Bill, models.DO_NOTHING, db_column='bill_number')

    class Meta:
        managed = False
        db_table = 'Medical_Bill'


class Medicine(models.Model):
    medicine_id = models.AutoField(primary_key=True)
    inventory_quantity = models.IntegerField(blank=True, null=True)
    name = models.CharField(max_length=30, blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Medicine'


class Nurse(models.Model):
    nurse_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=30, blank=True, null=True)
    last_name = models.CharField(max_length=30, blank=True, null=True)
    contact_no = models.CharField(unique=True, max_length=15, blank=True, null=True)
    address = models.CharField(max_length=100, blank=True, null=True)
    salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Nurse'


class Patient(models.Model):
    patient_id = models.IntegerField(primary_key=True)
    first_name = models.CharField(max_length=30, blank=True, null=True)
    last_name = models.CharField(max_length=30, blank=True, null=True)
    contact_no = models.CharField(unique=True, max_length=15, blank=True, null=True)
    address = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Patient'


class PatientLog(models.Model):
    patient = models.OneToOneField(Patient, models.DO_NOTHING, primary_key=True)
    checkin = models.DateTimeField()
    checkout = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Patient_Log'
        unique_together = (('patient', 'checkin'),)


class Pays(models.Model):
    patient_id = models.IntegerField()
    bill_number = models.OneToOneField(Bill, models.DO_NOTHING, db_column='bill_number', primary_key=True)

    class Meta:
        managed = False
        db_table = 'Pays'


class Performs(models.Model):
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    treatment = models.OneToOneField('Treatment', models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Performs'
        unique_together = (('treatment', 'doctor'),)


class Prescription(models.Model):
    prescription_id = models.IntegerField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'Prescription'


class Procedure(models.Model):
    procedure_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50, blank=True, null=True)
    cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Procedure'


class Recommends(models.Model):
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    diagnosis = models.OneToOneField(Diagnosis, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Recommends'


class Room(models.Model):
    room_no = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=30, blank=True, null=True)
    availability = models.TextField(blank=True, null=True)  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'Room'


class Serves(models.Model):
    treatment = models.OneToOneField('Treatment', models.DO_NOTHING, primary_key=True)
    nurse = models.ForeignKey(Nurse, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Serves'
        unique_together = (('treatment', 'nurse'),)


class Test(models.Model):
    test_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50, blank=True, null=True)
    cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Test'


class Treated(models.Model):
    patient = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)
    treatment = models.OneToOneField('Treatment', models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Treated'


class Treatment(models.Model):
    treatment_id = models.IntegerField(primary_key=True)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)
    details = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Treatment'


class TreatmentBill(models.Model):
    bill_number = models.ForeignKey(Bill, models.DO_NOTHING, db_column='bill_number', blank=True, null=True)
    treatment = models.OneToOneField(Treatment, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Treatment_Bill'


class TreatmentPresc(models.Model):
    treatment = models.OneToOneField(Treatment, models.DO_NOTHING, primary_key=True)
    prescription = models.ForeignKey(Prescription, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Treatment_Presc'


class Undergoes(models.Model):
    patient = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)
    diagnosis = models.OneToOneField(Diagnosis, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'Undergoes'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'
