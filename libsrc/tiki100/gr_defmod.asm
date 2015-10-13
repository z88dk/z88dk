;
;	TIKI-100 graphics routines
;	by Stefano Bodrato, Fall 2015
;
; void __FASTCALL__ gr_defmod(uchar mode)
;
; Set graphics mode
; (1 = BW mode, 2 = four color mode, 3 = 16 color mode)
;
;
;	$Id: gr_defmod.asm,v 1.2 2015-10-13 19:56:30 stefano Exp $
;

PUBLIC gr_defmod
PUBLIC gr_currentmode

gr_currentmode:
		defb 16

gr_defmod:
	ld a,l
	and 3
	sla a
	sla a
	sla a
	sla a
	ld (gr_currentmode),a
	
	DI
	LD ($F04D),A	; Video port: copy of the value sent to the video port address 0CH
	OUT   ($0C),A		; set graphics mode
	EI
	RET
