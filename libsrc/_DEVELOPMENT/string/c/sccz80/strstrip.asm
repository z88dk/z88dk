
; char *strstrip(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strstrip

EXTERN asm_strstrip

defc strstrip = asm_strstrip
IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strstrip

_strstrip:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strstrip
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strstrip
defc _strstrip = strstrip
ENDIF

