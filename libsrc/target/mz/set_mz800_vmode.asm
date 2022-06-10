; 03.2022 stefano

; int set_mz800_vmode()

SECTION code_clib
PUBLIC set_mz800_vmode
PUBLIC _set_mz800_vmode


set_mz800_vmode:
_set_mz800_vmode:
	LD     A,L
	OUT    (0xCE),A
	RET
