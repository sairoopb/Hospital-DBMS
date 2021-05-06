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
    if branch == 'index' or branch == 'pay':
        if request.method == "POST":
            if 'bill_number' not in request.POST or request.POST['bill_number'] == "":
                with connection.cursor() as cursor:
                    if 'patient_id' in request.POST and request.POST['patient_id'] != "":
                        cursor.execute("SELECT * FROM Patient WHERE patient_id = %s", [request.POST['patient_id']])
                        if cursor.rowcount == 0:
                            return render(request, "dbms_app/payments.html",{"errorFlag" : True})
                        if 'isPaid' in request.POST :
                            cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report WHERE patient_id = %s AND paid = 0 ORDER BY bill_number asc", [request.POST['patient_id']])
                        else:
                            cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report WHERE patient_id = %s ORDER BY bill_number asc", [request.POST['patient_id']])
                    else:
                        if 'isPaid' in request.POST :
                            cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report WHERE paid = 0 ORDER BY bill_number asc")
                        else:
                            cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report ORDER BY bill_number asc")

                    columns = ["Bill Number", "Name", "Patient ID", "Bill Paid"]
                    return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor)})
            elif 'bill_number' in request.POST and request.POST['bill_number'] != "":
                with connection.cursor() as cursor:
                    cursor.execute("SELECT * FROM Bill WHERE bill_number = %s", [request.POST['bill_number']])
                    if cursor.rowcount == 0:
                        return render(request, "dbms_app/payment.html",{"errorFlag" : True})
                    cursor.callproc("mark_bill_paid", [request.POST['bill_number'], 0])
                    cursor.execute("SELECT @_mark_bill_paid_1")
                    if (cursor.fetchone()[0] == 0):
                        cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report ORDER BY bill_number asc")
                        columns = ["Bill Number", "Name", "Patient ID", "Bill Paid"]
                        return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor), "createFlag" : True})
                    cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report ORDER BY bill_number asc")
                    columns = ["Bill Number", "Name", "Patient ID", "Bill Paid"]
                    return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor), "errorFlag" : True})
            else:
                with connection.cursor() as cursor:
                    cursor.execute("SELECT * FROM Bill_Report ORDER BY bill_number asc")
                    columns = ["Bill Number", "Name", "Patient ID", "Bill Paid"]
                    return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor)})
        else:
            with connection.cursor() as cursor:
                cursor.execute("SELECT DISTINCT bill_number, Patient_name, patient_id, paid FROM Bill_Report ORDER BY bill_number asc")
                columns = ["Bill Number", "Name", "Patient ID", "Bill Paid"]
                return render(request,"dbms_app/payments.html", {"headers": columns, "data":dictfetchall(cursor)})
            
    else:
        if request.method == "POST":
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM Bill WHERE bill_number = %s", [request.POST['bill_id']])
                if cursor.rowcount == 0:
                    return render(request, "dbms_app/pay_bill.html",{"errorFlag" : False})
                
                cursor.execute("SELECT * FROM Bill WHERE bill_number = %s", [request.POST['bill_id']])
                bill_details = cursor.fetchall()

                cursor.execute("SELECT DISTINCT Tests, Test_Cost FROM Bill_Report WHERE bill_number = %s", [request.POST['bill_id']])
                test_details = cursor.fetchall()

                cursor.execute("SELECT DISTINCT Procedures,Procedure_Cost FROM Bill_Report WHERE bill_number = %s", [request.POST['bill_id']])
                proc_details = cursor.fetchall()

                cursor.execute("SELECT DISTINCT drug, Medicine_Qt, Medicine_Unit_Cost FROM Bill_Report WHERE bill_number = %s", [request.POST['bill_id']])
                medicine_details = cursor.fetchall()
                
                cursor.execute("SELECT DISTINCT patient_id, Patient_Name FROM Bill_Report WHERE bill_number = %s", [request.POST['bill_id']])
                patient_details = cursor.fetchall()

                return render(request,"dbms_app/pay_bill.html", {"flag":True, "bill" : bill_details, "test" : test_details, "proc" : proc_details, "medicine" : medicine_details, "patient" : patient_details})
        else:
            return render(request,"dbms_app/pay_bill.html", {"flag" : False})
