/*
 *      clock() function
 *
 *      Return the current time basically
 *      Typically used to find amount of CPU time
 *      used by a program.
 *
 *      ANSI allows any time at start of program so
 *      properly written programs should call this fn
 *      twice and take the difference
 *
 *      djm 9/1/2000
 *
 * --------
 * $Id: clock.c,v 1.1 2002-11-20 21:15:23 dom Exp $
 */


#include <time.h>

/*
 * Get the current time
 */
clock_t clock()
{
#asm
        ld      c,$21   ;SYSTIME
        rst     $10     ;h=hour,l=minute,b=second
        ld      c,h
        push    bc      ;save hour,second
        ld      h,0
        ld      de,60   ;seconds in minute
        call    l_mult  ;hl now is number of seconds
        pop     bc
        push    bc
        ld      c,b
        ld      b,0
        add     hl,bc   ;hl now is seconds + mins * 60
        pop     bc      ;get hours back
        push    hl      ;save hl
        ld      l,c
        ld      h,0
        ld      de,0
        push    de
        push    hl
        ld      hl,3600 ;seconds in hours (de=0)
        call    l_long_mult
        pop     bc      ;get seconds + mins back
        push    de
        push    hl
        ld      l,c
        ld      h,b
        ld      de,0
        call    l_long_add
#endasm
}

