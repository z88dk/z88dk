SECTION code_user

; public

PUBLIC _engine_music_manager_load_module
PUBLIC _engine_music_manager_start_module
PUBLIC _engine_music_manager_play_module
PUBLIC _engine_music_manager_pause_module

_engine_music_manager_load_module:

		ld a, 2
		ld hl, $8000

		jp PSGMOD_LoadModule

defc _engine_music_manager_start_module = PSGMOD_Start
defc _engine_music_manager_play_module  = PSGMOD_Play
defc _engine_music_manager_pause_module = PSGMOD_Pause

; private

;01
PSGMOD_LoadModule:
	ld   b, a
	ld   a, ($FFFF)
	push af
	ld   a, b
	ld   ($C24B), a				; ld   (PSGMOD_FRAME), a				; ld   ($C24B), a
	ld   ($FFFF), a
	ld   ($C255), hl			; ld   (PSGMOD_ADDRESS), hl				; ld   ($C255), hl
	ld   c, (hl)
	inc  hl
	ld   b, (hl)
	inc  hl
	ld   ($C204), bc			; ld   (PSGMOD_LENGTH), bc				; ld   ($C204), bc
	ld   ($C206), bc			; ld   (PSGMOD_LENGTH_CNT), bc			; ld   ($C206), bc
	ld   de, $C100				; ld   de, PSGMOD_INSTRUMENTS			; ld   de, $C100
	ld   bc, $0100				; ld   bc, 256							; ld   bc, $0100
	ldir
	ld   e, $15					; ld   e, PSGMOD_INITIAL_SPEED & 255	; ld   e, $15
	ldi
	ldi
	ldi
	ldi
	ld   ($C200), hl			; ld   (PSGMOD_SEQ_LIST_START_PTR), hl	; ld   ($C200), hl
	ld   ($C202), hl			; ld   (PSGMOD_SEQ_LIST_PTR), hl		; ld   ($C202), hl

	call PSGMOD_StartSequences
	call PSGMOD_ResetPlayer

	pop  af
	ld   ($FFFF), a

	ret
	
	
;02
PSGMOD_ResetPlayer:
	ld   a, ($C215)				; ld a, (PSGMOD_INITIAL_SPEED)
	ld   ($C219), a				; ld (PSGMOD_SPEED), a
	ld   a, ($C216)				; ld a, (PSGMOD_INITIAL_GG_STEREO)
	ld   ($C21C), a				; ld (PSGMOD_GG_STEREO), a
	ld   a, $07
	ld   ($C21A), a				; ld   (PSGMOD_SPEED_CNT), a
	xor  a
	ld   ($C24C), a				; ld   (PSGMOD_STARTED), a
	ld   hl, $C100				; ld hl, PSGMOD_INSTRUMENTS
	ld   ($C21F), hl			; ld (PSGMOD_INSTR_PTR), hl
	ld   ($C221), hl			; ld (PSGMOD_INSTR_PTR+2), hl
	ld   ($C223), hl			; ld (PSGMOD_INSTR_PTR+4), hl
	ld   ($C225), hl			; ld (PSGMOD_INSTR_PTR+6), hl
	ld   hl, $0101
	ld   ($C210), hl			; ld (PSGMOD_SEQ_WAIT), hl
	ld   ($C212), hl			; ld (PSGMOD_SEQ_WAIT+2), hl
	dec  h
	dec  l
	ld   ($C223), hl			; ld (PSGMOD_PHASE_VOLUME), hl
	ld   ($C225), hl			; ld (PSGMOD_PHASE_VOLUME+2), hl
	ld   ($C236), hl			; ld (PSGMOD_VOLUME), hl
	ld   ($C238), hl			; ld (PSGMOD_VOLUME+2), hl
	ld   ($C240), hl			; ld (PSGMOD_PULSE_VIBRATO), hl
	ld   ($C227), a				; ld (PSGMOD_PHASE_VOLUME_ADD_0), a
	ld   ($C229), a				; ld (PSGMOD_PHASE_VOLUME_ADD_1), a
	ld   ($C22B), a				; ld (PSGMOD_PHASE_VOLUME_ADD_2), a
	ld   ($C22D), a				; ld (PSGMOD_PHASE_VOLUME_ADD_3), a
	ld   ($C242), a				; ld (PSGMOD_PULSE_VIBRATO + 2), a
	dec  a
	ld   ($C228), a				; ld (PSGMOD_PHASE_DELAY_0), a
	ld   ($C22A), a				; ld (PSGMOD_PHASE_DELAY_1), a
	ld   ($C22C), a				; ld (PSGMOD_PHASE_DELAY_2), a
	ld   ($C22E), a				; ld (PSGMOD_PHASE_DELAY_3), a
	ld   l, $F0
	ld   ($C22F), hl			; ld (PSGMOD_FREQUENCY), hl
	ld   ($C231), hl			; ld (PSGMOD_FREQUENCY + 2), hl
	ld   ($C233), hl			; ld (PSGMOD_FREQUENCY + 4), hl
	ld   a, $E0
	ld   ($C235), a				; ld (PSGMOD_FREQUENCY+6), a
	ld   hl, $0D0D
	ld   ($C21F), hl			; ld (PSGMOD_INSTR_PTR), hl
	ld   ($C221), hl			; ld (PSGMOD_INSTR_PTR+2), hl
	ld   hl, $8000
	ld   ($C23A), hl			; ld (PSGMOD_VIBPOS), hl
	ld   ($C23C), hl			; ld (PSGMOD_VIBPOS+2), hl
	ld   ($C23E), hl			; ld (PSGMOD_VIBPOS+4), hl
	ld   a, $55
	ld   ($C21B), a				; ld (PSGMOD_PULSE_VIBRATO_MASK), a
	ret	
	
	
;03
PSGMOD_Start:
	ld   a, $01
	jp   PSGMOD_PauseII	; jp   +

PSGMOD_Pause:
  xor  a

PSGMOD_PauseII:
	ld   ($C24C), a				; ld   (PSGMOD_STARTED), as

