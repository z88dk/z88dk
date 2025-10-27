
; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC bcopy_callee

EXTERN asm_bcopy

bcopy_callee:

   pop hl       ;ret
   pop bc       ;len
   pop de       ;dst
   ex (sp),hl   ;src

   jp asm_bcopy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bcopy_callee
defc _bcopy_callee = bcopy_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___bcopy_callee
defc ___bcopy_callee = bcopy_callee
ENDIF

