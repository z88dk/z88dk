include(`z88dk.m4')
include(`config_private.inc')

SECTION BIFROST2
org 51625

PUBLIC asm_BIFROST2_start
PUBLIC asm_BIFROST2_showNext2Tiles
PUBLIC asm_BIFROST2_showNextTile
PUBLIC asm_BIFROST2_showTilePosH
PUBLIC asm_BIFROST2_drawTileH
PUBLIC _BIFROST2_TILE_IMAGES
PUBLIC _BIFROST2_ISR_HOOK
PUBLIC asm_BIFROST2_fillTileAttrH
PUBLIC _BIFROST2_tilemap

INCLUDE "bifrost2_engine_48.def"

defc DELAY_ADDR = 56541+(__BIFROST2_TOTAL_ROWS*43)-((__BIFROST2_TOTAL_ROWS/22)*10)

; -----------------------------------------------------------------------------
; Address: 51625 BINARY BLOBS
; -----------------------------------------------------------------------------

multi48:
BINARY  "bifrost2_engine_48.bin.zx0"

multip3:
BINARY  "bifrost2_engine_p3.bin.zx0"

multiend:

; -----------------------------------------------------------------------------
; Address: 65041 DECOMPRESSOR
; -----------------------------------------------------------------------------

defs 65041 - 51625 - ASMPC

; INLINE DZX0_TURBO SO THAT NO SYMBOLS ARE EXPORTED

; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas & introspec
; "Turbo" version (128 bytes, 20% faster)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------



; Entry: hl = void *src
;        de = void *dst
;
; Uses: af, bc, de, hl
asm_dzx0_turbo:
dzx0_turbo:
        ld      bc, $ffff               ; preserve default offset 1
        ld      (dzx0t_last_offset+1), bc
        inc     bc
        ld      a, $80
        jr      dzx0t_literals
dzx0t_new_offset:
        inc     c                       ; obtain offset MSB
        add     a, a
        jp      nz, dzx0t_new_offset_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0t_new_offset_skip:
        call    nc, dzx0t_elias
        ex      af, af'                 ; adjust for negative offset
        xor     a
        sub     c
        ret     z                       ; check end marker
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0t_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    nc, dzx0t_elias
        inc     bc
dzx0t_copy:
        push    hl                      ; preserve source
dzx0t_last_offset:
        ld      hl, 0                   ; restore offset
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0t_new_offset
dzx0t_literals:
        inc     c                       ; obtain length
        add     a, a
        jp      nz, dzx0t_literals_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0t_literals_skip:
        call    nc, dzx0t_elias
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0t_new_offset
        inc     c                       ; obtain length
        add     a, a
        jp      nz, dzx0t_last_offset_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0t_last_offset_skip:
        call    nc, dzx0t_elias
        jp      dzx0t_copy
dzx0t_elias:
        add     a, a                    ; interlaced Elias gamma coding
        rl      c
        add     a, a
        jr      nc, dzx0t_elias
        ret     nz
dzx0t_elias_reload:
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ret     c
        add     a, a
        rl      c
        rl      b
        add     a, a
        ret     c
        add     a, a
        rl      c
        rl      b
        add     a, a
        ret     c
        add     a, a
        rl      c
        rl      b
        add     a, a
        ret     c
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      dzx0t_elias_reload
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; Address: 65226 INSTALLER
; -----------------------------------------------------------------------------

defs 65226 - 51625 - ASMPC

; Install engine
;
; Destroys:
;   AF, BC, DE, HL, AF'
;
; Address:
;   65226

PUBLIC asm_BIFROST2_install

asm_BIFROST2_install:
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
        call    asm_dzx0_turbo

        ex      af, af'
        ld      (DELAY_ADDR), a

        ld      hl, $fe00
        ld      de, $fe01
        ld      bc, 256
        ldir
        ret