PSGMOD_ResetPSG:
	ld   bc, $0A7F				; ld   bc, (10 << 8) | (PSGMOD_PSG_PORT)
	ld   hl, PSGMOD_ResetPSG_Table		;ld   hl, $0245
	otir

	ld   a, ($C235)				; ld   a, (PSGMOD_FREQUENCY + 6)
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a	
	ret

PSGMOD_ResetPSG_Table:
; Set all volumes to 0
;.db (15|144),(15|144)+32,(15|144)+64,(15|144)+96

; Set tone channel frequencies to 0
;.db 128,0,128+32,0,128+64,0

defb $9F, $BF, $DF, $FF, $80, $00, $A0, $00, $C0, $00	
	

;04
PSGMOD_Play:
	ld   a, ($C24C)				; ld   a, (PSGMOD_STARTED)
	and  a
	jp   Z, PSGMOD_ResetPSG		; jp   z, _LABEL_237_19						; _LABEL_237_19
	ld   a, ($C21A)				; ld   a, (PSGMOD_SPEED_CNT)
	sub  0x08				
	jp   c, PSGMOD_Play_TriggerLine	; jp   C, _LABEL_4E3_20					; _LABEL_4E3_20
	ld   ($C21A), a				; ld   (PSGMOD_SPEED_CNT), a

PSGMOD_Play_TriggerLine_Cont:
;_LABEL_261_74:
	ld   a, ($C24D)				; ld a, (PSGMOD_SFX_2_PRIORITY)
	or   a
	jr Z, PSGMOD_Play_NoSFX_2	; jr   z, _LABEL_2AB_21						; _LABEL_2AB_21
	ld   hl, $C24F				; ld hl, PSGMOD_SFX_2_CNT
	ld   a, (hl)
	sub  $01
	ld   (hl), a
	jr   nc, PSGMOD_Play_NoSFX_2_End	; jr NC, _LABEL_29F_22				; _LABEL_29F_22
	xor  a
	ld   ($C24D), a				; ld (PSGMOD_SFX_2_PRIORITY), a
	ld   a, ($C21B)				; ld a, (PSGMOD_PULSE_VIBRATO_MASK)
	or   a
	ld   hl, ($C233)			; ld hl, (PSGMOD_FREQUENCY+4)
	jr   z, PSGMOD_Play_ResetFreq2_NoVib	; jr Z, _LABEL_284_23			; _LABEL_284_23
	ld   d, $00
	ld   a, ($C242)				; ld a, (PSGMOD_PULSE_VIBRATO + 2)
	ld   e, a
	add  hl, de
	
PSGMOD_Play_ResetFreq2_NoVib:
;_LABEL_284_23:
	ld   a, l
	and  $0F
	or   $C0
	out  ($7F), a				; out (PSGMOD_PSG_PORT), a
	ld   a, l
	rrca
	rrca
	rrca
	rrca
	and  $0F
	ld   b, a
	ld   a, h
	and  $03
	rrca
	rrca
	rrca
	rrca
	or   b
	out  ($7F), a				; out (PSGMOD_PSG_PORT), a
	jr PSGMOD_Play_NoSFX_2		; jr _LABEL_2AB_21							; _LABEL_2AB_21

PSGMOD_Play_NoSFX_2_End:
;_LABEL_29F_22:
	ld   hl, ($C251)			; ld hl, (PSGMOD_SFX_2_ADDRESS)
	outi
	outi
	outi
	ld   ($C251), hl			; ld (PSGMOD_SFX_2_ADDRESS), hl

PSGMOD_Play_NoSFX_2:
;_LABEL_2AB_21:
	ld   a, ($C24E)				; ld a, (PSGMOD_SFX_3_PRIORITY)
	or   a
	jr   z, PSGMOD_Play_NoSFX_3	; jr Z, _LABEL_2D8_24						; _LABEL_2D8_24
	ld   hl, $C250				; ld hl, PSGMOD_SFX_3_CNT
	ld   a, (hl)
	sub  $01
	ld   (hl), a
	jr   nc, PSGMOD_Play_NoSFX_3_End	; jr NC, _LABEL_2C5_25				; _LABEL_2C5_25
	xor  a
	ld   ($C24E), a				; ld (PSGMOD_SFX_3_PRIORITY), a
	ld   a, ($C235)				; ld a, (PSGMOD_FREQUENCY + 6)
	out  ($7F), a				; out (PSGMOD_PSG_PORT), a
	jr   PSGMOD_Play_NoSFX_3	; jr _LABEL_2D8_24							; _LABEL_2D8_24

PSGMOD_Play_NoSFX_3_End:
;_LABEL_2C5_25:
	ld   hl, ($C253)			; ld hl, (PSGMOD_SFX_3_ADDRESS)
	ld   a, (hl)
	inc  hl
	or   a
	jr   z, PSGMOD_Play_SFX_3_	; jr Z, _LABEL_2D1_26						; _LABEL_2D1_26
	ld   a, (hl)
	inc  hl
	out  ($7F), a				; out (PSGMOD_PSG_PORT), a

PSGMOD_Play_SFX_3_:
;_LABEL_2D1_26:
	ld   a, (hl)
	inc  hl
	out  ($7F), a				; out (PSGMOD_PSG_PORT), a
	ld   ($C253), hl			; ld (PSGMOD_SFX_3_ADDRESS), hl

PSGMOD_Play_NoSFX_3:
;_LABEL_2D8_24:

;.MACRO _PSGMOD_SET_TONE_CHANNEL_PSG
	ld   a, $03					; ld   a, :PSGMOD_VIBRATO_TABLES
	ld   ($FFFF), a
	ld   c, $0F

;_PSGMOD_SET_TONE_CHANNEL_PSG 0, 0
	ld   a, ($C236)				; ld   a, (PSGMOD_VOLUME + \1)
	ld   d, a
	ld   a, ($C223)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	rrca
	rrca
	rrca
	rrca
	and  c
	add  a, d
	sub  c
	jp   NC, _LABEL_2F1_27		; jp   nc, +								; _LABEL_2F1_27
	xor  a	

