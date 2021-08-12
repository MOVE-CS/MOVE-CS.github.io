# -*- coding: utf-8 -*-

import os
from tqdm import tqdm
import pandas as pd 
import numpy as
def k2p(dis):
    return 8+max((dis-3000),0)*1.8/1000


if __name__=='__main__':
    file_path = 'E:/LiYaoyu/taxi_tra'
    windows = 60
    n_days = 31
    file_list = os.listdir(file_path)

    delta = 0.0025

    base_lat = 29.501652
    base_lon = 106.435680


    lat_num = 56
    lon_num = 72
    
    lat_min=base_lat
    lat_max=base_lat+(lat_num)*delta
    lon_min=base_lon
    lon_max=base_lon+(lon_num)*delta
    

    count = np.zeros(((24 * 60 // windows), lat_num, lon_num))
    profit = np.zeros(((24 * 60 // windows),lat_num, lon_num))

    for file in tqdm(file_list):
        flag=0
        dis=0
        for line in open(os.path.join(file_path,file)):
            line.replace('\n','')
            line=line.split(',')

            if line[-1]=='\n':
                continue
            

            if lat_min < float(line[0]) < lat_max and lon_min < float(line[1]) < lon_max and pd.to_datetime(line[-3], format='%Y-%m-%d %H:%M:%S').day == 6:
                if int(line[-2])==1 and flag==0:
                    hour = pd.to_datetime(line[-3], format='%Y-%m-%d %H:%M:%S').hour
                    minute = pd.to_datetime(line[-3], format='%Y-%m-%d %H:%M:%S').minute
                    index = (hour*60+minute)//windows
                    lat_index=int((float(line[0])-base_lat)//delta)
                    lon_index=int((float(line[1])-base_lon)//delta)
                    count[index][lat_index][lon_index] += 1
                    flag=1


            if int(line[-2])!=0 and flag==1:
                dis+=float(line[-1])


            if int(line[-2])==0 and flag==1:
                flag = 0
                pro = k2p(dis)
                profit[index][lat_index][lon_index] += pro
                dis = 0

    for j in range((24*60//windows)):
        np.savetxt('result3/count6' + '_' + str(j) +
                   '.csv', count[j], fmt='%i', delimiter=',')
        np.savetxt('result3/profit6' + '_' + str(j) +
                   '.csv', profit[j], fmt='%.3f', delimiter=',')
