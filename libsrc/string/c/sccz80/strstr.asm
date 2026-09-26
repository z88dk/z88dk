
; char *strstr(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strstr

EXTERN asm_strstr

strstr:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strstr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strstr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strstr
defc _strstr = strstr
ENDIF


; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strstr, s, subs) -> ___strstr(subs, s): HL=subs, DE=s.
; asm_strstr enter: DE=s (haystack), HL=subs (needle) -- already correct.
IF __CLASSIC
PUBLIC ___strstr
___strstr:
   call asm_strstr          ; enter HL=subs, DE=s; exit HL=ptr or 0
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF

