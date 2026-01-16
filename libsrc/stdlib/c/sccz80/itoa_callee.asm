
; char *itoa(int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC itoa_callee

EXTERN asm_itoa

itoa_callee:
IF __CPU_GBZ80__
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
   pop hl
   pop bc
   pop de
   ex (sp),hl
 IF !__CPU_INTEL__
   push ix 
   call asm_itoa
   pop ix
   ret
 ELSE
   jp asm_itoa
 ENDIF
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _itoa_callee
defc _itoa_callee = itoa_callee
ENDIF

