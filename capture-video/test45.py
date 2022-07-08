import cv2
import ctypes

WINDOW_NAME = 'Full Integration'


# initialize video capture object to read video from external webcam
video_capture = cv2.VideoCapture(2)
# if there is no external camera then take the built-in camera
if not video_capture.read()[0]:
    video_capture = cv2.VideoCapture(0)

# Full screen mode
cv2.namedWindow(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN)
cv2.setWindowProperty(WINDOW_NAME, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)


while (video_capture.isOpened()):
    # get Screen Size
    user32 = ctypes.windll.user32
    screen_width, screen_height = user32.GetSystemMetrics(0), user32.GetSystemMetrics(1)

    # read video frame by frame
    ret, frame = video_capture.read()

    frame = cv2.flip(frame, 1)

    frame_height, frame_width, _ = frame.shape

    scaleWidth = float(screen_width)/float(frame_width)
    scaleHeight = float(screen_height)/float(frame_height)

    if scaleHeight>scaleWidth:
        imgScale = scaleWidth

    else:
        imgScale = scaleHeight

    newX,newY = frame.shape[1]*imgScale, frame.shape[0]*imgScale
    frame = cv2.resize(frame,(int(newX),int(newY)))
    cv2.imshow(WINDOW_NAME, frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# release video capture object
video_capture.release()
cv2.destroyAllWindows()