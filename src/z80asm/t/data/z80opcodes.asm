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

; BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
bug0047a:
        defw ASMPC,ASMPC,ASMPC          ;=> 0136  36 01 36 01 36 01
bug0047b: 
        jp   ASMPC                      ;=> 013C  C3 3C 01

;------------------------------------------------------------------------------
; IF ELSE ENDIF
;------------------------------------------------------------------------------
        if   1 
        defb 1                          ;=> 013F  01
        if   1 
        defb 2                          ;=> 0140  02
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
        defb 8                          ;=> 0141  08
        endif 
        
        if   0 
        defb 9 
        else 
        defb 10                         ;=> 0142  0A
        endif 
        
        if   undefined 
        defb 11 
        else 
        defb 12                         ;=> 0143  0C
        endif 

        if   undefined | 1 
        defb 13                         ;=> 0144  0D
        else 
        defb 14 
        endif 

;------------------------------------------------------------------------------
; Z88DK specific opcodes
;------------------------------------------------------------------------------
        call_oz 1                       ;=> 0145  E7 01
        call_oz 255                     ;=> 0147  E7 FF
        call_oz 256                     ;=> 0149  E7 00 01
        call_oz 65535                   ;=> 014C  E7 FF FF

        call_pkg 0                      ;=> 014F  CF 00 00
        call_pkg 1                      ;=> 0152  CF 01 00
        call_pkg 65535                  ;=> 0155  CF FF FF
        
        fpp  1                          ;=> 0158  DF 01
        fpp  254                        ;=> 015A  DF FE

        invoke 0                        ;=> 015C  CD 00 00
        invoke 1                        ;=> 015F  CD 01 00
        invoke 65535                    ;=> 0162  CD FF FF
        
;------------------------------------------------------------------------------
; 8 bit load group
;------------------------------------------------------------------------------

        ld   b,b                        ;=> 0165  40
        ld   c,b                        ;=> 0166  48
        ld   d,b                        ;=> 0167  50
        ld   e,b                        ;=> 0168  58
        ld   h,b                        ;=> 0169  60
        ld   l,b                        ;=> 016A  68
        ld   a,b                        ;=> 016B  78
        ld   b,c                        ;=> 016C  41
        ld   c,c                        ;=> 016D  49
        ld   d,c                        ;=> 016E  51
        ld   e,c                        ;=> 016F  59
        ld   h,c                        ;=> 0170  61
        ld   l,c                        ;=> 0171  69
        ld   a,c                        ;=> 0172  79
        ld   b,d                        ;=> 0173  42
        ld   c,d                        ;=> 0174  4A
        ld   d,d                        ;=> 0175  52
        ld   e,d                        ;=> 0176  5A
        ld   h,d                        ;=> 0177  62
        ld   l,d                        ;=> 0178  6A
        ld   a,d                        ;=> 0179  7A
        ld   b,e                        ;=> 017A  43
        ld   c,e                        ;=> 017B  4B
        ld   d,e                        ;=> 017C  53
        ld   e,e                        ;=> 017D  5B
        ld   h,e                        ;=> 017E  63
        ld   l,e                        ;=> 017F  6B
        ld   a,e                        ;=> 0180  7B
        ld   b,h                        ;=> 0181  44
        ld   c,h                        ;=> 0182  4C
        ld   d,h                        ;=> 0183  54
        ld   e,h                        ;=> 0184  5C
        ld   h,h                        ;=> 0185  64
        ld   l,h                        ;=> 0186  6C
        ld   a,h                        ;=> 0187  7C
        ld   b,l                        ;=> 0188  45
        ld   c,l                        ;=> 0189  4D
        ld   d,l                        ;=> 018A  55
        ld   e,l                        ;=> 018B  5D
        ld   h,l                        ;=> 018C  65
        ld   l,l                        ;=> 018D  6D
        ld   a,l                        ;=> 018E  7D
        ld   b,a                        ;=> 018F  47
        ld   c,a                        ;=> 0190  4F
        ld   d,a                        ;=> 0191  57
        ld   e,a                        ;=> 0192  5F
        ld   h,a                        ;=> 0193  67
        ld   l,a                        ;=> 0194  6F
        ld   a,a                        ;=> 0195  7F
        ld   b,N                        ;=> 0196  06 20
        ld   c,N                        ;=> 0198  0E 20
        ld   d,N                        ;=> 019A  16 20
        ld   e,N                        ;=> 019C  1E 20
        ld   h,N                        ;=> 019E  26 20
        ld   l,N                        ;=> 01A0  2E 20
        ld   a,N                        ;=> 01A2  3E 20

        ld   b,ixh                      ;=> 01A4  DD 44
        ld   c,ixh                      ;=> 01A6  DD 4C
        ld   d,ixh                      ;=> 01A8  DD 54
        ld   e,ixh                      ;=> 01AA  DD 5C
        ld   ixh,ixh                    ;=> 01AC  DD 64
        ld   ixl,ixh                    ;=> 01AE  DD 6C
        ld   a,ixh                      ;=> 01B0  DD 7C
        ld   b,ixl                      ;=> 01B2  DD 45
        ld   c,ixl                      ;=> 01B4  DD 4D
        ld   d,ixl                      ;=> 01B6  DD 55
        ld   e,ixl                      ;=> 01B8  DD 5D
        ld   ixh,ixl                    ;=> 01BA  DD 65
        ld   ixl,ixl                    ;=> 01BC  DD 6D
        ld   a,ixl                      ;=> 01BE  DD 7D
        ld   ixh,b                      ;=> 01C0  DD 60
        ld   ixl,b                      ;=> 01C2  DD 68
        ld   ixh,c                      ;=> 01C4  DD 61
        ld   ixl,c                      ;=> 01C6  DD 69
        ld   ixh,d                      ;=> 01C8  DD 62
        ld   ixl,d                      ;=> 01CA  DD 6A
        ld   ixh,e                      ;=> 01CC  DD 63
        ld   ixl,e                      ;=> 01CE  DD 6B
        ld   ixh,ixh                    ;=> 01D0  DD 64
        ld   ixl,ixh                    ;=> 01D2  DD 6C
        ld   ixh,ixl                    ;=> 01D4  DD 65
        ld   ixl,ixl                    ;=> 01D6  DD 6D
        ld   ixh,a                      ;=> 01D8  DD 67
        ld   ixl,a                      ;=> 01DA  DD 6F
        ld   ixh,N                      ;=> 01DC  DD 26 20
        ld   ixl,N                      ;=> 01DF  DD 2E 20
        
        ld   b,iyh                      ;=> 01E2  FD 44
        ld   c,iyh                      ;=> 01E4  FD 4C
        ld   d,iyh                      ;=> 01E6  FD 54
        ld   e,iyh                      ;=> 01E8  FD 5C
        ld   iyh,iyh                    ;=> 01EA  FD 64
        ld   iyl,iyh                    ;=> 01EC  FD 6C
        ld   a,iyh                      ;=> 01EE  FD 7C
        ld   b,iyl                      ;=> 01F0  FD 45
        ld   c,iyl                      ;=> 01F2  FD 4D
        ld   d,iyl                      ;=> 01F4  FD 55
        ld   e,iyl                      ;=> 01F6  FD 5D
        ld   iyh,iyl                    ;=> 01F8  FD 65
        ld   iyl,iyl                    ;=> 01FA  FD 6D
        ld   a,iyl                      ;=> 01FC  FD 7D
        ld   iyh,b                      ;=> 01FE  FD 60
        ld   iyl,b                      ;=> 0200  FD 68
        ld   iyh,c                      ;=> 0202  FD 61
        ld   iyl,c                      ;=> 0204  FD 69
        ld   iyh,d                      ;=> 0206  FD 62
        ld   iyl,d                      ;=> 0208  FD 6A
        ld   iyh,e                      ;=> 020A  FD 63
        ld   iyl,e                      ;=> 020C  FD 6B
        ld   iyh,iyh                    ;=> 020E  FD 64
        ld   iyl,iyh                    ;=> 0210  FD 6C
        ld   iyh,iyl                    ;=> 0212  FD 65
        ld   iyl,iyl                    ;=> 0214  FD 6D
        ld   iyh,a                      ;=> 0216  FD 67
        ld   iyl,a                      ;=> 0218  FD 6F
        ld   iyh,N                      ;=> 021A  FD 26 20
        ld   iyl,N                      ;=> 021D  FD 2E 20

        ld   b,(hl)                     ;=> 0220  46
        ld   c,(hl)                     ;=> 0221  4E
        ld   d,(hl)                     ;=> 0222  56
        ld   e,(hl)                     ;=> 0223  5E
        ld   h,(hl)                     ;=> 0224  66
        ld   l,(hl)                     ;=> 0225  6E
        ld   a,(hl)                     ;=> 0226  7E
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

        ld   b,(ix+DIS)                 ;=> 0227  DD 46 40
        ld   c,(ix+DIS)                 ;=> 022A  DD 4E 40
        ld   d,(ix+DIS)                 ;=> 022D  DD 56 40
        ld   e,(ix+DIS)                 ;=> 0230  DD 5E 40
        ld   h,(ix+DIS)                 ;=> 0233  DD 66 40
        ld   l,(ix+DIS)                 ;=> 0236  DD 6E 40
        ld   a,(ix+DIS)                 ;=> 0239  DD 7E 40
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

        ld   b,(iy+DIS)                 ;=> 023C  FD 46 40
        ld   c,(iy+DIS)                 ;=> 023F  FD 4E 40
        ld   d,(iy+DIS)                 ;=> 0242  FD 56 40
        ld   e,(iy+DIS)                 ;=> 0245  FD 5E 40
        ld   h,(iy+DIS)                 ;=> 0248  FD 66 40
        ld   l,(iy+DIS)                 ;=> 024B  FD 6E 40
        ld   a,(iy+DIS)                 ;=> 024E  FD 7E 40
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

        ld   (hl),b                     ;=> 0251  70
        ld   (hl),c                     ;=> 0252  71
        ld   (hl),d                     ;=> 0253  72
        ld   (hl),e                     ;=> 0254  73
        ld   (hl),h                     ;=> 0255  74
        ld   (hl),l                     ;=> 0256  75
        ld   (hl),a                     ;=> 0257  77
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

        ld   (ix+DIS),b                 ;=> 0258  DD 70 40
        ld   (ix+DIS),c                 ;=> 025B  DD 71 40
        ld   (ix+DIS),d                 ;=> 025E  DD 72 40
        ld   (ix+DIS),e                 ;=> 0261  DD 73 40
        ld   (ix+DIS),h                 ;=> 0264  DD 74 40
        ld   (ix+DIS),l                 ;=> 0267  DD 75 40
        ld   (ix+DIS),a                 ;=> 026A  DD 77 40
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

        ld   (iy+DIS),b                 ;=> 026D  FD 70 40
        ld   (iy+DIS),c                 ;=> 0270  FD 71 40
        ld   (iy+DIS),d                 ;=> 0273  FD 72 40
        ld   (iy+DIS),e                 ;=> 0276  FD 73 40
        ld   (iy+DIS),h                 ;=> 0279  FD 74 40
        ld   (iy+DIS),l                 ;=> 027C  FD 75 40
        ld   (iy+DIS),a                 ;=> 027F  FD 77 40
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

        ld   (hl),N                     ;=> 0282  36 20
