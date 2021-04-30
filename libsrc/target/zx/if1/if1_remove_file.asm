;
;	ZX IF1 & Microdrive functions
;
;	remove a given file in the given drive
;
;	int if1_remove (int drive, char *filename);
;	
;	$Id: if1_remove_file.asm $
;

		SECTION code_clib
		PUBLIC 	if1_remove_file
		PUBLIC 	_if1_remove_file

		EXTERN	if1_setname
		EXTERN	if1_rommap

		EXTERN	ERASEM


if1_remove_file:
_if1_remove_file:

		;; TODO:  check for possible IX corruption here
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		pop	af
		pop	de	;filename
		pop	bc	;driveno
		push	bc
		push	de
		push	af

		ld      a,c
		ld      hl,-1
		and     a               ; drive no. = 0 ?
		ret     z               ; yes, return -1
		cp      9               ; drive no. >8 ?
		ret     nc              ; yes, return -1
		ld	($5cd6),a
			
		push	de
		ld	hl,filename	; filename location
		push	hl
		call	if1_setname
		ld	($5cda),hl	; length
		pop	hl
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
