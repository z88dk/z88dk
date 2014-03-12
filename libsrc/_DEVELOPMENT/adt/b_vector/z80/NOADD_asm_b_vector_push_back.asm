
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_vector_APPEND

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_push_back(b_vector_t *a, int c)
;
; Append char to end of vector, return index of appended char.
;
; ===============================================================

asm_b_vector_push_back:

   ; enter : hl = vector *
   ;         bc = int c
   ;
   ; exit  : bc = int c
   ;
   ;         success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, de, hl
