
; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strtok

EXTERN asm_strtok

strtok:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strtok
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strtok
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtok
defc _strtok = strtok
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strtok, s, delim) -> ___strtok(delim, s): HL=delim, DE=s.
; asm_strtok enter: DE=delimiters, HL=string -> swap needed.
IF __CLASSIC
PUBLIC ___strtok
___strtok:
   ex de,hl                 ; HL = s, DE = delim
   call asm_strtok          ; enter DE=delim, HL=s; exit carry+HL=token or HL=0
   ex de,hl                 ; DE = result ptr (C return value)
   ret
ENDIF

