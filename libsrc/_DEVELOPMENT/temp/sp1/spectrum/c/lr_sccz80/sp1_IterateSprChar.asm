; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)
; CALLER linkage for function pointers

XLIB sp1_IterateSprChar

LIB asm_sp1_IterateSprChar

sp1_IterateSprChar:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm_sp1_IterateSprChar
