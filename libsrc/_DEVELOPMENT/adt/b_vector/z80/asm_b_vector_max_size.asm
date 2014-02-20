
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_max_size(b_vector_t *v)
;
; Return the vector's max_size.
;
; ===============================================================

XLIB asm_b_vector_max_size
XDEF asm_b_vector_capacity, asm_b_vector_size, asm_b_vector_data

asm_b_vector_max_size:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = max_size
   ;
   ; uses  : a, hl

   inc hl
   inc hl

asm_b_vector_capacity:

   inc hl
   inc hl

asm_b_vector_size:

   inc hl
   inc hl

asm_b_vector_data:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ret
