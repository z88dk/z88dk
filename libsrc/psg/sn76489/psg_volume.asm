	SECTION code_clib
	
IF !__CPU_INTEL__ & !__CPU_RABBIT__ & !__CPU_GBZ80__
	PUBLIC	set_sound_volume
	PUBLIC	_set_sound_volume
	PUBLIC	___set_sound_volume
	PUBLIC	psg_volume
	PUBLIC	_psg_volume
	PUBLIC	___psg_volume
	
;	$Id: psg_volume.asm $

;==============================================================
; void set_sound_volume(int channel, int volume)
;==============================================================
; Sets the sound volume for a given channel
;==============================================================

	INCLUDE	"sn76489.inc"

.set_sound_volume
._set_sound_volume
.___set_sound_volume
.psg_volume
._psg_volume
.___psg_volume

	ld	hl, 2
	add	hl, sp
	ld	e, (hl)		; E = Volume
	inc	hl
	inc 	hl
	ld	c, (hl)		; C = Channel

	ld	a, e
	cpl			; The volume is actually an atenuation
	and	a, $0F
	ld	b, a		; Only the 4 lower bits are significant
	
	ld	a, c
	rrc	a
	rrc	a
	rrc	a
	and	a, $60		; Puts the channel number in bits 5 and 6	
	
	or	a, $90
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

	ret
ENDIF
