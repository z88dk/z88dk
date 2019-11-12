;
; Switch to graphics (hires) mode and clear screen
;

	SECTION	  code_clib
        PUBLIC    clg
        PUBLIC    _clg

	EXTERN	generic_console_ioctl

        INCLUDE "ioctl.def"

.clg
._clg
        ret
