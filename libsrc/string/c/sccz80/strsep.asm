
; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

PUBLIC strsep

EXTERN asm_strsep

strsep:

   pop hl
   pop de
   pop bc

   push bc
   push de
   push hl
IF __CLASSIC && __CPU_GBZ80__
   call asm_strsep
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strsep
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strsep
defc _strsep = strsep
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strsep, stringp, delim) -> ___strsep(delim, stringp): HL=delim, DE=stringp.
; asm_strsep enter: DE=delim, BC=stringp (char**).
IF __CLASSIC
PUBLIC ___strsep
___strsep:
   ld c,e
   ld b,d                   ; BC = stringp (char **)
   ex de,hl                 ; DE = delim
   call asm_strsep          ; enter DE=delim, BC=stringp; exit HL=token or 0
   ex de,hl                 ; DE = result ptr (C return value)
   ret
ENDIF

