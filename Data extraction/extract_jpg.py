from distutils.log import error
from PIL import Image
import piexif
import os
import sys

from database_connector import *

def dms_to_dd(d, m, s):
    dd = d + float(m)/60 + float(s)/3600
    return dd

# Function:    image_to_table
# Description  Takes a image, extracts info and inserts the image into database
# Input        image: Image to put into database
def image_to_table(image):
    # Extract EXIF data from image
    exifdata = image.getexif()
    exif_dict = piexif.load(image.info.get('exif'))
    print(image.filename)

    dd_lat = 0;
    dd_long = 0;
    maps_link = '';
    
    if bool(exif_dict['GPS']) :
        lat = exif_dict['GPS'][2];
        long = exif_dict['GPS'][4];
        # convert latitude coordinates from dms to dd (google use dd)
        d = int(lat[0][0])/int(lat[0][1])
        m = int(lat[1][0])/int(lat[1][1])
        s = int(lat[2][0])/int(lat[2][1])
        dd_lat = dms_to_dd(d,m,s)

        # convert longitude coordinates from dms to dd (google use dd)
        d = int(long[0][0])/int(long[0][1])
        m = int(long[1][0])/int(long[1][1])
        s = int(long[2][0])/int(long[2][1])
        dd_long = dms_to_dd(d,m,s)

        maps_link = ("https://www.google.com/maps/place/%s,%s" % (dd_lat, dd_long))

    # Get correct TIMESTAMP structure
    str = exifdata[306]
    index1 = 4
    index2 = 7
    new_character = '-'
    str = str[:index1] + new_character + str[index1+1:index2] + new_character + str[index2+1:]

    # Insert image with info into database
    ref = insert_image(image.filename, os.path.basename(image.filename), str, dd_lat, dd_long, maps_link)
    if ref:
        return error

# Main-function: Reads all files in directory in 'path' and inserts them into datbase.
# When you have whitespaces in the filename put '\' backslash before the whitespace, ex: BirdData-master/Data/Viltkamera\ STP\ 2022-18
def main():
    # input arguments
    args = sys.argv[1:]
    
    # if no relative path to folder is given terminate program 
    if len(args) < 1:
        print("Need relative path to folder with images: python3 extract_jpg.py [\"PATH1\"] [\"PATH2\"] ...")
        return

    for path in args:
        num_images = 0

        # iterate through the names of contents of the folder
        for image_path in os.listdir(path):
            num_images = num_images+1

            # create the full input path and read the file
            input_path = os.path.join(path, image_path)

            # read the image data using PIL
            image = Image.open(input_path)

            # do something with data
            image_to_table(image)

        print("num_images = ", num_images)

if __name__ == '__main__':
    main()