from django.shortcuts import render
from .. import models

class Section:
    def __init__(self, section_name, details, image):
        self.section_name = section_name
        self.details = details
        self.image = image


sections = [Section("Appointments", "View and create appointments between a doctor and a patient.", "https://images.unsplash.com/photo-1576089172869-4f5f6f315620?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZG9jdG9ycyUyMHBhdGllbnQlMjBhcHBvaW50bWVudHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
            Section("Diagnoses", "Record diagnoses into the system and retrieve diagnosis reports.", "https://images.unsplash.com/photo-1576669801945-7a346954da5a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZG9jdG9ycyUyMHBhdGllbnQlMjBhcHBvaW50bWVudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
            Section("Patient Log", "Find a registered patient. Register new patients. Check-in and check-out patients.","https://images.unsplash.com/photo-1599045118108-bf9954418b76?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8aG9zcGl0YWwlMjByZWNlcHRpb258ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
            Section("Payments", "Retrieve or pay hospital bills", "https://images.unsplash.com/photo-1544377193-33dcf4d68fb5?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YWNjb3VudHN8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
            Section("Pharmacy", "Retrieve a prescription. Bill a prescription", "https://images.unsplash.com/photo-1576602976047-174e57a47881?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhhcm1hY3l8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
            Section("Prescriptions", "Create prescriptions","https://images.unsplash.com/photo-1577401132921-cb39bb0adcff?ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8cHJlc2NyaXB0aW9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
            Section("Treatments", "Create treatment template and add procedures to it", "https://images.unsplash.com/photo-1579684288361-5c1a2957a700?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8b3BlcmF0aW9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60")]

def home_view(request):
    return render(request,"dbms_app/home.html",
    {
        "sections": sections
    })
