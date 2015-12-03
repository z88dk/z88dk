
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)
;
; Remove chars at indices [idx_first, idx_last) from the vector.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_erase_range

EXTERN asm_b_array_erase_range

defc asm_b_vector_erase_range = asm_b_array_erase_range

   ; enter : hl = idx_last
   ;         bc = idx_first
   ;         de = vector *
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx_first = idx of first byte following erased
   ;            carry reset
   ;
   ;         fail if block does not lie within vector.data
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
