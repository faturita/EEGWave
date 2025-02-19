#include <iostream>
#include <fstream>
#include <string>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <opencv2/features2d/features2d.hpp>

#include <opencv2/features2d.hpp>
#include <opencv2/xfeatures2d.hpp>

#include <opencv2/ml.hpp>


#include "serializer.h"
#include "spellerletter.h"

using namespace cv::ml;


std::vector<int> readlabels(int subject)
{
    char filename[256];
    sprintf(filename, "labelrange%d.csv", subject);

    std::ifstream inputfile(filename);
    std::string current_line;
    // vector allows you to add data without knowing the exact size beforehand
    std::vector<int>  all_data;
    // Start reading lines as long as there are lines in the file
    while(std::getline(inputfile, current_line)){
       // Now inside each line we need to seperate the cols
       std::stringstream temp(current_line);
       std::string single_value;
       while(std::getline(temp,single_value,',')){
            // convert the string element to a integer value
            all_data.push_back(atoi(single_value.c_str()));
       }
    }

    return all_data;
}

/**
void readtable()
{
    std::ifstream inputfile("labels.csv");
    std::string current_line;
    // vector allows you to add data without knowing the exact size beforehand
    std::vector< vector<int> > all_data;
    // Start reading lines as long as there are lines in the file
    while(std::getline(inputfile, current_line)){
       // Now inside each line we need to seperate the cols
       std::vector<int> values;
       std::stringstream temp(current_line);
       std::string single_value;
       while(std::getline(temp,single_value,',')){
            // convert the string element to a integer value
            values.push_back(atoi(single_value.c_str()));
       }
       // add the row to the complete data vector
       all_data.push_back(values);
    }

    // Now add all the data into a Mat element
    Mat vect = Mat::zeros((int)all_data.size(), (int)all_data[0].size(), CV_8UC1);
    // Loop over vectors and add the data
    for(int rows = 0; row < (int)all_data.size(); rows++){
       for(int cols= 0; cols< (int)all_data[0].size(); cols++){
          vect.at<uchar>(rows,cols) = all_data[rows][cols];
       }
    }
}**/



cv::Mat processplot(char *filename)
{
    cv::Mat src;
    std::vector<cv::KeyPoint> keypoints;
    cv::Mat descriptors;

    //infile = std::ifstream(filename);
    src = cv::imread( filename );

    if( !src.data )
    {
        printf("Error!\n");
        return descriptors; }

    cv::Ptr<cv::SIFT> detector = cv::SIFT::create(0,70,0.04,2,1.6);

    detector->detect( src, keypoints);

    detector->compute(src,keypoints,descriptors);

    return descriptors;
}

int inline pickrow(cv::flann::Index flann_index,std::vector<cv::Mat> TM, int baseindex)
{
    std::vector<double> sum;

    for(int index=0;index<6;index++)
    {
        cv::Mat query = TM[baseindex+index];
        cv::Mat indices, dists; //neither assume type nor size here !
        double radius= 2.0;

        //flann_index.radiusSearch(query, indices, dists, radius, max_neighbours,cv::flann::SearchParams(32));

        flann_index.knnSearch(query, indices, dists, 1,cv::flann::SearchParams(32) );

        printf("Indices: %d, %d\n", indices.size().width, indices.size().height);

        printf("Dists: %d, %d\n", dists.size().width, dists.size().height);


        printf("Dist:%f\n", cv::sum( dists )[0]);

        sum.push_back(cv::sum( dists )[0]);
    }
    printf("Classes %lu\n", sum.size());

    int min=0;
    double minvalue=sum[0];
    for(int index=1;index<6;index++)
    {
        if (sum[index]<=minvalue)
        {
            min = index;
            minvalue = sum[index];
        }
    }
    return min;
}

