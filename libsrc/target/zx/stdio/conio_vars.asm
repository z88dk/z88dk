; Some console variables shared with the -clib=ansi driver
;

    MODULE  console_vars

    PUBLIC  __zx_console_attr

    SECTION data_clib

__zx_console_attr:
    defb    56      ;Default attribute
IF FORzxn
    PUBLIC  __zx_ink_colour
__zx_ink_colour:
    defb    15      ;Default ink colour
ENDIF

IF FORsam
    PUBLIC  __sam_MODE3_attr
    PUBLIC  __sam_MODE4_attr

__sam_MODE3_attr:
    defb    @11000000, @00000000        ;ink = pen3, paper = pen0

__sam_MODE4_attr:
    defb    @11110000, @00000000        ;ink = pen15, paper = pen0
ENDIF

