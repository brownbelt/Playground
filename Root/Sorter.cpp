#include <iostream>
#include <random>
#include <limits>
#include <cstdlib>
#include <ctime>
#include <vector>

#define RAND_COUNT 10

int main(int argc, char** argv) {
    std::cout << argv[0] << std::endl;
    std::vector<unsigned int> randAccum(RAND_COUNT);
    std::vector<unsigned int> valSorted(RAND_COUNT);
    
    /* std::random_device randDevice;
    std::mt19937 mteGen(randDevice());
    std::uniform_int_distribution<> randDistrib(0, 100); */

    srand(time(NULL));

    for(unsigned int randNumElem = 0; randNumElem < randAccum.size(); randNumElem++)
        randAccum[randNumElem] = static_cast<unsigned int>(std::rand());

    /* for(unsigned int randNumElem = 0; randNumElem < randAccum.size(); randNumElem++)
        std::cout << randAccum[randNumElem] << std::endl; */

    unsigned int minVal; unsigned int minIndex;
    unsigned int maxVal; unsigned int maxIndex;
    unsigned int sortIndex;
    
    while(randAccum.size() > 1 || sortIndex == randAccum.size()){
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
        for(unsigned int randNumElem = 0; randNumElem < randAccum.size(); randNumElem++)
            std::cout << randAccum[randNumElem] << std::endl;
        std::cout << "Yum yum" << std::endl;
        randAccum.erase(randAccum.begin() + minIndex);
        randAccum.erase(randAccum.begin() + maxIndex);
        sortIndex++;
    }

    return 0;
}