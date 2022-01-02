;
; Generic version
; calibrated for a fixed bitrate, 1-bit
;
; Stefano Bodrato, Feb - 2021
;

;
;$Id: playzb4_big.asm $
;

; extern void __LIB__ playzb4(uchar *SamStart, ushort SamLen);
; play 4 bit pulse wave encoded data using sid master volume


IF !__CPU_GBZ80__ && !__CPU_INTEL__

	SECTION code_clib
	
	PUBLIC	playzb4
	PUBLIC	_playzb4

    EXTERN	bit_open_di
    EXTERN	bit_close_ei
    EXTERN	__snd_tick

    INCLUDE  "games/games.inc"


playzb4:
_playzb4:

	call	bit_open_di

	pop	bc
	pop	de	;sample length
	pop	hl	;sample start addr
	push	hl
	push	de
	push	bc


	push hl
	push de
	ld	hl,dithpat
	ld	b,dithpat_end-dithpat
rep:
	  ld	a,(hl)
	  and  SOUND_ONEBIT_mask      ; check the bit status
	  ld   a,0
	  jr   z,noz
	  dec  a
noz:
	  ld   d,a
	  ld   a,(__snd_tick)
	  or  d                 ; toggle the sound bit to be sure it 'plays'
	  ld   (hl),a
	  inc  hl
	djnz rep
	pop de
	pop hl


rep1:
	ld      a,(hl)          ; a = sample byte
	rrca                    ; a = a div 16
	rrca                    ;
	rrca                    ;
	rrca                    ;
	and     $0f             ; 4 bit nibble
	call	do_sound

	ld      a,(hl)          ; a = sample byte
	and     $0f             ; 4 bit nibble
	call	do_sound

	inc     hl              ; hl = hl+1
	dec     e               ;
	jr      nz,rep1         ;
	dec     d               ; de = de-1
	jr      nz,rep1         ;until de = 0

	jp	bit_close_ei



do_sound:
	push hl
	;push de
	add a
	ld	l,a
	add a	; x4
	add l	; x6
	ld	hl,dithpat
	add l
	ld  l,a
	ld	a,h
	adc 0
	ld  h,a

	ld   bc,SOUND_ONEBIT_port
	
	; 15 times
	outi
	outi
	outi
	outi

	outi
	outi
	outi
	outi

	outi
	outi
	outi
	outi

	outi
	outi
	outi

	pop hl
	ret




	SECTION data_clib

; 15 samples, starting at marked position
dithpat:
	defb	@00000000	; 0
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000	; 1
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000	; 2
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000	; 3
	defb	@11111111
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000	; 4
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@11111111	; 5
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@11111111	; 6
	defb	@00000000
	defb	@11111111
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000	; 7
	defb	@00000000
	defb	@11111111
	defb	@00000000
	defb	@11111111
	defb	@11111111
	defb	@00000000	; 8
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@00000000
	defb	@11111111
	defb	@11111111	; 9
	defb	@11111111
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@00000000	; 10
	defb	@11111111
	defb	@00000000
	defb	@11111111
	defb	@00000000
	defb	@11111111
	defb	@11111111	; 11
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@11111111
	defb	@00000000
	defb	@00000000	; 12
	defb	@11111111
	defb	@11111111
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@11111111	; 13
	defb	@00000000
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@00000000
	defb	@11111111	; 14
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111	; 15
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111

dithpat_end:

ENDIF
