

SECTION code_video_vdp

PUBLIC  __v9938_mode8_xypos
EXTERN  __tms9918_pattern_name


; convert character x,y to address
; Entry: b = row
;        c = column
;
__v9938_mode8_xypos:
    ld      a,b
    add     a
    add     a       ;*4
    add     a       ;*8
    ld      h,a
    ld      a,(__tms9918_pattern_name+1)
    add     h
    ld      h,a     ;Row * 2048 + screen base
    ; Now, how many bytes per character?
    sla     c
    sla     c
    sla     c       ;8 bytes needed for a character
    ld      l,c
    ret
