
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_front(w_vector_t *v)
;
; Return word stored at front of vector.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_front

EXTERN asm_w_array_front

defc asm_w_vector_front = asm_w_array_front

   ; enter : hl = vector *
   ;
   ; exit  : de = vector.data
   ;         bc = vector.size in bytes
   ;
   ;         success
   ;
   ;            hl = word at front of vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
