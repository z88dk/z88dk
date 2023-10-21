;
;      Turtle graphics library
;      Stefano - 11/2017
;
;      $Id: pen_down.asm $
;

        SECTION code_graphics
        PUBLIC  pen_down
        PUBLIC  _pen_down


pen_down:
_pen_down:
        ld      hl, __pen
        ld      a, 128
        or      (hl)
        ld      (hl), a
        ret


        SECTION bss_graphics
        PUBLIC  __pen

__pen:  defb    0                       ; leftmost bit: pen up/down

