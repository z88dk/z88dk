#pragma printf = ""   // list required % converters here

#include <stdio.h>
#include <z80.h>

void main(void)
{
   while (1)
   {
      printf("Hello World!\n");
      z80_delay_ms(1000);
   }
}
