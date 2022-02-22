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
;    $Id: grafix.inc $
;


IF FORti82
    DEFINE gotgfx
    defc row_bytes    = 12
    defc maxx    = 96
    defc maxy    = 64
ENDIF

IF FORti83
    DEFINE gotgfx
    defc row_bytes    = 12
    defc maxx    = 96
    defc maxy    = 64
ENDIF

IF FORti83p
    DEFINE gotgfx
    defc row_bytes    = 12
    defc maxx    = 96
    defc maxy    = 64
ENDIF

IF FORti85
    DEFINE gotgfx
    defc row_bytes    = 16
    defc maxx    = 128
    defc maxy    = 64
ENDIF

IF FORti86
    DEFINE gotgfx
    defc row_bytes    = 16
    defc maxx    = 128
    defc maxy    = 64
ENDIF

IF FORpc6001
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 192
    defc blankch    = 0
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORpc88
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
    defc    WANT_swapgfxbk = 0
ENDIF


IF FORvz
    DEFINE gotgfx
    IF BLOCKgfx
        defc maxx    = 64
              defc maxy    = 32
    ELSE
        defc maxx    = 128
              defc maxy    = 64
    ENDIF
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORg800
    DEFINE gotgfx
    defc maxx    = 143    ; display size of the PC-G850
    defc maxy    = 47    ; (a different "getmaxy" is provided for G800 and smaller ones)
ENDIF

IF FORabc80
    DEFINE gotgfx
    defc maxx    = 78
    defc maxy    = 72
ENDIF

IF FORbee
    DEFINE gotgfx
    defc maxx    = 160
    defc maxy    = 75
    defc blankch    = 128
ENDIF

IF FORbeehr
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 275
ENDIF

IF FORbeehr320
    DEFINE gotgfx
    defc maxx    = 320
    defc maxy    = 275
ENDIF

IF FORbeehr512
    DEFINE gotgfx
    defc maxx    = 512
    defc maxy    = 256
ENDIF

IF FORzx80
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 48
ENDIF

IF FORzx81
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 48
    defc blankch    = 0
ENDIF

IF FORlambda
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 48
    defc blankch    = 0
ENDIF

IF FORzx81udg
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 71
    defc blankch    = 0
ENDIF

IF FORzx81phrg
    DEFINE gotgfx
    defc maxx    = 128
    defc maxy    = 96    ; This one can be changed !  1..200 are theorical valid values !
ENDIF

IF FORzx81hr64
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 64
ENDIF

IF FORzx81hr192
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 192
ENDIF

IF FORzx81mt64
    DEFINE gotgfx
    defc maxx    = 248
    defc maxy    = 64
ENDIF

IF FORzx81mt192
    DEFINE gotgfx
    defc maxx    = 248
    defc maxy    = 192
ENDIF

IF FORzx81g007
    DEFINE gotgfx
    defc maxx    = 256    ; It could be 272 but we should switch to 'wide' mode
    defc maxy    = 185
ENDIF

IF FORaceudg
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 72
    defc blankch    = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORace
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 48
    defc blankch    = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORkaypro
    DEFINE gotgfx
    defc maxx    = 160
    defc maxy    = 100
ENDIF

IF FORbondwell
    DEFINE gotgfx
    defc maxx    = 160
    defc maxy    = 75
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORbondwell2
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
ENDIF

IF FORkaypro83
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 50
ENDIF

IF FORosborne1
    DEFINE gotgfx
    defc maxx    = 104
    defc maxy    = 48
    defc blankch    = 32
ENDIF

IF FORzx
 IF !FORts2068
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 192
    defc    WANT_swapgfxbk = 0
 ENDIF
ENDIF

IF FORcpc
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORpcw
    DEFINE gotgfx
    defc maxx    = 720
    defc maxy    = 256
ENDIF

