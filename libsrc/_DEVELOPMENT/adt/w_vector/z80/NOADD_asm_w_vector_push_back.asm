
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_VECTOR_APPEND

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_push_back(w_vector_t *v, void *item)
;
; Append word to end of vector, return index of appended word.
;
; ===============================================================

asm_w_vector_push_back:

   ; enter : hl = vector *
   ;         bc = item
   ;
   ; exit  : bc = item
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
   ;            carry set, errno set
   ;
   ; uses  : af, de, hl
