#ifndef SERIALIZER_H
#define SERIALIZER_H

#include "opencv2/opencv.hpp"

using namespace cv;
using namespace std;

void serializeMatbin(cv::Mat& mat, std::string filename);

cv::Mat deserializeMatbin(std::string filename);

void testSerializeMatbin();

#endif // SERIALIZER_H
