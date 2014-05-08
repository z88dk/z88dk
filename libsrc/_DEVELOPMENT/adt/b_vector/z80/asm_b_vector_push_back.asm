
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_push_back(b_vector_t *v, int c)
;
; Append char to end of vector, return index of appended char.
;
; ===============================================================

PUBLIC asm_b_vector_push_back

EXTERN asm_b_vector_append

asm_b_vector_push_back:

   jp asm_b_vector_append

;defc asm_b_vector_push_back = asm_b_vector_append

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
