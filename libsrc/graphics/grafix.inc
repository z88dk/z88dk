;
;       Z88 Graphics Functions - Small C+ stubbs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       Define for graphics and other standard library functions
;       See also text/textgfx.inc and text6/textgfx.inc
;
;
;	$Id: grafix.inc $
;


IF FORti82
	DEFINE gotgfx
	defc row_bytes	= 12
	defc maxx	= 96
	defc maxy	= 64
ENDIF

IF FORti83
	DEFINE gotgfx
	defc row_bytes	= 12
	defc maxx	= 96
	defc maxy	= 64
ENDIF

IF FORti83p
	DEFINE gotgfx
	defc row_bytes	= 12
	defc maxx	= 96
	defc maxy	= 64
ENDIF

IF FORti85
	DEFINE gotgfx
	defc row_bytes	= 16
	defc maxx	= 128
	defc maxy	= 64
ENDIF

IF FORti86
	DEFINE gotgfx
	defc row_bytes	= 16
	defc maxx	= 128
	defc maxy	= 64
ENDIF

IF FORpc6001
	DEFINE gotgfx
	defc maxx	= 64		;Text graphics settings
	defc maxy	= 48
	defc blankch    = 0
	defc USEplotc   = 1		; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORvz
	DEFINE gotgfx
	IF BLOCKgfx
	    defc maxx	= 64
      	    defc maxy	= 32
	    defc USEplotc   = 1		; We call generic_console_plotc, not _printc for text mode
	ELSE
	    defc maxx	= 128
      	    defc maxy	= 64
	ENDIF
ENDIF

IF FORabc80
	DEFINE gotgfx
	defc maxx	= 70
	defc maxy	= 72
ENDIF

IF FORbee
	DEFINE gotgfx
	defc maxx	= 160
	defc maxy	= 75
	defc blankch	= 128
ENDIF

IF FORbeehr
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 275
ENDIF

IF FORbeehr320
	DEFINE gotgfx
	defc maxx	= 320
	defc maxy	= 275
ENDIF

IF FORbeehr512
	DEFINE gotgfx
	defc maxx	= 512
	defc maxy	= 256
ENDIF

IF FORzx80
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
ENDIF

IF FORzx81
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
	defc blankch	= 0
ENDIF

IF FORlambda
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
	defc blankch	= 0
ENDIF

IF FORzx81udg
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 71
	defc blankch	= 0
ENDIF

IF FORzx81hr64
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 64
ENDIF

IF FORzx81hr192
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
ENDIF

IF FORzx81mt64
	DEFINE gotgfx
	defc maxx	= 248
	defc maxy	= 64
ENDIF

IF FORzx81mt192
	DEFINE gotgfx
	defc maxx	= 248
	defc maxy	= 192
ENDIF

IF FORzx81g007
	DEFINE gotgfx
	defc maxx	= 256	; It could be 272 but we should switch to 'wide' mode
	defc maxy	= 185
ENDIF

IF FORaceudg
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 71
	defc blankch	= 128
ENDIF

IF FORace
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORkaypro
	DEFINE gotgfx
	defc maxx	= 160
	defc maxy	= 100
ENDIF

IF FORkaypro83
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
ENDIF

IF FORosborne1
	DEFINE gotgfx
	defc maxx	= 104
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORzx
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
ENDIF

IF FORcpc
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 200
ENDIF

IF FOReinstein
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 1
ENDIF

IF FORmsx
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 1
ENDIF

IF FORmz
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
ENDIF

IF FORattache
	DEFINE gotgfx
	defc maxx	= 320
	defc maxy	= 240
ENDIF

IF FORsvi
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
	defc fcolor	= 1
ENDIF

IF FORsam
	DEFINE gotgfx
	defc maxx	= 256
	defc maxy	= 192
ENDIF

IF FORoz
	DEFINE gotgfx
	defc row_bytes	= 30
	defc maxx	= 239
	defc maxy	= 80
ENDIF

