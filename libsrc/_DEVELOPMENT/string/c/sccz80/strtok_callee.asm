
; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strtok_callee

EXTERN asm_strtok

strtok_callee:
IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
   call asm_strtok
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop de
   ex (sp),hl
   jp asm_strtok
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtok_callee
defc _strtok_callee = strtok_callee
ENDIF

