;
;   Z88 Sound Functions - SN76489 PSG chip definitions
;
;	$Id: sn76489.inc $
;

IF FORmz
	defc psgport	= $F2
ENDIF

IF FORsc3000
	defc psgport	= $7F		; also valid for SG-1000
ENDIF

IF FORm5
	defc psgport	= $20
ENDIF

IF FORmtx
	defc psgport	= $06
ENDIF

IF FORsms
	defc psgport	= $40
ENDIF

IF FORpv2000
	defc psgport	= $40
ENDIF

; ********************************************************
;   This last part refers to NOT YET supported hardware
; ********************************************************

IF FORcoleco
	defc psgport	= $E0		; also valid for Coleco Adam and Pencil II
ENDIF

IF FORpasopia
	defc psgport	= $3A		; Pasopia has also a second PSG on port $3B
ENDIF

IF FORrx78
	defc psgport	= $FF
ENDIF

IF FORsmc777
	defc psgport	= $53		; possibly valid also for Sony SMC 70
ENDIF

