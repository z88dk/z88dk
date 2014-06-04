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
 *      CPM3 version by Stefano - 3/6/2014
 *
 * this module should work with the following operating systems:
 *
 *	CPM 3.x  (aka "CPM+")
 *	MP/M 2.x and higher
 *	TurboDOS 1.2x, 1.3x, and, presumably, higher
 *	Not (of course) CPM 1.x and 2.x, which have no real-time functions
 *
 * --------
 * $Id: clock.c,v 1.1 2014-06-04 20:37:27 stefano Exp $
 *
 */


#include <time.h>

/*
 * Get the current time
 */
clock_t clock()
{
#asm
        ld      de,jdate    ; pointer to date/time bufr
        ld      c,105       ; C=return date/time function
        call    5           ; get date/time

        push    af
        
        ld      c,12
        call    5           ; check version
        pop     af
        ld      c,a
        ld      a,l
        cp      02Fh        ; MP/M II or later (cpm3..) ?
        jr      c,nompmii
        ld      a,c         ; if so we get the seconds from the L reg
        ld      (secs),a

; we jump here directly if we have dosplus or a CP/M version <=MPM II
nompmii:
        ld      a,(secs)
        call    unbcd       ; decode seconds and put in HL
        push    hl
        ld      a,(mins)
        call    unbcd       ; decode minutes and put in HL
        ld      de,60       ; seconds in minute
        call    l_mult      ; hl now is number of seconds
        pop     bc
        add     hl,bc       ; hl now is seconds + mins * 60
        push    hl          ; save hl
        ld      a,(hours)
        call    unbcd       ; decode minutes and put in HL
        ld      de,0
        push    de
        push    hl
        ld      hl,3600     ; seconds in hours (de=0)
        call    l_long_mult
        pop     bc          ; get seconds + mins back
        push    de
        push    hl
        ld      l,c
        ld      h,b
        call    l_long_add
        ret

jdate:	defs	2           ; Day count, starting on 1st January 1978 (add 2922 days to move epoch to 1970)
hours:	defs	1
mins:	defs	1
secs:	defs	1

unbcd:
	push	bc
	ld	c,a
	and	0f0h
	srl	a
	ld	b,a
	srl	a
	srl	a
	add	a,b
	ld	b,a
	ld	a,c
	and	0fh
	add	a,b
	pop	bc
	ld  l,a
	ld  h,0
	ret

#endasm
}

