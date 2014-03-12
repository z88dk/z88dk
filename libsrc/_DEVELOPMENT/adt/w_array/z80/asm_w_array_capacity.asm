
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_capacity(w_array_t *a)
;
; Return the amount of space allocated for the array in words.
;
; ===============================================================

XLIB asm_w_array_capacity
XDEF asm_w_array_size

XDEF asm_w_vector_size, asm_w_vector_capacity, asm_w_vector_max_size

asm_w_vector_max_size:

   inc hl
   inc hl

asm_w_array_capacity:
asm_w_vector_capacity:

   ; enter : hl = array *
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl

   inc hl
   inc hl

asm_w_array_size:
asm_w_vector_size:

   inc hl
   inc hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   srl h
   rr l
   
   ret
