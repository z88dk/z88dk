


IF FORalphatro
	defc	address_r = 0
	defc	address_w = 0x50
	defc	status_r = 0
	defc	register_r = 0x51
	defc	register_w = 0x51
ENDIF

IF FORtrs80
	; Really for the Color Genie (eg2000)
	defc	address_r = 0
	defc	address_w = 0xfa
	defc	register_r = 0xfb
	defc	register_w = 0xfb
ENDIF

IF FORlynx
	defc	address_r = 0
	defc	status_r = 0x86
	defc	address_w = 0x86
	defc	register_r = 0x87
	defc	register_w = 0x87

ENDIF

IF FOReinstein
	defc	address_r = 0
	defc	status_r = 0 
	defc	address_w = 0x48
	defc	register_r = 0
	defc	register_w = 0x49
ENDIF
