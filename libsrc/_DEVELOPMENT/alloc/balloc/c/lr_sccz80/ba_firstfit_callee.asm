
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

XDEF ba_firstfit_callee

ba_firstfit_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld a,c
   
   INCLUDE "../../z80/asm_ba_firstfit.asm"
