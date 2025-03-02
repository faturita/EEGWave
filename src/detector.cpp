#include <iostream>
#include <vector>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/xfeatures2d.hpp>

#include <opencv2/features2d/features2d.hpp>

#include "eegimage.h"
#include "bcisift.h"
#include "detector.h"

std::vector<int> detectevents(double signal[], int length)
{

    int height;
    int width;
    int zerolevel;

    cv::Mat image;

    int defaultheight = 240;
    int gammat = 1;
    int gamma = 1;
    bool normalize = true;
    std::string windowname = "signalplot";

    eegimage(image, height, width, zerolevel,signal,defaultheight, length, gammat, gamma, normalize, windowname);

    int numOctaves = 2;
    int imageheight = height;
    int imagewidth = width;

    std::vector<int> events = scaledetector(image,  imageheight,  imagewidth, numOctaves);

    for(int i=0;i<events.size();i++)
    {
        std::cout << "Event found at:" << events[i] << std::endl;
    }

    std::string ext = ".png";
    cv::imwrite(windowname + ext, image );

    return events;
}