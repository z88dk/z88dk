
; char *strstrip(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strstrip

EXTERN asm_strstrip

defc strstrip = asm_strstrip
IF __CPU_INTEL__ || __CPU_GBZ80__
PUBLIC _strstrip

_strstrip:
   ld hl,sp+2
IF __CPU_GBZ80__
   ld a,(hl+)
ELSE
   ld a,(hl)
   inc hl
ENDIF
   ld h,(hl)
   ld l,a

IF __CLASSIC && __CPU_GBZ80__
   call asm_strstrip
   ld   de,hl
   ret
ELSE 
   jp asm_strstrip
ENDIF

ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strstrip
defc _strstrip = strstrip
ENDIF

