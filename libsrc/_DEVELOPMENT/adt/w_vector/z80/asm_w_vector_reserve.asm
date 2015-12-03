
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int w_vector_reserve(w_vector_t *v, size_t n)
;
; Allocate at least n words for the vector's array.
;
; If the array is already larger, do nothing.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_reserve

EXTERN asm_b_vector_reserve, error_zc

asm_w_vector_reserve:

   ; enter : hl = vector *
   ;         bc = n words
   ;
   ; exit  : bc = n * 2 bytes
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
   ; uses  : af, bc, de, hl

   sla c
   rl b
   jp nc, asm_b_vector_reserve
   
   jp error_zc
