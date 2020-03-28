;  int find_file (char *filename, struct flos_file file);
;  CALLER linkage for function pointers
;
;	$Id: find_file.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

SECTION code_clib
PUBLIC find_file
PUBLIC _find_file

EXTERN find_file_callee
EXTERN ASMDISP_FIND_FILE_CALLEE

find_file:
_find_file:
	pop		bc
	pop		de	; ptr to file struct
	pop		hl	; ptr to file name
	push	hl
	push	de
	push	bc

   jp find_file_callee + ASMDISP_FIND_FILE_CALLEE
