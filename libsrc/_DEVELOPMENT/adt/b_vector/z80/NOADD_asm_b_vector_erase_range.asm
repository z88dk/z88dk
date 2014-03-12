
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_ERASE_RANGE

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)
;
; Remove chars at indices [idx_first, idx_last) from the vector.
;
; ===============================================================

asm_b_vector_erase_range:

   ; enter : hl = idx_last
   ;         bc = idx_first
   ;         de = vector *
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx_first = idx of first byte following erased
   ;            carry reset
   ;
   ;         fail if block does not lie within array.data
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
