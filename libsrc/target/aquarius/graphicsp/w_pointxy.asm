;
;       Plot pixel at (x,y) coordinate.



    SECTION code_graphics
    PUBLIC  w_pointxy
    defc    NEEDpoint = 1
    defc    WIDE_GFX = 1
    EXTERN  __aquarius_mode
    EXTERN  w_pointxy_BITMAP


.w_pointxy			
    ld      a,(__aquarius_mode)
    bit     2,a
    jp      nz,w_pointxy_BITMAP
    ld      h,l
    ld      l,e
    INCLUDE	"gfx/gencon/pixel.inc"