;	ldi	(hl),N							;;	ld	(hl),N ;; inc hl
;	ldd	(hl),N							;;	ld	(hl),N ;; dec hl

        ld   (ix+DIS),N                 ;=> 0284  DD 36 40 20
;	ldi	(ix+DIS),N						;;	ld	(ix+DIS),N ;; inc ix
;	ldd	(ix+DIS),N						;;	ld	(ix+DIS),N ;; dec ix

        ld   (iy+DIS),N                 ;=> 0288  FD 36 40 20
;	ldi	(iy+DIS),N						;;	ld	(iy+DIS),N ;; inc iy
;	ldd	(iy+DIS),N						;;	ld	(iy+DIS),N ;; dec iy

        ld   a,(bc)                     ;=> 028C  0A
        ld   a,(de)                     ;=> 028D  1A
;	ldi	a,(bc)						;;	ld	a,(bc) ;; inc bc
;	ldi	a,(de)						;;	ld	a,(de) ;; inc de
;	ldd	a,(bc)						;;	ld	a,(bc) ;; dec bc
;	ldd	a,(de)						;;	ld	a,(de) ;; dec de

        ld   (bc),a                     ;=> 028E  02
        ld   (de),a                     ;=> 028F  12
;	ldi	(bc),a						;;	ld	(bc),a ;; inc bc
;	ldi	(de),a						;;	ld	(de),a ;; inc de
;	ldd	(bc),a						;;	ld	(bc),a ;; dec bc
;	ldd	(de),a						;;	ld	(de),a ;; dec de

        ld   a,(NN)                     ;=> 0290  3A 30 00
        ld   (NN),a                     ;=> 0293  32 30 00

        ld   a,i                        ;=> 0296  ED 57
        ld   a,r                        ;=> 0298  ED 5F
        ld   i,a                        ;=> 029A  ED 47
        ld   r,a                        ;=> 029C  ED 4F

