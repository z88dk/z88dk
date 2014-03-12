
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_POP_BACK

; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_pop_back(b_vector_t *v)
;
; Pop char from end of vector.
;
; ===============================================================

asm_b_vector_pop_back:

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