;+:
_LABEL_2F1_27:
	xor  $9F					; xor  ($60 - (32 * \1)) ~ $FF
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	ld   hl, ($C22F)			; ld   hl, (PSGMOD_FREQUENCY + \2)
	ld   de, $0000
	ld   a, ($C21B)				; ld   a, (PSGMOD_PULSE_VIBRATO_MASK)
	rrca
	jp   NC, _LABEL_306_28		; jp   nc, +								; _LABEL_306_28
	ld   a, ($C240)				; ld   a, (PSGMOD_PULSE_VIBRATO + \1)
	ld   e, a
	
;+:
_LABEL_306_28:
	add  hl, de
	ld   a, l
	or   $F0
	ld   l, a
	ld   de, ($C23A)			; ld   de, (PSGMOD_VIBPOS + \2)
	ld   a, (de)
	ld   b, a
	inc  e
	ld   a, (de)
	ld   d, a
	inc  e
	ld   a, e
	ld   ($C23A), a				; ld   (PSGMOD_VIBPOS + \2), a
	ld   e, b
	add  hl, de
	ld   a, l
	and  c
	or   $80					; or   128 + (32 * \1)
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	ld   a, h
	and  $3F
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	
;_PSGMOD_SET_TONE_CHANNEL_PSG 1, 2
	ld   a, ($C237)				; ld   a, (PSGMOD_VOLUME + \1)
	ld   d, a
	ld   a, ($C224)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	rrca
	rrca
	rrca
	rrca
	and  c
	add  a, d
	sub  c
	jp   NC, _LABEL_338_29		; jp   nc, + 								; _LABEL_338_29
	xor  a

;+:
_LABEL_338_29:
	xor  $BF					; xor  ($60 - (32 * \1)) ~ $FF
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	ld   hl, ($C231)			; ld   hl, (PSGMOD_FREQUENCY + \2)
	ld   de, $0000
	ld   a, ($C21B)				; ld   a, (PSGMOD_PULSE_VIBRATO_MASK)
	rrca
	jp   nc, _LABEL_34D_30			; jp   NC, +				; _LABEL_34D_30
	ld   a, ($C241)				; ld   a, (PSGMOD_PULSE_VIBRATO + \1)
	ld   e, a
	
;+:
_LABEL_34D_30:
	add  hl, de
	ld   a, l
	or   $F0
	ld   l, a
	ld   de, ($C23C)			; ld   de, (PSGMOD_VIBPOS + \2)
	ld   a, (de)
	ld   b, a
	inc  e
	ld   a, (de)
	ld   d, a
	inc  e
	ld   a, e
	ld   ($C23C), a				; ld   (PSGMOD_VIBPOS + \2), a
	ld   e, b
	add  hl, de
	ld   a, l
	and  c
	or   $A0					; or   128 + (32 * \1)
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	ld   a, h
	and  $3F
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	
;_PSGMOD_SET_TONE_CHANNEL_PSG 2, 4
	ld   a, ($C24D)				; ld   a, (PSGMOD_SFX_2_PRIORITY)
	and  a
	jr   NZ, _LABEL_3BA_31		; jr   nz, ++								; _LABEL_3BA_31

	ld   a, ($C238)				; ld   a, (PSGMOD_VOLUME + \1)
	ld   d, a
	ld   a, ($C225)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	rrca
	rrca
	rrca
	rrca
	and  c
	add  a, d
	sub  c
	jp   NC, _LABEL_385_32		; jp   nc, +								; _LABEL_385_32
	xor  a

;+:
_LABEL_385_32:
	xor  $DF					; xor  ($60 - (32 * \1)) ~ $FF
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	ld   hl, ($C233)			; ld   hl, (PSGMOD_FREQUENCY + \2)
	ld   de, $0000
	ld   a, ($C21B)				; ld   a, (PSGMOD_PULSE_VIBRATO_MASK)
	rrca
	jp   NC, _LABEL_39A_33		; jp   nc, +								; _LABEL_39A_33
	ld   a, ($C242)				; ld   a, (PSGMOD_PULSE_VIBRATO + \1)
	ld   e, a

;+:
_LABEL_39A_33:
	add  hl, de
	ld   a, l
	or   $F0
	ld   l, a
	ld   de, ($C23E)			; ld   de, (PSGMOD_VIBPOS + \2)
	ld   a, (de)
	ld   b, a
	inc  e
	ld   a, (de)
	ld   d, a
	inc  e
	ld   a, e
	ld   ($C23E), a				; ld   (PSGMOD_VIBPOS + \2), a
	ld   e, b
	add  hl, de
	ld   a, l
	and  c
	or   $C0					; or   128 + (32 * \1)
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	ld   a, h
	and  $3F
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	
;++:
_LABEL_3BA_31:	

;_PSGMOD_SET_TONE_CHANNEL_PSG 3, 6
	ld   a, ($C24E)				;  ld   a, (PSGMOD_SFX_3_PRIORITY)
	and  a
	jr   NZ, _LABEL_3D6_34		; jr   nz, ++								; _LABEL_3D6_34

	ld   a, ($C239)				; ld   a, (PSGMOD_VOLUME + \1)
	ld   d, a
	ld   a, ($C226)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	rrca
	rrca
	rrca
	rrca
	and  c
	add  a, d
	sub  c
	jp   NC, _LABEL_3D2_35		; jp   nc, +								; _LABEL_3D2_35
	xor  a
	
;+:
_LABEL_3D2_35:
	xor  $FF					; xor  ($60 - (32 * \1)) ~ $FF
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a
	
;++:
_LABEL_3D6_34:	

;.MACRO PSGMOD_PLAY_INSTRUMENT

