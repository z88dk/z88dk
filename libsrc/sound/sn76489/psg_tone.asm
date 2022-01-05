	SECTION code_clib
	
IF !__CPU_INTEL__ & !__CPU_RABBIT__ & !__CPU_GBZ80__
	PUBLIC	set_sound_freq
	PUBLIC	_set_sound_freq
	PUBLIC	psg_tone
	PUBLIC	_psg_tone
	
;	$Id: psg_tone.asm $

;==============================================================
; void set_sound_freq(int channel, int freq)
;==============================================================
; Sets the sound frequency for a given channel
;==============================================================

	INCLUDE	"sn76489.inc"

.set_sound_freq
._set_sound_freq
.psg_tone
._psg_tone

	ld	hl, 2
	add	hl, sp
	ld	e, (hl)		; DE = Frequency
	inc	hl
	ld	d, (hl)
	inc 	hl
	ld	c, (hl)		; C = Channel

	ld	a, e
	and	a, $0F
	ld	b, a		; 4 LSB of the freq
	
	ld	a, c
	rrc	a
	rrc	a
	rrc	a
	and	a, $60		; Puts the channel number in bits 5 and 6	
	
	or	a, $80
	or	a, b		; Prepares the first byte of the command
IF HAVE16bitbus
    ld      bc,psgport
    out     (c),a
ELSE
    out	(psgport), a	; Sends it
  IF PSGLatchPort
    in a,(PSGLatchPort)
  ENDIF
ENDIF
	
	ld	a, e
	srl	a
	srl	a
	srl	a
	srl	a
	and	a, $0F
	ld	b, a		; Bits 4..7 of the frequency go to bytes 0..3 of the register
	
	ld	a, d
	sla	a
	sla	a
	sla	a
	sla	a
	and	a, $30		; Bits 8, 9 of the frequency go to bytes 4,5 of the register
	
	or	a, b		; Puts them together
IF HAVE16bitbus
    ld      bc,psgport
    out     (c),a
ELSE
    out	(psgport), a	; Sends the second byte of the command
  IF PSGLatchPort
    in a,(PSGLatchPort)
  ENDIF
ENDIF

	ret
ENDIF
