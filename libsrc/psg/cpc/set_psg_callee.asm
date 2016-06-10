;
;	Amstrad CPC specific routines
;	by Stefano Bodrato, Fall 2013
;	source: www.cpctech.org.uk
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.4 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry


;;------------------------------------------------
;; Write to a AY-3-8912 register
;;
;; Entry conditions:
;;
;; L = C = register number
;; E = data 
;; PPI port A is assumed to be set to output.
;; PSG operation is assumed to be "inactive"
;;
;; Exit conditions:
;;
;; BC corrupt
;;
;; This function is compatible with the CPC+.



ld	c,l
;; ASMENTRY + 1 <- psg_init gets here !!



;; step 1 -  select register

;; write register index to PPI port A
ld b,$f4
out (c),c

;; set PSG operation -  "select register"
ld bc,$f6c0
out (c),c

;; set PSG operation -  "inactive"
ld bc,$f600
out (c),c

;; step 2 -  write data to register 

;; write data to PPI port A
ld b,$f4
out (c),e

;; set PSG operation -  "write data to register"
ld bc,$f680
out (c),c

;; set PSG operation -  "inactive"
ld bc,$f600
out (c),c
ret


DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee

