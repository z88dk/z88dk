;
;   Robotron KC85/2..5 Graphics Functions
;
;	by Stefano Bodrato  - Oct 2016
;
;
;	$Id: w_pixladdr.asm,v 1.1 2016-10-10 07:09:14 stefano Exp $
;


	SECTION   code_clib
        PUBLIC    w_pixeladdress

        INCLUDE "graphics/grafix.inc"
		INCLUDE  "caos.def"

;
;       $Id: w_pixladdr.asm,v 1.1 2016-10-10 07:09:14 stefano Exp $
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
			

			ld		a,l
			
			push	af
			rr h
			rra
			rr h
			rra
			rr h
			rra
			ld	l,a
			ld	h,e

			push	bc
			call    PV1
			defb    FNPADR	; pixel address
			
			ex		de,hl

			pop		bc
			pop		af
			
			and		7
			xor		7

	        ret

