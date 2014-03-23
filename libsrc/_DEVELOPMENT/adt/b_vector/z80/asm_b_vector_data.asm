
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_vector_data(b_vector_t *v)
;
; Return the address of the vector's data, could be 0.
;
; ===============================================================

XLIB asm_b_vector_data

LIB l_readword_hl

asm_b_vector_data:

   jp l_readword_hl

;defc asm_b_vector_data = l_readword_hl

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.data
   ;
   ; uses  : a, hl
