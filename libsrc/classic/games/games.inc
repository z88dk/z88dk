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
;                   SOUND_IN = toggle speaker when reading on a given address (Apple II only, Z80 reads from memory)
;                   SOUND_OUTOUT = toggle speaker accessing to 2 different port addresses (x820ii only)
;                   SOUND_OUTIN = toggle speaker accessing with in/out to 2 different port addresses (ZX81 family)
;                   SOUND_IFF = toggle speaker with ei/di cycle (+sol20 only)
;
;       $Id: games.inc $
;



IF FORapple2
        defc SOUND_IN = 1
        defc SOUND_ONEBIT_port   = -$E030
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc TAPEIN_ONEBIT_port  = -$E060
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
        defc TAPE_SPEED_2MHZ   = 1
        ;----
ENDIF

IF FORc128
        defc SOUND_ONEBIT_port   = 54296	; $D418: addres is a word: uses a special lib version
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = 15
        ;----
        defc TAPEIN_ONEBIT_port  = $DC0D
        defc TAPEIN_ONEBIT_mask  = 16
        ;----
        defc TAPE_SPEED_2MHZ   = 1
        ;----
ENDIF

IF FORzx
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 64
        ;----
ENDIF

IF FORzxn
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 64
        ;----
ENDIF

IF FORts2068
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 64
        ;----
ENDIF

IF FORmsx
        defc SOUND_ONEBIT_port   = 170
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 158        ; bit 7 (key click) and 5 (tape)
        ;----
        defc TAPEIN_ONEBIT_port  = $A2
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
ENDIF

IF FORsvi
        defc SOUND_ONEBIT_port   = 150
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 158        ; bit 7 (key click) and 5 (tape)
        ;----
        defc TAPEIN_ONEBIT_port  = $90
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORmc1000
        defc SOUND_ONEBIT_port   = 96            ; $60 = YM amplitude register
        defc SOUND_ONEBIT_bit    = 3            ; More significant bit
        defc SOUND_ONEBIT_mask   = 15
        ;----
        defc TAPEIN_ONEBIT_port  = $40
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
ENDIF

IF FORsam
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = 16         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 64
        ;----
        defc TAPE_SPEED_6MHZ   = 1
        ;----
ENDIF

IF FORz88
        defc SOUND_ONEBIT_port   = $B0
        defc SOUND_ONEBIT_bit    = 6
        defc SOUND_ONEBIT_mask   = 64
        ;----
        defc PLAY_MSXDATA_HI     = $2922    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO     = $544B    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR    = 13       ; 1200 baud, leading tone cycle count
ENDIF

IF FORace
        defc SOUND_INOUT = 1
        defc SOUND_ONEBIT_port   = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc PLAY_MSXDATA_HI     = $2922    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO     = $544B    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR    = 13       ; 1200 baud, leading tone cycle count
ENDIF

IF FORaquarius
        defc SOUND_ONEBIT_port   = 252
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
        ;----
        defc TAPEIN_ONEBIT_port  = $FC
        defc TAPEIN_ONEBIT_mask  = 1
        ;----
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORalphatro
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORenterprise
        defc SOUND_ONEBIT_port   = $A8
        defc SOUND_ONEBIT_bit    = 5
        defc SOUND_ONEBIT_mask   = 32
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
ENDIF

IF FORg815
        defc SOUND_ONEBIT_port   = $18
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 192
ENDIF

IF FORe200
        defc SOUND_ONEBIT_port   = $18
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 192
ENDIF

IF FORg850
        defc SOUND_ONEBIT_port   = $18
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 192
ENDIF

IF FORp2000
        defc SOUND_ONEBIT_port   = 80
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
        ;----
        defc TAPE_SPEED_2_5MHZ   = 1
        ;----
ENDIF

IF FORpc88
        defc SOUND_ONEBIT_port   = $40
        defc SOUND_ONEBIT_bit    = 7        ; bit 5 could be chosen for earlier models (worse quality)
        defc SOUND_ONEBIT_mask   = 128	; as above
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
ENDIF

IF FORmbc200
        defc SOUND_ONEBIT_port   = $E9
        defc SOUND_ONEBIT_bit    = 1
        defc SOUND_ONEBIT_mask   = 2
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
ENDIF

IF FORti82
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @00111100
        ;----
        defc TAPE_SPEED_6MHZ   = 1
        ;----
ENDIF

IF FORti83
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 3
        ;----
        defc TAPE_SPEED_6MHZ   = 1
        ;----
ENDIF

IF FORti83p
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 3
        ;----
        defc TAPE_SPEED_6MHZ   = 1
        ;----
ENDIF

IF FORti85
        defc SOUND_ONEBIT_port   = 7
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @00111100
        ;----
        defc TAPE_SPEED_6MHZ   = 1
        ;----
