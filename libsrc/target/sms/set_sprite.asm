        SECTION code_clib
        PUBLIC  set_sprite
        PUBLIC  _set_sprite
        PUBLIC  asm_set_sprite

        EXTERN  CONSOLE_YOFFSET
        EXTERN  CONSOLE_XOFFSET
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts_jp

        include "sms.hdr"
;==============================================================
; set_sprite(int sprite, int x, int y, int tile)
;==============================================================
; Set information for the specified sprite
;==============================================================
set_sprite:
_set_sprite:
        ld      hl, 2
        add     hl, sp
        ld      d, (hl)                 ; tile
        inc     hl
        inc     hl
        ld      a, +(CONSOLE_YOFFSET*8)
        add     (hl)                    ; y
        ld      b, a
        inc     hl
        inc     hl
        ld      a, +(CONSOLE_XOFFSET*8)
        add     (hl)                    ; x
        ld      c, a
        inc     hl
        inc     hl
        ld      e, (hl)                 ; sprite

;==============================================================
; Set sprite data
;==============================================================
; Parameters:
; d = tile number
; e = Sprite number
; b = Sprite y position
; c = Sprite x position
;==============================================================
asm_set_sprite:
        call    l_tms9918_disable_interrupts

	;vdp set addr (Y table)
        ld      a, e
        out     (__IO_VDP_COMMAND), a
        ld      a, VDP_SET_VRAM|(SpriteTableAddress>>8)
        out     (__IO_VDP_COMMAND), a

        ld      a, b
        out     (__IO_VDP_DATA), a      ; Set Y

	;vdp set addr (X/Tile table)
        ld      a, e
        add     a, a
        or      $80

        out     (__IO_VDP_COMMAND), a
        ld      a, VDP_SET_VRAM|(SpriteTableAddress>>8)
        out     (__IO_VDP_COMMAND), a

        ld      a, c
        out     (__IO_VDP_DATA), a      ; Set X
        nop                             ;4
        nop
        nop
        nop
        nop
        nop
        ld      a, d                    ;4
        out     (__IO_VDP_DATA), a      ; Set Tile

        ; exit through l_tms9918_enable_interrupts_jp
        jp      l_tms9918_enable_interrupts_jp