IF FOReinstein
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 192
    defc fcolor    = 1
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORmsx
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 192
    defc fcolor    = 1
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORmz
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 50
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORattache
    DEFINE gotgfx
    defc maxx    = 320
    defc maxy    = 240
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORsvi
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 192
    defc fcolor    = 1
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORsam
    DEFINE gotgfx
    defc maxx    = 512
    defc maxy    = 192
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORoz
    DEFINE gotgfx
    defc row_bytes    = 30
    defc maxx    = 239
    defc maxy    = 80
ENDIF

IF FORosca
    DEFINE gotgfx
    defc maxx    = 320
    defc maxy    = 200
    ; untested 240 lines resolution, see 'libsrc/graphics/osca'
    ;defc maxy    = 240
ENDIF

IF FORc128hr
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
ENDIF

IF FORc128hr480
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 480
ENDIF

IF FORts2068
    DEFINE gotgfx
    defc maxx       = 512
    defc maxy       = 192
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORzxn
    DEFINE gotgfx
    defc maxx       = 512
    defc maxy       = 192
    defc    WANT_swapgfxbk = 0
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
    defc    maxx    = 256
    defc    maxy     = 64
ENDIF

IF FORz9001
    DEFINE gotgfx
    defc maxx    = 320
    defc maxy    = 192
    defc    WANT_swapgfxbk = 0
    defc blankch = 32
ENDIF

IF FORkc
    DEFINE gotgfx
    defc maxx    = 320
    defc maxy    = 256
ENDIF

IF FORaussie
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 576
ENDIF

IF FORaquarius
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 72
    defc blankch    = 160
ENDIF

IF FORaq48
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 48
    defc blankch    = 160
ENDIF

IF FORz1013
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 256
    defc    WANT_swapgfxbk = 0
ENDIF


IF FORc128
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 50
    defc blankch    = 32
ENDIF

IF FORc128udg
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 75
    defc blankch    = 0
ENDIF

IF FORfp1100
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
    defc blankch    = 32
    defc USEplotc   = 1
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORgal
    DEFINE gotgfx
    ; This size reflects the Gal+ screen mode
        IF textgraphics
            defc maxx    = 64
        defc maxy    = 48
        ELSE
            defc maxx    = 256
        defc maxy    = 208
        ENDIF
    defc blankch    = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORnascom
    DEFINE gotgfx
    defc maxx    = 96
    defc maxy    = 48
    defc blankch    = 32
ENDIF

IF FORtrs80
    DEFINE gotgfx
    defc maxx    = 128
    defc maxy    = 48
    defc blankch    = 128
    defc    WANT_swapgfxbk = 0
ENDIF

IF FOReg2000
    DEFINE gotgfx
    defc maxx    = 160
    defc maxy    = 102
ENDIF

IF FORhrg1
    DEFINE gotgfx
    defc maxx    = 384
    defc maxy    = 192
ENDIF

IF FORgrafyx3
    DEFINE gotgfx
    defc maxx    = 512
    defc maxy    = 192
ENDIF

IF FORgrafyx4
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 240
ENDIF

IF FORp2000
    DEFINE gotgfx
    defc maxx    = 78
    defc maxy    = 72
    defc blankch    = 0
ENDIF

IF FORpx4
    DEFINE gotgfx
    defc maxx    = 240
    defc maxy    = 64
ENDIF

IF FORpx8
    DEFINE gotgfx
    defc maxx    = 480
    defc maxy    = 64
ENDIF

IF FORnc100
    DEFINE gotgfx
    defc maxx    = 480
    defc maxy    = 64
ENDIF

IF FORnc200
    DEFINE gotgfx
    defc maxx    = 480
    defc maxy    = 128
ENDIF

IF FORvg5k
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 75
    defc blankch    = 0
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORsorcerer
    DEFINE gotgfx
    defc maxx    = 128
    defc maxy    = 60
    defc blankch    = 32
ENDIF

IF FORpacman
    DEFINE gotgfx
    defc maxx    = 84
    defc maxy    = 72
    defc blankch    = 192
ENDIF

