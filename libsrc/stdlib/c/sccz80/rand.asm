
; int rand(void)

SECTION code_clib
SECTION code_stdlib

PUBLIC rand

EXTERN asm_rand

IF !__CPU_GBZ80__
defc rand = asm_rand
ELSE
rand:
  call asm_rand
  ld   d,h
  ld   e,l
  ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _rand
defc _rand = rand
ENDIF
