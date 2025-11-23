
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_array_clear(w_array_t *a)
;
; Clear the array to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_clear

EXTERN l_zeroword_hl

defc asm_w_array_clear = l_zeroword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = & array.size
   ;
   ; uses  : hl