void process()
{

    char filename[256];
    int subject[8]={ 1,11,14,16,17,20,22,23};

    for(int s=0;s<8;s++)
    {
        std::vector<cv::Mat> M;
        cv::Mat trainingVector;
        cv::Mat labelMat;
        cv::Mat hits;
        std::vector<int> labels = readlabels(subject[s]);
        for(int e=1;e<=180;e++)
        {
            for(int c=1;c<=1;c++)
            {
                int l=labels[e-1];
                /// Load an image
                sprintf(filename,"./Plots/s.%d.e.%d.l.%d.c.%d.tif",subject[s],e,l,c);
                printf("Processing %d.%d.%d.%d:%s\n",subject[s],e,l,c,filename);
                cv::Mat descriptors = processplot(filename);
                trainingVector.push_back(descriptors);
                for(int i=0;i<descriptors.size().height;i++)
                {
                    labelMat.push_back(l);
                }
                M.push_back(descriptors);

                if (l==2)
                {
                    hits.push_back(descriptors);
                }


            }
        }

        cv::Mat testVector;
        cv::Mat expectedLabelMat;
        std::vector<cv::Mat> TM;
        cv::Mat testLabel;
        for(int e=181;e<=420;e++)
        {
            for(int c=1;c<=1;c++)
            {
                int l=labels[e-1];
                /// Load an image
                sprintf(filename,"./Plots/s.%d.e.%d.l.%d.c.%d.tif",subject[s],e,l,c);
                printf("Processing %d.%d.%d.%d:%s\n",subject[s],e,l,c,filename);
                cv::Mat descriptors = processplot(filename);
                assert( descriptors.size().height > 0);
                testVector.push_back(descriptors);
                for(int i=0;i<descriptors.size().height;i++)
                {
                    expectedLabelMat.push_back(l);
                }
                M.push_back(descriptors);

                TM.push_back(descriptors);
                testLabel.push_back(l);
            }
        }

        cv::Ptr<SVM> svm = SVM::create();
        svm->setType(SVM::C_SVC);
        svm->setKernel(SVM::LINEAR);
        svm->setTermCriteria(cv::TermCriteria(cv::TermCriteria::MAX_ITER, 100, 1e-6));


        printf("Size: %d, %d\n", trainingVector.size().width, trainingVector.size().height);
        printf("Size: %d, %d\n", labelMat.size().width, labelMat.size().height);

        printf("Size: %d, %d\n", trainingVector.row(0).size().width, trainingVector.row(0).size().height);

        svm->train(trainingVector, ROW_SAMPLE, labelMat);

        int accuracies=0;

        for(int i=0;i<240;i++)
        {
            printf("%d\n",i);
            printf("Size: %d, %d\n", testVector.row(i).size().width, testVector.row(i).size().height);
            float response = svm->predict(testVector.row(i));
            int expected = expectedLabelMat.at<int>(0,i);
            printf("Expected vs Predicted %d vs %10.6f\n", expected,response);


            if (response==expected) accuracies++;

        }


        printf ("Success %10.6f\n", (float)accuracies/240);


        //cv::Boost boost;
        //2. Train it with 100 features
        //boost.train(cv::BoostParams(CvBoost::REAL, 100, 0, 1, false, 0), false);



        // Clasificar usando NBNN 6 vs 6.
        // Tomar los descriptores de M y primero armar el template set.
        // Luego tomar los descriptores de test, que deberian ser 20x12=240 x qKS
        // Donde qKS es la cantidad de descriptores extraído de cada imagen.

        //cv::FlannBasedMatcher matcher;
        //std::vector< DMatch > matches;
        //matcher.match( descriptors_1, descriptors_2, matches );

        cv::flann::Index flann_index(hits, cv::flann::KDTreeIndexParams(1));

        cv::Mat predictedLabelMat;

        for(int baseindex=0;baseindex<240;)
        {
            int row=-1;
            {
                std::vector<double> sum;

                for(int index=0;index<6;index++)
                {
                    cv::Mat query = TM[baseindex+index];
                    cv::Mat indices, dists; //neither assume type nor size here !
                    double radius= 2.0;

                    //flann_index.radiusSearch(query, indices, dists, radius, max_neighbours,cv::flann::SearchParams(32));

                    flann_index.knnSearch(query, indices, dists, 1,cv::flann::SearchParams(32) );

                    printf("Indices: %d, %d\n", indices.size().width, indices.size().height);

                    printf("Dists: %d, %d\n", dists.size().width, dists.size().height);


                    printf("Dist:%f\n", cv::sum( dists )[0]);

                    sum.push_back(cv::sum( dists )[0]);
                }
                printf("Classes %lu\n", sum.size());

                int min=0;
                double minvalue=sum[0];
                for(int index=1;index<6;index++)
                {
                    if (sum[index]<=minvalue)
                    {
                        min = index;
                        minvalue = sum[index];
                    }
                }
                row = min;
            }

            printf("Row:%d\n",row);

            baseindex+=6;

            int col=-1;
            {
                std::vector<double> sum;

                for(int index=0;index<6;index++)
                {
                    cv::Mat query = TM[baseindex+index];
                    cv::Mat indices, dists; //neither assume type nor size here !
                    double radius= 2.0;

                    //flann_index.radiusSearch(query, indices, dists, radius, max_neighbours,cv::flann::SearchParams(32));

                    flann_index.knnSearch(query, indices, dists, 1,cv::flann::SearchParams(32) );

                    printf("Indices: %d, %d\n", indices.size().width, indices.size().height);

                    printf("Dists: %d, %d\n", dists.size().width, dists.size().height);


                    printf("Dist:%f\n", cv::sum( dists )[0]);

                    sum.push_back(cv::sum( dists )[0]);
                }
                printf("Classes %lu\n", sum.size());

                int min=0;
                double minvalue=sum[0];
                for(int index=1;index<6;index++)
                {
                    if (sum[index]<=minvalue)
                    {
                        min = index;
                        minvalue = sum[index];
                    }
                }
                col = min;
            }
            printf("Col:%d\n",col);

            baseindex+=6;

            for(int i=0;i<6;i++)
            {
                if (row==i) predictedLabelMat.push_back(2);
                        else predictedLabelMat.push_back(1);
            }

            for(int i=0;i<6;i++)
            {
                if (col==i) predictedLabelMat.push_back(2);
                        else predictedLabelMat.push_back(1);
            }


        }

        accuracies=0;

        for(int i=0;i<240;i++)
        {
            int predicted = predictedLabelMat.at<int>(0,i);
            int expected = expectedLabelMat.at<int>(0,i);
            printf("Expected vs Predicted %d vs %d\n", expected,predicted);


            if (predicted==expected) accuracies++;

        }

        printf ("Success %10.6f\n", (float)accuracies/240);

        std::ofstream f("experiment.log",std::ofstream::out | std::ofstream::app);
        f <<  (float)accuracies/240 << std::endl;
        f.close();


        accuracies=0;

        for(int i=0;i<240;)
        {
            int exprow,expcol,predrow,predcol;

            for(int j=0;j<6;j++)
            {
                int predicted = predictedLabelMat.at<int>(0,i);
                int expected = expectedLabelMat.at<int>(0,i);

                if (predicted==2) predrow=j;
                if (expected==2)  exprow=j;
                i++;
            }

            for(int j=0;j<6;j++)
            {
                int predicted = predictedLabelMat.at<int>(0,i);
                int expected = expectedLabelMat.at<int>(0,i);

                if (predicted==2) predcol=j;
                if (expected==2)  expcol=j;
                i++;
            }



            if (predrow==exprow && predcol==expcol) accuracies++;

        }

        printf ("Performance %10.6f\n", (float)accuracies/240);

        std::ofstream fs("performance.log",std::ofstream::out | std::ofstream::app);
        fs <<  (float)accuracies/240 << std::endl;
        fs.close();

   /**     1 # create BFMatcher object
        2 bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
        3
        4 # Match descriptors.
        5 matches = bf.match(des1,des2)
        6
        7 # Sort them in the order of their distance.
        8 matches = sorted(matches, key = lambda x:x.distance)
        9
       10 # Draw first 10 matches.
       11 img3 = cv2.drawMatches(img1,kp1,img2,kp2,matches[:10], flags=2)
       **/

    }

}

