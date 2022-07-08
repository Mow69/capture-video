# Library
import json
import os
import random
import time
import ctypes
import cv2
import numpy as np
import gi

#import gtk, pygtk
#from bluedot.btcomm import BluetoothServer

# Python File
#import initDevice as initDevice

#gi.require_version('Gtk', '3.0')
#from gi.repository import Gtk

# CONST -------------------

CAMERA_PORT = 2
RESIZE_WIDTH = 1920
RESIZE_HEIGHT = 1080
WINDOW_NAME = 'Full Integration'

# VAR ----------------------

with open("filter.json","r") as json_file:
    all_filter_json = json.load(json_file)

def get_filter_path(id_filter):
    return all_filter_json[str(id_filter)]['path']

activate_camera = True
is_random = False
app_commande = None
hidde_filter = False

frame_filter_nb = 5
frame_filter_pause = False
actual_filter_index = 1

actual_flash_index = False
ret_flash = False
capture_flash = False
frame_flash = False
show_img_flash = False

ret_live = False
capture_live = False
frame_live = False
show_img_live = False

ret_filter = False
capture_filter = False
frame_filter = False
show_img_filter = False

# Init Capture ------------

capture_live = cv2.VideoCapture(2)
# if there is no external camera then take the built-in camera
if not capture_live.read()[0]:
    capture_live = cv2.VideoCapture(0)

capture_filter = cv2.VideoCapture(get_filter_path(actual_filter_index))

# Function ------------------

def data_b(data):
    global app_commande
    app_commande = data.split(":")
    s.send(data )

#TODO s = BluetoothServer(data_b) # Start watch bluetooth

def check_app_commande():
    global frame_filter_nb, frame_filter_pause, retFilter,is_random, actual_filter_index,cap_filter, retFlash, frame_flash, cap_flash, app_commande,activate_camera, hidde_filter


    app_commande_function = app_commande[0]
    app_commande_value = app_commande[1]
    # TODO CONVERT TO SWITCH

   # Activate/Desactivate Camera BTN
    if app_commande_function == 'camera':
        activate_camera = not activate_camera

    # Activate/Desactivate PAUSE BTN
    if app_commande_function == 'pause':
        frame_filter_pause = not frame_filter_pause

    # Activate/Desactivate Random BTN
    if app_commande_function == 'random':
        is_random = not is_random
        if (capture_filter):
            capture_filter.release()
        capture_filter = cv2.VideoCapture(get_filter_path(random.randint(1, 8))) # TODO max = lenght of json

    # UP/DOWN Speed BTN
    if app_commande_function == 'speed':
        frame_filter_nb = int(app_commande_value)

    # Activate Reset BTN
    if app_commande_function == 'reset':
        frame_filter_nb = 5
        activate_camera = True
        frame_filter_pause = False
        hidde_filter = True
        is_random = False
        if(capture_filter):
            cap_filter.release()
            retFilter = False
            frame_filter = False

    # Change Filter BTN
    if app_commande_function == 'filterId':
        hidde_filter = False
        actual_filter_index = int(app_commande_value)
        if(capture_filter):
            capture_filter.release()
        capture_filter = cv2.VideoCapture(get_filter_path(actual_filter_index))

    # Change Flash BTN
    if app_commande_function == 'flashId':
        actual_flash_index = int(app_commande_value)
        if(capture_flash):
            capture_flash.release()
        capture_flash = cv2.VideoCapture(get_filter_path(actual_filter_index))


# Full screen mode
cv2.namedWindow(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN)
cv2.setWindowProperty(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

while (capture_live.isOpened()):

    # EXECUTE STORED BLUETOOTH COMMANDE
    if app_commande:
        check_app_commande()
        app_commande = None


    # Get Screen Size


    #window = gtk.Window()
    #screen = window.get_screen()
    #print("width = " + str(screen.get_width()) + ", height = " + str(screen.get_height()))
    #screen_width = user32.GetSystemMetrics(0)
    #screen_height = user32.GetSystemMetrics(1)

    a,b,screen_width, screen_height = cv2.getWindowImageRect(WINDOW_NAME)
    # Read video frame by frame
    ret_live, frame_live = capture_live.read()
    frame_live = cv2.flip(frame_live, 1)
    frame_live_height, frame_live_width, _ = frame_live.shape
    scaleWidth = float(screen_width)/float(frame_live_width)
    scaleHeight = float(screen_height)/float(frame_live_height)

    # Size Scale On live
    if scaleHeight>scaleWidth:
        imgScale = scaleWidth
    else:
        imgScale = scaleHeight

    newX,newY = frame_live.shape[1]*imgScale, frame_live.shape[0]*imgScale
    frame_live = cv2.resize(frame_live,(int(newX),int(newY)),interpolation = cv2.INTER_AREA)
    # ------------ MAIN FUNCTION ------------

    if not ret_live:
        print('Cannot receive frame from camera')
        break


    # Read Filter n*frame by n*frame (if not pause)
    if not frame_filter_pause:
        for i in range(frame_filter_nb):
            ret_filter, frame_filter = capture_filter.read()

    # Reload filter if is finish
    if not ret_filter:
        if (capture_filter):
            capture_filter.release()
        if is_random :
            capture_filter = cv2.VideoCapture(get_filter_path(random.randint(1, 8))) # TODO max = lenght of json
        else :
            capture_filter = cv2.VideoCapture(get_filter_path(actual_filter_index))
        ret_filter, frame_filter = capture_filter.read()
    frame_filter = cv2.flip(frame_filter, 1)
    frame_filter = cv2.resize(frame_filter,(int(newX),int(newY)))

    # Read Flash frame by frame (if activate)
    if ret_flash:
        ret_flash, frame_flash = capture_flash.read()
        frame_flash = cv2.flip(frame_flash, 1)
        frame_flash = cv2.resize(frame_flash,(int(newX),int(newY)))
    else:
        if capture_flash:
            capture_flash.release()
        show_img_flash = False

    # ---- ALPHA Filter
    if (ret_filter):
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

        #outFilter = cv2.add(show_img_flash, foreground) # if flash exist
        #outImage = cv2.add(outFilter,background)



    #---- ALPHA Flash
    if (ret_flash) : # aply alpha to flash

        alpha_flash = np.zeros_like(frame_flash)

        gray_flash = cv2.cvtColor(frame_flash, cv2.COLOR_BGR2GRAY)
        alpha_flash[:, :, 0] = gray_flash
        alpha_flash[:, :, 1] = gray_flash
        alpha_flash[:, :, 2] = gray_flash
        show_img_flash = frame_flash.astype(float)
        alpha_flash = alpha_flash.astype(float)/255
        show_img_flash = cv2.multiply(alpha_flash,flash)

    if (show_img_flash):
        outImage = cv2.add(flash,foreground)
        outImage = cv2.add(outImage,background)
    else:
        outImage = cv2.add(foreground,background)

    ims = cv2.resize(outImage,(int(newX),int(newY)))
    cv2.imshow(WINDOW_NAME, ims/255)

    # --------- END MAIN FUNCTION ---------

    # "Q" for exit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# release video capture object
if (capture_live):
    capture_live.release()
if (capture_filter):
    capture_filter.release()
if (capture_flash):
    capture_flash.release()
cv2.destroyAllWindows()
