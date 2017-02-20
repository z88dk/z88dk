include(`z88dk.m4')
include(`config_private.inc')

; -----------------------------------------------------------------------------
; NIRVANA+ ENGINE (32 columns) - by Einar Saukas
; A Bicolor (Multicolor 8x2) Full-Screen Engine
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

SECTION NIRVANAP

PUBLIC org_nirvanap

IF ((__NIRVANAP_OPTIONS & 0x3) = 0x3)
defc org_nirvanap = 56073
ELSE
IF (__NIRVANAP_OPTIONS & 0x1)
defc org_nirvanap = 56085
ELSE
defc org_nirvanap = 56323
ENDIF
ENDIF

org org_nirvanap

IF ((__NIRVANAP_OPTIONS & 0x3) = 0x3)

; -----------------------------------------------------------------------------
; Internal routine that executes NIRVANA_drawT, but taking as long as
; NIRVANA_drawW. This way, each wide sprite can freely switch between both,
; without affecting timing.
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAP_drawTW

asm_NIRVANAP_drawTW:
; preserve stack pointer
        ld      (exit_wide+1), sp       ; delay 20T in 4 bytes
        ld      bc, $2e00               ; delay 10T
delay_sprite:
        djnz    delay_sprite            ; delay 593T
        jp      asm_NIRVANAP_drawT      ; execute NIRVANA_drawT with delay 10T

ENDIF

IF (__NIRVANAP_OPTIONS & 0x1)

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

PUBLIC asm_NIRVANAP_drawW
PUBLIC _NIRVANAP_WIDE_IMAGES

asm_NIRVANAP_drawW:
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
defc _NIRVANAP_WIDE_IMAGES = ASMPC + 1
        ld      de, __NIRVANAP_WIDE_IMAGES
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
        ld      hl, attribs - bitmaps - 16
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
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;
; Address: 56323
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAP_printC
PUBLIC _NIRVANAP_CHAR_TABLE

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
defc _NIRVANAP_CHAR_TABLE = ASMPC + 1
        ld      bc, __NIRVANAP_CHAR_TABLE
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
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;
; Address: 56418
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAP_paintC

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

PUBLIC _NIRVANAP_ISR_HOOK

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

IF ((__NIRVANAP_OPTIONS & 0x3) = 0x3)

; draw 6 wide tiles
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawW
Z88DK_FOR(`LOOP', `1', `5',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawW+4
')
        jr      skip_wide
Z88DK_FOR(`LOOP', `1', `7',
`
        nop
')
skip_wide:
Z88DK_FOR(`LOOP', `1', `7',
`
        nop                             ; extra delay
')

; wait for the raster beam
        ld      b, 55-22
        jr      delay_wide
delay_128k:
delay_wide:
        ld      b, 57-22

ELSE

; draw 8 tiles
Z88DK_FOR(`LOOP', `1', `6',
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawT
')
Z88DK_FOR(`LOOP', `1', `2',
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

ENDIF

wait_raster:
        djnz    wait_raster

; preserve stack pointer
        ld      (exit_raster+1), sp

IF (__SPECTRUM & __SPECTRUM_PENTAGON)

; synchronize with raster beam
; pentagon timing

        ld      b, 92                       ; extra delay
        djnz	ASMPC                        ; extra delay
        djnz	ASMPC                        ; extra delay
        nop                                 ; extra delay
        nop                                 ; extra delay
        jp      race_raster

		  defs 56693 - org_nirvanap - ASMPC

; race the raster beam to update attributes on screen at the right time
race_raster:
        ld      a, 4
Z88DK_FOR(`ROWREPT', `0', eval(__NIRVANAP_TOTAL_ROWS-1),
`
Z88DK_FOR(`LINREPT', `0', `3',
`
        ld      c, a                        ; extra delay
        dec     c                           ; extra delay
        jr      nz, ASMPC-1                 ; extra delay
        inc     bc                          ; extra delay

        ld      sp, $5822+(ROWREPT*32)+6    ; reference columns 6 and 7
        ld      hl, 0                       ; attributes for columns 14 and 15
        ld      de, 0                       ; attributes for columns 16 and 17
        ld      bc, 0                       ; attributes for columns 18 and 19
        exx
        ld      hl, 0                       ; attributes for columns 0 and 1
        ld      de, 0                       ; attributes for columns 4 and 5
        ld      bc, 0                       ; attributes for columns 6 and 7
        ld      ($5820+(ROWREPT*32)), hl    ; update columns 0 and 1
        ld      hl, 0                       ; attributes for columns 2 and 3
        push    bc                          ; update columns 6 and 7
        push    de                          ; update columns 4 and 5
        push    hl                          ; update columns 2 and 3
        ld      sp, $5822+(ROWREPT*32)+24   ; reference columns 24 and 25
        ld      hl, 0                       ; attributes for columns 20 and 21
        ld      de, 0                       ; attributes for columns 22 and 23
        ld      bc, 0                       ; attributes for columns 24 and 25
        push    bc                          ; update columns 24 and 25
        push    de                          ; update columns 22 and 23
        push    hl                          ; update columns 20 and 21
        exx
        push    bc                          ; update columns 18 and 19
        push    de                          ; update columns 16 and 17
        push    hl                          ; update columns 14 and 15
        ld      hl, 0                       ; attributes for columns 8 and 9
        ld      de, 0                       ; attributes for columns 10 and 11
        ld      bc, 0                       ; attributes for columns 12 and 13
        push    bc                          ; update columns 12 and 13
        push    de                          ; update columns 10 and 11
        push    hl                          ; update columns 8 and 9
        ld      sp, $5822+(ROWREPT*32)+30   ; reference columns 30 and 31
        ld      hl, 0                       ; attributes for columns 26 and 27
        ld      de, 0                       ; attributes for columns 28 and 29
        ld      bc, 0                       ; attributes for columns 30 and 31
        push    bc                          ; update columns 30 and 31
        push    de                          ; update columns 28 and 29
        push    hl                          ; update columns 26 and 27
')
')

ELSE

; synchronize with raster beam while updating first attribute pair of each row
; spectrum 48k/128k timing
Z88DK_FOR(`ROWREPT', `0', `22',
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
Z88DK_FOR(`ROWREPT', `0', eval(__NIRVANAP_TOTAL_ROWS-1),
`
Z88DK_FOR(`LINREPT', `0', `3',
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

ENDIF

exit_raster:
; restore stack pointer
        ld      sp, 0

; available entry-point for additional interrupt routines
_NIRVANAP_ISR_HOOK:
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

defs 64262 - org_nirvanap - ASMPC

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

PUBLIC asm_NIRVANAP_drawT
PUBLIC _NIRVANAP_TILE_IMAGES

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
defc _NIRVANAP_TILE_IMAGES = ASMPC + 1
        ld      de, __NIRVANAP_TILE_IMAGES
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

        ld      hl, attribs - bitmaps - 16
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

; -----------------------------------------------------------------------------
bitmaps:
; lookup table with screen coordinates
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
Z88DK_FOR(`ROWREPT', `0', eval(__NIRVANAP_TOTAL_ROWS-1),
`
Z88DK_FOR(`LIN2REPT', `0', `3',
`
        defw      16384 + (((ROWREPT+1)/8)*2048) + (LIN2REPT*512) + (((ROWREPT+1)%8)*32)
')
')

Z88DK_FOR(`LOOP', `1', eval(4*(23-__NIRVANAP_TOTAL_ROWS)),
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
Z88DK_FOR(`RACEREPT', `0', eval(4*__NIRVANAP_TOTAL_ROWS-1),
`
        defw      race_raster + (RACEREPT*82)
')
Z88DK_FOR(`LOOP', `1', eval(4*(23-__NIRVANAP_TOTAL_ROWS)),
`
        defw      0
')
Z88DK_FOR(`LOOP', `1', `8',
`
        defw      0
')
; -----------------------------------------------------------------------------
; Insert Space Here
; -----------------------------------------------------------------------------

defs 64928 - org_nirvanap - ASMPC

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

PUBLIC asm_NIRVANAP_fillT

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
; Activate NIRVANA engine.
;
; Address: 64995
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAP_start

asm_NIRVANAP_start:
        di
IF ((__SPECTRUM & __SPECTRUM_PENTAGON) = 0)
        ld      a, ($004c)
        and     2
        ld      (delay_128k-1), a
ENDIF
        ld      a, $fe
        ld      i, a
        im      2
        ei
        ret
; -----------------------------------------------------------------------------
; Insert Space Here
; -----------------------------------------------------------------------------

defs 65012 - org_nirvanap - ASMPC

; -----------------------------------------------------------------------------
; Deactivate NIRVANA engine.
;
; Address: 65012
; -----------------------------------------------------------------------------

PUBLIC asm_NIRVANAP_stop

asm_NIRVANAP_stop:
        di
        ld      a, $3f
        ld      i, a
        im      1
        ei
        ret

; -----------------------------------------------------------------------------
; Insert Space Here
; -----------------------------------------------------------------------------

defs 0xfdfd - org_nirvanap - ASMPC

; -----------------------------------------------------------------------------
; interrupt address at $fdfd
        jp      main_engine

; -----------------------------------------------------------------------------
; jump vector table at addresses $fe00-$ff00
        defs 257, 0xfd

; -----------------------------------------------------------------------------
deltas:
IF (__SPECTRUM & __SPECTRUM_PENTAGON)
; lookup table with deltas (column offsets)
; pentagon
        defb      21, 22, 33, 34, 24, 25, 27, 28, 58, 59, 61, 62, 64, 65, 11, 12
        defb      14, 15, 17, 18, 42, 43, 45, 46, 48, 49, 73, 74, 76, 77, 79, 80
ELSE
; lookup table with deltas (column offsets)
        defb      25, 26, 32, 33, 38, 39, 58, 59, 9, 10, 12, 13, 15, 16, 2, 3
        defb      19, 20, 22, 23, 44, 45, 6, 7, 65, 66, 68, 69, 71, 72, 77, 78
ENDIF
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

PUBLIC asm_NIRVANAP_fillC

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

PUBLIC asm_NIRVANAP_readC

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