;------------------------------------------------------------------------------
; 16 bit load group
;------------------------------------------------------------------------------

        ld   bc,NN                      ;=> 029E  01 30 00
        ld   de,NN                      ;=> 02A1  11 30 00
        ld   hl,NN                      ;=> 02A4  21 30 00
        ld   ix,NN                      ;=> 02A7  DD 21 30 00
        ld   iy,NN                      ;=> 02AB  FD 21 30 00
        ld   sp,NN                      ;=> 02AF  31 30 00
        ld   bc,(NN)                    ;=> 02B2  ED 4B 30 00
        ld   de,(NN)                    ;=> 02B6  ED 5B 30 00
        ld   hl,(NN)                    ;=> 02BA  2A 30 00
        ld   ix,(NN)                    ;=> 02BD  DD 2A 30 00
        ld   iy,(NN)                    ;=> 02C1  FD 2A 30 00
        ld   sp,(NN)                    ;=> 02C5  ED 7B 30 00
        ld   (NN),bc                    ;=> 02C9  ED 43 30 00
        ld   (NN),de                    ;=> 02CD  ED 53 30 00
        ld   (NN),hl                    ;=> 02D1  22 30 00
        ld   (NN),ix                    ;=> 02D4  DD 22 30 00
        ld   (NN),iy                    ;=> 02D8  FD 22 30 00
        ld   (NN),sp                    ;=> 02DC  ED 73 30 00
        ld   sp,hl                      ;=> 02E0  F9
        ld   sp,ix                      ;=> 02E1  DD F9
        ld   sp,iy                      ;=> 02E3  FD F9
        push bc                         ;=> 02E5  C5
        push de                         ;=> 02E6  D5
        push hl                         ;=> 02E7  E5
        push ix                         ;=> 02E8  DD E5
        push iy                         ;=> 02EA  FD E5
        push af                         ;=> 02EC  F5
        pop  bc                         ;=> 02ED  C1
        pop  de                         ;=> 02EE  D1
        pop  hl                         ;=> 02EF  E1
        pop  ix                         ;=> 02F0  DD E1
        pop  iy                         ;=> 02F2  FD E1
        pop  af                         ;=> 02F4  F1

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

        ex   de,hl                      ;=> 02F5  EB
        ex   af,af                      ;=> 02F6  08
        ex   af,af'                     ;=> 02F7  08
        exx                             ;=> 02F8  D9
        
        ex   (sp),hl                    ;=> 02F9  E3
        ex   (sp),ix                    ;=> 02FA  DD E3
        ex   (sp),iy                    ;=> 02FC  FD E3

        ldi                             ;=> 02FE  ED A0
        ldir                            ;=> 0300  ED B0
        ldd                             ;=> 0302  ED A8
        lddr                            ;=> 0304  ED B8

        cpi                             ;=> 0306  ED A1
        cpir                            ;=> 0308  ED B1
        cpd                             ;=> 030A  ED A9
        cpdr                            ;=> 030C  ED B9