;PSGMOD_PLAY_INSTRUMENT 0, 0
	ld   a, ($C223)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	ld   hl, $C227				; ld   hl, PSGMOD_PHASE_VOLUME_ADD_0 + \2
	add  a, (hl)
	ld   ($C223), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	dec  (hl)
	jp   nz, PSGMOD_Play_PhasesDone0	; jp   NZ, _LABEL_401_36			; _LABEL_401_36
	ld   d, h
	dec  h
	ld   a, ($C21F)				; ld   a, (PSGMOD_INSTR_PTR + \1)
	ld   l, a
	ld   e, $27					; ld   e, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	ldi
	ldi
	ld   a, (hl)
	ld   ($C23B), a				; ld (PSGMOD_VIBPOS + \2 + 1), a
	inc  l
	ld   a, l
	and  $0F
	jp  Z, _LABEL_400_37		; jp   z, +									; _LABEL_400_37
	ld   a, l
	ld   ($C21F), a				; ld (PSGMOD_INSTR_PTR + \1), a

;+:
_LABEL_400_37:
	inc  h

PSGMOD_Play_PhasesDone0:
;_LABEL_401_36:

;PSGMOD_PLAY_INSTRUMENT 1, 2
	ld   a, ($C224)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	ld   l, $29					; ld   l, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	add  a, (hl)
	ld   ($C224), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	dec  (hl)
	jp   NZ, PSGMOD_Play_PhasesDone1	; jp   nz, _LABEL_42B_38			; _LABEL_42B_38
	ld   d, h
	dec  h
	ld   a, ($C220)				; ld   a, (PSGMOD_INSTR_PTR + \1)
	ld   l, a
	ld   e, $29					; ld   e, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	ldi
	ldi
	ld   a, (hl)
	ld   ($C23D), a				; ld (PSGMOD_VIBPOS + \2 + 1), a
	inc  l
	ld   a, l
	and  $0F
	jp  Z, _LABEL_42A_39		; jp   z, +									; _LABEL_42A_39
	ld   a, l
	ld   ($C220), a

;+:
_LABEL_42A_39:
	inc  h

PSGMOD_Play_PhasesDone1:
;_LABEL_42B_38:

;PSGMOD_PLAY_INSTRUMENT 2, 4
	ld   a, ($C225)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	ld   l, $2B					; ld   l, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	add  a, (hl)
	ld   ($C225), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	dec  (hl)
	jp   nz, PSGMOD_Play_PhasesDone2	; jp   NZ, _LABEL_455_40			;  _LABEL_455_40
	ld   d, h
	dec  h
	ld   a, ($C221)				; ld   a, (PSGMOD_INSTR_PTR + \1)
	ld   l, a
	ld   e, $2B					; ld   e, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	ldi
	ldi
	ld   a, (hl)
	ld   ($C23F), a				; ld (PSGMOD_VIBPOS + \2 + 1), a
	inc  l
	ld   a, l
	and  $0F
	jp  Z, _LABEL_454_41		; jp   z, +									; _LABEL_454_41
	ld   a, l
	ld   ($C221), a				; ld (PSGMOD_INSTR_PTR + \1), a

;+:
_LABEL_454_41:
	inc  h

PSGMOD_Play_PhasesDone2:
;_LABEL_455_40:

;PSGMOD_PLAY_INSTRUMENT 3, 6
	ld   a, ($C226)				; ld   a, (PSGMOD_PHASE_VOLUME + \1)
	ld   l, $2D					; ld   l, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	add  a, (hl)
	ld   ($C226), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	dec  (hl)
	ret  nz

	ld   d, h
	dec  h
	ld   a, ($C222)				; ld   a, (PSGMOD_INSTR_PTR + \1)
	ld   l, a
	ld   e, $2D					; ld   e, (PSGMOD_PHASE_VOLUME_ADD_0 + \2) & 255
	ldi
	ldi
	inc  l
	ld   a, l
	and  $0F
	jp  Z, _LABEL_478_42		; jp   z, +									; _LABEL_478_42
	ld   a, l
	ld   ($C222), a				; ld (PSGMOD_INSTR_PTR + \1), a

;+:
_LABEL_478_42:
	inc  h
	ret
	
	
;05
PSGMOD_StartSequences:
	ld   de, ($C255)			; ld   de, (PSGMOD_ADDRESS)		; ld   de, ($C255)

  ; PSGMOD_START_SEQUENCE 0, 0
	ld   c, (hl)
	inc  hl
	ld   b, (hl)
	inc  hl
	push hl
	ld   h, b
	ld   l, c
	add  hl, de
	ld   a, (hl)
	add  a, e
	ld   c, a
	inc  hl
	ld   a, d
	adc  a, (hl)
	ld   b, a
	ld   ($C243), bc			; ld   (PSGMOD_NOTES_PTR + \2), bc
	inc  hl
	ld   a, (hl)
	ld   ($C214), a				; ld   (PSGMOD_SEQ_LENGTH_CNT), a ; nur einmal
	inc  hl
	ld   ($C208), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	pop  hl

  ; PSGMOD_START_SEQUENCE 1, 2
	ld   c, (hl)
	inc  hl
	ld   b, (hl)
	inc  hl
	push hl
	ld   h, b
	ld   l, c
	add  hl, de
	ld   a, (hl)
	add  a, e
	ld   c, a
	inc  hl
	ld   a, d
	adc  a, (hl)
	ld   b, a
	ld   ($C245), bc			; ld   (PSGMOD_NOTES_PTR + \2), bc
	inc  hl
	inc  hl
	ld   ($C20A), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	pop  hl

  ; PSGMOD_START_SEQUENCE 2. 4
	ld   c, (hl)
	inc  hl
	ld   b, (hl)
	inc  hl
	push hl
	ld   h, b
	ld   l, c
	add  hl, de
	ld   a, (hl)
	add  a, e
	ld   c, a
	inc  hl
	ld   a, d
	adc  a, (hl)
	ld   b, a
	ld   ($C247), bc			; ld   (PSGMOD_NOTES_PTR + \2), bc
	inc  hl
	inc  hl
	ld   ($C20C), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	pop  hl

  ; PSGMOD_START_SEQUENCE 3, 6
	ld   c, (hl)
	inc  hl
	ld   h, (hl)
	ld   l, c
	add  hl, de
	ld   a, (hl)
	add  a, e
	ld   c, a
	inc  hl
	ld   a, d
	adc  a, (hl)
	ld   b, a
	ld   ($C249), bc			; ld   (PSGMOD_NOTES_PTR + \2), bc
	inc  hl
	inc  hl
	ld   ($C20E), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl

	ret
	

