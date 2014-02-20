
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_erase(b_vector_t *v, size_t idx)
;
; Remove char at vector.array[idx] and return new index of
; char that follows the one removed.
;
; ===============================================================

XLIB asm_b_vector_erase

LIB asm_b_vector_erase_block

asm_b_vector_erase:

   ; enter : hl = b_vector_t *
   ;         bc = size_t idx
   ;
   ; exit  : success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx = new idx of char following the one removed
   ;            carry reset
   ;
   ;         fail if block exceeds vector.array
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   ld de,1
   jp asm_b_vector_erase_block
