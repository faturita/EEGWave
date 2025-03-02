#ifndef BCISIFT_H
#define BCISIFT_H


struct result
{
    int size;
    int hits;
};

std::vector<int> scaledetector(cv::Mat image, const int imageheight, const int imagewidth, const int numOctaves);

int bcisift(int option);

#endif // BCISIFT_H