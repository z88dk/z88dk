
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_append(b_vector_t *v, int c)
;
; Append char to end of vector, return index of appended char.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_append

EXTERN asm0_b_array_append, asm0_b_vector_append_block_extra
EXTERN l_inc_sp, error_mc

asm_b_vector_append:

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
   ;            carry set
   ;
   ; uses  : af, de, hl

   inc hl
   inc hl
   
   push hl                     ; save & vector.size
   
   call asm0_b_array_append    ; append without growing
   jp nc, l_inc_sp - 2         ; if successful
   
   pop hl                      ; hl = & vector.size

   ; must grow vector
   
   push bc                     ; save char
   
   call grow_vector
   
   pop bc                      ; bc = char
   jp c, error_mc              ; if append error
   
   ld (hl),c                   ; append char to end
   
   ex de,hl                    ; de = & array.data[idx], hl = idx
   ret

grow_vector:

   ld de,1
   push de
   
   dec de
   push de
   
   inc de
   
   ; de = n = 1
   ; hl = & vector.size
   ; stack = n, extra
   
   jp asm0_b_vector_append_block_extra
