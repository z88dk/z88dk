;
;   Define constants for VDP in different platforms of the SEGA/MSX generation
;
;	$Id: vdp.inc,v 1.4 2010-09-15 09:00:39 stefano Exp $
;

IF FORsms
	defc VDP_DATA    = $be
	defc VDP_DATAIN  = $be ; ?
	defc VDP_CMD     = $bf
	defc VDP_STATUS  = $bf ; ?
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 0
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF
	
IF FORsc3000
	defc VDP_DATA    = $be
	defc VDP_DATAIN  = $be ; ?
	defc VDP_CMD     = $bf
	defc VDP_STATUS  = $bf ; ?
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF
	
IF FORmsx
	defc VDP_DATA    = $98
	defc VDP_DATAIN  = $98
	defc VDP_CMD     = $99
	defc VDP_STATUS  = $99
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORmsx2
	defc VDP_DATA    = $98
	defc VDP_DATAIN  = $98
	defc VDP_CMD     = $99
	defc VDP_STATUS  = $99
        ; Additional ports for V9938
	defc VDP_PORT2   = $9a      ;Palette register
	defc VDP_PORT3   = $9b      ;Register pointer
	defc VRAM_SIZE   = 64
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
	defc V9938 = 1
ENDIF

IF FORsvi
	defc VDP_DATA    = $80
	defc VDP_DATAIN  = $84
	defc VDP_CMD     = $81
	defc VDP_STATUS  = $85
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 0
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORm5
	defc VDP_DATA    = $10
	defc VDP_DATAIN  = $10
	defc VDP_CMD     = $11
	defc VDP_STATUS  = $11
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORmtx
	defc VDP_DATA    = 1
	defc VDP_DATAIN  = 1
	defc VDP_CMD     = 2
	defc VDP_STATUS  = 2
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FOReinstein
	defc VDP_DATA    = 8
	defc VDP_DATAIN  = 8
	defc VDP_CMD     = 9
	defc VDP_STATUS  = 9
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 0
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FOReinstein256
	defc VDP_DATA    = 8
	defc VDP_DATAIN  = 8
	defc VDP_CMD     = 9
	defc VDP_STATUS  = 9
        ; Additional ports for V9938
	defc VDP_PORT2   = 10      ;Palette register
	defc VDP_PORT3   = 11      ;Register pointer
	defc VRAM_SIZE   = 64	   ;Guess?
	defc VDP_EXPORT_DIRECT = 0
	defc VDP_EXPORT_GFX_DIRECT = 1
	defc V9938 = 1
ENDIF


IF FORpv2000
	defc VDP_DATA    = -0x4000
	defc VDP_DATAIN  = -0x4000
	defc VDP_CMD     = -0x4001
	defc VDP_STATUS  = -0x4001
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORmyvision
	defc VDP_DATA    = -0xe000
	defc VDP_DATAIN  = -0xe000
	defc VDP_CMD     = -0xe002
	defc VDP_STATUS  = -0xe002
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORsg1000
	defc VDP_DATA    = 0xbe
	defc VDP_DATAIN  = 0xbe
	defc VDP_CMD     = 0xbf
	defc VDP_STATUS  = 0xbf
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORcoleco
	defc VDP_DATA    = 0xbe
	defc VDP_DATAIN  = 0xbe
	defc VDP_CMD     = 0xbf
	defc VDP_STATUS  = 0xbf
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORpencil2
	defc VDP_DATA    = 0xbe
	defc VDP_DATAIN  = 0xbe
	defc VDP_CMD     = 0xbf
	defc VDP_STATUS  = 0xbf
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORspc1000
	defc VDP_DATA    = 0xc800
	defc VDP_DATAIN  = 0xc800
	defc VDP_CMD     = 0xc801
	defc VDP_STATUS  = 0xc801
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 0
	defc VDP_EXPORT_GFX_DIRECT = 0
ENDIF

IF FORlm80c
	defc VDP_DATA    = @00110000
	defc VDP_DATAIN  = @00110000
	defc VDP_CMD     = @00110010
	defc VDP_STATUS  = @00110010
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
ENDIF

IF FORnabu
	defc VDP_DATA    = $a0
	defc VDP_DATAIN  = $a0
	defc VDP_CMD     = $a1
	defc VDP_STATUS  = $a1
	defc VRAM_SIZE   = 16
	defc VDP_EXPORT_DIRECT = 1
	defc VDP_EXPORT_GFX_DIRECT = 1
	defc F18A = 1
ENDIF

; Macro to help writing to ports
; If port >= 256 we expect bc to hold the port
MACRO VDPOUT PORT
IF PORT < 0
    ld      (-PORT),a
ELIF PORT < 256
    out     (PORT),a
ELSE
    out     (c),a
ENDIF
ENDM

; Macro to help reading from ports
; If port >= 256 we expect bc to hold the port
MACRO VDPIN PORT
IF PORT < 0
    ld      a,(-PORT)
ELIF PORT < 256
    in      a,(PORT)
ELSE
    in      a,(c)
ENDIF
ENDM


; Logic operations for the V9938

defc V9938_LOGIC_SET = 0
defc V9938_LOGIC_XOR = 0011b
