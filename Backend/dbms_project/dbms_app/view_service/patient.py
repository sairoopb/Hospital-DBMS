from django.shortcuts import render
from dbms_app.models import Doctor,Room,Patient
from django.db import connection
import datetime

cursor = connection.cursor()



def patient_reg_view(request,branch):
    if(branch == "find_patient"):
        return find_patient(request)
    elif( branch == "patient_log"):
        return patient_log(request)
    else:
        return patient_registration(request)

def patient_registration(request):
    if request.method == "GET":
        return render(request,"dbms_app/patient_reg.html")
    else:
        try:
            first_name = request.POST["first_name"]
            last_name = request.POST["last_name"]
            contact_no = request.POST["contact_no"]
            address = request.POST["address"]
            cursor.execute(f'''CALL new_registration("{first_name}","{last_name}","{contact_no}","{address}",@new_id)''')
            cursor.execute("SELECT @new_id")
            new_id = (cursor.fetchone())[0]
            return render(request,"dbms_app/patient_reg.html",{
            "message": f"Registered Successfully",
            "result":f"Registered Successfully with id={new_id}, Click below to view details",
            "pat_ids":[new_id]
            })
        except Exception as e:
            print(e)
            return render(request,"dbms_app/patient_reg.html",{
            "message": "Some error occured, please try again!"
            })
def find_patient(request):
    if request.method == "GET":
        return render(request,"dbms_app/find_patient.html")
    else:
        try:
            pat_id = request.POST["patient_id"]
            contact_no = request.POST["contact_no"]
            if contact_no == "":
                contact_no = None
            if pat_id == "":
                pat_id = None
            print(contact_no, pat_id)
            args = [pat_id,contact_no,0,0]
            cursor.callproc("patient_exists",args)
            cursor.execute("SELECT @_patient_exists_2")
            patient_check =cursor.fetchone()[0]
            cursor.execute("SELECT @_patient_exists_3")
            pat_id = cursor.fetchone()[0]
            if int(patient_check)==0:
                return render(request,"dbms_app/patient_details.html",{
                "message":"The patient does not exist"
                })
            else:
                # print("check")
                patient = Patient.objects.get(patient_id = pat_id)
                return render(request,"dbms_app/patient_details.html",{
                "patient":patient
                })
        except Exception as e:
            print(e)
            return render(request,"dbms_app/patient_details.html",{
            "message":"Some error occured, please try again!"
            })

def patient_log(request):
    if request.method == "GET":
        return render(request,"dbms_app/patient_log.html")
    else:
        try:
            year = int(request.POST["year"])
            month = int(request.POST["month"])
            date = int(request.POST["date"])
            hr = int(request.POST["hour"])
            mi = int(request.POST["minute"])
            s = int(request.POST["second"])
            chckin = int(request.POST["chckin"])
            patient_id = int(request.POST["patient_id"])
            date_val = datetime.datetime(year,month,date,hr,mi,s,0)
            print("check: ",patient_id,str(date_val),chckin)
            args = [patient_id, date_val,chckin,0]
            cursor.callproc("checkin_out", args)
            cursor.execute("SELECT @_checkin_out_3")
            result = cursor.fetchone()[0]
            if result == 1:
                return render(request,"dbms_app/patient_log.html", {
                    "message":"Successfully logged, Check Reports for confirmation"
                })
            else:
                return render(request,"dbms_app/patient_log.html", {
                    "message":"Error, Please check the details"
                })
        except Exception as e:
            return render(request,"dbms_app/patient_log.html", {
                "message":str(e)
            })
