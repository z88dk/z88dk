
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC strnlen

EXTERN asm_strnlen

strnlen:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
IF __CLASSIC && __CPU_GBZ80__
   call asm_strnlen
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strnlen
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnlen
defc _strnlen = strnlen
ENDIF


; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strnlen, s, max_len) -> ___strnlen(max_len, s): HL=max, DE=s.
; asm_strnlen enter: HL=s, BC=maxlen.
IF __CLASSIC
PUBLIC ___strnlen
___strnlen:
   ld c,l
   ld b,h                   ; BC = maxlen
   ex de,hl                 ; HL = s
   call asm_strnlen         ; enter HL=s, BC=maxlen; exit HL=length
   ex de,hl                 ; DE = length (C return value)
   ret
ENDIF

