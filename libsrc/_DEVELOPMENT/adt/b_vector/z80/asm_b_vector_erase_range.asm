
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)
;
; Remove chars at indices [idx_first, idx_last) from the vector.
;
; ===============================================================

XLIB asm_b_vector_erase_range

LIB asm_b_vector_erase_block, error_einval_mc

asm_b_vector_erase_range:

   ; enter : hl = idx_last
   ;         bc = idx_first
   ;         de = b_vector_t *
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
   sbc hl,de
   jp c, error_einval_mc       ; if idx.last < idx.first

   ex de,hl
   jp asm_b_vector_erase_block
