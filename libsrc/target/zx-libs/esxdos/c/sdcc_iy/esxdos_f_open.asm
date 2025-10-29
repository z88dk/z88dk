; uchar esxdos_f_open(char *filename, uchar mode)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_open

EXTERN l0_esxdos_f_open_callee

_esxdos_f_open:

   pop af
	pop hl
	dec sp
	pop bc
	
	dec sp
	push hl
	push af

   jp l0_esxdos_f_open_callee