void comparesignals(int subject1, int epoch1, int label1, int channel1, int subject2, int epoch2, int label2, int channel2)
{
    bool wait = false;
    cv::Mat src1;
    std::vector<cv::KeyPoint> keypoints1;

    char filename[256];

    /// Load an image
    sprintf(filename,"/Users/rramele/Data/Plots/s.%d.e.%d.l.%d.c.%d.tif",subject1,epoch1,label2,channel1);
    src1 = cv::imread( filename );

    if( !src1.data )
    {
        printf("File not found:%s\n",filename);
        return;
    }

    cv::Mat featureImage1(src1.size().height,src1.size().width,CV_8U,cv::Scalar(0));


    /**
    https://docs.opencv.org/3.2.0/d5/d3c/classcv_1_1xfeatures2d_1_1SIFT.html
    static Ptr<SIFT> cv::SIFT::create	(	int 	nfeatures = 0,
    int 	nOctaveLayers = 3,
    double 	contrastThreshold = 0.04,
    double 	edgeThreshold = 10,
    double 	sigma = 1.6
    )	**/


    cv::Ptr<cv::SIFT> detector = cv::SIFT::create(0,70,0.04,2,1.6);

    //cv::Ptr<cv::SIFT> detector = cv::SIFT::create();

    detector->detect( src1, keypoints1);
    cv::drawKeypoints( src1,
                       keypoints1,
                       featureImage1,
                       cv::Scalar(255,255,255),
                       cv::DrawMatchesFlags::DRAW_RICH_KEYPOINTS);

    if (wait)
    {
        cv::imshow("Image 1", featureImage1);
        cv::waitKey(0);
    }


    sprintf(filename,"/Users/rramele/Data/Plots/s.%d.e.%d.l.%d.c.%d.tif",subject2,epoch2,label2,channel2);
    cv::Mat src2 = cv::imread( filename );

    std::vector<cv::KeyPoint> keypoints2;

    cv::Mat descriptors1, descriptors2;

    detector->detect( src2, keypoints2);

    cv::Mat featureImage2(src2.size().height,src2.size().width,CV_8U,cv::Scalar(0));

    cv::drawKeypoints( src2,
                       keypoints2,
                       featureImage2,
                       cv::Scalar(255,255,255),
                       cv::DrawMatchesFlags::DRAW_RICH_KEYPOINTS);

    if (wait)
    {
        cv::imshow("Image 2", featureImage2);
        cv::waitKey(0);
    }

    // Get descriptors and run matching...

    detector->compute(src1,keypoints1,descriptors1);
    detector->compute(src2,keypoints2,descriptors2);

    printf("Descriptors Image 1: Size: %d, %d\n", descriptors1.size().width, descriptors1.size().height);
    printf("Descriptors Image 2: Size: %d, %d\n", descriptors2.size().width, descriptors2.size().height);


    std::vector<cv::DMatch> matches;

    cv::BFMatcher bf = cv::BFMatcher(cv::NORM_L2);

    bf.match(descriptors1,descriptors2, matches);

    cv::Mat matchimg;

    cv::drawMatches(src1,keypoints1,src2,keypoints2,matches,matchimg);

    if (wait)
    {
        cv::imshow("Matching", matchimg);
        cv::waitKey(0);
    }

    std::vector<int> compression_params;
    compression_params.push_back(cv::IMWRITE_PNG_COMPRESSION);
    compression_params.push_back(9);

    try {
        printf ("Saving image to matching.png\n");
        sprintf(filename, "matching-s.%d.e.%d.l.%d.c.%d-s.%d.e.%d.l.%d.c.%d.png",subject1,epoch1,label1,channel1,subject2,epoch2,label2,channel2);
        cv::imwrite(filename, matchimg, compression_params);
    }
    catch (std::runtime_error& ex) {
        fprintf(stderr, "Exception converting image to PNG format: %s\n", ex.what());
        return;
    }

}


