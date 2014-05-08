
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_array_clear(w_array_t *a)
;
; Clear the array to empty.
;
; ===============================================================

PUBLIC asm_w_array_clear

EXTERN l_zeroword_hl

asm_w_array_clear:

   jp l_zeroword_hl - 2

;defc asm_w_array_clear = l_zeroword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = & array.size
   ;
   ; uses  : hl
