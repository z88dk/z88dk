;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 30/06/2006
;
;	Currah uSpeech call, just speak as it does in BASIC
;
;	int currah_speech(char *text);
;
;
;	$Id: currah_speech.asm,v 1.2 2015-01-19 01:33:11 pauloscustodio Exp $
;

	PUBLIC	currah_speech
	EXTERN	zx_setstr
	
currah_speech:
	pop	bc
	pop	hl	; text
	push	hl
	push	bc
	
	ld	c,'s'
	ld	b,0
	push	bc		; char for s$
	push	hl		; text
	call	zx_setstr
	pop	hl
	pop	bc
	
	ld	bc,1
	jp	$1f3d		; PAUSE 1
