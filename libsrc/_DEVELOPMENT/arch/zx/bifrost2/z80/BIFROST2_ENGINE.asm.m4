include(`z88dk.m4')
include(`config_private.inc')

; -----------------------------------------------------------------------------
; BIFROST*2 ENGINE by Einar Saukas
; A Rainbow Graphics 20 Columns 8x1 Multicolor Engine for Animated Tiles
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

org 51625

; -----------------------------------------------------------------------------
; Start engine
;
; Destroys:
;   AF
;
; Address:
;   51625
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_start

asm_BIFROST2_start:
activate_engine:
        di
        ld      a, $fe
        ld      i, a
        im      2
        ei
        ret

; -----------------------------------------------------------------------------
; Stop engine
;
; Destroys:
;   AF
;
; Address:
;   51634
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_stop

asm_BIFROST2_stop:
deactivate_engine:
        di
        ld      a, $3f
        ld      i, a
        im      1
        ei
        ret

; -----------------------------------------------------------------------------
; Internal routine
; -----------------------------------------------------------------------------
skip_tile:
        ld      b, 92
delay_tile:
        inc     hl
        djnz    delay_tile
        inc     hl
        ret

; -----------------------------------------------------------------------------
; Instantly show/animate next 2 tile map positions in drawing order
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51650
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_showNext2Tiles

asm_BIFROST2_showNext2Tiles:
show_next2:
        call    show_next_tile

; -----------------------------------------------------------------------------
; Instantly show/animate next tile map position in drawing order
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51653
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_showNextTile

asm_BIFROST2_showNextTile:
show_next_tile:
        ld      de, $1001               ; D = lin (16,32,48..176), E = col (1,3,5..19)
        ld      a, e
        sub     +(10-__BIFROST2_TILE_ORDER)*2
        ld      e, a
        jr      nc, prev_lin
        add     a, 20
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
        and     +((__BIFROST2_TOTAL_ROWS+1)/2)*16
        add     a, d
        ld      d, a
        ld      (show_next_tile+1), de

; -----------------------------------------------------------------------------
; Instantly show/animate specified tile map position on screen
;
; Parameters:
;   D: lin (16,32,48..176)
;   E: col (1,3,5..19)
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51683
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_showTilePosH
PUBLIC _BIFROST2_tilemap

asm_BIFROST2_showTilePosH:
show_tile_pos:
        ld      a, d                    ; A = 8*(lin/8)
        rrca                            ; A = 4*(lin/8)
        rrca                            ; A = 2*(lin/8)
        add     a, d                    ; A = 10*(lin/8)
        add     a, e                    ; A = 10*(lin/8)+col
        sub     19                      ; A = 10*(lin/8)-20+(col+1)
        rra                             ; A = 10*(lin/16)-10+(col+1)/2
        ld      l, a
defc _BIFROST2_tilemap = __BIFROST2_TILE_MAP
        ld      h, __BIFROST2_TILE_MAP/256   ; HL = TILEMAP+10*(lin/16)-10+(col-1)/2

get_tile:
        ld      a,(hl)
        cp      __BIFROST2_STATIC_MIN
        jp      c, animate_tile
        inc     a
        jr      z, skip_tile
        sub     1+__BIFROST2_STATIC_OVERLAP
        jr      draw_tile
animate_tile:
        rrca
IF (__BIFROST2_ANIM_GROUP = 4)
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
; Instantly draw tile at specified position on screen
;
; Parameters:
;   A: tile number (0-255)
;   D: lin (0-207)
;   E: col (0-20)
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51714
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_drawTileH
PUBLIC _BIFROST2_TILE_IMAGES

asm_BIFROST2_drawTileH:
draw_tile:
; calculate screen bitmap lookup address
        ld      (exit_draw+1), sp
        ld      h, lookup/512
        ld      l, d                    ; HL = lookup/2+lin
        add     hl, hl                  ; HL = lookup+2*lin
        ld      sp, hl                  ; SP = lookup+2*lin

; preserve values
        ld      b, e                    ; B = col
        ld      c, h

; calculate tile image address
        ld      l, 0                    ; AL = 256*tile
        rra
        rr      l                       ; AL = 128*tile
        rra
        rr      l                       ; AL = 64*tile
        ld      h, a                    ; HL = 64*tile
defc _BIFROST2_TILE_IMAGES = ASMPC + 1
        ld      de, __BIFROST2_TILE_IMAGES
        add     hl, de                  ; HL = TILE_IMAGES+64*tile

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
        ex      de, hl                  ; DE = TILE_IMAGES+64*tile+32
        rr      b                       ; B = INT(col/2)
        ld      c, 235                  ; BC = 256*INT(col/2)+235
        ld      h, b
        ld      l, c                    ; HL = 256*INT(col/2)+235
        srl     h
        rr      l                       ; HL = 128*INT(col/2)+117
        add     hl, bc                  ; HL = 384*INT(col/2)+352 = 384*INT(col/2)+384-32
        add     hl, sp                  ; HL = SP+384*INT(col/2)+384-32 = (lookup+384)+lin*2+384*INT(col/2)
        ld      sp, hl
        ex      de, hl

; distinguish between even/odd column
        rra
        jr      nc, draw_even_col

; draw multicolor attributes starting at odd column
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     de
        ldi
        ldi
')
        pop     de
        ldi
        ld      a, (hl)
        ld      (de), a
exit_draw:
        ld      sp, 0
        ret

draw_even_col:
        ld      a, b                    ; A = INT(col/2)
        cp      10
        ld      de, -384
        jr      z, draw_last_col

; draw right side of tile
Z88DK_FOR(`LOOP', `1', `16',
`
        inc     hl
        pop     de
        ldi
')
        and     a
        jr      z, exit_draw

        ld      de, -32
        add     hl, de
        ld      de, -(384+32)
draw_last_col:
        ex      de, hl
        add     hl, sp
        ld      sp, hl
        ex      de, hl

; draw left side of tile
Z88DK_FOR(`LOOP', `1', `15',
`
        pop     de
        inc     de
        ldi
        inc     hl
')
        pop     de
        inc     de
        ldi

        jp      exit_draw

; -----------------------------------------------------------------------------
; Lookup tables
; -----------------------------------------------------------------------------
extra_buffer:
Z88DK_FOR(`LOOP', `1', `22',
`
        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)
')
lookup:
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with screen coordinates
Z88DK_FOR(`ROWREPT', `0', `21',
`
Z88DK_FOR(`LINREPT', `0', `7',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      16384 + (((ROWREPT+1)/8)*2048) + (LINREPT*256) + (((ROWREPT+1)%8)*32)
ELSE
        defw      0
ENDIF
')
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 1 & 2
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/19)*(3-ROWREPT)*7)+40
        defw      race_raster+(ROWREPT*333)+30
        defw      race_raster+(ROWREPT*333)+73
        defw      race_raster+(ROWREPT*333)+122
IFDEF PLUS3
        defw      race_raster+(ROWREPT*333)+164
ELSE
        defw      race_raster+(ROWREPT*333)+86
ENDIF
        defw      race_raster+(ROWREPT*333)+222
        defw      race_raster+(ROWREPT*333)+260
        defw      race_raster+(ROWREPT*333)+302
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 3 & 4
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/19)*(3-ROWREPT)*7)+36
        defw      race_raster+(ROWREPT*333)+26
        defw      race_raster+(ROWREPT*333)+76
        defw      race_raster+(ROWREPT*333)+125
        defw      race_raster+(ROWREPT*333)+167
        defw      race_raster+(ROWREPT*333)+211
        defw      race_raster+(ROWREPT*333)+48
        defw      race_raster+(ROWREPT*333)+305
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 5 & 6
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/19)*(3-ROWREPT)*7)+30
        defw      race_raster+(ROWREPT*333)+34
        defw      race_raster+(ROWREPT*333)+79
        defw      race_raster+(ROWREPT*333)+128
