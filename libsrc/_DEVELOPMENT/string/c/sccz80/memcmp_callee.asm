
; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memcmp_callee

EXTERN asm_memcmp

memcmp_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_memcmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memcmp_callee
defc _memcmp_callee = memcmp_callee
ENDIF

