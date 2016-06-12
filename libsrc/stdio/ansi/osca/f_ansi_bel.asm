;
;       OSCA C Library
;
; 	ANSI Video handling
;
; 	BEL - chr(7)   Beep it out
;	
;
;	Stefano Bodrato - June 2012
;
;
;	$Id: f_ansi_bel.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL
    INCLUDE "osca.def"
    INCLUDE "flos.def"

.ansi_BEL
	di

	ld hl,0
	ld e,2
	call kjt_read_sysram_flat
	push af
	ld hl,1
	ld e,2
	call kjt_read_sysram_flat
	push af
	ld hl,0
	ld e,2
	ld a,$80	;put 1st byte square wave
	call kjt_write_sysram_flat
	ld hl,1
	ld e,2
	ld a,$7f	;put 2nd byte square wave
	call kjt_write_sysram_flat
	
;-----------------------------------------------------------------------------------------
	
	in a,(sys_audio_enable)	
	and @11111110
	out (sys_audio_enable),a	;stop channel 0 playback


	in a,(sys_vreg_read)	;wait for the beginning of a scan line 
	and $40			;(ie: after audio DMA) This is so that all the
	ld b,a			;audio registers are cleanly initialized
.dma_loop
	in a,(sys_vreg_read)
	and $40
	cp b
	jr z,dma_loop
	

	ld hl,0			;Sample location * WORD POINTER IN SAMPLE RAM* 
	ld b,h			;(EG: 0=$20000,1=$20002)
	ld c,audchan0_loc
	out (c),l			;write sample address to relevant port
	
	ld hl,1			;sample length * IN WORDS *
	ld b,h
	ld c,audchan0_len
	out (c),l			;set sample length to relevant port
	
	ld hl,$4000		;period = clock ticks between sample bytes
	ld b,h
	ld c,audchan0_per
	out (c),l			;set sample period to relevant port 
	
	ld a,64
	out (audchan0_vol),a	;set sample volume to relevant port (64 = full volume)
	
	in a,(sys_audio_enable)	
	or @00000001
	out (sys_audio_enable),a	;start channel 0 playback

	xor a
	ld b,50	; sleep abt 200 milliseconds
.bdelay
	call kjt_timer_wait
	djnz bdelay
	
	in a,(sys_audio_enable)	
	and @11111110
	out (sys_audio_enable),a	;stop channel 0 playback

	ld hl,1
	ld e,2
	pop af
	call kjt_write_sysram_flat
	ld hl,0
	ld e,2
	pop af
	call kjt_write_sysram_flat

	ei
	ret
