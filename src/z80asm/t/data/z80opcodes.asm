;------------------------------------------------------------------------------
; Z80 reference opcodes parsed by build_z80opcodes.pl
; 		z80asm-code ;; z80pack-code ;; code ;; code
; The code is assembled by z80pack and transformed into code and binary form:
;		z80asm-code ;; addr hh hh hh hh
; This is file used to test the assembly of z80asm
; 
; Copyright (C) Paulo Custodio, 2011-2014
; 
; 
;
;------------------------------------------------------------------------------

        org  0100h

        defc IND = 05h 
        defc M = 10h 
        defc N = 20h 
        defc NN = 30h 
        defc DIS = 40h 
        
;------------------------------------------------------------------------------
; Value ranges
;------------------------------------------------------------------------------

										; z80pack does not allow negative indexes
        ld   a,(ix-128)                 ;=> 0100  DD 7E 80
        ld   a,(iy-128)                 ;=> 0103  FD 7E 80
        ld   a,(ix)                     ;=> 0106  DD 7E 00
        ld   a,(iy)                     ;=> 0109  FD 7E 00
        ld   a,(ix+0)                   ;=> 010C  DD 7E 00
        ld   a,(iy+0)                   ;=> 010F  FD 7E 00
        ld   a,(ix+127)                 ;=> 0112  DD 7E 7F
        ld   a,(iy+127)                 ;=> 0115  FD 7E 7F

        ld   a,-128                     ;=> 0118  3E 80
        ld   a,0                        ;=> 011A  3E 00
        ld   a,255                      ;=> 011C  3E FF
        ld   bc,-32768                  ;=> 011E  01 00 80
        ld   bc,-1                      ;=> 0121  01 FF FF
        ld   bc,0                       ;=> 0124  01 00 00
        ld   bc,65535                   ;=> 0127  01 FF FF
        jp   -32768                     ;=> 012A  C3 00 80
        jp   -1                         ;=> 012D  C3 FF FF
        jp   0                          ;=> 0130  C3 00 00
        jp   65535                      ;=> 0133  C3 FF FF

;------------------------------------------------------------------------------
; Regression tests
;------------------------------------------------------------------------------

; BUG_0011: ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
        defb bug0011a-ASMPC, bug0011a-ASMPC  ;=> 0136  06 06
        defb bug0011a-ASMPC, bug0011a-ASMPC  ;=> 0138  04 04
        defb bug0011a-ASMPC, bug0011a-ASMPC  ;=> 013A  02 02
bug0011a:

; BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
bug0047a:
        defw ASMPC,ASMPC,ASMPC          ;=> 013C  3C 01 3C 01 3C 01
bug0047b: 
        jp   ASMPC                      ;=> 0142  C3 42 01

;------------------------------------------------------------------------------
; IF ELSE ENDIF
;------------------------------------------------------------------------------
        if   1 
        defb 1                          ;=> 0145  01
        if   1 
        defb 2                          ;=> 0146  02
        else 
        defb 3 
        endif 
        else 
        defb 4 
        if   1 
        defb 5 
        else 
        defb 6 
        endif 
        endif 

        if   0 
        defb 7 
        endif 
        
        if   1 
        defb 8                          ;=> 0147  08
        endif 
        
        if   0 
        defb 9 
        else 
        defb 10                         ;=> 0148  0A
        endif 
        
        if   undefined 
        defb 11 
        else 
        defb 12                         ;=> 0149  0C
        endif 

        if   undefined | 1 
        defb 13                         ;=> 014A  0D
        else 
        defb 14 
        endif 

;------------------------------------------------------------------------------
; Z88DK specific opcodes
;------------------------------------------------------------------------------
        call_oz 1                       ;=> 014B  E7 01
        call_oz 255                     ;=> 014D  E7 FF
        call_oz 256                     ;=> 014F  E7 00 01
        call_oz 65535                   ;=> 0152  E7 FF FF

        call_pkg 0                      ;=> 0155  CF 00 00
        call_pkg 1                      ;=> 0158  CF 01 00
        call_pkg 65535                  ;=> 015B  CF FF FF
        
        fpp  1                          ;=> 015E  DF 01
        fpp  254                        ;=> 0160  DF FE

        invoke 0                        ;=> 0162  CD 00 00
        invoke 1                        ;=> 0165  CD 01 00
        invoke 65535                    ;=> 0168  CD FF FF
        
;------------------------------------------------------------------------------
; 8 bit load group
;------------------------------------------------------------------------------

        ld   b,b                        ;=> 016B  40
        ld   c,b                        ;=> 016C  48
        ld   d,b                        ;=> 016D  50
        ld   e,b                        ;=> 016E  58
        ld   h,b                        ;=> 016F  60
        ld   l,b                        ;=> 0170  68
        ld   a,b                        ;=> 0171  78
        ld   b,c                        ;=> 0172  41
        ld   c,c                        ;=> 0173  49
        ld   d,c                        ;=> 0174  51
        ld   e,c                        ;=> 0175  59
        ld   h,c                        ;=> 0176  61
        ld   l,c                        ;=> 0177  69
        ld   a,c                        ;=> 0178  79
        ld   b,d                        ;=> 0179  42
        ld   c,d                        ;=> 017A  4A
        ld   d,d                        ;=> 017B  52
        ld   e,d                        ;=> 017C  5A
        ld   h,d                        ;=> 017D  62
        ld   l,d                        ;=> 017E  6A
        ld   a,d                        ;=> 017F  7A
        ld   b,e                        ;=> 0180  43
        ld   c,e                        ;=> 0181  4B
        ld   d,e                        ;=> 0182  53
        ld   e,e                        ;=> 0183  5B
        ld   h,e                        ;=> 0184  63
        ld   l,e                        ;=> 0185  6B
        ld   a,e                        ;=> 0186  7B
        ld   b,h                        ;=> 0187  44
        ld   c,h                        ;=> 0188  4C
        ld   d,h                        ;=> 0189  54
        ld   e,h                        ;=> 018A  5C
        ld   h,h                        ;=> 018B  64
        ld   l,h                        ;=> 018C  6C
        ld   a,h                        ;=> 018D  7C
        ld   b,l                        ;=> 018E  45
        ld   c,l                        ;=> 018F  4D
        ld   d,l                        ;=> 0190  55
        ld   e,l                        ;=> 0191  5D
        ld   h,l                        ;=> 0192  65
        ld   l,l                        ;=> 0193  6D
        ld   a,l                        ;=> 0194  7D
        ld   b,a                        ;=> 0195  47
        ld   c,a                        ;=> 0196  4F
        ld   d,a                        ;=> 0197  57
        ld   e,a                        ;=> 0198  5F
        ld   h,a                        ;=> 0199  67
        ld   l,a                        ;=> 019A  6F
        ld   a,a                        ;=> 019B  7F
        ld   b,N                        ;=> 019C  06 20
        ld   c,N                        ;=> 019E  0E 20
        ld   d,N                        ;=> 01A0  16 20
        ld   e,N                        ;=> 01A2  1E 20
        ld   h,N                        ;=> 01A4  26 20
        ld   l,N                        ;=> 01A6  2E 20
        ld   a,N                        ;=> 01A8  3E 20

        ld   b,ixh                      ;=> 01AA  DD 44
        ld   c,ixh                      ;=> 01AC  DD 4C
        ld   d,ixh                      ;=> 01AE  DD 54
        ld   e,ixh                      ;=> 01B0  DD 5C
        ld   ixh,ixh                    ;=> 01B2  DD 64
        ld   ixl,ixh                    ;=> 01B4  DD 6C
        ld   a,ixh                      ;=> 01B6  DD 7C
        ld   b,ixl                      ;=> 01B8  DD 45
        ld   c,ixl                      ;=> 01BA  DD 4D
        ld   d,ixl                      ;=> 01BC  DD 55
        ld   e,ixl                      ;=> 01BE  DD 5D
        ld   ixh,ixl                    ;=> 01C0  DD 65
        ld   ixl,ixl                    ;=> 01C2  DD 6D
        ld   a,ixl                      ;=> 01C4  DD 7D
        ld   ixh,b                      ;=> 01C6  DD 60
        ld   ixl,b                      ;=> 01C8  DD 68
        ld   ixh,c                      ;=> 01CA  DD 61
        ld   ixl,c                      ;=> 01CC  DD 69
        ld   ixh,d                      ;=> 01CE  DD 62
        ld   ixl,d                      ;=> 01D0  DD 6A
        ld   ixh,e                      ;=> 01D2  DD 63
        ld   ixl,e                      ;=> 01D4  DD 6B
        ld   ixh,ixh                    ;=> 01D6  DD 64
        ld   ixl,ixh                    ;=> 01D8  DD 6C
        ld   ixh,ixl                    ;=> 01DA  DD 65
        ld   ixl,ixl                    ;=> 01DC  DD 6D
        ld   ixh,a                      ;=> 01DE  DD 67
        ld   ixl,a                      ;=> 01E0  DD 6F
        ld   ixh,N                      ;=> 01E2  DD 26 20
        ld   ixl,N                      ;=> 01E5  DD 2E 20
        
        ld   b,iyh                      ;=> 01E8  FD 44
        ld   c,iyh                      ;=> 01EA  FD 4C
        ld   d,iyh                      ;=> 01EC  FD 54
        ld   e,iyh                      ;=> 01EE  FD 5C
        ld   iyh,iyh                    ;=> 01F0  FD 64
        ld   iyl,iyh                    ;=> 01F2  FD 6C
        ld   a,iyh                      ;=> 01F4  FD 7C
        ld   b,iyl                      ;=> 01F6  FD 45
        ld   c,iyl                      ;=> 01F8  FD 4D
        ld   d,iyl                      ;=> 01FA  FD 55
        ld   e,iyl                      ;=> 01FC  FD 5D
        ld   iyh,iyl                    ;=> 01FE  FD 65
        ld   iyl,iyl                    ;=> 0200  FD 6D
        ld   a,iyl                      ;=> 0202  FD 7D
        ld   iyh,b                      ;=> 0204  FD 60
        ld   iyl,b                      ;=> 0206  FD 68
        ld   iyh,c                      ;=> 0208  FD 61
        ld   iyl,c                      ;=> 020A  FD 69
        ld   iyh,d                      ;=> 020C  FD 62
        ld   iyl,d                      ;=> 020E  FD 6A
        ld   iyh,e                      ;=> 0210  FD 63
        ld   iyl,e                      ;=> 0212  FD 6B
        ld   iyh,iyh                    ;=> 0214  FD 64
        ld   iyl,iyh                    ;=> 0216  FD 6C
        ld   iyh,iyl                    ;=> 0218  FD 65
        ld   iyl,iyl                    ;=> 021A  FD 6D
        ld   iyh,a                      ;=> 021C  FD 67
        ld   iyl,a                      ;=> 021E  FD 6F
        ld   iyh,N                      ;=> 0220  FD 26 20
        ld   iyl,N                      ;=> 0223  FD 2E 20

        ld   b,(hl)                     ;=> 0226  46
        ld   c,(hl)                     ;=> 0227  4E
        ld   d,(hl)                     ;=> 0228  56
        ld   e,(hl)                     ;=> 0229  5E
        ld   h,(hl)                     ;=> 022A  66
        ld   l,(hl)                     ;=> 022B  6E
        ld   a,(hl)                     ;=> 022C  7E
