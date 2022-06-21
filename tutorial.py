import cv2
import time
import numpy as np

current_milli_time = lambda: int(round(time.time() * 1000))

# webcam interne du macbook (port 0)
# cap = cv2.VideoCapture(0)
# webcam externe sur le port 1
cap_cam = cv2.VideoCapture(1)
# cap_cam.set(cv2.CAP_PROP_BUFFERSIZE, 3)

if not cap_cam.isOpened():
    print('Cannot open camera')
    exit()
ret, frame_cam = cap_cam.read()
if not ret:
    print('Cannot open camera stream')
    cap_cam.release()
    exit()

# Video feed
# filename = 'assets/video.mov'
filename = 'assets/1104Z_stktunnelmotionstriangledesign_1.mov'
# filename = 'assets/Triangle_VJ_Background_Loop.mp4'
# filename = 'assets/rendu2.mov'


cap_vid = cv2.VideoCapture(filename)
# cap_vid.set(cv2.CAP_PROP_BUFFERSIZE, 3)

if not cap_cam.isOpened():
    print('Cannot open video: ' + filename)
    cap_cam.release()
    exit()
ret, frame_vid = cap_vid.read()

if not ret:
    print('Cannot open video stream: ' + filename)
    cap_cam.release()
    cap_vid.release()
    exit()

# Resize the camera frame to the size of the video
# height = int(cap_vid.get(cv2.CAP_PROP_FRAME_HEIGHT))
# width = int(cap_vid.get(cv2.CAP_PROP_FRAME_WIDTH))

height = int(1080.0)
width = int(1920.0)

# print(cap_vid.get(cv2.CAP_PROP_FRAME_WIDTH))
# 1080.0
# print('width : ' . width) 
# 1920.0

# Starting from now, syncronize the videos
start = current_milli_time()

while True:
    # Capture the next frame from camera
    ret, frame_cam = cap_cam.read()
    if not ret:
        print('Cannot receive frame from camera')
        break
    frame_cam = cv2.resize(frame_cam, (width, height), interpolation = cv2.INTER_AREA)

    if not cap_vid:
        cap_cam = cv2.VideoCapture(1)
        print(cap_vid)
        break

    ret, frame_vid = cap_vid.read()
    print(cap_vid.read())

    # Blend the two images and show the result
    tr = 0.3 # transparency between 0-1, show camera if 0
    if frame_vid is not None:
        frame_vid = cv2.resize(frame_vid, (width, height))
        frame = ((1-tr) * frame_cam.astype(np.float64) + tr * frame_vid.astype(np.float64)).astype(np.uint8)
        cv2.imshow('Transparent result', frame)
    else:
        cap_vid = cv2.VideoCapture(filename)
        ret, frame_vid = cap_vid.read()
    
    if cv2.waitKey(1) == 27: # ESC is pressed
        break



#     # Find OpenCV version
#     (major_ver, minor_ver, subminor_ver) = (cv2.__version__).split('.')

#     # With webcam get(CV_CAP_PROP_FPS) does not work.
#     # Let's see for ourselves.

#     if int(major_ver)  < 3 :
#         fps = cap_vid.get(cv2.CAP_PROP_FPS)
#         print("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
#     else :
#         fps = cap_vid.get(cv2.CAP_PROP_FPS)
#         print("Frames per second using video.get(cv2.CAP_PROP_FPS) : {0}".format(fps))

#     # Number of frames to capture
#     num_frames = 120

#     print("Capturing {0} frames".format(num_frames))

#     # Start time
#     start = time.time()

#     # Grab a few frames
#     for i in range(0, num_frames) :
#         ret, frame = cap_vid.read()

#     # End time
#     end = time.time()

#     # Time elapsed
#     seconds = end - start
#     print ("Time taken : {0} seconds".format(seconds))

#     # Calculate frames per second
#     fps  = num_frames / seconds
#     print("Estimated frames per second : {0}".format(fps))


cap_cam.release()
cap_vid.release()
cv2.destroyAllWindows()
