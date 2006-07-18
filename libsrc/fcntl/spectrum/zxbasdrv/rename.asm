;
; Rename a file by the BASIC driver
; NOTE: We don't set a drive number, here
;
; Stefano - 5/7/2006
;
; specify drive no. in old drive
;
; int rename(char *oldname, char *newname)
;
; $Id: rename.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	rename

	LIB	zx_setstr
	LIB	zx_goto
	LIB	zxgetfname

.rename
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc

	push	de

	call	zxgetfname	; HL points to old name and drive specification
	
	ld	h,0
	ld	l,'O'		; O$
	call	zx_setstr
	pop	de

	ld	bc,7950		; BASIC routine for "rename"
	push	bc
	call	zx_goto
	pop	bc

	ret

