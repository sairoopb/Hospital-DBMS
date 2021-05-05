from django.contrib import admin
from django.apps import apps
from .models import User
from django.contrib.auth.admin import UserAdmin

# admin.site.unregister(User)
admin.site.register(User, UserAdmin)
models = apps.get_models()


for model in models:
    if "dbms_app.models" in str(model) and "dbms_app.models.User" not in str(model):
        print(type(type(model)),type(model))
        admin.site.register(model)
