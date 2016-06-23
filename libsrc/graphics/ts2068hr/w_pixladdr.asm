; libsrc/graphics/ts2068hr/w_pixladdr.asm
; posted by rdk77, 11/11/2010

	SECTION   code_clib
        PUBLIC    w_pixeladdress

        INCLUDE "graphics/grafix.inc"
;
;       $Id: w_pixladdr.asm,v 1.5 2016-06-23 19:41:02 dom Exp $
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
	        LD	A,E
	        LD      B,A
	        AND     A
	        RRA
	        SCF			; Set Carry Flag
	        RRA
	        AND     A
	        RRA
	        XOR     B
	        AND     @11111000
	        XOR     B
	        LD      D,A
	        LD      A,l

	        bit		3,a
	        jp		z,isfirst
	        set		5,d
.isfirst
	        rr h
	        rra

	        RLCA
	        RLCA
	        RLCA

	        XOR     B
	        AND     @11000111
	        XOR     B
	        RLCA
	        RLCA
	        LD      E,A
	        LD      A,L
	        AND     @00000111
	        XOR	@00000111
	        ret

