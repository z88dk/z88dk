#pragma printf = "%s"   // prune to required converters
#pragma scanf  = "%s"   // prune to required converters

#include <stdio.h>

unsigned char buf[64];

void main(void)
{
   while (1)
   {
      printf("Message: ");
      
      fflush(stdin);
      scanf("%63s", buf);
      
      printf("\"%s\"\n\n", buf);
   }
}
