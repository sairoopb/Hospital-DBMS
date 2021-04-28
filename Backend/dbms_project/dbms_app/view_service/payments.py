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

def payments_view(request,branch):
    if request.method == "GET":
        with connection.cursor() as cursor:
            if 'bill_number' not in request.GET:
                if 'patient_id' not in request.GET or request.GET['patient_id'] == "":
                    cursor.execute("SELECT * FROM Bill_Report ORDER BY bill_number asc")
                else:
                    cursor.execute("SELECT * FROM Bill_Report WHERE patient_id = %s ORDER BY bill_number asc", [request.GET['patient_id']])
                columns = [col[0] for col in cursor.description]
                return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor)})
            else:
                cursor.callproc("mark_bill_paid", [request.GET['bill_number'], 0])
                cursor.execute("SELECT @_mark_bill_paid_1")
                if (cursor.fetchone()[0] == 0):
                    cursor.execute("SELECT * FROM Bill_Report ORDER BY bill_number asc")
                    columns = [col[0] for col in cursor.description]
                    return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor), "createFlag" : True})
                cursor.execute("SELECT * FROM Bill_Report ORDER BY bill_number asc")
                columns = [col[0] for col in cursor.description]
                return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor), "errorFlag" : True})
                