;
;	Sony SMC-777: write sectors of the disk
;
;	int smc777_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;
;
;	Writes count sectors of 256 bytes from buf, starting at the sector (the first on a track is 1) of the
;	track (the disk is single sided: the track is the cylinder), and carries on to the next track after sector 16.  Returns 0, or 1 if
;	the controller reported an error.  Interrupts are turned off for the call and restored.
;

	MODULE	smc777_disk_write

	SECTION	code_clib
	PUBLIC	smc777_disk_write
	PUBLIC	_smc777_disk_write
	PUBLIC	smc777_disk_write_callee
	PUBLIC	_smc777_disk_write_callee

	EXTERN	asm_smc777_disk_call
	EXTERN	asm_smc777_disk_call_callee

smc777_disk_write:
_smc777_disk_write:
	ld	a,1
	jp	asm_smc777_disk_call

smc777_disk_write_callee:
_smc777_disk_write_callee:
	ld	a,1
	jp	asm_smc777_disk_call_callee
