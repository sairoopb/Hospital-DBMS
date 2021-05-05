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
