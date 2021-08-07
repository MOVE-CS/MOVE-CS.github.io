# -*- coding: utf-8 -*-
"""
Created on Sun Oct 20 11:02:06 2019

@author: user5
"""


"""
⭐
统计31天，windows  粒度下，单位是分钟
每个区域的上客量和收入
每个区域一个二维矩阵，行列分别是day和window
不用local，定义一个四维矩阵,也能一遍过
只有main函数，没有封装
保存到文件时，对经纬度做了格式化，保留5位小数
做了出错控制，自动根据选取region的数量，lat,lon的最大最小值，不会报错
不会出现只求这个3*3有的超出这个区域就报错的情况
lat_num=5  #参考值10
lon_num=5  #参考值20
delta=0.005 #参考值0.005  约500m
"""

import os
from tqdm import tqdm
import pandas as pd 
import numpy as np

def k2p(dis):#将里程转化成收益
    return 8+max((dis-3000),0)*1.8/1000
#一维列表，相当于一天为粒度，粗略统计每天的量             

if __name__=='__main__':
    file_path = 'E:/LiYaoyu/taxi_tra'
    windows = 60  # 240  分钟
    n_days = 31  # 3月31天
    file_list = os.listdir(file_path)

    delta = 0.0025
    # 石门大桥作为基准点，求江北地区
    base_lat = 29.501652
    base_lon = 106.435680

    # 设置基准经纬度上，向经纬度扩展几次delta
    lat_num = 56
    lon_num = 72
    
    lat_min=base_lat
    lat_max=base_lat+(lat_num)*delta
    lon_min=base_lon
    lon_max=base_lon+(lon_num)*delta
    
    #定义四维大矩阵
    count = np.zeros(((24 * 60 // windows), lat_num, lon_num))
    profit = np.zeros(((24 * 60 // windows),lat_num, lon_num))

    for file in tqdm(file_list):
        flag=0 #之前是否有客
        dis=0 #某一单的里程，下客清零
        for line in open(os.path.join(file_path,file)):
            line.replace('\n','')
            line=line.split(',')
            #异常数据
            if line[-1]=='\n':
                continue
            
            #上客，统计地点和费用
            if lat_min < float(line[0]) < lat_max and lon_min < float(line[1]) < lon_max and pd.to_datetime(line[-3], format='%Y-%m-%d %H:%M:%S').day == 6:
                if int(line[-2])==1 and flag==0:
                    hour = pd.to_datetime(line[-3], format='%Y-%m-%d %H:%M:%S').hour#获取小时
                    minute = pd.to_datetime(line[-3], format='%Y-%m-%d %H:%M:%S').minute#获取分钟
                    index = (hour*60+minute)//windows
                    lat_index=int((float(line[0])-base_lat)//delta)
                    lon_index=int((float(line[1])-base_lon)//delta)
                    count[index][lat_index][lon_index] += 1
                    flag=1

            #增加一单的里程
            if int(line[-2])!=0 and flag==1:
                dis+=float(line[-1])

            #下客复位
            if int(line[-2])==0 and flag==1:
                flag = 0
                pro = k2p(dis) #里程转化成收益
                profit[index][lat_index][lon_index] += pro
                dis = 0 #本单里程清零

    for j in range((24*60//windows)):
        np.savetxt('result3/count6' + '_' + str(j) +
                   '.csv', count[j], fmt='%i', delimiter=',')
        np.savetxt('result3/profit6' + '_' + str(j) +
                   '.csv', profit[j], fmt='%.3f', delimiter=',')
#    for i in range(lat_num):
#        for j in range(lon_num):
#            np.savetxt('result/cout_' + str(i) + '_' + str(j) +
#                       '.csv', count[i][j], fmt='%i', delimiter=',')
#            np.savetxt('result/profit_' + str(i) + '_' + str(j) +
#                       '.csv', profit[i][j], fmt='%.3f', delimiter=',')
