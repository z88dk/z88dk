
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void ba_free(void *m)
;
; Push block m onto the front of its queue for later reallocation. 
; If m == NULL, ignore as with free().
;
; ===============================================================

XDEF ba_free

ba_free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_ba_free.asm"
