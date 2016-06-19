;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closein.asm,v 1.5 2016-06-19 21:03:22 dom Exp $


		SECTION   code_clib
		PUBLIC		cpc_closein

		INCLUDE		"cpcfirm.def"


.cpc_closein
        call    firmware
        defw    cas_in_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

