;
;       Game functions parameters
;
;       Written by Stefano Bodrato  1/10/2001
;       based on the Dominic's sound routines
;
;
;       $Id: games.inc,v 1.31 2016-11-15 11:42:34 stefano Exp $
;

IF FORc128
        defc sndbit_port   = 54296	; $D418: addres is a word: uses a special lib version
        defc sndbit_bit    = 3
        defc sndbit_mask   = 15
ENDIF

IF FORzx
        defc sndbit_port   = 254
        defc sndbit_bit    = 4
        defc sndbit_mask   = 16         ; (2^sndbit_bit)
ENDIF

IF FORmsx
        defc sndbit_port   = 170
        defc sndbit_bit    = 7
        defc sndbit_mask   = 158        ; bit 7 (key click) and 5 (tape)
ENDIF

IF FORmc1000
        defc sndbit_port   = 96            ; $60 = YM amplitude register
        defc sndbit_bit    = 3            ; More significant bit
        defc sndbit_mask   = 15
ENDIF

IF FORsvi
        defc sndbit_port   = 150
        defc sndbit_bit    = 7
        defc sndbit_mask   = 158        ; bit 7 (key click) and 5 (tape)
	defc JOYSTICK_inkey = 1
ENDIF

IF FORsam
        defc sndbit_port   = 254
        defc sndbit_bit    = 4
        defc sndbit_mask   = 16         ; (2^sndbit_bit)
ENDIF

IF FORz88
        defc sndbit_port   = $B0
        defc sndbit_bit    = 6
        defc sndbit_mask   = 64
ENDIF

IF FORace
        defc sndbit_port   = 254
        defc sndbit_bit    = 3
        defc sndbit_mask   = 8         ; (2^sndbit_bit)
ENDIF

IF FORaquarius
        defc sndbit_port   = 252
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1
	defc JOYSTICK_inkey = 1
ENDIF

IF FORalphatro
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
	defc JOYSTICK_inkey = 1
ENDIF

IF FORenterprise
        defc sndbit_port   = $A8
        defc sndbit_bit    = 5
        defc sndbit_mask   = 32
ENDIF

IF FORp2000
        defc sndbit_port   = 80
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1
ENDIF

IF FORpc88
        defc sndbit_port   = $40
        defc sndbit_bit    = 7		; bit 5 could be chosen for earlier models (worse quality)
        defc sndbit_mask   = 128	; as above
ENDIF

IF FORti82
        defc sndbit_port   = 0
        defc sndbit_bit    = 2
        defc sndbit_mask   = @00111100
ENDIF

IF FORti83
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 3
ENDIF

; Confusing name
IF FORti8x
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 3
ENDIF

IF FORti85
        defc sndbit_port   = 7
        defc sndbit_bit    = 2
        defc sndbit_mask   = @00111100
ENDIF


IF FORti86
        defc sndbit_port   = 7
        defc sndbit_bit    = 2
        defc sndbit_mask   = @00111100
ENDIF

IF FORtrs80
        defc sndbit_port   = 255
        defc sndbit_bit    = 1
        defc sndbit_mask   = 3
	defc JOYSTICK_inkey = 1
ENDIF

IF FORvg5k
        defc sndbit_port   = 175
        defc sndbit_bit    = 3
        defc sndbit_mask   = 8
ENDIF

IF FORvz
        defc sndbit_port   = 26624      ; this is a memory address, not a port !
        defc sndbit_bit    = 0
        defc sndbit_mask   = 33         ; bit 0 (Speaker A) and 5 (Speaker B)
ENDIF

IF FORlaser500
        defc sndbit_port   = $6800 	; this is a memory address, not a port !
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1         ; bit 0 (Speaker A) and 5 (Speaker B)
ENDIF

IF FORgal
        defc sndbit_port   = 8248       ; this is a memory address, not a port !
        defc sndbit_bit    = 2
        defc sndbit_mask   = @01000100
        ;defc sndbit_mask   = 4
ENDIF

IF FORzx81
        defc sndbit_port   = 254
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1
ENDIF

IF FORlambda
        defc sndbit_port   = 254
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1
ENDIF

IF FORzx80
        defc sndbit_port   = 254
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1
ENDIF

IF FORz9001
        defc sndbit_port   = 136
        defc sndbit_bit    = 7
        defc sndbit_mask   = 128
ENDIF

IF FORbee
        defc sndbit_port   = 2
        defc sndbit_bit    = 6
        defc sndbit_mask   = 64
ENDIF

IF FORaussie
        defc sndbit_port   = 32
        defc sndbit_bit    = 7
        defc sndbit_mask   = 128	; bit 6 should stay 'on'
ENDIF

IF FORsuper80
	defc	sndbit_port = $F0
	defc	sndbit_bit = 3
	defc	sndbit_mask = 8
	defc JOYSTICK_inkey = 1
ENDIF

IF FORz80tvgame
	defc	sndbit_port = $02
	defc	sndbit_bit = 0
	defc	sndbit_mask = 1
ENDIF

; Compatibily ones only, the following ports don't have a beeper
IF FOReinstein
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORoz
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORpps
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORpv1000
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORlynx
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORosca
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORsrr
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
	defc JOYSTICK_inkey = 1
ENDIF

IF FORspc1000
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
	defc JOYSTICK_inkey = 1
ENDIF

IF FORpc6001
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

; ********************************************************
;  SN76489 PSG chip definitions
; ********************************************************

IF FORmz
	defc sndbit_port	= $F2
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF

IF FORsc3000
	defc sndbit_port	= $7F		; also valid for SG-1000
        defc sndbit_bit    = 3
        defc sndbit_mask   = $0F			; $0F for full volume output
	defc JOYSTICK_inkey = 1
ENDIF

IF FORm5
	defc sndbit_port	= $20
        defc sndbit_bit    = 3
        defc sndbit_mask   = $0F			; $0F for full volume output
	defc JOYSTICK_inkey = 1
ENDIF

IF FORmtx
	defc sndbit_port	= $06
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF

IF FORsms
	defc sndbit_port	= $40
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF

IF FORpv2000
    defc sndbit_port	= $40		
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF


IF FORrx78
	defc sndbit_port	= $FF
	defc sndbit_bit    = 3
	defc sndbit_mask   = $0F			; $0F for full volume output
	defc JOYSTICK_inkey = 1
ENDIF

; ********************************************************
;   This last part refers to NOT YET supported hardware
; ********************************************************

IF FORcoleco
	defc sndbit_port	= $E0		; also valid for Coleco Adam and Pencil II
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF

IF FORpasopia
	defc sndbit_port	= $3A		; Pasopia has also a second PSG on port $3B
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF


IF FORsmc777
	defc sndbit_port	= $53		; possibly valid also for Sony SMC 70
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF


IF !JOYSTICK_inkey
	defc	JOYSTICK_inkey = 0
ENDIF