ENDIF

IF FORti86
        defc SOUND_ONEBIT_port   = 7
        defc SOUND_ONEBIT_bit    = 2
        defc SOUND_ONEBIT_mask   = @00111100
        ;----
        defc TAPE_SPEED_6MHZ   = 1
        ;----
ENDIF

IF FORtrs80
        defc SOUND_ONEBIT_port   = 255
        defc SOUND_ONEBIT_bit    = 1
        defc SOUND_ONEBIT_mask   = 3
        ;----
        defc TAPEIN_ONEBIT_port  = $FF
        defc TAPEIN_ONEBIT_mask  = 128
        ;----

        defc TAPE_SPEED_2MHZ   = 1

        ; 1.774 Mhz - TRS 80 Model I
        ; defc PLAY_DATA_LEAD    = 83    ;  Timing for the leading tone
        ; defc PLAY_DATA_SYNC1   = 23    ;  Sync bit / Tuned delay for switching to the next byte
        ; defc PLAY_DATA_BIAS    = 2     ;  Fine tuning the parameters
        ; defc PLAY_DATA_SYNC2   = 27    ;
        ; defc PLAY_DATA_BIT0    = 31    ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        ; defc LDR_DATA_TIMING   = 11
        ; defc PLAY_MSXDATA_HI     = $1611   ; 1200 baud, High tone period
        ; defc PLAY_MSXDATA_LO     = $2D29   ; 1200 baud, Low tone period
        ; defc PLAY_MSXDATA_HDR    = 7       ; 1200 baud, leading tone cycle count

        ;  2.03 Mhz - EACA EG2000
        ;   2.2 Mhz - TRS 80 Model III
        ;     4 Mhz - Model II, Model IV or modified Model III

        ;----
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORvg5k
        defc SOUND_ONEBIT_port   = 175
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = 8
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
ENDIF

IF FORvz
        defc SOUND_ONEBIT_port   = -26624      ; this is a memory address, not a port !
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 33         ; bit 0 (Speaker A) and 5 (Speaker B)
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
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
        ;----
        defc PLAY_DATA_LEAD    = 143   ;  Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 39    ;  Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 4     ;  Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 47    ;
        defc PLAY_DATA_BIT0    = 53    ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 19
        defc PLAY_MSXDATA_HI    = $2620    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO    = $4E47    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR   = 13       ; 1200 baud, leading tone cycle count
        ;----
ENDIF

; Mostly used also for the Lambda clones
IF FORzx81
        defc SOUND_OUTIN = 1
        defc SOUND_ONEBIT_port   = 255
        defc SOUND_ZEROBIT_port  = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
ENDIF

IF FORlambda
        defc SOUND_OUTIN = 1
        defc SOUND_ONEBIT_port   = 255
        defc SOUND_ZEROBIT_port  = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
ENDIF

IF FORzx80
        defc SOUND_OUTIN = 1
        defc SOUND_ONEBIT_port   = 255
        defc SOUND_ZEROBIT_port  = 254
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
        ;----
        defc TAPEIN_ONEBIT_port  = $FE
        defc TAPEIN_ONEBIT_mask  = 128
        ;----
ENDIF

IF FORz9001
        defc SOUND_ONEBIT_port   = 136
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 128
        ;----
        defc TAPE_SPEED_2_5MHZ   = 1
        ;----
ENDIF

IF FORbee
        defc SOUND_ONEBIT_port   = 2
        defc SOUND_ONEBIT_bit    = 6
        defc SOUND_ONEBIT_mask   = 64
        ;----
        defc TAPE_SPEED_2MHZ   = 1
        ;----
ENDIF

IF FORaussie
        defc SOUND_ONEBIT_port   = 32
        defc SOUND_ONEBIT_bit    = 7
        defc SOUND_ONEBIT_mask   = 128	; bit 6 should stay 'on'
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
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
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
ENDIF

IF FORsuper80
        defc SOUND_ONEBIT_port = $F0
        defc SOUND_ONEBIT_bit = 3
        defc SOUND_ONEBIT_mask = 8
        ;----
        defc TAPEIN_ONEBIT_port  = $f2
        defc TAPEIN_ONEBIT_mask  = 1
        ;----
        defc TAPE_SPEED_2MHZ   = 1
        ;----
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORz80tvgame
        defc SOUND_ONEBIT_port = $02
        defc SOUND_ONEBIT_bit = 0
        defc SOUND_ONEBIT_mask = 1
ENDIF

IF FORgl
        defc SOUND_ONEBIT_port = $12
        defc SOUND_ONEBIT_bit = 3
        defc SOUND_ONEBIT_mask = 8
ENDIF

