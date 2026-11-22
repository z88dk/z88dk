
; void *zx_saddrpright(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpright

EXTERN asm_zx_saddrpright

zx_saddrpright:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_zx_saddrpright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddrpright
defc _zx_saddrpright = zx_saddrpright
ENDIF

