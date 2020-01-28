 ;
 ;      clock() function
 ;
 ;      Return the current time basically
 ;      Typically used to find amount of CPU time
 ;      used by a program.
 ;
 ;      ANSI allows any time at start of program so
 ;      properly written programs should call this fn
 ;      twice and take the difference
 ;
 ;      Memotech MTX version by Stefano - 2017
 ;
 ;		FD57 (ds 7) - HHMMSSx  (x counts from 48 to 173 in 125th of second)
 ;
 ; --------
 ; $Id: clock.asm $
 ;
 ;

	SECTION		code_clib
PUBLIC clock
PUBLIC _clock

EXTERN l_mult, l_long_mult, l_long_add

clock:
_clock:
        ld      hl,$fd5b
        call    unbcd       ; decode seconds and put in HL
        ld      de,125       ; seconds in minute
        call    l_mult      ; hl now is number of seconds
		ld		a,($fd5d)	; 1/125 seconds
		ld		d,0
		ld		e,a
		add		hl,de		; add
        ld      e,d
        push    de
        push    hl

        ld      hl,$fd59
        call    unbcd       ; decode minutes and put in HL
		push	de
		push	hl
        ld      hl,60*125     ; seconds in a minute * 125 (de=0)
        call    l_long_mult
        call    l_long_add	 ; add minutes to seconds to 1/125 seconds
		push	de
        push    hl
		
        ld      hl,$fd57
        call    unbcd       ; decode hours and put in HL
        ld      de,0
        push    de
        push    hl
        ld      e,6
        ld      hl,$DDD0	; DEHL=3600*125=$6DDD0     ; seconds in hours (de=6)
        call    l_long_mult
        call    l_long_add
        ret


unbcd:
	ld a,(hl)
	ld b,a
	add a
	add a
	add b
	add a	; *10
	inc hl
	add (hl)
	ld	l,a
	ld	h,0
	ret
