
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_front(w_vector_t *v)
;
; Return word stored at front of vector.
;
; ===============================================================

XLIB asm_w_vector_front

LIB __vector_back, error_einval_mc

asm_w_vector_front:

   ; enter : hl = w_vector_t *
   ;
   ; exit  : de = vector.array
   ;         bc = vector.size in words
   ;
   ;         success
   ;
   ;            hl = word at front of vector
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

   ex de,hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl
   
   ex de,hl
   
   srl b
   rr c
   
   ret
