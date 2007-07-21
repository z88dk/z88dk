;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closeout.asm,v 1.2 2007-07-21 21:28:22 dom Exp $



		XLIB		cpc_closeout

		INCLUDE		"#cpcfirm.def"


.cpc_closeout
        call    firmware
        defw    cas_out_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

