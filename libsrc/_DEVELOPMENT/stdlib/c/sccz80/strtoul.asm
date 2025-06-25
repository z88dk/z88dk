
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

IF !__CPU_INTEL__ && !__CPU_GBZ80__


SECTION code_clib
SECTION code_stdlib

PUBLIC strtoul

EXTERN asm_strtoul

strtoul:
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   jp  asm_strtoul
ELSE
   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   push ix
   call asm_strtoul
   pop ix
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoul
defc _strtoul = strtoul
ENDIF

ENDIF

