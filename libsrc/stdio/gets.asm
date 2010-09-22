;
;	New stdio functions for Small C+
;
;	gets(char *s) - get string from console
;
;
;	$Id: gets.asm,v 1.1 2010-09-22 09:28:25 stefano Exp $
;


		XLIB  gets
		LIB   fgetc_cons
		LIB   fputc_cons


; Enter in with hl holding the address of string to print

.gets
	; we don't __FASTCALL__, z88 version of gets needs parameters
	pop	bc
	pop hl
	push hl
	push bc
	ld	d,h	; keep the start of buffer
	ld	e,l
	call	cursor

.getloop
	push	de
	push	hl	; preserve buffer location
	call	fgetc_cons
	pop		hl
	pop		de
	cp		8
	jr		z,bs
	cp		12
	jr		nz,nobs
.bs
	ld		a,h	; are we at beginning of buffer ?
	sub		d
	jr		nz,dobs
	ld		a,l
	sub		e
	jr		z,getloop
.dobs
	call	wipecursor
	call	chr8
	ld		a,' '
	call	conout
	call	chr8
	call	cursor
	dec		hl
	jr		getloop
.nobs
	cp		13
	jr		z,getend
	ld		(hl),a
	inc		hl
	call	conout
	call	cursor
	jr		getloop	

.getend
	call	wipecursor
	xor	a
	ld	(hl),a
	ld	a,13	; end with CR

.conout
	push	hl
	push	de
	ld		c,a
	push	bc
	call	fputc_cons
	pop		bc
	pop		de
	pop		hl
	ret

.wipecursor
	ld		a,' '
	jr		cursor+2
.cursor
	ld		a,'_'
	call	conout
.chr8
	ld		a,8
	call	conout
	ret
