
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last)
;
; Remove words at indices [idx_first, idx_last) from the array.
;
; ===============================================================

PUBLIC asm_w_array_erase_range

EXTERN asm_b_array_erase_block, error_einval_mc

asm_w_array_erase_range:

   ; enter : hl = idx_last
   ;         bc = idx_first
   ;         de = array *
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx_first = idx of first word following erased
   ;            carry reset
   ;
   ;         fail if block does not lie within array.data
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   or a
   sbc hl,bc
   jp c, error_einval_mc       ; if idx.last < idx.first
   
   add hl,hl
   jp c, error_einval_mc
   
   sla c
   rl b
   jp c, error_einval_mc

   ex de,hl
   call asm_b_array_erase_block
   ret c
   
   srl h
   rr l
   
   ret
