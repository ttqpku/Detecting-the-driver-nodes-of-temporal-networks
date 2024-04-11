import pandas as pd
import numpy as np


def map_name_to_number(data_path):
    email_info = pd.read_csv(data_path)
    columns = email_info.columns
    emails = np.array(email_info)
    number_emails = []
    count = 1
    dictionary = dict()
    for i in range(emails.shape[0]):
        Date, Month, Time, Sender_Email, Receiver_Email = emails[i]
        Datetime = Date+" "+Time
        if Sender_Email not in dictionary.keys():
            dictionary[Sender_Email] = count
            count += 1
        if Receiver_Email not in dictionary.keys():
            dictionary[Receiver_Email] = count
            count += 1
        number_emails.append(np.array([Datetime, dictionary[Sender_Email], dictionary[Receiver_Email]],
                                      dtype=np.object_))
    number_emails = np.stack(number_emails, axis=0)
    new_data = pd.DataFrame(number_emails, columns=['Datetime', 'Sender_Email', 'Receiver_Email'])
    new_data.to_csv('number_data.csv', index=False)
    name_dict = pd.DataFrame(list(zip(dictionary.keys(), dictionary.values())), columns=['邮箱地址', '编号'])
    name_dict.to_csv('name_dict.csv', index=False)


if __name__ == '__main__':
    map_name_to_number("./selected.csv")