;	ldi	b,(hl)			;; 	ld	b,(hl) ;; inc hl
;	ldi	c,(hl)			;; 	ld	c,(hl) ;; inc hl
;	ldi	d,(hl)			;; 	ld	d,(hl) ;; inc hl
;	ldi	e,(hl)			;; 	ld	e,(hl) ;; inc hl
;	ldi	h,(hl)			;; 	ld	h,(hl) ;; inc hl
;	ldi	l,(hl)			;; 	ld	l,(hl) ;; inc hl
;	ldi	a,(hl)			;; 	ld	a,(hl) ;; inc hl
;	ldd	b,(hl)			;; 	ld	b,(hl) ;; dec hl
;	ldd	c,(hl)			;; 	ld	c,(hl) ;; dec hl
;	ldd	d,(hl)			;; 	ld	d,(hl) ;; dec hl
;	ldd	e,(hl)			;; 	ld	e,(hl) ;; dec hl
;	ldd	h,(hl)			;; 	ld	h,(hl) ;; dec hl
;	ldd	l,(hl)			;; 	ld	l,(hl) ;; dec hl
;	ldd	a,(hl)			;; 	ld	a,(hl) ;; dec hl

        ld   b,(ix+DIS)                 ;=> 022D  DD 46 40
        ld   c,(ix+DIS)                 ;=> 0230  DD 4E 40
        ld   d,(ix+DIS)                 ;=> 0233  DD 56 40
        ld   e,(ix+DIS)                 ;=> 0236  DD 5E 40
        ld   h,(ix+DIS)                 ;=> 0239  DD 66 40
        ld   l,(ix+DIS)                 ;=> 023C  DD 6E 40
        ld   a,(ix+DIS)                 ;=> 023F  DD 7E 40
;	ldi	b,(ix+DIS)		;;	ld	b,(ix+DIS) ;; inc ix
;	ldi	c,(ix+DIS)		;;	ld	c,(ix+DIS) ;; inc ix
;	ldi	d,(ix+DIS)		;;	ld	d,(ix+DIS) ;; inc ix
;	ldi	e,(ix+DIS)		;;	ld	e,(ix+DIS) ;; inc ix
;	ldi	h,(ix+DIS)		;;	ld	h,(ix+DIS) ;; inc ix
;	ldi	l,(ix+DIS)		;;	ld	l,(ix+DIS) ;; inc ix
;	ldi	a,(ix+DIS)		;;	ld	a,(ix+DIS) ;; inc ix
;	ldd	b,(ix+DIS)		;;	ld	b,(ix+DIS) ;; dec ix
;	ldd	c,(ix+DIS)		;;	ld	c,(ix+DIS) ;; dec ix
;	ldd	d,(ix+DIS)		;;	ld	d,(ix+DIS) ;; dec ix
;	ldd	e,(ix+DIS)		;;	ld	e,(ix+DIS) ;; dec ix
;	ldd	h,(ix+DIS)		;;	ld	h,(ix+DIS) ;; dec ix
;	ldd	l,(ix+DIS)		;;	ld	l,(ix+DIS) ;; dec ix
;	ldd	a,(ix+DIS)		;;	ld	a,(ix+DIS) ;; dec ix

        ld   b,(iy+DIS)                 ;=> 0242  FD 46 40
        ld   c,(iy+DIS)                 ;=> 0245  FD 4E 40
        ld   d,(iy+DIS)                 ;=> 0248  FD 56 40
        ld   e,(iy+DIS)                 ;=> 024B  FD 5E 40
        ld   h,(iy+DIS)                 ;=> 024E  FD 66 40
        ld   l,(iy+DIS)                 ;=> 0251  FD 6E 40
        ld   a,(iy+DIS)                 ;=> 0254  FD 7E 40
;	ldi	b,(iy+DIS)		;;	ld	b,(iy+DIS) ;; inc iy
;	ldi	c,(iy+DIS)		;;	ld	c,(iy+DIS) ;; inc iy
;	ldi	d,(iy+DIS)		;;	ld	d,(iy+DIS) ;; inc iy
;	ldi	e,(iy+DIS)		;;	ld	e,(iy+DIS) ;; inc iy
;	ldi	h,(iy+DIS)		;;	ld	h,(iy+DIS) ;; inc iy
;	ldi	l,(iy+DIS)		;;	ld	l,(iy+DIS) ;; inc iy
;	ldi	a,(iy+DIS)		;;	ld	a,(iy+DIS) ;; inc iy
;	ldd	b,(iy+DIS)		;;	ld	b,(iy+DIS) ;; dec iy
;	ldd	c,(iy+DIS)		;;	ld	c,(iy+DIS) ;; dec iy
;	ldd	d,(iy+DIS)		;;	ld	d,(iy+DIS) ;; dec iy
;	ldd	e,(iy+DIS)		;;	ld	e,(iy+DIS) ;; dec iy
;	ldd	h,(iy+DIS)		;;	ld	h,(iy+DIS) ;; dec iy
;	ldd	l,(iy+DIS)		;;	ld	l,(iy+DIS) ;; dec iy
;	ldd	a,(iy+DIS)		;;	ld	a,(iy+DIS) ;; dec iy

        ld   (hl),b                     ;=> 0257  70
        ld   (hl),c                     ;=> 0258  71
        ld   (hl),d                     ;=> 0259  72
        ld   (hl),e                     ;=> 025A  73
        ld   (hl),h                     ;=> 025B  74
        ld   (hl),l                     ;=> 025C  75
        ld   (hl),a                     ;=> 025D  77
;	ldi	(hl),b			;; 	ld	(hl),b ;; inc hl
;	ldi	(hl),c			;; 	ld	(hl),c ;; inc hl
;	ldi	(hl),d			;; 	ld	(hl),d ;; inc hl
;	ldi	(hl),e			;; 	ld	(hl),e ;; inc hl
;	ldi	(hl),h			;; 	ld	(hl),h ;; inc hl
;	ldi	(hl),l			;; 	ld	(hl),l ;; inc hl
;	ldi	(hl),a			;; 	ld	(hl),a ;; inc hl
;	ldd	(hl),b			;; 	ld	(hl),b ;; dec hl
;	ldd	(hl),c			;; 	ld	(hl),c ;; dec hl
;	ldd	(hl),d			;; 	ld	(hl),d ;; dec hl
;	ldd	(hl),e			;; 	ld	(hl),e ;; dec hl
;	ldd	(hl),h			;; 	ld	(hl),h ;; dec hl
;	ldd	(hl),l			;; 	ld	(hl),l ;; dec hl
;	ldd	(hl),a			;; 	ld	(hl),a ;; dec hl

        ld   (ix+DIS),b                 ;=> 025E  DD 70 40
        ld   (ix+DIS),c                 ;=> 0261  DD 71 40
        ld   (ix+DIS),d                 ;=> 0264  DD 72 40
        ld   (ix+DIS),e                 ;=> 0267  DD 73 40
        ld   (ix+DIS),h                 ;=> 026A  DD 74 40
        ld   (ix+DIS),l                 ;=> 026D  DD 75 40
        ld   (ix+DIS),a                 ;=> 0270  DD 77 40
