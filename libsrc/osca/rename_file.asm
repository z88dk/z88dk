;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'rename' but with a FLOS style error handling
;
;	$Id: rename_file.asm,v 1.2 2012-03-08 07:16:46 stefano Exp $
;


	XLIB  rename_file
	LIB  rename_file_callee
	XREF ASMDISP_RENAME_FILE_CALLEE

rename_file:
	pop bc
	pop de
	pop hl
	push hl
	push de
	push bc
   jp rename_file_callee + ASMDISP_RENAME_FILE_CALLEE
