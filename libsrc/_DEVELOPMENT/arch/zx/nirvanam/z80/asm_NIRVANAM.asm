

IF !_CLIB_TARGET_CFG_ASM_
defc _CLIB_TARGET_CFG_ASM_ = 1

; ********************************************************************
; IF YOU MAKE CHANGES TO THIS FILE YOU MUST RECOMPILE THE ZX LIBRARIES
; ********************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ZX SPECTRUM - TARGET CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------------------------
;-- ARCHITECTURE CONSTANTS ------------------------------------
;--------------------------------------------------------------

defc __spectrum     = 1

; 1 = spectrum 48k
; 2 = spectrum 128k
; 3 = pentagon

defc __clock_freq   = 3500000          ; Hz

defc __z80_cpu_info = $01

; bit 0 = $01 = if set indicates an nmos z80 (if unsure set it)
; bit 1 = $02 = allow undocumented instruction "sll r"


;--------------------------------------------------------------
;-- GAMES/NIRVANA- --------------------------------------------
;--------------------------------------------------------------

defc __NIRVANAM_OPTIONS = 0

; bit 0 = $01 = enable wide draw
; bit 1 = $02 = enable wide sprites

;;

; total number of rows drawn by nirvana- 1-22
; do not uncomment - this is an m4 define

defc __NIRVANAM_TILE_IMAGES = 48000  ; default location of bicolour tiles (16x16 pix, 48 bytes each)
defc __NIRVANAM_WIDE_IMAGES = 54000  ; default location of wide tiles (24x16 pix, 72 bytes each)
defc __NIRVANAM_CHAR_TABLE  = 15360  ; default location of character set (8x8 pix, 8 bytes each)


;--------------------------------------------------------------
;-- GAMES/NIRVANA+ --------------------------------------------
;--------------------------------------------------------------

defc __NIRVANAP_OPTIONS = 0

; bit 0 = $01 = enable wide draw
; bit 1 = $02 = enable wide sprites

;;

; total number of rows drawn by nirvana+ 1-23
; do not uncomment - this is an m4 define

defc __NIRVANAP_TILE_IMAGES = 48000  ; default location of bicolour tiles (16x16 pix, 48 bytes each)
defc __NIRVANAP_WIDE_IMAGES = 54000  ; default location of wide tiles (24x16 pix, 72 bytes each)
defc __NIRVANAP_CHAR_TABLE  = 15360  ; default location of character set (8x8 pix, 8 bytes each)


;--------------------------------------------------------------
;-- GAMES/SP1 -------------------------------------------------
;--------------------------------------------------------------

; display characteristics

defc SP1V_DISPORIGX     = 0            ; x coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPORIGY     = 0            ; y coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPWIDTH     = 32           ; width of area managed by sp1 in characters (16, 24, 32 ok as of now)
defc SP1V_DISPHEIGHT    = 24           ; height of area managed by sp1 in characters

; buffers

defc SP1V_PIXELBUFFER   = $d1f7        ; address of an 8-byte buffer to hold intermediate pixel-draw results
defc SP1V_ATTRBUFFER    = $d1ff        ; address of a single byte buffer to hold intermediate colour-draw results

; data structure locations

defc SP1V_TILEARRAY     = $f000        ; address of the 512-byte tile array associating character codes with tile graphics, must lie on 256-byte boundary (LSB=0)
defc SP1V_UPDATEARRAY   = $d200        ; address of the 10*SP1V_DISPWIDTH*SP1V_DISPHEIGHT byte update array
defc SP1V_ROTTBL        = $f000        ; location of the 3584-byte rotation table.  Must lie on 256-byte boundary (LSB=0).  Table begins $0200 bytes ahead of this
                                       ;  pointer ($f200-$ffff in this default case).  Set to $0000 if the table is not needed (if, for example, all sprites
                                       ;  are drawn at exact horizontal character coordinates or you use pre-shifted sprites only).
; sp1 variables

defc SP1V_UPDATELISTH   = $d1ed        ; address of 10-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $d1ef        ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn

; note: SP1V_UPDATELISTT is located inside the dummy struct_sp1_update pointed at by SP1V_UPDATELISTH

; default memory map

