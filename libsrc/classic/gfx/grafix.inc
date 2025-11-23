; Compile time constants for building the graphics library


IF FORabc80
    defc    _GFX_MAXX    = 78
    defc    _GFX_MAXY    = 72
ENDIF

IF FORaceudg
    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORace
    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORagon
   defc    _GFX_MAXX = 1024
   defc    _GFX_MAXY = 768
ENDIF

IF FORalphatro
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORalphatp2
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORaquarius
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 160
ENDIF

IF FORaqplus
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 299
ENDIF

IF FORaq48
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 160
ENDIF

IF FORattache
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 240
ENDIF

IF FORaussie
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 576
ENDIF

IF FORbee
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 75
    defc    _GFX_TEXT_BLANK_CHAR    = 128
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORbeehr
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 275
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORbeehr320
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 275
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORbeehr512
    defc    _GFX_MAXX    = 512
    defc    _GFX_MAXY    = 256
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORbondwell
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 75
ENDIF

IF FORbondwell2
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORc128
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 50
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORc128udg
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 75
    defc    _GFX_TEXT_BLANK_CHAR    = 0
ENDIF


IF FORc128hr
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
ENDIF

IF FORc128hr480
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 480
ENDIF


IF FORcpc
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
ENDIF



; GSX virtual window is (32768 x 32768)
; HiRez display should stay between 512..800 px.
; We keep an average value
IF FORcpm
  IF FORgsx
    defc    _GFX_MAXX    = 1920        ; foo value hopefully larger than the max X resolution
    defc    _GFX_MAXY    = 768        ; we keep unbalanced proportions, assuming non-square pixels
  ENDIF
ENDIF


IF FORe200
    defc    _GFX_MAXX    = 120    ; display size of the PC-E200
    defc    _GFX_MAXY    = 28
ENDIF

IF FOReinstein
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
    defc    _GFX_MSX_FILL_COLOUR    = 1
ENDIF

IF FORenterprise
    defc    _GFX_MAXX       = 336
    defc    _GFX_MAXY       = 243
ENDIF

IF FORenterprisehr
    defc    _GFX_MAXX       = 672
    defc    _GFX_MAXY       = 243
ENDIF


IF FORexcali64
    defc    _GFX_MAXX = 160
    defc    _GFX_MAXY = 72
    defc    _GFX_TEXT_BLANK_CHAR = 32
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    _GFX_TEXT_USE_INDEX = 1
ENDIF

IF FORfp1100
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
    defc    _GFX_TEXT_BLANK_CHAR    = 32
    defc    _GFX_GENCON_USEPLOTC   = 1
ENDIF


IF FORg850
    defc    _GFX_MAXX    = 144    ; display size of the PC-G850
    defc    _GFX_MAXY    = 48
ENDIF

IF FORg815
    defc    _GFX_MAXX    = 144    ; display size of the PC-G815
    defc    _GFX_MAXY    = 32
ENDIF



IF FORgal
    ; This size reflects the Gal+ screen mode
    IF textgraphics
        defc    _GFX_MAXX    = 64
        defc    _GFX_MAXY    = 48
    ELSE
        defc    _GFX_MAXX    = 256
        defc    _GFX_MAXY    = 208
    ENDIF
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF



IF FORgb
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORgemini
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 75
    defc    _GFX_TEXT_BLANK_CHAR    = 128
ENDIF

IF FORgeminihr
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 256
    defc    _GFX_TEXT_BLANK_CHAR    = 128
ENDIF



IF FORgl6000
    defc    _GFX_MAXX    = 240
    defc    _GFX_MAXY    = 100
ENDIF

IF FORh19
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 72
ENDIF

IF FORhector1
   DEFINE  _GFX_LINE_NOCLIP
   defc    _GFX_MAXX = 112
   defc    _GFX_MAXY = 77
ENDIF

IF FORhectorhr
   defc    _GFX_MAXX = 240
   defc    _GFX_MAXY = 226
ENDIF

IF FORhemc
    defc    _GFX_MAXX    = 64        ;Text graphics settings
    defc    _GFX_MAXY    = 24 
    defc    _GFX_TEXT_BLANK_CHAR    = 32
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORhgmc
    defc    _GFX_MAXX = 256
    defc    _GFX_MAXY = 256
    defc    BITS_reversed = 1
ENDIF

IF FORhomelab
    defc    _GFX_MAXX = 128
    defc    _GFX_MAXY = 64
ENDIF

IF FORhomelab2
    defc    _GFX_MAXX = 80
    defc    _GFX_MAXY = 50
ENDIF

IF FORinteract
   defc    _GFX_MAXX = 112
   defc    _GFX_MAXY = 77
ENDIF


IF FORkaypro
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 100
    defc    _GFX_PAGE_VRAM = 1
ENDIF


IF FORkaypro83
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 50
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORkc
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 256
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORkrokha
    defc    _GFX_MAXX    = 96 
    defc    _GFX_MAXY    = 64
ENDIF

