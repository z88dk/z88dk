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
 ;      RC-700 by Stefano - spring 2025
 ;
 ;
 ; --------
 ;
 ;

SECTION code_clib

PUBLIC  clock
PUBLIC  _clock

EXTERN  l_long_div_u

clock:
_clock:
    ld     hl,(0FFFCH)		; REAL TIME CLOCK
    ld     de,(0FFFEH)
    push   de      ; number MSW
    push   hl      ; number LSW
    ld     l,50
    ld     h,0
    ld     d,h
    ld     e,h
    call   l_long_div_u     ; Don't mess the stack: DO NOT just jump to l_long_div_u !
	ret

