	SECTION	bss_driver

    PUBLIC  __draw_mode
    PUBLIC  __fillstyle
    PUBLIC  __tempx_s
    PUBLIC  __tempy_s
    PUBLIC  __templ_d


	;; Drawing mode (SOILD etc)
__draw_mode:
	defs	1
	;; Fill __fillstyle
__fillstyle:	
	defs	0x01
	;; Various varibles
__tempx_s:	
	defs	2
__tempy_s:	
	defs	2
__templ_d:	
	defs	2
