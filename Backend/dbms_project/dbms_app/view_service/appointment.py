from django.shortcuts import render
from .. import models
from django.db import connection
from django.http import HttpResponse

def dictfetchall(cursor):
    "Return all rows from a cursor as a dict"
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]
def appointment_view(request,branch):
    if branch == "show" or branch == "index":
        if request.method == "POST":
            with connection.cursor() as cursor:
                if 'doctor_id' in request.POST and request.POST['doctor_id'] != "":
                    cursor.execute("SELECT * FROM Appointment_Schedule where doctor_id = %s ORDER BY doctor_id asc, `date` asc, start_time asc", [request.POST['doctor_id']])
                elif ('doctor_id' not in request.POST or request.POST['doctor_id'] == "") and ('specialization' in request.POST) and request.POST['specialization'] != "":
                    cursor.execute("SELECT * FROM Appointment_Schedule WHERE specialization = %s ORDER BY doctor_id asc, `date` asc, start_time asc", [request.POST['specialization']])
                else :
                    cursor.execute("SELECT * FROM Appointment_Schedule ORDER BY doctor_id asc, `date` asc, start_time asc")
                columns = [col[0] for col in cursor.description]
                return render(request,"dbms_app/appointment.html", {"headers": columns, "data":dictfetchall(cursor)})
        else:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM Appointment_Schedule ORDER BY doctor_id asc, `date` asc, start_time asc")
                columns = [col[0] for col in cursor.description]
                return render(request,"dbms_app/appointment.html", {"headers": columns, "data":dictfetchall(cursor)})
    elif branch == "create":
        if request.method == "POST":
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM Doctor WHERE doctor_id = %s", [request.POST['d_id']])
                if cursor.rowcount == 0:
                    return render(request, "dbms_app/create_appointment.html",{"error" : True})
                cursor.execute("SELECT * FROM Patient WHERE patient_id = %s", [request.POST['patient_id']])
                if cursor.rowcount == 0:
                    return render(request, "dbms_app/payments.html",{"error" : True})
                cursor.callproc("create_appointment", [request.POST['d_id'], request.POST['patient_id'], request.POST['bookDate'], 0])
                cursor.execute("SELECT @_create_appointment_3")
                if (cursor.fetchone()[0] == 1):
                    return render(request,"dbms_app/create_appointment.html", {"createFlag" : True})
                return render(request,"dbms_app/create_appointment.html", {"errorFlag" : True})
        else:
            return render(request, "dbms_app/create_appointment.html")