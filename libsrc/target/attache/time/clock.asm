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
 ;      djm 9/1/2000
 ;      Otrona Attachè by Stefano - fall 2024
 ;
 ;
 ; --------
 ;
 ;

SECTION code_clib

PUBLIC  clock
PUBLIC  _clock

EXTERN  l_mult, l_long_mult, l_long_add, __bdos

clock:
_clock:

    ld      c,2
    ld      e,27        ; ESC
    call    __bdos
    ld      c,2
    ld      e,'>'       ; 'what time is it' ?
    call    __bdos


    ;;ld      a,(secs)
    call    unbcd       ; decode seconds and put in HL
    push    hl
    ;;ld      a,(mins)
    call    unbcd       ; decode minutes and put in HL
    ld      de,60       ; seconds in minute
    call    l_mult      ; hl now is number of seconds
    pop     bc
    add     hl,bc       ; hl now is seconds + mins * 60
    push    hl          ; save hl
    ;;ld      a,(hours)
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


;  We just pick a 2 digit number from STDIN
;  'unbcd' name is kept for parallelism with the CP/M routines

unbcd:
	LD 	c,6
	ld	e,255
	call	__bdos
	and	a
	jr	z,unbcd
	push af
unbcd2:
	LD 	c,6
	ld	e,255
	call	__bdos
	and	a
	jr	z,unbcd2
    sub     '0'
    ld      e,a
    add     a
    add     a
    add     e
    add     a           ; *10
    ld      e,a
    pop     hl
    ld      a,h
    sub     '0'
    add     e
    ld      l,a
    ld      h,0
    ret

