
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_firstfit(unsigned int queue, unsigned char num)
;
; Allocate a block from the first queue in [queue, queue+num-1]
; that has a block available.
;
; ===============================================================

XDEF ba_firstfit

ba_firstfit:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   ld a,c

   INCLUDE "../../z80/asm_ba_firstfit.asm"