;	ldi	(ix+DIS),b		;;	ld	(ix+DIS),b ;; inc ix
;	ldi	(ix+DIS),c		;;	ld	(ix+DIS),c ;; inc ix
;	ldi	(ix+DIS),d		;;	ld	(ix+DIS),d ;; inc ix
;	ldi	(ix+DIS),e		;;	ld	(ix+DIS),e ;; inc ix
;	ldi	(ix+DIS),h		;;	ld	(ix+DIS),h ;; inc ix
;	ldi	(ix+DIS),l		;;	ld	(ix+DIS),l ;; inc ix
;	ldi	(ix+DIS),a		;;	ld	(ix+DIS),a ;; inc ix
;	ldd	(ix+DIS),b		;;	ld	(ix+DIS),b ;; dec ix
;	ldd	(ix+DIS),c		;;	ld	(ix+DIS),c ;; dec ix
;	ldd	(ix+DIS),d		;;	ld	(ix+DIS),d ;; dec ix
;	ldd	(ix+DIS),e		;;	ld	(ix+DIS),e ;; dec ix
;	ldd	(ix+DIS),h		;;	ld	(ix+DIS),h ;; dec ix
;	ldd	(ix+DIS),l		;;	ld	(ix+DIS),l ;; dec ix
;	ldd	(ix+DIS),a		;;	ld	(ix+DIS),a ;; dec ix

        ld   (iy+DIS),b                 ;=> 0273  FD 70 40
        ld   (iy+DIS),c                 ;=> 0276  FD 71 40
        ld   (iy+DIS),d                 ;=> 0279  FD 72 40
        ld   (iy+DIS),e                 ;=> 027C  FD 73 40
        ld   (iy+DIS),h                 ;=> 027F  FD 74 40
        ld   (iy+DIS),l                 ;=> 0282  FD 75 40
        ld   (iy+DIS),a                 ;=> 0285  FD 77 40
;	ldi	(iy+DIS),b		;;	ld	(iy+DIS),b ;; inc iy
;	ldi	(iy+DIS),c		;;	ld	(iy+DIS),c ;; inc iy
;	ldi	(iy+DIS),d		;;	ld	(iy+DIS),d ;; inc iy
;	ldi	(iy+DIS),e		;;	ld	(iy+DIS),e ;; inc iy
;	ldi	(iy+DIS),h		;;	ld	(iy+DIS),h ;; inc iy
;	ldi	(iy+DIS),l		;;	ld	(iy+DIS),l ;; inc iy
;	ldi	(iy+DIS),a		;;	ld	(iy+DIS),a ;; inc iy
;	ldd	(iy+DIS),b		;;	ld	(iy+DIS),b ;; dec iy
;	ldd	(iy+DIS),c		;;	ld	(iy+DIS),c ;; dec iy
;	ldd	(iy+DIS),d		;;	ld	(iy+DIS),d ;; dec iy
;	ldd	(iy+DIS),e		;;	ld	(iy+DIS),e ;; dec iy
;	ldd	(iy+DIS),h		;;	ld	(iy+DIS),h ;; dec iy
;	ldd	(iy+DIS),l		;;	ld	(iy+DIS),l ;; dec iy
;	ldd	(iy+DIS),a		;;	ld	(iy+DIS),a ;; dec iy

        ld   (hl),N                     ;=> 0288  36 20
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

        ld   (ix+DIS),N                 ;=> 028A  DD 36 40 20
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

        ld   (iy+DIS),N                 ;=> 028E  FD 36 40 20
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

        ld   a,(bc)                     ;=> 0292  0A
        ld   a,(de)                     ;=> 0293  1A
;	ldi	a,(bc)						;;	ld	a,(bc) ;; inc bc
;	ldi	a,(de)						;;	ld	a,(de) ;; inc de
;	ldd	a,(bc)						;;	ld	a,(bc) ;; dec bc
;	ldd	a,(de)						;;	ld	a,(de) ;; dec de

        ld   (bc),a                     ;=> 0294  02
        ld   (de),a                     ;=> 0295  12
;	ldi	(bc),a						;;	ld	(bc),a ;; inc bc
;	ldi	(de),a						;;	ld	(de),a ;; inc de
;	ldd	(bc),a						;;	ld	(bc),a ;; dec bc
;	ldd	(de),a						;;	ld	(de),a ;; dec de

        ld   a,(NN)                     ;=> 0296  3A 30 00
        ld   (NN),a                     ;=> 0299  32 30 00

        ld   a,i                        ;=> 029C  ED 57
        ld   a,r                        ;=> 029E  ED 5F
        ld   i,a                        ;=> 02A0  ED 47
        ld   r,a                        ;=> 02A2  ED 4F

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

        ld   bc,NN                      ;=> 02A4  01 30 00
        ld   de,NN                      ;=> 02A7  11 30 00
        ld   hl,NN                      ;=> 02AA  21 30 00
        ld   ix,NN                      ;=> 02AD  DD 21 30 00
        ld   iy,NN                      ;=> 02B1  FD 21 30 00
        ld   sp,NN                      ;=> 02B5  31 30 00
        ld   bc,(NN)                    ;=> 02B8  ED 4B 30 00
        ld   de,(NN)                    ;=> 02BC  ED 5B 30 00
        ld   hl,(NN)                    ;=> 02C0  2A 30 00
        ld   ix,(NN)                    ;=> 02C3  DD 2A 30 00
        ld   iy,(NN)                    ;=> 02C7  FD 2A 30 00
        ld   sp,(NN)                    ;=> 02CB  ED 7B 30 00
        ld   (NN),bc                    ;=> 02CF  ED 43 30 00
        ld   (NN),de                    ;=> 02D3  ED 53 30 00
        ld   (NN),hl                    ;=> 02D7  22 30 00
        ld   (NN),ix                    ;=> 02DA  DD 22 30 00
        ld   (NN),iy                    ;=> 02DE  FD 22 30 00
        ld   (NN),sp                    ;=> 02E2  ED 73 30 00
        ld   sp,hl                      ;=> 02E6  F9
        ld   sp,ix                      ;=> 02E7  DD F9
        ld   sp,iy                      ;=> 02E9  FD F9
        push bc                         ;=> 02EB  C5
        push de                         ;=> 02EC  D5
        push hl                         ;=> 02ED  E5
        push ix                         ;=> 02EE  DD E5
        push iy                         ;=> 02F0  FD E5
        push af                         ;=> 02F2  F5
        pop  bc                         ;=> 02F3  C1
        pop  de                         ;=> 02F4  D1
        pop  hl                         ;=> 02F5  E1
        pop  ix                         ;=> 02F6  DD E1
        pop  iy                         ;=> 02F8  FD E1
        pop  af                         ;=> 02FA  F1

;	ld	bc,bc	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	de,bc	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	hl,bc	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	bc,de	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	de,de	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	hl,de	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	bc,hl	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	de,hl	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	hl,hl	=}      0x40+<1:3>+<2>      0x49+<1:3>+<2>
;	ld	bc,ix				=} 0xDD 0x44+<1:3>     0xDD 0x4D+<1:3>
;	ld	de,ix				=} 0xDD 0x44+<1:3>     0xDD 0x4D+<1:3>
;	ld	bc,iy				=} 0xFD 0x44+<1:3>     0xFD 0x4D+<1:3>
;	ld	de,iy				=} 0xFD 0x44+<1:3>     0xFD 0x4D+<1:3>
;	
;	ld	bc,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x2B
;	ld	de,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x2B
;	ldi	bc,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x23
;	ldi	de,(hl)				=}      0x4E+<1:3> 0x23     0x46+<1:3> 0x23
;	
;	ld	bc,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS           0xDD 0x46+<1:3> DIS+1
;	ld	de,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS           0xDD 0x46+<1:3> DIS+1
;	ld	hl,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS           0xDD 0x46+<1:3> DIS+1
;	ldi	bc,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS 0xDD 0x23 0xDD 0x46+<1:3> DIS 0xDD 0x23 
;	ldi	de,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS 0xDD 0x23 0xDD 0x46+<1:3> DIS 0xDD 0x23 
;	ldi	hl,(ix+DIS)		=} 0xDD 0x4E+<1:3> DIS 0xDD 0x23 0xDD 0x46+<1:3> DIS 0xDD 0x23 
;	
;	ld	bc,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS           0xFD 0x46+<1:3> DIS+1
;	ld	de,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS           0xFD 0x46+<1:3> DIS+1
;	ld	hl,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS           0xFD 0x46+<1:3> DIS+1
;	ldi	bc,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS 0xFD 0x23 0xFD 0x46+<1:3> DIS 0xFD 0x23
;	ldi	de,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS 0xFD 0x23 0xFD 0x46+<1:3> DIS 0xFD 0x23
;	ldi	hl,(iy+DIS)		=} 0xFD 0x4E+<1:3> DIS 0xFD 0x23 0xFD 0x46+<1:3> DIS 0xFD 0x23
;	
;	ld 	(hl),bc				=}      0x71+<2> 0x23     0x70+<2> 0x2B
;	ld 	(hl),de				=}      0x71+<2> 0x23     0x70+<2> 0x2B
;	ldi	(hl),bc				=}      0x71+<2> 0x23     0x70+<2> 0x23
;	ldi	(hl),de				=}      0x71+<2> 0x23     0x70+<2> 0x23
;	
;	ld 	(ix+DIS),bc		=} 0xDD 0x71+<2> DIS           0xDD 0x70+<2> DIS+1
;	ld 	(ix+DIS),de		=} 0xDD 0x71+<2> DIS           0xDD 0x70+<2> DIS+1
;	ld 	(ix+DIS),hl		=} 0xDD 0x71+<2> DIS           0xDD 0x70+<2> DIS+1
;	ldi	(ix+DIS),bc		=} 0xDD 0x71+<2> DIS 0xDD 0x23 0xDD 0x70+<2> DIS 0xDD 0x23
;	ldi	(ix+DIS),de		=} 0xDD 0x71+<2> DIS 0xDD 0x23 0xDD 0x70+<2> DIS 0xDD 0x23
;	ldi	(ix+DIS),hl		=} 0xDD 0x71+<2> DIS 0xDD 0x23 0xDD 0x70+<2> DIS 0xDD 0x23
;	
;	ld 	(iy+DIS),bc		=} 0xFD 0x71+<2> DIS 0xFD 0x70+<2> DIS+1
;	ld 	(iy+DIS),de		=} 0xFD 0x71+<2> DIS 0xFD 0x70+<2> DIS+1
;	ld 	(iy+DIS),hl		=} 0xFD 0x71+<2> DIS 0xFD 0x70+<2> DIS+1
;	ldi	(iy+DIS),bc		=} 0xFD 0x71+<2> DIS 0xFD 0x23 0xFD 0x70+<2> DIS 0xFD 0x23
;	ldi	(iy+DIS),de		=} 0xFD 0x71+<2> DIS 0xFD 0x23 0xFD 0x70+<2> DIS 0xFD 0x23
;	ldi	(iy+DIS),hl		=} 0xFD 0x71+<2> DIS 0xFD 0x23 0xFD 0x70+<2> DIS 0xFD 0x23
;	
;	ld 	hl,ix						=} 0xDD 0xE5 0xE1
;	ld 	hl,iy						=} 0xFD 0xE5 0xE1
;	
;	ld	ix,bc				=} 0xDD 0x69+<2>       0xDD 0x60+<2>
;	ld	ix,de				=} 0xDD 0x69+<2>       0xDD 0x60+<2>
;	ld	iy,bc				=} 0xFD 0x69+<2>       0xFD 0x60+<2>
;	ld	iy,de				=} 0xFD 0x69+<2>       0xFD 0x60+<2>
;	
;	ld ix,hl						=} 0xE5 0xDD 0xE1
;	ld iy,hl						=} 0xE5 0xFD 0xE1
;	
;	ld ix,ix						=} 0xDD 0x6D 0xDD 0x64
;	ld ix,iy						=} 0xFD 0xE5 0xDD 0xE1
;	
;	ld iy,iy						=} 0xFD 0x6D 0xFD 0x64
;	ld iy,ix						=} 0xDD 0xE5 0xFD 0xE1


