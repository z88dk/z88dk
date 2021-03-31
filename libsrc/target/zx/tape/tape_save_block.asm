; int tape_save_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_save_block
PUBLIC _tape_save_block

EXTERN asm_tape_save_block

.tape_save_block
._tape_save_block

   pop hl
   pop bc
   ld a,c
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp asm_tape_save_block
