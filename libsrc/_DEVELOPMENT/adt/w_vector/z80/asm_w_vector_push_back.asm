
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_VECTOR_APPEND

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_push_back(w_vector_t *v, int c)
;
; Append char to end of vector, return index of appended char.
;
; ===============================================================

asm_w_vector_push_back:

   ; enter : hl = w_vector_t *
   ;         bc = void *item
   ;
   ; exit  : bc = void *item
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
