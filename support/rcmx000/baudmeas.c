/*
	Z88DK - Rabbit Control Module examples
	Measuring the RMC baud rate
	
	$Id: baudmeas.c,v 1.1 2007-05-18 06:36:50 stefano Exp $
*/

#include <stdio.h>

static int baudmeas()
{
#asm
  push af ;
  push bc ;
  push de ;
    
  call baudmeas ;

  ld l,a ;
  ld h,0 ;

  pop de ;
  pop bc ;
  pop af ;

  ret

#include "baudmeas.asm"

#endasm
}

/** Simple hack just to set outgoing serial to the baudrate obtained earlier */
static int init_serial(int divisor)
{
#asm

  ; Set the baudrate to 2400 ;
  ld a,l    ; serial divisor, low byte ;
  defb 0d3h ; ioi ;
  ld (0a9h),a ;

#endasm
}

int main()
{
  int divisor;

  divisor=baudmeas();

  init_serial(divisor-1);

  printf("This little program should now have measured the baudrate.\n");

  printf("The divisor was: %d\n", divisor);

  while (1);
}
