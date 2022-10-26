import sys
import os

from database_connector import *

def video_to_table(video):

    # Get nest_id from videos filename
    str = os.path.basename(video)
    index1 = 6
    index2 = 14
    index3 = 17
    new_character = '/'
    nest_id = str[index1:index2] + new_character + str[index2+1:index3]

    # Checks so that we do not put a nest_id with 2020 into database
    if (nest_id[4:8] == '2020'):
        return

    # Video STP 2020-07 A.mpg
    # Insert video with info into database
    ref = insert_video(video, os.path.basename(video), nest_id)
    if ref:
       return error

def main():
# input arguments
    args = sys.argv[1:]
    
    # if no relative path to folder is given terminate program 
    if len(args) < 1:
        print("Need relative path to folder with videos: python3 extract_video.py [\"PATH1\"] [\"PATH2\"] ...")
        return

    for path in args:
        num_videos = 0

        # iterate through the names of contents of the folder
        for video_path in os.listdir(path):
            num_videos = num_videos+1
            # create the full input path and read the file
            filepath = os.path.join(path, video_path)
            # do something with data
            video_to_table(filepath)

        print("num_videos = ", num_videos)

if __name__ == '__main__':
    main()