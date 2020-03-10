#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 10 07:33:07 2020

@author: fl27895
"""

# QPSK LLR training

import tensorflow as tf
from tensorflow.keras import callbacks
import numpy as np
import matplotlib.pyplot as plt
from model import llr_model
from data_proc import prepare_data


Nsym = 1 #2**10 # number of samples
snrdb = 10.0
  
nb_epochs = 100     # number of epochs to train on
batchsize = 2**7  # training batch size


def train_model():
    model = llr_model(snrdb)


    file_path = 'test_llrnet_weight.h5'
    checkpt = callbacks.ModelCheckpoint(filepath = file_path, monitor = "val_loss", save_best_only = True, save_weights_only = False, mode = "auto", period = 1)
    earlystop = callbacks.EarlyStopping(monitor = "val_loss", min_delta = 1e-3, patience = 5, mode = "auto", restore_best_weights = True)

    dataset = tf.data.Dataset.from_generator(prepare_data, output_types = (tf.float32,tf.float32), output_shapes=(tf.TensorShape([2*Nsym]),tf.TensorShape([2])), args = [snrdb])
    dataset = dataset.batch(batchsize).repeat()
    valset = tf.data.Dataset.from_generator(prepare_data, output_types = (tf.float32,tf.float32), output_shapes=(tf.TensorShape([2*Nsym]),tf.TensorShape([2])), args = [snrdb])
    valset = valset.batch(batchsize).repeat()
    history = model.fit(dataset, steps_per_epoch = 512, epochs = nb_epochs, validation_data = valset, validation_steps = 128, callbacks = [checkpt, earlystop])
    # model.load_weights(file_path)

    # Show performance
    testset = tf.data.Dataset.from_generator(prepare_data, output_types = (tf.float32,tf.float32), output_shapes=(tf.TensorShape([2*Nsym]),tf.TensorShape([2])), args = [snrdb])
    testset = testset.batch(batchsize).repeat()
    score = model.evaluate(testset, verbose = 1, steps = batchsize)
    print(score)

    fig = plt.figure()
    plt.title('Training performance')
    plt.plot(history.epoch, history.history['loss'], label='train loss+error')
    plt.plot(history.epoch, history.history['val_loss'], label='val_error')
    plt.legend()
    fig.savefig("loss_QPSK.png")
    plt.close(fig)
    
    return model
    

#####
##### Test the network: generate new symbols, feed it to the network and compute the LLRs
#####
def test_model(model):
    Nsym = 1
    Ntest = 2**7
    ytest = np.zeros((2*Ntest,))
    llrtest = np.zeros((2*Ntest,))
    bits = np.zeros((2*Ntest,))
    sigmaN = ... # noise stdev
    for k in range(Ntest):
        print(str(k+1)+" out of "+str(Ntest))
        bits[2*k] = ...
        bits[2*k+1] = ...
        sigvec = ...
        noisevec = np.random.normal(loc=0.0, scale=sigmaN, size=(Nsym,))+np.random.normal(loc=0.0, scale=sigmaN, size=(Nsym,))*1.0j
        x = sigvec + noisevec
        xout = np.zeros((2*Nsym,), dtype=np.float32)
        yout = np.zeros((2*Nsym,), dtype=np.float32)
        xout[::2]  = np.real(x)
        xout[1::2] = np.imag(x)
        s00 = # symbol 00
        s01 = # symbol 01
        s10 = # symbol 10
        s11 = # symbol 11
        for i in range(Nsym):
            yout[2*i]   = # LLR 0
            yout[2*i+1] = # LLR 1
            
        packaged_data = (xout,yout)
        testset2 = tf.data.Dataset.from_tensors(np.expand_dims(packaged_data[0], axis = 1).T)
            
        pred_llrs = model.predict(testset2, steps=1)
        ytest[2*k]     = yout[0]
        ytest[2*k+1]   = yout[1]
        llrtest[2*k]   = pred_llrs[0][0]
        llrtest[2*k+1] = pred_llrs[0][1]

    fig  = plt.figure()
    plt.plot(ytest,'b', label = 'True LLRs')
    plt.plot(llrtest,'r', label = 'NN LLRs')
    plt.title('QPSK LLRs')
    plt.legend()
    fig.savefig("LLRs_QPSK.png")
    plt.close(fig)
    BERs = [np.sum(np.logical_xor(ytest>0.0,bits>0))/Ntest,np.sum(np.logical_xor(llrtest>0.0,bits>0))/Ntest]
    print(BERs)
    

model = train_model()
test_model(model)