;
; long fdtell(int fd, long posn, int whence)
;
; Set position in file
;
; Not written as yet!
;
; $Id: lseek.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $

		SECTION	code_clib
		PUBLIC	lseek	
      PUBLIC   _lseek

.lseek
._lseek
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
