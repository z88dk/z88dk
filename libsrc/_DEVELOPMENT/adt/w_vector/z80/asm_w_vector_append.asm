
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_vector_append(b_vector_t *v, void *item)
;
; Append word to end of vector, return index of appended word.
;
; ===============================================================

XLIB asm_w_vector_append
XDEF asm_w_vector_push_back

LIB asm_b_vector_append_block, error_mc

asm_w_vector_append:
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

   push bc                     ; save void *item
   
   ld bc,2
   call asm_b_vector_append_block
   
   pop bc                      ; bc = void *item
   jp c, error_mc              ; if vector grow failed
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; write word to vector
   dec hl
   
   ex de,hl
   
   srl h
   rr l                        ; carry flag set should never happen

   ret