;06
PSGMOD_Play_TriggerLine:
;_LABEL_4E3_20:
	ld   hl, $C219				; ld   hl, PSGMOD_SPEED
	add  a, (hl)
	inc  l
	ld   (hl), a
	inc  l
	rrc  (hl)
	ld   a, ($C24B)				; ld   a, (PSGMOD_FRAME)
	ld   ($FFFF), a

;.MACRO _PSGMOD_PLAY_CHANNEL
; _PSGMOD_PLAY_CHANNEL 0, 0
	ld   l, $10					; ld   l, (PSGMOD_SEQ_WAIT + \1) & 255
	dec  (hl)
	jp   nz, PSGMOD_Play_Ch0_Done	; jp   NZ, _LABEL_56C_43				; _LABEL_56C_43

PSGMOD_Play_ExecLine0:
;_LABEL_4F8_48:
	ld   hl, ($C208)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   b, (hl)
	inc  hl
	ld   ($C208), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	ld   a, b
	and  $E0
	jr   z, PSGMOD_Play_NoNote0	; jr   Z, _LABEL_549_44						; _LABEL_549_44
	rlca
	rlca
	rlca
	ld   ($C210), a				; ld   (PSGMOD_SEQ_WAIT + \1), a
	ld   hl, ($C243)			; ld   hl, (PSGMOD_NOTES_PTR + \2)
	ld   a, b
	and  $1F
	ld   d, a
	add  a, a
	add  a, d
	ld   e, a
	ld   d, $00
	add  hl, de
	ld   b, (hl)
	inc  hl
	ld   e, (hl)
	inc  hl
	ld   d, (hl)
	ld   ($C22F), de			; ld (PSGMOD_FREQUENCY+\2), de
	ld   a, b
	and  $0F
	ld   ($C236), a				; ld   (PSGMOD_VOLUME+\1), a
	ld   a, b
	and  $F0
	ld   h, $C1					; ld   h, PSGMOD_INSTRUMENTS >> 8
	ld   l, a
	ld   a, (hl)
	ld   ($C223), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	ld   de, $C227				; ld   de, PSGMOD_PHASE_VOLUME_ADD_0 + \2
	ldi
	ldi
	ld   a, (hl)
	ld   ($C23B), a				; ld   (PSGMOD_VIBPOS + \2 + 1), a
	xor  a
	ld   ($C23A), a				; ld   (PSGMOD_VIBPOS + \2), a
	inc  l
	ld   a, l
	ld   ($C21F), a				; ld   (PSGMOD_INSTR_PTR + \1), a
	jp   PSGMOD_Play_Ch0_Done	; jp   _LABEL_56C_43						; _LABEL_56C_43
	
PSGMOD_Play_NoNote0:
;_LABEL_549_44:
	rrc  b
	jp   nc, PSGMOD_Play_NoNote0_Wait; jp   NC, _LABEL_567_45				; _LABEL_567_45

	ld   hl, ($C208)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   a, (hl)
	inc  hl
	ld   ($C208), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	rrc  b
	jp   C, _LABEL_561_46		; jp   c, +									; _LABEL_561_46
	ld   ($C240), a				; ld (PSGMOD_PULSE_VIBRATO + \1), a
	jp   _LABEL_564_47			; jp   ++									; _LABEL_564_47

;+:
_LABEL_561_46:
	ld   ($C236), a				; ld (PSGMOD_VOLUME + \1), a

;++:
_LABEL_564_47:
	jp   PSGMOD_Play_ExecLine0	; jp   _LABEL_4F8_48						; _LABEL_4F8_48

PSGMOD_Play_NoNote0_Wait:
;_LABEL_567_45:
	ld   a, b
	inc  a
	ld   ($C210), a				; ld   (PSGMOD_SEQ_WAIT+\1), a

PSGMOD_Play_Ch0_Done:
;_LABEL_56C_43:	

;_PSGMOD_PLAY_CHANNEL 1, 2
	ld   hl, $C211				; ld   hl, PSGMOD_SEQ_WAIT+\1
	dec  (hl)
	jp   nz, PSGMOD_Play_Ch1_Done	; jp   NZ, _LABEL_5E7_49				; _LABEL_5E7_49

PSGMOD_Play_ExecLine1:
;_LABEL_573_54:
	ld   hl, ($C20A)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   b, (hl)
	inc  hl
	ld   ($C20A), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	ld   a, b
	and  $E0
	jr   z, PSGMOD_Play_NoNote1	; jr   Z, _LABEL_5C4_50						; _LABEL_5C4_50
	rlca
	rlca
	rlca
	ld   ($C211), a				; ld   (PSGMOD_SEQ_WAIT + \1), a
	ld   hl, ($C245)			; ld   hl, (PSGMOD_NOTES_PTR + \2)
	ld   a, b
	and  $1F
	ld   d, a
	add  a, a
	add  a, d
	ld   e, a
	ld   d, $00
	add  hl, de
	ld   b, (hl)
	inc  hl
	ld   e, (hl)
	inc  hl
	ld   d, (hl)
	ld   ($C231), de			; ld (PSGMOD_FREQUENCY+\2), de
	ld   a, b
	and  $0F
	ld   ($C237), a				; ld   (PSGMOD_VOLUME+\1), a
	ld   a, b
	and  $F0
	ld   h, $C1					; ld   h, PSGMOD_INSTRUMENTS >> 8
	ld   l, a
	ld   a, (hl)
	ld   ($C224), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	ld   de, $C229				; ld   de, PSGMOD_PHASE_VOLUME_ADD_0 + \2
	ldi
	ldi
	ld   a, (hl)
	ld   ($C23D), a				; ld   (PSGMOD_VIBPOS + \2 + 1), a
	xor  a
	ld   ($C23C), a				; ld   (PSGMOD_VIBPOS + \2), a
	inc  l
	ld   a, l
	ld   ($C220), a				; ld   (PSGMOD_INSTR_PTR + \1), a
	jp   PSGMOD_Play_Ch1_Done	; jp   _LABEL_5E7_49						; _LABEL_5E7_49
	
