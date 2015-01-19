;
;       Small C+ Runtime Library
;
;       Random number generator
;
;       void srand(int) - seed "random" number
;
; -----
; $Id: srand.asm,v 1.6 2015-01-19 01:33:22 pauloscustodio Exp $

PUBLIC srand
EXTERN _std_seed
PUBLIC ASMDISP_SRAND

; FASTCALL

; you must declare an integer named "std_seed" in your
; main.c file to hold the seed.
;
; int std_seed;

.srand

   ld (_std_seed),hl
   ret

DEFC ASMDISP_SRAND = 0
