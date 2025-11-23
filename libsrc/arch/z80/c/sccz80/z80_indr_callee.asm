
; void *z80_indr(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_indr_callee

EXTERN asm_z80_indr

z80_indr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld b,e
   jp asm_z80_indr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_indr_callee
defc _z80_indr_callee = z80_indr_callee
ENDIF

