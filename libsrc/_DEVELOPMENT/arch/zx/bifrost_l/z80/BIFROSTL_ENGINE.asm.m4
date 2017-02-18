include(`z88dk.m4')
include(`config_private.inc')

; -----------------------------------------------------------------------------
; BIFROST* ENGINE by Einar Saukas - v1.2/L
; A Rainbow Graphics Support Engine for Animated Tiles
;
; Based on the ZXodus Engine by Andrew Owen
; Most 16x16 tiles created by Dave Hughes (R-Tape)
;
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

SECTION BIFROSTL
org $e501

; -----------------------------------------------------------------------------
attribs:
Z88DK_FOR(`ROWREPT', `0', `17',
`
        defw      race_raster + (ROWREPT * 8 * 41)
')
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROSTL_fillTileAttrL

asm_BIFROSTL_fillTileAttrL:
fill_tile_attr:

; calculate multicolor attribute address
        ld      h, attribs/256
        ld      l, e
        set     6, l
        ld      a, (hl)                 ; A = delta (column offset)
        ld      l, d
        sla     l
        ld      d, (hl)
        dec     l
        add     a, (hl)
        ld      l, a
        adc     a, d
        sub     l
        ld      h, a

; replace attrib with value C
        ld      de, 40
        ld      b, 16
fill_loop:
        ld      (hl), c
        inc     hl
        ld      (hl), c
        add     hl, de
        djnz    fill_loop
        ret

; -----------------------------------------------------------------------------
deltas:
        defb      4, 5, 7, 8, 10, 11, 14, 15, 17, 18, 32, 33, 28, 29, 24, 25, 20, 21, 20
; -----------------------------------------------------------------------------

skip_tile:
        ld      b, $71
delay_skip:
        djnz    delay_skip
        sbc     hl, hl                  ; extra delay
        ret

; -----------------------------------------------------------------------------

show_next3_delayed1:
        nop                             ; extra delay
show_next3_delayed2:
        ld      bc, $8f00
delay_show:
        djnz    delay_show
        call    show_next_tile
        call    show_next_tile
		  
PUBLIC asm_BIFROSTL_showNextTile
		  
asm_BIFROSTL_showNextTile:
show_next_tile:
        ld      de, $0101               ; D = row, E = col (1,3,5..17)
        ld      a, e
        sub     __BIFROSTL_TILE_ORDER * 2
        ld      e, a
        sbc     a, a
        and     18
        add     a, e
        ld      e, a
        sbc     a, a
        ld      c, a
        add     a, a
        add     a, d
        ld      d, a
        sbc     a, a
        xor     c
        and     18
        add     a, d
        ld      d, a
        ld      (show_next_tile+1), de

; -----------------------------------------------------------------------------

PUBLIC asm_BIFROSTL_showTilePosL
PUBLIC _BIFROSTL_tilemap

defc _BIFROSTL_tilemap = __BIFROSTL_TILE_MAP

asm_BIFROSTL_showTilePosL:
show_tile_pos:                          ; D = row, E = col
        ld      a, d
        rlca
        rlca
        rlca
        add     a, d
        add     a, e
        sub     8
        rra
        ld      l, a
        ld      h, __BIFROSTL_TILE_MAP/256

get_tile:
        ld      a,(hl)
        cp      __BIFROSTL_STATIC_MIN
        jp      c, animate_tile
        inc     a
        jr      z, skip_tile
        sub     1+__BIFROSTL_STATIC_OVERLAP
        jr      draw_tile
animate_tile:
        rrca
IF __BIFROSTL_ANIM_GROUP=4
        rrca
        add     a, $40
        rlca
ELSE
        nop
        add     a, $80
        nop
ENDIF
        rlca
        ld      (hl), a

; -----------------------------------------------------------------------------

PUBLIC asm_BIFROSTL_drawTileL
PUBLIC _BIFROSTL_TILE_IMAGES

asm_BIFROSTL_drawTileL:
draw_tile:                              ; D = row, E = col, A = tile

; calculate tile image address
        ld      (exit_draw+1), sp
        ld      l, 0
        srl     a
        rr      l
        rra
        rr      l
        ld      h, a
defc _BIFROSTL_TILE_IMAGES = ASMPC + 1
        ld      bc, __BIFROSTL_TILE_IMAGES
        add     hl, bc
        ld      sp, hl

; calculate screen bitmap address
        ld      a, d                    ; DE = 000RRrrr 000ccccc
        and     %00000111
        rrca
        rrca
        rrca
        or      e
        ld      l, a                    ; L = rrrccccc
        ld      a, d
        and     %00011000
        or      %01000000
        ld      h, a                    ; H = 010RR000

; draw first bitmap row
Z88DK_FOR(`LOOP', `1', `7',
`
        pop     bc
        ld      (hl),c
        inc     l
        ld      (hl),b
        dec     l
        inc     h
')
        pop     bc
        ld      (hl),c
        inc     l
        ld      (hl),b
; move to next bitmap row
        ld      bc, 31
        add     hl, bc
        ld      a, h
        and     248
        ld      h, a
; draw second bitmap row
Z88DK_FOR(`LOOP', `1', `7',
`
        pop     bc
        ld      (hl),c
        inc     l
        ld      (hl),b
        dec     l
        inc     h
')
        pop     bc
        ld      (hl),c
        inc     l
        ld      (hl),b

; calculate multicolor attribute address
        ld      h, attribs/256
        ld      l, e
        set     6, l
        ld      a, (hl)                 ; A = delta (column offset)
        ld      l, d
        sla     l
        ld      d, (hl)
        dec     l
        add     a, (hl)
        ld      l, a
        adc     a, d
        sub     l
        ld      h, a

; draw multicolor attribute
        ld      de, 40
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     bc
        ld      (hl), c
        inc     hl
        ld      (hl), b
        add     hl, de
')
        pop     bc
        ld      (hl), c
        inc     hl
        ld      (hl), b

exit_draw:
        ld      sp, 0
        ret

; -----------------------------------------------------------------------------

PUBLIC _BIFROSTL_ISR_HOOK

main_engine:
; preserve all registers
        push    af
        push    bc
        push    de
        push    hl
        ex      af, af'
        exx
        push    af
        push    bc
        push    de
        push    hl

tile_mapping_begin:
; draw and animate first 3 tiles
        call    show_next3_delayed1
IF __BIFROSTL_ANIM_SPEED=4
        ld      a, $c6
ELSE
        ld      a, $fe
ENDIF
        ld      (animate_tile+2), a
; draw (and perhaps animate) another 3 tiles
        call    show_next3_delayed2
        ld      a, $c6
        ld      (animate_tile+2), a
tile_mapping_end:

; synchronize with the raster beam
        ld      bc, $3805
        ld      a, 14
        jr      sync_raster
delay_128k:
        ld      b, $3b

sync_raster:
        nop                             ; extra delay
sync_raster_loop:
        djnz    sync_raster_loop
        ld      b, a
        ld      hl, ($4000)             ; synchronize
        dec     c
        jr      nz, sync_raster

; wait for the raster beam
        ld      a, (bc)                 ; extra delay
        ld      b, 4
wait_raster:
        djnz    wait_raster

; preserve stack pointer
        ld      (exit_raster+1), sp

; race the raster beam to update attributes at the right time
race_raster:
Z88DK_FOR(`ROWREPT', `0', `17',
`
Z88DK_FOR(`LOOP', `1', `8',
`
        ld      sp, $5833+(32*ROWREPT)
        ld      bc, 0                   ; columns 01 and 02
        ld      de, 0                   ; columns 03 and 04
        ld      hl, 0                   ; columns 05 and 06
        exx
        ld      de, 0                   ; columns 07 and 08
        ld      hl, 0                   ; columns 09 and 10
        ld      bc, 0                   ; columns 17 and 18
        push    bc
        ld      bc, 0                   ; columns 15 and 16
        push    bc
        ld      bc, 0                   ; columns 13 and 14
        push    bc
        ld      bc, 0                   ; columns 11 and 12
        push    bc
        push    hl
        push    de
        exx
        push    hl
        push    de
        push    bc
')
')
exit_raster:
; restore stack pointer
        ld      sp, 0
; restore all registers
        pop     hl
        pop     de
        pop     bc
        pop     af
        exx
        ex      af, af'
        pop     hl
        pop     de
        pop     bc
        pop     af
_BIFROSTL_ISR_HOOK:
        ei
		  reti

; -----------------------------------------------------------------------------
; RAND USR 64995 to activate engine

PUBLIC asm_BIFROSTL_start

asm_BIFROSTL_start:

        di
        ld      a, ($004c)
        and     2
        ld      (delay_128k-1), a
        ld      a, $fe
        ld      i, a
        im      2
        ei
        ret

; -----------------------------------------------------------------------------
; RAND USR 65012 to deactivate engine

PUBLIC asm_BIFROSTL_stop

asm_BIFROSTL_stop:

        di
        ld      a, $3f
        ld      i, a
        im      1
        ei
        ret

; -----------------------------------------------------------------------------
; interrupt address at $fdfd
        jp      main_engine

; -----------------------------------------------------------------------------
; jump vector table at addresses $fe00-$ff00

        defs 257, 0xfd

; -----------------------------------------------------------------------------
