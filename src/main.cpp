#include <iostream>
#include <fstream>
#include <string.h> 

#include "eegimage.h"
#include "lsl.h"
#include "plotprocessing.h"
#include "decoder.h"
#include "detector.h"
#include "bcisift.h"


int  eeglogger(char *filename, char *subject, int duration);

int randInt2(int low, int high)
    {
    // Random number between low and high
    return rand() % ((high + 1) - low) + low;
}

void randomSignal(double *signal, int signallength, int variance)
{
    for(int i=0;i<signallength;i++)
    {
        signal[i] = randInt2(50-variance,50+variance)-50;
    }
}

int madin(int argc, char *argv[])
{
    //std::string imagename = "HappyFish.jpg";
    //cv::Mat image = cv::imread(imagename,CV_LOAD_IMAGE_COLOR);
    //cv::Mat image(240,320,CV_8U,cv::Scalar(100));

    /**
    CV_LOAD_IMAGE_UNCHANGED (<0) loads the image as is (including the alpha channel if present)
    CV_LOAD_IMAGE_GRAYSCALE ( 0) loads the image as an intensity one
    CV_LOAD_IMAGE_COLOR (>0) loads the image in the RGB format
    **/

    //salt(image, 3000);

    srand(time(NULL));

    int option=0;

    if (argc>1)
    {
        if (strcmp(argv[1],"sift")==0)
            option = 1;
        else if (strcmp(argv[1],"surf")==0)
            option = 2;
        else if (strcmp(argv[1],"fast")==0)
            option = 3;
        else if (strcmp(argv[1],"handmade")==0)
            option = 4;
    }
    else
    {
        std::cout << "bcisift {sift|surf|fast|handmade}" << std::endl;
        return -1;
    }


       for(;;)
       {
           eegimage(0,randInt2(50-3,50+3)-50);
       }

       int fileid = 1;

       std::string c;

       char filename[256];

       sprintf(filename,"file%d.dat", fileid);
       std::ifstream infile(filename);

       infile >> c;

       int field=0;
       while (fileid<100)
       {
           //std::cout << c << std::endl;
           //eegimage(0,randInt2(50-3,50+3)-50);

           if ((field % 22)==2)
           {
                std::cout << c << std::endl;
                eegimage(4320.0F, std::stod(c));
           }
           field++;
           if (!(infile >> c))
           {
               sprintf(filename,"file%d.dat", fileid++);
               infile = std::ifstream(filename);
           }
       }
       infile.close();

    return 1;

}


void testsignals()
{
    double signal[256];
    memset(signal,0,sizeof(double)*256);
    signal[120] = signal[132] = 40;
    signal[128] = -50;
    //randomSignal(signal,256,20);

    for(int i=0;i<256;i++)
    {
        std::cout << signal[i] << std::endl;
    }

    zscore(signal,256);

    for(int i=0;i<256;i++)
    {
        std::cout << signal[i] << std::endl;
    }
}

int getMinValue(double *signal, int signallength)
{
    int pos = 0;
    double min = signal[0];

    for(int i=1;i<signallength;i++)
    {
        if (signal[i] < min)
        {
            min = signal[i];
            pos = i;
        }
    }

    return pos;
}

void clusterize(double *signal, int signallength)
{
    int pos = 0;
    double kernel[3] = {1,1,1};

    double *signcopy = new double[signallength];
    memcpy(signcopy,signal,sizeof(double)*signallength);

    for(int i=1;i<signallength-1;i++)
    {
        signal[i] = (signcopy[i-1]*kernel[0] + signcopy[i]*kernel[1] + signcopy[i+1]*kernel[2]);
    }

    delete [] signcopy;

}



/**
 * @brief main
 * @param argc
 * @param argv
 * @return
 */
