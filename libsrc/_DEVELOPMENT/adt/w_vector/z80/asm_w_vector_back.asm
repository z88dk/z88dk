
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_back(w_vector_t *v)
;
; Return word stored at the end of the vector.
; If the vector is empty, return -1.
;
; ===============================================================

XLIB asm_w_vector_back

LIB __vector_back, error_einval_mc

asm_w_vector_back:

   ; enter : hl = w_vector_t *v
   ;
   ; exit  : success
   ;
   ;            hl = last word in vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
   
   call __vector_back
   jp z, error_einval_mc

   ex de,hl                    ; hl = vector.array
   
   dec hl
   add hl,bc                   ; hl = vector.array + vector.size - 1b
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   
   ret
