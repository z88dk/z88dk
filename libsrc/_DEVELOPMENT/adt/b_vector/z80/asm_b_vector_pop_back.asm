
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_pop_back(b_vector_t *v)
;
; Pop char from end of vector.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_pop_pack

EXTERN asm_b_array_pop_back

defc asm_b_vector_pop_back = asm_b_array_pop_back

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = last char, popped
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
