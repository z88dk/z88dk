
*** IMPLEMENTED AS PART OF ASM_W_ARRAY_AT

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_at(w_vector_t *v, size_t idx)
;
; Return word stored in vector at index idx.
; If idx is outside the vector's range, return -1.
;
; ===============================================================

asm_w_vector_at:

   ; enter : hl = vector *
   ;         bc = idx
   ;
   ; exit  : bc = idx
   ;         de = vector.size
   ;
   ;         success
   ;
   ;            de = & vector.data[idx]
   ;            hl = vector.data[idx]
   ;            carry reset
   ;
   ;         fail if idx out of range
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl
