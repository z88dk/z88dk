
; void *b_array_append_block(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_append_block_callee
PUBLIC b_array_append_block_entry

EXTERN error_zc, asm_b_array_append_block

b_array_append_block_callee:

   pop hl
   pop de
   ex (sp),hl

b_array_append_block_entry:

   call asm_b_array_append_block
   ret nc
   
   jp error_zc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_append_block_callee
defc _b_array_append_block_callee = b_array_append_block_callee
ENDIF

