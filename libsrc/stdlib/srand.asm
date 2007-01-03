;
;       Small C+ Runtime Library
;
;       Random number generator
;
;       void srand(int) - seed "random" number
;
; -----
; $Id: srand.asm,v 1.5 2007-01-03 22:23:48 aralbrec Exp $

XLIB srand
XREF _std_seed
XDEF ASMDISP_SRAND

; FASTCALL

; you must declare an integer named "std_seed" in your
; main.c file to hold the seed.
;
; int std_seed;

.srand

   ld (_std_seed),hl
   ret

DEFC ASMDISP_SRAND = 0
