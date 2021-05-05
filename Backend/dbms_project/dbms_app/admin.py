from django.contrib import admin
from django.apps import apps
from .models import User
from django.contrib.auth.admin import UserAdmin


models = apps.get_models()


for model in models:
    if "dbms_app.models" in str(model):
        admin.site.register(model)
