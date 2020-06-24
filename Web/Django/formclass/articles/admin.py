from django.contrib import admin
from .models import Article, Comment

class ArticleAdmin(admin.ModelAdmin):
    list_display = ('pk', 'title', 'created_at', 'updated_at',)

class CommentAdmin(admin.ModelAdmin):
    list_display = ('pk', 'content',)

admin.site.register(Article, ArticleAdmin)
admin.site.register(Comment, CommentAdmin)

