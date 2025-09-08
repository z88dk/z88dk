

    INCLUDE "target/zx/def/zxports.h"



defc __BIFROST2_ANIM_GROUP     = 4
defc __BIFROST2_STATIC_MIN     = 128
defc __BIFROST2_STATIC_OVERLAP = 128
defc __BIFROST2_TILE_IMAGES    = 49000
defc __BIFROST2_TILE_ORDER     = 7
defc __BIFROST2_TILE_MAP       = 65281
defc __BIFROST2_TOTAL_ROWS     = 22
defc __BIFROST2_HOLE           = 64839
defc _BIFROST2_HOLE            = 64839
defc __BIFROST2_HOLE_SIZE      = 0
; define(`__BIFROST2_TOTAL_ROWS', 22)


defc __NIRVANAP_TILE_IMAGES = 48000   ; default location of bicolour tiles (16x16 pix, 48 bytes each)
defc __NIRVANAP_WIDE_IMAGES = 54000   ; default location of wide tiles (24x16 pix, 72 bytes each)
defc __NIRVANAP_CHAR_TABLE  = 15360   ; default location of character set (8x8 pix, 8 bytes each)

; define(`__NIRVANAP_TOTAL_ROWS', 23)      # total number of rows drawn by nirvana+ 1-23
; define(`__NIRVANAP_OPTIONS_WIDE_DRAW',    0x01)
; define(`__NIRVANAP_OPTIONS_WIDE_SPRITES', 0x02)
