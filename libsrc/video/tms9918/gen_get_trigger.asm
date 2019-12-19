;
;	z88dk library: Generic I/O support code for MSX family machines
;
;
;	extern bool __FASTCALL__ msx_get_trigger(unsigned char id);
;
;	get state of joystick button (trigger) number \a id, true = pressed
;
;	$Id: gen_get_trigger.asm $
;

        SECTION code_clib
	PUBLIC	msx_get_trigger
	PUBLIC	_msx_get_trigger

msx_get_trigger:
_msx_get_trigger:

IF (FORmsx | FORsvi)

	EXTERN  set_psg_callee
	EXTERN  get_psg

IF FORmsx
	;;INCLUDE "target/msx/def/msx.def"
	defc PPI_B    = $A9
	defc PPI_C    = $AA
	defc PSG_ADDR    = $A0
	defc PSG_DATA    = $A1
	defc PSG_DATAIN  = $A2
ELSE
	;;INCLUDE "target/svi/def/svi.def"
	defc PPI_A    = $98
	defc PPI_B    = $99
	defc PPI_C    = $9A
	defc PSG_ADDR    = $88
	defc PSG_DATA    = $8C
	defc PSG_DATAIN  = $90
ENDIF

                ld      a,l		; __FASTCALL__ parameter passing
                or      a
                jr      nz,joy_trig
gttrig_space:
; Keyboard (spacebar)
                di
                in      a,(PPI_C)		; GIO_REGS
                and     $F0
                or      8				; kbd row 8
                out     (PPI_C),a		; GIO_REGS
                in      a,(PPI_B)		; KBD_STAT
                ei
                                        ; bit0 = 0 -> space pressed
				and		1
				jr		result
				

; Joystick triggers
joy_trig:
	dec	a
	ld	e,a
	di

;;  Exclude Joystick selection on Spectravideo,
;;  reg #15 has other uses and would crash everything.

IF FORmsx
	ld      a,15		; set PSG register #15
	out     (PSG_ADDR),a
	in      a,(PSG_DATAIN)		; read value

	dec	e		; Joystick number
	jr	z,joystick_2

	and @11011111
	or  @01001100
	jr	joystick_1

.joystick_2
	and @10101111
	or  @00000011

.joystick_1
	; we still have PSG register #15 set
	out     (PSG_DATA),a

	ld      a,14		; set PSG register #14
	out     (PSG_ADDR),a
	in      a,(PSG_DATAIN)		; read value
ENDIF

IF FORsvi
	in      a,(PPI_A)
	dec	e		; Joystick number
	jr	z,joystick_1
	rra
.joystick_1
ENDIF

	and	$10		; Stick Trigger
	ei

result:
				ld		hl,0
                ret		nz
				dec		hl
				ret

ELSE

IF FORm5
	in a,($30)	; keyboard row scan
	ld hl,0
	and $40	; mask the SPACE key
	ret z
	dec hl
	ret
ELSE

	ld	hl,0
	ret

ENDIF

ENDIF



