; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC strrstr

EXTERN asm_strrstr

strrstr:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strrstr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrstr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrstr
defc _strrstr = strrstr
ENDIF

; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strrstr, s, w) -> ___strrstr(w, s): HL=w, DE=s.
; asm_strrstr enter: HL=s, DE=w -- swap needed.
IF __CLASSIC
PUBLIC ___strrstr
___strrstr:
   ex de,hl                 ; HL=s, DE=w
   call asm_strrstr         ; exit HL=ptr in s (or 0 if not found)
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF

