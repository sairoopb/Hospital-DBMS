from django.shortcuts import render
from django.db import connection
from .. import models
from datetime import date

def treatment_view(request,branch):
    try:
        if branch == "index":
            cursor = connection.cursor()
            pat_id = None
            doc_ids = None
            room = None
            diag_id = None
            proc_ids = None
            st_date = None
            en_date = None
            details = None
            aft_room = None
            aft_nurse = None
            new_tr_id = None
            result = None

            if request.method == 'POST':
                pat_id = request.POST.get('pat_id')
                doc_ids = request.POST.get('doc_ids')
                room = request.POST.get('room')
                proc_ids = request.POST.get('proc_ids')
                st_date = request.POST.get('st_date')
                en_date = request.POST.get('en_date')
                details = request.POST.get('details')
                aft_room = request.POST.get('aftercare_room')
                if(not aft_room): aft_room = -1
                aft_nurse = request.POST.get('aftercare_nurse')
                if(not aft_nurse): aft_nurse = -1
                if(not diag_id):  diag_id = -1

                args = [pat_id, doc_ids, room, diag_id, proc_ids, st_date, en_date, details, aft_room, aft_nurse, new_tr_id]
                cursor.callproc('create_treatment', args)
                cursor.execute("SELECT @_create_treatment_10")
                new_tr_id = cursor.fetchone()[0]
                cursor.close()
                if(int(new_tr_id) > 0):
                    result = "Treatment Recorded. Treatment id = " + str(new_tr_id)

                if result is None:     
                    return render(request, "dbms_app/create_treatment.html",
                                  {
                                      "results": ["Treatment Recording Failed. Recheck all inputs."],
                                      "treat_ids": []
                                  })
                else:
                    return render(request, "dbms_app/create_treatment.html",
                                  {
                                      "results": [result],
                                      "treat_ids": [new_tr_id]
                                  })
            else:
                return render(request, "dbms_app/create_treatment.html",
                                  {
                                      "results": [],
                                      "treat_ids": []
                                  })


        elif branch == "retrieve":
            if request.method == 'POST':
                tr_id = request.POST.get('treat_id')
                cursor = connection.cursor()
                cursor.execute("SELECT * FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                if cursor.rowcount == 0:
                    return render(request, "dbms_app/retrieve_treatment.html",
                                  {
                                      "reports": [],
                                      "errors": ["Treatment ID not found"]
                                  })

                cursor.execute("SELECT DISTINCT treatmentRoom FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                room = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT doctor_id, Doctor FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                docs = cursor.fetchall()

                cursor.execute("SELECT DISTINCT patient_id FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                pat_id = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT Patient FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                pat_name = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT procedure_id, Procedures FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                procs = cursor.fetchall()

                cursor.execute("SELECT DISTINCT relatedDiagnosis FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                diag_id = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT prescription_id FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                presc_id = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT `Medicine Name`, unit FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                meds = cursor.fetchall()

                cursor.execute("SELECT DISTINCT start_date FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                st_date = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT end_date FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                en_date = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT aftercare_start FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                aft_stdate = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT aftercare_end FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                aft_endate = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT aftercareRoom FROM Treatment_Report WHERE treatment_id=%s", [tr_id])
                aft_room = cursor.fetchone()[0]

                return render(request, "dbms_app/retrieve_treatment.html",
                                  {
                                      "reports": [1],
                                      "errors":[],
                                      "tr_id": tr_id,
                                      "pat_id": pat_id,
                                      "pat_name": pat_name,
                                      "tr_room": room,
                                      "docs": docs,
                                      "diag_id": diag_id,
                                      "procs": procs,
                                      "presc_id": presc_id,
                                      "st_date": st_date,
                                      "en_date": en_date,
                                      "aft_stdate": aft_stdate,
                                      "aft_endate": aft_endate,
                                      "aft_room": aft_room,
                                      "meds": meds
                                  })

            else:
                return render(request, "dbms_app/retrieve_treatment.html",
                                  {
                                      "reports": [],
                                      "errors":[]
                                  })

        elif branch == "discharge":
            if request.method == 'POST':
                pat_id = request.POST.get('pat_id')
                curr_date = date.today()
                curr_date = curr_date.strftime("%Y-%m-%d")
                cursor = connection.cursor()
                cursor.callproc("discharge_patient", [pat_id, curr_date, 0])
                cursor.execute("SELECT @_discharge_patient_2")
                success_state = cursor.fetchone()[0]
                cursor.close()

                if(success_state == 0):
                    return render(request, "dbms_app/discharge_patient.html",
                                  {
                                      "message": ["Patient successfully discharged"]
                                  })
                else:
                    return render(request, "dbms_app/discharge_patient.html",
                                  {
                                      "message": ["Error. The patient either doesn't exist or isn't admitted in aftercare as of now"]
                                  })

            else:
                return render(request, "dbms_app/retrieve_treatment.html",
                                  {
                                      "message": []
                                  })

    except:
        return render(request, "dbms_app/treat_error_page.html")
