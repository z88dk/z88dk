
; int iscntrl(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC iscntrl
PUBLIC iscntrl_fastcall

EXTERN asm_iscntrl, error_znc


iscntrl:
IF __CPU_GBZ80__
   ld  hl,sp+2
   ld  a,(hl+)
   ld  h,(hl)
   ld  l,a
ELIF __CPU_RABBIT__ | __CPU_KC160__
   ld hl,(sp+2)
ELSE
   pop de
   pop hl
   push hl
   push de
ENDIF

iscntrl_fastcall:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_iscntrl
   
   ld l,h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nc
   
   inc l
IF __CPU_GBZ80__
   inc e
ENDIF
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _iscntrl
defc _iscntrl = iscntrl
PUBLIC _iscntrl_fastcall
defc _iscntrl_fastcall = iscntrl_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___iscntrl
defc ___iscntrl = iscntrl
ENDIF

