
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_array_insert_block(b_array_t *a, size_t idx, size_t n)
;
; Inserts n uninitialized bytes before idx into the array and
; returns the address of the inserted bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_insert_block
PUBLIC asm0_b_array_insert_block, asm1_b_array_insert_block

EXTERN asm0_b_array_append_block, asm_memmove, error_zc

asm_b_array_insert_block:

   ; enter : hl = array *
   ;         de = n
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            hl = & array.data[idx]
   ;            carry reset
   ;
   ;         fail if idx > array.size or array too small
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl

asm0_b_array_insert_block:

   push de                     ; save n
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl                    ; hl = array.size
   
   or a
   sbc hl,bc                   ; hl = array.size - idx
   jp c, error_zc - 1          ; if array.size < idx
   
   ; bc = idx
   ; hl = array.size - idx
   ; de = & array.size + 1b
   ; stack = n

   ex (sp),hl
   push bc
   ex de,hl
   
   ; hl = & array.size + 1b
   ; de = n
   ; stack = array.size - idx, idx
   
   dec hl                      ; hl = & array.size
   push hl                     ; save & array.size
   
   call asm0_b_array_append_block
   
   pop hl                      ; hl = & array.size
   jp c, error_zc - 2          ; if array too small

asm1_b_array_insert_block:

   ; sufficient room for insertion

   ; hl = & array.size
   ; bc = n
   ; stack = array.size - idx, idx

   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = array.data
   
   pop hl                      ; hl = idx
   add hl,de
   
   ld e,l
   ld d,h                      ; de = & array.data[idx]

   add hl,bc                   ; hl = & array.data[idx + n]
   
   pop bc                      ; bc = array.size - idx
   ex de,hl
   
   ; hl = & array.data[idx]
   ; de = & array.data[idx + n]
   ; bc = array.size - idx

   push hl                     ; save & array.data[idx]
   
   call asm_memmove            ; copy array data forward
   
   pop hl                      ; hl = & array.data[idx]
   ret
