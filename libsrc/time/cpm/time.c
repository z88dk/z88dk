/*
 *	time_t time(time_t *)
 *
 *	Return number of seconds since epoch
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *  CP/M epoch is 1/1/1978
 * 
 *	CPM+ and MPM have BDOS function #105 to get time/date, it looks this function
 *	sometimes shortcuts to the hardware directly, no BIOS implementation
 *
 *	this module should work at least with the following operating systems:
 *
 *	CPM 3.x  (aka "CPM+")
 *	MP/M 2.x and higher
 *	TurboDOS 1.2x, 1.3x, and, presumably, higher
 *	Not (of course) CPM 1.x and 2.x, which have no real-time functions
 *
 * --------
 * $Id: time.c,v 1.1 2014-06-05 20:01:01 stefano Exp $
 */


#include <time.h>


time_t time(time_t *store)
{
#asm
        pop     de
        pop     ix
        push    ix
        push    de
        
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

        push    de
        push    hl

		ld      hl,(jdate)
        ld      de,0
        push    de
        push    hl
        ld      hl,2922     ; fix epoch to 1970
        call    l_long_add
        
        push    de
        push    hl

        ld      hl,20864
        ld      de,1		; load 86400 to dehl, 3600 seconds x 24 hours
        
        call    l_long_mult
        
        ld      (ix+0),l
        ld      (ix+1),h
        ld      (ix+2),e
        ld      (ix+3),d

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
