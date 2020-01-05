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
; $Id: write.asm,v 1.3 2016-06-19 20:26:58 dom Exp $


        SECTION code_clib
	PUBLIC	write
	PUBLIC	_write

	EXTERN	nb_putblock
	
.write
._write
	jp	nb_putblock
