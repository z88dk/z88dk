;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'rename' but with a FLOS style error handling
;
;	$Id: rename_file_callee.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  rename_file_callee
	EXTERN   flos_err
	PUBLIC  ASMDISP_RENAME_FILE_CALLEE

rename_file_callee:
	pop bc
	pop de
	pop hl
	push bc

asmentry:
	call	kjt_rename_file
	jp   flos_err

DEFC ASMDISP_RENAME_FILE_CALLEE = # asmentry - rename_file_callee