IFDEF PLUS3
        defw      race_raster+(ROWREPT*333)+83
ELSE
        defw      race_raster+(ROWREPT*333)+170
ENDIF
        defw      race_raster+(ROWREPT*333)+214
        defw      race_raster+(ROWREPT*333)+256
        defw      race_raster+(ROWREPT*333)+295
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 7 & 8
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/19)*(3-ROWREPT)*7)+27
        defw      race_raster+(ROWREPT*333)+61
        defw      race_raster+(ROWREPT*333)+108
        defw      extra_buffer+(ROWREPT*4)+2
        defw      race_raster+(ROWREPT*333)+193
        defw      race_raster+(ROWREPT*333)+236
        defw      race_raster+(ROWREPT*333)+278
        defw      race_raster+(ROWREPT*333)+318
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 9 & 10
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/19)*(3-ROWREPT)*7)+24
        defw      race_raster+(ROWREPT*333)+64
        defw      race_raster+(ROWREPT*333)+10
        defw      race_raster+(ROWREPT*333)+112
        defw      race_raster+(ROWREPT*333)+154
        defw      extra_buffer+(ROWREPT*4)
        defw      race_raster+(ROWREPT*333)+240
        defw      race_raster+(ROWREPT*333)+291
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 11 & 12
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/20)*(2-ROWREPT)*7)+(((21-ROWREPT)/19)*4)+20
        defw      race_raster+(ROWREPT*333)+67
        defw      race_raster+(ROWREPT*333)+13
        defw      race_raster+(ROWREPT*333)+115
        defw      race_raster+(ROWREPT*333)+157
        defw      race_raster+(ROWREPT*333)+198
        defw      race_raster+(ROWREPT*333)+243
        defw      race_raster+(ROWREPT*333)+282
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 13 & 14
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/20)*(2-ROWREPT)*7)+(((21-ROWREPT)/19)*4)+16
        defw      race_raster+(ROWREPT*333)+20
        defw      race_raster+(ROWREPT*333)+16
        defw      race_raster+(ROWREPT*333)+118
        defw      race_raster+(ROWREPT*333)+160
        defw      race_raster+(ROWREPT*333)+201
        defw      race_raster+(ROWREPT*333)+246
        defw      race_raster+(ROWREPT*333)+285
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 15 & 16
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/20)*(2-ROWREPT)*7)+(((21-ROWREPT)/19)*4)+10
        defw      race_raster+(ROWREPT*333)+52
        defw      race_raster+(ROWREPT*333)+92
        defw      race_raster+(ROWREPT*333)+137
