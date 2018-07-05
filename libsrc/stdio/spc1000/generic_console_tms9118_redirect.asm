

	MODULE		__tms9118_console_stubs

        PUBLIC          tms9918_cls
        PUBLIC          tms9918_console_vpeek
        PUBLIC          tms9918_console_ioctl
        PUBLIC          tms9918_scrollup
        PUBLIC          tms9918_printc
        PUBLIC          tms9918_set_ink
        PUBLIC          tms9918_set_paper
        PUBLIC          tms9918_set_inverse
	PUBLIC		tms9918_spc1000_impl

        EXTERN          __tms9918_cls
        EXTERN          __tms9918_console_vpeek
        EXTERN          __tms9918_console_ioctl
        EXTERN          __tms9918_scrollup
        EXTERN          __tms9918_printc
        EXTERN          __tms9918_set_ink
        EXTERN          __tms9918_set_paper
        EXTERN          __tms9918_set_inverse

	defc		tms9918_cls = __tms9918_cls
	defc		tms9918_console_vpeek = __tms9918_console_vpeek
	defc		tms9918_console_ioctl = __tms9918_console_ioctl
	defc		tms9918_scrollup = __tms9918_scrollup
	defc		tms9918_printc = __tms9918_printc
	defc		tms9918_set_ink = __tms9918_set_ink
	defc		tms9918_set_paper = __tms9918_set_paper
	defc		tms9918_set_inverse = __tms9918_set_inverse

	defc		tms9918_spc1000_impl = 1
