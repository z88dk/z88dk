
; char *strerror(int errnum)

SECTION code_clib
SECTION code_string

PUBLIC strerror

EXTERN asm_strerror

defc strerror = asm_strerror

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strerror

_strerror:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strerror
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strerror
defc _strerror = strerror
ENDIF

