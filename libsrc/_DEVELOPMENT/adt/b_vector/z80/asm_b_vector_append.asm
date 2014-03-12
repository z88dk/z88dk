
; ===============================================================
; Mar 2014
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
   
   push bc                     ; save char
   
   ld de,1
   call asm_b_vector_append_block
   
   pop bc                      ; bc = char
   jp c, error_mc              ; if append error
   
   ld (hl),c                   ; append char to end
   
   ex de,hl                    ; de = & array.data[idx], hl = idx
   ret
