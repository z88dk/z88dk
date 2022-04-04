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
	defc PSGLatchPort = $03
ENDIF

IF FORsms
	defc psgport	= $7f
ENDIF

IF FORpv2000
	defc psgport	= $40
ENDIF

IF FORrx78
	defc psgport = $ff
ENDIF

IF FORcoleco
	defc psgport	= $ff		; also valid for Coleco Adam and Pencil II
ENDIF

IF FORpencil2
	defc psgport	= $ff		; also valid for Coleco Adam and Pencil II
ENDIF

IF FORbit90
	defc psgport	= $ff		; also valid for Coleco Adam and Pencil II
ENDIF

IF FORpasopia
	defc psgport	= $3A		; Pasopia has also a second PSG on port $3B
ENDIF


IF FORsmc777
	defc psgport	= $53		; possibly valid also for Sony SMC 70
	defc HAVE16bitbus = 1
ENDIF

IF FORpasopia7
	defc psgport 	= $3a		; There's a second one on 3b
ENDIF



IF !psgport
	defc psgport = $00		;Placeholder
ENDIF
