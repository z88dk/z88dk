/*
	Z88DK - Rabbit Control Module examples

	Example I/O lib to use shadow registers in a unified way,
	in due time this should go into the rcmx000 library!

*/

#include "iolib.h"

#ifdef IOLIB_DEBUG
#include <stdio.h>
#endif

static /* const */ unsigned char address_table[]={
  0x30, /* PADR     */
  0x70, /* PEDR     */
  0x77, /* PEDDR    */
  0x24, /* SPCR     */
  0x48, /* PGDR     */
  0x4c, /* PGCR     */
  0x4d, /* PGFR     */
  0x4e, /* PGDCR    */
  0x4f, /* PGDDR    */
  0x2,  /* RTC0R    */
  0x40, /* PBDR     */
  0x47, /* PBDDR    */
};


static unsigned char shadow_value[]={
  0,     /* PADR    xxxxxxxx */
  0,     /* PEDR    xxxxxxxx */
  0,     /* PEDDR   00000000 */
  0,     /* SPCR    xxxxxxxx */
  0,     /* PGDR    xxxxxxxx */
  0,     /* PGCR    xx00xx00 */
  0,     /* PGFR    xxxxxxxx */
  0,     /* PGDCR   xxxxxxxx */
  0,     /* PGDDR   00000000 */
  0,     /* RTC0R   xxxxxxxx */
  0,     /* PBDR    00xxxxxx */
  192    /* PBDDR   11000000 */
};



static unsigned ioi_data;
static unsigned ioi_addr;


extern unsigned iolib_physical(unsigned register)
{
  return address_table[register];
}


static void ioi_inb_impl()
{
#asm
  push hl;
  push af;

  ld hl,(_ioi_addr);
  defb 0d3h ; ioi ;
  ld a,(hl);
  ld (_ioi_data),a;

  pop af ;
  pop hl ;
#endasm
}
 
unsigned char iolib_inb(unsigned register)
{
  ioi_addr=iolib_physical(register);
  ioi_inb_impl();
  return ioi_data;
}
  
static void ioi_outb_impl()
{
#asm
  push hl ;
  push af ;
  
  ld hl,(_ioi_addr);
  ld a,(_ioi_data);

  defb 0d3h; ioi ;
  ld (hl),a ;
  
  pop af ;
  pop hl ;
#endasm
}

void iolib_outb(unsigned register, unsigned char data)
{
  ioi_addr=iolib_physical(register);
  ioi_data=data;
  ioi_outb_impl();
  shadow_value[register]=data;
}

void iolib_setbit(unsigned register, unsigned char bit, unsigned char val)
{
  ioi_addr=iolib_physical(register);

  /** Now we modify shadow reg */
  if (val)
    {
      /** Or the value of the bit */
      shadow_value[register] |= (1<<bit);
    }
  else
    {
      /** And the complement value of the bit */
      shadow_value[register] &= ((1<<bit)^0xff);      
    }

  ioi_data=shadow_value[register];
  
#ifdef IOLIB_DEBUG
  printf("iolib_setbit data=%x\n", ioi_data);
#endif

  ioi_outb_impl();  
}

unsigned char iolib_getbit(unsigned addr, unsigned char bit)
{
  return (  iolib_inb(addr) & (1<<bit) ? 1 : 0);
}

