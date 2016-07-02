; libsrc/graphics/ts2068hr/w_pixladdr.asm
; posted by rdk77, 11/11/2010

        PUBLIC    w_pixeladdress

        INCLUDE "graphics/grafix.inc"
;
;       $Id: w_pixladdr.asm,v 1.2 2016-07-02 09:01:36 dom Exp $
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
; 
; out: de       = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.w_pixeladdress

	LD A,L
	
	RR H
	RR L
	RR H
	RR L
	SRL E
	RR L
	LD H,E
	LD D,E
	LD E,L

	AND @00000111
	
	RET

