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
 ; --------
 ;
 ;      RC-700 implementation notes
 ;
 ;      A free-running 32-bit tick counter is kept in RAM at 0FFFCH..0FFFFH
 ;      (LSW at 0FFFCH, MSW at 0FFFEH).  It is incremented by the CRT
 ;      interrupt service routine in the system firmware/BIOS, i.e. once per
 ;      Intel 8275 frame interrupt (~50 Hz).  The counter therefore only
 ;      advances while that interrupt is live -- on real hardware or under
 ;      MAME.  A bare emulator such as z88dk-ticks does NOT run the CRT ISR,
 ;      so the counter stays put unless a test writes 0FFFCH by hand.
 ;
 ;      clock() reads the 32-bit counter and divides it by 50 (the tick
 ;      rate).  With CLOCKS_PER_SEC == 1 on this target (<time.h>, __CPM__),
 ;      the return value is whole seconds; sub-second resolution is lost in
 ;      the /50.
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

