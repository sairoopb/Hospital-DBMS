# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    USER_TYPE_CHOICES = (
        (0, 'admin'),
        (1, 'accounts'),
        (2, 'consultant'),
        (3, 'doctor'),
        (4, 'frontdesk'),
        (5, 'pharmacist'),
        )
    user_type = models.PositiveSmallIntegerField(choices=USER_TYPE_CHOICES, default=0)
    class Meta:
        managed = True
        db_table = 'User'
