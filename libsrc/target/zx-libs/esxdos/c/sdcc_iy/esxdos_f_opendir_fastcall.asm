; uchar esxdos_f_opendir(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_opendir_fastcall

EXTERN asm_esxdos_f_opendir

_esxdos_f_opendir_fastcall:

   ld a,__ESXDOS_DRIVE_CURRENT
	ld b,0
	
	push iy
	
	call asm_esxdos_f_opendir
	
	pop iy
	ret
