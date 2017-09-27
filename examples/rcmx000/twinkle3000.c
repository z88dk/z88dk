/*
	Z88DK - Rabbit Control Module examples
	Led blinking for the Rabbit 3000
	
	$Id: twinkle3000.c,v 1.1 2007-02-28 11:23:15 stefano Exp $
*/
	
	
void setup_io()
{
#asm
    ; This could have been better documented but its possible to look it up in the ;
    ; Rabbit3000 manuals ;

    ld a,0 ;
    defb 0xd3; ioi ;
    ld (0x4e),a ;

    ld a,0ffh ;
    defb 0xd3; ioi ;
    ld (0x4f),a ;
#endasm
}


void leds_on()
{
#asm
    ld a,0  ; leds on ;
    defb 0xd3; ioi ;
    ld (0x48),a ;
#endasm
}	
	
	
void leds_off()
{
#asm
    ld a,0xff  ; leds off ;
    defb 0xd3; ioi ;
    ld (0x48),a ;
#endasm
}

static int wait_rtc()
{
#asm
    push de ;
    push hl ;

wait:

    defb 0xd3 ; ioi ;
    ld (2),a		; Any write triggers transfer ;
    defb 0xd3 ; ioi ;
    ld hl,(2)		; RTC byte 0-1 ;

    ld de,7fffh ;
    defb 0xdc ; and hl,de ;
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
