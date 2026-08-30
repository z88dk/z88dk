; All ten 8085 extended ops (Zilog). Forward jp cc is not-taken (7).
; rstv is not-taken (6). Total 97:
;   sub hl,bc 10, sra hl 7, rl de 10, ld de,sp+* 10, ld de,hl+* 10,
;   ld hl,(de) 10, ld (de),hl 10, jp nk 7, jp k 7, rstv 6, ret 10.
	MODULE	t_8085_ext

	SECTION	code_compiler

._foo
	sub	hl,bc
L_ext_1:
	sra	hl
	rl	de
	ld	de,sp+4
	ld	de,hl+2
	ld	hl,(de)
	ld	(de),hl
	jp	nk,L_nk
L_nk:
	jp	k,L_k
L_k:
	rstv
	ret

	SECTION	code_compiler
	GLOBAL	_foo