PSGMOD_Play_NoNote1:
;_LABEL_5C4_50:
	rrc  b
	jp   nc, PSGMOD_Play_NoNote1_Wait	; jp   _LABEL_5E2_51				; _LABEL_5E2_51

	ld   hl, ($C20A)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   a, (hl)
	inc  hl
	ld   ($C20A), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	rrc  b
	jp   C, _LABEL_5DC_52		; jp   c, +									; _LABEL_5DC_52
	ld   ($C241), a				; ld (PSGMOD_PULSE_VIBRATO + \1), a
	jp   _LABEL_5DF_53			; jp   ++									; _LABEL_5DF_53

;+:
_LABEL_5DC_52:
	ld   ($C237), a

;++:
_LABEL_5DF_53:
	jp   PSGMOD_Play_ExecLine1	; jp   PSGMOD_Play_ExecLine1				; _LABEL_573_54

PSGMOD_Play_NoNote1_Wait:
;_LABEL_5E2_51:
	ld   a, b
	inc  a
	ld   ($C211), a				; ld   (PSGMOD_SEQ_WAIT+\1), a

PSGMOD_Play_Ch1_Done:
;_LABEL_5E7_49:	

;_PSGMOD_PLAY_CHANNEL 2, 4
	ld   hl, $C212				; ld   hl, PSGMOD_SEQ_WAIT+\1
	dec  (hl)
	jp   nz, PSGMOD_Play_Ch2_Done	; jp   NZ, _LABEL_662_55				; _LABEL_662_55

PSGMOD_Play_ExecLine2:
;_LABEL_5EE_60:
	ld   hl, ($C20C)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   b, (hl)
	inc  hl
	ld   ($C20C), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	ld   a, b
	and  $E0
	jr   z, PSGMOD_Play_NoNote2	; jr   Z, PSGMOD_Play_NoNote2				; _LABEL_63F_56
	rlca
	rlca
	rlca
	ld   ($C212), a				; ld   (PSGMOD_SEQ_WAIT + \1), a
	ld   hl, ($C247)			; ld   hl, (PSGMOD_NOTES_PTR + \2)
	ld   a, b
	and  $1F
	ld   d, a
	add  a, a
	add  a, d
	ld   e, a
	ld   d, $00
	add  hl, de
	ld   b, (hl)
	inc  hl
	ld   e, (hl)
	inc  hl
	ld   d, (hl)
	ld   ($C233), de			; ld (PSGMOD_FREQUENCY+\2), de
	ld   a, b
	and  $0F
	ld   ($C238), a				;  ld   (PSGMOD_VOLUME+\1), a
	ld   a, b
	and  $F0
	ld   h, $C1					; ld   h, PSGMOD_INSTRUMENTS >> 8
	ld   l, a
	ld   a, (hl)
	ld   ($C225), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	ld   de, $C22B				; ld   de, PSGMOD_PHASE_VOLUME_ADD_0 + \2
	ldi
	ldi
	ld   a, (hl)
	ld   ($C23F), a				; ld   (PSGMOD_VIBPOS + \2 + 1), a
	xor  a
	ld   ($C23E), a				; ld   (PSGMOD_VIBPOS + \2), a
	inc  l
	ld   a, l
	ld   ($C221), a				; ld   (PSGMOD_INSTR_PTR + \1), a
	jp   PSGMOD_Play_Ch2_Done	; jp   PSGMOD_Play_Ch2_Done					; _LABEL_662_55

PSGMOD_Play_NoNote2:
;_LABEL_63F_56:
	rrc  b
	jp   nc, PSGMOD_Play_NoNote2_Wait; jp   NC, PSGMOD_Play_NoNote2_Wait	; _LABEL_65D_57

	ld   hl, ($C20C)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   a, (hl)
	inc  hl
	ld   ($C20C), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	rrc  b
	jp   c, _LABEL_657_58		; jp   C, +									; _LABEL_657_58
	ld   ($C242), a				; ld (PSGMOD_PULSE_VIBRATO + \1), a
	jp   _LABEL_65A_59			; jp   ++									; _LABEL_65A_59

;+:
_LABEL_657_58:
	ld   ($C238), a				; ld (PSGMOD_VOLUME + \1), a

;++:
_LABEL_65A_59:
	jp   PSGMOD_Play_ExecLine2	; jp   PSGMOD_Play_ExecLine2				; _LABEL_5EE_60

PSGMOD_Play_NoNote2_Wait:
;_LABEL_65D_57:
	ld   a, b
	inc  a
	ld   ($C212), a				; ld   (PSGMOD_SEQ_WAIT+\1), a

PSGMOD_Play_Ch2_Done:
;_LABEL_662_55:

;_PSGMOD_PLAY_CHANNEL 3, 6
	ld   hl, $C213				; ld   hl, PSGMOD_SEQ_WAIT+\1
	dec  (hl)
	jp   nz, PSGMOD_Play_Ch3_Done	; jp   NZ, PSGMOD_Play_Ch3_Done			; _LABEL_719_61

PSGMOD_Play_ExecLine3:
;_LABEL_669_73:
	ld   hl, ($C20E)			; ld   hl, (PSGMOD_SEQ_PTR + \2)
	ld   b, (hl)
	inc  hl
	ld   ($C20E), hl			; ld   (PSGMOD_SEQ_PTR + \2), hl
	ld   a, b
	and  $E0
	jr   z, PSGMOD_Play_NoNote3	; jr   Z, PSGMOD_Play_NoNote3				; _LABEL_6B6_62
	rlca
	rlca
	rlca
	ld   ($C213), a				; ld   (PSGMOD_SEQ_WAIT + \1), a
	ld   hl, ($C249)			; ld   hl, (PSGMOD_NOTES_PTR + \2)
	ld   a, b
	and  $1F
	add  a, a
	ld   e, a
	ld   d, $00
	add  hl, de
	ld   b, (hl)
	inc  hl
	ld   e, (hl)
	ld   a, ($C24E)				; ld   a, (PSGMOD_SFX_3_PRIORITY)
	and  a
	ld   a, e
	ld   ($C235), a				; ld   (PSGMOD_FREQUENCY + \2), a
	jr   NZ, _LABEL_696_63		; jr   nz, +								; _LABEL_696_63
	out  ($7F), a				; out  (PSGMOD_PSG_PORT), a

