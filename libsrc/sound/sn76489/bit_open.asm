	SECTION code_clib
	

IF !__CPU_INTEL__ & !__CPU_RABBIT__ & !__CPU_GBZ80__
	
    PUBLIC     bit_open
    PUBLIC     _bit_open
	PUBLIC     bit_open_di
    PUBLIC     _bit_open_di

    PUBLIC	bit_close
    PUBLIC	_bit_close
    PUBLIC	bit_close_ei
    PUBLIC	_bit_close_ei

    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

	EXTERN	psg_init
	EXTERN	psg_tone
	
;	$Id: bit_open.asm $

;==============================================================
; void bit_open();
; void bit_open_di();
; void bit_close();
; void bit_close_ei();
;==============================================================
; Generic 1 bit sound functions
;==============================================================

.bit_open_di
._bit_open_di
	ld a,i		; get the current status of the irq line
	di
	push af
	
	ex (sp),hl
	ld (__bit_irqstatus),hl
	pop hl

	
.bit_open
._bit_open

	call psg_init
	ld	de,1	; channel 1, frequency 1 (fixed high output, volume will change the level)
	push de
	push de
	call psg_tone
	pop de
	pop de
	
	ld	a,$BF	; channel 1 ($20) + set volume command ($90) + max attenuation ($0F)
	ld	(__snd_tick),a
	;out	(psgport), a	; Sends it, but I think it is not necessary, the OUT instruction will happen in bit_* library
	
	ret


.bit_close_ei
._bit_close_ei
	push hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei


.bit_close
._bit_close
	ret
ENDIF
