import numpy as np
import pyeegwave
des = np.zeros((1,512))
des[0,23] = 200
des[0,129] = 500
descr = pyeegwave.extract(des.tolist()[0])
print(descr)
print(len(descr))
