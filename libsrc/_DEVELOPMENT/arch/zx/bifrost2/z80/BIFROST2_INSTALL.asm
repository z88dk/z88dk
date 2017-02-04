; -----------------------------------------------------------------------------
; BIFROST*2 ENGINE by Einar Saukas
; A Rainbow Graphics 20 Columns 8x1 Multicolor Engine for Animated Tiles
;
; To be compiled with PASMO - http://pasmo.speccy.org/
; -----------------------------------------------------------------------------

INCLUDE "BIFROST2_CONFIG.asm"

DELAY_ADDR      EQU 56541+(TOTAL_ROWS*43)-((TOTAL_ROWS/22)*10)

; -----------------------------------------------------------------------------

        org     51625

; -----------------------------------------------------------------------------
multi48:
INCBIN  "bifrost2_48.bin.zx7"
multip3:
INCBIN  "bifrost2_p3.bin.zx7"
multiend:

; -----------------------------------------------------------------------------

        org     65041

; -----------------------------------------------------------------------------
INCLUDE "dzx7_turbo.asm"

; -----------------------------------------------------------------------------

        org     65226

; -----------------------------------------------------------------------------
; Install engine
;
; Destroys:
;   AF, BC, DE, HL, AF'
;
; Address:
;   65226
; -----------------------------------------------------------------------------
install_engine:
        ld      a, 4
        ex      af, af'
        ld      hl, multiend-1
        ld      bc, multiend-multip3
        ld      a, ($0b53)
        rra
        jr      nc, installp3
        rra
        ld      a, 9
        jr      nc, install48
        ld      a, 10
install48:
        ex      af, af'
        ld      hl, multip3-1
        ld      bc, multip3-multi48
installp3:
        ld      de, $fe10
        lddr
        ex      de, hl
        inc     hl
        ld      de, 51625
        call    dzx7_turbo

        ex      af, af'
        ld      (DELAY_ADDR), a

        ld      hl, $fe00
        ld      de, $fe01
        ld      bc, 256
        ldir
        ret

; -----------------------------------------------------------------------------
