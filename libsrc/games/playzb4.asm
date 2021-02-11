;
; Generic version
; calibrated for a fixed bitrate, 1-bit
;
; Stefano Bodrato, Feb - 2021
;

;
;$Id: playzb4.asm $
;

; extern void __LIB__ playzb4(uchar *SamStart, ushort SamLen);
; play 4 bit pulse wave encoded data using sid master volume


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

	IF sndbit_port >= 256
	  exx
	  ld   bc,sndbit_port
	  exx
	ENDIF

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
	ld	hl,_dithpat
	add l
	ld  l,a
	ld	a,h
	adc 0
	ld  h,a

	ld	a,(hl)

;  LOOP UNROLLING !!
;	ld b,6
;byte1:
	  rlca
	  ld   l,a
	  sbc  a,a	; 0 or FF
	  and  sndbit_mask
	  ld   c,a
	  ld   a,(__snd_tick)
	  xor  c
	  
	IF sndbit_port >= 256
	  exx
	  out  (c),a                   ;9 T slower
	  exx
	ELSE
	  out  (sndbit_port),a
	ENDIF

	  ld a,l
	;djnz byte1
	  rlca
	  ld   l,a
;  LOOP UNROLLING !!
	  sbc  a,a	; 0 or FF
	  and  sndbit_mask
	  ld   c,a
	  ld   a,(__snd_tick)
	  xor  c
	  
	IF sndbit_port >= 256
	  exx
	  out  (c),a                   ;9 T slower
	  exx
	ELSE
	  out  (sndbit_port),a
	ENDIF
	
	  ld a,l
	  rlca
	  ld   l,a

	  sbc  a,a	; 0 or FF
	  and  sndbit_mask
	  ld   c,a
	  ld   a,(__snd_tick)
	  xor  c
	  
	IF sndbit_port >= 256
	  exx
	  out  (c),a                   ;9 T slower
	  exx
	ELSE
	  out  (sndbit_port),a
	ENDIF
	
	  ld a,l
	  rlca
	  ld   l,a

	  sbc  a,a	; 0 or FF
	  and  sndbit_mask
	  ld   c,a
	  ld   a,(__snd_tick)
	  xor  c
	  
	IF sndbit_port >= 256
	  exx
	  out  (c),a                   ;9 T slower
	  exx
	ELSE
	  out  (sndbit_port),a
	ENDIF
	
	  ld a,l
	  rlca
	  ld   l,a

	  sbc  a,a	; 0 or FF
	  and  sndbit_mask
	  ld   c,a
	  ld   a,(__snd_tick)
	  xor  c
	  
	IF sndbit_port >= 256
	  exx
	  out  (c),a                   ;9 T slower
	  exx
	ELSE
	  out  (sndbit_port),a
	ENDIF
	
	  ld a,l
	  rlca
	  ld   l,a

	  sbc  a,a	; 0 or FF
	  and  sndbit_mask
	  ld   c,a
	  ld   a,(__snd_tick)
	  xor  c
	  
	IF sndbit_port >= 256
	  exx
	  out  (c),a                   ;9 T slower
	  exx
	ELSE
	  out  (sndbit_port),a
	ENDIF

	;pop de
	pop hl
	ret




	SECTION rodata_clib

_dithpat:
	
	defb	@00000000	; 0
	
	defb	@00000000	; 1
	
	defb	@00000100	; 2

	defb	@00001100	; 3

	defb	@00010100	; 4

	defb	@00101000	; 5

	defb	@00111001	; 6

	defb	@10001011	; 7

	defb	@10101110	; 8

	defb	@11001100	; 9

	defb	@11001100	; 10

	defb	@11011101	; 11

	defb	@11011101	; 12

	defb	@11011111	; 13

	defb	@11111101	; 14

	defb	@11111111	; 15
