
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_AT

; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_vector_at(b_vector_t *a, size_t idx)
;
; Return char stored in vector at index idx.
; If idx is outside the vector's range, return -1.
;
; ===============================================================

asm_b_vector_at:

   ; enter : hl = vector *
   ;         bc = idx
   ;
   ; exit  : bc = idx
   ;
   ;         success
   ;
   ;            de = & vector.data[idx]
   ;            hl = vector.data[idx]
   ;            carry reset
   ;
   ;         fail if idx out of range
   ;
   ;            de = vector.size
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl
