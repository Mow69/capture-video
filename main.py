# Library
import cv2
import time
import numpy as np

# Python File
import initDevice as initDevice

# CONST
#filter_path = './img/filter1.mp4'
CAMERA_PORT = 0
FILTER_PATH ='./assets/1104Z_stktunnelmotionstriangledesign_1.mov'
RESIZE_WIDTH = 400
RESIZE_HEIGHT = 400

# Var
frame_filter_nb = 5

# Main

ret, cap_live = initDevice.init_live(CAMERA_PORT)
ret, cap_filter = initDevice.init_filter(FILTER_PATH)

while True:
    # Capture the next frame from camera
    ret, frame_live = cap_live.read()

    
    #fps = cap_live.get(cv2.CAP_PROP_FPS)
    #print("Frames per second using cap_live: {0}".format(fps))
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

    
    # Blend the two images and show the result
    tr = 0.3; # transparency between 0-1, show camera if 0
    frame = ((1-tr) * frame_live.astype(np.double) + tr * frame_filter.astype(np.double)).astype(np.uint8)
    cv2.imshow('Transparent result', frame)


    key_press = cv2.waitKeyEx(1)
    if key_press == 27: # exit if ESC is pressed
        break
    if key_press == 2490368: # exit if up-arrow is pressed
        if frame_filter_nb < 10:
            frame_filter_nb += 1
        print(frame_filter_nb)  
    if key_press == 2621440: # exit if down-arrow is pressed
        if frame_filter_nb > 00:
            frame_filter_nb -= 1
        print(frame_filter_nb)

initDevice.close_all(cap_live,cap_filter)