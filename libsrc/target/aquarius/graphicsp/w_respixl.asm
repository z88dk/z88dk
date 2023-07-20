;
;       Plot pixel at (x,y) coordinate.



    SECTION code_graphics
    PUBLIC  w_respixel
    defc    NEEDunplot = 1
    defc    WIDE_GFX = 1
    EXTERN  __aquarius_mode
    EXTERN  w_respixel_BITMAP


.w_respixel			
    ld      a,(__aquarius_mode)
    bit     2,a
    jp      nz,w_respixel_BITMAP
    ld      h,l
    ld      l,e
    INCLUDE	"gfx/gencon/pixel.inc"



