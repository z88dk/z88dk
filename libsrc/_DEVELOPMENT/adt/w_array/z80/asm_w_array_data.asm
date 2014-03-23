
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *w_array_data(w_array_t *a)
;
; Return the address of the array's data, could be 0.
;
; ===============================================================

XLIB asm_w_array_data

LIB l_readword_hl

asm_w_array_data:

   jp l_readword_hl

;defc asm_w_array_data = l_readword_hl

   ; enter : hl = array *
   ;
   ; exit  : hl = array.data
   ;
   ; uses  : a, hl
