;
; long fdtell(int fd, long posn, int whence)
;
; Set position in file
;
; Not written as yet!
;
; $Id: lseek.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $

		PUBLIC	lseek	

.lseek
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
