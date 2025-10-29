
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_array_data(b_array_t *a)
;
; Return the address of the array's data, could be 0.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_data

EXTERN l_readword_hl

defc asm_b_array_data = l_readword_hl

   ; enter : hl = array *
   ;
   ; exit  : hl = array.data
   ;
   ; uses  : a, hl
