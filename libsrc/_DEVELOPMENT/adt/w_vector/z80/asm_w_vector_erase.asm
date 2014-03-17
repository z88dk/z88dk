
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_erase(w_vector_t *v, size_t idx)
;
; Remove word at vector.data[idx] and return new index of
; word that follows the one removed.
;
; ===============================================================

XLIB asm_w_vector_erase

LIB asm_w_array_erase

defc asm_w_vector_erase = asm_w_array_erase

   ; enter : hl = vector *
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx = idx of word following the one removed
   ;            carry reset
   ;
   ;         fail if idx outside vector.data
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
