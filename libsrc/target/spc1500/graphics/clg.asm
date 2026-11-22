;
;	Samsung SPC-1500 graphics: clear the screen to the paper pen
;
;	void clg(void);
;
;	The console's clear (generic_console_cls).  The graphics mode is the
;	start-up code's (spc1500_gfx_init), and this leaves it, and the palette,
;	as they are.
;
    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg
    EXTERN  generic_console_cls

    defc    clg = generic_console_cls
    defc    _clg = generic_console_cls
