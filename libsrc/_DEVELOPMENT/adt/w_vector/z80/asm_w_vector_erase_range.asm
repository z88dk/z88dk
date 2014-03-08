
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)
;
; Remove chars at indices [idx_first, idx_last) from the vector.
;
; ===============================================================

XLIB asm_w_vector_erase_range

LIB asm_b_vector_erase_block, error_einval_mc

asm_w_vector_erase_range:

   ; enter : hl = idx_last
   ;         bc = idx_first
   ;         de = w_vector_t *
   ;
   ; exit  : success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx_first = idx of first byte following erased
   ;            carry reset
   ;
   ;         fail if block does not lie within vector.array
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   or a
   sbc hl,bc
   jp c, error_einval_mc       ; if idx.last < idx.first

   sla c
   rl b
   jp c, error_einval_mc
   
   add hl,hl
   jp c. error_einval_mc

   ex de,hl
   call asm_b_vector_erase_block
   ret c
   
   srl h
   rr l
   
   ret
