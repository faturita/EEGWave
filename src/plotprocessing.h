#ifndef PLOTPROCESSING_H
#define PLOTPROCESSING_H

#include "spellerletter.h"

void process();

void comparesignals(int subject1, int epoch1, int label1, int channel1, int subject2, int epoch2, int label2, int channel2);
void comparehits();
void classify(float *descr, int trials, int trialstolearn, int trialstotest);
void memorize(float *descr, int length);
void remember(float *descr, int length);
struct SpellerLetter classifytrial(float *descr);

#endif // PLOTPROCESSING_H


