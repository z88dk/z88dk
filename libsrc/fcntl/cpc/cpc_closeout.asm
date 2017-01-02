;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closeout.asm,v 1.6 2017-01-02 21:02:22 aralbrec Exp $


        SECTION   code_clib
		PUBLIC		cpc_closeout
      PUBLIC      _cpc_closeout

		INCLUDE		"cpcfirm.def"


.cpc_closeout
._cpc_closeout
        call    firmware
        defw    cas_out_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

