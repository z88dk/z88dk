#include <arch/px8.h>
#include <graphics.h>
#include <string.h>
#include <stdio.h>

// minfrom = maxto * 10; maxfrom = minto * 10
#define MAP_DOWN_X10(minfrom, maxfrom, minto, maxto, value) (maxto * 10 - (value - minfrom) * (maxto - minto) * 10 / (maxfrom - minfrom))

void print_sw(int sw) {
  for (int i = 0; i < 8; ++i) {
    printf("%s", sw & 0x1 ? "^" : "v");
    sw >>= 1;
  }
}

int main() {
  unsigned int status = 0;
  subcpu_7508(0x2C, 0, NULL, 1, &status);
  printf("Analog input:\tADCVRT: %d\t\t7508: %d\n", adcvrt(CH_ANALOG) >> 2, status >> 2);

  subcpu_7508(0x3C, 0, NULL, 1, &status);
  printf("Barcode reader:\tADCVRT: %d\t\t7508: %d\n", adcvrt(CH_BARCODE) >> 2, status >> 2);

  subcpu_7508(0x0A, 0, NULL, 1, &status);
  int sw = adcvrt(CH_DIP_SW);
  printf("DIP SW:\t\tADCVRT: ");
  print_sw(sw);
  printf("\t7508: ");
  print_sw(status);
  printf("\n");

  int voltage = adcvrt(CH_BATTERY) * 57 / 255;
  subcpu_7508(0x0C, 0, NULL, 1, &status);
  status = status * 57 / 255;
  printf("Battery:\tADCVRT: %d.%dv\t\t7508: %d.%dv\n", voltage / 10, voltage % 10, status / 10, status % 10);

  READ_TEMPERATURE(&status);
  printf("RAW Temp:\t0x%X\t\t\tTemp: ", status);

  // Real PX-8 is kinda messed up, can't declare large functions before main.
  // 20h = 90
  // 40h = 65
  // 60h = 50 --
  // 80h = 40   more or less linear
  // A0h = 30
  // C0h = 20 --
  // E0h = 15
  if (status >= 0x60 && status <= 0xC0) {
    unsigned int temp_x10 = MAP_DOWN_X10(0x60, 0xC0, 20, 50, status);
    printf("%d.%d", temp_x10 / 10, temp_x10 % 10);
  } else {
    printf("???");
  }
  printf(" C\n");

  int pwr = adcvrt(CH_BUTTONS);
  subcpu_7508(0x08, 0, NULL, 1, &status);
  printf("ADCVRT: Power is %s; trigger is %s; 7508: Power is %s; trigger is %s\n",
      pwr & 1 ? "ON" : "OFF", pwr & 2 ? "ON" : "OFF",
      status & 1 ? "ON" : "OFF", status & 2 ? "ON" : "OFF");
  getc(stdin);
}
