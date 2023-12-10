# -*- coding: utf-8 -*-
"""
Spyder Editor

"""
#!/usr/bin/env python3

# Author(s): T. Flutre - M. Ecarnot - A. Patouillard - A. Hardy - C. Lee - R. Roux-Vaneph
# 
# References:
# http://www.plantphysiol.org/lookup/doi/10.1104/pp.112.205120
# https://codegolf.stackexchange.com/questions/40831/counting-grains-of-rice

import sys
sys.path.append("/Users/romeo/Desktop/Test_donnees")
print(sys.path)


# dependencies

import os
import numpy as np
from numpy import matlib as mb
import scipy as sci
import matplotlib.pyplot as plt
import cv2 as cv
import spectral as sp
import spectral.io.envi as envi
from skimage.measure import label, regionprops, regionprops_table
import gzip
import os
import time


## PATH of hyperspectral images
PATH =  '/Users/romeo/Desktop/Test_donnees/'
filelist = os.listdir(PATH)

for filename in filelist: #os.listdir(PATH)[27:187]:  # [2:filelist.__len__()]
    print(filename)
    # res = [ele for ele in lines if (ele in filename)]
    if filename.endswith('.hyspex'): #res.__len__()>0 and filename.endswith('.hyspex'):  # When targetting pure var in Q3-PR1
        print(filename)
        sImg = filename[0:filename.find('.')]  # 'x30y21-var1_11000_us_2x_2020-12-02T101757_corr'  #
        # # input parameters
        cropIdxDim1 = 190
        thresh_refl = 0.07 # threshold of reflectance to remove background
        thresh_lum_spectralon = 13000  # threshold of light intensity to remove background + milli
        #areaRange = 1000  # range of grain area in number of pixels
        band = 150  # spectral band to extract (#100 : 681 nm)


        img = envi.open(PATH + sImg + '.hdr', PATH + sImg + '.hyspex')

        img = np.array(img.load(),dtype=np.int16)
        img = np.transpose(img, (1, 0, 2))
        imr = np.empty(img.shape,np.float32)
    
        # Detect and extract spectralon
        im0 = img[:, 1:cropIdxDim1, :]
#        ret0, binaryImage0 = cv.threshold(im0[:,:,band[0]]/im0[:,:,band[1]], thresh_lum_spectralon,1, cv.THRESH_BINARY)
        ret0, binaryImage0 = cv.threshold(im0[:,:,band], thresh_lum_spectralon,1, cv.THRESH_BINARY)
        binaryImage0 = cv.erode(binaryImage0, np.ones((10,10),np.uint8))
        binaryImage0 = cv.morphologyEx(binaryImage0, cv.MORPH_CLOSE, np.ones((20, 20), np.uint8))
        # Conversion to reflectance  : Essential for shape detection
        ref = np.zeros((img.shape[0],img.shape[2]),img.dtype)
        for x in range(0,img.shape[0]):
             nz=binaryImage0[x,:] != 0
             if sum(nz) > 50:
                 ref[x,:] = np.mean(im0[x,nz,:],0)
                 imr[x,:,:] = img[x,:,:] / np.tile(ref[x,:],(img.shape[1],1))

        plt.imshow(imr[:, :, (80, 52, 15)])
        
        # Reduce image to 1 section: To modify for each series of seeds
        colmin = 1000
        colmax = 3200

        # Grain detection and split close grains
        imrred=imr[:, colmin:colmax, :]
        im1 = imr[:, colmin:colmax, band]
        ret, binaryImage = cv.threshold(im1, thresh_refl, 1, cv.THRESH_BINARY)
plt.imshow(binaryImage)
plt.figure()
opening = cv.morphologyEx(binaryImage, cv.MORPH_OPEN,  np.ones((7,4),np.uint8))
plt.imshow(opening)
opening2 = cv.morphologyEx(binaryImage, cv.MORPH_OPEN, np.ones((4, 7), np.uint8))
plt.figure()
plt.imshow(opening2)

#Loop on every sample image 

 #sp = np.empty((0,img.shape[2])).astype(np.int16)
n=1
for y in range (5): #parcours les 5 lignes de notre image
    for x in range (5): #parcours les 5 colonnes de notre image
        #Ici on sélectionne le carré contenant l'échantillon qui nous intéresse 
        y_start=420*y+50
        y_end=y_start+420-0
        x_start=420*x+30
        x_end=x_start+420-60
        imrred1=imrred[y_start:y_end,x_start:x_end,:]
        plt.imshow(imrred1[:, :,band])
        plt.show()
        bin1=binaryImage[y_start:y_end,x_start:x_end]
        opening1 = cv.morphologyEx(bin1, cv.MORPH_OPEN, np.ones((4, 7), np.uint8))
        plt.imshow(opening1)
        plt.figure()
        dep = np.reshape(imrred1,(imrred1.shape[0]*imrred1.shape[1],imrred1.shape[2]))
        depbin=np.reshape(bin1,(bin1.shape[0]*bin1.shape[1]))
        sp1=dep[depbin.astype(bool)]
        sp1m=np.mean(sp1, axis=0)
        plt.plot(sp1m)
        plt.show()
        # Save Spectra
       # Enregistrer les Spectres au format CSV
        name_out = "S3W" + str(n)
        csv_file_path = PATH + name_out + "_sp.csv"
        np.savetxt(csv_file_path, sp1m, delimiter=',', header='Reflectance', comments='')
        n+=1

    

