
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_erase(w_vector_t *v, size_t idx)
;
; Remove word at vector.array[idx] and return new index of
; word that follows the one removed.
;
; ===============================================================

XLIB asm_w_vector_erase

LIB asm_b_vector_erase_block, error_einval_mc

asm_w_vector_erase:

   ; enter : hl = w_vector_t *
   ;         bc = size_t idx
   ;
   ; exit  : success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx = new idx of char following the one removed
   ;            carry reset
   ;
   ;         fail if block exceeds vector.array
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   sla c
   rl b                        ; bc = byte idx
   jp c, error_einval_mc

   ld de,2
   call asm_b_vector_erase_block
   ret c
   
   srl h
   rr l
   
   ret
