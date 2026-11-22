;
; Scroll 4 pixel up
;
;
; ZX81 low resolution version, Stefano Bodrato - 2025
;
;
; $Id: scrollup_4px.asm $
;

    PUBLIC  scrollup_4px
    PUBLIC  _scrollup_4px
    PUBLIC  ___scrollup_4px

    EXTERN  scrolluptxt

scrollup_4px:
_scrollup_4px:
___scrollup_4px:

	call    scrolluptxt
    jp      scrolluptxt
