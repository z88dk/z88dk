
; Unplot pixel at (x,y) in the mkII hires modes

    SECTION code_driver
    PUBLIC  __pc8001_hires_unplot
    defc    NEEDunplot=1

__pc8001_hires_unplot:
    INCLUDE "target/pc8001/hires/pixel_HIRES.inc"
