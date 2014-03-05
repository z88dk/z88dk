
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_APPEND

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_push_back(b_vector_t *v, int c)
;
; Append char to end of vector, return index of appended char.
;
; ===============================================================

asm_b_vector_push_back:

   ; enter : hl = b_vector_t *
   ;         bc = int c
   ;
   ; exit  : bc = int c
   ;
   ;         success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, de, hl
