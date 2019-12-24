; $Id: bit_open_di.asm,v 1.6 2016-06-16 20:23:52 dom Exp $
;
; VZ 200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 31/3/2008
;

	SECTION	code_clib
	PUBLIC  bit_open_di
	PUBLIC  _bit_open_di
	PUBLIC  bit_open
	PUBLIC  _bit_open
	EXTERN	__snd_tick
	EXTERN	__bit_irqstatus

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
	ld	a,@00000101
	ld	(__snd_tick),a
	ret
