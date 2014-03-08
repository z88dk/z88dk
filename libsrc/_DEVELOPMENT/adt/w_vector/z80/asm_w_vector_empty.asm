
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_EMPTY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_empty(w_vector_t *v)
;
; Return non-zero if the vector is empty.
;
; ===============================================================

asm_w_vector_empty:

   ; enter : hl = w_vector_t *
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


