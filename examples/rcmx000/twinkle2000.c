/*
	Z88DK - Rabbit Control Module examples
	Led blinking for the Rabbit 2000
	
	$Id: twinkle2000.c,v 1.1 2007-02-28 11:23:15 stefano Exp $
*/


static void setup_io()
{
#asm

    ld a,84h ;
    defb 0d3h; ioi ;
    ld (24h),a ;

#endasm
}

static void leds_on()
{
#asm
    ld a,00h  ; leds on ;
    defb 0d3h; ioi ;
    ld (030h),a ;
#endasm
}	

static void leds_off()
{
#asm
    ld a,0ffh  ; leds off ;
    defb 0d3h; ioi ;
    ld (030h),a ;
#endasm
}

static int read_rtc()
{
#asm
    defb 0d3h ; ioi ;
    ld (2),a		; Any write triggers transfer ;
    defb 0d3h ; ioi ;
    ld hl,(2)		; RTC byte 0-1 ;
#endasm
}
				   
static int wait_rtc()
{
#asm
    push de ;
    push hl ;

wait:

    defb 0d3h ; ioi ;
    ld (2),a		; Any write triggers transfer ;
    defb 0d3h ; ioi ;
    ld hl,(2)		; RTC byte 0-1 ;

    ld de,07fffh ;
    defb 0dch ; and hl,de ;
    jr nz, wait ;

    pop hl ;
    pop de ;
#endasm
}

#include <stdio.h>

int main()
{
    int i;

    setup_io();

    while(1)
    {
	leds_on();

	printf("LED ON....\n");
	
	wait_rtc();
	
	leds_off();

	printf("LED OFF...\n");

	wait_rtc();
    }

}
