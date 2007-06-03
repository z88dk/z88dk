;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; fcntl input function
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int __LIB__ __FASTCALL__ readbyte(int handle);
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: readbyte.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;

	XLIB	readbyte
	LIB	nb_getc

.readbyte
	jp	nb_getc
