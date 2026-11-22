;
;	Sharp X1: write sectors of the disk
;
;	int x1_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;
;
;	Writes count sectors of 256 bytes from buf, starting at the sector (the first on a track is 1) of the track (the sides alternate:
;	track = 2 * cylinder + side), and carries on to the next track after sector 16.  Returns 0, or 1 if the controller reported an
;	error.  Interrupts are turned off for the call and restored.
;

	MODULE	x1_disk_write

	SECTION	code_clib
	PUBLIC	x1_disk_write
	PUBLIC	_x1_disk_write
	PUBLIC	x1_disk_write_callee
	PUBLIC	_x1_disk_write_callee

	EXTERN	asm_x1_disk_call
	EXTERN	asm_x1_disk_call_callee

x1_disk_write:
_x1_disk_write:
	ld	a,1
	jp	asm_x1_disk_call

x1_disk_write_callee:
_x1_disk_write_callee:
	ld	a,1
	jp	asm_x1_disk_call_callee
