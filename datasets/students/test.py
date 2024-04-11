#read pkl-file
import pickle
import  scipy.io
f = open(r'high_contact_mat_0.5h.pk','rb')
data = pickle.load(f)


scipy.io.savemat('high_contact_05h.mat', mdict={'data': data})



