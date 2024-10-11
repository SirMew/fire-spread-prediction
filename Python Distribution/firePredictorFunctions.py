import numpy as np

#Function  to convert image values into F,B,O states

def imageToFireMap(img):

    a1 = img[:,:,1]
    
    B_idx = (a1==237) #where red set to fire
    # correction_idx = (a1~=237 & a1~=34 & a1 ~= 127) #detects any colours that may have occurred due to automatic blending in paint
    # F_idx = (a1==34) #where green set to fuel
    # O_idx = (a1==127) #Where grey set to out
    
    map_init = np.zeros([1000,1000])
    map_init[B_idx] == 3
    # map_init(F_idx) = 2
    # map_init(O_idx) = 1
    # map_init(correction_idx) = 2

    return B_idx