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
 ;      Like the other platforms (see target/shared/clock.asm) clock() returns
 ;      the raw counter; convert to seconds with CLOCKS_PER_SEC, which is 50
 ;      for this target (the 50 Hz tick rate, see <time.h>, __RC700__).
 ;
 ; --------
 ;
 ;

SECTION code_clib

PUBLIC  clock
PUBLIC  _clock

clock:
_clock:
    ld     hl,(0FFFCH)		; REAL TIME CLOCK, low word
    ld     de,(0FFFEH)		; high word -> return 32-bit in DEHL
    ret

