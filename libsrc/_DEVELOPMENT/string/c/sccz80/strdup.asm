
; char *strdup(const char * s)

SECTION code_clib
SECTION code_string

PUBLIC strdup

EXTERN asm_strdup

defc strdup = asm_strdup

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strdup

_strdup:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call strdup
   ld de,hl
   ret
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strdup
defc _strdup = strdup
ENDIF

