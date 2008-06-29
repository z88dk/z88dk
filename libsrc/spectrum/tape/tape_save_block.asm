; int tape_save_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

XLIB tape_save_block

LIB tape_save_block_callee
XREF ASMDISP_TAPE_SAVE_BLOCK_CALLEE

.tape_save_block

   pop hl
   pop bc
   ld a,c
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp tape_save_block_callee + ASMDISP_TAPE_SAVE_BLOCK_CALLEE
