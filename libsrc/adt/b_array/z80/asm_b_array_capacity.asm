
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_capacity(b_array_t *a)
;
; Return the amount of space allocated for the array.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_capacity

EXTERN l_readword_hl

defc asm_b_array_capacity = l_readword_hl - 4

   ; enter : hl = array *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
