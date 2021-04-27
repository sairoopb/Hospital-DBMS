from django.shortcuts import render
from dbms_app.models import Doctor,Room,Patient
from django.db import connection

cursor = connection.cursor()



def patient_reg_view(request,branch):
    if(branch == "find_patient"):
        return find_patient(request)
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
            "message": f"Registered Successfully with id={new_id}, Check in find patient"
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
                contact_no = "NULL"

            cursor.execute(f"CALL patient_exists({pat_id},{contact_no},@temp)")
            cursor.execute("SELECT @temp")
            result = cursor.fetchone()
            # print(result)
            patient_check = result[0]
            if patient_check==0:
                return render(request,"dbms_app/patient_details.html",{
                "message":"The patient does not exist"
                })
            else:
                patient = Patient.objects.get(patient_id=pat_id)
                return render(request,"dbms_app/patient_details.html",{
                "patient":patient
                })
        except Exception as e:
            print(e)
            return render(request,"dbms_app/patient_details.html",{
            "message":"Some error occured, please try again!"
            })
