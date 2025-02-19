#include <iostream>
#include <fstream>
#include <string>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/xfeatures2d.hpp>


#include <time.h>

#include "bcisift.h"
#include "plotprocessing.h"
#include "lsl.h"

int randInt(int low, int high)
    {
    // Random number between low and high
    return rand() % ((high + 1) - low) + low;
}


void salt(cv::Mat &image, int n)
{
    for(int k=0; k<n; k++)
    {
        int i = rand() % image.cols;
        int j = rand() % image.rows;

        if (image.channels() == 1) {
            // grey image
            image.at<uchar>(j,i) = 255;

        } else if (image.channels() == 3)
        {
            // (row, column)
            image.at<cv::Vec3b>(j,i)[0] = 255;
            image.at<cv::Vec3b>(j,i)[1] = 255;
            image.at<cv::Vec3b>(j,i)[2] = 255;
        }
    }
}

cv::Mat findkeypoint(int octave, cv::Mat image, const int imageheight, const int imagewidth, std::vector<cv::Point> &extrema);

const int thresh = 20;



result handmadesift(cv::Mat image, const int imageheight, const int imagewidth, const int numOctaves, std::vector<int> event)
{
    cv::Mat Vnspo=image;

    std::vector<cv::Point> extrema;
    cv::Scalar color(255,255,255);

    int hits=0;

    for(int octaves=1;octaves<numOctaves+1;octaves++)
    {
        Vnspo = findkeypoint(octaves, Vnspo, imageheight/pow(2,octaves-1), imagewidth/pow(2,octaves-1), extrema);

        for(unsigned int i=0;i<extrema.size();i++)
        {
            if (extrema[i].x > 0 && extrema[i].y > 0)
            {
                std::cout << "Extrema[" << i << "]:" << extrema[i] << std::endl;
                double radi=10;
                cv::circle(image,extrema[i],radi,color);

                for(unsigned int k=0;k<event.size();k++)
                {
                    if ( ((event[k]-thresh)<extrema[i].y) && (extrema[i].y<event[k]+thresh) )
                    {
                        hits++;
                    }
                }
            }
        }
    }

    std::cout << "Size:" << extrema.size() << std::endl;

    cv::imshow("handMadeSift", image);

    //cv::imwrite("handmadesift.png", image);

    result r;

    r.hits = hits;
    r.size = extrema.size();

    return r;
}

result featuredetector(cv::Mat image, const int imageheight, const int imagewidth, std::vector<int> event)
{
    // This is the full image
    cv::Mat featureImage(imageheight,imagewidth,CV_8U,cv::Scalar(0));
    std::vector<cv::KeyPoint> keypoints;

    /**
    cv::FastFeatureDetector fast(40);
    fast.detect(image,keypoints);

    **/

    cv::FAST(image,keypoints, 40,true );

    cv::drawKeypoints( image,
                       keypoints,
                       featureImage,
                       cv::Scalar(255,255,255),
                       cv::DrawMatchesFlags::DRAW_RICH_KEYPOINTS);

    int hits=0;
    for(unsigned int p=0;p<event.size();p++)
    {
        for(unsigned int k=0;k<keypoints.size();k++)
        {
            if ( ((event[p]-thresh)<keypoints[k].pt.y) && (keypoints[k].pt.y<event[p]+thresh) )
            {
                hits++;
            }
        }
    }

    cv::imshow("FAST", featureImage);
    cv::imwrite("fast.png", featureImage);

    result r;

    r.hits = hits;
    r.size = keypoints.size();

    return r;
}

result surf(cv::Mat image, const int imageheight, const int imagewidth, std::vector<int> event)
{
    // This is the full image
    cv::Mat featureImage(imageheight,imagewidth,CV_8U,cv::Scalar(0));
    std::vector<cv::KeyPoint> keypoints;

/**
    cv::SurfFeatureDetector surf(2500.);
    surf.detect(image,keypoints);
    **/

    cv::Ptr<cv::xfeatures2d::SURF> detector = cv::xfeatures2d::SURF::create(400);

    detector->detect( image, keypoints);

    cv::drawKeypoints( image,
                       keypoints,
                       featureImage,
                       cv::Scalar(255,255,255),
                       cv::DrawMatchesFlags::DRAW_RICH_KEYPOINTS);

    int hits=0;
    for(int p=0;p<event.size();p++)
    {
        for(int k=0;k<keypoints.size();k++)
        {
            if ( ((event[p]-thresh)<keypoints[k].pt.y) && (keypoints[k].pt.y<event[p]+thresh) )
            {
                hits++;
            }
        }
    }


    cv::imshow("SURF", featureImage);
    cv::imwrite("surf.png",featureImage);

    result r;

    r.hits = hits;
    r.size = keypoints.size();

    return r;
}

