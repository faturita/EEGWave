#ifndef BCISIFT_H
#define BCISIFT_H


struct result
{
    int size;
    int hits;
};

result sift(cv::Mat image, const int imageheight, const int imagewidth, int edgeresponse, std::vector<int> event);

#endif // BCISIFT_H