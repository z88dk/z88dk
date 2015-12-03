
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_erase(b_vector_t *v, size_t idx)
;
; Remove char at vector.data[idx] and return index of char
; that follows the one removed.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_erase

EXTERN asm_b_array_erase

defc asm_b_vector_erase = asm_b_array_erase

   ; enter : hl = vector *
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx = idx of char following the one removed
   ;            carry reset
   ;
   ;         fail if idx outside vector.data
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
