;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closeout.asm,v 1.1 2003-09-12 16:30:43 dom Exp $



		XLIB		cpc_closeout

		INCLUDE		"#cpcfirm.def"


.cpc_closeout
		call		cas_out_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

