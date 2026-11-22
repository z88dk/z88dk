; int esxdos_disk_read(uchar device, ulong position, void *dst)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_disk_read

EXTERN l0_esxdos_disk_read_callee

_esxdos_disk_read:

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

   jp l0_esxdos_disk_read_callee
