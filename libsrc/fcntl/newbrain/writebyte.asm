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
; $Id: writebyte.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $



	XLIB	writebyte
	LIB	nb_putc
	
.writebyte
	jp	nb_putc
