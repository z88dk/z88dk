; 03.2022 stefano

; void mz800_vsync()

SECTION code_clib
PUBLIC mz800_vsync
PUBLIC _mz800_vsync


mz800_vsync:
_mz800_vsync:
	IN     A,(0xCE)
	AND    $40          ;vblank check
	JR     NZ,mz800_vsync
	RET
