
; Point pixel at (x,y) in the mkII hires modes

    SECTION code_graphics
    PUBLIC  __pc8001_hires_point
    defc    NEEDpoint=1

__pc8001_hires_point:
    INCLUDE "target/pc8001/hires/pixel_HIRES.inc"
