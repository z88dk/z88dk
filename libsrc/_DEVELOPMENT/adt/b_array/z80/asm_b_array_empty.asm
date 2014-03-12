
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_empty(b_array_t *a)
;
; Return non-zero if the array is empty.
;
; ===============================================================

XLIB asm_b_array_empty
XDEF asm_w_array_empty, asm_b_vector_empty, asm_w_vector_empty

LIB asm_p_forward_list_empty

asm_b_array_empty:
asm_w_array_empty:
asm_b_vector_empty:
asm_w_vector_empty:

   ; enter : hl = array *
   ;
   ; exit  : if array is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if array is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl

   inc hl
   inc hl
   
   jp asm_p_forward_list_empty
