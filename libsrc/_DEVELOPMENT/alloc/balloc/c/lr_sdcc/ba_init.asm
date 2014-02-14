
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void ba_init(unsigned char num)
;
; Clear all queues to empty.
;
; ===============================================================

XDEF ba_init

ba_init:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_ba_init.asm"