IF FORpv1000
    DEFINE gotgfx
    defc maxx    = 56
    defc maxy    = 48
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORalphatro
    DEFINE gotgfx
    defc maxx    = 80
    defc maxy    = 72
    defc blankch    = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORhemc
    DEFINE gotgfx
    defc maxx    = 64        ;Text graphics settings
    defc maxy    = 24 
    defc blankch    = 32
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORhgmc
    DEFINE    gotgfx
    defc    maxx = 256
    defc    maxy = 256
    defc    WANT_swapgfxbk = 0
    defc    BITS_reversed = 1
ENDIF


IF FORspc1000
    DEFINE gotgfx
    ;defc maxx    = 64        ;Text graphics settings
    ;defc maxy    = 48
    defc maxx    = 256        ;Graphics/VDP
    defc maxy    = 192
    defc blankch    = 32
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORsmc777
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORmulti8
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORrx78
    DEFINE gotgfx
    defc maxx    = 192
    defc maxy    = 184
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORlynx
    DEFINE gotgfx
    defc maxx    = 64        ;Text graphics settings
    defc maxy    = 64
    defc blankch    = 0
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORx1
    DEFINE gotgfx
    defc maxx    = 640
    defc maxy    = 200
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORlaser500
    DEFINE gotgfx
    defc maxx = 320
    defc maxy = 192
    defc blankch = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORexcali64
    DEFINE gotgfx
    defc maxx = 160
    defc maxy = 72
    defc blankch = 32
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc USEindex = 1
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORz80tvgame
    DEFINE gotgfx
    defc maxx = 168
    defc maxy = 208
    defc blankch = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORsv8000
    DEFINE gotgfx
    defc maxx = 256
    defc maxy = 96
    defc blankch = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORpmd85
    DEFINE gotgfx
    defc maxx = 288
    defc maxy = 256
    defc blankch = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORm100
    DEFINE gotgfx
    defc maxx = 240
    defc maxy = 64
ENDIF

IF FORvector06c
    DEFINE gotgfx
    defc maxx = 256
    defc maxy = 256
    defc blankch = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORspecial
    DEFINE gotgfx
    defc maxx = 384
    defc maxy = 256
    defc blankch = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORhomelab
    DEFINE gotgfx
    defc maxx = 128
    defc maxy = 64
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORhomelab2
    DEFINE gotgfx
    defc maxx = 80
    defc maxy = 50
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORgb
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORmikro80
    defc USEplotc = 1
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORondra
    DEFINE gotgfx
    defc maxx    = 320
    defc maxy    = 256
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORlviv
    DEFINE gotgfx
    defc maxx    = 256
    defc maxy    = 256
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORvti
    DEFINE gotgfx
    defc maxx    = 128
    defc maxy    = 48
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc blankch    = 160
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORvio
    DEFINE gotgfx
    defc maxx    = 160
    defc maxy    = 72
    defc blankch    = 32
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORvdm
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 16
    defc USEplotc   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORkrokha
    DEFINE gotgfx
    defc maxx    = 96 
    defc maxy    = 64
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORgl6000
    DEFINE gotgfx
    defc maxx    = 240
    defc maxy    = 100
    defc    WANT_swapgfxbk = 0
ENDIF

IF FORsol20
    DEFINE gotgfx
    defc maxx    = 64
    defc maxy    = 16
    defc USEplotc = 1
ENDIF

; GSX virtual window is (32768 x 32768)
; HiRez display should stay between 512..800 px.
; We keep an average value
IF FORcpm
  IF FORgsx
    DEFINE gotgfx
    defc maxx    = 1920        ; foo value hopefully larger than the max X resolution
    defc maxy    = 768        ; we keep unbalanced proportions, assuming non-square pixels
  ENDIF
ENDIF

; =============================================


; Catch all to sort things out

IF !gotgfx
    defc    maxx = 256
    defc    maxy = 192
ENDIF

IF WANT_swapgfxbk
    defc    NEED_swapgfxbk = 0
ELSE
    defc    NEED_swapgfxbk = 1
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