;------------------------------------------------------------------------------
; Exchange, block transfer, search group
;------------------------------------------------------------------------------

        ex   de,hl                      ;=> 02FB  EB
        ex   af,af                      ;=> 02FC  08
        ex   af,af'                     ;=> 02FD  08
        exx                             ;=> 02FE  D9
        
        ex   (sp),hl                    ;=> 02FF  E3
        ex   (sp),ix                    ;=> 0300  DD E3
        ex   (sp),iy                    ;=> 0302  FD E3

        ldi                             ;=> 0304  ED A0
        ldir                            ;=> 0306  ED B0
        ldd                             ;=> 0308  ED A8
        lddr                            ;=> 030A  ED B8

        cpi                             ;=> 030C  ED A1
        cpir                            ;=> 030E  ED B1
        cpd                             ;=> 0310  ED A9
        cpdr                            ;=> 0312  ED B9

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  a,b                        ;=> 0314  80
        adc  a,b                        ;=> 0315  88
        sbc  a,b                        ;=> 0316  98
        add  a,c                        ;=> 0317  81
        adc  a,c                        ;=> 0318  89
        sbc  a,c                        ;=> 0319  99
        add  a,d                        ;=> 031A  82
        adc  a,d                        ;=> 031B  8A
        sbc  a,d                        ;=> 031C  9A
        add  a,e                        ;=> 031D  83
        adc  a,e                        ;=> 031E  8B
        sbc  a,e                        ;=> 031F  9B
        add  a,h                        ;=> 0320  84
        adc  a,h                        ;=> 0321  8C
        sbc  a,h                        ;=> 0322  9C
        add  a,l                        ;=> 0323  85
        adc  a,l                        ;=> 0324  8D
        sbc  a,l                        ;=> 0325  9D
        add  a,a                        ;=> 0326  87
        adc  a,a                        ;=> 0327  8F
        sbc  a,a                        ;=> 0328  9F
        add  a,(hl)                     ;=> 0329  86
        adc  a,(hl)                     ;=> 032A  8E
        sbc  a,(hl)                     ;=> 032B  9E
        add  a,(ix+DIS)                 ;=> 032C  DD 86 40
        adc  a,(ix+DIS)                 ;=> 032F  DD 8E 40
        sbc  a,(ix+DIS)                 ;=> 0332  DD 9E 40
        add  a,(iy+DIS)                 ;=> 0335  FD 86 40
        adc  a,(iy+DIS)                 ;=> 0338  FD 8E 40
        sbc  a,(iy+DIS)                 ;=> 033B  FD 9E 40
        add  a,N                        ;=> 033E  C6 20
        adc  a,N                        ;=> 0340  CE 20
        sbc  a,N                        ;=> 0342  DE 20
        add  b                          ;=> 0344  80
        adc  b                          ;=> 0345  88
        sbc  b                          ;=> 0346  98
        add  c                          ;=> 0347  81
        adc  c                          ;=> 0348  89
        sbc  c                          ;=> 0349  99
        add  d                          ;=> 034A  82
        adc  d                          ;=> 034B  8A
        sbc  d                          ;=> 034C  9A
        add  e                          ;=> 034D  83
        adc  e                          ;=> 034E  8B
        sbc  e                          ;=> 034F  9B
        add  h                          ;=> 0350  84
        adc  h                          ;=> 0351  8C
        sbc  h                          ;=> 0352  9C
        add  l                          ;=> 0353  85
        adc  l                          ;=> 0354  8D
        sbc  l                          ;=> 0355  9D
        add  a                          ;=> 0356  87
        adc  a                          ;=> 0357  8F
        sbc  a                          ;=> 0358  9F
        add  (hl)                       ;=> 0359  86
        adc  (hl)                       ;=> 035A  8E
        sbc  (hl)                       ;=> 035B  9E
        add  (ix+DIS)                   ;=> 035C  DD 86 40
        adc  (ix+DIS)                   ;=> 035F  DD 8E 40
        sbc  (ix+DIS)                   ;=> 0362  DD 9E 40
        add  (iy+DIS)                   ;=> 0365  FD 86 40
        adc  (iy+DIS)                   ;=> 0368  FD 8E 40
        sbc  (iy+DIS)                   ;=> 036B  FD 9E 40
        add  N                          ;=> 036E  C6 20
        adc  N                          ;=> 0370  CE 20
        sbc  N                          ;=> 0372  DE 20
        
        sub  b                          ;=> 0374  90
        and  b                          ;=> 0375  A0
        xor  b                          ;=> 0376  A8
        or   b                          ;=> 0377  B0
        cp   b                          ;=> 0378  B8
        sub  c                          ;=> 0379  91
        and  c                          ;=> 037A  A1
        xor  c                          ;=> 037B  A9
        or   c                          ;=> 037C  B1
        cp   c                          ;=> 037D  B9
        sub  d                          ;=> 037E  92
        and  d                          ;=> 037F  A2
        xor  d                          ;=> 0380  AA
        or   d                          ;=> 0381  B2
        cp   d                          ;=> 0382  BA
        sub  e                          ;=> 0383  93
        and  e                          ;=> 0384  A3
        xor  e                          ;=> 0385  AB
        or   e                          ;=> 0386  B3
        cp   e                          ;=> 0387  BB
        sub  h                          ;=> 0388  94
        and  h                          ;=> 0389  A4
        xor  h                          ;=> 038A  AC
        or   h                          ;=> 038B  B4
        cp   h                          ;=> 038C  BC
        sub  l                          ;=> 038D  95
        and  l                          ;=> 038E  A5
        xor  l                          ;=> 038F  AD
        or   l                          ;=> 0390  B5
        cp   l                          ;=> 0391  BD
        sub  a                          ;=> 0392  97
        and  a                          ;=> 0393  A7
        xor  a                          ;=> 0394  AF
        or   a                          ;=> 0395  B7
        cp   a                          ;=> 0396  BF
        sub  (hl)                       ;=> 0397  96
        and  (hl)                       ;=> 0398  A6
        xor  (hl)                       ;=> 0399  AE
        or   (hl)                       ;=> 039A  B6
        cp   (hl)                       ;=> 039B  BE
        sub  (ix+DIS)                   ;=> 039C  DD 96 40
        and  (ix+DIS)                   ;=> 039F  DD A6 40
        xor  (ix+DIS)                   ;=> 03A2  DD AE 40
        or   (ix+DIS)                   ;=> 03A5  DD B6 40
        cp   (ix+DIS)                   ;=> 03A8  DD BE 40
        sub  (iy+DIS)                   ;=> 03AB  FD 96 40
        and  (iy+DIS)                   ;=> 03AE  FD A6 40
        xor  (iy+DIS)                   ;=> 03B1  FD AE 40
        or   (iy+DIS)                   ;=> 03B4  FD B6 40
        cp   (iy+DIS)                   ;=> 03B7  FD BE 40
        sub  N                          ;=> 03BA  D6 20
        and  N                          ;=> 03BC  E6 20
        xor  N                          ;=> 03BE  EE 20
        or   N                          ;=> 03C0  F6 20
        cp   N                          ;=> 03C2  FE 20
        sub  a,b                        ;=> 03C4  90
        and  a,b                        ;=> 03C5  A0
        xor  a,b                        ;=> 03C6  A8
        or   a,b                        ;=> 03C7  B0
        cp   a,b                        ;=> 03C8  B8
        sub  a,c                        ;=> 03C9  91
        and  a,c                        ;=> 03CA  A1
        xor  a,c                        ;=> 03CB  A9
        or   a,c                        ;=> 03CC  B1
        cp   a,c                        ;=> 03CD  B9
        sub  a,d                        ;=> 03CE  92
        and  a,d                        ;=> 03CF  A2
        xor  a,d                        ;=> 03D0  AA
        or   a,d                        ;=> 03D1  B2
        cp   a,d                        ;=> 03D2  BA
        sub  a,e                        ;=> 03D3  93
        and  a,e                        ;=> 03D4  A3
        xor  a,e                        ;=> 03D5  AB
        or   a,e                        ;=> 03D6  B3
        cp   a,e                        ;=> 03D7  BB
        sub  a,h                        ;=> 03D8  94
        and  a,h                        ;=> 03D9  A4
        xor  a,h                        ;=> 03DA  AC
        or   a,h                        ;=> 03DB  B4
        cp   a,h                        ;=> 03DC  BC
        sub  a,l                        ;=> 03DD  95
        and  a,l                        ;=> 03DE  A5
        xor  a,l                        ;=> 03DF  AD
        or   a,l                        ;=> 03E0  B5
        cp   a,l                        ;=> 03E1  BD
        sub  a,a                        ;=> 03E2  97
        and  a,a                        ;=> 03E3  A7
        xor  a,a                        ;=> 03E4  AF
        or   a,a                        ;=> 03E5  B7
        cp   a,a                        ;=> 03E6  BF
        sub  a,(hl)                     ;=> 03E7  96
        and  a,(hl)                     ;=> 03E8  A6
        xor  a,(hl)                     ;=> 03E9  AE
        or   a,(hl)                     ;=> 03EA  B6
        cp   a,(hl)                     ;=> 03EB  BE
        sub  a,(ix+DIS)                 ;=> 03EC  DD 96 40
        and  a,(ix+DIS)                 ;=> 03EF  DD A6 40
        xor  a,(ix+DIS)                 ;=> 03F2  DD AE 40
        or   a,(ix+DIS)                 ;=> 03F5  DD B6 40
        cp   a,(ix+DIS)                 ;=> 03F8  DD BE 40
        sub  a,(iy+DIS)                 ;=> 03FB  FD 96 40
        and  a,(iy+DIS)                 ;=> 03FE  FD A6 40
        xor  a,(iy+DIS)                 ;=> 0401  FD AE 40
        or   a,(iy+DIS)                 ;=> 0404  FD B6 40
        cp   a,(iy+DIS)                 ;=> 0407  FD BE 40
        sub  a,N                        ;=> 040A  D6 20
        and  a,N                        ;=> 040C  E6 20
        xor  a,N                        ;=> 040E  EE 20
        or   a,N                        ;=> 0410  F6 20
        cp   a,N                        ;=> 0412  FE 20
        
        inc  b                          ;=> 0414  04
        dec  b                          ;=> 0415  05
        inc  c                          ;=> 0416  0C
        dec  c                          ;=> 0417  0D
        inc  d                          ;=> 0418  14
        dec  d                          ;=> 0419  15
        inc  e                          ;=> 041A  1C
        dec  e                          ;=> 041B  1D
        inc  h                          ;=> 041C  24
        dec  h                          ;=> 041D  25
        inc  l                          ;=> 041E  2C
        dec  l                          ;=> 041F  2D
        inc  a                          ;=> 0420  3C
        dec  a                          ;=> 0421  3D
        inc  (hl)                       ;=> 0422  34
        dec  (hl)                       ;=> 0423  35
        inc  (ix+DIS)                   ;=> 0424  DD 34 40
        dec  (ix+DIS)                   ;=> 0427  DD 35 40
        inc  (iy+DIS)                   ;=> 042A  FD 34 40
        dec  (iy+DIS)                   ;=> 042D  FD 35 40
        
        add  a,ixh                      ;=> 0430  DD 84
        adc  a,ixh                      ;=> 0432  DD 8C
        sbc  a,ixh                      ;=> 0434  DD 9C
        add  a,ixl                      ;=> 0436  DD 85
        adc  a,ixl                      ;=> 0438  DD 8D
        sbc  a,ixl                      ;=> 043A  DD 9D
        add  a,iyh                      ;=> 043C  FD 84
        adc  a,iyh                      ;=> 043E  FD 8C
        sbc  a,iyh                      ;=> 0440  FD 9C
        add  a,iyl                      ;=> 0442  FD 85
        adc  a,iyl                      ;=> 0444  FD 8D
        sbc  a,iyl                      ;=> 0446  FD 9D
        sub  ixh                        ;=> 0448  DD 94
        and  ixh                        ;=> 044A  DD A4
        xor  ixh                        ;=> 044C  DD AC
        or   ixh                        ;=> 044E  DD B4
        cp   ixh                        ;=> 0450  DD BC
        inc  ixh                        ;=> 0452  DD 24
        dec  ixh                        ;=> 0454  DD 25
        sub  ixl                        ;=> 0456  DD 95
        and  ixl                        ;=> 0458  DD A5
        xor  ixl                        ;=> 045A  DD AD
        or   ixl                        ;=> 045C  DD B5
        cp   ixl                        ;=> 045E  DD BD
        inc  ixl                        ;=> 0460  DD 2C
        dec  ixl                        ;=> 0462  DD 2D
        sub  iyh                        ;=> 0464  FD 94
        and  iyh                        ;=> 0466  FD A4
        xor  iyh                        ;=> 0468  FD AC
        or   iyh                        ;=> 046A  FD B4
        cp   iyh                        ;=> 046C  FD BC
        inc  iyh                        ;=> 046E  FD 24
        dec  iyh                        ;=> 0470  FD 25
        sub  iyl                        ;=> 0472  FD 95
        and  iyl                        ;=> 0474  FD A5
        xor  iyl                        ;=> 0476  FD AD
        or   iyl                        ;=> 0478  FD B5
        cp   iyl                        ;=> 047A  FD BD
        inc  iyl                        ;=> 047C  FD 2C
        dec  iyl                        ;=> 047E  FD 2D

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  hl,bc                      ;=> 0480  09
        add  hl,de                      ;=> 0481  19
        add  hl,hl                      ;=> 0482  29
        add  hl,sp                      ;=> 0483  39
        add  ix,bc                      ;=> 0484  DD 09
        add  ix,de                      ;=> 0486  DD 19
        add  ix,ix                      ;=> 0488  DD 29
        add  ix,sp                      ;=> 048A  DD 39
        add  iy,bc                      ;=> 048C  FD 09
        add  iy,de                      ;=> 048E  FD 19
        add  iy,iy                      ;=> 0490  FD 29
        add  iy,sp                      ;=> 0492  FD 39

        sbc  hl,bc                      ;=> 0494  ED 42
        adc  hl,bc                      ;=> 0496  ED 4A
        sbc  hl,de                      ;=> 0498  ED 52
        adc  hl,de                      ;=> 049A  ED 5A
        sbc  hl,hl                      ;=> 049C  ED 62
        adc  hl,hl                      ;=> 049E  ED 6A
        sbc  hl,sp                      ;=> 04A0  ED 72
        adc  hl,sp                      ;=> 04A2  ED 7A
