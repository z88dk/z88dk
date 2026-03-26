;
; Plotting in layer2 mode
;


  IF    FORzxn
    SECTION code_graphics
    PUBLIC  plot_MODE128


plot_MODE128:
    defc    NEEDplot=1
    INCLUDE "pixel_MODE128.inc"
  ENDIF
