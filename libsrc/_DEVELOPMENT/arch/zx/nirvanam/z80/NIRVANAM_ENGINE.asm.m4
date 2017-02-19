include(`z88dk.m4')
include(`config_private.inc')

; -----------------------------------------------------------------------------
; NIRVANA ENGINE (30 columns) - by Einar Saukas
; A Bicolor (Multicolor 8x2) Full-Screen Engine
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

SECTION NIRVANAM

PUBLIC org_nirvanam

IF ((__NIRVANAM_OPTIONS & 0x3) = 0x3)
defc org_nirvanam = 56450
ELSE
IF (__NIRVANAM_OPTIONS & 0x1)
defc org_nirvanam = 56463
ELSE
defc org_nirvanam = 56701
ENDIF
ENDIF

org org_nirvanam

IF ((__NIRVANAM_OPTIONS & 0x3) = 0x3)

; -----------------------------------------------------------------------------
; Internal routine that executes NIRVANA_drawT, but taking as long as
; NIRVANA_drawW. This way, each wide sprite can freely switch between both,
; without affecting timing.
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_drawTW

asm_NIRVANAM_drawTW:
; preserve stack pointer
        ld      (exit_wide+1), sp       ; delay 20T in 4 bytes
        add     hl, hl                  ; delay 11T
        ld      bc, $2c00               ; delay 10T
delay_sprite:
        djnz    delay_sprite            ; delay 567T
        jp      asm_NIRVANAM_drawT      ; execute NIRVANA_drawT with delay 10T

ENDIF

IF (__NIRVANAM_OPTIONS & 0x1)

; -----------------------------------------------------------------------------
; Draw wide tile (24x16 pixels) at specified position (in 2345T)
;
; Params:
;     A = wide tile index (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (1-28)
;
; Address: 56463
;
; IMPORTANT: This routine is disabled by default, recompile this file
;            declaring 'ENABLE_WIDE_DRAW' before calling it!!!
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_drawW
PUBLIC _NIRVANAM_WIDE_IMAGES

asm_NIRVANAM_drawW:
; preserve stack pointer
        ld      (exit_wide+1), sp

; calculate screen bitmap lookup address
        ld      h, bitmaps/256
        ld      l, d
        ld      sp, hl

; preserve values
        ld      b, e
        ld      c, h

; calculate tile image address
        ld      h, 0
        ld      l, a
        ld      e, h
        add     hl, hl
        add     hl, hl
        add     hl, hl
        rra
        rr      e
        rra
        rr      e
        ld      d, a
        add     hl, de
defc _NIRVANAM_WIDE_IMAGES = ASMPC + 1
        ld      de, __NIRVANAM_WIDE_IMAGES
        add     hl, de

; draw bitmap lines
Z88DK_FOR(`LOOP', `1', `8',
`
        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi
        ld      a, (hl)
        ld      (de), a
        inc     hl
        dec     e
        dec     e
        inc     d
        ldi
        ldi
        ldi
')
; calculate routine attribute addresses
        ex      de, hl
        ld      hl, attribs-bitmaps-16
        add     hl, sp
        ld      sp, hl

; set routine attribute offsets
        ld      h, deltas/256
        ld      l, b
        inc     l
        ld      a, (hl)
        ld      (wide_1st+2), a
        inc     l
        ld      a, (hl)
        ld      (wide_2nd+2), a
        inc     l
        ld      a, (hl)
        ld      (wide_3rd+2), a

; set routine attributes
        ld      b, 8
loop_wide:
        pop     ix
        ld      a, (de)
        inc     de
wide_1st:
        ld      (ix+0), a
        ld      a, (de)
        inc     de
wide_2nd:
        ld      (ix+0), a
        ld      a, (de)
        inc     de
wide_3rd:
        ld      (ix+0), a
        djnz    loop_wide

exit_wide:
; restore stack pointer
        ld      sp, 0
        ret

ENDIF

; -----------------------------------------------------------------------------
; Print a 8x8 character at specified position, afterwards paint it with a
; provided sequence of 4 attribute values (in 617T for positions matching
; standard character rows, in 646T otherwise)
;
; Params:
;     A = character code (0-255)
;     BC = attributes address
;     D = pixel line (16-184, even values only)
;     E = char column (1-30)
;
; Address: 56701
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_printC
PUBLIC _NIRVANAM_CHAR_TABLE

asm_NIRVANAM_printC:
; preserve paintC parameters
        push    de
        push    bc

; calculate initial screen bitmap address
        ld      h, bitmaps/256
        ld      l, d
        ld      d, (hl)
        inc     l
        ld      h, (hl)
        ld      l, d
        ld      d, 0
        add     hl, de
        ex      de, hl

; calculate initial character address
        ld      l, a
        add     hl, hl
        add     hl, hl
        add     hl, hl
defc _NIRVANAM_CHAR_TABLE = ASMPC + 1
        ld      bc, __NIRVANAM_CHAR_TABLE
        add     hl, bc

; draw bitmap lines
Z88DK_FOR(`LOOP', `1', `3',
`
        ld      a, (hl)
        ld      (de), a
        inc     hl
        inc     d

        ld      a, (hl)
        ld      (de), a
        inc     hl
        inc     d

        ld      a, d
        and     7
        jr      nz, ASMPC+11
        ld      a, e
        sub     -32
        ld      e, a
        sbc     a, a
        and     -8
        add     a, d
        ld      d, a
')
        ld      a, (hl)
        ld      (de), a
        inc     hl
        inc     d
        ld      a, (hl)
        ld      (de), a

; restore paintC parameters
        pop     bc
        pop     de

; -----------------------------------------------------------------------------
; Paint specified 8x8 block with a sequence of 4 attribute values (in 211T)
;
; Params:
;     BC = attributes address
;     D = pixel line (16-184, even values only)
;     E = char column (1-30)
;
; Address: 56796
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_paintC

asm_NIRVANAM_paintC:
; calculate initial routine attribute address
        ld      h, 0
        ld      l, d
        ld      d, deltas/256
        inc     e
        ld      a, (de)
        ld      de, attribs
        add     hl, de
        add     a, (hl)
        ld      e, a
        inc     l
        adc     a, (hl)
        sub     e
        ld      d, a
        ex      de, hl

; update attributes
        ld      de, 83

        ld      a, (bc)
        ld      (hl), a
        inc     bc
        add     hl, de

        ld      a, (bc)
        ld      (hl), a
        inc     bc
        add     hl, de

        ld      a, (bc)
        ld      (hl), a
        inc     bc
        add     hl, de

        ld      a, (bc)
        ld      (hl), a
        ret

; -----------------------------------------------------------------------------
bitmaps:
; lookup table with screen coordinates
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
Z88DK_FOR(`ROWREPT', 0, eval(__NIRVANAM_TOTAL_ROWS-1),
`
Z88DK_FOR(`LIN2REPT', `0', `3',
`
        defw      16384 + (((ROWREPT+1)/8)*2048) + (LIN2REPT*512) + (((ROWREPT+1)%8)*32)
')
')
Z88DK_FOR(`LOOP', `1', eval(4*(22-__NIRVANAM_TOTAL_ROWS)),
`
        defw      0
')
; -----------------------------------------------------------------------------
attribs:
; lookup table with render attribute coordinates
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
Z88DK_FOR(`RACEREPT', `0', eval((4*__NIRVANAM_TOTAL_ROWS)-1),
`
        defw      race_raster + (RACEREPT*83) - 51
')
Z88DK_FOR(`LOOP', `1', eval(4*(22-__NIRVANAM_TOTAL_ROWS)),
`
        defw      0
')
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
; -----------------------------------------------------------------------------
; Fill specified tile position with attribute value (in 502T)
;
; Params:
;     A = attribute value (0-255)
;     D = pixel line (0-192, even values only)
;     E = char column (0-30)
;
; Address: 57232
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_fillT

asm_NIRVANAM_fillT:
; preserve stack pointer
        ld      (exit_fill+1), sp

; calculate first routine attribute address
        ld      hl, attribs
        ld      b, 0
        ld      c, d                    ; pixel line
        add     hl, bc
        ld      sp, hl

        ld      h, deltas/256
        ld      l, e                    ; char column
        inc     l
        ld      c, (hl)                 ; BC = 1st delta (column offset)
        inc     l
        ld      l, (hl)                 ; HL = 2nd delta (column offset)
        ld      h, b
        sbc     hl, bc
        ex      de, hl                  ; DE = difference between column offsets

; update attribute addresses to specified value
Z88DK_FOR(`LOOP', `1', `8',
`
        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a
')
exit_fill:
; restore stack pointer
        ld      sp, 0
        ret

; -----------------------------------------------------------------------------
; Draw tile at specified position (in 1727T)
;
; Params:
;     A = tile index (0-255)
;     D = pixel line (0-192, even values only)
;     E = char column (0-30)
;
; Address: 57299
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_drawT
PUBLIC _NIRVANAM_TILE_IMAGES

asm_NIRVANAM_drawT:
; preserve stack pointer
        ld      (exit_draw+1), sp

; calculate screen bitmap lookup address
        ld      h, bitmaps/256
        ld      l, d
        ld      sp, hl

; preserve values
        ld      b, e
        ld      c, h

; calculate tile image address
        ld      h, 0
        ld      l, a
        ld      d, h
        ld      e, l
        add     hl, hl
        add     hl, de
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
defc _NIRVANAM_TILE_IMAGES = ASMPC + 1
        ld      de, __NIRVANAM_TILE_IMAGES
        add     hl, de

; draw bitmap lines
Z88DK_FOR(`LOOP', `1', `8',
`
        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ld      a, (hl)
        ld      (de), a
        inc     hl
        dec     e
        inc     d
        ldi
        ldi
')
; calculate routine attribute address
        ex      de, hl

        ld      h, deltas/256
        ld      l, b
        inc     l
        ld      c, (hl)
        inc     l
        ld      a, (hl)
        ex      af, af'

        ld      hl, attribs-bitmaps-16
        ld      b, h
        add     hl, sp
        ld      sp, hl

; set 1st column of routine attributes
Z88DK_FOR(`LOOP', `1', `8',
`
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de
')
        ex      af, af'
        add     a, c
        jr      c, last_column
        sub     c
        ld      c, a
        ld      hl, -16
        add     hl, sp
        ld      sp, hl

; set 2nd column of routine attributes
Z88DK_FOR(`LOOP', `1', `7',
`
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de
')
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a

exit_draw:
; restore stack pointer
        ld      sp, 0
        ret

last_column:
        ld      b, 26
delay_last:
        djnz    delay_last
        jr      exit_draw

; -----------------------------------------------------------------------------

PUBLIC _NIRVANAM_ISR_HOOK

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
        push    ix
        push    iy

IF ((__NIRVANAM_OPTIONS & 0x3) = 0x3)

; draw 6 wide tiles
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW
Z88DK_FOR(`LOOP', `1', `5',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW+4
')
        jr      skip_wide
Z88DK_FOR(`LOOP', `1', `3',
`
        nop
')
skip_wide:
Z88DK_FOR(`LOOP', `1', `11',
`
        nop                             ; extra delay
')
; synchronize with the raster beam
        ld      bc, $0206
        ld      a, 14
        jr      delay_wide
delay_wide:
delay_128k:
        ld      b, $05
		  
ELSE

; draw 8 tiles
Z88DK_FOR(`LOOP', `1', `6',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT
')
Z88DK_FOR(`LOOP', `1', `2',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT+4
')
; synchronize with the raster beam
        ld      bc, $1006
        ld      a, 14
        jr      sync_raster
delay_128k:
        ld      b, $13

ENDIF

sync_raster:
        nop                             ; extra delay
sync_raster_loop:
        djnz    sync_raster_loop
        ld      b, a
        dec     c
        ld      hl, ($4000)             ; synchronize
        jr      nz, sync_raster

; wait for the raster beam
        ld      b, 12
wait_raster:
        djnz    wait_raster

; preserve stack pointer
        ld      (exit_raster+1), sp

        ld      hl, ($4000)             ; synchronize

; race the raster beam to update attributes on screen at the right time
race_raster:
Z88DK_FOR(`ROWREPT', `0', eval(__NIRVANAM_TOTAL_ROWS-1),
`
Z88DK_FOR(`LINREPT', `0', `3',
`
        ld      sp, $5822+(ROWREPT*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(ROWREPT*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(ROWREPT*32)+19   ; reference columns 19 and 20
        ld      ix, 0                       ; columns 17 and 18(*)
        push    de                          ; columns 19 and 20
        ld      de, 0                       ; columns 13 and 14(*)
        ld      bc, 0                       ; columns 15 and 16(*)
        push    ix                          ; columns 17 and 18
        push    bc                          ; columns 15 and 16
        push    de                          ; columns 13 and 14
        push    hl                          ; columns 11 and 12
        exx
        push    bc                          ; columns 9 and 10
        push    de                          ; columns 7 and 8
        ld      sp, $5822+(ROWREPT*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(ROWREPT*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay
')
')
exit_raster:
; restore stack pointer
        ld      sp, 0

; available entry-point for additional interrupt routines
_NIRVANAM_ISR_HOOK:
        ld      hl, 0

; restore all registers
        pop     iy
        pop     ix
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
        ei
		  reti

; -----------------------------------------------------------------------------
; Insert Space Here
; -----------------------------------------------------------------------------

defs 64995 - org_nirvanam - ASMPC

; -----------------------------------------------------------------------------
; Activate NIRVANA engine.
;
; Address: 64995
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_start

asm_NIRVANAM_start:
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
; Deactivate NIRVANA engine.
;
; Address: 65012
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_stop

asm_NIRVANAM_stop:
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
deltas:
; lookup table with deltas (column offsets)
        defb      75, 75, 76, 71, 72, 79, 80, 58, 59, 61, 62, 65, 66, 97, 98, 100, 101
        defb      93, 94, 68, 69, 115, 116, 118, 119, 121, 122, 55, 56, 127, 128, 128

; -----------------------------------------------------------------------------
; Fill specified 8x8 block with attribute value (in 165T)
;
; Params:
;     C = attribute value (0-255)
;     D = pixel line (16-184, even values only)
;     E = char column (1-30)
;
; Address: 65313
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_fillC

asm_NIRVANAM_fillC:
; calculate initial routine attribute address
        ld      h, 0
        ld      l, d
        ld      d, deltas/256
        inc     e
        ld      a, (de)
        ld      de, attribs
        add     hl, de
        add     a, (hl)
        ld      e, a
        inc     l
        adc     a, (hl)
        sub     e
        ld      d, a
        ex      de, hl

; update attributes
        ld      de, 83

        ld      (hl), c
        add     hl, de

        ld      (hl), c
        add     hl, de

        ld      (hl), c
        add     hl, de

        ld      (hl), c
        ret

; -----------------------------------------------------------------------------
; Retrieve a sequence of 4 attribute values from specified 8x8 block (in 211T)
;
; Params:
;     D = pixel line (16-184, even values only)
;     E = char column (1-30)
;     BC = attributes address
;
; Address: 65342
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAM_readC

asm_NIRVANAM_readC:
; calculate initial routine attribute address
        ld      h, 0
        ld      l, d
        ld      d, deltas/256
        inc     e
        ld      a, (de)
        ld      de, attribs
        add     hl, de
        add     a, (hl)
        ld      e, a
        inc     l
        adc     a, (hl)
        sub     e
        ld      d, a
        ex      de, hl

; read attributes
        ld      de, 83

        ld      a, (hl)
        ld      (bc), a
        inc     bc
        add     hl, de

        ld      a, (hl)
        ld      (bc), a
        inc     bc
        add     hl, de

        ld      a, (hl)
        ld      (bc), a
        inc     bc
        add     hl, de

        ld      a, (hl)
        ld      (bc), a
        ret
