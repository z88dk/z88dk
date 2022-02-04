        SECTION code_clib
        PUBLIC  load_tiles
        PUBLIC  _load_tiles
        PUBLIC  asm_load_tiles

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        include "sms.hdr"
;==============================================================
; load_tiles(unsigned char *data, int index, int count, int bpp)
;==============================================================
; Loads the specified tileset into VRAM
;==============================================================
load_tiles:
_load_tiles:
        push    ix                      ; save callers ix
        ld      hl, 4
        add     hl, sp
        ld      a, (hl)                 ; bits per pixel
        inc     hl
        inc     hl
        ld      c, (hl)                 ; number of tiles to load
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      e, (hl)                 ; initial tile index
        inc     hl
        ld      d, (hl)
        inc     hl
        push    de
        ld      e, (hl)                 ; location of tile data
        inc     hl
        ld      d, (hl)
        inc     hl
        push    de
        pop     ix                      ; tile data
        pop     hl                      ; initial index
        ld      d, a                    ; bpp

        call    asm_load_tiles

        pop     ix
        ret

;==============================================================
; Tile loader
;==============================================================
; Parameters:
; hl = tile number to start at
; ix = location of tile data
; bc = No. of tiles to load
; d  = bits per pixel
;==============================================================
asm_load_tiles:
        call    l_tms9918_disable_interrupts

        push    af
        push    bc
        push    de
        push    hl
        push    ix

        ; Tell VDP where I want to write (hl<<5)
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h

        ; Set the VRAM access address
        ld      a, l
        out     (__IO_VDP_COMMAND), a
        ld      a, h
        or      VDP_SET_VRAM
        out     (__IO_VDP_COMMAND), a

        ; I need to output bc*8 bytes so I need to modify bc (<<3)
        sla     c
        rl      b
        sla     c
        rl      b
        sla     c
        rl      b

        ; Write data
_Loop:
            ; Restore counter
        ld      e, d

_DataLoop:
                ; Write byte
        ld      a, (ix+0)               ;19
        out     (__IO_VDP_DATA), a
        dec     e                       ;4
        inc     ix                      ;10
        jp      nz, _DataLoop           ;10

            ; Restore counter
        ld      e, d
_BlankLoop:
                ; Write blank data to fill up the rest of the tile definition
        inc     e
        ld      a, e
        cp      5
        jp      z, _NoMoreBlanks

        ld      a, 0
        out     (__IO_VDP_DATA), a
        jp      _BlankLoop

_NoMoreBlanks:

        dec     bc
        ld      a, b
        or      c
        jp      nz, _Loop

        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
