
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_array_clear(b_array_t *a)
;
; Clear the array to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_clear

EXTERN l_zeroword_hl

defc asm_b_array_clear = l_zeroword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = & array.size
   ;
   ; uses  : hl
