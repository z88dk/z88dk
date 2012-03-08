;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'rename' but with a FLOS style error handling
;
;	$Id: rename_file_callee.asm,v 1.1 2012-03-08 07:16:46 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  rename_file_callee
	LIB   flos_err
	XDEF  ASMDISP_RENAME_FILE_CALLEE

rename_file_callee:
	pop bc
	pop de
	pop hl
	push bc

asmentry:
	call	kjt_rename_file
	jp   flos_err

DEFC ASMDISP_RENAME_FILE_CALLEE = asmentry - rename_file_callee
