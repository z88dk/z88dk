
; void dzx2_nano(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC dzx2_nano

EXTERN asm_dzx2_nano

dzx2_nano:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx2_nano

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx2_nano
defc _dzx2_nano = dzx2_nano
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx2_nano
defc ___dzx2_nano = dzx2_nano
ENDIF

