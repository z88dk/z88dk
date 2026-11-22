
SECTION code_clib

PUBLIC  xypos_BITMAP

EXTERN  __aquarius_video_base


; Entry:
;       b = row
;       c = column
; Exit: 
;       hl = address
xypos_BITMAP:
    ld      a,b     ;row * 320 = row * 5 * 64, and row * 5 fits in 8 bits (rows < 51)
    add     a,a     ;*2
    add     a,a     ;*4
    add     a,b     ;*5
    ld      h,a     ;*5 * 256
    ld      l,0
    srl     h       ;/2
    rr      l
    srl     h       ;/4: *5 * 64
    rr      l
    ld      b,0     ;Add column (c)
    add     hl,bc
    ld      bc,(__aquarius_video_base)
    add     hl,bc
    ret
