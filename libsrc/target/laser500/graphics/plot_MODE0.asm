
        SECTION code_clib

        PUBLIC  plot_MODE0

	EXTERN	__console_w
	EXTERN	__console_h

.plot_MODE0
        defc    NEEDplot = 1
        INCLUDE "gfx/gencon/pixel.inc"