;	sub       hl,bc						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,de						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,hl						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,sp						=} 0xB7 0xED 0x42+<2:4>

        inc  bc                         ;=> 04A4  03
        dec  bc                         ;=> 04A5  0B
        inc  de                         ;=> 04A6  13
        dec  de                         ;=> 04A7  1B
        inc  hl                         ;=> 04A8  23
        dec  hl                         ;=> 04A9  2B
        inc  ix                         ;=> 04AA  DD 23
        dec  ix                         ;=> 04AC  DD 2B
        inc  iy                         ;=> 04AE  FD 23
        dec  iy                         ;=> 04B0  FD 2B
        inc  sp                         ;=> 04B2  33
        dec  sp                         ;=> 04B3  3B

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

        rlca                            ;=> 04B4  07
        rrca                            ;=> 04B5  0F
        rla                             ;=> 04B6  17
        rra                             ;=> 04B7  1F

        rlc  b                          ;=> 04B8  CB 00
        rrc  b                          ;=> 04BA  CB 08
        rl   b                          ;=> 04BC  CB 10
        rr   b                          ;=> 04BE  CB 18
        sla  b                          ;=> 04C0  CB 20
        sra  b                          ;=> 04C2  CB 28
        srl  b                          ;=> 04C4  CB 38
        rlc  c                          ;=> 04C6  CB 01
        rrc  c                          ;=> 04C8  CB 09
        rl   c                          ;=> 04CA  CB 11
        rr   c                          ;=> 04CC  CB 19
        sla  c                          ;=> 04CE  CB 21
        sra  c                          ;=> 04D0  CB 29
        srl  c                          ;=> 04D2  CB 39
        rlc  d                          ;=> 04D4  CB 02
        rrc  d                          ;=> 04D6  CB 0A
        rl   d                          ;=> 04D8  CB 12
        rr   d                          ;=> 04DA  CB 1A
        sla  d                          ;=> 04DC  CB 22
        sra  d                          ;=> 04DE  CB 2A
        srl  d                          ;=> 04E0  CB 3A
        rlc  e                          ;=> 04E2  CB 03
        rrc  e                          ;=> 04E4  CB 0B
        rl   e                          ;=> 04E6  CB 13
        rr   e                          ;=> 04E8  CB 1B
        sla  e                          ;=> 04EA  CB 23
        sra  e                          ;=> 04EC  CB 2B
        srl  e                          ;=> 04EE  CB 3B
        rlc  h                          ;=> 04F0  CB 04
        rrc  h                          ;=> 04F2  CB 0C
        rl   h                          ;=> 04F4  CB 14
        rr   h                          ;=> 04F6  CB 1C
        sla  h                          ;=> 04F8  CB 24
        sra  h                          ;=> 04FA  CB 2C
        srl  h                          ;=> 04FC  CB 3C
        rlc  l                          ;=> 04FE  CB 05
        rrc  l                          ;=> 0500  CB 0D
        rl   l                          ;=> 0502  CB 15
        rr   l                          ;=> 0504  CB 1D
        sla  l                          ;=> 0506  CB 25
        sra  l                          ;=> 0508  CB 2D
        srl  l                          ;=> 050A  CB 3D
        rlc  a                          ;=> 050C  CB 07
        rrc  a                          ;=> 050E  CB 0F
        rl   a                          ;=> 0510  CB 17
        rr   a                          ;=> 0512  CB 1F
        sla  a                          ;=> 0514  CB 27
        sra  a                          ;=> 0516  CB 2F
        srl  a                          ;=> 0518  CB 3F
        rlc  (hl)                       ;=> 051A  CB 06
        rrc  (hl)                       ;=> 051C  CB 0E
        rl   (hl)                       ;=> 051E  CB 16
        rr   (hl)                       ;=> 0520  CB 1E
        sla  (hl)                       ;=> 0522  CB 26
        sra  (hl)                       ;=> 0524  CB 2E
        srl  (hl)                       ;=> 0526  CB 3E
        rlc  (ix+DIS)                   ;=> 0528  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 052C  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 0530  DD CB 40 16
        rr   (ix+DIS)                   ;=> 0534  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 0538  DD CB 40 26
        sra  (ix+DIS)                   ;=> 053C  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 0540  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 0544  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 0548  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 054C  FD CB 40 16
        rr   (iy+DIS)                   ;=> 0550  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 0554  FD CB 40 26
        sra  (iy+DIS)                   ;=> 0558  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 055C  FD CB 40 3E
;	rlc (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),b	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),c	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),d	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),e	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),h	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),l	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rrc (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rl (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rr (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sla (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	sra (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	srl (ix+DIS),a	=} 0xDD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),b	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),c	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),d	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),e	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),h	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),l	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rlc (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rrc (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rl (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	rr (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sla (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sra (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	srl (iy+DIS),a	=} 0xFD 0xCB DIS 0x00+<0:3+<2
;	sll ...
;	sli ...

        rld                             ;=> 0560  ED 6F
        rrd                             ;=> 0562  ED 67

;	# rotate 16 bits
;
;	rl bc					=} 0xCB 0x11+<1 0xCB 0x10+<1
;	rl de					=} 0xCB 0x11+<1 0xCB 0x10+<1
;	rl hl					=} 0xCB 0x11+<1 0xCB 0x10+<1
;	rr bc					=} 0xCB 0x18+<1 0xCB 0x19+<1
;	rr de					=} 0xCB 0x18+<1 0xCB 0x19+<1
;	rr hl					=} 0xCB 0x18+<1 0xCB 0x19+<1
;
;	sla hl							=} 0x29			# special case: add hl,hl
;	sla bc				=} 0xCB 0x21+<1 0xCB 0x10+<1
;	sla de				=} 0xCB 0x21+<1 0xCB 0x10+<1
;	sla hl				=} 0xCB 0x21+<1 0xCB 0x10+<1
;	sll bc				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sll de				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sll hl				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sli bc				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sli de				=} 0xCB 0x31+<1 0xCB 0x10+<1
;	sli hl				=} 0xCB 0x31+<1 0xCB 0x10+<1
;
;	sra bc				=} 0xCB 0x28+<1 0xCB 0x19+<1
;	sra de				=} 0xCB 0x28+<1 0xCB 0x19+<1
;	sra hl				=} 0xCB 0x28+<1 0xCB 0x19+<1
;	srl bc				=} 0xCB 0x38+<1 0xCB 0x19+<1
;	srl de				=} 0xCB 0x38+<1 0xCB 0x19+<1
;	srl hl				=} 0xCB 0x38+<1 0xCB 0x19+<1

;------------------------------------------------------------------------------
; General purpose arithmetic and CPU control group
;------------------------------------------------------------------------------

        cpl                             ;=> 0564  2F
        neg                             ;=> 0565  ED 44
        ccf                             ;=> 0567  3F
        scf                             ;=> 0568  37
        nop                             ;=> 0569  00

        daa                             ;=> 056A  27
        di                              ;=> 056B  F3
        ei                              ;=> 056C  FB
        halt                            ;=> 056D  76
        im   0                          ;=> 056E  ED 46
        im   1                          ;=> 0570  ED 56
        im   2                          ;=> 0572  ED 5E

