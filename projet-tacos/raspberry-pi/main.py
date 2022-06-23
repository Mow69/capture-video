# Library
import cv2
import time
import numpy as np

# Python File
import initDevice as initDevice

# CONST

CAMERA_PORT = 2
FILTER_PATH ='./assets/Triangle_VJ_Background_Loop.mp4'
FLASH_PATH ='./assets/flash/white_flash.mp4'
RESIZE_WIDTH = 400
RESIZE_HEIGHT = 400

# Var
frame_filter_nb = 2
frame_filter_pause = False

ret, cap_live = initDevice.init_live(CAMERA_PORT)
ret, cap_filter = initDevice.init_filter(FILTER_PATH)

retFlash = False
flash = False
cap_flash = False
frame_flash = False

# Function



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
    
    
    # --- KeyPress ---
    key_press = cv2.waitKeyEx(1)
    if key_press == 27: # exit if ESC is pressed
        break
    if key_press == 2490368: # speed up if up-arrow is pressed
        if frame_filter_pause:
            frame_filter_pause = not frame_filter_pause
        if frame_filter_nb < 5:
            frame_filter_nb += 1
      
        print(frame_filter_nb)  
    if key_press == 2621440: # speed down if down-arrow is pressed
        if frame_filter_pause:
                frame_filter_pause = not frame_filter_pause
        if frame_filter_nb > 0:
            frame_filter_nb -= 1
        print(frame_filter_nb)
    if key_press == 32: # pause if down-arrow is pressed
        if frame_filter_nb==0:
            frame_filter_pause = False
            frame_filter_nb = 1
        else:
            frame_filter_pause = not frame_filter_pause
    if key_press == ord("1"): # pause if down-arrow is pressed
        retFlash, cap_flash = initDevice.init_filter(FLASH_PATH)
    # --- End-KeyPress ---    
        
    
    if retFlash: #if flash key are pressed, play it
        retFlash, frame_flash = cap_flash.read()
        if retFlash:
            frame_flash = cv2.resize(frame_flash, (RESIZE_WIDTH, RESIZE_HEIGHT))
    else:
        if cap_flash:
            cap_flash.release()
        flash = False

    
        
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
 
 
        if retFlash: # aply alpha to flash 
            alphaFlash = np.zeros_like(frame_flash)
            grayFlash = cv2.cvtColor(frame_flash, cv2.COLOR_BGR2GRAY)
            alphaFlash[:, :, 0] = grayFlash
            alphaFlash[:, :, 1] = grayFlash
            alphaFlash[:, :, 2] = grayFlash
            flash = frame_flash.astype(float)
            alphaFlash = alphaFlash.astype(float)/255
            flash = cv2.multiply(alphaFlash,flash)
 
        # adding the masked foreground
        # and background together
        outFilter = cv2.add(flash, foreground)
        outImage = cv2.add(outFilter,background)
 
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

initDevice.close_all(cap_live,cap_filter,cap_flash)