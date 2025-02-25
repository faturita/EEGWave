OPENCV_DIR=$(OpenCV_DIR)
CC = g++
CFLAGS = -O3 -std=c++17 -w -g -Wall -I/usr/include -I/opt/local/include/  -fpermissive -I$(OPENCV_DIR)/include/opencv4/
PROG = eegwave

SRCSC = src/generic.c src/host.c src/imopv.c src/mathop.c src/random.c  src/sift.c 
SRCSCPP = src/bcisift.cpp src/serializer.cpp src/decoder.cpp src/lsl.cpp src/lsltransmitter.cpp src/plotprocessing.cpp src/scalespace.cpp src/unp.cpp src/eegimage.cpp src/main.cpp 

OBJSC 	= $(SRCSC:.c=.o)
OBJSCPP	= $(SRCSCPP:.cpp=.o)

ifeq ($(shell uname),Darwin)
	LIBS = -L/opt/local/lib/ -L/usr/local/lib -L$(OPENCV_DIR)/lib/ -lpthread -framework CoreMIDI -framework CoreFoundation -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_features2d -lopencv_xfeatures2d -lopencv_calib3d -lopencv_imgcodecs -lopencv_ml -lopencv_flann -llsl
else
	CFLAGS=$(CFLAGS) -fPIC
	LIBS = -L/usr/local/lib -L/usr/lib/x86_64-linux-gnu/ -L$(OPENCV_DIR)/lib/ -pthread -lbsd -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_features2d -lopencv_xfeatures2d -lopencv_calib3d -lopencv_imgcodecs -lopencv_ml -lopencv_flann -llsl
endif

all: $(PROG)

$(PROG):	$(OBJSC) $(OBJSCPP)
	@echo "Object files are $(OBJS)"
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
	@echo "export DYLD_LIBRARY_PATH=$(OPENCV_DIR)/lib"

.cpp.o:		$(SRCSC)
	$(CC) $(CFLAGS) -c $< -o $@

.c.o:		$(SRCSCPP)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(PROG)
	@echo "Object files are $(OBJSC) $(OBJSCPP)"
	rm -f $(OBJSC)
	rm -f $(OBJSCPP)
	rm -f pyeegwave/libvl.so
	rm -rf $(PROG).dSYM
	rm -rf pyeegwave/__pycache__
	rm -rf pyeegwave/*.pyc
	rm -rf pyeegwave/build 
	rm -rf pyeegwave/dist
	rm -rf pyeegwave/*.egg-info


libshared:	$(OBJSC)
	@echo "Building shared library"
	$(CC) $(CFLAGS) -shared -o pyeegwave/libvl.so $^ $(LIBS)

#testcase:	$(TCOBJS)
#	@echo "Building test cases"
#	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)


