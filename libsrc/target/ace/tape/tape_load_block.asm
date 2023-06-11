; int tape_load_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_load_block
PUBLIC _tape_load_block

EXTERN asm_tape_load_block

.tape_load_block
._tape_load_block

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp asm_tape_load_block
