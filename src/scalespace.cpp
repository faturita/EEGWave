#include <iostream>
#include <fstream>
#include <string>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <opencv2/features2d/features2d.hpp>

#include <opencv2/features2d.hpp>
#include <opencv2/xfeatures2d.hpp>




/**
 * @brief Return the subsampled ( half ) version of the provided image.
 * @param image
 * @return
 */
cv::Mat subsample(cv::Mat image)
{
    //cv::Mat featureImage(240,imagewidth,CV_8U,cv::Scalar(0));

    cv::Mat featureImage;

    cv::pyrDown( image, featureImage, cv::Size( image.cols/2, image.rows/2 ));

    //cv::imshow("Subsampled", featureImage);

    return featureImage;
}





cv::Mat scalespace(std::string name, cv::Mat image, const int imageheight, const int imagewidth, float k)
{
    cv::Mat featureImage(imageheight,imagewidth,CV_8U,cv::Scalar(0));

    float sigmao = 1.6f;
    float sigma = sigmao * k;
    float size = 8 * sigma + 1;

    std::cout << "Sigma:" << sigma << " Size:" << size << std::endl;

    // Kernel needs to be odd.
    if ( ((int)size)% 2 == 0) size+=1;

    GaussianBlur( image, featureImage, cv::Size( size, size ), sigma, sigma );

    cv::imshow(name, featureImage);

    return featureImage;
}

void setValAt(cv::Mat mask, int y, int x, int value)
{
    cv::Size s = mask.size();

    if ((0 < y && y < s.height) &&
        (0 < x && x < s.width))
    {
        mask.at<uchar>(y,x)=value;
    }
}



cv::Mat patchfromthis(cv::Mat mask, int i, int j, int value)
{
    setValAt(mask,i-1,j-1,value);
    setValAt(mask,i-1,j,value);
    setValAt(mask,i-1,j+1,value);
    setValAt(mask,i,j-1,value);
    setValAt(mask,i,j,value);
    setValAt(mask,i,j+1,value);
    setValAt(mask,i+1,j-1,value);
    setValAt(mask,i+1,j,value);
    setValAt(mask,i+1,j+1,value);

    return mask;
}

cv::Mat patchfromthis(cv::Mat mask, int i, int j)
{
    return patchfromthis(mask,i,j,1);
}

cv::Mat patch(cv::Mat tmp, int i, int j, int value)
{
    cv::Size s = tmp.size();

    cv::Mat mask(s.height,s.width,CV_8U,cv::Scalar(0));

    return patchfromthis(mask,i,j,value);
}

cv::Mat patch(cv::Mat tmp, int i, int j)
{
    return patch(tmp,i,j,1);
}

void extremascale(cv::Mat tmp, cv::Point minLoc, cv::Point maxLoc, double &minVal, double &maxVal )
{
    cv::Point minLoc2, maxLoc2;

    // We need that the patch includes both minLoc and maxLoc
    cv::Mat mask = patch(tmp, minLoc.y, minLoc.x);
    mask = patchfromthis(mask,maxLoc.y, maxLoc.x);

    cv::minMaxLoc(tmp, &minVal, &maxVal,&minLoc2 , &maxLoc2, mask);
}

bool extremascale(cv::Mat tmp, cv::Point location, double maxVal)
{
    cv::Size s = tmp.size();

    cv::Mat mask(s.height,s.width,CV_8U,cv::Scalar(0));

    double minVal; cv::Point minLoc, location2;
    double maxVal2;

    //cv::minMaxLoc(tmp, &minVal, &maxVal2,&minLoc , &location2);
    //location = location2;

    setValAt(mask,location.y-1,location.x-1,1);
    setValAt(mask,location.y-1,location.x,1);
    setValAt(mask,location.y-1,location.x+1,1);
    setValAt(mask,location.y,location.x-1,1);
    setValAt(mask,location.y,location.x,1);
    setValAt(mask,location.y,location.x+1,1);
    setValAt(mask,location.y+1,location.x-1,1);
    setValAt(mask,location.y+1,location.x,1);
    setValAt(mask,location.y+1,location.x+1,1);


    cv::minMaxLoc(tmp, &minVal, &maxVal2,&minLoc , &location2, mask);

    std::cout << maxVal << " >> MaxVal at Pyramidal Location:" << maxVal2 << std::endl ;

    return (maxVal>=maxVal2);
}