;------------------------------------------------------------------------------
; 8 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  a,b                        ;=> 030E  80
        adc  a,b                        ;=> 030F  88
        sbc  a,b                        ;=> 0310  98
        add  a,c                        ;=> 0311  81
        adc  a,c                        ;=> 0312  89
        sbc  a,c                        ;=> 0313  99
        add  a,d                        ;=> 0314  82
        adc  a,d                        ;=> 0315  8A
        sbc  a,d                        ;=> 0316  9A
        add  a,e                        ;=> 0317  83
        adc  a,e                        ;=> 0318  8B
        sbc  a,e                        ;=> 0319  9B
        add  a,h                        ;=> 031A  84
        adc  a,h                        ;=> 031B  8C
        sbc  a,h                        ;=> 031C  9C
        add  a,l                        ;=> 031D  85
        adc  a,l                        ;=> 031E  8D
        sbc  a,l                        ;=> 031F  9D
        add  a,a                        ;=> 0320  87
        adc  a,a                        ;=> 0321  8F
        sbc  a,a                        ;=> 0322  9F
        add  a,(hl)                     ;=> 0323  86
        adc  a,(hl)                     ;=> 0324  8E
        sbc  a,(hl)                     ;=> 0325  9E
        add  a,(ix+DIS)                 ;=> 0326  DD 86 40
        adc  a,(ix+DIS)                 ;=> 0329  DD 8E 40
        sbc  a,(ix+DIS)                 ;=> 032C  DD 9E 40
        add  a,(iy+DIS)                 ;=> 032F  FD 86 40
        adc  a,(iy+DIS)                 ;=> 0332  FD 8E 40
        sbc  a,(iy+DIS)                 ;=> 0335  FD 9E 40
        add  a,N                        ;=> 0338  C6 20
        adc  a,N                        ;=> 033A  CE 20
        sbc  a,N                        ;=> 033C  DE 20
        add  b                          ;=> 033E  80
        adc  b                          ;=> 033F  88
        sbc  b                          ;=> 0340  98
        add  c                          ;=> 0341  81
        adc  c                          ;=> 0342  89
        sbc  c                          ;=> 0343  99
        add  d                          ;=> 0344  82
        adc  d                          ;=> 0345  8A
        sbc  d                          ;=> 0346  9A
        add  e                          ;=> 0347  83
        adc  e                          ;=> 0348  8B
        sbc  e                          ;=> 0349  9B
        add  h                          ;=> 034A  84
        adc  h                          ;=> 034B  8C
        sbc  h                          ;=> 034C  9C
        add  l                          ;=> 034D  85
        adc  l                          ;=> 034E  8D
        sbc  l                          ;=> 034F  9D
        add  a                          ;=> 0350  87
        adc  a                          ;=> 0351  8F
        sbc  a                          ;=> 0352  9F
        add  (hl)                       ;=> 0353  86
        adc  (hl)                       ;=> 0354  8E
        sbc  (hl)                       ;=> 0355  9E
        add  (ix+DIS)                   ;=> 0356  DD 86 40
        adc  (ix+DIS)                   ;=> 0359  DD 8E 40
        sbc  (ix+DIS)                   ;=> 035C  DD 9E 40
        add  (iy+DIS)                   ;=> 035F  FD 86 40
        adc  (iy+DIS)                   ;=> 0362  FD 8E 40
        sbc  (iy+DIS)                   ;=> 0365  FD 9E 40
        add  N                          ;=> 0368  C6 20
        adc  N                          ;=> 036A  CE 20
        sbc  N                          ;=> 036C  DE 20
        
        sub  b                          ;=> 036E  90
        and  b                          ;=> 036F  A0
        xor  b                          ;=> 0370  A8
        or   b                          ;=> 0371  B0
        cp   b                          ;=> 0372  B8
        sub  c                          ;=> 0373  91
        and  c                          ;=> 0374  A1
        xor  c                          ;=> 0375  A9
        or   c                          ;=> 0376  B1
        cp   c                          ;=> 0377  B9
        sub  d                          ;=> 0378  92
        and  d                          ;=> 0379  A2
        xor  d                          ;=> 037A  AA
        or   d                          ;=> 037B  B2
        cp   d                          ;=> 037C  BA
        sub  e                          ;=> 037D  93
        and  e                          ;=> 037E  A3
        xor  e                          ;=> 037F  AB
        or   e                          ;=> 0380  B3
        cp   e                          ;=> 0381  BB
        sub  h                          ;=> 0382  94
        and  h                          ;=> 0383  A4
        xor  h                          ;=> 0384  AC
        or   h                          ;=> 0385  B4
        cp   h                          ;=> 0386  BC
        sub  l                          ;=> 0387  95
        and  l                          ;=> 0388  A5
        xor  l                          ;=> 0389  AD
        or   l                          ;=> 038A  B5
        cp   l                          ;=> 038B  BD
        sub  a                          ;=> 038C  97
        and  a                          ;=> 038D  A7
        xor  a                          ;=> 038E  AF
        or   a                          ;=> 038F  B7
        cp   a                          ;=> 0390  BF
        sub  (hl)                       ;=> 0391  96
        and  (hl)                       ;=> 0392  A6
        xor  (hl)                       ;=> 0393  AE
        or   (hl)                       ;=> 0394  B6
        cp   (hl)                       ;=> 0395  BE
        sub  (ix+DIS)                   ;=> 0396  DD 96 40
        and  (ix+DIS)                   ;=> 0399  DD A6 40
        xor  (ix+DIS)                   ;=> 039C  DD AE 40
        or   (ix+DIS)                   ;=> 039F  DD B6 40
        cp   (ix+DIS)                   ;=> 03A2  DD BE 40
        sub  (iy+DIS)                   ;=> 03A5  FD 96 40
        and  (iy+DIS)                   ;=> 03A8  FD A6 40
        xor  (iy+DIS)                   ;=> 03AB  FD AE 40
        or   (iy+DIS)                   ;=> 03AE  FD B6 40
        cp   (iy+DIS)                   ;=> 03B1  FD BE 40
        sub  N                          ;=> 03B4  D6 20
        and  N                          ;=> 03B6  E6 20
        xor  N                          ;=> 03B8  EE 20
        or   N                          ;=> 03BA  F6 20
        cp   N                          ;=> 03BC  FE 20
        sub  a,b                        ;=> 03BE  90
        and  a,b                        ;=> 03BF  A0
        xor  a,b                        ;=> 03C0  A8
        or   a,b                        ;=> 03C1  B0
        cp   a,b                        ;=> 03C2  B8
        sub  a,c                        ;=> 03C3  91
        and  a,c                        ;=> 03C4  A1
        xor  a,c                        ;=> 03C5  A9
        or   a,c                        ;=> 03C6  B1
        cp   a,c                        ;=> 03C7  B9
        sub  a,d                        ;=> 03C8  92
        and  a,d                        ;=> 03C9  A2
        xor  a,d                        ;=> 03CA  AA
        or   a,d                        ;=> 03CB  B2
        cp   a,d                        ;=> 03CC  BA
        sub  a,e                        ;=> 03CD  93
        and  a,e                        ;=> 03CE  A3
        xor  a,e                        ;=> 03CF  AB
        or   a,e                        ;=> 03D0  B3
        cp   a,e                        ;=> 03D1  BB
        sub  a,h                        ;=> 03D2  94
        and  a,h                        ;=> 03D3  A4
        xor  a,h                        ;=> 03D4  AC
        or   a,h                        ;=> 03D5  B4
        cp   a,h                        ;=> 03D6  BC
        sub  a,l                        ;=> 03D7  95
        and  a,l                        ;=> 03D8  A5
        xor  a,l                        ;=> 03D9  AD
        or   a,l                        ;=> 03DA  B5
        cp   a,l                        ;=> 03DB  BD
        sub  a,a                        ;=> 03DC  97
        and  a,a                        ;=> 03DD  A7
        xor  a,a                        ;=> 03DE  AF
        or   a,a                        ;=> 03DF  B7
        cp   a,a                        ;=> 03E0  BF
        sub  a,(hl)                     ;=> 03E1  96
        and  a,(hl)                     ;=> 03E2  A6
        xor  a,(hl)                     ;=> 03E3  AE
        or   a,(hl)                     ;=> 03E4  B6
        cp   a,(hl)                     ;=> 03E5  BE
        sub  a,(ix+DIS)                 ;=> 03E6  DD 96 40
        and  a,(ix+DIS)                 ;=> 03E9  DD A6 40
        xor  a,(ix+DIS)                 ;=> 03EC  DD AE 40
        or   a,(ix+DIS)                 ;=> 03EF  DD B6 40
        cp   a,(ix+DIS)                 ;=> 03F2  DD BE 40
        sub  a,(iy+DIS)                 ;=> 03F5  FD 96 40
        and  a,(iy+DIS)                 ;=> 03F8  FD A6 40
        xor  a,(iy+DIS)                 ;=> 03FB  FD AE 40
        or   a,(iy+DIS)                 ;=> 03FE  FD B6 40
        cp   a,(iy+DIS)                 ;=> 0401  FD BE 40
        sub  a,N                        ;=> 0404  D6 20
        and  a,N                        ;=> 0406  E6 20
        xor  a,N                        ;=> 0408  EE 20
        or   a,N                        ;=> 040A  F6 20
        cp   a,N                        ;=> 040C  FE 20
        
        inc  b                          ;=> 040E  04
        dec  b                          ;=> 040F  05
        inc  c                          ;=> 0410  0C
        dec  c                          ;=> 0411  0D
        inc  d                          ;=> 0412  14
        dec  d                          ;=> 0413  15
        inc  e                          ;=> 0414  1C
        dec  e                          ;=> 0415  1D
        inc  h                          ;=> 0416  24
        dec  h                          ;=> 0417  25
        inc  l                          ;=> 0418  2C
        dec  l                          ;=> 0419  2D
        inc  a                          ;=> 041A  3C
        dec  a                          ;=> 041B  3D
        inc  (hl)                       ;=> 041C  34
        dec  (hl)                       ;=> 041D  35
        inc  (ix+DIS)                   ;=> 041E  DD 34 40
        dec  (ix+DIS)                   ;=> 0421  DD 35 40
        inc  (iy+DIS)                   ;=> 0424  FD 34 40
        dec  (iy+DIS)                   ;=> 0427  FD 35 40
        
        add  a,ixh                      ;=> 042A  DD 84
        adc  a,ixh                      ;=> 042C  DD 8C
        sbc  a,ixh                      ;=> 042E  DD 9C
        add  a,ixl                      ;=> 0430  DD 85
        adc  a,ixl                      ;=> 0432  DD 8D
        sbc  a,ixl                      ;=> 0434  DD 9D
        add  a,iyh                      ;=> 0436  FD 84
        adc  a,iyh                      ;=> 0438  FD 8C
        sbc  a,iyh                      ;=> 043A  FD 9C
        add  a,iyl                      ;=> 043C  FD 85
        adc  a,iyl                      ;=> 043E  FD 8D
        sbc  a,iyl                      ;=> 0440  FD 9D
        sub  ixh                        ;=> 0442  DD 94
        and  ixh                        ;=> 0444  DD A4
        xor  ixh                        ;=> 0446  DD AC
        or   ixh                        ;=> 0448  DD B4
        cp   ixh                        ;=> 044A  DD BC
        inc  ixh                        ;=> 044C  DD 24
        dec  ixh                        ;=> 044E  DD 25
        sub  ixl                        ;=> 0450  DD 95
        and  ixl                        ;=> 0452  DD A5
        xor  ixl                        ;=> 0454  DD AD
        or   ixl                        ;=> 0456  DD B5
        cp   ixl                        ;=> 0458  DD BD
        inc  ixl                        ;=> 045A  DD 2C
        dec  ixl                        ;=> 045C  DD 2D
        sub  iyh                        ;=> 045E  FD 94
        and  iyh                        ;=> 0460  FD A4
        xor  iyh                        ;=> 0462  FD AC
        or   iyh                        ;=> 0464  FD B4
        cp   iyh                        ;=> 0466  FD BC
        inc  iyh                        ;=> 0468  FD 24
        dec  iyh                        ;=> 046A  FD 25
        sub  iyl                        ;=> 046C  FD 95
        and  iyl                        ;=> 046E  FD A5
        xor  iyl                        ;=> 0470  FD AD
        or   iyl                        ;=> 0472  FD B5
        cp   iyl                        ;=> 0474  FD BD
        inc  iyl                        ;=> 0476  FD 2C
        dec  iyl                        ;=> 0478  FD 2D

