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
; $Id: writebyte.asm,v 1.2 2015-01-22 12:09:57 stefano Exp $



	PUBLIC	writebyte
	EXTERN	nb_putc
	
.writebyte
	jp	nb_putc
