
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)
;
; Inserts n bytes before idx into vector's array and return
; the address of the inserted bytes.
;
; ===============================================================

XLIB asm_b_vector_insert_block

LIB asm_b_vector_append_block, asm_memmove
LIB error_einval_zc, error_zc

asm_b_vector_insert_block:

   ; enter : hl = b_vector_t *
   ;         de = size_t n
   ;         bc = size_t idx
   ;
   ; exit  : success
   ;
   ;            hl = & vector.array[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save n
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.size
   
   or a
   sbc hl,bc                   ; hl = vector.size - idx
   jp c, error_einval_zc - 1   ; if vector.size < idx
   
   ; bc = idx
   ; hl = vector.size - idx
   ; de = & vector.size + 1b
   ; stack = n

   ex (sp),hl
   push bc
   
   ld c,l
   ld b,h
   
   ex de,hl
   
   dec hl
   dec hl
   dec hl
   
   ; bc = n
   ; hl = vector *
   ; stack = vector.size - idx, idx

   push hl                     ; save vector *
   
   call asm_b_vector_append_block  ; grow vector by n bytes
   
   pop hl                      ; hl = vector *
   jp c, error_zc - 2          ; if growth not possible
   
   ; hl = vector *
   ; bc = n
   ; stack = size - idx, idx

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.array
   
   pop hl
   add hl,de
   
   ld e,l
   ld d,h                      ; de = vector.array + idx
   
   add hl,bc                   ; hl = vector.array + idx + n
   
   pop bc                      ; bc = size - idx
   ex de,hl
   
   ; bc = size - idx
   ; de = vector.array + idx + n
   ; hl = vector.array + idx
   
   push hl
   
   call asm_memmove            ; copy array data forward
   
   pop hl                      ; hl = & vector.array[idx]
   ret
