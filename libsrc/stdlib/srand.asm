;
;       Small C+ Runtime Library
;
;       Random number generator
;
;       void srand(int) - seed "random" number
;
; -----
; $Id: srand.asm,v 1.4 2006-12-31 22:14:53 aralbrec Exp $

XLIB srand
XREF _std_seed

; FASTCALL

; you must declare an integer named "std_seed" in your
; main.c file to hold the seed.
;
; int std_seed;

.srand

   ld (_std_seed),hl
   ret
