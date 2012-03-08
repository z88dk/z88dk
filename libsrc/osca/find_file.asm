;  int find_file (char *filename, struct flos_file file);
;  CALLER linkage for function pointers
;
;	$Id: find_file.asm,v 1.2 2012-03-08 07:16:46 stefano Exp $
;

XLIB find_file

LIB find_file_callee
XREF ASMDISP_FIND_FILE_CALLEE

find_file:
	pop		bc
	pop		de	; ptr to file struct
	pop		hl	; ptr to file name
	push	hl
	push	de
	push	bc

   jp find_file_callee + ASMDISP_FIND_FILE_CALLEE
