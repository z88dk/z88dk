;
;	ZX IF1 & Microdrive functions
;
;	remove a given file in the given drive
;
;	int if1_remove (int drive, char *filename);
;	
;	$Id: if1_remove_file.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;

		SECTION code_clib
		PUBLIC 	if1_remove_file
		PUBLIC 	_if1_remove_file

		EXTERN	if1_setname
		EXTERN	if1_rommap

		EXTERN	ERASEM


if1_remove_file:
_if1_remove_file:

		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		pop	af
		pop	de	;filename
		pop	bc	;driveno
		push	bc
		push	de
		push	af

		ld	a,c
		ld	($5cd6),a
			
		push	de
		ld	hl,filename	; filename location
		push	hl
		call	if1_setname
		ld	($5cda),hl	; length
		pop	de
		ld	($5cdc),hl	; pointer to filename

		call	if1_rommap
		call	ERASEM
		call	1		; unpage
		ei
		ld	hl,0
		ret

		SECTION bss_clib
; parameters and variables
filename:	defs	10
