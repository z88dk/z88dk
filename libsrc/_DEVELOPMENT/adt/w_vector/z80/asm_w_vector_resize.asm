
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
; If n > vector.size, vector.array is grown and if that
; is successfully done, new elements are zeroed. 
;
; Carry set on failure.
;
; ===============================================================

XLIB asm_w_vector_resize

LIB asm_b_vector_resize, error_enomem_zc

asm_w_vector_resize:

   ; enter : hl = w_vector_t *
   ;         bc = size_t n = desired size in words
   ;
   ; exit  : success
   ;
   ;            hl = non-zero
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   sla c
   rl b
   jp nc, asm_b_vector_resize

   jp error_enomem_zc