result sift(cv::Mat image, const int imageheight, const int imagewidth, int edgeresponse, std::vector<int> event)
{
    // This is the full image
    cv::Mat featureImage(imageheight,imagewidth,CV_8U,cv::Scalar(0));
    std::vector<cv::KeyPoint> keypoints;

    /**
    cv::SiftFeatureDetector sift(0.03,edgeresponse);
    sift.detect(image,keypoints);

    **/

    //(int nfeatures=0, int nOctaveLayers=3, double contrastThreshold=0.04, double edgeThreshold=10, double sigma=1.6)
    cv::Ptr<cv::SIFT> detector = cv::SIFT::create(0,70,0.04,2,1.6);

    detector->detect( image, keypoints);


    cv::drawKeypoints( image,
                       keypoints,
                       featureImage,
                       cv::Scalar(255,255,255),
                       cv::DrawMatchesFlags::DRAW_RICH_KEYPOINTS);

    cv::imshow("SIFT", featureImage);
    cv::imwrite("sift.png",featureImage);

    int hits=0;
    for(unsigned int p=0;p<event.size();p++)
    {
        std::cout << "Event at:" << event[p] << std::endl;
        for(unsigned int k=0;k<keypoints.size();k++)
        {
            std::cout <<  "Event:" << event[p]-thresh << std::endl;
            std::cout  << "Keypoint:" <<  keypoints[k].pt.x << std::endl;
            std::cout <<  "Event:" << event[p]+thresh << std::endl;
            if ( ((event[p]-thresh)<keypoints[k].pt.x) && (keypoints[k].pt.x<(event[p]+thresh)) )
            {
                hits++;
                std::cout << "Hit!" << std::endl;
            }
        }
    }

    std::cout << "Hits:" << hits;

    //if (hits>0)
    //{
    //    cv::waitKey(20000);
    //    exit(1);
    //}

    result r;

    r.hits = hits;
    r.size = keypoints.size();

    return r;
}

int bcisift(int option)
{
    const int imagewidth = 320;
    const int imageheight= 240;

    const int numOctaves = 2;

    const int timestep = 10;

    std::vector<int> event;

    int err=0;
    int autotest=0;

    char logfilename[256];

    int edgeresponse=10;

    // 1 La imagen queda igual
    // 2 La imagen se ajusta a toda la pantalla y se resizea.
    cv::namedWindow("BrainWaves",2);

    cv::Point pt1(1,100);
    cv::Point pt2(10,100);

    int idx = 2;

    cv::Mat image(imageheight,imagewidth,CV_8U,cv::Scalar(0));
    cv::Scalar color(255,255,255);

    static int delta=0;
    static double psd=0;
    static int times=0;

    for(;;)
    {

        cv::line(image, pt1, pt2,color);

        int key = cv::waitKey(30);

        switch (key)
        {
            case 13:
                while ( cv::waitKey(1000) != 13);
                break;
            case '-':
                err-=1;
                break;
            case '+':
                err+=1;
                break;
            case 'w':
                edgeresponse+=1;
                break;
            case 's':
                edgeresponse-=1;
                break;
            case 't':
                autotest=1;
                break;
            case 27:
                return 1;
                break;
        }

        if (!(0 < err && err<=50))
            err=0;

        if (!(0 < edgeresponse && edgeresponse<=90))
            edgeresponse=0;

        // Must have the same window name.
        cv::imshow("BrainWaves", image);


        pt1=pt2;

        if (delta>0 || randInt(0,10) == 5)
        {
            int p300[] = {0,0,-5,10,30,25,10,5,0,0,0};

            psd+=p300[delta];

            cv::Point pt3(idx+=timestep,100+p300[delta++]);
            pt2=pt3;

            if (delta==5) event.push_back(idx);
            if (delta>=11) delta=0; //Reset

            times++;
        } else
        {

            cv::Point pt3(idx+=timestep,100+randInt(50-err,50+err)-50);
            pt2=pt3;
        }

        if (idx>=imagewidth)
        {
            result r;

            cv::imwrite("base.png", image);


            switch (option)
            {
            case 1:
                r=sift(image, imageheight, imagewidth, edgeresponse, event);
                strcpy(logfilename,"sift");
                break;
            case 2:
                r=surf(image, imageheight, imagewidth, event);
                strcpy(logfilename,"surf");
                break;
            case 3:
                r=featuredetector(image, imageheight, imagewidth, event);
                strcpy(logfilename,"fast");
                break;
            default:
                r=handmadesift(image, imageheight, imagewidth, numOctaves, event);
                strcpy(logfilename,"handmade");
            }

            std::cout << "-------------" << std::endl;

            cv::Mat image2(imageheight,imagewidth,CV_8U,cv::Scalar(0));
            image = image2;

            idx=3;
            cv::Point pt4(1,100);
            cv::Point pt5(1+timestep,100);

            pt1=pt4;
            pt2=pt5;

            std::cout << event.size() << ":" << "SNR:" << (times*1.0)/(err+1) << "/" << r.hits << std::endl;

            if (autotest>0)
            {
                std::ofstream myfile;
                myfile.open (logfilename, std::ios::app | std::ios::out);
                myfile << (times*1.0)/(err+1) << " " << r.size << " " << r.hits << std::endl;
                myfile.close();
            }

            times=0;psd=0;

            event.clear();

            if (autotest>0)
            {
                autotest++;

                if (autotest % 100 == 0)
                {
                    err+=1;
                }

                if (err>=49)
                {
                    err=0;
                    autotest=0;
                    exit(1);
                }
            }


        }


        // Use me to log the time "t" (y position)
        //std::cout << idx << std::endl;



    }

    //cv::imwrite("output.png", image);

    return 1;
}

