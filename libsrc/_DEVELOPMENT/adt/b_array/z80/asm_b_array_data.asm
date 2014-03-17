
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_array_data(b_array_t *a)
;
; Return the address of the array's data, could be 0.
;
; ===============================================================

XLIB asm_b_array_data

LIB l_readword_hl

defc asm_b_array_data = l_readword_hl

   ; enter : hl = array *
   ;
   ; exit  : hl = array.data
   ;
   ; uses  : a, hl
