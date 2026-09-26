
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn

EXTERN asm_strrcspn

strrcspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strrcspn
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrcspn
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrcspn
defc _strrcspn = strrcspn
ENDIF


; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strrcspn, s, set) -> ___strrcspn(set, s): HL=set, DE=s.
; asm_strrcspn enter: HL=str, DE=cset -- swap needed.
IF __CLASSIC
PUBLIC ___strrcspn
___strrcspn:
   ex de,hl                 ; HL=str, DE=cset
   call asm_strrcspn        ; exit HL=position (size_t)
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF

