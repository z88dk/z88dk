;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Write a byte by the BASIC driver
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int writebyte(int handle, int byte)
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: writebyte.asm,v 1.3 2016-06-19 20:26:58 dom Exp $


        SECTION code_clib
	PUBLIC	writebyte
	PUBLIC	_writebyte
	EXTERN	nb_putc
	
.writebyte
._writebyte
	jp	nb_putc
