;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	int find_file (char *filename, struct flos_file file);
;
;	Find a file and load its properties in a structure
;
;	$Id: find_file_callee.asm,v 1.5 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  find_file_callee
	PUBLIC  _find_file_callee
	PUBLIC  ASMDISP_FIND_FILE_CALLEE

.find_file_callee
._find_file_callee
	pop		bc
	pop		de	; ptr to file struct
	pop		hl	; ptr to file name
	push	bc

.asmentry
	push	ix		; save callers
	push	hl
	push	iy

	push	hl
	ld		bc,13
	ldir		; copy file name in struct
	pop		hl

	push	de
	call	kjt_find_file
		;IX:IY = Length of file
		;DE = First cluster that the file uses
	pop		hl
 	jr		nz,err

	push	iy		; get file size
	pop		bc
	ld		(hl),c
	inc		hl
	ld		(hl),b
	inc		hl
	push	ix
	pop		bc
	ld		(hl),c
	inc		hl
	ld		(hl),b
	inc		hl

	ld		(hl),e	; set cluster number
	inc		hl
	ld		(hl),d
	inc		hl

	xor		a		; set the zero flag for proper return code
	ld		(hl),a	; initial sector

	;inc		hl
	;ld		(hl),a	; initial file position
	;inc		hl
	;ld		(hl),a
	;inc		hl
	;ld		(hl),a
	;inc		hl
	;ld		(hl),a

	;xor		a
err:
	pop		iy
	pop		hl
	pop		ix	;restore callers
	ret	z

	ld	hl,0	; flag was not zero
	ret

DEFC ASMDISP_FIND_FILE_CALLEE = # asmentry - find_file_callee
