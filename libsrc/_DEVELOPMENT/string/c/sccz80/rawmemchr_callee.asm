
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_string

PUBLIC rawmemchr_callee

rawmemchr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld a,c
   
   INCLUDE "string/z80/asm_rawmemchr.asm"
