# Library
import json
import os
import random
import time
import ctypes
import cv2
import numpy as np


# Python File
import initDevice as initDevice

# CONST
CAMERA_PORT = 0
RESIZE_WIDTH = 1920
RESIZE_HEIGHT = 1080
WINDOW_NAME = 'Full Integration'

# Var
with open("filter.json","r") as json_file:
    all_filter_json = json.load(json_file)

def get_filter_path(id_filter):
    return all_filter_json[str(id_filter)]['path']



frame_filter_nb = 5
frame_filter_pause = False
actual_filter_index = 1
activate_camera = True
actual_flash_index = False

is_random = False



retCam, cap_live = initDevice.init_live(CAMERA_PORT)

retFilter, cap_filter = initDevice.init_filter(get_filter_path(actual_filter_index))

retFlash = False
flash = False
cap_flash = False
frame_flash = False
hidde_filter = False
app_commande = None
# Function

#_____________________________________data_split_______________________

#_____________________________________________________________________________

def check_app_commande():
    global frame_filter_nb, frame_filter_pause, retFilter,is_random, actual_filter_index,cap_filter, retFlash, frame_flash, cap_flash, app_commande,activate_camera, hidde_filter


    app_commande_function = app_commande[0]
    app_commande_value = app_commande[1]


   #________________________________PAUSE___________________________________________________________

    if app_commande_function == 'camera': # clic sur pause alors qu'il est en mouvement
        activate_camera = not activate_camera

    #________________________________PAUSE___________________________________________________________

    if app_commande_function == 'pause': # clic sur pause alors qu'il est en mouvement
        frame_filter_pause = not frame_filter_pause


    #____________________________Random_____________________________________________________________

    if app_commande_function == 'random':
        is_random = not is_random
        cap_filter.release()
        retFilter, cap_filter = initDevice.init_filter(get_filter_path(random.randint(1, 8)))


    #____________________________Speed_____________________________________________________________
    if app_commande_function == 'speed':
        frame_filter_nb = int(app_commande_value)

    #____________________________Reset_____________________________________________________________
    if app_commande_function == 'reset':
        frame_filter_nb = 5
        activate_camera = True
        frame_filter_pause = False
        hidde_filter = True
        is_random = False
        if(retFilter):
            cap_filter.release()
            retFilter = False
            frame_filter = False
    #_____________________________________Changer filter______________________________________
    if app_commande_function == 'filterId':
         hidde_filter = False
         actual_filter_index = int(app_commande_value)
         cap_filter.release()
         retFilter, cap_filter = initDevice.init_filter(get_filter_path(actual_filter_index))
    #____________________________Changer flash_____________________________________________________________
    elif app_commande_function == 'flashId':
        actual_flash_index = int(app_commande_value)
        if(retFlash):
            cap_flash.release()
        retFlash, cap_flash = initDevice.init_filter(get_filter_path( actual_flash_index ))


    #_______________________________________________________________________________________


cv2.namedWindow(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN)
cv2.setWindowProperty(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

# Main
while True:

    # Execute Stored command from Bluetooth only at this position
    if app_commande:
        check_app_commande()
        app_commande = None

    # Capture the next frame from camera
    retCam, frame_live = cap_live.read()
    if not retCam:
        print('Cannot receive frame from camera')
        cap_live.release()
        ret, frame_live = cap_live.read()
        if not retCam:
            print('Cannot receive frame from camera')
            break
    frame_live = cv2.resize(frame_live, (RESIZE_WIDTH, RESIZE_HEIGHT), interpolation = cv2.INTER_AREA)

    if not frame_filter_pause:
        for i in range(frame_filter_nb):
            retFilter, frame_filter = cap_filter.read()

    if retFilter == False: #reload filter video and remove cache
        if is_random :
           retFilter, frame_filter, cap_filter = initDevice.reload_filter(get_filter_path(random.randint(1, 8)),cap_filter)
        else :
            retFilter, frame_filter, cap_filter = initDevice.reload_filter(get_filter_path(actual_filter_index),cap_filter)

    frame_filter = cv2.resize(frame_filter, (RESIZE_WIDTH, RESIZE_HEIGHT))

    if not retFilter:
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
            frame_filter_nb = 5

        print(frame_filter_nb)
    if key_press == 2621440: # speed down if down-arrow is pressed
        if frame_filter_pause:
                frame_filter_pause = not frame_filter_pause
        if frame_filter_nb > 0:
            frame_filter_nb -= 1
        print(frame_filter_nb)


    if key_press == 32: # pause if space is pressed
        if frame_filter_nb==0:
            frame_filter_pause = False
            frame_filter_nb = 1
        else:
            frame_filter_pause = not frame_filter_pause


    # --- End-KeyPress ---

    if retFlash: #if flash key are pressed, play it
        retFlash, frame_flash = cap_flash.read()
        if retFlash:
            frame_flash = cv2.resize(frame_flash, (RESIZE_WIDTH, RESIZE_HEIGHT))
    else:
        if cap_flash:
            cap_flash.release()
        flash = False


    if retFilter:
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


        if retFlash and type(frame_flash) != None : # aply alpha to flash

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



initDevice.close_all(cap_live,cap_filter,cap_flash)
