import numpy as np
# from rrc import rrc

def prepare_data(snrdb):
    # Generate the data
    Nsym = 1
    sigmaN = ...  # noise stdev
    sigvec = ...  # signal vector
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
    yield (xout,yout)