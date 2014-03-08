
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_max_size(w_vector_t *v)
;
; Return the vector's max_size in words.
;
; ===============================================================

XLIB asm_w_vector_max_size
XDEF asm_w_vector_capacity, asm_w_vector_size

asm_w_vector_max_size:

   ; enter : hl = w_vector_t *
   ;
   ; exit  : hl = max_size
   ;
   ; uses  : a, hl

   inc hl
   inc hl

asm_w_vector_capacity:

   inc hl
   inc hl

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
