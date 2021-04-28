from django.shortcuts import render
from .view_service import patient, appointment, treatment, diagnosis, prescription, pharma_bill, payments, Home

# Create your views here.


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
    return pharma.pharma_bill_view(request,branch)


def treatment_view(request,branch):
    return treatment.treatment_view(request,branch)


def prescription_view(request,branch):
    return prescription.prescription_view(request,branch)
