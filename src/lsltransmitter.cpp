#include <lsl_cpp.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


#include "eegimage.h"
#include "plotprocessing.h"
#include "unp.h"


using namespace lsl;

/**
 * This code simulates the sending of lsl EEG stream with markers.
 *
 *
 */

int sendeegandmarkers() {

    const double markertypes[] = {32773.0, 32774.0, 33025.0, 33026.0, 33027.0, 33028.0,33029.0,33030.0,33031.0,
                                 33032.0,33033.0,33034.0,33035.0,33036.0,33037.0};

    // make a new stream_info (128ch) and open an outlet with it
    stream_info info("openvibeSignal2","EEG",8);
    stream_outlet outleteeg(info);

    // make a new stream_info
    lsl::stream_info infomk("openvibeMarkers2","Markers",1,lsl::IRREGULAR_RATE,lsl::cf_double64,"myuniquesourceid23443");

    // make a new outlet
    lsl::stream_outlet outletmk(infomk);


    // send data forever

    float forwardsample[8];

    while(true) {
        double ts = 1.12;

        //forwardsample[0] = ts;

        // generate random data
        for (int c=0;c<8;c++)
            forwardsample[c] = (rand()%1500)/500.0-1.5;

        printf ("%10.8f\n",forwardsample[0]);

        // send it
        outleteeg.push_sample(forwardsample);
    }

    return 0;
}

int sendeeg() {

    // make a new stream_info (128ch) and open an outlet with it
    stream_info info("openvibeSignal","EEG",11);
    stream_outlet outlet(info);

    // send data forever

    float forwardsample[11];

    while(true) {
        double ts = 1.12;

        forwardsample[0] = ts;

        // generate random data
        for (int c=0;c<11;c++)
            forwardsample[c] = (rand()%1500)/500.0-1.5;

        printf ("%10.8f:%10.8f\n",ts,forwardsample[0]);

        // send it
        outlet.push_sample(forwardsample);
    }

    return 0;
}

/**
 * This is a minimal example that demonstrates how a multi-channel stream (here 128ch)
 * of a particular name (here: SimpleStream) can be resolved into an inlet, and how the
 * raw sample data & time stamps are pulled from the inlet. This example does not
 * display the obtained data.
 * export LD_LIBRARY_PATH=/Users/rramele/work/labstreaminglayer/build/install/lsl_Release/LSL/lib/
 */

int receiving() {
    using namespace lsl;

    // resolve the stream of interest & make an inlet to get data from the first result
    std::vector<stream_info> results = resolve_stream("name","openvibeSignal");
    stream_inlet inlet(results[0]);

    // receive data & time stamps forever (not displaying them here)
    float sample[11];
    float marker;

    while (true)
    {
        int Fs=256;
        double signal[256];
        for(int i=0;i<256;i++)
        {
            double ts = inlet.pull_sample(&sample[0],11);
            printf ("%10.8f:%10.8f\n",ts,sample[0]);
            signal[i]=sample[0];
        }

        eegimage(signal,256,Fs,1,1,true,1);
    }


    while (true)
    {
        double ts = inlet.pull_sample(&sample[0],11);
        printf ("%10.8f:%10.8f\n",ts,sample[0]);

        eegimage(0,sample[0]*10);
    }

    return 0;
}


/**
 * This is a minimal example that demonstrates how a multi-channel stream (here 128ch)
 * of a particular name (here: SimpleStream) can be resolved into an inlet, and how the
 * raw sample data & time stamps are pulled from the inlet. This example does not
 * display the obtained data.
 * export LD_LIBRARY_PATH=/Users/rramele/work/labstreaminglayer/build/install/lsl_Release/LSL/lib/
 */

int receivingsignal() {
    using namespace lsl;

    // resolve the stream of interest & make an inlet to get data from the first result
    std::vector<stream_info> markers = resolve_stream("name","openvibeMarkers2");
    stream_inlet markersInlet(markers[0]);

    std::vector<stream_info> results = resolve_stream("name","openvibeSignal2");
    stream_inlet inlet(results[0]);

    // receive data & time stamps forever (not displaying them here)
    float sample[8];
    float marker;
    while (true)
    {
        int Fs = 256;
        double signal[256];
        for(int i=0;i<256;i++)
        {
            double ts = inlet.pull_sample(&sample[0],8);
            //printf ("%10.8f:%10.8f\n",ts,sample[0]);
            signal[i]=sample[0];

            double mts = markersInlet.pull_sample(&marker,1,0.0f);
            if (mts>0)
                printf ("%10.8f:%10.8f:Marker %10.8f\n",ts,mts,marker);
        }

        eegimage(signal,256, Fs, 10,1,true,1);

    }

    return 0;
}


