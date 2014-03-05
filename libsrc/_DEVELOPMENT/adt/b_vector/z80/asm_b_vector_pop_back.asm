
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_pop_back(b_vector_t *v)
;
; Pop char from end of vector.
;
; ===============================================================

XLIB asm_b_vector_pop_back

LIB __vector_back, error_einval_mc

asm_b_vector_pop_back:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : success
   ;
   ;            hl = last char, popped
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

   ; bc = vector.size
   ; hl = & vector.size + 1b
   ; de = vector.array

   dec bc                      ; size--
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; write new size
   
   ex de,hl                    ; hl = vector.array
   add hl,bc                   ; hl = vector.array + size - 1
   
   ld l,(hl)
   ld h,0
   
   ret
