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
 ;      Galaksija version by Stefano - 2017
 ;
 ;		Y$ is an 11 characters string directly updated by the ROM timer code.
 ;		the "centiseconds" are incremented twice every 50th of second
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
	ld	a,128		; clock enable flag
	ld	(02bafh),a	
	ld	a,(02a80h)
 	cp	48
	call c,isntnum
	cp	58
	call	nc,isntnum
	
        ld      hl,02a86h
        call    unbcd       ; decode seconds and put in HL
        ld      de,100       ; seconds in minute
        call    l_mult      ; hl now is number of seconds
		ld		a,(02a89h)	; 1/100 seconds
		ld		d,0
		ld		e,a
		add		hl,de		; add
        ld      e,d
        push    de
        push    hl

        ld      hl,02a83h
        call    unbcd       ; decode minutes and put in HL
		push	de
		push	hl
        ld      hl,60*100     ; seconds in a minute * 100 (de=0)
        call    l_long_mult
        call    l_long_add	 ; add minutes to seconds to 1/100 seconds
		push	de
        push    hl
		
        ld      hl,02a80h
        call    unbcd       ; decode hours and put in HL
        ld      de,0
        push    de
        push    hl
        ld      e,5
        ld      hl,$7E40	; DEHL=3600*100=$57E40     ; seconds in hours (de=5)
        call    l_long_mult
        call    l_long_add
        ret
	
	
	;	Init clock
isntnum:
		ld	hl,iniclk
		ld	de,02a80h
		ld	bc,11
		ldir
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

        SECTION   data_clib
iniclk:
defm "00:00:00:00"

