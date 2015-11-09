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
 * $Id: time.c,v 1.3 2015-11-09 12:13:47 stefano Exp $
 */


#include <time.h>


time_t time(time_t *store)
{
#asm
        pop     de
        pop     hl
        push    hl
        push    de
        
        ld      a,h
        or      l
        jr      nz,haveparm
        ld      hl,jdate    ; use jdate as a foo parameter location
haveparm:
        push    hl

        ld      hl,0eb4eh   ; probe the Epson PX4 BIOS
        ld      a,(hl)
        cp      0cdh
        jr      nz,nopx4    ; no "jp" found for entry
		ld		c,0
		ld		de,year_px
        call    0eb4eh
		jp		mkjdate
		
nopx4:
		ld		hl,(1)
		ld		de,$4b
		add		hl,de
		ld		a,$3c
		cp		(hl)
		jr		nz,nodtbios
		ld		de,mkjdate
		push	de
		ld		c,0
		ld		de,year_px
		jp		(hl)

nodtbios:
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
        ld      hl,2921     ; shift epoch to 1970 (diff between 12/31/1977 and 01/01/1970)
							; in CP/M day '1' is 1/1/1978
        call    l_long_add
        
        push    de
        push    hl

        ld      hl,20864
        ld      de,1		; load 86400 to dehl, 3600 seconds x 24 hours
        
        call    l_long_mult
        call    l_long_add
        
        pop     ix
        ld      (ix+0),l
        ld      (ix+1),h
        ld      (ix+2),e
        ld      (ix+3),d

        ret


mkjdate:
	; The BIOS funcions put a value in year_px and put month+day in place of jdate
	; TODO: we need to build jdate
	
    ld      a,(jdate+1)
    call    unbcd       ; decode days and put in HL
	push    hl
	ld		(jdate),hl	; at the moment we set jdate with "days" only
	jr      nompmii

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

; 'px' suffixed data spaces and jdate are only placeholders
year_px:	defs	1
jdate:	defs	2           ; Day count, starting on 1st January 1978 (add 2922 days to move epoch to 1970)

hours:	defs	1
mins:	defs	1
secs:	defs	1

weekday_px:  defs 1



#endasm
}
