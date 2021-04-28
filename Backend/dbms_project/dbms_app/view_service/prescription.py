from django.shortcuts import render
from .. import models

def prescription_view(request,branch):
    return render(request,"dbms_app/doctors.html",
    {
        "doctors": models.Doctor.objects.all()
    })
