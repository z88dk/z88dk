;--------------------------------------------------------------
; ZX81 HRG library for the G007 expansion
; by Stefano Bodrato, Fall 2014
;--------------------------------------------------------------
;
;   Exit from HRG mode
;
;	$Id: g007_hrg_off.asm,v 1.1 2014-10-22 07:16:41 stefano Exp $
;

	XLIB	hrg_off

	XREF	L0292
	XREF	G007_P1
	XREF	G007_P2
	XREF	G007_P3
	
.hrg_off

	ld	a,193
	ld	(G007_P2+2),A	; patch our custom interrupt handler
	
	ld	hl,L0292
	ld	(G007_P1+1),HL)
	ld	(G007_P3+1),HL)

	ld	a,$1e
	ld	i,a	
	ret

