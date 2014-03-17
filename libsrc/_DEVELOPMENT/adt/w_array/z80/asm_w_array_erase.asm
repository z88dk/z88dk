
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_erase(w_array_t *a, size_t idx)
;
; Remove word at array.data[idx] and return index of word
; that follows the one removed.
;
; ===============================================================

XLIB asm_w_array_erase

LIB asm_b_array_erase_block, error_einval_mc

asm_w_array_erase:

   ; enter : hl = array *
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx = idx of word following the one removed
   ;            carry reset
   ;
   ;         fail if idx outside array.data
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   sla c
   rl b
   jp c, error_einval_mc
   
   ld de,2
   call asm_b_array_erase_block
   ret c
   
   srl h
   rr l
   
   ret
