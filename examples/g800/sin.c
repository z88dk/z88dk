#include <graphics.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void main() {
  int x, y;
  clg();

  for (x = 0; x < 144; x++) {
    y = (int)(24 * (1.0 - sin(x / 144.0 * 3.14 * 8)));
    plot(x, y);
  }

  sleep(1);  // sleep 1 second

  clg();
  plot(0,24);

  for (x = 0; x < 144; x++) {
    y = (int)(24 * (1.0 - sin(x / 144.0 * 3.14 * 8)));
     drawto(x,y);
  }


  while (getk() != 10) {
  };  // enter key is assigned to 10 in the g800 port of z88dk
}
