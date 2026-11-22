
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_erase(b_array_t *a, size_t idx)
;
; Remove char at array.data[idx] and return index of char
; that follows the one removed.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_erase

EXTERN asm_b_array_erase_block

asm_b_array_erase:

   ; enter : hl = array *
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx = idx of char following the one removed
   ;            carry reset
   ;
   ;         fail if idx outside array.data
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   ld de,1
   jp asm_b_array_erase_block
