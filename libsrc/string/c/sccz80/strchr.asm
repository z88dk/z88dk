
; char *strchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchr

EXTERN asm_strchr

strchr:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de

IF __CLASSIC && __CPU_GBZ80__
   call asm_strchr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strchr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchr
defc _strchr = strchr
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; __strchr(int c, const char *s): HL=c, DE=s; return ptr (or 0) in DE.
IF __CLASSIC
PUBLIC ___strchr
___strchr:
   ld c,l                   ; C = char c (low byte)
   ex de,hl                 ; HL = s
   call asm_strchr          ; enter C=c, HL=s; exit HL=ptr to c or 0
   ex de,hl                 ; DE = ptr (C return value)
   ret
ENDIF

