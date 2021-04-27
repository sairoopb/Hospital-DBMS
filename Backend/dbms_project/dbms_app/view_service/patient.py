from django.shortcuts import render
from dbms_app.models import Doctor,Room
from django.db import connection

cursor = connection.cursor()

table_headers = ["First Name", "Last Name"]


def patient_reg_view(request,branch):
    # return render(request,"dbms_app/patient_reg.html",
    # {
    #     "headers":table_headers,
    #     "doctors": models.Doctor.objects.all()
    # })
    # doctor = Doctors.objects.
    # print( Doctor.objects.all(), doctor.get_field_values)
    return render(request,"dbms_app/doctors.html",
    {
        "headers": Doctor._meta.fields,  # table headers
        "doctors": Doctor.objects.all()  # table entries
    })

# def load_findpatient(request):
#     if request.method == "POST" :
