
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memswap_callee

EXTERN asm_memswap

memswap_callee:

IF __CPU_GBZ80__
   pop af
   pop bc
   pop de
   pop hl
   push af
ELSE
   pop hl
   pop bc
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_memswap

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memswap_callee
defc _memswap_callee = memswap_callee
ENDIF

