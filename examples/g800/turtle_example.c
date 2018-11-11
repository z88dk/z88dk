#include <stdio.h>
#include "turtle.h"

void main() {

    clg();
    home();

    // triangle
    setposition(5,40);
    for(int i=0;i<3;i++){
        forward(40);
        left(120);
    }

    // hexagon
    setposition(60,5);
    for(int i=0;i<6;i++){
        forward(20);
        right(60);
    }

    // star
    setposition(100,16);
    for(int i=0;i<5;i++){
        forward(40);
        right(180-180/5);
    }

    while(getk()!=10){;;};
}