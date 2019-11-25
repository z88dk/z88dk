#include <graphics.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int small_delay(){
    int a=0;
    for(int i=0;i<10000;i++){a++;};
    return a;
}

void main() {
  int x, y, w, h;
  clg();

  while (1) {
    x = rand() % (getmaxx() );
    y = rand() % (getmaxy() );
    w = rand() % 16 + 4;
    h = rand() % 16 + 4;

    drawb(x, y, w, h);
    small_delay();
    if (getk() == 10) {
      break;
    }  // enter key is assigned to 10
  }
}
