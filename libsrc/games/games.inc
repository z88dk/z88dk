;
;       Game functions parameters
;
;       Written by Stefano Bodrato  1/10/2001
;       based on the Dominic's sound routines
;
;       SOUND_ONEBIT_port < 0 = memory based
;       SOUND_ONEBIT_port >= 256 = 16 bit io
;       else 8 bit io
;
;       However.... SOUND_INOUT = toggle speaker with in/out (+ace only)
;                   SOUND_IFF = toggle speaker with ei/di cycle (+sol20 only)
;
;       $Id: games.inc $
;

IF FORc128
        defc SOUND_ONEBIT_port   = 54296	; $D418: addres is a word: uses a special lib version
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = 15
ENDIF

IF FORzx
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
ENDIF

IF FORzxn
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
ENDIF

IF FORts2068
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
ENDIF

IF FORmsx
        defc SOUND_ONEBIT_port   = 170
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 158        ; bit 7 (key click) and 5 (tape)
ENDIF

IF FORmc1000
        defc SOUND_ONEBIT_port   = 96            ; $60 = YM amplitude register
        defc SOUND_ONEBIT_bit    = 3            ; More significant bit
        defc SOUND_ONEBIT_mask   = 15
ENDIF

IF FORsvi
        defc SOUND_ONEBIT_port   = 150
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 158        ; bit 7 (key click) and 5 (tape)
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORsam
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
ENDIF

IF FORz88
        defc SOUND_ONEBIT_port   = $B0
        defc SOUND_ONEBIT_bit    = 6
        defc SOUND_ONEBIT_mask   = 64
ENDIF

IF FORace
        defc SOUND_INOUT = 1
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1         ; (2^SOUND_ONEBIT_bit)
ENDIF

IF FORaquarius
        defc SOUND_ONEBIT_port   = 252
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORalphatro
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORenterprise
        defc SOUND_ONEBIT_port   = $A8
        defc SOUND_ONEBIT_bit    = 5
        defc SOUND_ONEBIT_mask   = 32
ENDIF

IF FORg800
        defc SOUND_ONEBIT_port   = $18
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 192
ENDIF

IF FORp2000
        defc SOUND_ONEBIT_port   = 80
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
ENDIF

IF FORpc88
        defc SOUND_ONEBIT_port   = $40
        defc SOUND_ONEBIT_bit    = 7		; bit 5 could be chosen for earlier models (worse quality)
        defc SOUND_ONEBIT_mask   = 128	; as above
ENDIF

IF FORti82
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @00111100
ENDIF

IF FORti83
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 3
ENDIF

; Confusing name
IF FORti8x
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 3
ENDIF

IF FORti85
        defc SOUND_ONEBIT_port   = 7
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @00111100
ENDIF


IF FORti86
        defc SOUND_ONEBIT_port   = 7
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @00111100
ENDIF

IF FORtrs80
        defc SOUND_ONEBIT_port   = 255
        defc SOUND_ONEBIT_bit    = 1
        defc SOUND_ONEBIT_mask   = 3
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORvg5k
        defc SOUND_ONEBIT_port   = 175
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = 8
ENDIF

IF FORvz
        defc SOUND_ONEBIT_port   = -26624      ; this is a memory address, not a port !
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 33         ; bit 0 (Speaker A) and 5 (Speaker B)
ENDIF

IF FORlaser500
        defc SOUND_ONEBIT_port   = -$6800 	; this is a memory address, not a port !
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1         ; bit 0 (Speaker A) and 5 (Speaker B)
ENDIF

IF FORgal
        defc SOUND_ONEBIT_port   = -8248       ; this is a memory address, not a port !
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @01000100
        ;defc SOUND_ONEBIT_mask   = 4
ENDIF

IF FORzx81
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
ENDIF

IF FORlambda
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
ENDIF

IF FORzx80
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
ENDIF

IF FORz9001
        defc SOUND_ONEBIT_port   = 136
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 128
ENDIF

IF FORbee
        defc SOUND_ONEBIT_port   = 2
        defc SOUND_ONEBIT_bit    = 6
        defc SOUND_ONEBIT_mask   = 64
ENDIF

IF FORaussie
        defc SOUND_ONEBIT_port   = 32
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 128	; bit 6 should stay 'on'
ENDIF

IF FORbondwell
        defc SOUND_ONEBIT_port   = $50
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = $80
ENDIF


IF FORpasopia7
    defc SOUND_ONEBIT_port	= $30
    defc SOUND_ONEBIT_bit    = 7
    defc SOUND_ONEBIT_mask   = $80
ENDIF

IF FORsuper80
	defc	SOUND_ONEBIT_port = $F0
	defc	SOUND_ONEBIT_bit = 3
	defc	SOUND_ONEBIT_mask = 8
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORz80tvgame
	defc	SOUND_ONEBIT_port = $02
	defc	SOUND_ONEBIT_bit = 0
	defc	SOUND_ONEBIT_mask = 1
ENDIF

