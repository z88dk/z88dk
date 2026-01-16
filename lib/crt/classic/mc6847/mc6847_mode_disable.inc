    EXTERN	vpeek_noop

IF CLIB_DISABLE_MODE0 = 1
    PUBLIC  plot_MODE0
    PUBLIC  res_MODE0
    PUBLIC  xor_MODE0
    PUBLIC  pointxy_MODE0
    defc    plot_MODE0 = noop
    defc    res_MODE0 = noop
    defc    xor_MODE0 = noop
    defc    pointxy_MODE0 = noop
ENDIF

IF CLIB_DISABLE_MODE1 = 1
    PUBLIC	vpeek_MODE1
    PUBLIC	printc_MODE1
    PUBLIC	plot_MODE1
    PUBLIC	res_MODE1
    PUBLIC	xor_MODE1
    PUBLIC	pointxy_MODE1
    PUBLIC	pixeladdress_MODE1
    defc	vpeek_MODE1 = vpeek_noop
    defc	printc_MODE1 = noop
    defc	plot_MODE1 = noop
    defc	res_MODE1 = noop
    defc	xor_MODE1 = noop
    defc	pointxy_MODE1 = noop
    defc	pixeladdress_MODE1 = noop
ENDIF
IF CLIB_DISABLE_MODE2 = 1
    PUBLIC	vpeek_MODE2
    PUBLIC	printc_MODE2
    PUBLIC	plot_MODE2
    PUBLIC	res_MODE2
    PUBLIC	xor_MODE2
    PUBLIC	pointxy_MODE2
    PUBLIC	pixeladdress_MODE2
    defc	vpeek_MODE2 = vpeek_noop
    defc	printc_MODE2 = noop
    defc	plot_MODE2 = noop
    defc	res_MODE2 = noop
    defc	xor_MODE2 = noop
    defc	pointxy_MODE2 = noop
    defc	pixeladdress_MODE2 = noop
ENDIF

