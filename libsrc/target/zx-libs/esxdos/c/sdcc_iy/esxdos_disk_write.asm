; int esxdos_disk_write(uchar device, ulong position, void *src)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_disk_write

EXTERN l0_esxdos_disk_write_callee

_esxdos_disk_write:

   pop af
	ex af,af'
	dec sp
	pop af
	pop de
	pop bc
	pop hl
	
	push hl
	push bc
	push de
	dec sp
	ex af,af'
	push af
	ex af,af'

   jp l0_esxdos_disk_write_callee
