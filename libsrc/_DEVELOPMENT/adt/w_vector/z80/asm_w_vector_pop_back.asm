
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_pop_back(w_vector_t *v)
;
; Pop word from end of vector.
;
; ===============================================================

XLIB asm_w_vector_pop_back

LIB asm_w_array_pop_back

defc asm_w_vector_pop_back = asm_w_array_pop_back

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