;------------------------------------------------------------------------------
; 16 bit arithmetic and logical group
;------------------------------------------------------------------------------

        add  hl,bc                      ;=> 047A  09
        add  hl,de                      ;=> 047B  19
        add  hl,hl                      ;=> 047C  29
        add  hl,sp                      ;=> 047D  39
        add  ix,bc                      ;=> 047E  DD 09
        add  ix,de                      ;=> 0480  DD 19
        add  ix,ix                      ;=> 0482  DD 29
        add  ix,sp                      ;=> 0484  DD 39
        add  iy,bc                      ;=> 0486  FD 09
        add  iy,de                      ;=> 0488  FD 19
        add  iy,iy                      ;=> 048A  FD 29
        add  iy,sp                      ;=> 048C  FD 39

        sbc  hl,bc                      ;=> 048E  ED 42
        adc  hl,bc                      ;=> 0490  ED 4A
        sbc  hl,de                      ;=> 0492  ED 52
        adc  hl,de                      ;=> 0494  ED 5A
        sbc  hl,hl                      ;=> 0496  ED 62
        adc  hl,hl                      ;=> 0498  ED 6A
        sbc  hl,sp                      ;=> 049A  ED 72
        adc  hl,sp                      ;=> 049C  ED 7A
;	sub       hl,bc						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,de						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,hl						=} 0xB7 0xED 0x42+<2:4>
;	sub       hl,sp						=} 0xB7 0xED 0x42+<2:4>

        inc  bc                         ;=> 049E  03
        dec  bc                         ;=> 049F  0B
        inc  de                         ;=> 04A0  13
        dec  de                         ;=> 04A1  1B
        inc  hl                         ;=> 04A2  23
        dec  hl                         ;=> 04A3  2B
        inc  ix                         ;=> 04A4  DD 23
        dec  ix                         ;=> 04A6  DD 2B
        inc  iy                         ;=> 04A8  FD 23
        dec  iy                         ;=> 04AA  FD 2B
        inc  sp                         ;=> 04AC  33
        dec  sp                         ;=> 04AD  3B

;------------------------------------------------------------------------------
; rotate and shift group
;------------------------------------------------------------------------------

        rlca                            ;=> 04AE  07
        rrca                            ;=> 04AF  0F
        rla                             ;=> 04B0  17
        rra                             ;=> 04B1  1F

        rlc  b                          ;=> 04B2  CB 00
        rrc  b                          ;=> 04B4  CB 08
        rl   b                          ;=> 04B6  CB 10
        rr   b                          ;=> 04B8  CB 18
        sla  b                          ;=> 04BA  CB 20
        sra  b                          ;=> 04BC  CB 28
        srl  b                          ;=> 04BE  CB 38
        rlc  c                          ;=> 04C0  CB 01
        rrc  c                          ;=> 04C2  CB 09
        rl   c                          ;=> 04C4  CB 11
        rr   c                          ;=> 04C6  CB 19
        sla  c                          ;=> 04C8  CB 21
        sra  c                          ;=> 04CA  CB 29
        srl  c                          ;=> 04CC  CB 39
        rlc  d                          ;=> 04CE  CB 02
        rrc  d                          ;=> 04D0  CB 0A
        rl   d                          ;=> 04D2  CB 12
        rr   d                          ;=> 04D4  CB 1A
        sla  d                          ;=> 04D6  CB 22
        sra  d                          ;=> 04D8  CB 2A
        srl  d                          ;=> 04DA  CB 3A
        rlc  e                          ;=> 04DC  CB 03
        rrc  e                          ;=> 04DE  CB 0B
        rl   e                          ;=> 04E0  CB 13
        rr   e                          ;=> 04E2  CB 1B
        sla  e                          ;=> 04E4  CB 23
        sra  e                          ;=> 04E6  CB 2B
        srl  e                          ;=> 04E8  CB 3B
        rlc  h                          ;=> 04EA  CB 04
        rrc  h                          ;=> 04EC  CB 0C
        rl   h                          ;=> 04EE  CB 14
        rr   h                          ;=> 04F0  CB 1C
        sla  h                          ;=> 04F2  CB 24
        sra  h                          ;=> 04F4  CB 2C
        srl  h                          ;=> 04F6  CB 3C
        rlc  l                          ;=> 04F8  CB 05
        rrc  l                          ;=> 04FA  CB 0D
        rl   l                          ;=> 04FC  CB 15
        rr   l                          ;=> 04FE  CB 1D
        sla  l                          ;=> 0500  CB 25
        sra  l                          ;=> 0502  CB 2D
        srl  l                          ;=> 0504  CB 3D
        rlc  a                          ;=> 0506  CB 07
        rrc  a                          ;=> 0508  CB 0F
        rl   a                          ;=> 050A  CB 17
        rr   a                          ;=> 050C  CB 1F
        sla  a                          ;=> 050E  CB 27
        sra  a                          ;=> 0510  CB 2F
        srl  a                          ;=> 0512  CB 3F
        rlc  (hl)                       ;=> 0514  CB 06
        rrc  (hl)                       ;=> 0516  CB 0E
        rl   (hl)                       ;=> 0518  CB 16
        rr   (hl)                       ;=> 051A  CB 1E
        sla  (hl)                       ;=> 051C  CB 26
        sra  (hl)                       ;=> 051E  CB 2E
        srl  (hl)                       ;=> 0520  CB 3E
        rlc  (ix+DIS)                   ;=> 0522  DD CB 40 06
        rrc  (ix+DIS)                   ;=> 0526  DD CB 40 0E
        rl   (ix+DIS)                   ;=> 052A  DD CB 40 16
        rr   (ix+DIS)                   ;=> 052E  DD CB 40 1E
        sla  (ix+DIS)                   ;=> 0532  DD CB 40 26
        sra  (ix+DIS)                   ;=> 0536  DD CB 40 2E
        srl  (ix+DIS)                   ;=> 053A  DD CB 40 3E
        rlc  (iy+DIS)                   ;=> 053E  FD CB 40 06
        rrc  (iy+DIS)                   ;=> 0542  FD CB 40 0E
        rl   (iy+DIS)                   ;=> 0546  FD CB 40 16
        rr   (iy+DIS)                   ;=> 054A  FD CB 40 1E
        sla  (iy+DIS)                   ;=> 054E  FD CB 40 26
        sra  (iy+DIS)                   ;=> 0552  FD CB 40 2E
        srl  (iy+DIS)                   ;=> 0556  FD CB 40 3E
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

        rld                             ;=> 055A  ED 6F
        rrd                             ;=> 055C  ED 67

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

        cpl                             ;=> 055E  2F
        neg                             ;=> 055F  ED 44
        ccf                             ;=> 0561  3F
        scf                             ;=> 0562  37
        nop                             ;=> 0563  00

        daa                             ;=> 0564  27
        di                              ;=> 0565  F3
        ei                              ;=> 0566  FB
        halt                            ;=> 0567  76
        im   0                          ;=> 0568  ED 46
        im   1                          ;=> 056A  ED 56
        im   2                          ;=> 056C  ED 5E

