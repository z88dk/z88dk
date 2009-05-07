/*
	Z88DK - Rabbit Control Module examples
	Led blinking for the Rabbit 3000
	
	Same, but using the IOLIB
	
*/
	
#include <iolib.h>
	
void setup_io()
{
  iolib_outb(IOLIB_PGDCR, 0);    /* High and low as opposed to open drain */
  iolib_outb(IOLIB_PGDDR, 0xff); /* Direction Out port */
}


void leds_on()
{
  iolib_outb(IOLIB_PGDR, 0);
}	
	
	
void leds_off()
{
  iolib_outb(IOLIB_PGDR, 0xff);
}

static int wait_rtc(int port_rtc0r)
{
#asm
    push bc ;
    push de ;
    push hl ;

    ld b,h ;
    ld c,l ; Save physical address to RTC0R in c ;

wait:

    defb 0d3h ; ioi ;
    ld (bc),a		; Any write triggers transfer ;
    defb 0d3h ; ioi ;
    ld a,(bc)		; RTC byte 0 ;
    ld l,a ;
    inc bc ;
    defb 0d3h ; ioi ;
    ld a,(bc)           ; RTC byte 1 ;
    ld h,a ;
    dec bc ;
    
    ld de,7fffh ;
    defb 0dch ; and hl,de ;
    jr nz, wait ;

    pop hl ;
    pop de ;
    pop bc ;
#endasm
}

#include <stdio.h>

int main()
{
    int i;

    unsigned port_rtc0r = iolib_physical(IOLIB_RTC0R);

    setup_io();

    while(1)
    {
	leds_on();

	printf("LED ON....\n");
	
	wait_rtc(port_rtc0r);
	
	leds_off();

	printf("LED OFF...\n");

	wait_rtc(port_rtc0r);
    }

}
