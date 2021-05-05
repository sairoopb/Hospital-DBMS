from django.shortcuts import render
from .view_service import patient, appointment, treatment, diagnosis, prescription, pharma_bill, payments, Home
# from ...utilities.decorators import student_required
# Create your views here.
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse


# @login_required
def login_view(request):
    if request.method == "POST":

        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            return HttpResponseRedirect(reverse("home"))
        else:
            return render(request, "dbms_app/login.html", {
                "message": "Invalid username and/or password."
            })
    else:
        return render(request, "dbms_app/login.html")

def home_view(request):
    return Home.home_view(request)

def diag_view(request,branch):
    return diagnosis.diagnosis_view(request,branch)

def appoint_view(request,branch):
    return appointment.appointment_view(request,branch)


def patient_view(request,branch):
    return patient.patient_reg_view(request,branch)


def payments_view(request,branch):
    return payments.payments_view(request,branch)


def pharmacy_view(request,branch):
    return pharma_bill.pharma_bill_view(request,branch)


def treatment_view(request,branch):
    return treatment.treatment_view(request,branch)


def prescription_view(request,branch):
    return prescription.prescription_view(request,branch)