;------------------------------------------------------------------------------
; Bit Set, Reset and Test Group
;------------------------------------------------------------------------------

        bit  0,b                        ;=> 056E  CB 40
        res  0,b                        ;=> 0570  CB 80
        set  0,b                        ;=> 0572  CB C0
        bit  1,b                        ;=> 0574  CB 48
        res  1,b                        ;=> 0576  CB 88
        set  1,b                        ;=> 0578  CB C8
        bit  2,b                        ;=> 057A  CB 50
        res  2,b                        ;=> 057C  CB 90
        set  2,b                        ;=> 057E  CB D0
        bit  3,b                        ;=> 0580  CB 58
        res  3,b                        ;=> 0582  CB 98
        set  3,b                        ;=> 0584  CB D8
        bit  4,b                        ;=> 0586  CB 60
        res  4,b                        ;=> 0588  CB A0
        set  4,b                        ;=> 058A  CB E0
        bit  5,b                        ;=> 058C  CB 68
        res  5,b                        ;=> 058E  CB A8
        set  5,b                        ;=> 0590  CB E8
        bit  6,b                        ;=> 0592  CB 70
        res  6,b                        ;=> 0594  CB B0
        set  6,b                        ;=> 0596  CB F0
        bit  7,b                        ;=> 0598  CB 78
        res  7,b                        ;=> 059A  CB B8
        set  7,b                        ;=> 059C  CB F8
        bit  0,c                        ;=> 059E  CB 41
        res  0,c                        ;=> 05A0  CB 81
        set  0,c                        ;=> 05A2  CB C1
        bit  1,c                        ;=> 05A4  CB 49
        res  1,c                        ;=> 05A6  CB 89
        set  1,c                        ;=> 05A8  CB C9
        bit  2,c                        ;=> 05AA  CB 51
        res  2,c                        ;=> 05AC  CB 91
        set  2,c                        ;=> 05AE  CB D1
        bit  3,c                        ;=> 05B0  CB 59
        res  3,c                        ;=> 05B2  CB 99
        set  3,c                        ;=> 05B4  CB D9
        bit  4,c                        ;=> 05B6  CB 61
        res  4,c                        ;=> 05B8  CB A1
        set  4,c                        ;=> 05BA  CB E1
        bit  5,c                        ;=> 05BC  CB 69
        res  5,c                        ;=> 05BE  CB A9
        set  5,c                        ;=> 05C0  CB E9
        bit  6,c                        ;=> 05C2  CB 71
        res  6,c                        ;=> 05C4  CB B1
        set  6,c                        ;=> 05C6  CB F1
        bit  7,c                        ;=> 05C8  CB 79
        res  7,c                        ;=> 05CA  CB B9
        set  7,c                        ;=> 05CC  CB F9
        bit  0,d                        ;=> 05CE  CB 42
        res  0,d                        ;=> 05D0  CB 82
        set  0,d                        ;=> 05D2  CB C2
        bit  1,d                        ;=> 05D4  CB 4A
        res  1,d                        ;=> 05D6  CB 8A
        set  1,d                        ;=> 05D8  CB CA
        bit  2,d                        ;=> 05DA  CB 52
        res  2,d                        ;=> 05DC  CB 92
        set  2,d                        ;=> 05DE  CB D2
        bit  3,d                        ;=> 05E0  CB 5A
        res  3,d                        ;=> 05E2  CB 9A
        set  3,d                        ;=> 05E4  CB DA
        bit  4,d                        ;=> 05E6  CB 62
        res  4,d                        ;=> 05E8  CB A2
        set  4,d                        ;=> 05EA  CB E2
        bit  5,d                        ;=> 05EC  CB 6A
        res  5,d                        ;=> 05EE  CB AA
        set  5,d                        ;=> 05F0  CB EA
        bit  6,d                        ;=> 05F2  CB 72
        res  6,d                        ;=> 05F4  CB B2
        set  6,d                        ;=> 05F6  CB F2
        bit  7,d                        ;=> 05F8  CB 7A
        res  7,d                        ;=> 05FA  CB BA
        set  7,d                        ;=> 05FC  CB FA
        bit  0,e                        ;=> 05FE  CB 43
        res  0,e                        ;=> 0600  CB 83
        set  0,e                        ;=> 0602  CB C3
        bit  1,e                        ;=> 0604  CB 4B
        res  1,e                        ;=> 0606  CB 8B
        set  1,e                        ;=> 0608  CB CB
        bit  2,e                        ;=> 060A  CB 53
        res  2,e                        ;=> 060C  CB 93
        set  2,e                        ;=> 060E  CB D3
        bit  3,e                        ;=> 0610  CB 5B
        res  3,e                        ;=> 0612  CB 9B
        set  3,e                        ;=> 0614  CB DB
        bit  4,e                        ;=> 0616  CB 63
        res  4,e                        ;=> 0618  CB A3
        set  4,e                        ;=> 061A  CB E3
        bit  5,e                        ;=> 061C  CB 6B
        res  5,e                        ;=> 061E  CB AB
        set  5,e                        ;=> 0620  CB EB
        bit  6,e                        ;=> 0622  CB 73
        res  6,e                        ;=> 0624  CB B3
        set  6,e                        ;=> 0626  CB F3
        bit  7,e                        ;=> 0628  CB 7B
        res  7,e                        ;=> 062A  CB BB
        set  7,e                        ;=> 062C  CB FB
        bit  0,h                        ;=> 062E  CB 44
        res  0,h                        ;=> 0630  CB 84
        set  0,h                        ;=> 0632  CB C4
        bit  1,h                        ;=> 0634  CB 4C
        res  1,h                        ;=> 0636  CB 8C
        set  1,h                        ;=> 0638  CB CC
        bit  2,h                        ;=> 063A  CB 54
        res  2,h                        ;=> 063C  CB 94
        set  2,h                        ;=> 063E  CB D4
        bit  3,h                        ;=> 0640  CB 5C
        res  3,h                        ;=> 0642  CB 9C
        set  3,h                        ;=> 0644  CB DC
        bit  4,h                        ;=> 0646  CB 64
        res  4,h                        ;=> 0648  CB A4
        set  4,h                        ;=> 064A  CB E4
        bit  5,h                        ;=> 064C  CB 6C
        res  5,h                        ;=> 064E  CB AC
        set  5,h                        ;=> 0650  CB EC
        bit  6,h                        ;=> 0652  CB 74
        res  6,h                        ;=> 0654  CB B4
        set  6,h                        ;=> 0656  CB F4
        bit  7,h                        ;=> 0658  CB 7C
        res  7,h                        ;=> 065A  CB BC
        set  7,h                        ;=> 065C  CB FC
        bit  0,l                        ;=> 065E  CB 45
        res  0,l                        ;=> 0660  CB 85
        set  0,l                        ;=> 0662  CB C5
        bit  1,l                        ;=> 0664  CB 4D
        res  1,l                        ;=> 0666  CB 8D
        set  1,l                        ;=> 0668  CB CD
        bit  2,l                        ;=> 066A  CB 55
        res  2,l                        ;=> 066C  CB 95
        set  2,l                        ;=> 066E  CB D5
        bit  3,l                        ;=> 0670  CB 5D
        res  3,l                        ;=> 0672  CB 9D
        set  3,l                        ;=> 0674  CB DD
        bit  4,l                        ;=> 0676  CB 65
        res  4,l                        ;=> 0678  CB A5
        set  4,l                        ;=> 067A  CB E5
        bit  5,l                        ;=> 067C  CB 6D
        res  5,l                        ;=> 067E  CB AD
        set  5,l                        ;=> 0680  CB ED
        bit  6,l                        ;=> 0682  CB 75
        res  6,l                        ;=> 0684  CB B5
        set  6,l                        ;=> 0686  CB F5
        bit  7,l                        ;=> 0688  CB 7D
        res  7,l                        ;=> 068A  CB BD
        set  7,l                        ;=> 068C  CB FD
        bit  0,a                        ;=> 068E  CB 47
        res  0,a                        ;=> 0690  CB 87
        set  0,a                        ;=> 0692  CB C7
        bit  1,a                        ;=> 0694  CB 4F
        res  1,a                        ;=> 0696  CB 8F
        set  1,a                        ;=> 0698  CB CF
        bit  2,a                        ;=> 069A  CB 57
        res  2,a                        ;=> 069C  CB 97
        set  2,a                        ;=> 069E  CB D7
        bit  3,a                        ;=> 06A0  CB 5F
        res  3,a                        ;=> 06A2  CB 9F
        set  3,a                        ;=> 06A4  CB DF
        bit  4,a                        ;=> 06A6  CB 67
        res  4,a                        ;=> 06A8  CB A7
        set  4,a                        ;=> 06AA  CB E7
        bit  5,a                        ;=> 06AC  CB 6F
        res  5,a                        ;=> 06AE  CB AF
        set  5,a                        ;=> 06B0  CB EF
        bit  6,a                        ;=> 06B2  CB 77
        res  6,a                        ;=> 06B4  CB B7
        set  6,a                        ;=> 06B6  CB F7
        bit  7,a                        ;=> 06B8  CB 7F
        res  7,a                        ;=> 06BA  CB BF
        set  7,a                        ;=> 06BC  CB FF
        bit  0,(hl)                     ;=> 06BE  CB 46
        res  0,(hl)                     ;=> 06C0  CB 86
        set  0,(hl)                     ;=> 06C2  CB C6
        bit  1,(hl)                     ;=> 06C4  CB 4E
        res  1,(hl)                     ;=> 06C6  CB 8E
        set  1,(hl)                     ;=> 06C8  CB CE
        bit  2,(hl)                     ;=> 06CA  CB 56
        res  2,(hl)                     ;=> 06CC  CB 96
        set  2,(hl)                     ;=> 06CE  CB D6
        bit  3,(hl)                     ;=> 06D0  CB 5E
        res  3,(hl)                     ;=> 06D2  CB 9E
        set  3,(hl)                     ;=> 06D4  CB DE
        bit  4,(hl)                     ;=> 06D6  CB 66
        res  4,(hl)                     ;=> 06D8  CB A6
        set  4,(hl)                     ;=> 06DA  CB E6
        bit  5,(hl)                     ;=> 06DC  CB 6E
        res  5,(hl)                     ;=> 06DE  CB AE
        set  5,(hl)                     ;=> 06E0  CB EE
        bit  6,(hl)                     ;=> 06E2  CB 76
        res  6,(hl)                     ;=> 06E4  CB B6
        set  6,(hl)                     ;=> 06E6  CB F6
        bit  7,(hl)                     ;=> 06E8  CB 7E
        res  7,(hl)                     ;=> 06EA  CB BE
        set  7,(hl)                     ;=> 06EC  CB FE
        bit  0,(ix+DIS)                 ;=> 06EE  DD CB 40 46
        res  0,(ix+DIS)                 ;=> 06F2  DD CB 40 86
        set  0,(ix+DIS)                 ;=> 06F6  DD CB 40 C6
        bit  1,(ix+DIS)                 ;=> 06FA  DD CB 40 4E
        res  1,(ix+DIS)                 ;=> 06FE  DD CB 40 8E
        set  1,(ix+DIS)                 ;=> 0702  DD CB 40 CE
        bit  2,(ix+DIS)                 ;=> 0706  DD CB 40 56
        res  2,(ix+DIS)                 ;=> 070A  DD CB 40 96
        set  2,(ix+DIS)                 ;=> 070E  DD CB 40 D6
        bit  3,(ix+DIS)                 ;=> 0712  DD CB 40 5E
        res  3,(ix+DIS)                 ;=> 0716  DD CB 40 9E
        set  3,(ix+DIS)                 ;=> 071A  DD CB 40 DE
        bit  4,(ix+DIS)                 ;=> 071E  DD CB 40 66
        res  4,(ix+DIS)                 ;=> 0722  DD CB 40 A6
        set  4,(ix+DIS)                 ;=> 0726  DD CB 40 E6
        bit  5,(ix+DIS)                 ;=> 072A  DD CB 40 6E
        res  5,(ix+DIS)                 ;=> 072E  DD CB 40 AE
        set  5,(ix+DIS)                 ;=> 0732  DD CB 40 EE
        bit  6,(ix+DIS)                 ;=> 0736  DD CB 40 76
        res  6,(ix+DIS)                 ;=> 073A  DD CB 40 B6
        set  6,(ix+DIS)                 ;=> 073E  DD CB 40 F6
        bit  7,(ix+DIS)                 ;=> 0742  DD CB 40 7E
        res  7,(ix+DIS)                 ;=> 0746  DD CB 40 BE
        set  7,(ix+DIS)                 ;=> 074A  DD CB 40 FE
        bit  0,(iy+DIS)                 ;=> 074E  FD CB 40 46
        res  0,(iy+DIS)                 ;=> 0752  FD CB 40 86
        set  0,(iy+DIS)                 ;=> 0756  FD CB 40 C6
        bit  1,(iy+DIS)                 ;=> 075A  FD CB 40 4E
        res  1,(iy+DIS)                 ;=> 075E  FD CB 40 8E
        set  1,(iy+DIS)                 ;=> 0762  FD CB 40 CE
        bit  2,(iy+DIS)                 ;=> 0766  FD CB 40 56
        res  2,(iy+DIS)                 ;=> 076A  FD CB 40 96
        set  2,(iy+DIS)                 ;=> 076E  FD CB 40 D6
        bit  3,(iy+DIS)                 ;=> 0772  FD CB 40 5E
        res  3,(iy+DIS)                 ;=> 0776  FD CB 40 9E
        set  3,(iy+DIS)                 ;=> 077A  FD CB 40 DE
        bit  4,(iy+DIS)                 ;=> 077E  FD CB 40 66
        res  4,(iy+DIS)                 ;=> 0782  FD CB 40 A6
        set  4,(iy+DIS)                 ;=> 0786  FD CB 40 E6
        bit  5,(iy+DIS)                 ;=> 078A  FD CB 40 6E
        res  5,(iy+DIS)                 ;=> 078E  FD CB 40 AE
        set  5,(iy+DIS)                 ;=> 0792  FD CB 40 EE
        bit  6,(iy+DIS)                 ;=> 0796  FD CB 40 76
        res  6,(iy+DIS)                 ;=> 079A  FD CB 40 B6
        set  6,(iy+DIS)                 ;=> 079E  FD CB 40 F6
        bit  7,(iy+DIS)                 ;=> 07A2  FD CB 40 7E
        res  7,(iy+DIS)                 ;=> 07A6  FD CB 40 BE
        set  7,(iy+DIS)                 ;=> 07AA  FD CB 40 FE
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
        jp   NN                         ;=> 07AE  C3 30 00
        jp   (hl)                       ;=> 07B1  E9
        jp   (ix)                       ;=> 07B2  DD E9
        jp   (iy)                       ;=> 07B4  FD E9
        jp   nz,NN                      ;=> 07B6  C2 30 00
        jp   z,NN                       ;=> 07B9  CA 30 00
        jp   nc,NN                      ;=> 07BC  D2 30 00
        jp   c,NN                       ;=> 07BF  DA 30 00
        jp   po,NN                      ;=> 07C2  E2 30 00
        jp   pe,NN                      ;=> 07C5  EA 30 00
        jp   p,NN                       ;=> 07C8  F2 30 00
        jp   m,NN                       ;=> 07CB  FA 30 00

										; max forward jump
        jr   jr2                        ;=> 07CE  18 7F
        jr   jr2                        ;=> 07D0  18 7D
        jr   jr2                        ;=> 07D2  18 7B
        
        djnz ASMPC                      ;=> 07D4  10 FE
        djnz ASMPC+0x81                 ;=> 07D6  10 7F
        jr   ASMPC                      ;=> 07D8  18 FE
        jr   ASMPC-0x7E                 ;=> 07DA  18 80
        
        djnz jr1                        ;=> 07DC  10 00
