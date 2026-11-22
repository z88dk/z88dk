        #include    "target/aquarius/def/plus.inc"
        SECTION code_clib

        PUBLIC  xypos_TEXT
        PUBLIC  xypos_BITMAP_ATTR

        EXTERN  CONSOLE_COLUMNS
        EXTERN  DISPLAY

        EXTERN  __aquarius_video_base
	EXTERN	__aquarius_mode

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
        ld      a, b                    ;row * 5 fits in 8 bits (rows < 51)
        add     a, a                    ;*2
        add     a, a                    ;*4
        add     a, b                    ;*5
        ld      l, a
        ld      h, 0
        add     hl, hl                  ;*10
        add     hl, hl                  ;*20
        add     hl, hl                  ;*40
        ld      b, 0                    ;bc = column

        ld      a, (__aquarius_mode)
        and     VCRTL_80COL_EN
        jr      z, col40
        add     hl, hl                  ;*80
col40:
        add     hl, bc
        ret

