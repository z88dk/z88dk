
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

XLIB asm_w_vector_reserve

LIB asm_b_vector_reserve, error_enomem_mc

asm_w_vector_reserve:

   ; enter : hl = w_vector_t *
   ;         bc = size_t n
   ;
   ; exit  : bc = size_t n
   ;         de = & vector.capacity + 1b
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   sla c
   rl b
   jr c, too_large
   
   call asm_b_vector_reserve

adjust_bc:

   srl b
   rr c
   
   ret

too_large:

   call adjust_bc
   jp error_enomem_zc
