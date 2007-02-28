/*
	Z88DK - Rabbit Control Module examples
	Simple demonstration of rudimentary stdin stdout capabilities
	
	$Id: example.c,v 1.1 2007-02-28 11:23:15 stefano Exp $
*/

#include <stdio.h>


int main()
{
  
  char ch;

  printf("Please enter a few characters and <enter> and see how target\n");
  printf("echoes them back one by one...\n");

  while (1)
    {
      ch=getchar(); 
      printf("Target Got: %c\r", ch);
    }

}
