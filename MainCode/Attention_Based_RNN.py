# -*- coding: utf-8 -*-
"""
Created on Thu Oct 31 17:07:25 2019

@author: pc
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from keras.models import load_model
from keras.callbacks import ModelCheckpoint 
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout
from seq2seq import AttentionSeq2Seq

from sklearn.metrics import mean_squared_error
import os
import shutil
import warnings
warnings.filterwarnings('ignore')

#rmse
def rmse(labels, preds):
    total_size = np.size(labels)
    return np.sqrt(np.sum(np.square(labels - preds)) / total_size)

#mae
def mae(labels, preds):
    total_size = np.size(labels)
    return np.sum(np.abs(labels - preds)) / total_size

#mape
def mape(labels, preds):
    diff = np.abs(np.array(labels) - np.array(preds))
    return np.mean(diff / labels)

def load_data():
    #data=pd.read_csv('../data/data.csv')
    data = np.load('../data/'+loc_name+'_'+data_name+'.npy')
    data_scaled = scaler.fit_transform(data)
    #data = data.replace(0, 1e-6)
    
    #获取训练集属性和标签
    X = []  #train输入
    y = []  #train标签
    for i in range(input_len+output_len, data_scaled.shape[0]):  
        X.append(data_scaled[i-input_len-output_len:i-output_len, :])
        y.append(data_scaled[i-output_len:i, 0])
    #整理数据类型
    X = np.array(X)
    y = np.array(y)  
    X = np.reshape(X, (X.shape[0], input_len, input_dim))  #样本数，input_len,input_dim
    y = np.reshape(y, (y.shape[0], output_len, output_dim))  #样本数，output_len,output_dim
    
    X_train=X[:1000]
    y_train=y[:1000]
 
    return X_train,y_train

def model(X_train,y_train):
    model=AttentionSeq2Seq(output_dim=output_dim, 
                           output_length=output_len,
                           hidden_dim=hidden_dim,
                           input_shape=(input_len, input_dim),                            
                           depth=depth)
    #模型编译
    model.compile(optimizer = 'adam', loss = 'mean_squared_error')
    
    if os.path.exists(model_path):
        model.load_weights(model_path)
        print('成功加载模型！')
    checkpoint = ModelCheckpoint(model_path,
                                 monitor='loss', #根据什么来保存
                                 save_weights_only=True,verbose=1,
                                 save_best_only=True, #只保存最好的
                                 period=period#每隔多久保存一次
                                 )    
    #==训练，loss可视化==    
    history=model.fit(X_train, y_train, epochs = epochs, 
              validation_split=0.1, 
              callbacks=[checkpoint], 
              batch_size = batch_size)  
    
    np.savetxt(sub_exp_path+'loss.csv', history.history['loss'])
    np.savetxt(sub_exp_path+'val_loss.csv', history.history['val_loss'])
    
    predictions = model.predict(X_train)
    for_trans=np.zeros((predictions.shape[0],input_dim))
    for_trans[:,0]=list(predictions[:,0,:])
    predictions = scaler.inverse_transform(for_trans)[:,0]
    
    for_trans=np.zeros((y_train.shape[0],input_dim))
    for_trans[:,0]=list(y_train[:,0,:])
    y_train = scaler.inverse_transform(for_trans)[:,0]
    
    result=np.vstack((y_train,predictions)).T
    np.savetxt(sub_exp_path+'prediction.csv', result,delimiter=',')
    
    model_mae = mae(y_train, predictions)
    model_rmse = rmse(y_train, predictions)
    
    print(f'rmse:{model_rmse}\nmae:{model_mae}\n')
    
    fig = plt.figure()
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title(experiment_name+' model loss')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'test'], loc='upper right')
    fig.savefig(sub_exp_path+'model loss.png',dpi=dpi)
    
    plt.figure(figsize=figsize)
    plt.plot(y_train, color='blue', label='Actual')
    plt.plot(predictions , color='red', label='Predicted')
    plt.title('model performance')
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.legend()
    plt.savefig(sub_exp_path+'performance.png',dpi=dpi)
    plt.show()

    return model_mae, model_rmse, history.history['loss'], history.history['val_loss']


if __name__=='__main__':
    #任务参数
    loc_name_list=['141','234']
    data_name_list=['Profit','Cout']
    exp_time=5
    
    input_len_list=[12,24,48,64,96,120]
    output_len=3
    input_dim=10
    output_dim=1
    # 网络参数
    epochs = 500
    depth = 3  # 网络深度
    hidden_dim = 50
    batch_size = 32
    period = 1  # 每个多少轮保存一次模型
    dpi = 600  # 保存图片的像素大小
    figsize = (10, 6)  # 图片大小 
    x_label='Date'#画图的x轴含义

    for loc_name in loc_name_list:
        for exp_t in range(1,exp_time+1):
            for data_name in data_name_list:
                y_label=data_name#画图的y轴含义
    
                for input_len in input_len_list:
                    experiment_name=data_name[0]+'_'+loc_name+'_AM_'+str(epochs)+'_'+str(input_len)
                    sub_exp_path='../exp set/'+loc_name+'_'+str(exp_t)+'/change input len/'+experiment_name+'/'
                    model_path=sub_exp_path+'model.h5'
    
                    if os.path.exists(sub_exp_path)==False:
                        print(sub_exp_path,'首次实验')    
                        os.mkdir(sub_exp_path)      
                    elif 'performance.png' in os .listdir(sub_exp_path):
                        print(sub_exp_path,'实验已经完成')
                        continue
                    else:
                        print(sub_exp_path,'实验已被删除')                    
                        shutil.rmtree(sub_exp_path)                    
                        os.mkdir(sub_exp_path)
    
                    #训练一个归一化器
                    from sklearn.preprocessing import MinMaxScaler
                    scaler = MinMaxScaler(feature_range = (0, 1))
    
                    X_train,y_train=load_data()
                    model_mae,model_rmse,loss,val_loss=model(X_train,y_train)
    
    
                    f = open(sub_exp_path+'config.txt','w')
                    f.write(f'''
                    rmse:{model_rmse}
                    mae:{model_mae}
                
                    input_len:{input_len}
                    output_len:{output_len}
                    input_dim:{input_dim}
                    output_dim:{output_dim}
                
                    loc_name:{loc_name}
                    epochs:{epochs}
                    depth:{depth}
                    hidden_dim:{hidden_dim}
                    ''')
                    f.close()
    
