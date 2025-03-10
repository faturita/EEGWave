#ifndef EEGIMAGE_H
#define EEGIMAGE_H

#include <iostream>
#include <fstream>
#include <string>

int eegimage(double avg, double data);

int eegimage(double signal[], int length, int defaultheight, int gammat, int gamma, bool normalize, int label);

int xeegimagedescriptor(float *descr,double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, int label);

int xeegimagedescriptor(float *descr,double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, std::string windowname);

void printdescriptor(float *descr);

void zscore(double *signal, int length);

int ploteegimage(double signal[], int defaultheight, int length, int gammat, int gamma, bool normalize, std::string windowname);

#endif // EEGIMAGE_H


