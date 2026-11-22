

    INCLUDE  "vdp.inc"

IFDEF   V9938

    SECTION code_video_vdp
    PUBLIC  vdp_set_palette_entry
    PUBLIC  _vdp_set_palette_entry


    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts




; void vdp_set_palette_entry(uint8_t index, uint16_t colour)
vdp_set_palette_entry:
_vdp_set_palette_entry:

    ld      hl, 2
    add     hl, sp
    ld      e, (hl)                     ; Colour
    inc     hl
    ld      d, (hl)                     ; Colour
    inc     hl
    ld      l, (hl)                     ; Index
    call    l_tms9918_disable_interrupts
    ld      bc, VDP_CMD
    ld      a, l
    out     (c), a
    ld      a, 16+$80
    out     (c), a
    ld      a, e
    ld      c, VDP_PORT2
    out     (c),a
    ld      a, d
    out     (c), a
    call    l_tms9918_enable_interrupts
    ret
    

ENDIF