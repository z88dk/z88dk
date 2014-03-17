
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_array_clear(w_array_t *a)
;
; Clear the array to empty.
;
; ===============================================================

XLIB asm_w_array_clear

LIB l_zeroword_hl

defc asm_w_array_clear = l_zeroword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = & array.size
   ;
   ; uses  : hl
