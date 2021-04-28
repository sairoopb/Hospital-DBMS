from django.urls import path

from . import views
urlpatterns = [
    path("",views.home_view,name = "home"),
    path("Appointments/<str:branch>",views.appoint_view,name = "appointments"),
    path("Diagnoses/<str:branch>",views.diag_view,name = "diagnosis"),
    path("Patient Log/<str:branch>",views.patient_view,name = "patients_reg"),
    path("Payments/<str:branch>",views.payments_view,name = "payments"),
    path("Pharamcy/<str:branch>",views.pharmacy_view,name = "pharmacy"),
    path("Prescriptions/<str:branch>",views.prescription_view,name = "prescriptions"),
    path("Treatments/<str:branch>",views.treatment_view,name = "treatments"),
]
