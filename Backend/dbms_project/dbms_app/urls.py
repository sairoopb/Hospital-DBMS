from django.urls import path

from . import views
urlpatterns = [
    path("",views.home_view,name = "home"),
    path("appointments/<str:branch>",views.appoint_view,name = "appointments"),
    path("diagnosis/<str:branch>",views.diag_view,name = "diagnosis"),
    path("patients_reg/<str:branch>",views.patient_view,name = "patients_reg"),
    path("payments/<str:branch>",views.payments_view,name = "payments"),
    path("pharamcy/<str:branch>",views.pharmacy_view,name = "pharmacy"),
    path("prescriptions/<str:branch>",views.prescription_view,name = "prescriptions"),
    path("treatments/<str:branch>",views.treatment_view,name = "treatments"),
]