IF FORosca
	DEFINE gotgfx
	defc maxx	= 320
	defc maxy	= 200
	; untested 240 lines resolution, see 'libsrc/graphics/osca'
	;defc maxy	= 240
ENDIF

IF FORc128hr
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 200
ENDIF

IF FORc128hr480
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 480
ENDIF

IF FORgfx2068hr
	DEFINE gotgfx
	defc maxx       = 512
	defc maxy       = 192
ENDIF

IF FORtiki100
	DEFINE gotgfx
	defc maxx       = 1024
	defc maxy       = 256
ENDIF

IF FORenterprise
	DEFINE gotgfx
	defc maxx       = 336
	defc maxy       = 243
ENDIF

IF FORenterprisehr
	DEFINE gotgfx
	defc maxx       = 672
	defc maxy       = 243
ENDIF

IF FORz88
	DEFINE gotgfx
	defc	maxx	= 256
	defc	maxy 	= 64
ENDIF

IF FORz9001krt
	DEFINE gotgfx
	defc maxx	= 320
	defc maxy	= 192
ENDIF

IF FORkc
	DEFINE gotgfx
	defc maxx	= 320
	defc maxy	= 256
ENDIF

IF FORaussie
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 576
ENDIF

IF FORaquarius
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
	defc blankch	= 160
ENDIF

IF FORaq48
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 48
	defc blankch	= 160
ENDIF

IF FORz1013
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 64
	defc blankch	= 32
ENDIF

IF FORz9001
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORc128
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 50
	defc blankch	= 32
ENDIF

IF FORgal
	DEFINE gotgfx
	defc maxx	= 64
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORnascom
	DEFINE gotgfx
	defc maxx	= 96
	defc maxy	= 48
	defc blankch	= 32
ENDIF

IF FORtrs80
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 48
	defc blankch	= 128
ENDIF

IF FOReg2000
	DEFINE gotgfx
	defc maxx	= 160
	defc maxy	= 102
ENDIF

IF FORp2000
	DEFINE gotgfx
	defc maxx	= 78
	defc maxy	= 72
ENDIF

IF FORpx4
	DEFINE gotgfx
	defc maxx	= 240
	defc maxy	= 64
ENDIF

IF FORpx8
	DEFINE gotgfx
	defc maxx	= 480
	defc maxy	= 64
ENDIF

IF FORnc100
	DEFINE gotgfx
	defc maxx	= 480
	defc maxy	= 64
ENDIF

IF FORnc200
	DEFINE gotgfx
	defc maxx	= 480
	defc maxy	= 128
ENDIF

IF FORvg5k
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
	defc blankch	= 0
ENDIF

IF FORsorcerer
	DEFINE gotgfx
	defc maxx	= 128
	defc maxy	= 60
	defc blankch	= 32
ENDIF

IF FORpacman
	DEFINE gotgfx
	defc maxx	= 56
	defc maxy	= 72
	defc blankch	= 30
ENDIF

IF FORpv1000
	DEFINE gotgfx
	defc maxx	= 56
	defc maxy	= 48
ENDIF

IF FORalphatro
	DEFINE gotgfx
	defc maxx	= 80
	defc maxy	= 72
	defc blankch	= 32
ENDIF

IF FORspc1000
	DEFINE gotgfx
	defc maxx	= 64		;Text graphics settings
	defc maxy	= 48
	defc blankch    = 32
	defc USEplotc   = 1		; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORmulti8
	DEFINE gotgfx
	defc maxx	= 640
	defc maxy	= 200
ENDIF

IF FORrx78
	DEFINE gotgfx
	defc maxx	= 192
	defc maxy	= 184
ENDIF

; =============================================


; Catch all to sort things out

IF !gotgfx
	defc	maxx = 256
	defc	maxy = 192
ENDIF



;       Structure for open window       struct *window

DEFVARS 0
{
        windnum ds.b    1
        wind_x  ds.b    1
        wind_y  ds.b    1
        wind_w  ds.b    1       ;width/map width
        wind_d  ds.b    1       ;
        type    ds.b    1       ;
        graph   ds.b    1       ;0=text 1=graphics
}
