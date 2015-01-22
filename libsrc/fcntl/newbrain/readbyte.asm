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
; $Id: readbyte.asm,v 1.2 2015-01-22 12:09:57 stefano Exp $
;

	PUBLIC	readbyte
	EXTERN	nb_getc

.readbyte
	jp	nb_getc
