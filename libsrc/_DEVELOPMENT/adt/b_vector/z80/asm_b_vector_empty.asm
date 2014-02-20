
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_empty(b_vector_t *v)
;
; Return non-zero if the vector is empty.
;
; ===============================================================

XLIB asm_b_vector_empty

LIB asm_p_forward_list_empty

asm_b_vector_empty:

   ; enter : hl = b_vector_t *
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

   inc hl
   inc hl
   
   jp asm_p_forward_list_empty
