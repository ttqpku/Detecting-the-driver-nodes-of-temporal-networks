import pandas as pd
import numpy as np

def map_to_number(data_path):
    ant_info = pd.ExcelFile(data_path)
    for name in ant_info.sheet_names:
        data_ant = ant_info.parse(sheet_name=name)
        columns = data_ant.columns
        ants = np.array(data_ant)
        number_ants = []
        count = 1
        dictionary = dict()
        for i in range(ants.shape[0]):
            Actor, Target, ActorPosX, ActorPosY, Time = ants[i]
            if Actor not in dictionary.keys():
                dictionary[Actor] = count
                count += 1
            if Target not in dictionary.keys():
                dictionary[Target] = count
                count += 1
            number_ants.append(np.array([dictionary[Actor], dictionary[Target], Time],
                                      dtype=np.object_))
        number_ants = np.stack(number_ants, axis=0)
        new_data = pd.DataFrame(number_ants, columns=['Actor', 'Target', 'Time'])
        new_data.to_csv(str(name)+'.csv', index=False)



map_to_number('ant_all.xlsx')

