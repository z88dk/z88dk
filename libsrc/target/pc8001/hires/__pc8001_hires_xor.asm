
; Xor pixel at (x,y) in the mkII hires modes

    SECTION code_graphics
    PUBLIC  __pc8001_hires_xor
    defc    NEEDxor=1

__pc8001_hires_xor:
    INCLUDE "target/pc8001/hires/pixel_HIRES.inc"
