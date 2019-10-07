
; char *strrstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrstrip

EXTERN asm_strrstrip

defc strrstrip = asm_strrstrip

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strrstrip

_strrstrip:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strrstrip
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strrstrip
defc _strrstrip = strrstrip
ENDIF

