import numpy as np
import cv2

# webcam interne du macbook (port 0)
# cap = cv2.VideoCapture(0)
# webcam externe sur le port 1
cap = cv2.VideoCapture(1)


while True:
    ret, frame = cap.read()

    if not ret:
        print('Cannot receive frame from camera')
        break
    # frame_cam = cv2.resize(frame_cam, (width, height), interpolation = cv2.INTER_AREA)


 # Blend the two images and show the result
    tr = 0.3 # transparency between 0-1, show camera if 0
    frame = ((1-tr) * frame.astype(np.float) + tr * frame.astype(np.float)).astype(np.uint8)
    cv2.imshow('Transparent result', frame)
    if cv2.waitKey(1) == 27: # ESC is pressed
        break

    # cv2.imshow('frame', frame)

    # if cv2.waitKey(1) == ord('q'):
    #     break

cap.release()
cv2.destroyAllWindows()
