# Library
import cv2
import time
import numpy as np

# Python File
import initDevice as initDevice

# Var
CAMERA_PORT = 1
# FILTER_PATH ='./assets/1104Z_stktunnelmotionstriangledesign_1.mov'
FILTER_PATH ='./assets/Triangle_VJ_Background_Loop.mp4'
# FILTER_PATH ='./assets/rendu2.mov'

RESIZE_WIDTH = 980
RESIZE_HEIGHT = 540

frame_filter_speed = 10

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
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    #################################


    # Blend the two images and show the result
    # tr = 0.3; # transparency between 0-1, show camera if 0
    # frame = ((1-tr) * frame_live.astype(np.double) + tr * frame_filter.astype(np.double)).astype(np.uint8)
    # cv2.imshow('Transparent result', frame)


    # if cv2.waitKey(1) == 27: # exit if ESC is pressed
    #     break

initDevice.close_all(cap_live,cap_filter)