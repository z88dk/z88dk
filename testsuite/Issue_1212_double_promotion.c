#include <math.h>
#include <stdio.h>

int main() {
  int x, y;

  for (x = 0; x < 144; x++) {
    y = (int)(24 * (1.0 - sin(x / 144.0 * 3.14 * 8)));
    printf("%d, %d\n",x,y);
  }

  for (x = 0; x < 144; x++) {
    y = (int)(24 * (1.0 - sin(x / 144.0 * 3.14 * 8)));
    printf("%d, %d\n",x,y);
  }
  return 0;
}
