	SECTION code_clib
	
IF !__CPU_INTEL__ & !__CPU_RABBIT__ & !__CPU_GBZ80__
	PUBLIC	psg_envelope
	PUBLIC	_psg_envelope
	PUBLIC	___psg_envelope

; 
	
;	$Id: psg_envelope.asm $

;========================================================================================
; void psg_envelope(unsigned int waveform, int period, unsigned int channel) __smallc;
;========================================================================================
;  foo entry, envelope is not avaliable on SN76489
;==============================================================

	INCLUDE	"sn76489.inc"

.psg_envelope
._psg_envelope
.___psg_envelope

	ld	hl, 2
	add	hl, sp
	ld	c, (hl)		; C = Channel

	ld	a, $0F		; max attenuation,
	ld	b, a		; ..only the 4 lower bits are significant
	
	ld	a, c
	rrc	a
	rrc	a
	rrc	a
	and	a, $60		; Puts the channel number in bits 5 and 6	
	
	or	a, $90
	or	a, b		; Prepares the first byte of the command
IF HAVE16bitbus
	ld	bc,psgport
	out	(c),a
ELSE
	out	(psgport), a	; Sends it
  IF PSGLatchPort
    in a,(PSGLatchPort)
  ENDIF
ENDIF

	ret
ENDIF
