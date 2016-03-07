;
; long fdtell(int fd, long posn, int whence)
;
; Set position in file
;
; Not written as yet!
;
; $Id: lseek.asm,v 1.3 2016-03-07 13:44:48 dom Exp $

		SECTION	code_clib
		PUBLIC	lseek	

.lseek
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
