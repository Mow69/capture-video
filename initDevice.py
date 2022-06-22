# Library
import cv2


def init_live(CAMERA_PORT):
    # Live camera feed
    cap_live = cv2.VideoCapture(CAMERA_PORT)

    if not cap_live.isOpened():
        print('Cannot open live camera')
        exit()
        
    ret, frame_live_first = cap_live.read() # ret = <bool>, frame_live_first = <array/null>
    
    if not ret:
        print('Cannot open live camera stream')
        cap_live.release() #remove unused capture
        exit()
    return ret, cap_live

def init_filter(filter_path): # Init Vidéo filter
    cap_filter = cv2.VideoCapture(filter_path)

    if not cap_filter.isOpened():
        print('Cannot open video filter: ' + filter_path)
        exit()
        
    ret, frame_filter_first = cap_filter.read() # ret = <bool>, frame_filter_first = <array/null>

    if not ret:
        print('Cannot open video filter stream: ' + filter_path)
        cap_filter.release()
        # End of vidéo possibility, reload vidéo :
        
    return ret, cap_filter;

def reload_filter(filter_path,last_cap_filter):
    last_cap_filter.release()
    try:
        new_cap_filter = cv2.VideoCapture(filter_path) #ret, frame_filter
        ret, frame_filter = new_cap_filter.read()
        return ret, frame_filter, new_cap_filter
    except:
        print('Cannot reload the video filter ' + filter_path)
        exit()
        
        
def close_all(cap_live,cap_filter):
    cap_live.release()
    cap_filter.release()
    cv2.destroyAllWindows()