void showextrema(cv::Mat tmp, int scale)
{
    cv::Point location, minLoc;
    double maxVal, minVal;

    cv::minMaxLoc(tmp, &minVal, &maxVal,&minLoc , &location);

    std::cout << "MaxValue at scale " << scale << ":" << maxVal << std::endl ;
}

cv::Point addextrema(int octave,cv::Mat tmp, cv::Point location, double val)
{
    cv::Point extrema(0,0);

    tmp.at<uchar>(location.y,location.x) = 255;
    extrema.x = ((int)((float)location.x)*pow(2,octave-1));
    extrema.y = ((int)((float)location.y)*pow(2,octave-1));

    extrema.x = location.x;
    extrema.y = location.y;

    if (octave == 2) {extrema.x = extrema.x*2; extrema.y=extrema.y*2;}
    if (octave == 3) {extrema.x = extrema.x*4; extrema.y=extrema.y*4;}

    std::cout << octave <<  "- Max Location:" << val << " " << extrema << std::endl;

    return extrema;
}

void locatelocalextrema(int octave, cv::Mat tmp,cv::Mat up, cv::Mat down,std::vector<cv::Point> &extrema)
{
    cv::Size s = tmp.size();

    for(int i=1;i<s.height;i++)
        for (int j=1;j<s.width;j++)
        {
            if (i>=s.height || tmp.at<uchar>(i,j)==0)
                continue;

            cv::Point location, minLoc;
            double maxVal, minVal;

            cv::minMaxLoc(tmp, &minVal, &maxVal,&minLoc , &location, patch(tmp,i,j));

            double maxValUp, maxValDown;
            double minValUp, minValDown;

            extremascale(up,minLoc,location,minValUp, maxValUp);
            extremascale(down,minLoc,location,minValDown, maxValDown);

            if (minVal == 0 || maxVal == 0)
                continue;

            //if (minVal < minValDown && minVal < minValUp)
           // {
           //     extrema.push_back(addextrema(octave,tmp,minLoc,minVal));
           // }

            if (maxVal > maxValDown && maxVal > maxValUp)
            {
                std::cout << maxVal << " >> MaxVal at Pyramidal Location:" << maxValDown << "-" << maxValUp << std::endl ;
                extrema.push_back(addextrema(octave,tmp,location,maxVal));
            }
        }
}


void locateextrema(int octave, int howmany, std::string name,cv::Mat tmp, cv::Mat up, cv::Mat down, cv::Mat mask, std::vector<cv::Point> &extrema)
{
    cv::Point minLoc,maxLoc;
    double maxVal, minVal;

    cv::minMaxLoc(tmp, &minVal, &maxVal,&minLoc , &maxLoc, mask);

    double minValUp, minValDown;
    double maxValUp, maxValDown;

    // Lets check what happen with the patch upscale and downscale.
    //extremascale(up,   minLoc, maxLoc, minValUp,   maxValUp);
    //extremascale(down, minLoc, maxLoc, minValDown, maxValDown);



    //std::cout << minVal << "," << maxVal <<  " at " << minLoc << "," << maxLoc << " vs " << "[" << minValUp << "," << minValDown << "] and [" << maxValUp << "," << maxValDown << "]" << std::endl;

    //if (minVal < minValUp && minVal < minValDown)
    {
        //extrema.push_back(addextrema(octave,tmp,minLoc,minVal));
    }

    //if (maxVal > maxValUp && maxVal > maxValDown)
    {
        extrema.push_back(addextrema(octave,tmp,maxLoc,maxVal));
    }

    if (howmany == 6)
    {
        setValAt(mask,maxLoc.y,maxLoc.x,0);
        locateextrema(octave,--howmany,name,tmp,up,down,mask,extrema);
        threshold( tmp, tmp, 5, 100,0 );
        imshow(name, tmp);
    } else if (howmany > 0)
    {
        setValAt(mask,maxLoc.y,maxLoc.x,0);
        locateextrema(octave,--howmany,name,tmp,up,down,mask,extrema);
    }

    //imshow(name, tmp);

    //cv::waitKey(40000);
}


