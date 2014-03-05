
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_back(b_vector_t *v)
;
; Return char stored at the end of the vector.
; If the vector is empty, return -1.
;
; ===============================================================

XLIB asm_b_vector_back

LIB __vector_back, error_einval_mc

asm_b_vector_back:

   ; enter : hl = b_vector_t *v
   ;
   ; exit  : success
   ;
   ;            hl = last char in vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
   
   call __vector_back
   jp c, error_einval_mc

   ex de,hl                    ; hl = vector.array
   
   dec hl
   add hl,bc                   ; hl = vector.array + vector.size - 1b
   
   ld l,(hl)
   ld h,0
   
   ret
