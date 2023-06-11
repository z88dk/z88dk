
; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlwr

EXTERN asm_strlwr

defc strlwr = asm_strlwr

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strlwr

_strlwr:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strlwr
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strlwr
defc _strlwr = strlwr
ENDIF

