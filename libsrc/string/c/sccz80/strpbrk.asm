
; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strpbrk

EXTERN asm_strpbrk

strpbrk:

   pop de
   pop de
   pop hl
   
   push hl
   push de
   push de
IF __CLASSIC && __CPU_GBZ80__
   call asm_strpbrk
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strpbrk
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strpbrk
defc _strpbrk = strpbrk
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strpbrk
defc ___strpbrk = strpbrk
ENDIF


; strpkbrk(s, set) is a z88dk-extension alias for strpbrk(s1, s2).
; __ZPROTO2 generates ___strpkbrk(set, s) -- reversed register ABI:
;   HL = set, DE = s
; asm_strpbrk wants: HL = s, DE = set
IF __CLASSIC
PUBLIC _strpkbrk               ; sccz80/sdcc: same stack layout as strpbrk
defc _strpkbrk = strpbrk

PUBLIC ___strpkbrk             ; llvmz80 clang: register-ABI bridge
___strpkbrk:
   ex de,hl                   ; HL = s, DE = set
   call asm_strpbrk
   ex de,hl                   ; DE = result (clang reads return in DE)
   ret
ENDIF

