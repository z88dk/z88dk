
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_size(w_array_t *a)
;
; Return the array's current size in words.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_size

EXTERN l_readword_2_hl

defc asm_w_array_size = l_readword_2_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
