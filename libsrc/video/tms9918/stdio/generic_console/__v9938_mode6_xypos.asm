

SECTION code_video_vdp

PUBLIC  __v9938_mode6_xypos
EXTERN  __tms9918_pattern_name



; Entry b = y, c = x
; Exit: hl = VDP address
__v9938_mode6_xypos:
    ld      a,b
    add     a
    add     a       ;*4
    ld      h,a
    ld      a,(__tms9918_pattern_name+1)
    add     h
    ld      h,a     ;Row * 1024 + screen base
    ; Now, how many bytes per character?
    ld      a,c
    add     a
    ld      l,a
    ret