struct SpellerLetter processtrial(float *descr,double gammat, double gamma,double Fs, stream_inlet &inlet, stream_inlet &markersInlet)
{
    // receive data & time stamps forever (not displaying them here)
    float sample[8];
    float marker;

    int window = (int)Fs * 1;   // 1 is one second, the length of the segment.

    int maxtrialsamplelength = 400;

    double Segments[15][12][window];
    int counters[12];
    double signal[window*maxtrialsamplelength]; // FIXME Trial length should be no longer than 400 seconds.
    // FIXME number of intensifications should be no longer than 130.
    int stims[130];
    int stimmarkers[130];
    int stimcounter=0;

    double tsoffset=0;

    bool hit = false;
    int row=-1;
    int col=-1;

    memset(counters,0,12*sizeof(int));
    memset(signal,0,window*maxtrialsamplelength*sizeof(double));
    memset(Segments,0,15*12*window*sizeof(double));

    // First wait until the trial-start mark arrives.  Discard everything.
    while(true)
    {
        double mts = markersInlet.pull_sample(&marker,1,0.0f);
        if (mts>0)
        {
            // Trial start
            if (((int)marker)==32773)
            {
                printf("\nTrial start triggered.");
                tsoffset = mts;
                break;
            }
        }
    }

    // Start getting the entire EEG stream.
    // Pull the markers and store them internally to find and match the segments.
    // Find the hit/nohit markers also to identify the ground-truth letter.
    for(int i=0;i<window*maxtrialsamplelength;i++)
    {
        double ts = inlet.pull_sample(&sample[0],8);
        //printf ("%10.8f:%10.8f\n",ts,sample[0]);

        // FIXME Multichannel (or at least channel-by-channel)
        signal[i]=sample[0];

        double mts = markersInlet.pull_sample(&marker,1,0.0f);
        if (mts>0)
        {
            printf ("\n%10.8f:%10.8f:Marker %10.8f",ts,mts,marker);

            if (marker == 33285)
            {
                // Hit found.  Next stim will be hit... This is dangerous.#FIXME
                hit = true;
            } else if (marker  == 33286)
            {
                hit = false;
            }

            if (marker >= 33025 && marker <= 33037)
            {
                int stim = (int)marker - 33025;
                printf ("- Stim: %d.", stim);
                stims[stimcounter]=stim;
                stimmarkers[stimcounter] = (int)((mts-tsoffset)*window);
                stimcounter++;

                if (hit && stim<=5)
                    row = stim;
                if (hit && stim>=6)
                    col = stim;

            }
            // Trial stop 32770 is the end of the experiment.
            if (((int)marker)==32774)
            {
                printf("\nEnd of Trial triggered.");
                break;
            }
        }

        // Safe break
        if (stimcounter>=160) break;
    }

    // Pull the segments according to markers information.
    for(int i=0;i<stimcounter;i++)
    {
        int stim = stims[i];
        printf("\nCopying segment %d into position %d on repetition %d.",stim, stimmarkers[i],counters[stim]);
        //signal[stimmarkers[i] + 200] = 50;signal[stimmarkers[i] + 220] = -5;
        //memcpy(Segments[counters[stim]++][stim],&signal[stimmarkers[i]],256*sizeof(double));
        memset(&Segments[counters[stim]][stim][0],0,sizeof(double)*window);

        // FIXME DEBUG
        if (stim == row || stim == col)
        {
            //Segments[counters[stim]][stim][window-10] = Segments[counters[stim]][stim][window-5] = 40;
            //Segments[counters[stim]][stim][128] = -50;
        } else

        for(int j=0;j<window;j++)
        {
            Segments[counters[stim]][stim][j] = signal[stimmarkers[i]+j];
        }
        counters[stim]++;

    }

    // Ensemble Average of all the segments, create the image and get the descriptors.
    for(int i=0;i<12;i++)
    {
        printf("\nCounter for stim %d:%d",i,counters[i] );

        double sign[window];

        for(int j=0;j<window;j++)
        {
            double avg = 0;
            for(int rep=0;rep<counters[i];rep++)
            {
                avg += Segments[rep][i][j];
            }
            sign[j] = avg/(counters[i]*1.0F);
        }

        eegimage(&descr[i*128],sign,window, Fs,gammat,gamma,true,i);

    }

    printf("Ground truth - Row: %d, Col: %d.\n",row,col);

    struct SpellerLetter l;
    l.row = row;
    l.col = col;
    return l;
}