IF FORlaser500
    defc    _GFX_MAXX = 320
    defc    _GFX_MAXY = 192
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF

IF FORlviv
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 256
ENDIF

IF FORlynx
    defc    _GFX_MAXX    = 64        ;Text graphics settings
    defc    _GFX_MAXY    = 64
    defc    _GFX_TEXT_BLANK_CHAR   = 0
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORm100
    defc    _GFX_MAXX = 240
    defc    _GFX_MAXY = 64
ENDIF

IF FORmbc200
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 400
ENDIF

IF FORmc1000
    defc    _GFX_MAXX = 256
    defc    _GFX_MAXY = 192
ENDIF

IF FORmikro80
    defc    _GFX_GENCON_USEPLOTC = 1
ENDIF

IF FORmsx
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
    defc _GFX_MSX_FILL_COLOUR    = 1
ENDIF

IF FORmulti8
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
ENDIF


IF FORmz
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 50
ENDIF


IF FORnascom
    defc    _GFX_MAXX    = 96
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORnc100
    defc    _GFX_MAXX    = 480
    defc    _GFX_MAXY    = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORnc200
    defc    _GFX_MAXX    = 480
    defc    _GFX_MAXY    = 128
    defc    _GFX_PAGE_VRAM = 1
ENDIF



IF FORondra
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 256
ENDIF


IF FORosborne1
    defc    _GFX_MAXX    = 104
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORosca
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 200
    ; untested 240 lines resolution, see 'libsrc/graphics/osca'
    ;defc    _GFX_MAXY    = 240
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORoz
    defc row_bytes    = 30
    defc    _GFX_MAXX    = 239
    defc    _GFX_MAXY    = 80
    defc    _GFX_PAGE_VRAM = 1
ENDIF



IF FORp2000
    defc    _GFX_MAXX    = 78
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 0
ENDIF


IF FORpacman
    defc    _GFX_MAXX    = 84
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 192
ENDIF

IF FORpc88
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
ENDIF

IF FORpc6001
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
    defc    _GFX_TEXT_BLANK_CHAR    = 0
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORpcw
    defc    _GFX_MAXX    = 720
    defc    _GFX_MAXY    = 256
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORphc25
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
    defc    _GFX_TEXT_BLANK_CHAR    = 32
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORphc20
    defc    _GFX_MAXX    = 32        ;Text graphics settings
    defc    _GFX_MAXY    = 16 
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORpmd85
    defc    _GFX_MAXX = 288
    defc    _GFX_MAXY = 256
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF


IF FORpv1000
    defc    _GFX_MAXX    = 56
    defc    _GFX_MAXY    = 48
ENDIF

IF FORpx4
    defc    _GFX_MAXX    = 240
    defc    _GFX_MAXY    = 64
ENDIF

IF FORpx8
    defc    _GFX_MAXX    = 480
    defc    _GFX_MAXY    = 64
ENDIF


IF FORrc700
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 75
    defc    _GFX_TEXT_BLANK_CHAR    = 32
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORregis
   defc    _GFX_MAXX = 768
   defc    _GFX_MAXY = 480
ENDIF

IF FORrx78
    defc    _GFX_MAXX    = 192
    defc    _GFX_MAXY    = 184
ENDIF


IF FORsam
    defc    _GFX_MAXX    = 512
    defc    _GFX_MAXY    = 192
ENDIF


IF FORsmc777
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
ENDIF


IF FORsol20
    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 16
    defc    _GFX_GENCON_USEPLOTC = 1
ENDIF

IF FORsorcerer
    defc    _GFX_MAXX    = 128
    defc    _GFX_MAXY    = 60
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORspc1000
    ;defc    _GFX_MAXX    = 64        ;Text graphics settings
    ;defc    _GFX_MAXY    = 48
    defc    _GFX_MAXX    = 256        ;Graphics/VDP
    defc    _GFX_MAXY    = 192
    defc    _GFX_TEXT_BLANK_CHAR    = 32
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORspecial
    defc    _GFX_MAXX = 384
    defc    _GFX_MAXY = 256
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF

IF FORsv8000
    defc    _GFX_MAXX = 256
    defc    _GFX_MAXY = 96
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF

IF FORsvi
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
    defc _GFX_MSX_FILL_COLOUR    = 1
ENDIF


IF FORtek
   defc    _GFX_MAXX = 1024
   defc    _GFX_MAXY = 768
ENDIF


IF FORti82
    defc row_bytes    = 12
    defc    _GFX_MAXX    = 96
    defc    _GFX_MAXY    = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORti83
    defc row_bytes    = 12
    defc    _GFX_MAXX    = 96
    defc    _GFX_MAXY    = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORti83p
    defc row_bytes    = 12
    defc    _GFX_MAXX    = 96
    defc    _GFX_MAXY    = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORti85
    defc row_bytes    = 16
    defc    _GFX_MAXX    = 128
    defc    _GFX_MAXY    = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORti86
    defc row_bytes    = 16
    defc    _GFX_MAXX    = 128
    defc    _GFX_MAXY    = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORtiki100
    defc    _GFX_MAXX       = 1024
    defc    _GFX_MAXY       = 256
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORtim011
   defc    _GFX_MAXX = 512
   defc    _GFX_MAXY = 256
