
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import seaborn as sns
import datetime
import matplotlib.pyplot as plt
import re
from math import  floor

Month_example = ['May' , 'May' , 'Oct' , 'Oct' ,'Aug', 'Aug', 'Aug', 'Jul' , 'Oct' , 'Oct']

mon = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
for i in range(len(Month_example)):
    Month_example[i] = str(mon.index(Month_example[i])+1)
print(Month_example)

# Month_example_new = list(map(lambda x: int(x), Month_example))
# # print(Month_example_new)
#
# Day_example = [1, 1, 2, 2, 3, 3, 3, 4, 5, 5]
# Year_example = [2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010]
# Time_example = ['16:39:00', '13:51:00', '03:00:00', '06:13:00', '05:07:00', '04:17:00', '07:44:00', '06:59:00',
#                 '02:26:00', '06:44:00']
# hour = list(map(lambda x: x.split(':')[0],Time_example))
# min = list(map(lambda x: x.split(':')[1],Time_example))
#
# hour_new = list(map(lambda x: int(x), hour))
# min_new = list(map(lambda x: int(x), min))
#
# a = datetime.date(Year_example[0], Month_example_new[0], Day_example[0])
# b = datetime.time(hour_new[1], min_new[1])
# start = datetime.datetime(2010, 5, 1, 0, 0)
# print(b.minute)
#
# c = datetime.datetime.combine(a,b)
# d = c.__sub__(start)
# print(floor(d.seconds/3600))