void comparehits()
{
    for(int s=1;s<=1;s++)
    {
        std::vector<cv::Mat> M;
        cv::Mat trainingVector;
        cv::Mat labelMat;
        std::vector<int> labels = readlabels(s);
        for(int e1=1;e1<=180;e1++)
        {
            for(int c1=8;c1<=8;c1++)
            {
                int l1=labels[e1-1];

                if (l1==2)
                {
                    for(int e2=181;e2<=420;e2++)
                    {
                        for(int c2=8;c2<=8;c2++)
                        {
                            int l2=labels[e2-1];

                            if (l2==2)
                            {
                                comparesignals(s,e1,l1,c1, s,e2,l2,c2);
                            }
                        }
                    }
                }

            }
        }

    }

}


void memorize(float *descr, int samples)
{
    cv::Mat training(samples,128,CV_32FC1);
    std::memcpy(training.data, descr, samples*128*sizeof(float));

    printf("Template Matrix Size: %d, %d\n", training.size().width, training.size().height);
    printf("Size of Sample: %d, %d\n", training.row(0).size().width, training.row(0).size().height);

    serializeMatbin(training,"training.bin");
}

void remember(float *descr, int samples)
{
    cv::Mat training;

    // Load the template database obtained during training.
    training = deserializeMatbin("training.bin");

    std::memcpy(descr,training.data, samples*128*sizeof(float));
}


