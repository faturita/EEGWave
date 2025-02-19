# EEGWave 

 export DYLD_LIBRARY_PATH=/Users/rramele/opencv/lib

This program takes a monochannel signal, a time series of doubles, and converts that signal into an image, a standardized plot.  It takes the image and use a variant of the SIFT descriptor to capture their visual shape and retuns a descriptor which represents that shape.

![SIFT](images/sift.png)
![SIFT](images/sift2.png)

It is aimed to be used in Neuroscience research and applications. This allows to search or compare against specific templates and to verify
if wavepatterns are presented in a given signal segment.

The library uses:

- OpenCV 3.4.2
- VlFeat: their fastest SIFT implementation, a modified version.
- KFR: A very fast signal processing library (c7cd3a9bcc73a10bbe0ba767d7bb6e0804ef8821)
- LSL: Labstreamlayer protocol for connecting to EEG sources (956a7137e588a4bc0c9618a4451d6ebc6b66966b)

# Usage

```
import pybcisift
import numpy as np
el = np.zeros((1,256))
el[0,23]=200
descr = pybcisift.extract(el.tolist()[0])
print(descr)
print(len(descr))
```

The list 'descr' is a SIFT^ descriptor which represents the signal shape, and can be used later for comparision.

## Mac Installation

OpenCV is tricky to install on Mac, this is the best and easier way that I found so far:

First, install brew.  Then do this

```
 brew tap homebrew/science
 brew install opencv
```
 
# Add into the .pro file

```
 LIBS += -L/usr/local/lib \
    -lopencv_core \
    -lopencv_imgproc \
    -lopencv_highgui \
    -lopencv_objdetect \
    -lopencv_calib3d

 INCLUDEPATH += /usr/local/include/opencv
```

And the most important part for Yosemite, add this into the .pro file:

```
QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.9
```

## Ubuntu Installation

# OpenCV

```
 sudo apt install -y cmake g++ wget unzip
 sudo apt install libgtk2.0-dev pkg-config
 sudo apt install clang2
 ```

Follow the guidelines from https://docs.opencv.org/master/df/d65/tutorial_table_of_content_introduction.html 
Download and unpack sources

```
 wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
 wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/master.zip
 unzip opencv.zip
 unzip opencv_contrib.zip 
 ```

```
 cd opencv-master
 mkdir -p build
 cd build
 cmake -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-master/modules ..
 cmake --build .
 sudo make install
 ```
 
# VLFeat

```
 git clone https://github.com/faturita/vlfeat
 cd vlfeat
 make DISABLE_OPENMP=yes
 ```
 
# LSL

```
 wget https://github.com/sccn/liblsl/releases/download/v1.14.0/liblsl-1.14.0-bionic_amd64.deb
 sudo dpkg -i liblsl-1.14.0-bionic_amd64.deb
 (use https://github.com/sccn/liblsl/releases/download/1.13.0/liblsl-1.13.0-Linux64-bionic.deb for ubuntu 18)
 ```
 
# BciSift

```
 export OpenCV_DIR=~/opencv-master/build
 cmake -DCMAKE_CXX_COMPILER=clang++
 ```

## Refs

* http://tilomitra.com/opencv-on-mac-osx/
* http://stackoverflow.com/questions/21811858/opencv-mac-os-x-qt-creator-strange-linking-bug
* https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/UsingDynamicLibraries.html



