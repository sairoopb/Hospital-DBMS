from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.urls import reverse
from django.shortcuts import redirect

def login_view(request):
    if request.method == "POST":

        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect(request.GET.get('next'))#HttpResponseRedirect(reverse("home"))
        else:
            return render(request, "dbms_app/login.html", {
                "message": "Invalid username and/or password."
            })
    else:
        return render(request, "dbms_app/login.html")