;+:
_LABEL_696_63:
	ld   a, b
	and  $0F
	ld   ($C239), a				; ld   (PSGMOD_VOLUME+\1), a
	ld   a, b
	and  $F0
	ld   h, $C1					; ld   h, PSGMOD_INSTRUMENTS >> 8
	ld   l, a
	ld   a, (hl)
	ld   ($C226), a				; ld   (PSGMOD_PHASE_VOLUME + \1), a
	inc  l
	ld   de, $C22D				; d   de, PSGMOD_PHASE_VOLUME_ADD_0 + \2
	ldi
	ldi
	inc  l
	ld   a, l
	ld   ($C222), a				; ld   (PSGMOD_INSTR_PTR + \1), a
	jp   PSGMOD_Play_Ch3_Done	; jp   _LABEL_719_61						; _LABEL_719_61

PSGMOD_Play_NoNote3:
;_LABEL_6B6_62:
	rrc  b
	jp   nc, PSGMOD_Play_NoNote3_Wait	; jp   NC, _LABEL_714_64			; _LABEL_714_64

	rrc  b
	jp   nc, PSGMOD_Play_Effect3_NoSpeedCommand	; jp   NC, _LABEL_6D4_65	;_LABEL_6D4_65
	ld   hl, ($C20E)			; ld hl, (PSGMOD_SEQ_PTR+\2)
	ld   c, (hl)
	inc  hl
	ld   ($C20E), hl			; ld (PSGMOD_SEQ_PTR+\2), hl
	ld   a, ($C21A)				; ld a, (PSGMOD_SPEED_CNT)
	ld   hl, $C219				; ld hl, PSGMOD_SPEED
	sub  (hl)
	ld   (hl), c
	add  a, c
	ld   ($C21A), a				; ld (PSGMOD_SPEED_CNT), a

PSGMOD_Play_Effect3_NoSpeedCommand:
;_LABEL_6D4_65:
	rrc  b
	rrc  b
	jp   nc, PSGMOD_Play_Effect3_NoSetVolumeEffect	; jp   NC, _LABEL_6E6_66; _LABEL_6E6_66 
	ld   hl, ($C20E)			; ld hl, (PSGMOD_SEQ_PTR+\2)
	ld   a, (hl)
	ld   ($C239), a				; ld (PSGMOD_VOLUME + \1), a
	inc  hl
	ld   ($C20E), hl			; ld (PSGMOD_SEQ_PTR+\2), hl

PSGMOD_Play_Effect3_NoSetVolumeEffect:
;_LABEL_6E6_66:
	rrc  b
	jp   nc, PSGMOD_Play_Effect3_NoExt	; jp   NC, PSGMOD_Play_Effect3_NoExt; _LABEL_711_67
	ld   hl, ($C20E)			; ld  hl, (PSGMOD_SEQ_PTR+\2)
	ld   b, (hl)
	inc  hl
	rrc  b
	jp   nc, _LABEL_6FA_68		; jp  NC, +									; _LABEL_6FA_68
	ld   a, (hl)
	inc  hl
	ld   ($C21B), a				; ld  (PSGMOD_PULSE_VIBRATO_MASK), a

;+:
_LABEL_6FA_68:
	rrc  b
	jp   NC, _LABEL_704_69		; jp   nc, +								; _LABEL_704_69
	ld   a, (hl)
	inc  hl
	call PSGMOD_CallCallback	; call _LABEL_7F2_70						; _LABEL_7F2_70

;+:
_LABEL_704_69:
	rrc  b
	jp   NC, _LABEL_70E_72		; jp   NC, +								; _LABEL_70E_72
	ld   a, (hl)
	inc  hl
	call PSGMOD_CallCallback	; call _LABEL_7F2_70						; _LABEL_7F2_70

;+:
_LABEL_70E_72:
	ld   ($C20E), hl	; ld (PSGMOD_SEQ_PTR + \2), hl

PSGMOD_Play_Effect3_NoExt:
;_LABEL_711_67:
	jp   PSGMOD_Play_ExecLine3	; jp   _LABEL_669_73						; _LABEL_669_73

PSGMOD_Play_NoNote3_Wait:
;_LABEL_714_64:
	ld   a, b
	inc  a
	ld   ($C213), a				; ld   (PSGMOD_SEQ_WAIT+\1), a

PSGMOD_Play_Ch3_Done:
;_LABEL_719_61:
	ld   hl, $C214				; ld   hl, PSGMOD_SEQ_LENGTH_CNT
	dec  (hl)
	jp   nz, PSGMOD_Play_TriggerLine_Cont	; jp   NZ, _LABEL_261_74		; _LABEL_261_74
	ld   hl, ($C206)			; ld   hl, (PSGMOD_LENGTH_CNT)
	dec  hl
	ld   ($C206), hl			; ld   (PSGMOD_LENGTH_CNT), hl
	ld   a, l
	or   h
	jr   z, PSGMOD_Play_Repeat	; jr   Z, _LABEL_73B_75						; _LABEL_73B_75
	ld   hl, ($C202)			;  ld   hl, (PSGMOD_SEQ_LIST_PTR)
	ld   de, 0x0008
	add  hl, de
	ld   ($C202), hl			; ld   (PSGMOD_SEQ_LIST_PTR), hl
	call PSGMOD_StartSequences	; call PSGMOD_StartSequences				; _LABEL_47A_13
	jp   PSGMOD_Play_TriggerLine_Cont	; jp   PSGMOD_Play_TriggerLine_Cont	; _LABEL_261_74
	
