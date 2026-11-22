
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_empty(b_vector_t *v)
;
; Return non-zero if the vector is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_empty

EXTERN l_testword_hl

defc asm_b_vector_empty = l_testword_hl - 2

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
