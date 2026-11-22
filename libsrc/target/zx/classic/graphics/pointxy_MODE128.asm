;
; Plotting in layer2 mode
;

  IF    FORzxn
    SECTION code_graphics
    PUBLIC  pointxy_MODE128


pointxy_MODE128:
    defc    NEEDpoint=1
    INCLUDE "pixel_MODE128.inc"
  ENDIF
