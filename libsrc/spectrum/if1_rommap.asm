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
;	$Id: if1_rommap.asm,v 1.2 2005-02-18 08:30:13 stefano Exp $
;


		XLIB 	if1_rommap

		XDEF	MAKE_M
		XDEF	CLOSE_M
		XDEF	FETCH_H
		XDEF	MOTOR
		XDEF	RD_BUFF
		XDEF	ERASEM

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
		ld	a,(10A5h)
		or	a
		jr	z,rom1

		ld	bc,18		; 6 jumps * 3 bytes
		;ld	bc,24		; 8 jumps * 3 bytes
		ld	de,jptab	; JP table dest addr
		ld	hl,rom2tab	; JP table for ROM 2
		ldir
rom1:
		
		pop	bc		; throw away some garbage
		pop	bc		; ... from the stack
		
		ret
		;jp	MAKE_M


; Jump table (ROM1 is the default)

jptab:

MAKE_M: 	JP 0FE8h	; set temporary "M" channel
CLOSE_M:	JP 12A9h	; close file (pointed by IX)
FETCH_H: 	JP 12C4h	; fetch header
MOTOR:		JP 17F7h	; select drive motor
RD_BUFF:	JP 18A9h	; get buffer
ERASEM:		JP 1D6Eh	; delete a file from cartridge

;LDBYTS:		JP 15ACh	;
;SVBYTS:		JP 14EEh	;


rom2tab:
		JP 10A5h	; JP table image (rom2 and rom3)
		JP 138Eh
		JP 13A9h
		JP 1532h
		JP 15EBh
		JP 1D79h ;ERASEM

		;JP 199Dh ;LDBYTS
		;JP 18DFh ;SVBYTS
