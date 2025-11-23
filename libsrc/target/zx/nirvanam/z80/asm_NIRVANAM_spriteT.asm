; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; Update sprite information, so the specified tile will automatically
; appear at the specified location when the next interrupt occurs
; (and automatically redrawn at every interrupt afterwards, until
; this sprite information is updated again).
;
; Sprites are displayed in increasing priority order, i.e.
; sprite 7 will appear in front of everything else.
;
; Notice there's no way to disable sprites. If you don't want to
; display a certain sprite, simply move it to line zero, so it
; will be hidden outside the screen.
;
; Params:
;     
; Parameters:
;     HL = sprite number (0-7)
;      A = tile index (0-255)
;      D = pixel line (0-192, even values only)
;      E = char column (0-30)
;
; WARNING: If this routine is under execution when interrupt occurs,
;          a sprite (containing partially updated information) may
;          be displayed at an incorrect location on screen (see
;          NIRVANAhalt)
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_spriteT

asm_NIRVANAM_spriteT:

        add hl,hl
        add hl,hl
        add hl,hl       ; HL=sprite*8
        ld bc,57577
        add hl,bc       ; HL=57577+sprite*8
        ld (hl),a       ; tile
        dec l
        dec hl
        ld (hl),d       ; lin
        dec l
        ld (hl),e       ; col
        ret
