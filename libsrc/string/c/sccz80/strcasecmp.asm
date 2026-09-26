
; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcasecmp

EXTERN asm_strcasecmp

strcasecmp:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strcasecmp
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcasecmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcasecmp
defc _strcasecmp = strcasecmp
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strcasecmp, s1, s2) -> ___strcasecmp(s2, s1): HL=s2, DE=s1.
; asm_strcasecmp enter: HL=s2, DE=s1 -- already correct, no swap needed.
IF __CLASSIC
PUBLIC ___strcasecmp
___strcasecmp:
   call asm_strcasecmp      ; enter HL=s2, DE=s1; exit A=diff
   ex de,hl                 ; DE = result (C return value, sign-extends in A)
   ret
ENDIF

