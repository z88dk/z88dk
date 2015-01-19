;--------------------------------------------------------------
; ZX81 HRG library for the G007 expansion
; by Stefano Bodrato, Fall 2014
;--------------------------------------------------------------
;
;   Exit from HRG mode
;
;	$Id: g007_hrg_off.asm,v 1.3 2015-01-19 01:32:52 pauloscustodio Exp $
;

	PUBLIC	hrg_off

	EXTERN	L0292
	EXTERN	G007_P1
	EXTERN	G007_P2
	EXTERN	G007_P3
	
.hrg_off

	ld	a,193
	ld	(G007_P2+2),A	; patch our custom interrupt handler
	
	ld	hl,L0292
	ld	(G007_P1+1),HL
	ld	(G007_P3+1),HL

	ld	a,$1e
	ld	i,a	
	ret

