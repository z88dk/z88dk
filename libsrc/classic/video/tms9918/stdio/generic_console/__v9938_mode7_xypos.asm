

    SECTION code_video_vdp

    PUBLIC  __v9938_mode7_xypos
    EXTERN  __tms9918_pattern_name



; Entry b = y, c = x
; Exit: hl = VDP address
; Each row is 2048 bytes
__v9938_mode7_xypos:
    ld      a, b
    add     a           ;*512
    add     a           ;*1024
    add     a           ;*2048
    ld      h, a
    ld      a, (__tms9918_pattern_name+1)
    add     h
    ld      h, a        ;Row * 2048 + screen base
    ld      a, c        ;4 bytes per character
    add     a
    add     a
    ld      l, a
    ret