cv::Mat heatup(cv::Mat image, float threshold=20, float heat=150)
{
    cv::Size s = image.size();

    for(int y=0;y<s.height;y++)
        for (int x=0;x<s.width;x++)
        {
            if (image.at<uchar>(y,x) > threshold)
               image.at<uchar>(y,x) += heat;
        }

    return image;
}


cv::Mat grad(cv::Mat src)
{
    cv::Mat src_gray;
    cv::Mat grad;

    std::string window_name = "Sobel Demo - Simple Edge Detector";
    int scale = 1;
    int delta = 0;
    int ddepth = CV_16S;

    int c;

    if( !src.data )
    { return src; }

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

    // Returning to avoid warning, this might not be correct
    return grad;
    
}





cv::Mat findkeypoint(int octave, cv::Mat image, const int imageheight, const int imagewidth, std::vector<cv::Point> &extrema)
{
    std::vector<cv::Mat> images;
    std::vector<cv::Mat> DoG;

    std::string wtitle ( octave,'-');

    grad(image);

    // Primera octava, son 5 escalas.
    images.push_back(scalespace(wtitle + "1",image,imageheight, imagewidth, pow(2,octave-1)*pow(sqrt(2),1)/(1.6*2)));
    images.push_back(scalespace(wtitle + "2",image,imageheight, imagewidth, pow(2,octave-1)*pow(sqrt(2),2)/(1.6*2)));
    images.push_back(scalespace(wtitle + "3",image,imageheight, imagewidth, pow(2,octave-1)*pow(sqrt(2),3)/(1.6*2)));
    images.push_back(scalespace(wtitle + "4",image,imageheight, imagewidth, pow(2,octave-1)*pow(sqrt(2),4)/(1.6*2)));
    images.push_back(scalespace(wtitle + "5",image,imageheight, imagewidth, pow(2,octave-1)*pow(sqrt(2),5)/(1.6*2)));

    // As per the Lowe's paper, it is the third image from top the one who you will use to create the next octave
    cv::Mat Vnspo = images[4];

    DoG.push_back(images[1]-images[0]);
    DoG.push_back(images[2]-images[1]);
    DoG.push_back(images[3]-images[2]);
    DoG.push_back(images[4]-images[3]);

    cv::Mat tmp = DoG[1];

    showextrema(DoG[0],1);
    showextrema(DoG[1],2);
    showextrema(DoG[2],3);
    showextrema(DoG[3],4);

    //extrema.push_back(locateextrema(octave,wtitle + "at 2",tmp,DoG[0],DoG[2]));
    //extrema.push_back(locateextrema(octave,wtitle + "at 3",DoG[2],DoG[1],DoG[3]));

    cv::Mat mask(imageheight,imagewidth,CV_8U,cv::Scalar(1));

    locateextrema(octave,6,wtitle + "at 2",DoG[1],DoG[0],DoG[2], mask, extrema);
    locateextrema(octave,6,wtitle + "at 3",DoG[2],DoG[1],DoG[3], mask, extrema);

    if (extrema.size() == 0)
        exit(1);

    //locatelocalextrema(octave,tmp,DoG[0],DoG[2],extrema);
    //locatelocalextrema(octave,DoG[2],DoG[1],DoG[3],extrema);

    Vnspo = heatup(Vnspo);

    return subsample(Vnspo);
}

