
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_array_append_block(b_array_t *a, size_t n)
;
; Expand committed portion of array by n bytes and return a
; pointer to the appended bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_append_block
PUBLIC asm0_b_array_append_block

EXTERN __1_array_expand

asm_b_array_append_block:

   ; Attempt to grow committed portion of array by n bytes
   ;
   ; enter : hl = array *
   ;         de = n
   ;
   ; exit  : success
   ;
   ;            bc = n
   ;            de = old array.size
   ;            hl = & array.data[old array.size]
   ;            carry reset
   ;
   ;         fail if array too small to accommodate
   ;
   ;            de = n
   ;            hl = & array.size
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl                      ; hl = & array.size

asm0_b_array_append_block:

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = array.size
   
   push de                     ; save n
   
   ex de,hl
   
   add hl,bc                   ; hl = new_size = n + array.size
   jr c, error_1               ; if new_size > 64k
   
   ; bc = array.size
   ; de = & array.size + 1b
   ; hl = new_size
   ; stack = n
   
   call __1_array_expand       ; expand array to minimum new_size bytes
   jr c, error_0               ; if array is too small

   ; hl = & array.size + 1b
   ; bc = old array.size
   ; stack = n
   
   dec hl
   dec hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = array.data
   
   add hl,bc                   ; hl = & array.data[old array.size]
   
   ld e,c
   ld d,b                      ; de = old array.size
   
   pop bc                      ; bc = n
   ret

error_1:

   ; de = & array.size + 1b
   ; carry set
   ; stack = n

   ex de,hl

error_0:

   ; hl = & array.size + 1b
   ; carry set
   ; stack = n

   dec hl                      ; hl = & array.size
   pop de                      ; de = n
   
   ret