IF FORkrokha
        defc SOUND_ONEBIT_port = -0xf7ff
        defc SOUND_ONEBIT_bit = 1
        defc SOUND_ONEBIT_mask = 2
ENDIF

IF FORlviv
        defc SOUND_ONEBIT_port   = $c2
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
ENDIF

IF FORlynx
        defc SOUND_ONEBIT_port   = $84
        defc SOUND_ONEBIT_bit    = 5
        defc SOUND_ONEBIT_mask   = 32
        defc TAPEIN_ONEBIT_port  = $80	; The original ROM uses a 16 bit port addressing (BC)
        defc TAPEIN_ONEBIT_mask  = 4
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORmz
;   PSG on the MZ-800
	defc SOUND_ONEBIT_port	= $F2
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
;    defc SOUND_ONEBIT_port   = -0xe007
;    defc SOUND_ONEBIT_bit    = 3
;    defc SOUND_ONEBIT_mask   = $28        	; $0F for full volume output
ENDIF

IF FORsol20
    defc SOUND_IFF     = 1
ENDIF

IF FORsrr
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORspc1000
        defc SOUND_ONEBIT_port   = $6000	; 16 bit port addressing (BC)
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORgl6000
    defc INPUT_JOY_useinkey = 1
ENDIF

IF FORprimo
        defc SOUND_ONEBIT_port	= $00 ;
        defc SOUND_ONEBIT_bit    = 4
        defc SOUND_ONEBIT_mask   = $10        ;
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

IF FORx820ii
        defc SOUND_OUTOUT = 1
        defc SOUND_ONEBIT_port   = $28
        defc SOUND_ONEBIT_port2   = $29
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 1         ; (2^SOUND_ONEBIT_bit)
        ;----
        defc TAPE_SPEED_4MHZ   = 1
        ;----
ENDIF


; ********************************************************
;  SN76489 PSG chip definitions
; ********************************************************

IF FORsc3000
	defc SOUND_ONEBIT_port	= $7F        ; also valid for SG-1000
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORm5
	defc SOUND_ONEBIT_port	= $20
        defc SOUND_ONEBIT_bit    = 3
        defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORmtx
	defc SOUND_ONEBIT_port	= $06
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
ENDIF

IF FORsms
	defc SOUND_ONEBIT_port	= $40
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
ENDIF

IF FORpv2000
    defc SOUND_ONEBIT_port	= $40        
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
ENDIF

IF FORrx78
	defc SOUND_ONEBIT_port	= $FF
	defc SOUND_ONEBIT_bit    = 3
	defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
	defc INPUT_JOY_useinkey = 1
ENDIF

IF FORsmc777
    defc SOUND_ONEBIT_port   = $53           ; possibly valid also for Sony SMC 70
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F                   ; $0F for full volume output
ENDIF

IF FORcoleco
    defc SOUND_ONEBIT_port	= $ff        ; also valid for Coleco Adam and Pencil II
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
ENDIF

IF FORbit90
    defc SOUND_ONEBIT_port	= $ff        ; also valid for Coleco Adam and Pencil II
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
ENDIF

IF FORpencil2
    defc SOUND_ONEBIT_port	= $ff        ; also valid for Coleco Adam and Pencil II
    defc SOUND_ONEBIT_bit    = 3
    defc SOUND_ONEBIT_mask   = $0F        	; $0F for full volume output
    defc INPUT_JOY_useinkey = 1
        ;----
        defc TAPE_SPEED_3_58MHZ   = 1
        ;----
ENDIF


; ********************************************************
;   This part refers to NOT YET supported hardware
; ********************************************************

IF !INPUT_JOY_useinkey
	defc	INPUT_JOY_useinkey = 0
ENDIF

IFNDEF SOUND_ONEBIT_port
        defc SOUND_ONEBIT_port   = 0
        defc SOUND_ONEBIT_bit    = 0
        defc SOUND_ONEBIT_mask   = 0
ENDIF

IFNDEF TAPEIN_ONEBIT_port
        defc TAPEIN_ONEBIT_port  = 0
        defc TAPEIN_ONEBIT_mask  = 0
ENDIF


; ********************************************************
;  Presets for tape loading, common timing values
; ********************************************************

IFDEF TAPE_SPEED_2MHZ
        defc PLAY_DATA_LEAD    = 93    ;  Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 26    ;  Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 2     ;  Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 31    ;
        defc PLAY_DATA_BIT0    = 35    ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 13
        defc PLAY_MSXDATA_HI     = $1915   ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO     = $332E   ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR    = 8       ; 1200 baud, leading tone cycle count
ENDIF


