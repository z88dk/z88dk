
    INCLUDE  "vdp.inc"

IFDEF   V9938

    SECTION code_video_vdp
    PUBLIC  vdp_set_palette
    PUBLIC  _vdp_set_palette
    PUBLIC  vdp_set_palette_fastcall
    PUBLIC  _vdp_set_palette_fastcall

    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts




vdp_set_palette:
_vdp_set_palette:
    pop     bc
    pop     hl
    push    hl
    push    bc
    ; Fall through

vdp_set_palette_fastcall:
_vdp_set_palette_fastcall:
    ld      bc,VDP_CMD

    call    l_tms9918_disable_interrupts

    xor     a               ; Set color 0 ...
    di
    out     (c),a           ; TODO: mmap variant
    ld      a,80h+16        ; ...into register 16 (+80h)
    out     (c),a

    ld	    c,VDP_PORT2
    ld      b,32
    otir
    call    l_tms9918_enable_interrupts
    ret

ENDIF


