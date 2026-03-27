;
; Plotting in layer2 mode
;

  IF    FORzxn
    SECTION code_graphics
    PUBLIC  res_MODE128


res_MODE128:
    defc    NEEDunplot=1
    INCLUDE "pixel_MODE128.inc"
  ENDIF
