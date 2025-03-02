#ifndef EEGIMAGE_H
#define EEGIMAGE_H

#include <iostream>
#include <fstream>
#include <string>
#include <opencv2/core/core.hpp>

int eegimage(double avg, double data);

int eegiamage(double avg, double datapoint);

int eegimage(double signal[], int length, int defaultheight, int gammat, int gamma, bool normalize, int label);

int eegimage(cv::Mat &image, int &height, int &width, int &zerolevel, double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, std::string windowname);

int xeegimagedescriptor(float *descr,double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, int label);

int xeegimagedescriptor(float *descr,double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, std::string windowname);

void printdescriptor(float *descr);

void zscore(double *signal, int length);

int ploteegimage(double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, std::string windowname);

#endif // EEGIMAGE_H


