from django.shortcuts import render
from .. import models
from django.db import connection

def pharma_bill_view(request,branch):
    try:
        if branch == "create" or branch == "index":
            
            cursor = connection.cursor()

            if request.method == "POST":
                
                flag = False
                for key, value in list(request.POST.items()):
                    if key == "presc_id":
                        presc_id = value
                        flag = False
                        break
                    
                    if key == "presc_id_bill":
                        presc_id = value
                        flag = True
                        break

                cursor.execute("SELECT * FROM Prescription_Report WHERE prescription_id = %s",[presc_id])
                result = cursor.fetchall()

                new_bill_id = None
                if flag:
                    args = [presc_id,new_bill_id]
                    cursor.callproc("evaluate_prescription",args)
                    cursor.execute("SELECT @_evaluate_prescription_1")
                    new_bill_id = cursor.fetchone()[0]

                cursor.close()

                if not result:
                    return render(request,"dbms_app/create_bill.html",{
                        "result": "Prescription with ID " + str(presc_id) + " not found.",
                        "presc_id": None
                    })

                else:

                    bill_result = None
                    
                    if flag: 
                        if new_bill_id > 0:
                            bill_result = "Bill generated with ID " + str(new_bill_id) 
                        else:
                            bill_result = "Bill was not generated."

                    rows = []
                    for row in result:
                        rows.append([row[1],row[2]])

                    headers = ['Prescription ID','Quantity','Medicine']

                    return render(request,"dbms_app/create_bill.html",{
                        "result": None,
                        "presc_id": presc_id,
                        "headers": headers[1:],
                        "rows": rows,
                        "flag": flag,
                        "bill_result" : bill_result,
                        "bill_id": new_bill_id
                    })
            
            else:
                return render(request,"dbms_app/create_bill.html")

        if branch == "show":
            
            cursor = connection.cursor()
            bill_id = None
            flag = False

            if request.method == "POST":
                for key, value in list(request.POST.items()):
                    if key == "bill_id_show":
                        bill_id = value
                        flag = False
                        break
                    
                    if key == "bill_id_create":
                        bill_id = value
                        flag = True
                        break
                
                cursor.execute("SELECT * FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                result = cursor.fetchall()  
                
                if result:

                    cursor.execute("SELECT DISTINCT total FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    total =  cursor.fetchone()[0]
                    
                    cursor.execute("SELECT DISTINCT subtotal FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    subtotal =  cursor.fetchone()[0]
                    
                    cursor.execute("SELECT DISTINCT taxes FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    taxes =  cursor.fetchone()[0]

                    cursor.execute("SELECT DISTINCT paid FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    paid =  cursor.fetchone()[0]
                    
                    if paid == 0:
                        paid = "Unpaid"
                    else:
                        paid = "paid"

                    cursor.execute("SELECT DISTINCT Tests, Test_Cost FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    tests =  cursor.fetchall()

                    cursor.execute("SELECT DISTINCT Procedures,Procedure_cost FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    procedures =  cursor.fetchall()

                    cursor.execute("SELECT DISTINCT drug, Medicine_Qt, Medicine_Unit_Cost FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    drug =  cursor.fetchall()

                    cursor.execute("SELECT DISTINCT patient_id FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    patient_id =  cursor.fetchone()[0]

                    cursor.execute("SELECT DISTINCT Patient_Name FROM Bill_Report WHERE bill_type = 1 and bill_number = %s",[bill_id])
                    patient_name =  cursor.fetchone()[0]

                cursor.close()
                
                if not result:
                    return render(request,"dbms_app/show_bill.html",{
                        "message": "No bill with ID " + str(bill_id),
                        "flag": flag
                    })
                
                else:
        
                    return render(request,"dbms_app/show_bill.html",{
                        "flag": flag,
                        "total" : total,
                        "subtotal" : subtotal,
                        "taxes": taxes,
                        "paid": paid,
                        "tests": tests,
                        "bill_id": bill_id,
                        "procedures": procedures,
                        "drugs": drug,
                        "patient_id": patient_id,
                        "patient_name":patient_name
                    })
            
            else:
                return render(request,"dbms_app/show_bill.html")

        return render(request,"dbms_app/create_bill.html")
    except:
        return render(request,"dbms_app/bill_error_page.html")
