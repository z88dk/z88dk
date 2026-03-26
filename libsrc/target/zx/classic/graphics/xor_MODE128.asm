;
; Plotting in layer2 mode
;

  IF    FORzxn
    SECTION code_graphics
    PUBLIC  xor_MODE128


xor_MODE128:
    defc    NEEDxor=1
    INCLUDE "pixel_MODE128.inc"
  ENDIF
