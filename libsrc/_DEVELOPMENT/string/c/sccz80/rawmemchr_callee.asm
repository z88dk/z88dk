
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

PUBLIC rawmemchr_callee, l0_rawmemchr_callee

EXTERN asm_rawmemchr

rawmemchr_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_rawmemchr_callee:

   ld a,c
   
   jp asm_rawmemchr
