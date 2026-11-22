/*
    Z88DK - Rabbit Control Module examples
    Led blinking for the Rabbit 2000

    $Id: twinkle2000.c,v 1.1 2007-02-28 11:23:15 stefano Exp $
*/


static void setup_io()
{
#asm
    ld a,84h ;
    ioi ld (24h),a ;
#endasm
}

static void leds_on()
{
#asm
    ld a,00h  ; leds on ;
    ioi ld (030h),a ;
#endasm
}

static void leds_off()
{
#asm
    ld a,0ffh  ; leds off ;
    ioi ld (030h),a ;
#endasm
}

static int read_rtc()
{
#asm
    ioi ld (2),a        ; Any write triggers transfer ;
    ioi ld hl,(2)   ; RTC byte 0-1 ;
#endasm
}

static int wait_rtc()
{
#asm
    push de ;
    push hl ;

wait:

    ioi ld (2),a        ; Any write triggers transfer ;
    ioi ld hl,(2)       ; RTC byte 0-1 ;

    ld de,07fffh ;
    and hl,de ;
    jr nz, wait ;

    pop hl ;
    pop de ;
#endasm
}

#include <stdio.h>

int main(void)
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
    return 0;
}
