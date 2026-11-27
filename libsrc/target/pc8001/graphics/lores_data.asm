    SECTION rodata_driver

    PUBLIC  __pc8001_lores_pixel_map

; Bit within a semigraphic cell, indexed by ((x & 1) * 4) + (y & 3)
__pc8001_lores_pixel_map:
    defb    $01, $02, $04, $08, $10, $20, $40, $80
