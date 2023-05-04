; int mbc_setcursorpos(char variable, char *value)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC mbc_setcursorpos
PUBLIC _mbc_setcursorpos

EXTERN asm_mbc_setcursorpos

mbc_setcursorpos:
_mbc_setcursorpos:
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_mbc_setcursorpos
