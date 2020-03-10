from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense


def llr_model():
    Nsym = 1
    model = Sequential()
    model.add(Dense(..., batch_input_shape=(None, 2*Nsym), activation = "..."))
    model.add(Dense(..., activation = "..."))
    model.compile(loss="...", optimizer = "adam", metrics = ["accuracy"])
    
    return model