struct SpellerLetter classifytrial(float *descr)
{
    cv::Mat descriptors(1*12,128,CV_32FC1);

    cv::Mat training;

    std::memcpy(descriptors.data, descr, 1*12*128*sizeof(float));

    // Load the template database obtained during training.
    training = deserializeMatbin("training.bin");

    printf("Template Matrix Size: %d, %d\n", training.size().width, training.size().height);
    printf("Query Matrix Size: %d, %d\n", descriptors.size().width, descriptors.size().height);

    printf("Size of Template Element: %d, %d\n", training.row(0).size().width, training.row(0).size().height);
    printf("Size of Query Element: %d, %d\n", descriptors.row(0).size().width, descriptors.row(0).size().height);

    cv::flann::Index flann_index(training, cv::flann::KDTreeIndexParams(1));


    int row=-1;
    {
        std::vector<double> sum;

        for(int index=0;index<6;index++)
        {
            cv::Mat query = descriptors.row(index);
            cv::Mat indices, dists; //neither assume type nor size here !
            double radius= 2.0;

            //flann_index.radiusSearch(query, indices, dists, radius, max_neighbours,cv::flann::SearchParams(32));

            flann_index.knnSearch(query, indices, dists, 7,cv::flann::SearchParams(32) );

            //printf("Indices: %d, %d\n", indices.size().width, indices.size().height);

            //printf("Dists: %d, %d\n", dists.size().width, dists.size().height);

            printf("Row %2d:Dist:%10.2f\n", index,cv::sum( dists )[0]);

            sum.push_back(cv::sum( dists )[0]);
        }
        //printf("Classes %d\n", sum.size());

        int min=0;
        double minvalue=sum[0];
        for(int index=1;index<6;index++)
        {
            if (sum[index]<=minvalue)
            {
                min = index;
                minvalue = sum[index];
            }
        }
        row = min;
    }

