#include "opencv2/opencv.hpp"

using namespace cv;
using namespace std;

/*
Will save in the file:
cols\n
rows\n
elemSize\n
type\n
DATA
*/
void serializeMatbin(cv::Mat& mat, std::string filename){
    if (!mat.isContinuous()) {
        std::cout << "Not implemented yet" << std::endl;
        exit(1);
    }

    int elemSizeInBytes = (int)mat.elemSize();
    int elemType        = (int)mat.type();
    int dataSize        = (int)(mat.cols * mat.rows * mat.elemSize());

    FILE* FP = fopen(filename.c_str(), "wb");
    int sizeImg[4] = {mat.cols, mat.rows, elemSizeInBytes, elemType };
    fwrite(/* buffer */ sizeImg, /* how many elements */ 4, /* size of each element */ sizeof(int), /* file */ FP);
    fwrite(mat.data, mat.cols * mat.rows, elemSizeInBytes, FP);
    fclose(FP);
}

cv::Mat deserializeMatbin(std::string filename){
    FILE* fp = fopen(filename.c_str(), "rb");

    if (fp == NULL)
    {
        cout << "File do not exist." << std::endl;
        exit(-1);
    }

    int header[4];
    fread(header, sizeof(int), 4, fp);
    int cols            = header[0];
    int rows            = header[1];
    int elemSizeInBytes = header[2];
    int elemType        = header[3];

    //std::cout << "rows="<<rows<<" cols="<<cols<<" elemSizeInBytes=" << elemSizeInBytes << std::endl;

    cv::Mat outputMat = cv::Mat::ones(rows, cols, elemType);

    size_t result = fread(outputMat.data, elemSizeInBytes, (size_t)(cols * rows), fp);

    if (result != (size_t)(cols * rows)) {
        fputs ("Reading error", stderr);
    }

    //std::cout << ((float*)outputMat.data)[200] << std::endl;

    fclose(fp);
    return outputMat;
}

void testSerializeMatbin(){
    cv::Mat a = cv::Mat::ones(/*cols*/ 10, /* rows */ 5, CV_32F) * -2;
    std::string filename = "test.matbin";
    serializeMatbin(a, filename);
    cv::Mat b = deserializeMatbin(filename);
    std::cout << "Rows: " << b.rows << " Cols: " << b.cols << " type: " << b.type()<< std::endl;
}
