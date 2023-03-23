
    SECTION code_video_vdp
    PUBLIC  __tms9918_text_xypos

    EXTERN  __tms9918_pattern_name
    EXTERN  __console_w

    EXTERN	CONSOLE_YOFFSET
    EXTERN	CONSOLE_XOFFSET


; Entry: b = row, c = column
__tms9918_text_xypos:
    ld      de,(__console_w)
    ld      d,0
    ld      hl,(__tms9918_pattern_name)
    and     a
    sbc     hl,de
    ld      a,b
    add     CONSOLE_YOFFSET
    ld      b,a
    inc     b
xypos_1:
    add     hl,de
    djnz    xypos_1
    ld      a,CONSOLE_XOFFSET
    add     c
    ld      c,a
    add     hl,bc
    ret
