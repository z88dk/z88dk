;
;	ZX IF1 & Microdrive functions
;
;	Stefano Bodrato - Oct. 2004
;
;
;	if1_rommap:
;	 - detect the shadow rom version
;	 - init the jump table
;	
;	$Id: if1_rommap.asm,v 1.1 2004-10-08 12:33:24 stefano Exp $
;


		XLIB 	if1_rommap

		XDEF	MAKE_M
		XDEF	CLOSE_M
		XDEF	FETCH_H
		XDEF	MOTOR
		XDEF	RD_BUFF

		XDEF	mdvbuffer

mdvbuffer:	defw	0

if1_rommap:	; start creating an 'M' channel

		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		ld	hl,paged
		ld	(5CEDh),hl 	; Location for hook 32h to jump to

		rst	8		; Call 'paged' with shadow paged in
		defb	32h		; (in other words: page in the shadow ROM)

paged:
		set 	0,(iy+7Ch)	; FLAGS3: reset the "executing extended command" flag

	; update jump table
		ld	bc,15		; 5 jumps * 3 bytes
		;ld	bc,24		; 8 jumps * 3 bytes
		ld	de,jptab	; JP table dest addr
		ld	hl,rom1tab	; JP table for ROM 1
		ld	a,(10A5h)
		or	a
		jr	z,rom1
		ld	hl,rom2tab	; JP table for ROM 2
rom1:
		ldir
		
		pop	bc		; throw away some garbage
		pop	bc		; ... from the stack
		
		ret
		;jp	MAKE_M


; Jump table

jptab:

MAKE_M: 	JP 0FE8h	; set temporary "M" channel
CLOSE_M:	JP 12A9h	; close file (pointed by IX)
FETCH_H: 	JP 12C4h	; fetch header
MOTOR:		JP 17F7h	; select drive motor
RD_BUFF:	JP 18A9h	; get buffer

;LDBYTS:		JP 15ACh	;
;SVBYTS:		JP 14EEh	;
;ERASEM:		JP 1D6Eh	;

rom1tab:
		JP 0FE8h	; JP table image (rom1)
		JP 12A9h
		JP 12C4h
		JP 17F7h
		JP 18A9h

		;JP 15ACh ;LDBYTS
		;JP 14EEh ;SVBYTS
		;JP 1D6Eh ;ERASEM

rom2tab:
		JP 10A5h	; JP table image (rom2 and rom3)
		JP 138Eh
		JP 13A9h
		JP 1532h
		JP 15EBh

		;JP 199Dh ;LDBYTS
		;JP 18DFh ;SVBYTS
		;JP 1D79h ;ERASEM
