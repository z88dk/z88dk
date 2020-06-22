; libsrc/graphics/ts2068hr/w_pixladdr.asm
; posted by rdk77, 11/11/2010

	SECTION		code_graphics
	PUBLIC		w_pixeladdress

	INCLUDE		"graphics/grafix.inc"
;
;       $Id: w_pixladdr.asm,v 1.3 2016-10-14 06:40:26 stefano Exp $
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
;
; CAVEAT
; CAVEAT Input coordinates valid in terms of 1024x256 mode!
; CAVEAT For other modes, scale coordinates to match in advance.
; CAVEAT
;
; out: de = hl    = address of pixel byte
;      a          = bit number of byte where pixel is to be placed
;      fz         = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.w_pixeladdress
	ld	a,l
	rr	h
	rr	l
	rr	h
	rr	l
	srl	e
	rr	l
	
	ld	h,e
	ld	d,e
	ld	e,l

	and	@00000111
	ret

