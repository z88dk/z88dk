
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_front(b_vector_t *v)
;
; Return char stored at front of vector.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_front

EXTERN asm_b_array_front

defc asm_b_vector_front = asm_b_array_front

   ; enter : hl = vector *
   ;
   ; exit  : de = vector.data
   ;         bc = vector.size
   ;
   ;         success
   ;
   ;            hl = char at front of vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
