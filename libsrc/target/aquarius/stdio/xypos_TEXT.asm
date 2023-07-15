
SECTION code_clib

PUBLIC xypos_TEXT
PUBLIC xypos_BITMAP_ATTR

EXTERN CONSOLE_COLUMNS

INCLUDE "target/aquarius/def/aquarius.def"

EXTERN __aquarius_video_base

; Entry:
;       b = row
;       c = column
; Exit: 
;       hl = address
xypos_TEXT:
    call    xypos
    ld      bc,DISPLAY
    add     hl,bc
    ret

xypos_BITMAP_ATTR:
    call    xypos
    set     5,h     ;Add $2000
    ld      bc,(__aquarius_video_base)
    add     hl,bc
    ret

xypos:
    ld      a,c     ;save column
    ld      l,b
    ld      h,0
    add     hl,hl   ;*2
    ld      bc,hl
    add     hl,hl   ;*4
    add     hl,hl   ;*8
    add     hl,bc   ;*10
    add     hl,hl   ;*20
    add     hl,hl   ;*40
    ld      c,a     ;add column (b=0 already)
    ld      b,0
    add     hl,bc
    ret

    