# Library
import cv2
import time
import numpy as np

# Python File
import initDevice as initDevice

# CONST
CAMERA_PORT = 0
FILTER_PATH ='./assets/1104Z_stktunnelmotionstriangledesign_1.mov'
RESIZE_WIDTH = 980
RESIZE_HEIGHT = 540

# Var
frame_filter_nb = 2
frame_filter_pause = False

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

    if not frame_filter_pause:
        for i in range(frame_filter_nb):
            ret, frame_filter = cap_filter.read()
    
    if ret == False: #reload filter video and remove cache
        ret, frame_filter, cap_filter = initDevice.reload_filter(FILTER_PATH,cap_filter) 
        
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
        foreground = cv2.multiply(alpha,foreground)
 
        # multiplying the background
        # with (1 - alpha)
        background = cv2.multiply(1.0 - alpha,background)
 
        # adding the masked foreground
        # and background together
        outImage = cv2.add(foreground,background)
 
        # resizing the masked output
        ims = cv2.resize(outImage, (RESIZE_WIDTH, RESIZE_HEIGHT))
 
        # showing the masked output video
        cv2.imshow('Blended', ims/255)

    # KeyPress
    key_press = cv2.waitKeyEx(1)
    if key_press == 27: # exit if ESC is pressed
        break
    if key_press == 2490368 or key_press == ord('m'): # speed up if up-arrow is pressed
        if frame_filter_nb < 5:
            frame_filter_nb += 1
        print(frame_filter_nb)  
    if key_press == 2621440 or key_press == ord('l'): # speed down if down-arrow is pressed
        if frame_filter_nb > 0:
            frame_filter_nb -= 1
        print(frame_filter_nb)
    if key_press == 32: # pause if down-arrow is pressed
        frame_filter_pause = not frame_filter_pause

initDevice.close_all(cap_live,cap_filter)