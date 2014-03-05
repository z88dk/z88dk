
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_front(b_vector_t *v)
;
; Return char stored at front of vector.
;
; ===============================================================

XLIB asm_b_vector_front

LIB __vector_back, error_einval_mc

asm_b_vector_front:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : de = vector.array
   ;         bc = vector.size
   ;
   ;         success
   ;
   ;            hl = char at front of vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   call __vector_back
   jp z, error_einval_mc       ; if vector is empty
   
   ; de = vector.array
   ; bc = vector.size

   ld a,(de)
   
   ld l,a
   ld h,0                      ; hl = char at front of vector
   
   ret
