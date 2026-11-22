
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

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_erase

EXTERN asm_b_array_erase_block, error_mc

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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   sla c
   rl b
   jp c, error_mc
   
   ld de,2
   call asm_b_array_erase_block
   ret c
   
   srl h
   rr l
   
   ret
