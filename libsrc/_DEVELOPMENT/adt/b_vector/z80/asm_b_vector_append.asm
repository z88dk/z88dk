
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_append(b_vector_t *v, int c)
;
; Append char to end of vector, return index of appended char.
;
; ===============================================================

XLIB asm_b_vector_append
XDEF asm_b_vector_push_back

LIB asm_b_vector_append_block, error_mc

asm_b_vector_append:
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

   push bc                     ; save char
   
   ld bc,1
   call asm_b_vector_append_block
   
   pop bc                      ; bc = char
   jp c, error_mc              ; if vector grow failed
   
   ld (hl),c                   ; write char to vector
   
   ex de,hl
   ret