; With these default settings the memory map is:
;
; ADDRESS (HEX)   LIBRARY  DESCRIPTION
;
; f200 - ffff     SP1.LIB  horizontal rotation tables
; f000 - f1ff     SP1.LIB  tile array
; d200 - efff     SP1.LIB  update array for full size screen 32x24
; d1ff - d1ff     SP1.LIB  attribute buffer
; d1f7 - d1fe     SP1.LIB  pixel buffer
; d1ed - d1f6     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
;  * d1ef - d1f0  SP1.LIB  update list tail pointer (inside dummy struct sp1_update)
; d1d4 - d1ec     --free-  25 bytes free
; d1d1 - d1d3     -------  JP to im2 service routine (im2 table filled with 0xd1 bytes)
; d101 - d1d0     --free-  208 bytes
; d000 - d100     IM2.LIB  im 2 vector table (257 bytes)
; ce00 - cfff     -------  z80 stack (512 bytes) set SP=d000


;--------------------------------------------------------------
;-- SOUND/BIT -------------------------------------------------
;--------------------------------------------------------------

; 1-bit sound constants

defc __sound_bit_method       = 1      ; 1 = port_8, 2 = port_16, 3 = memory
defc __sound_bit_port         = $fe    ; port or memory address
defc __sound_bit_toggle       = $10    ; bits to toggle to make noise
defc __sound_bit_toggle_pos   = 4      ; bit position to test state of output
defc __sound_bit_read_mask    = $17    ; part of state byte to be used in output
defc __sound_bit_write_mask   = $e8    ; part of state byte to be preserved on write

