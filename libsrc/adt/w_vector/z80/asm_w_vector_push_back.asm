
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_push_back(w_vector_t *v, void *item)
;
; Append word to end of vector, return index of appended word.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_push_back

EXTERN asm_w_vector_append

defc asm_w_vector_push_back = asm_w_vector_append

   ; enter : hl = vector *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & vector.data[idx

   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