IF FORgl
	defc	SOUND_ONEBIT_port = $12
	defc	SOUND_ONEBIT_bit = 3
	defc	SOUND_ONEBIT_mask = 8
ENDIF

IF FORkrokha
	defc	SOUND_ONEBIT_port = -0xf7ff
	defc	SOUND_ONEBIT_bit = 1
	defc	SOUND_ONEBIT_mask = 2
ENDIF

IF FORlviv
        defc SOUND_ONEBIT_port   = $c2
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
ENDIF


IF FORsol20
    defc SOUND_IFF     = 1
ENDIF


IF FORlynx
	defc INPUT_JOY_useinkey = 1
ENDIF


IF FORsrr
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORspc1000
	defc INPUT_JOY_useinkey = 1
ENDIF


IF FORgl6000
    defc INPUT_JOY_useinkey = 1
ENDIF


IF FORprimo
    defc SOUND_ONEBIT_port	= $00 ;
    defc SOUND_ONEBIT_bit    = 4
    defc SOUND_ONEBIT_mask   = $10		;
ENDIF

IF FORmikro80
    defc SOUND_ONEBIT_port	= $4 ;
    defc SOUND_ONEBIT_bit    = 1
    defc SOUND_ONEBIT_mask   = $2	;
ENDIF

IF FORtvc
    defc SOUND_ONEBIT_port      = $06           ; PORT 6 sets volume
    defc SOUND_ONEBIT_mask      = @00111100     ; 4 bit wide volume: 0 or 1 -> 0000 or 1111
    defc SOUND_ONEBIT_bit       = 5             ; bit 5 is just fine to test (could be bit 2-5)
ENDIF


; ********************************************************
;  SN76489 PSG chip definitions
; ********************************************************

IF FORmz
	defc SOUND_ONEBIT_port	= $F2
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
ENDIF

IF FORsc3000
	defc SOUND_ONEBIT_port	= $7F		; also valid for SG-1000
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORm5
	defc SOUND_ONEBIT_port	= $20
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORmtx
	defc SOUND_ONEBIT_port	= $06
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
ENDIF

IF FORsms
	defc SOUND_ONEBIT_port	= $40
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
ENDIF

IF FORpv2000
    defc SOUND_ONEBIT_port	= $40		
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
ENDIF


IF FORrx78
	defc SOUND_ONEBIT_port	= $FF
	defc SOUND_ONEBIT_bit    = 3
	defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORsmc777
    defc SOUND_ONEBIT_port   = $53           ; possibly valid also for Sony SMC 70
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F                   ; $0F for full volume output
ENDIF



IF FORcoleco
    defc SOUND_ONEBIT_port	= $ff		; also valid for Coleco Adam and Pencil II
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
ENDIF

IF FORbit90
    defc SOUND_ONEBIT_port	= $ff		; also valid for Coleco Adam and Pencil II
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
ENDIF

IF FORpencil2
    defc SOUND_ONEBIT_port	= $ff		; also valid for Coleco Adam and Pencil II
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F			; $0F for full volume output
    defc INPUT_JOY_useinkey = 1
ENDIF

IFNDEF SOUND_ONEBIT_port
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 0
ENDIF

MACRO ONEBITOUT
LOCAL l1, l2, l3, l4
IF SOUND_INOUT = 1
    ld      c,a
    and     SOUND_ONEBIT_mask
    jr      nz,l1
    in      a,(SOUND_ONEBIT_port) 
    jr      l2
l1: out     (SOUND_ONEBIT_port),a 
l2: ld      a,c
ELIF SOUND_IFF = 1
    ld      c,a
    and     SOUND_ONEBIT_mask
    jp      nz,l3
    di 
l3: jp      l4
    ei
l4: ld      a,c
ELIF SOUND_ONEBIT_port >= 256
    exx
    out     (c),a
    exx
ELIF SOUND_ONEBIT_port < 0
    ld      (-SOUND_ONEBIT_port),a
ELSE
    out     (SOUND_ONEBIT_port),a 
ENDIF
ENDM


MACRO ONEBITOUT2
LOCAL l1, l2, l3, l4
IF SOUND_INOUT = 1
    ld      c,a
    and     SOUND_ONEBIT_mask
    jr      nz,l1
    in      a,(SOUND_ONEBIT_port) 
    jr      l2
l1: out     (SOUND_ONEBIT_port),a 
l2: ld      a,c
ELIF SOUND_IFF = 1
    ld      c,a
    and     SOUND_ONEBIT_mask
    jp      nz,l3
    di 
l3: jp      l4
    ei
l4: ld      a,c
ELIF SOUND_ONEBIT_port >= 256
    out     (c),a
ELIF SOUND_ONEBIT_port < 0
    ld      (-SOUND_ONEBIT_port),a
ELSE
    out     (SOUND_ONEBIT_port),a 
ENDIF
ENDM



; ********************************************************
;   This last part refers to NOT YET supported hardware
; ********************************************************





IF !INPUT_JOY_useinkey
	defc	INPUT_JOY_useinkey = 0
ENDIF
