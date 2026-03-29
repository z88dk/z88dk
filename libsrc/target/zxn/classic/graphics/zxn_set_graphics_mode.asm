

MODULE zxn_set_graphics_mode
SECTION code_graphics
PUBLIC zxn_set_graphics_mode
PUBLIC _zxn_set_graphics_mode

EXTERN __zx_gfxmode

EXTERN  __IO_LAYER_2_CONFIG
EXTERN  __IL2C_SHOW_LAYER_2


; void zxn_set_graphics_mode(uint16_t mode);
zxn_set_graphics_mode:
_zxn_set_graphics_mode:
    pop     bc
    pop     hl
    push    hl
    push    bc
    ld      a, l
    ld      (__zx_gfxmode), a
    bit     7, a
    jr      nz, handle_layer2
    bit     6, a
    ret     z
    ;; TODO: Tilemap mode, enabling is a bit awkward since graphics is based on the console
    ret

handle_layer2:
    ; Set layer2 to visible
    ld      a,__IL2C_SHOW_LAYER_2
    ld      bc,__IO_LAYER_2_CONFIG
    out     (c),a
    ret