IFDEF PLUS3
        defw      race_raster+(ROWREPT*333)+174
ELSE
        defw      race_raster+(ROWREPT*333)+164
ENDIF
        defw      race_raster+(ROWREPT*333)+204
        defw      race_raster+(ROWREPT*333)+250
        defw      race_raster+(ROWREPT*333)+299
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 17 & 18
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/20)*(2-ROWREPT)*7)+(((21-ROWREPT)/19)*4)+7
        defw      race_raster+(ROWREPT*333)+55
        defw      race_raster+(ROWREPT*333)+95
        defw      race_raster+(ROWREPT*333)+140
IFDEF PLUS3
        defw      race_raster+(ROWREPT*333)+177
ELSE
        defw      race_raster+(ROWREPT*333)+175
ENDIF
        defw      race_raster+(ROWREPT*333)+208
        defw      race_raster+(ROWREPT*333)+253
        defw      race_raster+(ROWREPT*333)+322
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')
; lookup table with attribute coordinates for columns 19 & 20
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT < __BIFROST2_TOTAL_ROWS)
        defw      setup_raster+((__BIFROST2_TOTAL_ROWS-1-ROWREPT)*43)+(((21-ROWREPT)/20)*(2-ROWREPT)*7)+(((21-ROWREPT)/19)*4)+4
        defw      race_raster+(ROWREPT*333)+23
        defw      race_raster+(ROWREPT*333)+98
        defw      race_raster+(ROWREPT*333)+143
IFDEF PLUS3
        defw      race_raster+(ROWREPT*333)+180
ELSE
        defw      race_raster+(ROWREPT*333)+178
ENDIF
        defw      race_raster+(ROWREPT*333)+219
        defw      race_raster+(ROWREPT*333)+275
        defw      race_raster+(ROWREPT*333)+328
