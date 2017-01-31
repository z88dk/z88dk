include(`z88dk.m4')
include(`clib_target_cfg.asm')

define(`__NIRVANAP_TOTAL_ROWS', ifdef(`__NIRVANAP_TOTAL_ROWS', __NIRVANAP_TOTAL_ROWS, 23))

; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
; ----------------------------------------------------------------

SECTION smc_clib
SECTION smc_nirvanap

PUBLIC asm_NIRVANAP_engine_isr
PUBLIC __NIRVANAP_delay128k, __NIRVANAP_race_raster

asm_NIRVANAP_engine_isr:

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

; ----------------------------------------------------------------

; WIDE SPRITES ENABLED

EXTERN asm_NIRVANAP_drawW

; draw 6 wide tiles
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawW
z88dk_for(`LOOP', `1', `5', 
`
        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAP_drawW+4
')

        jr      skip_wide

		  nop
		  nop
		  nop
		  nop
		  nop
		  nop
		  nop
		  
skip_wide:

        nop                             ; extra delay
		  nop
		  nop
		  nop
		  nop
		  nop
		  nop

; wait for the raster beam
        ld      b, 55-22
        jr      delay_wide
delay_wide:
__NIRVANAP_delay128k:
        ld      b, 57-22

; ----------------------------------------------------------------

ELSE

; ----------------------------------------------------------------

; NORMAL SPRITE SIZE

EXTERN asm_NIRVANAP_drawT

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
__NIRVANAP_delay128k:
        ld      b, 57

; ----------------------------------------------------------------

ENDIF

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
__NIRVANAP_race_raster:
z88dk_for(`ROWREPT', `0', eval(__NIRVANAP_TOTAL_ROWS - 1), 
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
 
SECTION 

; linker inserts isr hooks here

SECTION

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
