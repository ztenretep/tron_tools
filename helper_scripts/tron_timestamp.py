#!/usr/bin/python3

from datetime import datetime

TIMESTAMP = 1651756158000

timestamp = TIMESTAMP/1000
dt_obj = datetime.fromtimestamp(timestamp)

print(dt_obj)