ENDIF




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

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0



        defw      16384 + (((0+1)/8)*2048) + (0*512) + (((0+1)%8)*32)

        defw      16384 + (((0+1)/8)*2048) + (1*512) + (((0+1)%8)*32)

        defw      16384 + (((0+1)/8)*2048) + (2*512) + (((0+1)%8)*32)

        defw      16384 + (((0+1)/8)*2048) + (3*512) + (((0+1)%8)*32)



        defw      16384 + (((1+1)/8)*2048) + (0*512) + (((1+1)%8)*32)

        defw      16384 + (((1+1)/8)*2048) + (1*512) + (((1+1)%8)*32)

        defw      16384 + (((1+1)/8)*2048) + (2*512) + (((1+1)%8)*32)

        defw      16384 + (((1+1)/8)*2048) + (3*512) + (((1+1)%8)*32)



        defw      16384 + (((2+1)/8)*2048) + (0*512) + (((2+1)%8)*32)

        defw      16384 + (((2+1)/8)*2048) + (1*512) + (((2+1)%8)*32)

        defw      16384 + (((2+1)/8)*2048) + (2*512) + (((2+1)%8)*32)

        defw      16384 + (((2+1)/8)*2048) + (3*512) + (((2+1)%8)*32)



        defw      16384 + (((3+1)/8)*2048) + (0*512) + (((3+1)%8)*32)

        defw      16384 + (((3+1)/8)*2048) + (1*512) + (((3+1)%8)*32)

        defw      16384 + (((3+1)/8)*2048) + (2*512) + (((3+1)%8)*32)

        defw      16384 + (((3+1)/8)*2048) + (3*512) + (((3+1)%8)*32)



        defw      16384 + (((4+1)/8)*2048) + (0*512) + (((4+1)%8)*32)

        defw      16384 + (((4+1)/8)*2048) + (1*512) + (((4+1)%8)*32)

        defw      16384 + (((4+1)/8)*2048) + (2*512) + (((4+1)%8)*32)

        defw      16384 + (((4+1)/8)*2048) + (3*512) + (((4+1)%8)*32)



        defw      16384 + (((5+1)/8)*2048) + (0*512) + (((5+1)%8)*32)

        defw      16384 + (((5+1)/8)*2048) + (1*512) + (((5+1)%8)*32)

        defw      16384 + (((5+1)/8)*2048) + (2*512) + (((5+1)%8)*32)

        defw      16384 + (((5+1)/8)*2048) + (3*512) + (((5+1)%8)*32)



        defw      16384 + (((6+1)/8)*2048) + (0*512) + (((6+1)%8)*32)

        defw      16384 + (((6+1)/8)*2048) + (1*512) + (((6+1)%8)*32)

        defw      16384 + (((6+1)/8)*2048) + (2*512) + (((6+1)%8)*32)

        defw      16384 + (((6+1)/8)*2048) + (3*512) + (((6+1)%8)*32)



        defw      16384 + (((7+1)/8)*2048) + (0*512) + (((7+1)%8)*32)

        defw      16384 + (((7+1)/8)*2048) + (1*512) + (((7+1)%8)*32)

        defw      16384 + (((7+1)/8)*2048) + (2*512) + (((7+1)%8)*32)

        defw      16384 + (((7+1)/8)*2048) + (3*512) + (((7+1)%8)*32)



        defw      16384 + (((8+1)/8)*2048) + (0*512) + (((8+1)%8)*32)

        defw      16384 + (((8+1)/8)*2048) + (1*512) + (((8+1)%8)*32)

        defw      16384 + (((8+1)/8)*2048) + (2*512) + (((8+1)%8)*32)

        defw      16384 + (((8+1)/8)*2048) + (3*512) + (((8+1)%8)*32)



        defw      16384 + (((9+1)/8)*2048) + (0*512) + (((9+1)%8)*32)

        defw      16384 + (((9+1)/8)*2048) + (1*512) + (((9+1)%8)*32)

        defw      16384 + (((9+1)/8)*2048) + (2*512) + (((9+1)%8)*32)

        defw      16384 + (((9+1)/8)*2048) + (3*512) + (((9+1)%8)*32)



        defw      16384 + (((10+1)/8)*2048) + (0*512) + (((10+1)%8)*32)

        defw      16384 + (((10+1)/8)*2048) + (1*512) + (((10+1)%8)*32)

        defw      16384 + (((10+1)/8)*2048) + (2*512) + (((10+1)%8)*32)

        defw      16384 + (((10+1)/8)*2048) + (3*512) + (((10+1)%8)*32)



        defw      16384 + (((11+1)/8)*2048) + (0*512) + (((11+1)%8)*32)

        defw      16384 + (((11+1)/8)*2048) + (1*512) + (((11+1)%8)*32)

        defw      16384 + (((11+1)/8)*2048) + (2*512) + (((11+1)%8)*32)

        defw      16384 + (((11+1)/8)*2048) + (3*512) + (((11+1)%8)*32)



        defw      16384 + (((12+1)/8)*2048) + (0*512) + (((12+1)%8)*32)

        defw      16384 + (((12+1)/8)*2048) + (1*512) + (((12+1)%8)*32)

        defw      16384 + (((12+1)/8)*2048) + (2*512) + (((12+1)%8)*32)

        defw      16384 + (((12+1)/8)*2048) + (3*512) + (((12+1)%8)*32)



        defw      16384 + (((13+1)/8)*2048) + (0*512) + (((13+1)%8)*32)

        defw      16384 + (((13+1)/8)*2048) + (1*512) + (((13+1)%8)*32)

        defw      16384 + (((13+1)/8)*2048) + (2*512) + (((13+1)%8)*32)

        defw      16384 + (((13+1)/8)*2048) + (3*512) + (((13+1)%8)*32)



        defw      16384 + (((14+1)/8)*2048) + (0*512) + (((14+1)%8)*32)

        defw      16384 + (((14+1)/8)*2048) + (1*512) + (((14+1)%8)*32)

        defw      16384 + (((14+1)/8)*2048) + (2*512) + (((14+1)%8)*32)

        defw      16384 + (((14+1)/8)*2048) + (3*512) + (((14+1)%8)*32)



        defw      16384 + (((15+1)/8)*2048) + (0*512) + (((15+1)%8)*32)

        defw      16384 + (((15+1)/8)*2048) + (1*512) + (((15+1)%8)*32)

        defw      16384 + (((15+1)/8)*2048) + (2*512) + (((15+1)%8)*32)

        defw      16384 + (((15+1)/8)*2048) + (3*512) + (((15+1)%8)*32)



        defw      16384 + (((16+1)/8)*2048) + (0*512) + (((16+1)%8)*32)

        defw      16384 + (((16+1)/8)*2048) + (1*512) + (((16+1)%8)*32)

        defw      16384 + (((16+1)/8)*2048) + (2*512) + (((16+1)%8)*32)

        defw      16384 + (((16+1)/8)*2048) + (3*512) + (((16+1)%8)*32)



        defw      16384 + (((17+1)/8)*2048) + (0*512) + (((17+1)%8)*32)

        defw      16384 + (((17+1)/8)*2048) + (1*512) + (((17+1)%8)*32)

        defw      16384 + (((17+1)/8)*2048) + (2*512) + (((17+1)%8)*32)

        defw      16384 + (((17+1)/8)*2048) + (3*512) + (((17+1)%8)*32)



        defw      16384 + (((18+1)/8)*2048) + (0*512) + (((18+1)%8)*32)

        defw      16384 + (((18+1)/8)*2048) + (1*512) + (((18+1)%8)*32)

        defw      16384 + (((18+1)/8)*2048) + (2*512) + (((18+1)%8)*32)

        defw      16384 + (((18+1)/8)*2048) + (3*512) + (((18+1)%8)*32)



        defw      16384 + (((19+1)/8)*2048) + (0*512) + (((19+1)%8)*32)

        defw      16384 + (((19+1)/8)*2048) + (1*512) + (((19+1)%8)*32)

        defw      16384 + (((19+1)/8)*2048) + (2*512) + (((19+1)%8)*32)

        defw      16384 + (((19+1)/8)*2048) + (3*512) + (((19+1)%8)*32)



        defw      16384 + (((20+1)/8)*2048) + (0*512) + (((20+1)%8)*32)

        defw      16384 + (((20+1)/8)*2048) + (1*512) + (((20+1)%8)*32)

        defw      16384 + (((20+1)/8)*2048) + (2*512) + (((20+1)%8)*32)

        defw      16384 + (((20+1)/8)*2048) + (3*512) + (((20+1)%8)*32)



        defw      16384 + (((21+1)/8)*2048) + (0*512) + (((21+1)%8)*32)

        defw      16384 + (((21+1)/8)*2048) + (1*512) + (((21+1)%8)*32)

        defw      16384 + (((21+1)/8)*2048) + (2*512) + (((21+1)%8)*32)

        defw      16384 + (((21+1)/8)*2048) + (3*512) + (((21+1)%8)*32)



