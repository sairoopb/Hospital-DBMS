from django.shortcuts import render
from django.db import connection
from .. import models

def diagnosis_view(request, branch):
    try:
        if branch == "index":
            cursor = connection.cursor()
            pat_id = None
            doc_id = None
            test_ids = None
            test_res = None
            final_res = None
            result = None
            if request.method == 'POST':

                del_diag_id = request.POST.get('del_diag_id')
                if del_diag_id is not None:
                    cursor.execute("DELETE FROM Diagnosis WHERE diagnosis_id=%s", [del_diag_id])
                    return render(request, "dbms_app/create_diagnosis.html",
                                  {
                                      "results": [],
                                      "diag_ids": [],
                                      "del_status":["Deleted successfully"]
                                  })
                
                pat_id = request.POST.get('pat_id')
                doc_id = request.POST.get('doc_id')
                test_ids = request.POST.get('test_ids')
                test_res = request.POST.get('test_res')
                final_res = request.POST.get('final_res')

                args = [pat_id, doc_id, test_ids, test_res, final_res, 0]
                cursor.callproc('create_diagnosis', args)
                cursor.execute("SELECT @_create_diagnosis_5")
                new_diag_id = cursor.fetchone()[0]
                cursor.close()
                if(int(new_diag_id) > 0):
                    result = "Diagnosis Recorded. Diagnosis id = " + str(new_diag_id)

                if result is None:     
                    return render(request, "dbms_app/create_diagnosis.html",
                                  {
                                      "results": ["Diagnosis Recording Failed. Recheck all inputs."],
                                      "diag_ids": []
                                  })
                else:
                    return render(request, "dbms_app/create_diagnosis.html",
                                  {
                                      "results": [result],
                                      "diag_ids": [new_diag_id]
                                  })
            else:
                return render(request, "dbms_app/create_diagnosis.html",
                                  {
                                      "results": [],
                                      "diag_ids": []
                                  })


        elif branch == "retrieve":
            if request.method == 'POST':
                diag_id = request.POST.get('diag_id')
                cursor = connection.cursor()
                cursor.execute("SELECT * FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                if cursor.rowcount == 0:
                    return render(request, "dbms_app/retrieve_diagnosis.html",
                                  {
                                      "reports": [],
                                      "errors": ["Diagnosis ID not found"]
                                  })

                cursor.execute("SELECT DISTINCT room_no FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                room = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT doctor_id FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                doc_id = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT Doctor FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                doc_name = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT patient_id FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                pat_id = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT Patient FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                pat_name = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT test_id, `Test Name`, results FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                tests = cursor.fetchall()

                cursor.execute("SELECT DISTINCT prescription_id FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                presc_id = cursor.fetchone()[0]

                cursor.execute("SELECT DISTINCT `Medicine Name`, unit FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                meds = cursor.fetchall()


                cursor.execute("SELECT DISTINCT `Diagnosis Result` FROM Diagnosis_Report WHERE diagnosis_id=%s", [diag_id])
                final_result = cursor.fetchone()[0]

                return render(request, "dbms_app/retrieve_diagnosis.html",
                                  {
                                      "reports": [1],
                                      "errors":[],
                                      "diag_id":diag_id,
                                      "pat_id": pat_id,
                                      "pat_name": pat_name,
                                      "room": room,
                                      "doc_id": doc_id,
                                      "doc_name": doc_name,
                                      "tests": tests,
                                      "presc_id": presc_id,
                                      "meds": meds,
                                      "final_res": final_result
                                  })

            else:
                return render(request, "dbms_app/retrieve_diagnosis.html",
                                  {
                                      "reports": [],
                                      "errors":[]
                                  })

    except:
        return render(request, "dbms_app/diag_error_page.html")
