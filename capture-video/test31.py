# Library
import json
import os
import random
import time
import ctypes
import cv2
import numpy as np
#from bluedot.btcomm import BluetoothServer

# Python File
import initDevice as initDevice

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

# Full screen mode
cv2.namedWindow(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN)
cv2.setWindowProperty(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

while (capture_live.isOpened()):

    # Get Screen Size
    user32 = ctypes.windll.user32
    screen_width, screen_height = user32.GetSystemMetrics(0), user32.GetSystemMetrics(1)

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
    # ----------------------- MAIN FUNCTION ----------------------------------------

    if not ret_live:
        print('Cannot receive frame from camera')
        break

    # Reload filter
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


    # ------------- ALPHA Filter ---------------
    if ret_filter:
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









        ims = cv2.resize(outImage,(int(newX),int(newY)))
        cv2.imshow(WINDOW_NAME, ims/255)

        #----------------------- END MAIN FUNCTION ----------------------------------------

    # "Q" for exit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# release video capture object
capture_live.release()
capture_filter.release()
capture_flash.release()
cv2.destroyAllWindows()