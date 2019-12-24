; $Id: bit_open_di.asm,v 1.6 2016-06-16 20:23:52 dom Exp $
;
; void bit_open();
;
;

	SECTION	code_clib
	PUBLIC  bit_open_di
	PUBLIC  _bit_open_di
	PUBLIC  bit_open
	PUBLIC  _bit_open
	EXTERN	__snd_tick
	EXTERN	__bit_irqstatus
	EXTERN	PORT_F0_COPY

	INCLUDE	"target/laser500/def/laser500.def"

.bit_open_di
._bit_open_di

        ld	a,i		; get the current status of the irq line
        di
        push	af
        ex	(sp),hl
        ld	(__bit_irqstatus),hl
        pop	hl
bit_open:
_bit_open:
	ld	a,(PORT_F0_COPY)
	ld	(__snd_tick),a
	ret
