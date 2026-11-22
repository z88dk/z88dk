
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)
;
; Inserts n uninitialized bytes before idx into the vector and
; returns the address of the inserted bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_insert_block
PUBLIC asm0_b_vector_insert_block

EXTERN error_zc
EXTERN asm_b_vector_append_block, asm1_b_array_insert_block

asm_b_vector_insert_block:

   ; enter : hl = vector *
   ;         de = n
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            hl = & vector.data[idx]
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

   inc hl
   inc hl

asm0_b_vector_insert_block:

   push de                     ; save n
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = vector.size
   
   or a
   sbc hl,bc                   ; hl = vector.size - idx
   jp c, error_zc - 1          ; if vector.size < idx
   
   ; bc = idx
   ; hl = vector.size - idx
   ; de = & vector.size + 1b
   ; stack = n

   ex (sp),hl
   push bc
   ex de,hl
   
   ; hl = & vector.size + 1b
   ; de = n
   ; stack = vector.size - idx, idx
   
   dec hl                      ; hl = & vector.size
   push hl                     ; save & vector.size
   
   dec hl
   dec hl                      ; hl = vector *
   
   call asm_b_vector_append_block
   
   pop hl                      ; hl = & vector.size
   jp nc, asm1_b_array_insert_block
   
   jp error_zc - 2             ; if append failed
