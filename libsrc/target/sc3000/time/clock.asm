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
 ;      SEGA SC-3000 version by Stefano - 2017
 ;
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

        ld      a,(948Eh)	; seconds
		call	unbcd
        ld      de,50
        call    l_mult		; *50
		ex		de,hl
		ld      a,(948Dh)	; 1/50 seconds, BCD encoding
		call	unbcd
			
		add		hl,de		; add
		
		ld		de,0
        push    de
        push    hl

        ld      a,(948Fh)	; minutes
		call	unbcd
		push	de
		push	hl
        ld      hl,60*50     ; seconds in a minute * 50 (de=0)
        call    l_long_mult
        call    l_long_add	 ; add minutes to seconds to 1/50 seconds
		push	de
        push    hl
		
        ld      a,(9490h)	; hours
		call	unbcd
        ld      de,0
        push    de
        push    hl
        ld      e,2
        ld      hl,$BF20	; DEHL=3600*50=$2BF20     ; seconds in hours (de=2)
        call    l_long_mult
        call    l_long_add
		
        ret


unbcd:
			push af
			and $0f
			ld	c,a
			pop af
			srl a
			srl a
			srl a
			srl a
			ld b,a
			add a
			add a
			add b
			add a	; *10
			add c
			ld	l,a
			ld	h,0
			ret
