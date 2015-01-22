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
; $Id: write.asm,v 1.2 2015-01-22 12:09:57 stefano Exp $


	PUBLIC	write

	EXTERN	nb_putblock
	
.write
	jp	nb_putblock
