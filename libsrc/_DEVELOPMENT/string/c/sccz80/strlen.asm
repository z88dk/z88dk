
; size_t strlen(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlen

EXTERN asm_strlen

defc strlen = asm_strlen

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strlen

_strlen:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strlen
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strlen
defc _strlen = strlen
ENDIF

