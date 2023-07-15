
SECTION code_clib

PUBLIC  xypos_BITMAP

EXTERN  __aquarius_video_base


; Entry:
;       b = row
;       c = column
; Exit: 
;       hl = address
xypos_BITMAP:
    ld      a,c     ;save column for later
    ld      l,b
    ld      h,0
    add     hl,hl   ;*2
    add     hl,hl   ;*4
    add     hl,hl   ;*8
    add     hl,hl   ;*16
    add     hl,hl   ;*32
    add     hl,hl   ;*64
    ld      bc,hl
    add     hl,hl   ;*128
    add     hl,hl   ;*256
    add     hl,bc   ;*320
    ld      c,a     ;Add column
    ld      b,0
    add     hl,bc
    ld      bc,(__aquarius_video_base)
    add     hl,bc
    ret
