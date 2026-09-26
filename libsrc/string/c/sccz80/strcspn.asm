
; size_t strcspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcspn

EXTERN asm_strcspn

strcspn:

   pop bc
   pop de
   pop hl

   push hl
   push de
   push bc

IF __CLASSIC && __CPU_GBZ80__
   call asm_strcspn
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcspn
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcspn
defc _strcspn = strcspn
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strcspn, s, nspn) -> ___strcspn(nspn, s): HL=nspn, DE=s.
; asm_strcspn enter: DE=s2(reject chars), HL=s1(string) -> swap needed.
IF __CLASSIC
PUBLIC ___strcspn
___strcspn:
   ex de,hl                 ; HL = s, DE = nspn
   call asm_strcspn         ; enter DE=nspn, HL=s; exit HL=length
   ex de,hl                 ; DE = length (C return value)
   ret
ENDIF

