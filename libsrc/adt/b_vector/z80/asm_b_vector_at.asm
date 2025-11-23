
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_at(b_vector_t *v, size_t idx)
;
; Return char stored in vector at index idx.
; If idx is outside the vector's range, return -1.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_at

EXTERN asm_b_array_at

defc asm_b_vector_at = asm_b_array_at

   ; enter : hl = vector *
   ;         bc = idx
   ;
   ; exit  : bc = idx
   ;
   ;         success
   ;
   ;            de = & vector.data[idx]
   ;            hl = vector.data[idx]
   ;            carry reset
   ;
   ;         fail if idx out of range
   ;
   ;            de = vector.size
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
