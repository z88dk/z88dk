
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_vector_append_block(b_vector_t *v, size_t n)
;
; Grow vector by n bytes and return a pointer to the appended
; bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_append_block
PUBLIC asm_b_vector_append_block_extra, asm0_b_vector_append_block_extra

EXTERN error_zc
EXTERN asm_b_array_append_block, __vector_realloc_grow, l_inc_sp

asm_b_vector_append_block:

   ld bc,0

asm_b_vector_append_block_extra:

   ; enter : de = n
   ;         bc = extra
   ;         hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = & bytes added to vector.data
   ;            de = idx of bytes added to vector.data
   ;            bc = n
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save n
   push bc                     ; save extra
   
   call asm_b_array_append_block
   jp nc, l_inc_sp - 4         ; if successful

asm0_b_vector_append_block_extra:

   ; must realloc vector.data
   
   ; de = n
   ; hl = & vector.size
   ; stack = n, extra
   
   inc hl
   
   ld b,(hl)
   dec hl
   ld c,(hl)                   ; bc = vector.size
   
   dec hl
   dec hl

   ; de = n
   ; bc = old_size = vector.size
   ; hl = vector *
   ; stack = n, extra
   
   ex de,hl                    ; hl = n
   
   add hl,bc                   ; hl = old_size + n
   jp c, error_zc - 2
   
   ex de,hl
   ex (sp),hl
   
   ; de = old_size + n
   ; bc = old_size
   ; hl = extra
   ; stack = n, vector *
   
   add hl,de                   ; hl = old_size + n + extra
   jp c, error_zc - 2

   ex de,hl
   ex (sp),hl
   push bc
   
   ld c,e
   ld b,d
   
   ; bc = realloc_size = old_size + n + extra
   ; hl = vector *
   ; stack = n, old_size + n, old_size

   call __vector_realloc_grow
   jp c, error_zc - 3          ; if realloc error
   
   ; hl = vector *
   ; stack = n, old_size + n, old_size
   
   pop de                      ; de = old_size
   pop bc                      ; bc = new_size = old_size + n
   
   inc hl
   inc hl
   inc hl                      ; hl = & vector.size + 1b
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; vector.size = new_size
   dec hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = vector.data
   
   add hl,de                   ; hl = & vector.data[old_size]
   
   pop bc                      ; bc = n
   ret
