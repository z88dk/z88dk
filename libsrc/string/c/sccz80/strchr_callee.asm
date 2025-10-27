
; char *strchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchr_callee

EXTERN asm_strchr

strchr_callee:
IF __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   push de
   call asm_strchr
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop bc
   ex (sp),hl
   jp asm_strchr
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchr_callee
defc _strchr_callee = strchr_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strchr_callee
defc ___strchr_callee = strchr_callee
ENDIF

