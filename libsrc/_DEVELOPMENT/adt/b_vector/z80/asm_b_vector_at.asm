
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_at(b_vector_t *v, size_t idx)
;
; Return char stored in vector at index idx.
; If idx is outside the vector's range, return -1.
;
; ===============================================================

XLIB asm_b_vector_at

LIB __vector_at

asm_b_vector_at:

   ; enter : hl = b_vector_t *
   ;         bc = size_t idx
   ;
   ; exit  : bc = size_t idx
   ;
   ;         success
   ;
   ;            hl = vector.array[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl
   
   call __vector_at
   ret c

   ld l,(hl)
   ld h,0                      ; hl = array[idx]
   
   ret
