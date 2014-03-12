
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_FRONT

; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_front(b_vector_t *v)
;
; Return char stored at front of vector.
;
; ===============================================================

asm_b_vector_front:

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
