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
    if request.method == "GET":
        with connection.cursor() as cursor:
            if 'patient_id' not in request.GET:
                if 'doctor_id' not in request.GET or request.GET['doctor_id'] == "":
                    cursor.execute("SELECT * FROM Appointment_Schedule ORDER BY doctor_id asc, `date` asc, start_time asc")
                else:
                    cursor.execute("SELECT * FROM Appointment_Schedule where doctor_id = %s ORDER BY doctor_id asc, `date` asc, start_time asc", [request.GET['doctor_id']])
                columns = [col[0] for col in cursor.description]
                return render(request,"dbms_app/appointment.html", {"headers": columns, "data":dictfetchall(cursor)})
            else:
                cursor.callproc("create_appointment", [request.GET['d_id'], request.GET['patient_id'], request.GET['bookDate'], 0])
                cursor.execute("SELECT @_create_appointment_3")
                if (cursor.fetchone()[0] == 1):
                    cursor.execute("SELECT * FROM Appointment_Schedule ORDER BY doctor_id asc, `date` asc, start_time asc")
                    columns = [col[0] for col in cursor.description]
                    return render(request,"dbms_app/appointment.html", {"headers": columns, "data":dictfetchall(cursor), "createFlag" : True})
                cursor.execute("SELECT * FROM Appointment_Schedule ORDER BY doctor_id asc, `date` asc, start_time asc")
                columns = [col[0] for col in cursor.description]
                return render(request,"dbms_app/appointment.html", {"headers": columns, "data":dictfetchall(cursor), "errorFlag" : True})
                
