from distutils.core import setup, Extension

import os

OpenCV_DIR = os.environ['OpenCV_DIR']

print('OpenCV_DIR:', OpenCV_DIR)

OPENCV_LIB = OpenCV_DIR + '/lib'
OPENCV_INCLUDE = OpenCV_DIR + '/include/opencv4/'

module1 = Extension('pyeegwave',
                    include_dirs = [
                    '/usr/local/include',
                    '/usr/local/include/opencv4/',
                    OPENCV_INCLUDE,
                    '/opt/local/include/',
                    '../src/',
                    ],
                    libraries = [
                    'opencv_core',
                    'opencv_highgui',
                    'opencv_imgproc',
                    'opencv_features2d',
                    'opencv_xfeatures2d',
                    'opencv_calib3d',
                    'opencv_imgcodecs',
                    'opencv_ml',
                    'opencv_flann',
                    'lsl',
                    'vl'],
                    library_dirs = ['/usr/local/lib',
                    OPENCV_LIB,
                    '/opt/local/lib','.'
                    ],
                    sources = ['pyeegwave.cpp',
                    '../src/eegimage.cpp',
                    '../src/scalespace.cpp',
                    '../src/plotprocessing.cpp',
                    '../src/lsl.cpp',
                    '../src/lsltransmitter.cpp',
                    '../src/decoder.cpp',
                    '../src/serializer.cpp',
                    '../src/unp.cpp'],
                    extra_compile_args=['-std=c++17'],
                    )

setup (name = 'pyeegwave',
       version = '1.0',
       description = 'EEGWave Routine for python',
       author = 'faturita',
       author_email = 'rramele@gmail.com',
       url = 'https://docs.python.org/extending/building',
       long_description = '''
Get a SIFT (HIST) descriptor from a signal
''',
       ext_modules = [module1])