IFDEF TAPE_SPEED_2_5MHZ
        defc PLAY_DATA_LEAD    = 116   ;  Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 32    ;  Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 3     ;  Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 39    ;
        defc PLAY_DATA_BIT0    = 44    ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 16
        defc PLAY_MSXDATA_HI     = $1F1A    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO     = $4039    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR    = 10       ; 1200 baud, leading tone cycle count
ENDIF


IFDEF TAPE_SPEED_3_58MHZ
        defc PLAY_DATA_LEAD    = 167   ;  Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 46    ;  Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 4     ;  Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 55    ;
        defc PLAY_DATA_BIT0    = 62    ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 23

		; The tuning is useless for the MSX tape format but we are reusing the constants
		; to calibrate other loader which can be more sensitive

        ;; MSX default values, 1200bps declared but the pitch looks higher than 1200/2400hz
        defc PLAY_MSXDATA_HI    = $2D26    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO    = $5C53    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR   = 15       ; 1200 baud, leading tone cycle count

        ;; defc PLAY_MSXDATA_HI    = $160E   ; 2400 baud, High tone period
        ;; defc PLAY_MSXDATA_LO    = $2D25   ; 2400 baud, Low tone period
        ;; defc PLAY_MSXDATA_HDR   = 31      ; 2400 baud, leading tone cycle count
ENDIF


IFDEF TAPE_SPEED_4MHZ
        defc PLAY_DATA_LEAD    = 186   ;  Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 51    ;  Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 5     ;  Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 62    ;
        defc PLAY_DATA_BIT0    = 70    ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 25
        defc PLAY_MSXDATA_HI     = $322A    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO     = $665C    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR    = 17       ; 1200 baud, leading tone cycle count
ENDIF


IFDEF TAPE_SPEED_6MHZ
        defc PLAY_DATA_LEAD    = 279   ;  Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 77    ;  Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 7     ;  Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 93    ;
        defc PLAY_DATA_BIT0    = 105   ;  Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 38
        defc PLAY_MSXDATA_HI     = $4B3F    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO     = $9A8B    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR    = 25       ; 1200 baud, leading tone cycle count
ENDIF


; ********************************************************
;  Default timing values. They're tuned for a 3.5 Mhz CPU
; ********************************************************

IFNDEF PLAY_DATA_LEAD
        defc PLAY_DATA_LEAD    = 163   ; (164) Timing for the leading tone
        defc PLAY_DATA_SYNC1   = 45    ; (47, 49) Sync bit / Tuned delay for switching to the next byte
        defc PLAY_DATA_BIAS    = 4     ; Fine tuning the parameters
        defc PLAY_DATA_SYNC2   = 54    ; (55, 59)
        defc PLAY_DATA_BIT0    = 61    ; (62, 66) Delay for bit 1 uses both PLAY_DATA_BIT0 twice
        defc LDR_DATA_TIMING   = 22    ; 3.5 mhz
ENDIF

; ** Values here are tuned for 3.5 Mhz (MSX had a 3.58 Mhz CPU) **
IFNDEF PLAY_MSXDATA_HI
        ;; Almost Useless tuning, 3.5 Mhz CPU ---
        defc PLAY_MSXDATA_HI    = $2B25    ; 1200 baud, High tone period
        defc PLAY_MSXDATA_LO    = $5951    ; 1200 baud, Low tone period
        defc PLAY_MSXDATA_HDR   = 14       ; 1200 baud, leading tone cycle count
ENDIF


; **********************************************************
;  A bit of magic with the macros to make the code portable
; **********************************************************

MACRO ONEBITOUT
LOCAL l1, l2, l3, l4, l5, l6, l7
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
ELIF SOUND_OUTOUT = 1
    ld      c,a
    and     SOUND_ONEBIT_mask
    jr      nz,l5
    out     (SOUND_ONEBIT_port),a
    jr      l6
l5: out     (SOUND_ONEBIT_port2),a 
l6: ld      a,c
ELIF SOUND_OUTIN = 1
    push    af
    and     SOUND_ONEBIT_mask
    out     (SOUND_ONEBIT_port), a
    jr      z,l7
    in      a, (SOUND_ZEROBIT_port)
l7:
    pop     af
ELIF SOUND_IN = 1
    push    af
    and     SOUND_ONEBIT_mask
  IF SOUND_ONEBIT_port >= 256
    exx
    in      a,(c)
    exx
  ELIF SOUND_ONEBIT_port < 0
    ld      a,(-SOUND_ONEBIT_port)
  ELSE
    in      a,(SOUND_ONEBIT_port)
  ENDIF
    pop     af
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


MACRO ONEBITIN
IF TAPEIN_ONEBIT_port < 0
    LD      A, (-TAPEIN_ONEBIT_port)
ELIF SOUND_ONEBIT_port >= 256
    exx
    in     a,(c)
    exx
ELSE
    IN      A, (TAPEIN_ONEBIT_port)
ENDIF
ENDM
