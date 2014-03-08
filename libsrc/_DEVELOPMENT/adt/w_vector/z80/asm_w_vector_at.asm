
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_at(b_vector_t *v, size_t idx)
;
; Return word stored in vector at index idx.
; If idx is outside the vector's range, return -1.
;
; ===============================================================

XLIB asm_w_vector_at

LIB __vector_at

asm_w_vector_at:

   ; enter : hl = w_vector_t *
   ;         bc = size_t idx
   ;
   ; exit  : bc = size_t idx
   ;         de = vector.size
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
   ; uses  : af, bc, de, hl
   
   sla c
   rl b
   jp c, error_einval_mc       ; if word idx out of range

   call __vector_at
   ret c

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = vector.array[idx]
   
   srl b
   rr c
   
   ret
