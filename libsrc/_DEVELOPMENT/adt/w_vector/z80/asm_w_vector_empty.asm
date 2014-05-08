
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_empty(w_vector_t *v)
;
; Return non-zero if the vector is empty.
;
; ===============================================================

PUBLIC asm_w_vector_empty

EXTERN l_testword_hl

asm_w_vector_empty:

   jp l_testword_hl - 2

;defc asm_w_vector_empty = l_testword_hl - 2

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
