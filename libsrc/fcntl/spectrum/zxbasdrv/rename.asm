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
; $Id: rename.asm,v 1.5 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	rename
	PUBLIC	_rename

	EXTERN	zx_setstr
	EXTERN	zx_goto
	EXTERN	zxgetfname

.rename
._rename
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
	jp	zx_goto