int main( int argc, char **argv)
{
    if (argc < 2)
    {
        std::cout << argv[0] << " image | testclassifier | send | recv | randonline | train | online | udp | testclassify | trainclassify | testsignals | rand " << std::endl;
        return -1;
    }


    // I need first to create a signal file similar to what I use in CLAS with the same structure.
    // Then I need to read that file and allow the detection of features.
    // Then I need to read the file and use the detection and map a signal


    if (strcmp(argv[1],"detector")==0)
    {
        //bcisift(4);
        srand(time(NULL));
        // Detector Sample
        //  The detector gives me the probability on a signal segment that something interesting is happening
        //  To do so I can call the feature detector of handmadesift, pick all the extrema, build a pdf with all 
        //  of them and find the max value on the pdf.
        int N =512;
        int Fs = 256;
        double signal[N];
        memset(signal,0,sizeof(double)*N);

        randomSignal(signal,512,100);
        signal[128] = 320;
        signal[350] = signal[400] = -320;

        std::vector<int> events = detectevents(signal,512);

        memset(signal,0,sizeof(double)*N);
        for(int i=0;i<events.size();i++)
        {
            signal[events[i]] -= 200;
        }

        ploteegimage(signal,240,N,1,1,true,"plot");

        clusterize(signal,512);

        ploteegimage(signal,240,N,1,1,false,"plot2");

        int pos = getMinValue(signal,512);

        std::cout << "Event found at:" << pos << std::endl;

    }
    else
    if (strcmp(argv[1],"image")==0)
    {
        int N =256;
        int Fs = 256;
        double signal[N];
        memset(signal,0,sizeof(double)*N);
        signal[128] = 1000;
        signal[120] = signal[136] = -1200;
        //randomSignal(signal,512,20);

        ploteegimage(signal,N,240,1,1,true,"signalplot");
    }
    else if (strcmp(argv[1],"testclassifier")==0)
    {
        int words = 7;
        int charsPerWord = 5;
        int trials = words * charsPerWord;
        int timePoints = 128;

        // Each one of the segments corresponds to a row or column of the typical P300 experiment.
        int segments = 12;

        // 7 words, 5 letters, 12 repetitions / word, 128 time divisions in the signal.
        //float descr[20][128];
        float *descr = new float[trials * timePoints * segments];
        
        for(int j=0;j<trials;j++)
        {
            for(int i=0;i<6;i++)
            {
                // Class 1
                double signal[256];
                memset(signal,0,sizeof(double)*256);
                signal[120] =  2*40;
                signal[132] =  2*40;
                signal[128] = -50*2;
                xeegimagedescriptor(&descr[(j*12+i)*128],signal,256,256,1,1,true,1000+j*i);
            }

            for(int i=6;i<12;i++)
            {
                // Class 2
                double signal[256];
                memset(signal,0,sizeof(double)*256);
                signal[120] = -40;
                signal[132] = -40;
                signal[128] = -50;
                //randomSignal(signal,256,20);
                xeegimagedescriptor(&descr[(j*12+i)*128],signal,256,256,1,1,true,2000+j*i);
            }
        }

        // Segments belong to two different classes here.  Let's try to classify them.
        classify(descr, trials,3*5,4*5);

        delete [] descr;

    }
    else
    if (strcmp(argv[1],"send")==0)
    {
        sendeegandmarkers();
    }
    else if (strcmp(argv[1],"recv")==0)
    {
        receiving();
    }
    else if (strcmp(argv[1],"randonline")==0)
    {
        for(int i=0;i<256*10;i++)
        {
            eegimage(0,randInt2(50-16,50+16)-50);
            //eegimage(0,0);
        }
    }
    else if (strcmp(argv[1],"train")==0)
    {
        trainspeller();
    }
    else if (strcmp(argv[1],"online")==0)
    {
        onlinespeller();
    }
    else if (strcmp(argv[1],"udp")==0)
    {
        udp();
    }
    else if (strcmp(argv[1],"testclassify")==0)
    {
        testclassify();
    }
    else if (strcmp(argv[1],"trainclassify")==0)
    {
        trainclassify();
    }
    else if (strcmp(argv[1],"testsignals")==0)
    {
        testsignals();
    }
    else if (strcmp(argv[1],"signal")==0)
    {
        float *descr = new float[128];

        int N =256;
        int Fs = 256;
        double signal[N];
        memset(signal,0,sizeof(double)*N);
        signal[128] = 20;
        signal[120] = signal[136] = -120;
        randomSignal(signal,512,20); // @FIXME check the window size if exceeds the size of the array

        xeegimagedescriptor(&descr[0],signal,240,N,1,1,false,1);
        std::string dummy;
        std::getline(std::cin, dummy);

        printdescriptor(descr);

        for(int i=0;i<128;i++)
            printf("[%6.2f]\n", descr[i]);

    }




    return 0;
}

