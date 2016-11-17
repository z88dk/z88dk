;
;       Aussie Byte graphics library
;
;	by Stefano Bodrato  - 2016
;
;
;	$Id: w_pixladdr.asm,v 1.1 2016-11-17 09:39:03 stefano Exp $
;

	SECTION   code_clib
        PUBLIC    w_pixeladdress
		
        EXTERN    rdchar
        EXTERN    update
		EXTERN    row

        INCLUDE "graphics/grafix.inc"

;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
; 
; out:    hl    = address of pixel byte
;          b    = bit number of byte where pixel is to be placed
;          a    = "character" currently being edited
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.w_pixeladdress


;****************************************************************
;*	POINT Routine sets point at x,y on			*
;*	HL=X, DE=Y A=0 for off, 1 for on, 2 for complement	*
;****************************************************************

		;LD	(xloc),HL
		;LD	(yloc),DE			; save locations
		push de					; save locations

		;LD	(mode),A			; save operation code

;	Determine the character position along row, remainder
;	is the dot position within row.

		;LD	DE,8			; determine byte along line
		;call	divhd			; divide by 8 bits / byte
		ld	a,h
		and	7
		xor 7
		ld      b,a
		;LD	(xleft),A			; bits left in X (pos in byte)
		srl h
		rr l
		srl h
		rr l
		srl h
		rr l
		;LD	(xleft),HL			; bits left in X (pos in byte)
		;LD	(xloc),BC			; character loc
		;LD	(xloc),HL			; character loc
		;push hl			; character loc

;	Now determine the character row, using remainder as row within
;	the character.

		;LD	HL,(yloc)
		ex (sp),hl
		;LD	DE,16			; now for character
		;call	divhd
		ld	a,h
		and	15
		xor 15
		;LD	(yleft),A			; row number
		ex	af,af				; row number
		srl h
		rr l
		srl h
		rr l
		srl h
		rr l
		srl h
		rr l
		;LD	(yleft),HL			; row number
		;LD	(yloc),BC			; character row number
		;LD	(yloc),HL			; character row number

;	Now we read the byte location, and either :- Or, And or Compl bit

;****************************************************************
;*	XY$to$ABS converts Xloc and Yloc to absoloute character	*
;*	location, and saves this in CHRLOC for updating		*
;****************************************************************
		; take X,Y loc, and make abs character
		; location for reading / writing

		;LD	HL,(yloc)
		ADD	HL,HL			; * 2
		ADD	HL,HL			; * 4
		ADD	HL,HL			; * 8
		ADD	HL,HL			; * 16
		PUSH	HL			; save * 16 value
		ADD	HL,HL			; * 32
		ADD	HL,HL			; * 64
		POP	DE			; restore * 16 value
		ADD	HL,DE			; HL = HL*64 + HL*16
		;LD	DE,(xloc)
		pop de
		ADD	HL,DE
		;LD	(chrloc),HL			; absolute loc saved.
		;LD	HL,(chrloc)			; set by xy abs routine
		LD	(update),HL
		;LD	A,(yleft)
		ex	af,af
		LD	(row),A			; row from 0 to 15
		call	rdchar			; get current value at addr
		;PUSH	AF			; save it
		;LD	A,(xleft)
		ret

