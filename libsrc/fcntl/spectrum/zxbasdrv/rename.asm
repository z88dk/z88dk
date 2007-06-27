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
; $Id: rename.asm,v 1.2 2007-06-27 16:51:59 stefano Exp $

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

	ld	hl,7950		; BASIC routine for "rename"
	call	zx_goto

	ret