;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

        bit  0,b                        ;=> 0574  CB 40
        res  0,b                        ;=> 0576  CB 80
        set  0,b                        ;=> 0578  CB C0
        bit  1,b                        ;=> 057A  CB 48
        res  1,b                        ;=> 057C  CB 88
        set  1,b                        ;=> 057E  CB C8
        bit  2,b                        ;=> 0580  CB 50
        res  2,b                        ;=> 0582  CB 90
        set  2,b                        ;=> 0584  CB D0
        bit  3,b                        ;=> 0586  CB 58
        res  3,b                        ;=> 0588  CB 98
        set  3,b                        ;=> 058A  CB D8
        bit  4,b                        ;=> 058C  CB 60
        res  4,b                        ;=> 058E  CB A0
        set  4,b                        ;=> 0590  CB E0
        bit  5,b                        ;=> 0592  CB 68
        res  5,b                        ;=> 0594  CB A8
        set  5,b                        ;=> 0596  CB E8
        bit  6,b                        ;=> 0598  CB 70
        res  6,b                        ;=> 059A  CB B0
        set  6,b                        ;=> 059C  CB F0
        bit  7,b                        ;=> 059E  CB 78
        res  7,b                        ;=> 05A0  CB B8
        set  7,b                        ;=> 05A2  CB F8
        bit  0,c                        ;=> 05A4  CB 41
        res  0,c                        ;=> 05A6  CB 81
        set  0,c                        ;=> 05A8  CB C1
        bit  1,c                        ;=> 05AA  CB 49
        res  1,c                        ;=> 05AC  CB 89
        set  1,c                        ;=> 05AE  CB C9
        bit  2,c                        ;=> 05B0  CB 51
        res  2,c                        ;=> 05B2  CB 91
        set  2,c                        ;=> 05B4  CB D1
        bit  3,c                        ;=> 05B6  CB 59
        res  3,c                        ;=> 05B8  CB 99
        set  3,c                        ;=> 05BA  CB D9
        bit  4,c                        ;=> 05BC  CB 61
        res  4,c                        ;=> 05BE  CB A1
        set  4,c                        ;=> 05C0  CB E1
        bit  5,c                        ;=> 05C2  CB 69
        res  5,c                        ;=> 05C4  CB A9
        set  5,c                        ;=> 05C6  CB E9
        bit  6,c                        ;=> 05C8  CB 71
        res  6,c                        ;=> 05CA  CB B1
        set  6,c                        ;=> 05CC  CB F1
        bit  7,c                        ;=> 05CE  CB 79
        res  7,c                        ;=> 05D0  CB B9
        set  7,c                        ;=> 05D2  CB F9
        bit  0,d                        ;=> 05D4  CB 42
        res  0,d                        ;=> 05D6  CB 82
        set  0,d                        ;=> 05D8  CB C2
        bit  1,d                        ;=> 05DA  CB 4A
        res  1,d                        ;=> 05DC  CB 8A
        set  1,d                        ;=> 05DE  CB CA
        bit  2,d                        ;=> 05E0  CB 52
        res  2,d                        ;=> 05E2  CB 92
        set  2,d                        ;=> 05E4  CB D2
        bit  3,d                        ;=> 05E6  CB 5A
        res  3,d                        ;=> 05E8  CB 9A
        set  3,d                        ;=> 05EA  CB DA
        bit  4,d                        ;=> 05EC  CB 62
        res  4,d                        ;=> 05EE  CB A2
        set  4,d                        ;=> 05F0  CB E2
        bit  5,d                        ;=> 05F2  CB 6A
        res  5,d                        ;=> 05F4  CB AA
        set  5,d                        ;=> 05F6  CB EA
        bit  6,d                        ;=> 05F8  CB 72
        res  6,d                        ;=> 05FA  CB B2
        set  6,d                        ;=> 05FC  CB F2
        bit  7,d                        ;=> 05FE  CB 7A
        res  7,d                        ;=> 0600  CB BA
        set  7,d                        ;=> 0602  CB FA
        bit  0,e                        ;=> 0604  CB 43
        res  0,e                        ;=> 0606  CB 83
        set  0,e                        ;=> 0608  CB C3
        bit  1,e                        ;=> 060A  CB 4B
        res  1,e                        ;=> 060C  CB 8B
        set  1,e                        ;=> 060E  CB CB
        bit  2,e                        ;=> 0610  CB 53
        res  2,e                        ;=> 0612  CB 93
        set  2,e                        ;=> 0614  CB D3
        bit  3,e                        ;=> 0616  CB 5B
        res  3,e                        ;=> 0618  CB 9B
        set  3,e                        ;=> 061A  CB DB
        bit  4,e                        ;=> 061C  CB 63
        res  4,e                        ;=> 061E  CB A3
        set  4,e                        ;=> 0620  CB E3
        bit  5,e                        ;=> 0622  CB 6B
        res  5,e                        ;=> 0624  CB AB
        set  5,e                        ;=> 0626  CB EB
        bit  6,e                        ;=> 0628  CB 73
        res  6,e                        ;=> 062A  CB B3
        set  6,e                        ;=> 062C  CB F3
        bit  7,e                        ;=> 062E  CB 7B
        res  7,e                        ;=> 0630  CB BB
        set  7,e                        ;=> 0632  CB FB
        bit  0,h                        ;=> 0634  CB 44
        res  0,h                        ;=> 0636  CB 84
        set  0,h                        ;=> 0638  CB C4
        bit  1,h                        ;=> 063A  CB 4C
        res  1,h                        ;=> 063C  CB 8C
        set  1,h                        ;=> 063E  CB CC
        bit  2,h                        ;=> 0640  CB 54
        res  2,h                        ;=> 0642  CB 94
        set  2,h                        ;=> 0644  CB D4
        bit  3,h                        ;=> 0646  CB 5C
        res  3,h                        ;=> 0648  CB 9C
        set  3,h                        ;=> 064A  CB DC
        bit  4,h                        ;=> 064C  CB 64
        res  4,h                        ;=> 064E  CB A4
        set  4,h                        ;=> 0650  CB E4
        bit  5,h                        ;=> 0652  CB 6C
        res  5,h                        ;=> 0654  CB AC
        set  5,h                        ;=> 0656  CB EC
        bit  6,h                        ;=> 0658  CB 74
        res  6,h                        ;=> 065A  CB B4
        set  6,h                        ;=> 065C  CB F4
        bit  7,h                        ;=> 065E  CB 7C
        res  7,h                        ;=> 0660  CB BC
        set  7,h                        ;=> 0662  CB FC
        bit  0,l                        ;=> 0664  CB 45
        res  0,l                        ;=> 0666  CB 85
        set  0,l                        ;=> 0668  CB C5
        bit  1,l                        ;=> 066A  CB 4D
        res  1,l                        ;=> 066C  CB 8D
        set  1,l                        ;=> 066E  CB CD
        bit  2,l                        ;=> 0670  CB 55
        res  2,l                        ;=> 0672  CB 95
        set  2,l                        ;=> 0674  CB D5
        bit  3,l                        ;=> 0676  CB 5D
        res  3,l                        ;=> 0678  CB 9D
        set  3,l                        ;=> 067A  CB DD
        bit  4,l                        ;=> 067C  CB 65
        res  4,l                        ;=> 067E  CB A5
        set  4,l                        ;=> 0680  CB E5
        bit  5,l                        ;=> 0682  CB 6D
        res  5,l                        ;=> 0684  CB AD
        set  5,l                        ;=> 0686  CB ED
        bit  6,l                        ;=> 0688  CB 75
        res  6,l                        ;=> 068A  CB B5
        set  6,l                        ;=> 068C  CB F5
        bit  7,l                        ;=> 068E  CB 7D
        res  7,l                        ;=> 0690  CB BD
        set  7,l                        ;=> 0692  CB FD
        bit  0,a                        ;=> 0694  CB 47
        res  0,a                        ;=> 0696  CB 87
        set  0,a                        ;=> 0698  CB C7
        bit  1,a                        ;=> 069A  CB 4F
        res  1,a                        ;=> 069C  CB 8F
        set  1,a                        ;=> 069E  CB CF
        bit  2,a                        ;=> 06A0  CB 57
        res  2,a                        ;=> 06A2  CB 97
        set  2,a                        ;=> 06A4  CB D7
        bit  3,a                        ;=> 06A6  CB 5F
        res  3,a                        ;=> 06A8  CB 9F
        set  3,a                        ;=> 06AA  CB DF
        bit  4,a                        ;=> 06AC  CB 67
        res  4,a                        ;=> 06AE  CB A7
        set  4,a                        ;=> 06B0  CB E7
        bit  5,a                        ;=> 06B2  CB 6F
        res  5,a                        ;=> 06B4  CB AF
        set  5,a                        ;=> 06B6  CB EF
        bit  6,a                        ;=> 06B8  CB 77
        res  6,a                        ;=> 06BA  CB B7
        set  6,a                        ;=> 06BC  CB F7
        bit  7,a                        ;=> 06BE  CB 7F
        res  7,a                        ;=> 06C0  CB BF
        set  7,a                        ;=> 06C2  CB FF
        bit  0,(hl)                     ;=> 06C4  CB 46
        res  0,(hl)                     ;=> 06C6  CB 86
        set  0,(hl)                     ;=> 06C8  CB C6
        bit  1,(hl)                     ;=> 06CA  CB 4E
        res  1,(hl)                     ;=> 06CC  CB 8E
        set  1,(hl)                     ;=> 06CE  CB CE
        bit  2,(hl)                     ;=> 06D0  CB 56
        res  2,(hl)                     ;=> 06D2  CB 96
        set  2,(hl)                     ;=> 06D4  CB D6
        bit  3,(hl)                     ;=> 06D6  CB 5E
        res  3,(hl)                     ;=> 06D8  CB 9E
        set  3,(hl)                     ;=> 06DA  CB DE
        bit  4,(hl)                     ;=> 06DC  CB 66
        res  4,(hl)                     ;=> 06DE  CB A6
        set  4,(hl)                     ;=> 06E0  CB E6
        bit  5,(hl)                     ;=> 06E2  CB 6E
        res  5,(hl)                     ;=> 06E4  CB AE
        set  5,(hl)                     ;=> 06E6  CB EE
        bit  6,(hl)                     ;=> 06E8  CB 76
        res  6,(hl)                     ;=> 06EA  CB B6
        set  6,(hl)                     ;=> 06EC  CB F6
        bit  7,(hl)                     ;=> 06EE  CB 7E
        res  7,(hl)                     ;=> 06F0  CB BE
        set  7,(hl)                     ;=> 06F2  CB FE
        bit  0,(ix+DIS)                 ;=> 06F4  DD CB 40 46
        res  0,(ix+DIS)                 ;=> 06F8  DD CB 40 86
        set  0,(ix+DIS)                 ;=> 06FC  DD CB 40 C6
        bit  1,(ix+DIS)                 ;=> 0700  DD CB 40 4E
        res  1,(ix+DIS)                 ;=> 0704  DD CB 40 8E
        set  1,(ix+DIS)                 ;=> 0708  DD CB 40 CE
        bit  2,(ix+DIS)                 ;=> 070C  DD CB 40 56
        res  2,(ix+DIS)                 ;=> 0710  DD CB 40 96
        set  2,(ix+DIS)                 ;=> 0714  DD CB 40 D6
        bit  3,(ix+DIS)                 ;=> 0718  DD CB 40 5E
        res  3,(ix+DIS)                 ;=> 071C  DD CB 40 9E
        set  3,(ix+DIS)                 ;=> 0720  DD CB 40 DE
        bit  4,(ix+DIS)                 ;=> 0724  DD CB 40 66
        res  4,(ix+DIS)                 ;=> 0728  DD CB 40 A6
        set  4,(ix+DIS)                 ;=> 072C  DD CB 40 E6
        bit  5,(ix+DIS)                 ;=> 0730  DD CB 40 6E
        res  5,(ix+DIS)                 ;=> 0734  DD CB 40 AE
        set  5,(ix+DIS)                 ;=> 0738  DD CB 40 EE
        bit  6,(ix+DIS)                 ;=> 073C  DD CB 40 76
        res  6,(ix+DIS)                 ;=> 0740  DD CB 40 B6
        set  6,(ix+DIS)                 ;=> 0744  DD CB 40 F6
        bit  7,(ix+DIS)                 ;=> 0748  DD CB 40 7E
        res  7,(ix+DIS)                 ;=> 074C  DD CB 40 BE
        set  7,(ix+DIS)                 ;=> 0750  DD CB 40 FE
        bit  0,(iy+DIS)                 ;=> 0754  FD CB 40 46
        res  0,(iy+DIS)                 ;=> 0758  FD CB 40 86
        set  0,(iy+DIS)                 ;=> 075C  FD CB 40 C6
        bit  1,(iy+DIS)                 ;=> 0760  FD CB 40 4E
        res  1,(iy+DIS)                 ;=> 0764  FD CB 40 8E
        set  1,(iy+DIS)                 ;=> 0768  FD CB 40 CE
        bit  2,(iy+DIS)                 ;=> 076C  FD CB 40 56
        res  2,(iy+DIS)                 ;=> 0770  FD CB 40 96
        set  2,(iy+DIS)                 ;=> 0774  FD CB 40 D6
        bit  3,(iy+DIS)                 ;=> 0778  FD CB 40 5E
        res  3,(iy+DIS)                 ;=> 077C  FD CB 40 9E
        set  3,(iy+DIS)                 ;=> 0780  FD CB 40 DE
        bit  4,(iy+DIS)                 ;=> 0784  FD CB 40 66
        res  4,(iy+DIS)                 ;=> 0788  FD CB 40 A6
        set  4,(iy+DIS)                 ;=> 078C  FD CB 40 E6
        bit  5,(iy+DIS)                 ;=> 0790  FD CB 40 6E
        res  5,(iy+DIS)                 ;=> 0794  FD CB 40 AE
        set  5,(iy+DIS)                 ;=> 0798  FD CB 40 EE
        bit  6,(iy+DIS)                 ;=> 079C  FD CB 40 76
        res  6,(iy+DIS)                 ;=> 07A0  FD CB 40 B6
        set  6,(iy+DIS)                 ;=> 07A4  FD CB 40 F6
        bit  7,(iy+DIS)                 ;=> 07A8  FD CB 40 7E
        res  7,(iy+DIS)                 ;=> 07AC  FD CB 40 BE
        set  7,(iy+DIS)                 ;=> 07B0  FD CB 40 FE
