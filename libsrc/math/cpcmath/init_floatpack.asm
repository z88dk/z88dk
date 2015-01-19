;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: init_floatpack.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfp.def"

		PUBLIC		init_floatpack

; All the library routines that we have to change
                EXTERN             atan
                EXTERN             cos
                EXTERN             dadd
                EXTERN             ddiv
                EXTERN             deg
                EXTERN             deq
                EXTERN             dge
                EXTERN             dgt
                EXTERN             dleq
                EXTERN             dlt
                EXTERN             dmul
                EXTERN             dne
                EXTERN             dsub
                EXTERN             exp
                EXTERN             float
                EXTERN             floor
                EXTERN             fprand
                EXTERN             ifix
                EXTERN             log10
                EXTERN             log
                EXTERN             minusfa
                EXTERN             pi
                EXTERN             pow10
                EXTERN             pow
                EXTERN             rad
                EXTERN             sin
                EXTERN             sqrt
                EXTERN             tan

; The actual place where we have to change things
                EXTERN            atanc
                EXTERN            cosc
                EXTERN            daddc
                EXTERN            ddivc
                EXTERN            degc
                EXTERN            deqc
                EXTERN            dgec
                EXTERN            dgtc
                EXTERN            dleqc
                EXTERN            dltc
                EXTERN            dmulc
                EXTERN            dnec
                EXTERN            dsubc
                EXTERN            expc
                EXTERN            floatc
                EXTERN            floorc
                EXTERN            floorc2
                EXTERN            fprandc
                EXTERN            ifixc
                EXTERN            log10c
                EXTERN            logc
                EXTERN            minusfac
                EXTERN            pic
                EXTERN            pow10c
                EXTERN            powc
                EXTERN            radc
                EXTERN            sinc
                EXTERN            skelc
                EXTERN            sqrtc
                EXTERN            tanc

; Now, a hack around z80asm - we have to reference the .lib labels to get
; them into scope. Ideally we'd go (libroutine+offset), but the offset may
; change at some point and this is arguable the simplest way to do it
;
; We save space by only using defb - this overflow, but no harm done there

                defb    atan
                defb    cos
                defb    dadd
                defb    ddiv
                defb    deg
                defb    deq
                defb    dge
                defb    dgt
                defb    dleq
                defb    dlt
                defb    dmul
                defb    dne
                defb    dsub
                defb    exp
                defb    float
                defb    floor
                defb    fprand
                defb    ifix
                defb    log10
                defb    log
                defb    minusfa
                defb    pi
                defb    pow10
                defb    pow
                defb    rad
                defb    sin
                defb    sqrt
                defb    tan


.init_floatpack
		ld      hl,$BD65
		ld      a,(hl)
		cp      158
		jp      z,init_cpc464float
		cp      200
		jp      z,init_cpc664float
		ret

.init_cpc464float
		ld	    hl,CPCFP464_FLO_ATAN
        ld      (atanc),hl
		ld	    hl,CPCFP464_FLO_COS
        ld      (cosc),hl
		ld	    hl,CPCFP464_FLO_ADD
        ld      (daddc),hl
		ld	    hl,CPCFP464_FLO_DIV
        ld      (ddivc),hl
		ld	    hl,CPCFP464_FLO_DEG_RAD
        ld      (degc),hl
        ld      (radc),hl
		ld	    hl,CPCFP464_FLO_CMP
        ld      (deqc),hl
        ld      (dgec),hl
        ld      (dgtc),hl
        ld      (dleqc),hl
        ld      (dltc),hl
        ld      (dnec),hl
		ld	    hl,CPCFP464_FLO_MUL
        ld      (dmulc),hl
		ld	    hl,CPCFP464_FLO_REV_SUB
        ld      (dsubc),hl
		ld	    hl,CPCFP464_FLO_EXP
        ld      (expc),hl
		ld	    hl,CPCFP464_INT_2_FLO
        ld      (floatc),hl
		ld	    hl,CPCFP464_FLO_BINFIX
        ld      (floorc),hl
		ld	    hl,CPCFP464_BIN_2_FLO
        ld      (floorc2),hl
		ld	    hl,CPCFP464_FLO_RND
        ld      (fprandc),hl
		ld	    hl,CPCFP464_FLO_2_INT
        ld      (ifixc),hl
		ld	    hl,CPCFP464_FLO_LOG10
        ld      (log10c),hl
		ld	    hl,CPCFP464_FLO_LOG
        ld      (logc),hl
		ld	    hl,CPCFP464_FLO_INV_SGN
        ld      (minusfac),hl
		ld	    hl,CPCFP464_FLO_PI
        ld      (pic),hl
		ld	    hl,CPCFP464_FLO_POW10
        ld      (pow10c),hl
		ld	    hl,CPCFP464_FLO_POW
        ld      (powc),hl
		ld	    hl,CPCFP464_FLO_SIN
        ld      (sinc),hl
		ld	    hl,CPCFP464_FLO_SQRT
        ld      (sqrtc),hl
		ld	    hl,CPCFP464_FLO_TAN
        ld      (tanc),hl
		ret

.init_cpc664float
		ld	    hl,CPCFP664_FLO_ATAN
        ld      (atanc),hl
		ld	    hl,CPCFP664_FLO_COS
        ld      (cosc),hl
		ld	    hl,CPCFP664_FLO_ADD
        ld      (daddc),hl
		ld	    hl,CPCFP664_FLO_DIV
        ld      (ddivc),hl
		ld	    hl,CPCFP664_FLO_DEG_RAD
        ld      (degc),hl
        ld      (radc),hl
		ld	    hl,CPCFP664_FLO_CMP
        ld      (deqc),hl
        ld      (dgec),hl
        ld      (dgtc),hl
        ld      (dleqc),hl
        ld      (dltc),hl
        ld      (dnec),hl
		ld	    hl,CPCFP664_FLO_MUL
        ld      (dmulc),hl
		ld	    hl,CPCFP664_FLO_REV_SUB
        ld      (dsubc),hl
		ld	    hl,CPCFP664_FLO_EXP
        ld      (expc),hl
		ld	    hl,CPCFP664_INT_2_FLO
        ld      (floatc),hl
		ld	    hl,CPCFP664_FLO_BINFIX
        ld      (floorc),hl
		ld	    hl,CPCFP664_BIN_2_FLO
        ld      (floorc2),hl
		ld	    hl,CPCFP664_FLO_RND
        ld      (fprandc),hl
		ld	    hl,CPCFP664_FLO_2_INT
        ld      (ifixc),hl
		ld	    hl,CPCFP664_FLO_LOG10
        ld      (log10c),hl
		ld	    hl,CPCFP664_FLO_LOG
        ld      (logc),hl
		ld      hl,CPCFP664_FLO_INV_SGN
        ld      (minusfac),hl
		ld      hl,CPCFP664_FLO_PI
        ld      (pic),hl
		ld      hl,CPCFP664_FLO_POW10
        ld      (pow10c),hl
		ld      hl,CPCFP664_FLO_POW
        ld      (powc),hl
		ld      hl,CPCFP664_FLO_SIN
        ld      (sinc),hl
		ld      hl,CPCFP664_FLO_SQRT
        ld      (sqrtc),hl
		ld      hl,CPCFP664_FLO_TAN
        ld      (tanc),hl
		ret