jr1:
        jr   jr1                        ;=> 07DE  18 FE
        djnz jr1                        ;=> 07E0  10 FC
        jr   nz,jr1                     ;=> 07E2  20 FA
        jr   z,jr1                      ;=> 07E4  28 F8
        jr   nc,jr1                     ;=> 07E6  30 F6
        jr   c,jr1                      ;=> 07E8  38 F4
        
        defs 127-26, 0FFh 
jr2:
        defs 122, 0FFh 
        jr   jr2                        ;=> 08C9  18 84
        jr   jr2                        ;=> 08CB  18 82
										; max backward jump - z80pack does not accept -128
        jr   jr2                        ;=> 08CD  18 80
        

;	jr po,NN
;	jr pe,NN
;	jr p,NN
;	jr m,NN


;------------------------------------------------------------------------------
; Call and Return Group
;------------------------------------------------------------------------------

        call NN                         ;=> 08CF  CD 30 00
        ret                             ;=> 08D2  C9
        ret  nz                         ;=> 08D3  C0
        ret  z                          ;=> 08D4  C8
        ret  nc                         ;=> 08D5  D0
        ret  c                          ;=> 08D6  D8
        ret  po                         ;=> 08D7  E0
        ret  pe                         ;=> 08D8  E8
        ret  p                          ;=> 08D9  F0
        ret  m                          ;=> 08DA  F8
        reti                            ;=> 08DB  ED 4D
;	rst 0
;	rst 1
;	rst 2
;	rst 3
;	rst 4
;	rst 5
;	rst 6
;	rst 7


        call nz,NN                      ;=> 08DD  C4 30 00
        call z,NN                       ;=> 08E0  CC 30 00
        call nc,NN                      ;=> 08E3  D4 30 00
        call c,NN                       ;=> 08E6  DC 30 00
        call po,NN                      ;=> 08E9  E4 30 00
        call pe,NN                      ;=> 08EC  EC 30 00
        call p,NN                       ;=> 08EF  F4 30 00
        call m,NN                       ;=> 08F2  FC 30 00
        retn                            ;=> 08F5  ED 45
        rst  00h                        ;=> 08F7  C7
        rst  08h                        ;=> 08F8  CF
        rst  10h                        ;=> 08F9  D7
        rst  18h                        ;=> 08FA  DF
        rst  20h                        ;=> 08FB  E7
        rst  28h                        ;=> 08FC  EF
        rst  30h                        ;=> 08FD  F7
        rst  38h                        ;=> 08FE  FF


;------------------------------------------------------------------------------
; Input and Output Group
;------------------------------------------------------------------------------

        in   a,(N)                      ;=> 08FF  DB 20
        in   b,(c)                      ;=> 0901  ED 40
        in   c,(c)                      ;=> 0903  ED 48
        in   d,(c)                      ;=> 0905  ED 50
        in   e,(c)                      ;=> 0907  ED 58
        in   h,(c)                      ;=> 0909  ED 60
        in   l,(c)                      ;=> 090B  ED 68
        in   a,(c)                      ;=> 090D  ED 78
;	in f,(c)

        ini                             ;=> 090F  ED A2
        inir                            ;=> 0911  ED B2
        ind                             ;=> 0913  ED AA
        indr                            ;=> 0915  ED BA

        out  (N),a                      ;=> 0917  D3 20
        out  (c),b                      ;=> 0919  ED 41
        out  (c),c                      ;=> 091B  ED 49
        out  (c),d                      ;=> 091D  ED 51
        out  (c),e                      ;=> 091F  ED 59
        out  (c),h                      ;=> 0921  ED 61
        out  (c),l                      ;=> 0923  ED 69
        out  (c),a                      ;=> 0925  ED 79
;	out (c),0

        outi                            ;=> 0927  ED A3
        otir                            ;=> 0929  ED B3
        outd                            ;=> 092B  ED AB
        otdr                            ;=> 092D  ED BB

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
