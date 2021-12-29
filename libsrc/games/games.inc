;
;       Game functions parameters
;
;       Written by Stefano Bodrato  1/10/2001
;       based on the Dominic's sound routines
;
;       sndbit_port < 0 = memory based
;       sndbit_port >= 256 = 16 bit io
;       else 8 bit io
;
;       However.... SOUND_INOUT = toggle speaker with in/out (+ace only)
;                   SOUND_IFF = toggle speaker with ei/di cycle (+sol20 only)
;
;       $Id: games.inc $
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

IF FORzxn
        defc sndbit_port   = 254
        defc sndbit_bit    = 4
        defc sndbit_mask   = 16         ; (2^sndbit_bit)
ENDIF

IF FORts2068
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
        defc SOUND_INOUT = 1
        defc sndbit_port   = 254
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1         ; (2^sndbit_bit)
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

IF FORg800
        defc sndbit_port   = $18
        defc sndbit_bit    = 7
        defc sndbit_mask   = 192
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
        defc sndbit_port   = -26624      ; this is a memory address, not a port !
        defc sndbit_bit    = 0
        defc sndbit_mask   = 33         ; bit 0 (Speaker A) and 5 (Speaker B)
ENDIF

IF FORlaser500
        defc sndbit_port   = -$6800 	; this is a memory address, not a port !
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1         ; bit 0 (Speaker A) and 5 (Speaker B)
ENDIF

IF FORgal
        defc sndbit_port   = -8248       ; this is a memory address, not a port !
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

IF FORbondwell
        defc sndbit_port   = $50
        defc sndbit_bit    = 7
        defc sndbit_mask   = $80
ENDIF

IF FORbondwell2
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORpasopia7
    defc sndbit_port	= $30
    defc sndbit_bit    = 7
    defc sndbit_mask   = $80
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

IF FORgl
	defc	sndbit_port = $12
	defc	sndbit_bit = 3
	defc	sndbit_mask = 8
ENDIF

IF FORkrokha
	defc	sndbit_port = -0xf7ff
	defc	sndbit_bit = 1
	defc	sndbit_mask = 2
ENDIF

IF FORlviv
        defc sndbit_port   = $c2
        defc sndbit_bit    = 0
        defc sndbit_mask   = 1
ENDIF


IF FORsol20
    defc sndbit_port   = 0
    defc sndbit_bit    = 0
    defc sndbit_mask   = 0
    defc SOUND_IFF     = 1
ENDIF

; Compatibility ones only, the following ports don't have a beeper
IF FORondra
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF
IF FORsv8000
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORgb
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

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

IF FORtvc
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORpmd85
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF

IF FORvector06c
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF
  
IF FORm100
        defc sndbit_port   = 0
        defc sndbit_bit    = 0
        defc sndbit_mask   = 0
ENDIF


IF FORgl6000
    defc sndbit_port	= 0
    defc sndbit_bit    = 0
    defc sndbit_mask   = 0
ENDIF

IF FORmyvision
    defc sndbit_port	= 0
    defc sndbit_bit    = 0
    defc sndbit_mask   = 0
ENDIF

IF FORhomelab
    defc sndbit_port	= 0
    defc sndbit_bit    = 0
    defc sndbit_mask   = 0
ENDIF

IF FORhomelab2
    defc sndbit_port	= 0
    defc sndbit_bit    = 0
    defc sndbit_mask   = 0
ENDIF

IF FORlm80c
    defc sndbit_port	= 0
    defc sndbit_bit    = 0
    defc sndbit_mask   = 0
ENDIF

IF FORprimo
    defc sndbit_port	= $00 ;
    defc sndbit_bit    = 4
    defc sndbit_mask   = $10		;
ENDIF

IF FORmikro80
    defc sndbit_port	= $4 ;
    defc sndbit_bit    = 1
    defc sndbit_mask   = $2	;
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

IF FORsmc777
    defc sndbit_port   = $53           ; possibly valid also for Sony SMC 70
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F                   ; $0F for full volume output
ENDIF



IF FORcoleco
    defc sndbit_port	= $ff		; also valid for Coleco Adam and Pencil II
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF

IF FORbit90
    defc sndbit_port	= $ff		; also valid for Coleco Adam and Pencil II
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF

IF FORpencil2
    defc sndbit_port	= $ff		; also valid for Coleco Adam and Pencil II
    defc sndbit_bit    = 3
    defc sndbit_mask   = $0F			; $0F for full volume output
ENDIF




; ********************************************************
;   This last part refers to NOT YET supported hardware
; ********************************************************





IF !JOYSTICK_inkey
	defc	JOYSTICK_inkey = 0
ENDIF
