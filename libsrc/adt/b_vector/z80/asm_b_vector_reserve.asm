
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_reserve(b_vector_t *v, size_t n)
;
; Allocate at least n bytes for the vector's array.
;
; If the array is already larger, do nothing.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_reserve

EXTERN __0_vector_realloc_grow, error_mnc

asm_b_vector_reserve:

   ; enter : hl = vector *
   ;         bc = n
   ;
   ; exit  : bc = n
   ;         de = & vector.capacity + 1b
   ;
   ;         success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if realloc failed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl

   ld de,4
   add hl,de                   ; hl = & vector.capacity
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.capacity

   ex de,hl
   
   sbc hl,bc                   ; hl = vector.capacity - n
   jp nc, error_mnc            ; if vector.capacity >= n
   
   ; realloc required
   
   ex de,hl
   
   inc hl
   inc hl
   
   ; hl = & vector.max_size + 1b
   ; bc = n
   
   call __0_vector_realloc_grow
   ret c                       ; if realloc failed
   
   ; hl = vector *
   ; bc = n
   
   ld de,5
   add hl,de                   ; hl = & vector.capacity + 1b
   
   ex de,hl
   jp error_mnc
