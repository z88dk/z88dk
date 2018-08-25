; uchar esxdos_f_open_p3(char *filename, uchar mode, void *header)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_open_p3

EXTERN asm_esxdos_f_open

_esxdos_f_open_p3:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld a,__ESXDOS_DRIVE_CURRENT

   ld b,c
   jp asm_esxdos_f_open

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __esxdos_f_open_p3
defc __esxdos_f_open_p3 = _esxdos_f_open_p3
ENDIF

