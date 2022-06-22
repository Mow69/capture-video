# Library
import cv2
import time
import numpy as np

# Python File
import initDevice as initDevice

# CONST
CAMERA_PORT = 2
FILTER_PATH ='./assets/filter1.mp4'
RESIZE_WIDTH = 400
RESIZE_HEIGHT = 400

# Var
frame_filter_nb = 2

ret, cap_live = initDevice.init_live(CAMERA_PORT)
ret, cap_filter = initDevice.init_filter(FILTER_PATH)

# Main
while True:
    # Capture the next frame from camera
    ret, frame_live = cap_live.read()

    if not ret:
        print('Cannot receive frame from camera')
        break
    frame_live = cv2.resize(frame_live, (RESIZE_WIDTH, RESIZE_HEIGHT), interpolation = cv2.INTER_AREA)

    
    for i in range(frame_filter_nb):
        ret, frame_filter = cap_filter.read()
    
    if ret == False:
        ret, frame_filter, cap_filter = initDevice.reload_filter(FILTER_PATH,cap_filter) #reload filter video and remove cache
        
    frame_filter = cv2.resize(frame_filter, (RESIZE_WIDTH, RESIZE_HEIGHT))
    
    if not ret:
        print('Cannot read from video stream')
        break


    #################################
    # if foreground array is not empty which
    # means actual video is still going on
    if ret:
       
        # creating the alpha mask
        alpha = np.zeros_like(frame_filter)
        gray = cv2.cvtColor(frame_filter, cv2.COLOR_BGR2GRAY)
        alpha[:, :, 0] = gray
        alpha[:, :, 1] = gray
        alpha[:, :, 2] = gray
 
        # converting uint8 to float type
        foreground = frame_filter.astype(float)
        background = frame_live.astype(float)
 
        # normalizing the alpha mask inorder
        # to keep intensity between 0 and 1
        alpha = alpha.astype(float)/255
 
        # multiplying the foreground
        # with alpha matte
        foreground = cv2.multiply(alpha,
                                  foreground)
 
        # multiplying the background
        # with (1 - alpha)
        background = cv2.multiply(1.0 - alpha,
                                  background)
 
        # adding the masked foreground
        # and background together
        outImage = cv2.add(foreground,
                           background)
 
        # resizing the masked output
        ims = cv2.resize(outImage, (RESIZE_WIDTH, RESIZE_HEIGHT))
 
        # showing the masked output video
        cv2.imshow('Blended', ims/255)
 
        # if the user presses 'q' then the
        # program breaks from while loop
    #################################


    # Blend the two images and show the result
    # tr = 0.3; # transparency between 0-1, show camera if 0
    # frame = ((1-tr) * frame_live.astype(np.double) + tr * frame_filter.astype(np.double)).astype(np.uint8)
    # cv2.imshow('Transparent result', frame)


    # KeyPress
    key_press = cv2.waitKeyEx(1)
    if key_press == 27: # exit if ESC is pressed
        break
    if key_press == 2490368: # exit if up-arrow is pressed
        if frame_filter_nb < 5:
            frame_filter_nb += 1
        print(frame_filter_nb)  
    if key_press == 2621440: # exit if down-arrow is pressed
        if frame_filter_nb > 0:
            frame_filter_nb -= 1
        print(frame_filter_nb)

initDevice.close_all(cap_live,cap_filter)