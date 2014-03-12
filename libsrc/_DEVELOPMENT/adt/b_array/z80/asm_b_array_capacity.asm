
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_capacity(b_array_t *a)
;
; Return the amount of space allocated for the array.
;
; ===============================================================

XLIB asm_b_array_capacity
XDEF asm_b_array_size, asm_b_array_data

XDEF asm_b_vector_max_capacity, asm_b_vector_capacity, asm_b_vector_size, asm_b_vector_data

XDEF asm_w_array_data, asm_w_vector_data

asm_b_vector_max_capacity:

   inc hl
   inc hl

asm_b_array_capacity:
asm_b_vector_capacity:

   ; enter : hl = array *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl

   inc hl
   inc hl

asm_b_array_size:
asm_b_vector_size:

   inc hl
   inc hl

asm_b_array_data:
asm_w_array_data:
asm_b_vector_data:
asm_w_vector_data:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ret
