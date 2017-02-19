include(`z88dk.m4')
include(`config_private.inc')

; -----------------------------------------------------------------------------
; BIFROST* ENGINE by Einar Saukas - v1.2/H
; A Rainbow Graphics Support Engine for Animated Tiles
;
; Most 16x16 tiles created by Dave Hughes (R-Tape)
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

SECTION BIFROSTH
org $ded7

PUBLIC _BIFROSTH_tilemap
defc _BIFROSTH_tilemap = __BIFROSTH_TILE_MAP

; -----------------------------------------------------------------------------

PUBLIC asm_BIFROSTH_drawBackTilesH

asm_BIFROSTH_drawBackTilesH:
draw_back_tiles:
        bit     0, e
        jr      nz, draw_updown_tiles
        push    de
        push    bc
        dec     e
        call    draw_updown_tiles
        pop     bc
        pop     de
        inc     e
draw_updown_tiles:
        ld      a, e
        cp      19
        ret     nc
        ld      a, d
        and     $0f
        jr      z, draw_tile_pos
        xor     d
        ld      d, a
        push    de
        push    bc
        call    nz, draw_tile_pos
        pop     bc
        pop     de
        ld      a, d
        add     a, 16
        ld      d, a
		  
PUBLIC asm_BIFROSTH_drawTilePosH

asm_BIFROSTH_drawTilePosH:
draw_tile_pos:
        ld      a, d
        cp      160
        ret     nc
        rrca
        rrca
        rrca
        add     a, d
        add     a, e
        sub     17
        rra
        ld      l, a
        ld      h, __BIFROSTH_TILE_MAP/256
        ld      a,(hl)
        ld      hl, get_tile+2
        cp      (hl)
        jp      c, draw_tile
        inc     a
        jp      nz, get_tile+9

; -----------------------------------------------------------------------------

PUBLIC asm_BIFROSTH_fillTileAttrH

asm_BIFROSTH_fillTileAttrH:
fill_tile_attr:
        ld      (exit_draw+1), sp

; calculate multicolor attribute address
        ld      a, c
        ld      h, attribs/512
        ld      l, d
        add     hl, hl
        ld      bc, attribs-(attribs/512)*512
        add     hl, bc
        ld      sp, hl
        ld      h, deltas/256
        ld      l, e
        ld      c, (hl)                 ; BC = delta (column offset)
        dec     b
        inc     l
        ld      l, (hl)                 ; HL = second delta (column offset)
        ld      h, b
        sbc     hl, bc
        ex      de, hl

; replace attrib with value
Z88DK_FOR(`LOOP', `1', `16',
`
        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a
')
        jp      exit_draw

; -----------------------------------------------------------------------------
draw_at_last_col:
; draw multicolor attributes of a tile starting at the last column in the multicolor area
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        inc     hl
        ex      de, hl
')
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        jp      ldi_exit_draw

; -----------------------------------------------------------------------------
bitmaps:
; lookup table with screen coordinates
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
Z88DK_FOR(`ROWREPT', `0', `17',
`
Z88DK_FOR(`LINREPT', `0', `7',
`
        defw      16384 + (((ROWREPT+1)/8)*2048) + (LINREPT*256) + (((ROWREPT+1)%8)*32) + __BIFROSTH_SHIFT_COLUMNS
')
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; -----------------------------------------------------------------------------
attribs:
; lookup table with multicolor attribute coordinates
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
Z88DK_FOR(`RACEREPT', `0', `143',
`
        defw      race_raster + (RACEREPT * 41)
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; -----------------------------------------------------------------------------
        defb      0
show_next3_delayed:
        nop                             ; extra delay
        nop                             ; extra delay
        jp      show_next3

; -----------------------------------------------------------------------------
draw_sprites:
        ld      de, 0                   ; first sprite: D = lin, E = col
        ld      bc, 0                   ; first sprite: C = tile
        call    draw_sprite
        ld      de, 0                   ; second sprite: D = lin, E = col
        ld      c, 0                    ; second sprite: C = tile
draw_sprite:
; execute draw_tile with different delays depending on column
        ld      b, 81                   ; delay for draw_at_odd_col
        ld      a, e
        rrca
        dec     a
        jr      c, sprite_loop1
        ld      b, 44                   ; delay for draw_at_even_col_inc
        cp      5
        jr      c, sprite_loop2
        ld      b, 40                   ; delay for draw_at_even_col_dec
        cp      8
        jr      nz, sprite_loop
        ld      b, 86                   ; delay for draw_at_last_col
sprite_loop2:
        sbc     hl, hl                  ; extra delay
sprite_loop1:
        inc     hl                      ; extra delay
sprite_loop:
        dec     b
        jr      nz, sprite_loop
skip_sprite_loop:
        ld      a, c
        jp      draw_tile

; -----------------------------------------------------------------------------
draw_at_even_col_dec:
; draw multicolor attributes of a tile starting at even column with non-increasing delta
        cp      21
        jp      z, draw_at_last_col
        ld      c, a
        inc     l
        sub     (hl)                    ; (HL) = second delta (column offset)
        jp      c, draw_at_even_col_inc
        inc     a
        ex      af, af'
        ld      a, c
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        ex      de, hl
        ex      af, af
        ld      c, a
        sbc     hl, bc
        ex      de, hl
        ldi
        ex      de, hl
        ex      af, af
')
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        ex      de, hl
        ex      af, af'
        ld      c, a
        sbc     hl, bc
        ex      de, hl
        jp      ldi_exit_draw

; -----------------------------------------------------------------------------
deltas:
; lookup table with deltas (column offsets)
IF __BIFROSTH_SHIFT_COLUMNS=0
        defb      4, 4, 5, 7, 8, 10, 11, 14, 15, 17, 18, 32, 33, 28, 29, 24, 25, 20, 21, 21
ELSE
        defb      4, 4, 5, 7, 8, 10, 11, 14, 15, 33, 34, 29, 30, 24, 25, 20, 21, 17, 18, 18
ENDIF

; -----------------------------------------------------------------------------
draw_at_even_col_inc:
; draw multicolor attributes of a tile starting at even column with increasing delta
        cpl
        ex      af, af'
        ld      a, c
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     hl

        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        ex      de, hl
        ex      af, af

        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        ex      de, hl
        ex      af, af
')
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        ex      de, hl
        ex      af, af'
        ld      c, a
        add     hl, bc
        ex      de, hl
        jp      ldi_exit_draw

; -----------------------------------------------------------------------------
skip_tile:
        ld      b, $84
delay_tile:
        dec     b
        jr      nz, delay_tile
        ret

; -----------------------------------------------------------------------------
show_next3:
        call    show_next_tile
        call    show_next_tile

PUBLIC asm_BIFROSTH_showNextTile

asm_BIFROSTH_showNextTile:
show_next_tile:
        ld      de, $1001               ; D = lin (16,32,48..144), E = col (1,3,5..17)
        ld      a, e
        sub     (9-__BIFROSTH_TILE_ORDER)*2
        ld      e, a
        jr      nc, prev_lin
        add     a, 18
        ld      e, a
        xor     a
        jr      reset_lin
prev_lin:
        ld      a, d
        sub     16
        ld      d, a
        cp      16
reset_lin:
        sbc     a, a
        and     144
        add     a, d
        ld      d, a
        ld      (show_next_tile+1), de

; -----------------------------------------------------------------------------

PUBLIC asm_BIFROSTH_showTilePosH

asm_BIFROSTH_showTilePosH:
show_tile_pos:                          ; D = lin (0..160), E = col (0..18)
        ld      a, d
        rrca
        rrca
        rrca
        add     a, d
        add     a, e
        sub     17
        rra
        ld      l, a
        ld      h, __BIFROSTH_TILE_MAP/256

get_tile:
        ld      a,(hl)
        cp      __BIFROSTH_STATIC_MIN
        jp      c, animate_tile
        inc     a
        jr      z, skip_tile
        sub     1+__BIFROSTH_STATIC_OVERLAP
        jr      draw_tile
animate_tile:
        rrca
IF __BIFROSTH_ANIM_GROUP=4
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

PUBLIC asm_BIFROSTH_drawTileH
PUBLIC _BIFROSTH_TILE_IMAGES

asm_BIFROSTH_drawTileH:
draw_tile:                              ; D = lin, E = col, A = tile
; calculate screen bitmap lookup address
        ld      (exit_draw+1), sp
        ld      h, bitmaps/512
        ld      l, d
        add     hl, hl
        ld      sp, hl

; preserve values
        ld      b, e
        ld      c, h

; calculate tile image address
        ld      l, 0
        srl     a
        rr      l
        rra
        rr      l
        ld      h, a
defc _BIFROSTH_TILE_IMAGES = ASMPC + 1
        ld      de, __BIFROSTH_TILE_IMAGES
        add     hl, de

; draw bitmap lines
Z88DK_FOR(`LOOP', `1', `16',
`
        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi
')
; calculate multicolor attribute address
        ex      de, hl
        ld      hl, attribs-bitmaps-32
        add     hl, sp
        ld      sp, hl
        ld      h, deltas/256
        ld      l, b
        ld      a, (hl)                 ; A = delta (column offset)

; distinguish between even/odd column
        ld      b, 0
        bit     0, l
        jp      z, draw_at_even_col_dec

draw_at_odd_col:
; draw multicolor attributes starting at odd column
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
        ldi
        ex      de, hl
')
        pop     hl
        ld      c, a
        add     hl, bc
        ex      de, hl
        ldi
ldi_exit_draw:
        ldi
        
exit_draw:
        ld      sp, 0
        ret

; -----------------------------------------------------------------------------

PUBLIC _BIFROSTH_ISR_HOOK

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
        call    show_next3_delayed
IF __BIFROSTH_ANIM_SPEED=4
        ld      a, $c6
ELSE
        ld      a, $fe
ENDIF
        ld      (animate_tile+2), a
IF __BIFROSTH_SPRITE_MODE=0
; draw (and perhaps animate) another 3 tiles
        call    show_next3
ELSE
; draw both sprite tiles
        call    draw_sprites
ENDIF
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
IF __BIFROSTH_SHIFT_COLUMNS=0
        ld      a, (bc)                 ; extra delay
        ld      b, 4
ELSE
        add     hl, hl                  ; extra delay
        ld      b, 5
ENDIF
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
IF __BIFROSTH_SHIFT_COLUMNS=0
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
ELSE
        ld      sp, $5837+(32*ROWREPT)
        ld      hl, 0                   ; columns 05 and 06
        ld      de, 0                   ; columns 07 and 08
        ld      bc, 0                   ; columns 09 and 10
        exx
        ld      hl, 0                   ; columns 11 and 12
        ld      de, 0                   ; columns 21 and 22
        ld      bc, 0                   ; columns 19 and 20
        push    de
        ld      de, 0                   ; columns 17 and 18
        push    bc
        push    de
        ld      de, 0                   ; columns 15 and 16
        push    de
        ld      de, 0                   ; columns 13 and 14
        push    de
        push    hl
        exx
        push    bc
        push    de
        push    hl
ENDIF
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
		  
_BIFROSTH_ISR_HOOK:

        ei
		  reti

; -----------------------------------------------------------------------------
; RAND USR 64995 to activate engine

PUBLIC asm_BIFROSTH_start

asm_BIFROSTH_start:

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

PUBLIC asm_BIFROSTH_stop

asm_BIFROSTH_stop:

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