ENDIF


IF FORtrs80
    defc    _GFX_MAXX    = 128
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 128
ENDIF

IF FORtrs80m2
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 32
    defc GFXTEXT3 = 1
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORtrs80m4
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 128
    defc    _GFX_PAGE_VRAM = 1
ENDIF

; TRS80
IF FOReg2000
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 102
ENDIF

; TRS80
IF FORhrg1
    defc    _GFX_MAXX    = 384
    defc    _GFX_MAXY    = 192
ENDIF

; TRS80
IF FORgrafyx3
    defc    _GFX_MAXX    = 512
    defc    _GFX_MAXY    = 192
ENDIF

; TRS80
IF FORgrafyx4
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 240
ENDIF


IF FORts2068
    defc    _GFX_MAXX       = 512
    defc    _GFX_MAXY       = 192
ENDIF


IF FORv1050
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 300
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORv1050udg
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 75
    defc    _GFX_TEXT_BLANK_CHAR    = 160
    defc    _GFX_PAGE_VRAM = 1
ENDIF


IF FORvdm
    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 16
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF

IF FORvector06c
    defc    _GFX_MAXX = 256
    defc    _GFX_MAXY = 256
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF


IF FORvg5k
    defc    _GFX_MAXX    = 80
    defc    _GFX_MAXY    = 75
    defc    _GFX_TEXT_BLANK_CHAR    = 0
ENDIF

IF FORvio
    defc    _GFX_MAXX    = 160
    defc    _GFX_MAXY    = 72
    defc    _GFX_TEXT_BLANK_CHAR    = 32
ENDIF

IF FORvti
    defc    _GFX_MAXX    = 128
    defc    _GFX_MAXY    = 48
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
    defc    _GFX_TEXT_BLANK_CHAR    = 160
ENDIF


IF FORvz
    IF BLOCKgfx
        defc    _GFX_MAXX    = 64
        defc    _GFX_MAXY    = 32
    ELSE
        defc    _GFX_MAXX    = 128
        defc    _GFX_MAXY    = 64
    ENDIF
    defc    _GFX_GENCON_USEPLOTC   = 1        ; We call generic_console_plotc, not _printc for text mode
ENDIF


IF FORx1
    defc    _GFX_MAXX    = 640
    defc    _GFX_MAXY    = 200
ENDIF


IF FORz1013
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 256
ENDIF

IF FORz80tvgame
    defc    _GFX_MAXX = 168
    defc    _GFX_MAXY = 208
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF



IF FORz88
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY     = 64
    defc    _GFX_PAGE_VRAM = 1
ENDIF

IF FORz9001
    defc    _GFX_MAXX    = 320
    defc    _GFX_MAXY    = 192
    defc    _GFX_TEXT_BLANK_CHAR = 32
ENDIF

IF FORzx
 IF !FORts2068
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
 ENDIF
ENDIF


IF FORzxn
    defc    _GFX_MAXX       = 512
    defc    _GFX_MAXY       = 192
ENDIF



IF FORzx80
    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 48
ENDIF

IF FORzx81

    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 0
ENDIF

IF FORlambda

    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 48
    defc    _GFX_TEXT_BLANK_CHAR    = 0
ENDIF

IF FORzx81udg
    defc    _GFX_MAXX    = 64
    defc    _GFX_MAXY    = 71
    defc    _GFX_TEXT_BLANK_CHAR    = 0
ENDIF

IF FORzx81phrg
    defc    _GFX_MAXX    = 128
    defc    _GFX_MAXY    = 96    ; This one can be changed !  1..200 are theorical valid values !
ENDIF

IF FORzx81hr64
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 64
ENDIF

IF FORzx81hr128
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 128
ENDIF

IF FORzx81hr192
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 192
ENDIF

IF FORzx81hr384
    defc    _GFX_MAXX    = 256
    defc    _GFX_MAXY    = 384
ENDIF

IF FORzx81mt64
    defc    _GFX_MAXX    = 248
    defc    _GFX_MAXY    = 64
ENDIF

IF FORzx81mt192
    defc    _GFX_MAXX    = 248
    defc    _GFX_MAXY    = 192
ENDIF

IF FORzx81g007
    defc    _GFX_MAXX    = 256    ; It could be 272 but we should switch to 'wide' mode
    defc    _GFX_MAXY    = 185
ENDIF

IF FORzx81g64
    defc    _GFX_MAXX    = 256    ; It could be 272 but we should switch to 'wide' mode
    defc    _GFX_MAXY    = 64
ENDIF




; Defaults
IFNDEF _GFX_MAXX
    defc    _GFX_MAXX = 256
ENDIF

IFNDEF _GFX_MAXY
    defc    _GFX_MAXY = 192
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
