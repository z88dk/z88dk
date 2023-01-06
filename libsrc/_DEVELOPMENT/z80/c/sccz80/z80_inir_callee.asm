
; void *z80_inir(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_inir_callee

EXTERN asm_z80_inir

z80_inir_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   ld b,e
   jp asm_z80_inir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_inir_callee
defc _z80_inir_callee = z80_inir_callee
ENDIF

