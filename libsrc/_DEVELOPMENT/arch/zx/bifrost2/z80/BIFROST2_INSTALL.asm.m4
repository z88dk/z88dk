include(`z88dk.m4')
include(`config_private.inc')

SECTION BIFROST2
org 51625

PUBLIC asm_BIFROST2_start
PUBLIC asm_BIFROST2_stop
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
BINARY  "bifrost2_engine_48.bin.zx7"

multip3:
BINARY  "bifrost2_engine_p3.bin.zx7"

multiend:

; -----------------------------------------------------------------------------
; Address: 65041 DECOMPRESSOR
; -----------------------------------------------------------------------------

defs 65041 - 51625 - ASMPC

; INLINE DZX7_TURBO SO THAT NO SYMBOLS ARE EXPORTED

asm_dzx7_turbo:

; enter : hl = void *src
;         de = void *dst

        ld      a, $80
        
dzx7t_copy_byte_loop:

        ldi                             ; copy literal byte
        
dzx7t_main_loop:

        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        jr      nc, dzx7t_copy_byte_loop ; next bit indicates either literal or sequence

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b
        
dzx7t_len_size_loop:

        inc     d
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        jr      nc, dzx7t_len_size_loop
        jp      dzx7t_len_value_start

; determine length

dzx7t_len_value_loop:

        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        rl      c
        rl      b
        jr      c, dzx7t_exit           ; check end marker

dzx7t_len_value_start:

        dec     d
        jr      nz, dzx7t_len_value_loop
        inc     bc                      ; adjust length

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        inc     hl
        
IF __z80_cpu_info & $02

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF
        
        jr      nc, dzx7t_offset_end    ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits      ; no more bits left?
        ccf
        jr      c, dzx7t_offset_end
        inc     d                       ; equivalent to adding 128 to DE
        
dzx7t_offset_end:

        rr      e                       ; insert inverted fourth bit into E

; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        sbc     hl, de                  ; HL = destination - offset - 1
        pop     de                      ; DE = destination
        ldir
        
dzx7t_exit:

        pop     hl                      ; restore source address (compressed data)
        jp      nc, dzx7t_main_loop

dzx7t_load_bits:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ret

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
        call    asm_dzx7_turbo

        ex      af, af'
        ld      (DELAY_ADDR), a

        ld      hl, $fe00
        ld      de, $fe01
        ld      bc, 256
        ldir
        ret
