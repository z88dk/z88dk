
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int w_vector_resize(w_vector_t *v, size_t n)
;
; Attempt to resize the vector to n words.
;
; If n <= vector.size, vector.size = n and any elements in
; the vector.array at positions >= n are ignored.
;
; If n > vector.size, vector.data is grown and if that
; is successfully done, new elements are zeroed. 
;
; Carry set on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_resize

EXTERN asm_b_vector_resize, error_zc

asm_w_vector_resize:

   ; enter : hl = vector *
   ;         de = n = desired size in words
   ;
   ; exit  : success
   ;
   ;            hl = non-zero
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   sla e
   rl d
   jp nc, asm_b_vector_resize

   jp error_zc
