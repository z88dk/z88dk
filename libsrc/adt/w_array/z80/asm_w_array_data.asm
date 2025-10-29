
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *w_array_data(w_array_t *a)
;
; Return the address of the array's data, could be 0.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_data

EXTERN l_readword_hl

defc asm_w_array_data = l_readword_hl

   ; enter : hl = array *
   ;
   ; exit  : hl = array.data
   ;
   ; uses  : a, hl
