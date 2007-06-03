;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Write a data block
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; size_t write(int fd,void *ptr, size_t len)
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: write.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $


	XLIB	write

	LIB	nb_putblock
	
.write
	jp	nb_putblock
