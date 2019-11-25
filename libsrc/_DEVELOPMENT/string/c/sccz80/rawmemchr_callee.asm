
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

PUBLIC rawmemchr_callee, l0_rawmemchr_callee

EXTERN asm_rawmemchr

rawmemchr_callee:

IF __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   push de
ELSE
   pop hl
   pop bc
   ex (sp),hl
ENDIF

l0_rawmemchr_callee:

   ld a,c
   
   jp asm_rawmemchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _rawmemchr_callee
defc _rawmemchr_callee = rawmemchr_callee
ENDIF

