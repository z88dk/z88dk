include(`z88dk.m4')
include(`clib_target_cfg.asm')

define(`__NIRVANAP_TOTAL_ROWS', ifdef(`__NIRVANAP_TOTAL_ROWS', __NIRVANAP_TOTAL_ROWS, 23))

; -----------------------------------------------------------------------------
; NIRVANA+ ENGINE (32 columns) - by Einar Saukas
; A Bicolor (Multicolor 8x2) Full-Screen Engine
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

SECTION NIRVANAP
org 56323
SECTION nirvanap_isr
SECTION nirvanap_continue

SECTION NIRVANAP

PUBLIC __NIRVANAP_CHAR_TABLE
PUBLIC __NIRVANAP_TILE_IMAGES

; -----------------------------------------------------------------------------
; Print a 8x8 character at specified position, afterwards paint it with a
; provided sequence of 4 attribute values (in 617T for positions matching
; standard character rows, in 646T otherwise)
;
; Params:
;     A = character code (0-255)
;     BC = attributes address
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;
; Address: 56323
; -----------------------------------------------------------------------------
asm_NIRVANAP_printC:
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
defc __NIRVANAP_CHAR_TABLE = ASMPC + 1
        ld      bc, 15360
        add     hl, bc

; draw bitmap lines
z88dk_for(`LOOP', `1', `3',
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
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;
; Address: 56418
; -----------------------------------------------------------------------------
asm_NIRVANAP_paintC:
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
        ld      de, 82

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
asm_NIRVANAP_engine_isr:
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

; draw 8 tiles
z88dk_for(`LOOP', `1', `6',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawT
')
z88dk_for(`LOOP', `1', `2',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawT+4
')

; wait for the raster beam
        ld      b, 55
        jr      delay_128k
delay_128k:
        ld      b, 57
wait_raster:
        djnz    wait_raster

; preserve stack pointer
        ld      (exit_raster+1), sp

; synchronize with raster beam while updating first attribute pair of each row
z88dk_for(`ROWREPT', `0', `22',
`
IF ((ROWREPT = 4) || (ROWREPT = 9) || (ROWREPT = 14))
        ld      b, 3
        djnz    ASMPC                   ; extra delay
ELSE
IF (ROWREPT = 20)
        nop                             ; extra delay
ENDIF
ENDIF

        ld      hl, (race_raster+(ROWREPT*328)+25)
IF (ROWREPT < __NIRVANAP_TOTAL_ROWS)
        ld      ($5820+(ROWREPT*32)), hl
ELSE
        ld      hl, ($5820+(ROWREPT*32))
ENDIF
')

; race the raster beam to update attributes on screen at the right time
race_raster:
z88dk_for(`ROWREPT', `0', eval(__NIRVANAP_TOTAL_ROWS-1),
`
z88dk_for(`LINREPT', `0', `3',
`
        ld      ix, 0                       ; attributes for columns 14 and 15
        ld      iy, 0                       ; attributes for columns 22 and 23
        ld      bc, 0                       ; attributes for columns 8 and 9
        ld      de, 0                       ; attributes for columns 10 and 11
        ld      hl, 0                       ; attributes for columns 12 and 13
        exx
        ld      bc, 0                       ; attributes for columns 16 and 17
        ld      de, 0                       ; attributes for columns 18 and 19
        ld      hl, 0                       ; attributes for columns 0 and 1
IF (LINREPT = 0)
        ld      sp, $5822+(ROWREPT*32)+24   ; reference columns 24 and 25 on next row
        push    hl                          ; trash columns 24 and 25 (fixed below)
ELSE
        ld      a, (hl)                     ; extra delay
        ld      ($5820+(ROWREPT*32)), hl    ; update columns 0 and 1
ENDIF
        ld      hl, 0                       ; attributes for columns 2 and 3
        ld      ($5820+(ROWREPT*32)+2), hl  ; update columns 2 and 3
        ld      hl, 0                       ; attributes for columns 4 and 5
        ld      ($5820+(ROWREPT*32)+4),hl   ; update columns 4 and 5
        ld      hl, 0                       ; attributes for columns 20 and 21
        push    iy                          ; update columns 22 and 23
        push    hl                          ; update columns 20 and 21
        push    de                          ; update columns 18 and 19
        push    bc                          ; update columns 16 and 17
        exx
        push    ix                          ; update columns 14 and 15
        push    hl                          ; update columns 12 and 13
        push    de                          ; update columns 10 and 11
        push    bc                          ; update columns 8 and 9
        ld      hl, 0                       ; attributes for columns 6 and 7
        push    hl                          ; update columns 6 and 7
        ld      sp, $5822+(ROWREPT*32)+28   ; reference columns 28 and 29
        ld      bc, 0                       ; attributes for columns 24 and 25
        ld      de, 0                       ; attributes for columns 26 and 27
        ld      hl, 0                       ; attributes for columns 28 and 29
        push    hl                          ; update columns 28 and 29
        push    de                          ; update columns 26 and 27
        push    bc                          ; update columns 24 and 25
        ld      hl, 0                       ; attributes for columns 30 and 31
        ld      ($5820+(ROWREPT*32)+30),hl  ; update columns 30 and 31
')
')

exit_raster:
; restore stack pointer
        ld      sp, 0

; available entry-point for additional interrupt routines
SECTION nirvanap_isr
SECTION nirvanap_continue

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

defs 64262 - asm_NIRVANAP_drawT

; -----------------------------------------------------------------------------
; Draw tile at specified position (in 1712T)
;
; Params:
;     A = tile index (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (0-30)
;
; Address: 64262
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; -----------------------------------------------------------------------------

asm_NIRVANAP_drawT:
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
defc __NIRVANAP_TILE_IMAGES = ASMPC + 1
        ld      de, 48000
        add     hl, de

; draw bitmap lines
z88dk_for(`LOOP', `1', `8',
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

        ld      hl, attribs - bitmaps - 16
        ld      b, h
        add     hl, sp
        ld      sp, hl

; set 1st column of routine attributes
z88dk_for(`LOOP', `1', `8',
`
        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de
')
        ex      af, af'
        ld      c, a
        ld      hl, -16
        add     hl, sp
        ld      sp, hl

; set 2nd column of routine attributes
z88dk_for(`LOOP', `1', `7',
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

; -----------------------------------------------------------------------------
bitmaps:
; lookup table with screen coordinates
z88dk_for(`LOOP', `1', `8',
`
        defw      0
')
z88dk_for(`ROWREPT', `0', eval(__NIRVANAP_TOTAL_ROWS-1),
`
z88dk_for(`LIN2REPT', `0', `3',
`
        defw      16384 + ((ROWREPT+1)/8)*2048 + LIN2REPT*512 + ((ROWREPT+1)%8)*32
')
')

z88dk_for(`LOOP', `1', eval(4*(23-__NIRVANAP_TOTAL_ROWS)),
`
        defw      0
')
; -----------------------------------------------------------------------------
attribs:
; lookup table with render attribute coordinates
z88dk_for(`LOOP', `1', `8',
`
        defw      0
')
z88dk_for(`RACEREPT', `0', eval(4*__NIRVANAP_TOTAL_ROWS-1),
`
        defw      race_raster + (RACEREPT*82)
')
z88dk_for(`LOOP', `1', eval(4*(23-__NIRVANAP_TOTAL_ROWS)),
`
        defw      0
')

; -----------------------------------------------------------------------------
; Insert Space Here
; -----------------------------------------------------------------------------

defs 64928 - asm_NIRVANAP_fillT

; -----------------------------------------------------------------------------
; Fill specified tile position with attribute value (in 502T)
;
; Params:
;     A = attribute value (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (0-30)
;
; Address: 64928
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; -----------------------------------------------------------------------------
asm_NIRVANAP_fillT:
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
z88dk_for(`LOOP', `1', `8',
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
; Activate NIRVANA engine.
;
; Address: 64995
; -----------------------------------------------------------------------------
asm_NIRVANAP_start:
        ld      a, ($004c)
        and     2
        ld      (delay_128k-1), a
        ret

; -----------------------------------------------------------------------------
; Deactivate NIRVANA engine.
; -----------------------------------------------------------------------------
asm_NIRVANAP_stop:
        di
        ret

; -----------------------------------------------------------------------------
; Insert Space Here
; -----------------------------------------------------------------------------

defs 0xfdfd - interrupt_hook

; -----------------------------------------------------------------------------
; interrupt address at $fdfd
interrupt_hook:
        jp      main_engine

; -----------------------------------------------------------------------------
; jump vector table at addresses $fe00-$ff00
        defs 257, 0xfd

; -----------------------------------------------------------------------------
deltas:
; lookup table with deltas (column offsets)
        db      25, 26, 32, 33, 38, 39, 58, 59, 9, 10, 12, 13, 15, 16, 2, 3
        db      19, 20, 22, 23, 44, 45, 6, 7, 65, 66, 68, 69, 71, 72, 77, 78

; -----------------------------------------------------------------------------
; Fill specified 8x8 block with attribute value (in 165T)
;
; Params:
;     C = attribute value (0-255)
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;
; Address: 65313
; -----------------------------------------------------------------------------
asm_NIRVANAP_fillC:
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
        ld      de, 82

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
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;     BC = attributes address
;
; Address: 65342
; -----------------------------------------------------------------------------
asm_NIRVANAP_readC:
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
        ld      de, 82

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

IF (DEFINED ENABLE_WIDE_DRAW)
; -----------------------------------------------------------------------------
; Draw wide tile (24x16 pixels) at specified position (in 2345T)
;
; Params:
;     A = wide tile index (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (0-29)
;
; Address: 56085
;
; IMPORTANT: This routine is disabled by default, recompile this file
;            declaring 'ENABLE_WIDE_DRAW' before calling it!!!
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; -----------------------------------------------------------------------------
        org     56085

NIRVANA_drawW:
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
        ld      de, WIDE_IMAGES
        add     hl, de

; draw bitmap lines
REPT 8
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
ENDM

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

IF (DEFINED ENABLE_WIDE_SPRITE)
; -----------------------------------------------------------------------------
; Internal routine that executes NIRVANA_drawT, but taking as long as
; NIRVANA_drawW. This way, each wide sprite can freely switch between both,
; without affecting timing.
; -----------------------------------------------------------------------------
        org     56073

NIRVANA_drawTW:
; preserve stack pointer
        ld      (exit_wide+1), sp       ; delay 20T in 4 bytes
        ld      bc, $2e00               ; delay 10T
delay_sprite:
        djnz    delay_sprite            ; delay 593T
        jp      NIRVANA_drawT           ; execute NIRVANA_drawT with delay 10T

; -----------------------------------------------------------------------------
; Automatically draw 6 wide tile sprites (24x16 pixels) during upper border,
; instead of 8 bicolor tile sprites (16x16 pixels).
;
; IMPORTANT: Recompile this file declaring 'ENABLE_WIDE_SPRITE' to replace
;            standard bicolor tile sprites with wide tile sprites.
;
; WARNING: Remember you will only have 6 sprites (numbered from 0 to 5)
; -----------------------------------------------------------------------------
        org     56468

; draw 6 wide tiles
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    NIRVANA_drawW
REPT 5
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    NIRVANA_drawW+4
ENDM

        jr      skip_wide
REPT 7
        nop
ENDM
skip_wide:
REPT 7
        nop                             ; extra delay
ENDM

; wait for the raster beam
        ld      b, 55-22
        jr      delay_wide
delay_wide:
        ld      b, 57-22
ENDIF
ENDIF

; -----------------------------------------------------------------------------