; -----------------------------------------------------------------------------
attribs:
; lookup table with render attribute coordinates

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0


        defw      race_raster + (0*83) - 51

        defw      race_raster + (1*83) - 51

        defw      race_raster + (2*83) - 51

        defw      race_raster + (3*83) - 51

        defw      race_raster + (4*83) - 51

        defw      race_raster + (5*83) - 51

        defw      race_raster + (6*83) - 51

        defw      race_raster + (7*83) - 51

        defw      race_raster + (8*83) - 51

        defw      race_raster + (9*83) - 51

        defw      race_raster + (10*83) - 51

        defw      race_raster + (11*83) - 51

        defw      race_raster + (12*83) - 51

        defw      race_raster + (13*83) - 51

        defw      race_raster + (14*83) - 51

        defw      race_raster + (15*83) - 51

        defw      race_raster + (16*83) - 51

        defw      race_raster + (17*83) - 51

        defw      race_raster + (18*83) - 51

        defw      race_raster + (19*83) - 51

        defw      race_raster + (20*83) - 51

        defw      race_raster + (21*83) - 51

        defw      race_raster + (22*83) - 51

        defw      race_raster + (23*83) - 51

        defw      race_raster + (24*83) - 51

        defw      race_raster + (25*83) - 51

        defw      race_raster + (26*83) - 51

        defw      race_raster + (27*83) - 51

        defw      race_raster + (28*83) - 51

        defw      race_raster + (29*83) - 51

        defw      race_raster + (30*83) - 51

        defw      race_raster + (31*83) - 51

        defw      race_raster + (32*83) - 51

        defw      race_raster + (33*83) - 51

        defw      race_raster + (34*83) - 51

        defw      race_raster + (35*83) - 51

        defw      race_raster + (36*83) - 51

        defw      race_raster + (37*83) - 51

        defw      race_raster + (38*83) - 51

        defw      race_raster + (39*83) - 51

        defw      race_raster + (40*83) - 51

        defw      race_raster + (41*83) - 51

        defw      race_raster + (42*83) - 51

        defw      race_raster + (43*83) - 51

        defw      race_raster + (44*83) - 51

        defw      race_raster + (45*83) - 51

        defw      race_raster + (46*83) - 51

        defw      race_raster + (47*83) - 51

        defw      race_raster + (48*83) - 51

        defw      race_raster + (49*83) - 51

        defw      race_raster + (50*83) - 51

        defw      race_raster + (51*83) - 51

        defw      race_raster + (52*83) - 51

        defw      race_raster + (53*83) - 51

        defw      race_raster + (54*83) - 51

        defw      race_raster + (55*83) - 51

        defw      race_raster + (56*83) - 51

        defw      race_raster + (57*83) - 51

        defw      race_raster + (58*83) - 51

        defw      race_raster + (59*83) - 51

        defw      race_raster + (60*83) - 51

        defw      race_raster + (61*83) - 51

        defw      race_raster + (62*83) - 51

        defw      race_raster + (63*83) - 51

        defw      race_raster + (64*83) - 51

        defw      race_raster + (65*83) - 51

        defw      race_raster + (66*83) - 51

        defw      race_raster + (67*83) - 51

        defw      race_raster + (68*83) - 51

        defw      race_raster + (69*83) - 51

        defw      race_raster + (70*83) - 51

        defw      race_raster + (71*83) - 51

        defw      race_raster + (72*83) - 51

        defw      race_raster + (73*83) - 51

        defw      race_raster + (74*83) - 51

        defw      race_raster + (75*83) - 51

        defw      race_raster + (76*83) - 51

        defw      race_raster + (77*83) - 51

        defw      race_raster + (78*83) - 51

        defw      race_raster + (79*83) - 51

        defw      race_raster + (80*83) - 51

        defw      race_raster + (81*83) - 51

        defw      race_raster + (82*83) - 51

        defw      race_raster + (83*83) - 51

        defw      race_raster + (84*83) - 51

        defw      race_raster + (85*83) - 51

        defw      race_raster + (86*83) - 51

        defw      race_raster + (87*83) - 51



        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

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

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a

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

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        ex      af, af'
        add     a, c
        jr      c, last_column
        sub     c
        ld      c, a
        ld      hl, -16
        add     hl, sp
        ld      sp, hl

