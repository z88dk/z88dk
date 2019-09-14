
; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset_callee

EXTERN asm_memset

memset_callee:
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
   
   jp asm_memset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memset_callee
defc _memset_callee = memset_callee
ENDIF

