
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

XLIB asm_b_vector_back

LIB asm_b_array_back

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
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
