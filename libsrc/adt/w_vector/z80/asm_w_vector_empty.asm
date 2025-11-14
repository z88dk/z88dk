
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_empty(w_vector_t *v)
;
; Return non-zero if the vector is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_empty

EXTERN l_testword_hl

defc asm_w_vector_empty = l_testword_hl - 2

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
