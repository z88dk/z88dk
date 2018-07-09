

	MODULE		__tms9118_console_stubs

        PUBLIC          tms9918_cls
        PUBLIC          tms9918_console_vpeek
        PUBLIC          tms9918_console_ioctl
        PUBLIC          tms9918_scrollup
        PUBLIC          tms9918_printc
        PUBLIC          tms9918_set_ink
        PUBLIC          tms9918_set_paper
        PUBLIC          tms9918_set_inverse
	PUBLIC		tms9918_spc1000_stub

	defc		tms9918_cls = stub	
	defc		tms9918_console_vpeek = stub_scf
	defc		tms9918_console_ioctl = stub_scf
	defc		tms9918_scrollup = stub
	defc		tms9918_printc = stub
	defc		tms9918_set_ink = stub
	defc		tms9918_set_paper = stub
	defc		tms9918_set_inverse = stub

	defc		tms9918_spc1000_stub = 1

stub_scf:
	scf
stub:
	ret




