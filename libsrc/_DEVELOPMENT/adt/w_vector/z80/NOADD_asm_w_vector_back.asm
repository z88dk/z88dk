
*** IMPLEMENTED AS PART OF ASM_W_ARRAY_BACK

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_back(w_vector_t *v)
;
; Return word stored at the end of the vector.
; If the vector is empty, return -1.
;
; ===============================================================

asm_w_vector_back:

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            de = & last word in vector
   ;            hl = last word in vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