int trainspeller() {
    using namespace lsl;

    // resolve the stream of interest & make an inlet to get data from the first result
    std::vector<stream_info> markers = resolve_stream("name","openvibeMarkers2");
    stream_inlet markersInlet(markers[0]);

    std::vector<stream_info> results = resolve_stream("name","openvibeSignal2");
    stream_inlet inlet(results[0]);

    double Fs = 16;//10;16;256;
    double gammat  =6;
    double gamma = 10;

    int trials = 5;

    float *templates = new float[trials*2*128];
    float *descriptors = new float[12*128];

    for(int j=0;j<trials;j++)
    {
        struct SpellerLetter l;
        memset(descriptors,0,sizeof(float)*12*128);

        // This function returns 12 128-descriptors.
        l = processtrial(descriptors,gammat,gamma, Fs, inlet,markersInlet);

        memcpy(&templates[j*2*128],&descriptors[l.row*128],128*sizeof(float));
        memcpy(&templates[j*2*128+128],&descriptors[l.col*128],128*sizeof(float));

    }

    memorize(templates,2*trials);

    delete [] descriptors;
    delete [] templates;

    return 0;
}

int onlinespeller() {
    using namespace lsl;

    // resolve the stream of interest & make an inlet to get data from the first result
    std::vector<stream_info> markers = resolve_stream("name","openvibeMarkers2");
    stream_inlet markersInlet(markers[0]);

    std::vector<stream_info> results = resolve_stream("name","openvibeSignal2");
    stream_inlet inlet(results[0]);

    double Fs = 16;//10;16;256;
    double gammat  =6;
    double gamma = 10;

    int trials = 5;

    float *templates = new float[trials*2*128];
    float *descriptors = new float[trials*12*128];

    int sockfd = createsignalserver();

    for(int j=0;j<trials;j++)
    {
        struct SpellerLetter l;
        l = processtrial(&descriptors[j*12],gammat,gamma, Fs, inlet,markersInlet);

        struct SpellerLetter le;
        le = classifytrial(&descriptors[j*12]);

        informresult(sockfd,le.row,le.col);

    }

    //memorize(templates,2*trials);

    delete [] descriptors;
    delete [] templates;

    return 0;
}

// -------------------------- UNIT TESTING
int udp()
{
    int sockfd = createsignalserver();
    struct SpellerLetter le;
    le.row = 1;
    le.col = 1;
    informresult(sockfd,le.row,le.col);

    // Returning to avoid warning, this might not be correct
    return 0;
}

void trainclassify()
{
    float *descr = new float[5*1*12*128];
    memset(descr,0,sizeof(float)*5*1*12*128);

    for(int i=0;i<10;i++)
    {
        double signal[256];
        memset(signal,0,sizeof(double)*256);
        signal[120] = signal[132] = 40;
        signal[128] = -50;
        //randomSignal(signal,256,20);
        eegimage(&descr[(0*12+i)*128],signal,256,256,1,1,true,i);
        printdescriptor (&descr[(0*12+i)*128]);
    }

    memorize(descr,10);

    delete [] descr;
}

void testmemory()
{
    float *templates = new float[1*1*10*128];
    memset(templates,0,sizeof(float)*1*1*10*128);

    remember(templates,10);

    for(int i=0;i<10;i++)
    {
        printdescriptor(&templates[i*128]);
        printf("--------\n");
    }

    delete [] templates;

}

void testclassify()
{
    int trials = 1*1;

    float *descr = new float[1*1*12*128];
    memset(descr,0,sizeof(float)*1*1*12*128);

    for(int j=0;j<trials;j++)
    {
        for(int i=0;i<5;i++)
        {
            double signal[256];
            memset(signal,0,sizeof(double)*256);
            eegimage(&descr[(j*12+i)*128],signal,256,256,1,1,true,i);
            printdescriptor (&descr[(j*12+i)*128]);
        }

        for(int i=5;i<7;i++)
        {
            double signal[256];
            memset(signal,0,sizeof(double)*256);
            signal[120] = signal[132] = 40;
            signal[128] = -50;
            //randomSignal(signal,256,20);
            eegimage(&descr[(j*12+i)*128],signal,256,256,1,1,true,i);
            printdescriptor (&descr[(j*12+i)*128]);
        }

        for(int i=7;i<12;i++)
        {
            double signal[256];
            memset(signal,0,sizeof(double)*256);
            eegimage(&descr[(j*12+i)*128],signal,256,256,1,1,true,i);
            printdescriptor (&descr[(j*12+i)*128]);
        }

    }

    sleep(5);
    struct SpellerLetter le = classifytrial(&descr[1*12]);
}