// https://stackoverflow.com/questions/46936341/svm-predict-on-opencv-how-can-i-extract-the-same-number-of-features

int showLine(std::string imagename)
{
   cv::namedWindow("BrainWaves",1);

   cv::Point pt1(100,100);
   cv::Point pt2(150,100);
   cv::Mat image(240,320,CV_8U,cv::Scalar(0));
   cv::Scalar color(255,255,255);

   cv::line(image, pt1, pt2,color);


   if(! image.data )                              // Check for invalid input
   {
       std::cout <<  "Could not open or find the image " << imagename << std::endl ;
       return -1;
   }


   std::cout << "size:" << image.size().height << " , " << image.size().width << std::endl;


   cv::imshow("My IMage", image);



   cv::waitKey(5000);

   return 1;

}

/** @function main */
int sobelmain( int argc, char** argv )
{

  cv::Mat src, src_gray;
  cv::Mat grad;
  std::string window_name = "Sobel Demo - Simple Edge Detector";
  int scale = 1;
  int delta = 0;
  int ddepth = CV_16S;

  /// Load an image
  src = cv::imread( argv[1] );

  if( !src.data )
  { return -1; }

  cv::GaussianBlur( src, src, cv::Size(3,3), 0, 0, cv::BORDER_DEFAULT );

  /// Convert it to gray
  cv::cvtColor( src, src_gray, cv::COLOR_BGR2GRAY );

  /// Create window
  cv::namedWindow( window_name, cv::WindowFlags::WINDOW_AUTOSIZE );

  /// Generate grad_x and grad_y
  cv::Mat grad_x, grad_y;
  cv::Mat abs_grad_x, abs_grad_y;

  /// Gradient X
  //Scharr( src_gray, grad_x, ddepth, 1, 0, scale, delta, BORDER_DEFAULT );
  cv::Sobel( src_gray, grad_x, ddepth, 1, 0, 3, scale, delta, cv::BORDER_DEFAULT );
  convertScaleAbs( grad_x, abs_grad_x );

  /// Gradient Y
  //Scharr( src_gray, grad_y, ddepth, 0, 1, scale, delta, BORDER_DEFAULT );
  cv::Sobel( src_gray, grad_y, ddepth, 0, 1, 3, scale, delta, cv::BORDER_DEFAULT );
  convertScaleAbs( grad_y, abs_grad_y );

  /// Total Gradient (approximate)
  addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );

  imshow( window_name, grad );

  cv::waitKey(0);

  return 0;
  }



int bcisiftmain(int argc, char *argv[])
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

    //QTime time = QTime::currentTime();
    //qsrand((uint)time.msec());

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

    return bcisift(option);

}
