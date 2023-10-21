;
;      Colour graphics routines
;
;      cls ()  -- clear screen
;
;      Stefano Bodrato - 2018
;
;
;      $Id: cclg.asm $
;

        SECTION code_graphics
        PUBLIC  cclg
        PUBLIC  _cclg
        PUBLIC  ___cclg

        EXTERN  clg

        defc    cclg=clg
        defc    _cclg=cclg
        defc    ___cclg=cclg
