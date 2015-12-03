
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_vector_append(w_vector_t *v, void *item)
;
; Append word to end of vector, return index of appended word.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_append

EXTERN asm_w_array_append, l_inc_sp, error_mc, asm0_b_vector_append_block_extra

asm_w_vector_append:

   ; enter : hl = vector *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & vector.data[idx

   ;            hl = idx of appended word
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl

   push hl                     ; save vector*
   
   call asm_w_array_append
   jp nc, l_inc_sp - 2         ; if successful append
   
   pop hl
   
   ; append failed, need to realloc
   
   ; hl = vector *
   ; bc = item
   
   push bc                     ; save item
   
   call grow_word              ; grow vector by two bytes
   
   pop bc                      ; bc = item
   jp c, error_mc              ; grow failed

   ; hl = & word added to vector.data
   ; de = idx of word in bytes
   ; bc = item
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; append item
   dec hl
   
   ex de,hl
   
   srl h
   rr l
   
   ret

grow_word:

   ld de,2
   push de
   
   ld b,d
   ld c,d
   push bc
   
   inc hl
   inc hl
   
   ; de = 2
   ; hl = & vector.size
   ; stack = n=2, extra=0
   
   jp asm0_b_vector_append_block_extra
