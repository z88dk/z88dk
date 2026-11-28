    SECTION data_clib

    PUBLIC  __pc8001_mode
    PUBLIC  __pc8001_attr
    PUBLIC  __pc8001_gfxmode
    PUBLIC  __pc8001_ink
    PUBLIC  __pc8001_paper

; 0 = 80 column, 1 = 40 column
__pc8001_mode:
    defb    0
; Attribute used for ordinary text (reverse/underline/blink bits)
__pc8001_attr:
    defb    0
; 0 = semigraphics, 1 = 640x200 mono, 2 = 320x200 4 colour (-clib=mk2)
__pc8001_gfxmode:
    defb    0
; Pixel value used by plot() in the 320x200 4 colour mode
__pc8001_ink:
    defb    3
; Pixel value of the background of bitmapped text in the 320x200 mode
__pc8001_paper:
    defb    0
