
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_back(b_vector_t *v)
;
; Return char stored at the end of the vector.
; If the vector is empty, return -1.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_back

EXTERN asm_b_array_back

defc asm_b_vector_back = asm_b_array_back

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            de = & last char in vector
   ;            hl = last char in vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
