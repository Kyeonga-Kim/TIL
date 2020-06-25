from django.db import models
from imagekit.models import ProcessedImageField
from imagekit.processors import Thumbnail
from django.conf import settings

# Create your models here.
# 프로필
class Profile(models.Model):
    nickname = models.CharField(max_length=20, blank=True)
    image = ProcessedImageField(
        blank=True,
        processors=[
            Thumbnail(300,300),
        ],
        format='png',       
    )
user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE) #1대1
#CASCADE: user가 삭제되면 프로필 정보도 같이 삭제된다.