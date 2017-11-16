#include <iostream>
#include <random>
#include <limits>
#include <cstdlib>
#include <ctime>
#include <chrono>
#include <vector>
#include <deque>

namespace Benchmark {
    std::chrono::steady_clock::time_point beforeSort;
    std::chrono::steady_clock::time_point afterSort;
    std::chrono::duration<double, std::micro> microSpan;
}

bool foolProof(std::vector<unsigned int>* sortedVals){
    for(unsigned int currentVal = 0; currentVal < sortedVals->size() - 1; currentVal++){
        if(sortedVals->at(currentVal) <= sortedVals->at(currentVal + 1)){
            continue;
        }
        else {
            std::cerr << "Your sorting sucks" << std::endl;
            return false;
        }
    }
    std::cout << "Looks good to me" << std::endl;
}

unsigned int sort(unsigned int valCount){
    std::vector<unsigned int> randAccum(valCount);
    std::vector<unsigned int> valSorted(valCount);

    srand(time(NULL));
    for(unsigned int randNumElem = 0; randNumElem < randAccum.size(); randNumElem++)
        randAccum[randNumElem] = static_cast<unsigned int>(std::rand());

    Benchmark::beforeSort = std::chrono::steady_clock::now();
    unsigned int minVal; unsigned int minIndex;
    unsigned int maxVal; unsigned int maxIndex;
    unsigned int sortIndex = 0;

    while(!randAccum.empty()){
        minVal = randAccum[0];
        maxVal = randAccum[0];
        minIndex = 0;
        maxIndex = 0;
        for(unsigned int randNumElem = 0; randNumElem < randAccum.size(); randNumElem++){
            if(randAccum[randNumElem] < minVal){
                minVal = randAccum[randNumElem];
                minIndex = randNumElem;
            }
            if(randAccum[randNumElem] > maxVal){
                maxVal = randAccum[randNumElem];
                maxIndex = randNumElem;
            }
        }

        valSorted[sortIndex] = randAccum[minIndex];
        valSorted[valSorted.size() - sortIndex - 1] = randAccum[maxIndex];

        if(maxIndex == minIndex){
            randAccum.erase(randAccum.begin());
        } else if(maxIndex < minIndex){
            randAccum.erase(randAccum.begin() + minIndex);
            randAccum.erase(randAccum.begin() + maxIndex);
        } else {
            randAccum.erase(randAccum.begin() + maxIndex);
            randAccum.erase(randAccum.begin() + minIndex);
        }

        sortIndex++;
    }
    Benchmark::afterSort = std::chrono::steady_clock::now();
    Benchmark::microSpan = std::chrono::duration_cast<std::chrono::duration<double, std::micro>>(Benchmark::afterSort - Benchmark::beforeSort);
    std::cout << "Sorted in " << Benchmark::microSpan.count() << " microseconds" << std::endl;

    return Benchmark::microSpan.count();
}

/* unsigned int sort2(unsigned int valCount){
    std::deque<unsigned int> randAccum(valCount);

    srand(time(NULL));
    for(unsigned int randNumElem = 0; randNumElem < randAccum.size(); randNumElem++)
        randAccum[randNumElem] = static_cast<unsigned int>(std::rand());

    Benchmark::beforeSort = std::chrono::steady_clock::now();

    unsigned int currentVal;
    unsigned int tempVal;
    unsigned int replaceIndex;
    for(unsigned int setCount = 1; setCount < randAccum.size(); setCount++){
        currentVal = randAccum[setCount];
        replaceIndex = setCount;
        for(unsigned int setElem = 0; setElem < setCount; setElem++){
            if(currentVal < randAccum[setCount - (setElem + 1)]) replaceIndex--;
            else break;
        }
        if(replaceIndex != setCount){
            tempVal = randAccum[replaceIndex];
            randAccum.insert(randAccum.begin() + setCount, tempVal);
            randAccum.insert(randAccum.begin() + replaceIndex, currentVal);
        }
    }
} */

int main(int argc, char** argv) {
    std::cout << argv[0] << std::endl;

    sort(11);
    sort(60);
    sort(303);
    sort(1020);

    // sort2(10);

    return 0;
}
