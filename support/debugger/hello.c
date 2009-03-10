#include <stdio.h>


int main()
{
  int i;

  char ch,ch2;
  printf("Hello World\n");

  for (i=0;i<10;i++)
    {
      printf("i=%d\n", i);
    }


  printf("  Please enter a character and <return>\n");

  ch=getchar();
  ch2=getchar();

  printf("You typed: %c%c\n", ch, ch2);

}
