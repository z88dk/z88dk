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
; $Id: readbyte.asm,v 1.3 2016-06-19 20:26:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	readbyte
	PUBLIC	_readbyte
	EXTERN	nb_getc

.readbyte
._readbyte
	jp	nb_getc
