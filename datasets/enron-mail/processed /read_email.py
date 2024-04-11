import os
import pandas as pd
import numpy as np
import pickle


def get_files(dir_):  # 获取所有文件名
    for filepath, dirnames, filenames in os.walk(dir_):
        for filename in filenames:
            whole_path = os.path.join(filepath, filename)
            with open(file=whole_path, mode='r') as f:
                print(f.read().splitlines()[3])


# def get_sender():
#     dir_ = "D:\Astudy\qtt\enron_mail_20150507\maildir"
#     all_addresses = []
#     for name in sorted(os.listdir(dir_)):
#         if os.path.exists(os.path.join(dir_, name, 'sent')):
#             for index in sorted(os.listdir(os.path.join(dir_, name, 'sent'))):
#                 whole_path = os.path.join(dir_, name, 'sent', index)
#                 with open(file=whole_path, mode='r') as f:
#                     email_address = f.read().splitlines()[2].split(' ')[1]
#                     if email_address not in all_addresses:
#                         all_addresses.append(email_address)
#                         print(name, email_address)
#         if os.path.exists(os.path.join(dir_, name, 'sent_items')):
#             for index in os.listdir(os.path.join(dir_, name, 'sent_items')):
#                 whole_path = os.path.join(dir_, name, 'sent_items', index)
#                 with open(file=whole_path, mode='r') as f:
#                     email_address = f.read().splitlines()[2].split(' ')[1]
#                     if email_address not in all_addresses:
#                         all_addresses.append(email_address)
#                         print(name, email_address)
#         if os.path.exists(os.path.join(dir_, name, '_sent_mail')):
#             for index in os.listdir(os.path.join(dir_, name, '_sent_mail')):
#                 whole_path = os.path.join(dir_, name, '_sent_mail', index)
#                 with open(file=whole_path, mode='r') as f:
#                     email_address = f.read().splitlines()[2].split(' ')[1]
#                     if email_address not in all_addresses:
#                         all_addresses.append(email_address)
#                         print(name, email_address)


def generate_new_pkl():
    original = "D:/Astudy/qtt/enron_mail_20150507/ud120-projects/final_project/final_project_dataset.pkl"
    destination = "D:/Astudy/qtt/enron_mail_20150507/ud120-projects/final_project/final_project_dataset_used.pkl"
    outsize = 0
    with open(original, 'rb') as infile:
        content = infile.read()
    with open(destination, 'wb') as output:
        for line in content.splitlines():
            outsize += len(line) + 1
            output.write(line + str.encode('\n'))


def read_pkl():
    enron_data = pickle.load(open("D:/Astudy/qtt/enron_mail_20150507/ud120-projects/final_project"
                                  "/final_project_dataset_used.pkl", "rb"))
    emails_all = []
    for name in enron_data.keys():
        email_address = enron_data[name]['email_address']
        if email_address != 'NaN':
            emails_all.append(email_address)
    data_emails = pd.read_csv('./data_emails.csv')
    columns = data_emails.columns
    data_numpy = np.array(data_emails)
    new_data = []
    for i in range(data_numpy.shape[0]):
        Date, Month, Time, Sender_Email, Receiver_Email = data_numpy[i]
        Sender_Email = Sender_Email.replace(' ', '')
        Receiver_Email = Receiver_Email.replace(' ', '')
        if Sender_Email not in emails_all:
            continue
        if ',' in Receiver_Email:
            receivers  = Receiver_Email.split(',')
            for receiver in receivers:
                if receiver not in emails_all:
                    continue
                new_data.append(np.array([Date, Month, Time, Sender_Email, receiver], dtype=np.object_))
        else:
            if Receiver_Email not in emails_all:
                continue
            new_data.append(np.array([Date, Month, Time, Sender_Email, Receiver_Email], dtype=np.object_))
    new_data = np.stack(new_data, axis=0)
    dataframe = pd.DataFrame(data=new_data, columns=columns)
    dataframe.to_csv('selected.csv', index=False)


if __name__ == '__main__':
    read_pkl()