; set 2nd column of routine attributes

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

        pop     hl
        add     hl, bc
        ld      a, (de)
        ld      (hl), a
        inc     de

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

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW+4

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW+4

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW+4

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW+4

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawW+4

        jr      skip_wide

        nop

        nop

        nop

skip_wide:

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

        nop                             ; extra delay

; synchronize with the raster beam
        ld      bc, $0206
        ld      a, 14
        jr      delay_wide
delay_wide:
delay_128k:
        ld      b, $05
		  
ELSE

; draw 8 tiles

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT


        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT+4

        ld      de, 0                   ; D = pixel line, E = char column
        ld      a, 0                    ; A = tile
        call    asm_NIRVANAM_drawT+4

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


        ld      sp, $5822+(0*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(0*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(0*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(0*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(0*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(0*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(0*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(0*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(0*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(0*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(0*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(0*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(0*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(0*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(0*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(0*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(0*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(0*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(0*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(0*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(1*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(1*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(1*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(1*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(1*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(1*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(1*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(1*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(1*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(1*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(1*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(1*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(1*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(1*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(1*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(1*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(1*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(1*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(1*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(1*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(2*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(2*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(2*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(2*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(2*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(2*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(2*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(2*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(2*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(2*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(2*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(2*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(2*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(2*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(2*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(2*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(2*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(2*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(2*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(2*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(3*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(3*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(3*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(3*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(3*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(3*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(3*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(3*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(3*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(3*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(3*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(3*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(3*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(3*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(3*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(3*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(3*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(3*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(3*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(3*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(4*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(4*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(4*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(4*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(4*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(4*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(4*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(4*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(4*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(4*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(4*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(4*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(4*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(4*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(4*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(4*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(4*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(4*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(4*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(4*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(5*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(5*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(5*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(5*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(5*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(5*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(5*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(5*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(5*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(5*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(5*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(5*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(5*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(5*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(5*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(5*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(5*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(5*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(5*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(5*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(6*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(6*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(6*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(6*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(6*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(6*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(6*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(6*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(6*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(6*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(6*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(6*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(6*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(6*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(6*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(6*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(6*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(6*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(6*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(6*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(7*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(7*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(7*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(7*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(7*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(7*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(7*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(7*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(7*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(7*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(7*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(7*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(7*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(7*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(7*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(7*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(7*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(7*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(7*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(7*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(8*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(8*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(8*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(8*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(8*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(8*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(8*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(8*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(8*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(8*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(8*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(8*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(8*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(8*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(8*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(8*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(8*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(8*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(8*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(8*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(9*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(9*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(9*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(9*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(9*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(9*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(9*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(9*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(9*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(9*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(9*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(9*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(9*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(9*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(9*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(9*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(9*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(9*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(9*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(9*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(10*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(10*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(10*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(10*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(10*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(10*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(10*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(10*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(10*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(10*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(10*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(10*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(10*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(10*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(10*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(10*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(10*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(10*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(10*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(10*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(11*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(11*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(11*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(11*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(11*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(11*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(11*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(11*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(11*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(11*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(11*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(11*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(11*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(11*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(11*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(11*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(11*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(11*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(11*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(11*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(12*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(12*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(12*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(12*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(12*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(12*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(12*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(12*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(12*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(12*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(12*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(12*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(12*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(12*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(12*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(12*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(12*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(12*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(12*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(12*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(13*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(13*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(13*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(13*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(13*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(13*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(13*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(13*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(13*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(13*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(13*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(13*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(13*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(13*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(13*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(13*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(13*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(13*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(13*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(13*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(14*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(14*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(14*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(14*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(14*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(14*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(14*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(14*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(14*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(14*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(14*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(14*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(14*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(14*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(14*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(14*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(14*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(14*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(14*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(14*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(15*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(15*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(15*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(15*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(15*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(15*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(15*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(15*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(15*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(15*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(15*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(15*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(15*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(15*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(15*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(15*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(15*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(15*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(15*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(15*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(16*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(16*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(16*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(16*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(16*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(16*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(16*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(16*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(16*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(16*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(16*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(16*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(16*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(16*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(16*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(16*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(16*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(16*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(16*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(16*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(17*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(17*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(17*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(17*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(17*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(17*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(17*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(17*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(17*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(17*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(17*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(17*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(17*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(17*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(17*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(17*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(17*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(17*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(17*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(17*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(18*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(18*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(18*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(18*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(18*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(18*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(18*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(18*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(18*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(18*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(18*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(18*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(18*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(18*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(18*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(18*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(18*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(18*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(18*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(18*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(19*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(19*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(19*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(19*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(19*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(19*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(19*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(19*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(19*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(19*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(19*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(19*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(19*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(19*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(19*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(19*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(19*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(19*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(19*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(19*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(20*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(20*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(20*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(20*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(20*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(20*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(20*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(20*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(20*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(20*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(20*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(20*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(20*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(20*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(20*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(20*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(20*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(20*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(20*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(20*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay



        ld      sp, $5822+(21*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(21*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(21*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(21*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(21*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(21*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(21*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(21*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(21*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(21*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(21*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(21*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(21*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(21*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(21*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay

        ld      sp, $5822+(21*32)+5    ; reference columns 5 and 6
        ld      hl, 0                       ; columns 27 and 28(*)
        ld      de, 0                       ; columns 7 and 8(*)
        ld      bc, 0                       ; columns 9 and 10(*)
        exx
        ld      hl, 0                       ; columns 11 and 12(*)
        ld      de, 0                       ; columns 19 and 20(*)
        ld      bc, 0                       ; columns 3 and 4(*)
        ld      ix, 0                       ; columns 1 and 2(*)
        ld      iy, 0                       ; columns 5 and 6 (*)
        ld      ($5820+(21*32)+1), ix  ; columns 1 and 2
        push    iy                          ; columns 5 and 6
        push    bc                          ; columns 3 and 4
        ld      sp, $5822+(21*32)+19   ; reference columns 19 and 20
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
        ld      sp, $5822+(21*32)+27   ; reference columns 27 and 28
        push    hl                          ; columns 27 and 28
        ld      hl, 0                       ; columns 21 and 22(*)
        ld      de, 0                       ; columns 23 and 24(*)
        ld      bc, 0                       ; columns 25 and 26(*)
        push    bc                          ; columns 25 and 26
        push    de                          ; columns 23 and 24
        push    hl                          ; columns 21 and 22
        ld      hl, 0                       ; columns 29 and 30(*)
        ld      ($5820+(21*32)+29), hl ; columns 29 and 30
        sbc     hl, hl                      ; extra delay


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
