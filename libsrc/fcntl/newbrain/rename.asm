;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Rename a file
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int rename(char *oldname, char *newname)
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: rename.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $

	XLIB	rename

.rename
	ld	hl,-1
	ret

