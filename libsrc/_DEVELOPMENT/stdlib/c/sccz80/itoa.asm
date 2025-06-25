
; char *itoa(int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC itoa

EXTERN asm_itoa

itoa:
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld hl,2
   add hl,sp
   ld c,(hl)   ;radix
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)   ;buf
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)   ;num
   inc hl
   ld h,(hl)
   jp asm_itoa
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
   call asm_itoa
   pop ix
   ret
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _itoa
defc _itoa = itoa
ENDIF

