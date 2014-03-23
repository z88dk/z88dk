
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_array_clear(b_array_t *a)
;
; Clear the array to empty.
;
; ===============================================================

XLIB asm_b_array_clear

LIB l_zeroword_hl

asm_b_array_clear:

   jp l_zeroword_hl - 2

;defc asm_b_array_clear = l_zeroword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = & array.size
   ;
   ; uses  : hl