ELSE
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
ENDIF
')
Z88DK_FOR(`LOOP', `1', `16',
`
        defw      0
')

; -----------------------------------------------------------------------------

PUBLIC _BIFROST2_ISR_HOOK

main_engine:
; preserve all registers
        push    af
        push    bc
        push    de
        push    hl
        ex      af, af
        exx
        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy

; draw and animate next 5 tiles
        call    show_next2
        call    show_next2
        call    show_next_tile

; initial delay to synchronize with raster beam
IF __BIFROST2_TOTAL_ROWS<22
        ld      c, 22-__BIFROST2_TOTAL_ROWS
skip_loop:
        ld      b, 15
        djnz    ASMPC
        ld      a, (bc)
        dec     c
        jr      nz, skip_loop
ENDIF

; preserve stack pointer
        ld      (exit_raster+1), sp

; copy in advance first line of attributes for each row
        ld      a, 8
setup_raster:
Z88DK_FOR(`ROWREPT', `0', `21',
`
IF (ROWREPT>=(22-__BIFROST2_TOTAL_ROWS))
        ld      sp, $5822+((21-ROWREPT)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF ROWREPT>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF ROWREPT>17
; additional delay to synchronize with raster beam
IF ROWREPT=18
IFDEF PLUS3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF ROWREPT=21
IFDEF PLUS3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF
')
; race the raster beam to update attributes at the right time
race_raster:
Z88DK_FOR(`ROWREPT', `0', eval(__BIFROST2_TOTAL_ROWS-1),
`
        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(ROWREPT*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(ROWREPT*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(ROWREPT*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(ROWREPT*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IFDEF PLUS3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IFDEF PLUS3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(ROWREPT*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(ROWREPT*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IFDEF PLUS3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(ROWREPT*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(ROWREPT*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(ROWREPT*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(ROWREPT*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(ROWREPT*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(ROWREPT*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(ROWREPT*32)+19), hl     ; columns 19 and 20
')
exit_raster:
; restore stack pointer
        ld      sp, 0

; available entry-point for additional interrupt routines
_BIFROST2_ISR_HOOK:
        ld      hl, 0

; restore all registers
        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af
        exx
        ex      af, af
        pop     hl
        pop     de
        pop     bc
        pop     af
        ei
		  reti

; -----------------------------------------------------------------------------
        defs 64829 - 51625 - ASMPC
; -----------------------------------------------------------------------------
; Instantly fill the tile attributes at specified position with specified value
;
; Parameters:
;   C: attribute value (0-255)
;   D: lin (0-207)
;   E: col (0-20)
;
; Destroys:
;   AF, DE, HL, AF'
;
; Address:
;   64829
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_fillTileAttrH

asm_BIFROST2_fillTileAttrH:
fill_tile_attr:
        ld      (exit_fill+1), sp

        srl     e                               ; E = INT(col/2)
        ld      a, e
        ex      af, af
        inc     e                               ; E = INT(col/2)+1
        xor     a
        ld      l, a                            ; L = 0
        ld      a, e                            ; AL = 256*INT(col/2)+256
        rra
        rr      l                               ; AL = 128*INT(col/2)+128
        add     a, e                            ; AL = 384*INT(col/2)+384
        ld      h, a                            ; HL = 384*INT(col/2)+384

        ld      e, d                            ; E = lin
        ld      d, lookup/512                   ; DE = lookup/2+lin
        add     hl, de                          ; HL = 384*INT(col/2)+384+lookup/2+lin
        add     hl, de                          ; HL = 384*INT(col/2)+384+lookup+2*lin
        ld      sp, hl

        ex      af, af
        jr      nc, fill_even_col

; replace attrib with value
Z88DK_FOR(`LOOP', `1', `16',
`
        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c
')
exit_fill:
        ld      sp, 0
        ret

fill_even_col:
        cp      10
        ld      hl, -384
        jr      z, fill_last_col

; fill right side of tile
Z88DK_FOR(`LOOP', `1', `16',
`
        pop     hl
        ld      (hl), c
')
        and     a
        jr      z, exit_fill

        ld      hl, -(384+32)
fill_last_col:
        add     hl, sp
        ld      sp, hl

; fill left side of tile
Z88DK_FOR(`LOOP', `1', `16',
`
        pop     hl
        inc     hl
        ld      (hl), c
')
        jp      exit_fill

; -----------------------------------------------------------------------------
; Interrupt address at $fdfd
; -----------------------------------------------------------------------------
        jp      main_engine

; -----------------------------------------------------------------------------
; Jump vector table at addresses $fe00-$ff00
; -----------------------------------------------------------------------------
IFNDEF STRIPVECTOR
        defs 257, 0xfd
ELSE
        defb    $fd
ENDIF

; -----------------------------------------------------------------------------
