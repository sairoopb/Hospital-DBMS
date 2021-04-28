from django.contrib import admin
from django.apps import apps
# admin.site.unregister(User)

models = apps.get_models()

for model in models:
    if "dbms_app.models" in str(model):
        admin.site.register(model)