;	res     0,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),b	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),c	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),d	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),e	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),h	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),l	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     0,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     1,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     1,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     2,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     2,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     3,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     3,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     4,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     4,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     5,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     5,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     6,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     6,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     7,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	set     7,(ix+DIS),a	=} 0xDD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),b	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),c	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),d	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),e	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),h	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),l	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     0,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     0,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     1,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     1,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     2,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     2,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     3,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     3,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     4,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     4,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     5,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     5,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     6,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     6,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	res     7,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3
;	set     7,(iy+DIS),a	=} 0xFD 0xCB DIS <0:6+<1:3+<3

;------------------------------------------------------------------------------
; Jump Group
;------------------------------------------------------------------------------
        jp   NN                         ;=> 07B4  C3 30 00
        jp   (hl)                       ;=> 07B7  E9
        jp   (ix)                       ;=> 07B8  DD E9
        jp   (iy)                       ;=> 07BA  FD E9
        jp   nz,NN                      ;=> 07BC  C2 30 00
        jp   z,NN                       ;=> 07BF  CA 30 00
        jp   nc,NN                      ;=> 07C2  D2 30 00
        jp   c,NN                       ;=> 07C5  DA 30 00
        jp   po,NN                      ;=> 07C8  E2 30 00
        jp   pe,NN                      ;=> 07CB  EA 30 00
        jp   p,NN                       ;=> 07CE  F2 30 00
        jp   m,NN                       ;=> 07D1  FA 30 00

										; max forward jump
        jr   jr2                        ;=> 07D4  18 7F
        jr   jr2                        ;=> 07D6  18 7D
        jr   jr2                        ;=> 07D8  18 7B
        
        djnz ASMPC                      ;=> 07DA  10 FE
        djnz ASMPC+0x81                 ;=> 07DC  10 7F
        jr   ASMPC                      ;=> 07DE  18 FE
        jr   ASMPC-0x7E                 ;=> 07E0  18 80
        
        djnz jr1                        ;=> 07E2  10 00
jr1:
        jr   jr1                        ;=> 07E4  18 FE
        djnz jr1                        ;=> 07E6  10 FC
        jr   nz,jr1                     ;=> 07E8  20 FA
        jr   z,jr1                      ;=> 07EA  28 F8
        jr   nc,jr1                     ;=> 07EC  30 F6
        jr   c,jr1                      ;=> 07EE  38 F4
        
        defs 127-26, 0FFh 
jr2:
        defs 122, 0FFh 
        jr   jr2                        ;=> 08CF  18 84
        jr   jr2                        ;=> 08D1  18 82
										; max backward jump - z80pack does not accept -128
        jr   jr2                        ;=> 08D3  18 80
        

;	jr po,NN
;	jr pe,NN
;	jr p,NN
;	jr m,NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

        call NN                         ;=> 08D5  CD 30 00
        ret                             ;=> 08D8  C9
        ret  nz                         ;=> 08D9  C0
        ret  z                          ;=> 08DA  C8
        ret  nc                         ;=> 08DB  D0
        ret  c                          ;=> 08DC  D8
        ret  po                         ;=> 08DD  E0
        ret  pe                         ;=> 08DE  E8
        ret  p                          ;=> 08DF  F0
        ret  m                          ;=> 08E0  F8
        reti                            ;=> 08E1  ED 4D
;	rst 0
;	rst 1
;	rst 2
;	rst 3
;	rst 4
;	rst 5
;	rst 6
;	rst 7


        call nz,NN                      ;=> 08E3  C4 30 00
        call z,NN                       ;=> 08E6  CC 30 00
        call nc,NN                      ;=> 08E9  D4 30 00
        call c,NN                       ;=> 08EC  DC 30 00
        call po,NN                      ;=> 08EF  E4 30 00
        call pe,NN                      ;=> 08F2  EC 30 00
        call p,NN                       ;=> 08F5  F4 30 00
        call m,NN                       ;=> 08F8  FC 30 00
        retn                            ;=> 08FB  ED 45
        rst  00h                        ;=> 08FD  C7
        rst  08h                        ;=> 08FE  CF
        rst  10h                        ;=> 08FF  D7
        rst  18h                        ;=> 0900  DF
        rst  20h                        ;=> 0901  E7
        rst  28h                        ;=> 0902  EF
        rst  30h                        ;=> 0903  F7
        rst  38h                        ;=> 0904  FF


;------------------------------------------------------------------------------
; Input and Output Group
;------------------------------------------------------------------------------

        in   a,(N)                      ;=> 0905  DB 20
        in   b,(c)                      ;=> 0907  ED 40
        in   c,(c)                      ;=> 0909  ED 48
        in   d,(c)                      ;=> 090B  ED 50
        in   e,(c)                      ;=> 090D  ED 58
        in   h,(c)                      ;=> 090F  ED 60
        in   l,(c)                      ;=> 0911  ED 68
        in   a,(c)                      ;=> 0913  ED 78
;	in f,(c)

        ini                             ;=> 0915  ED A2
        inir                            ;=> 0917  ED B2
        ind                             ;=> 0919  ED AA
        indr                            ;=> 091B  ED BA

        out  (N),a                      ;=> 091D  D3 20
        out  (c),b                      ;=> 091F  ED 41
        out  (c),c                      ;=> 0921  ED 49
        out  (c),d                      ;=> 0923  ED 51
        out  (c),e                      ;=> 0925  ED 59
        out  (c),h                      ;=> 0927  ED 61
        out  (c),l                      ;=> 0929  ED 69
        out  (c),a                      ;=> 092B  ED 79
;	out (c),0

        outi                            ;=> 092D  ED A3
        otir                            ;=> 092F  ED B3
        outd                            ;=> 0931  ED AB
        otdr                            ;=> 0933  ED BB

;------------------------------------------------------------------------------
; 
; Revision 1.4  2014/04/28 22:07:03  pauloscustodio
; Extend tests
;
; Revision 1.3  2014/04/26 08:34:18  pauloscustodio
; No RCS keywords in generated files
;
; Revision 1.2  2014/04/26 08:14:01  pauloscustodio
; ws
;
; Revision 1.1  2014/04/25 23:52:17  pauloscustodio
; Rename input file for z80opcodes generation
;
;
