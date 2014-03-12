
*** IMPLEMENTED AS PART OF ASM_W_ARRAY_POP_BACK

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_pop_back(w_vector_t *v)
;
; Pop word from end of vector.
;
; ===============================================================

asm_w_vector_pop_back:

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = last word, popped
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
