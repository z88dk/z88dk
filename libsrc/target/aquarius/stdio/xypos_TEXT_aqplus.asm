        #include    "target/aquarius/def/plus.inc"
        SECTION code_clib

        PUBLIC  xypos_TEXT
        PUBLIC  xypos_BITMAP_ATTR

        EXTERN  CONSOLE_COLUMNS
        EXTERN  DISPLAY

        EXTERN  __aquarius_video_base

; Entry:
;       b = row
;       c = column
; Exit:
;       hl = address
xypos_TEXT:
        call    xypos
        ld      bc, DISPLAY
        add     hl, bc
        ret

xypos_BITMAP_ATTR:
        call    xypos
        set     5, h                    ;Add $2000
        ld      bc, (__aquarius_video_base)
        add     hl, bc
        ret

xypos:
        ld      a, c                    ;save column
        ld      l, b
        ld      h, 0
        add     hl, hl                  ;*2
        ld      bc, hl
        add     hl, hl                  ;*4
        add     hl, hl                  ;*8
        add     hl, bc                  ;*10
        add     hl, hl                  ;*20
        add     hl, hl                  ;*40
        ld      c, a                    ;column
        ld      b, 0

        in      a, (IO_VCTRL)
        and     VCRTL_80COL_EN
        jr      z, col40
        add     hl, hl                  ;*80
col40:
        add     hl, bc
        ret

