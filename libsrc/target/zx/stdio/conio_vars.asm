; Some console variables shared with the -clib=ansi driver
;

    MODULE  console_vars

    PUBLIC  __zx_console_attr

    SECTION data_clib

__zx_console_attr:
IF FORsam
    defb   7
ELSE
    defb    56      ;Default attribute
ENDIF
IF FORzxn
    PUBLIC  __zx_ink_colour
__zx_ink_colour:
    defb    15      ;Default ink colour
ENDIF
    PUBLIC  __zx_mode0_console_w
    EXTERN  CONSOLE_COLUMNS
__zx_mode0_console_w:
    defb    CONSOLE_COLUMNS

IF FORsam
    PUBLIC  __sam_MODE3_attr
    PUBLIC  __sam_MODE4_attr

__sam_MODE3_attr:
    defb    @11000000, @00000000        ;ink = pen3, paper = pen0

__sam_MODE4_attr:
    defb    @11110000, @00000000        ;ink = pen15, paper = pen0
ENDIF
