
; char *strrev(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrev

EXTERN asm_strrev

defc strrev = asm_strrev

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strrev

_strrev:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strrev
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strrev
defc _strrev = strrev
ENDIF

