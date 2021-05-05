from django.shortcuts import render
from .view_service import patient, appointment, treatment, diagnosis, prescription, pharma_bill, payments, Home, login_service, signup_service
from .Utilities.decorators import role_required
# Create your views here.
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse


# @login_required
def login_view(request):

    return login_service.login_view(request)

def home_view(request):
    return Home.home_view(request)

@role_required([0,3])
def diag_view(request,branch):
    return diagnosis.diagnosis_view(request,branch)

@role_required([0,2,3])
def appoint_view(request,branch):
    return appointment.appointment_view(request,branch)

@role_required([0,4])
def patient_view(request,branch):
    return patient.patient_reg_view(request,branch)

@role_required([0,1])
def payments_view(request,branch):
    return payments.payments_view(request,branch)

@role_required([0,5])
def pharmacy_view(request,branch):
    return pharma_bill.pharma_bill_view(request,branch)

@role_required([0,3])
def treatment_view(request,branch):
    return treatment.treatment_view(request,branch)

@role_required([0,3])
def prescription_view(request,branch):
    return prescription.prescription_view(request,branch)

@login_required
@role_required([0])
def signup_view(request):
    return signup_service.signup_view(request)
