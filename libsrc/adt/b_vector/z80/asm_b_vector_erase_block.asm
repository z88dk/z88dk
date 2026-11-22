
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)
;
; Remove bytes at indices [idx, idx+n) from the vector by copying
; data backward and adjusting vector.size.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_erase_block

EXTERN asm_b_array_erase_block

defc asm_b_vector_erase_block = asm_b_array_erase_block

   ; enter : hl = vector *
   ;         bc = idx
   ;         de = n
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx = index of first byte following erased
   ;            carry reset
   ;
   ;         fail if block at least partly extends outside vector.data
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
