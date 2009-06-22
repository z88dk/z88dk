;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closein.asm,v 1.3 2009-06-22 21:44:16 dom Exp $



		XLIB		cpc_closein

		INCLUDE		"cpcfirm.def"


.cpc_closein
        call    firmware
        defw    cas_in_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

