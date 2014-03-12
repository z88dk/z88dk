
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_EMPTY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_empty(b_vector_t *v)
;
; Return non-zero if the vector is empty.
;
; ===============================================================

asm_b_vector_empty:

   ; enter : hl = vector *
   ;
   ; exit  : if vector is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if vector is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
