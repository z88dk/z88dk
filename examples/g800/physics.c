#include <graphics.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void wait(int time) {
  int a;
  for (int i = 0; i < time; i++) {
    a += 1;
  }
}

#define ITEMS 10
#define XMAX 140
#define YMAX 48
#define WAIT 10

int x[ITEMS], y[ITEMS];
int vx[ITEMS], vy[ITEMS];
int oldx, oldy;

void reset() {
  for (int i = 0; i < ITEMS; i++) {
    x[i] = rand() % (XMAX-8) +4;
    y[i] = rand() % (YMAX-8) / 2 +4;
    vy[i] = rand() % 4 - 2;
    vx[i] = rand() % 10 - 4;
  }
}

void main() {
  int r = 2;
  clg();
  reset();

  while (1) {
    for (int i = 0; i < ITEMS; i++) {
      vy[i] = vy[i] + 1.0;

      oldx = x[i];
      oldy = y[i];
      x[i] = x[i] + vx[i];
      y[i] = y[i] + vy[i];

      if ((x[i] > XMAX-r) || (x[i] < r)) {
        vx[i] = -vx[i];
      }

      if ((y[i] > YMAX-r )|| (y[i]<r)) {
        vy[i] = -vy[i];
      }

      if(y[i]>YMAX-1){y[i]=YMAX-r;};
      if(y[i]<0){y[i]=r;};
      if(x[i]>XMAX-1){x[i]=XMAX-r;};
      if(x[i]<0){x[i]=r;};

      uncircle(oldx, oldy, r, 1);
      circle(x[i], y[i], r, 1);
    }

    wait(WAIT);
    if(getk()==10){break;}
    // Enter key is defined to be 10 (not 13)
    // It blocks when clib=g850
    // so this code should be build with clib=g850b
  }
}