PSGMOD_Play_Repeat:
;_LABEL_73B_75:
	ld   hl, ($C204)			; ld   hl, (PSGMOD_LENGTH)
	ld   de, ($C217)			; ld   de, (PSGMOD_REPEAT_POINT)
	and  a
	sbc  hl, de
	ld   ($C206), hl			; ld   (PSGMOD_LENGTH_CNT), hl
	ld   a, $07
	ld   ($C21A), a				; ld   (PSGMOD_SPEED_CNT), a
	ld   hl, ($C217)			; ld   hl, (PSGMOD_REPEAT_POINT)
	add  hl, hl
	add  hl, hl
	add  hl, hl
	ld   de, ($C200)			; ld   de, (PSGMOD_SEQ_LIST_START_PTR)
	add  hl, de
	ld   ($C202), hl			; ld   (PSGMOD_SEQ_LIST_PTR), hl
	call PSGMOD_StartSequences	; call PSGMOD_StartSequences				; _LABEL_47A_13
	jp   PSGMOD_Play_TriggerLine_Cont	; jp   PSGMOD_Play_TriggerLine_Cont	; _LABEL_261_74
	
	
;07:
PSGMOD_PlaySFX_2:
  	ld a, ($C24D)				; ld a, (PSGMOD_SFX_2_PRIORITY)
  	cp c
  	jr Z, PSGMOD_PlaySFX_2_OK
  	ret NC

PSGMOD_PlaySFX_2_OK:
  	ld a, b
  	ld ($C24F), a				; ld (PSGMOD_SFX_2_CNT), a
  	ld a, c
  	ld ($C24D), a				; ld (PSGMOD_SFX_2_PRIORITY), a
  	ld ($C251), hl				; ld (PSGMOD_SFX_2_ADDRESS), hl
  	ret

;----------------------------------------------------------
; PSGMOD_PlaySFX_3(B = length, C = priority, HL = address)
PSGMOD_PlaySFX_3:
  	ld a, ($C24E)				; ld a, (PSGMOD_SFX_3_PRIORITY)
  	cp c
  	jr Z, PSGMOD_PlaySFX_3_OK
  	ret NC

PSGMOD_PlaySFX_3_OK:
  
  	ld a, b
  	ld ($C250), a				; ld (PSGMOD_SFX_3_CNT), a
  	ld a, c
  	ld ($C24E), a				; ld (PSGMOD_SFX_3_PRIORITY), a
  	ld ($C253), hl				; ld (PSGMOD_SFX_3_ADDRESS), hl
  	ret  	

;----------------------------------------------------------
; PSGMOD_PlaySFX_23(B = length, C = priority, HL = address)
PSGMOD_PlaySFX_23:
  	ld a, ($C24E)				; ld a, (PSGMOD_SFX_3_PRIORITY)
  	cp c
  	jr Z, PSGMOD_PlaySFX_23_OK_3
  	ret NC

PSGMOD_PlaySFX_23_OK_3:
  	ld a, ($C24D)				; ld a, (PSGMOD_SFX_2_PRIORITY)
  	cp c
  	jr Z, PSGMOD_PlaySFX_23_OK_2
  	ret NC

PSGMOD_PlaySFX_23_OK_2:
  	ld a, b
  	ld ($C24F), a				; ld (PSGMOD_SFX_2_CNT), a
  	ld ($C250), a				; ld (PSGMOD_SFX_3_CNT), a
  	ld a, c
  	ld ($C24D), a				; ld (PSGMOD_SFX_2_PRIORITY), a
  	ld ($C24E), a				; ld (PSGMOD_SFX_3_PRIORITY), a
  
  	ld ($C251), hl				; ld (PSGMOD_SFX_2_ADDRESS), hl
  	ld c, b
  	ld b, 0
  	add hl, bc
  	add hl, bc
  	add hl, bc
  	ld ($C253), hl				; ld (PSGMOD_SFX_3_ADDRESS), hl
  	ret
  	  	
;------------------
; PSGMOD_StopSFX()
PSGMOD_StopSFX:
  	ld a, ($C24D)				; ld a, (PSGMOD_SFX_2_PRIORITY)
  	or a
  	jr Z, PSGMOD_StopSFX_2
  
  	xor a
  	ld ($C24D), a				; ld (PSGMOD_SFX_2_PRIORITY), a
  
  	ld a, ($C21B)				; ld a, (PSGMOD_PULSE_VIBRATO_MASK)
  	or a
  	ld hl, ($C233)				; ld hl, (PSGMOD_FREQUENCY+4)
  	jr Z, PSGMOD_StopSFX_ResetFreq2_NoVib
  	ld d, 0
  	ld a, ($C242)				; ld a, (PSGMOD_PULSE_VIBRATO + 2)
  	ld e, a
  	add hl, de

PSGMOD_StopSFX_ResetFreq2_NoVib:
  	ld a, l
  	and 15
  	or 128+64
  	out ($7F), a				; out (PSGMOD_PSG_PORT), a
  
  	ld a, l
 	rrca
  	rrca
  	rrca
  	rrca
  	and 15
  	ld b, a
  	ld a, h
  	and 3
  	rrca
  	rrca
  	rrca
  	rrca
  	or b
  	out ($7F), a				; out (PSGMOD_PSG_PORT), a

PSGMOD_StopSFX_2: 
  	ld   a, ($C24E)				; ld   a, (PSGMOD_SFX_3_PRIORITY)
  	or   a
  	ret  Z
  
  	xor  a
  	ld   ($C24E), a				; ld   (PSGMOD_SFX_3_PRIORITY), a
  
  	ld   a, ($C235)				; ld   a, (PSGMOD_FREQUENCY + 6)
  	out ($7F), a				; out (PSGMOD_PSG_PORT), a
  	ret
  	
;--------------------
PSGMOD_CallCallback:
; (A)
  	push hl
  	push bc
  	ld   hl, ($C21D)			; ld   hl, (PSGMOD_CALLBACK_FUNCTION)
  	call PSGMOD_JumpHL
  	pop  bc
  	pop  hl
  	ret
  
PSGMOD_JumpHL:
  	jp   (hl)

;------------------------------
; PSGMOD_SetCallbackFunction()
PSGMOD_SetCallbackFunction:
  	ld   hl, ($C21D)			; ld   hl, (PSGMOD_CALLBACK_FUNCTION)
  	ret  	