    int col=-1;
    {
        std::vector<double> sum;

        for(int index=6;index<12;index++)
        {
            cv::Mat query = descriptors.row(index);
            cv::Mat indices, dists; //neither assume type nor size here !
            double radius= 2.0;

            //flann_index.radiusSearch(query, indices, dists, radius, max_neighbours,cv::flann::SearchParams(32));

            flann_index.knnSearch(query, indices, dists, 7,cv::flann::SearchParams(32) );

            //printf("Indices: %d, %d\n", indices.size().width, indices.size().height);

            //printf("Dists: %d, %d\n", dists.size().width, dists.size().height);


            printf("Col %2d:Dist:%10.2f\n", index, cv::sum( dists )[0]);

            sum.push_back(cv::sum( dists )[0]);
        }
        //printf("Classes %d\n", sum.size());

        int min=0;
        double minvalue=sum[0];
        for(int index=1;index<6;index++)
        {
            if (sum[index]<=minvalue)
            {
                min = index;
                minvalue = sum[index];
            }
        }
        col = min;
    }
    printf("Row, Col:%d,%d\n",row,col+6);

    struct SpellerLetter sp;
    sp.row = row;
    sp.col = col+6;

    return sp;


}

void classify(float *descr, int trials, int trialstolearn,int trialstotest)
{
    cv::Mat descriptors(trials*12,128,CV_32FC1);
    std::memcpy(descriptors.data, descr, trials*12*128*sizeof(float));

    cv::Mat labelMat;
    std::vector<int> labels;

    cv::Mat training;
    cv::Mat testing;

    for(int j=0;j<trials;j++)
    {
        for(int i=0;i<6;i++)
        {
            labels.push_back(1);
            labelMat.push_back(1);
        }
        for(int i=6;i<12;i++)
        {
            labels.push_back(2);
            labelMat.push_back(2);
        }
    }

    int whichs[trialstolearn*12];
    int whachs[trialstotest*12];

    for(int i=0;i<trialstolearn*12;i++)
        whichs[i] = i;

    for(int i=trialstolearn*12;i<trials*12;i++)
        whachs[i-trialstolearn*12]=i;

    cv::Mat labelTraining;
    cv::Mat labelTesting;

    for(int i=0;i<trialstolearn*12;i++)
    {
        training.push_back(descriptors.row(whichs[i]));
        labelTraining.push_back(labelMat.row(whichs[i]));
    }

    for(int i=0;i<trialstotest*12;i++)
    {
        testing.push_back(descriptors.row(whachs[i]));
        labelTesting.push_back(labelMat.row(whachs[i]));
    }

    //training = deserializeMatbin("training.bin");

    cv::Ptr<SVM> svm = SVM::create();
    svm->setType(SVM::C_SVC);
    svm->setKernel(SVM::LINEAR);
    svm->setTermCriteria(cv::TermCriteria(cv::TermCriteria::MAX_ITER, 100, 1e-6));


    printf("Label Size: %d, %d\n", labelMat.size().width, labelMat.size().height);
    printf("Training Matrix Size: %d, %d\n", training.size().width, training.size().height);
    printf("Training Label Size: %d, %d\n", labelTraining.size().width, labelTraining.size().height);
    printf("Testing Matrix Size: %d, %d\n", testing.size().width, testing.size().height);
    printf("Testing Label Size: %d, %d\n", labelTesting.size().width, labelTesting.size().height);
    printf("Size of Sample: %d, %d\n", training.row(0).size().width, training.row(0).size().height);

    svm->train(training, ROW_SAMPLE, labelTraining);

    int accuracies=0;

    for(int i=0;i<trialstotest*12;i++)
    {
        printf("%d\n",i);
        printf("Size: %d, %d\n", testing.row(i).size().width, testing.row(i).size().height);
        float response = svm->predict(testing.row(i));
        int expected = labelTesting.at<int>(0,i);
        printf("Expected (%d) vs Predicted (%1.0f)\n", expected,response);


        if (response==expected) accuracies++;

    }


    printf ("Success %10.6f\n", (float)accuracies/(trialstotest*12));

    //serializeMatbin(training,"training.bin");

}
