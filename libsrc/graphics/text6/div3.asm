;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 14/12/2006
;
;
;	Divide by three lookup table
;
;
;	$Id: div3.asm,v 1.4 2016-06-16 19:53:50 dom Exp $
;

        SECTION rodata_clib
	PUBLIC	div3

.div3
		;	0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
		defb	0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5
		
		;	  17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32
		defb	   6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9,10,10,10,11
		
		;	  33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48
		defb	  11,11,12,12,12,13,13,13,14,14,14,15,15,15,16,16
		
		;	  49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64
		defb	  16,17,17,17,18,18,18,19,19,19,20,20,20,21,21,21
		
		;	  65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80
		defb	  22,22,22,23,23,23,24,24,24,25,25,25,26,26,26,27


;## TL TR
;## ML MR
;## BL BR
;
;POS: X/2, Y/3
;
;Bit: X mod 2, Y mod 3
