;
;	Amstrad CPC specific routines
;	by Stefano Bodrato, Fall 2013
;	source: www.cpctech.org.uk
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
get_psg:
_get_psg:


;;------------------------------------------------
;; Read from a AY-3-8912 register
;;
;; Entry conditions:
;;
;; L = C = register number
;; PPI port A is assumed to be set to output.
;; PSG operation is assumed to be "inactive"
;;
;; Exit conditions:
;;
;; A = register data
;; BC corrupt
;;
;; This function is compatible with the CPC+.

ld	c,l

;; step 1: select register

;; write register index to PPI port A
ld b,$f4
out (c),c

;; set PSG operation -  "select register"
ld bc,$f6c0
out (c),c

;; set PSG operation -  "inactive"
ld bc,$f600
out (c),c

;; PPI port A set to input, PPI port B set to input,
;; PPI port C (lower) set to output, PPI port C (upper) set to output
ld bc,$f700+@10010010
out (c),c

;; set PSG operation -  "read register data"
ld bc,$f640
out (c),c

;; step 2 -  read data from register

;; read PSG register data from PPI port A
ld b,$f4
in a,(c)

;; PPI port A set to output, PPI port B set to input,
;; PPI port C (lower) set to output, PPI port C (upper) set to output
ld bc,$f700+@10000010
out (c),c

;; set PSG operation -  "inactive"
ld bc,$f600
out (c),c

ld	l,a
ret
