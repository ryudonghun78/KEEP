# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-12-07 10:29
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('my_app', '0003_employee'),
    ]

    operations = [
        migrations.CreateModel(
            name='DEPARTMENT',
            fields=[
                ('dname', models.CharField(max_length=20)),
                ('dnumber', models.CharField(max_length=1, primary_key=True, serialize=False)),
                ('mgr_ssn', models.CharField(max_length=10)),
                ('mgr_start_date', models.DateField()),
            ],
        ),
    ]
