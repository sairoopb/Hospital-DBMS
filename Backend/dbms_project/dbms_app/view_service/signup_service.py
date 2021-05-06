from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.urls import reverse
from .. import models

def signup_view(request):

    if request.method == "GET":

        return render(request,"dbms_app/signup.html")
    else:
        username = request.POST["username"]
        password = request.POST["password"]
        u_type = request.POST["type"]
        user = models.User.objects.create_user(username,None, password,user_type = u_type)
        user.save()

        return HttpResponseRedirect(reverse("home"))
