;
;    CPC Maths Routines
;
;    August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;    $Id: init_floatpack.asm,v 1.5 2016-06-22 19:50:49 dom Exp $
;

        SECTION        code_fp
        INCLUDE        "target/cpc/def/cpcfp.def"

        PUBLIC        init_floatpack

; All the library routines that we have to change
        EXTERN        atan
        EXTERN        cos
        EXTERN        dadd
        EXTERN        ddiv
        EXTERN        deg
        EXTERN        deq
        EXTERN        dge
        EXTERN        dgt
        EXTERN        dleq
        EXTERN        dlt
        EXTERN        dmul
        EXTERN        dne
        EXTERN        dsub
        EXTERN        exp
        EXTERN        float
        EXTERN        floor
        EXTERN        fprand
        EXTERN        ifix
        EXTERN        log10
        EXTERN        log
        EXTERN        minusfa
        EXTERN        pow10
        EXTERN        pow
        EXTERN        rad
        EXTERN        sin
        EXTERN        sqrt
        EXTERN        tan

; The actual place where we have to change things
        EXTERN        atanc
        EXTERN        cosc
        EXTERN        daddc
        EXTERN        ddivc
        EXTERN        degc
        EXTERN        deqc
        EXTERN        dgec
        EXTERN        dgtc
        EXTERN        dleqc
        EXTERN        dltc
        EXTERN        dmulc
        EXTERN        dnec
        EXTERN        dsubc
        EXTERN        expc
        EXTERN        floatc
        EXTERN        floorc
        EXTERN        floorc2
        EXTERN        fprandc
        EXTERN        ifixc
        EXTERN        log10c
        EXTERN        logc
        EXTERN        minusfac
        EXTERN        pow10c
        EXTERN        powc
        EXTERN        radc
        EXTERN        sinc
        EXTERN        skelc
        EXTERN        sqrtc
        EXTERN        tanc

.init_floatpack
IFNDEF PORTABLE_CPC_MATH
        ld      hl,$BD65
        ld      a,(hl)
        cp      158
        jp      z,init_cpc464float
        cp      200
        jp      z,init_cpc664float
        ret

.init_cpc464float
        ld      hl,CPCFP464_FLO_ATAN
        ld      (atanc+3),hl
        ld      hl,CPCFP464_FLO_COS
        ld      (cosc+3),hl
        ld      hl,CPCFP464_FLO_ADD
        ld      (daddc+3),hl
        ld      hl,CPCFP464_FLO_DIV
        ld      (ddivc+3),hl
        ld      hl,CPCFP464_FLO_DEG_RAD
        ld      (degc+3),hl
        ld      (radc+3),hl
        ld      hl,CPCFP464_FLO_CMP
        ld      (deqc+3),hl
        ld      (dgec+3),hl
        ld      (dgtc+3),hl
        ld      (dleqc+3),hl
        ld      (dltc+3),hl
        ld      (dnec+3),hl
        ld      hl,CPCFP464_FLO_MUL
        ld      (dmulc+3),hl
        ld      hl,CPCFP464_FLO_REV_SUB
        ld      (dsubc+3),hl
        ld      hl,CPCFP464_FLO_EXP
        ld      (expc+3),hl
        ld      hl,CPCFP464_BIN_2_FLO
        ld      (floatc+3),hl
        ld      (floorc2+3),hl
        ld      hl,CPCFP464_FLO_BINFIX
        ld      (floorc+3),hl
        ld      hl,CPCFP464_FLO_RND
        ld      (fprandc+3),hl
        ld      hl,CPCFP464_FLO_BINFIX2
        ld      (ifixc+3),hl
        ld      hl,CPCFP464_FLO_LOG10
        ld      (log10c+3),hl
        ld      hl,CPCFP464_FLO_LOG
        ld      (logc+3),hl
        ld      hl,CPCFP464_FLO_INV_SGN
        ld      (minusfac+3),hl
        ld      hl,CPCFP464_FLO_POW10
        ld      (pow10c+3),hl
        ld      hl,CPCFP464_FLO_POW
        ld      (powc+3),hl
        ld      hl,CPCFP464_FLO_SIN
        ld      (sinc+3),hl
        ld      hl,CPCFP464_FLO_SQRT
        ld      (sqrtc+3),hl
        ld      hl,CPCFP464_FLO_TAN
        ld      (tanc+3),hl
        ret

.init_cpc664float
        ld      hl,CPCFP664_FLO_ATAN
        ld      (atanc+3),hl
        ld      hl,CPCFP664_FLO_COS
        ld      (cosc+3),hl
        ld      hl,CPCFP664_FLO_ADD
        ld      (daddc+3),hl
        ld      hl,CPCFP664_FLO_DIV
        ld      (ddivc+3),hl
        ld      hl,CPCFP664_FLO_DEG_RAD
        ld      (degc+3),hl
        ld      (radc+3),hl
        ld      hl,CPCFP664_FLO_CMP
        ld      (deqc+3),hl
        ld      (dgec+3),hl
        ld      (dgtc+3),hl
        ld      (dleqc+3),hl
        ld      (dltc+3),hl
        ld      (dnec+3),hl
        ld      hl,CPCFP664_FLO_MUL
        ld      (dmulc+3),hl
        ld      hl,CPCFP664_FLO_REV_SUB
        ld      (dsubc+3),hl
        ld      hl,CPCFP664_FLO_EXP
        ld      (expc+3),hl
        ld      hl,CPCFP664_BIN_2_FLO
        ld      (floatc+3),hl
        ld      (floorc2+3),hl
        ld      hl,CPCFP664_FLO_BINFIX
        ld      (floorc+3),hl
        ld      hl,CPCFP664_FLO_RND
        ld      (fprandc+3),hl
        ld      hl,CPCFP664_FLO_BINFIX2
        ld      (ifixc+3),hl
        ld      hl,CPCFP664_FLO_LOG10
        ld      (log10c+3),hl
        ld      hl,CPCFP664_FLO_LOG
        ld      (logc+3),hl
        ld      hl,CPCFP664_FLO_INV_SGN
        ld      (minusfac+3),hl
        ld      hl,CPCFP664_FLO_POW10
        ld      (pow10c+3),hl
        ld      hl,CPCFP664_FLO_POW
        ld      (powc+3),hl
        ld      hl,CPCFP664_FLO_SIN
        ld      (sinc+3),hl
        ld      hl,CPCFP664_FLO_SQRT
        ld      (sqrtc+3),hl
        ld      hl,CPCFP664_FLO_TAN
        ld      (tanc+3),hl
ENDIF
        ret
