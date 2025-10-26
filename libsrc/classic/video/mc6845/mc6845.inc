


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

IF FORsuper80
	defc	address_r = 0
	defc	status_r = 0 
	defc	address_w = 0x10
	defc	register_r = 0
	defc	register_w = 0x11
ENDIF

IF FORsvi
	defc	address_r = 0
	defc	status_r = 0 
	defc	address_w = 0x50
	defc	register_r = 0x51
	defc	register_w = 0x51
ENDIF

IF FORsmc777
	defc	address_r = 0x18
	defc	status_r = 0 
	defc	address_w = 0x18
	defc	register_r = 0x19
	defc	register_w = 0x19
ENDIF

IF FORpasopia7
	defc	address_r = 0x10
	defc	status_r = 0 
	defc	address_w = 0x10
	defc	register_r = 0x11
	defc	register_w = 0x11
ENDIF

IF FORexcali64
	defc	address_r = 0
	defc	status_r =  0x30
	defc	address_w = 0x30
	defc	register_r = 0x31
	defc	register_w = 0x31
ENDIF

IF FORx1
	defc	address_r = 0
	defc	status_r =  0x1800
	defc	address_w = 0x1800
	defc	register_r = 0x1801
	defc	register_w = 0x1801
ENDIF

IF FORbondwell
	defc	address_r = 0x10
	defc	status_r = 0 
	defc	address_w = 0x10
	defc	register_r = 0x11
	defc	register_w = 0x11
ENDIF

IF FORtrs80m2
	defc	address_r = 0
	defc	address_w = 0xfc
	defc	status_r = 0
	defc	register_r = 0
	defc	register_w = 0xfd
ENDIF
