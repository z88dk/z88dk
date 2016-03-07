;	A couple of routines for +3 library


; 	Routine to call +3DOS Routines. Located in startup
;	code to ensure we don't get paged out
;	(These routines have to be below 49152)
;
;	djm 17/3/2000 (after the manual!)
;
;	$Id: dodos.asm,v 1.3 2016-03-07 13:44:48 dom Exp $

	SECTION	code_clib
	PUBLIC	dodos

.dodos
	push	af
	push	bc
	ld	a,7
	ld	bc,32765
	di
	ld	(23388),a
	out	(c),a
	ei
	pop	bc
	pop	af
	push	ix		;save ix
	call	cjumpiy
	pop	ix
	push	af
	push	bc
	ld	a,16
	ld	bc,32765
	di
	ld	(23388),a
	out	(c),a
	ei
	pop	bc
	pop	af
	ret
.cjumpiy
	jp	(iy)

;
;	Short routine to set up a +3 DOS header so files
;	Can be accessed from BASIC, we set to type code
;	load address 0 and length supplied
;
;	Entry:	b = file handle
;	       hl = file length

.setheader
	ld	iy,setheader_r
	call	dodos
	ret

.setheader_r
	push	hl
	call	271	;DOS_RED_HEAD
	pop	hl
	ld	(ix+0),3	;COODE
	ld	(ix+1),l	;Length
	ld	(ix+2),h
	ld	(ix+3),0	;Load address
	ld	(ix+4),0
	ret
