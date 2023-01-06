
; void *z80_otdr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otdr_callee

EXTERN asm_z80_otdr

z80_otdr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   ld b,e
   jp asm_z80_otdr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_otdr_callee
defc _z80_otdr_callee = z80_otdr_callee
ENDIF

