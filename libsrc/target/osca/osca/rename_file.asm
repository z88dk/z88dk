;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'rename' but with a FLOS style error handling
;
;	$Id: rename_file.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

        SECTION code_clib
	PUBLIC  rename_file
	PUBLIC  _rename_file
	EXTERN  rename_file_callee
	EXTERN ASMDISP_RENAME_FILE_CALLEE

rename_file:
_rename_file:
	pop bc
	pop de
	pop hl
	push hl
	push de
	push bc
   jp rename_file_callee + ASMDISP_RENAME_FILE_CALLEE
