; 03.2022 stefano

; int get_mz800_vmode()

SECTION code_clib
PUBLIC get_mz800_vmode
PUBLIC _get_mz800_vmode


get_mz800_vmode:
_get_mz800_vmode:
	IN     A,(0xCE)
	AND    $0F
	LD     L,A
	LD     H,0
	RET
