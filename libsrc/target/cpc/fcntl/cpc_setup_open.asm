;
;	CPC fcntl Routines
;       Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_setup_open.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $
;

        SECTION   code_clib
		PUBLIC	cpc_setup_open
      PUBLIC   _cpc_setup_open

; We enter with sp + 4 = buffer, sp + 6 = lengthm sp + 8 = filename
.cpc_setup_open
._cpc_setup_open
		push	ix
		ld	ix,6
		add	ix,sp
		ld	e,(ix+0)
		ld	d,(ix+1)
		ld	b,(ix+2)
		ld	l,(ix+4)
		ld	h,(ix+5)
		pop	ix
		ret


