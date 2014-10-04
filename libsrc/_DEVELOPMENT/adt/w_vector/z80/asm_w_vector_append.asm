
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_vector_append(w_vector_t *v, void *item)
;
; Append word to end of vector, return index of appended word.
;
; ===============================================================

SECTION seg_code_w_vector

PUBLIC asm_w_vector_append

EXTERN asm_b_vector_append_block, asm1_w_array_append, error_mc

asm_w_vector_append:

   ; enter : hl = vector *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & vector.data[idx]
   ;            hl = idx of appended word
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl

   push bc                     ; save item
   
   ld de,2
   call asm_b_vector_append_block

   pop bc                      ; bc = item
   jp nc, asm1_w_array_append
   
   jp error_mc                 ; if vector append failed
