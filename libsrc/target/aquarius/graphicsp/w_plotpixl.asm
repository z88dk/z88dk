;
;       Plot pixel at (x,y) coordinate.



    SECTION code_graphics
    PUBLIC  w_plotpixel
    defc    NEEDplot = 1
    defc    WIDE_GFX = 1
    EXTERN  __aquarius_mode
    EXTERN  w_plotpixel_BITMAP


.w_plotpixel			
    ld      a,(__aquarius_mode)
    bit     2,a
    jp      nz,w_plotpixel_BITMAP
    ld      h,l
    ld      l,e
    INCLUDE	"gfx/gencon/pixel.inc"



