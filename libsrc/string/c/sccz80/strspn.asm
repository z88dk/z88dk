
; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strspn

EXTERN asm_strspn

strspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strspn
   ld d,h
   ld e,l
ELSE
   jp asm_strspn
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strspn
defc _strspn = strspn
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strspn, s, pfx) -> ___strspn(pfx, s): HL=pfx, DE=s.
; asm_strspn enter: DE=s2(prefix chars), HL=s1(string) -> swap needed.
IF __CLASSIC
PUBLIC ___strspn
___strspn:
   ex de,hl                 ; HL = s, DE = pfx
   call asm_strspn          ; enter DE=pfx, HL=s; exit HL=length
   ex de,hl                 ; DE = length (C return value)
   ret
ENDIF

