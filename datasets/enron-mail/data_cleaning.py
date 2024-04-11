# This Python 3 environment comes with many helpful analytics libraries installed

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import seaborn as sns
import datetime
import matplotlib.pyplot as plt
import re
from math import  floor
# df = pd.read_csv('/Users/qtt/Downloads/python/enron-mail/处理好的/number_data.csv')
#
#
# def message_id(x):
#     message_id = x.split('\n')[0]
#     return message_id.split(':')[1]
#
#
# df['Message_ID'] = df['message'].apply(message_id)
#
#
# def date(x):
#     date = x.split('\n')[1]
#     date = date.split(':')[1].split(',')[1]
#     date = date[:-3]
#     return date
#
#
# df['Date'] = df['message'].apply(date)
#
#
# def year(x):
#     date = x.split('\n')[1]
#     return date.split(':')[1].split(',')[1].split(' ')[3]
#
#
# df['Year'] = df['message'].apply(year)
#
#
# def month(x):
#     date = x.split('\n')[1]
#     return date.split(':')[1].split(',')[1].split(' ')[2]
#
#
# df['Month'] = df['message'].apply(month)
#
#
# def day(x):
#     date = x.split('\n')[1]
#     return date.split(':')[1].split(',')[1].split(' ')[1]
#
#
# df['Day'] = df['message'].apply(day)
#
#
#
# def time_(x):
#     date = x.split('\n')[1]
#     time = date.split(' ')[5]
#     return time
#
#
# df['Time'] = df['message'].apply(time_)
#
#
# def sender(x):
#     sender = x.split('\n')[2]
#     return sender.split(':')[1]
#
#
# df['Sender_Email'] = df['message'].apply(sender)
#

# def receiver(x):
#     receiver = x.split('\n')[3]
#     return receiver.split(':')[1]


# df['Receiver_Email'] = df['message'].apply(receiver)
#
# df.to_csv('data.csv', columns=['Date', 'Year', 'Month', 'Day', 'Time', 'Sender_Email', 'Receiver_Email'],index=False)

data = pd.read_csv('processed /number_data.csv')

Datetime = data['Datetime']
Datetime = np.array(Datetime)
print(type(Datetime[1]))
print(Datetime[1])

Datetime = [datetime.datetime.strptime(x, " %d %b %Y %H:%M:%S") for x in Datetime]
min_datetime = min(Datetime)
print(min_datetime)
print(Datetime.index(min_datetime))
max_datetime = max(Datetime)
print(max_datetime)
print(Datetime.index(max_datetime))
# Date_ = data['Date']
# Month_ = data['Month']
# Time_ = data['Time']
#
# Date__ = np.array(Date_)
#
# Month__ = np.array(Month_)
# Time__ = np.array(Time_)
#
#
# Year__ = list(map(lambda x: x.split(' ')[3], Date__))
# Year_new = list(map(lambda x: int(x), Year__))
#
# mon =  ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug', 'Sep', 'Oct', 'Nov', 'Dec']
# for i in range(len(Month__)):
#     Month__[i] = str(mon.index(Month__[i])+1)
#
# Month_new = list(map(lambda x: int(x), Month__))
#
# Day__ = list(map(lambda x: x.split(' ')[1], Date__))
# Day_new = list(map(lambda x: int(x), Day__))
#
# hour = list(map(lambda x: x.split(':')[0], Time__))
#
# minute_ = list(map(lambda x: x.split(':')[1], Time__))
#
# hour_new = list(map(lambda x: int(x), hour))
# min_new = list(map(lambda x: int(x), minute_))


Send = data['Sender_Email']
Send = np.array(Send)
print(type(Send[1]))
Receive = data['Receiver_Email']
Receive = np.array(Receive)

layer = []
Sender_Email = []
Receiver_Email = []
start_time = datetime.datetime(1979, 12, 31, 16, 0, 0)
start_time_1 = datetime.datetime(1999, 6, 25, 2, 0, 0)
for i in np.arange(len(Datetime)):
    if Datetime[i] >= start_time_1:
        # layer.append((Datetime[i]-start_time).days)
        layer.append(floor((Datetime[i]-start_time).total_seconds()/3600))
        Sender_Email.append(Send[i])
        Receiver_Email.append(Receive[i])


daf = pd.DataFrame(layer, columns=['time_layer'])
dbf = pd.DataFrame(Sender_Email, columns=['Sender_Email'])
dcf = pd.DataFrame(Receiver_Email, columns=['Receiver_Email'])

df = pd.concat([dbf, dcf, daf], axis=1)
df.to_csv('number_data_h.csv', index=False)

# df = pd.DataFrame(layer, columns=['time_layer'])
# daf = pd.concat([data['Sender_Email'], data['Receiver_Email']], axis=1)
# dbf = pd.concat([daf, df], axis=1)
# dbf.to_csv('number_data_d.csv', index=False)

# dbf.to_csv('processed/number_data1.csv', index=False)











