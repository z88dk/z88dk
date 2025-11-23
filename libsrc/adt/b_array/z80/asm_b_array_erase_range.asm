
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last)
;
; Remove chars at indices [idx_first, idx_last) from the array.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_erase_range

EXTERN asm_b_array_erase_block, error_mc

asm_b_array_erase_range:

   ; enter : hl = idx_last
   ;         bc = idx_first
   ;         de = array *
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx_first = idx of first byte following erased
   ;            carry reset
   ;
   ;         fail if block does not lie within array.data
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   or a
   sbc hl,bc
   jp c, error_mc              ; if idx.last < idx.first

   ex de,hl
   jp asm_b_array_erase_block
