; uchar esxdos_f_open(char *filename, uchar mode)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_open

EXTERN asm_esxdos_f_open

esxdos_f_open:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   ld a,__ESXDOS_DRIVE_CURRENT
   ld de,0
	
   ld b,c
   jp asm_esxdos_f_open

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_open
defc _esxdos_f_open = esxdos_f_open
ENDIF

