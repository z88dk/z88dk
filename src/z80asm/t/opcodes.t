#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/opcodes.t,v 1.6 2014-04-15 23:22:18 pauloscustodio Exp $

use strict;
use warnings;
use Test::More;
require 't/test_utils.pl';


# Z80 | RABBIT
assemble("", <<'END');
start:
	call_oz(1)		; E7 01
	call_oz(255)	; E7 FF
	call_oz(256)	; E7 00 01
	call_oz(65535)	; E7 FF FF
	call_pkg(0)		; CF 00 00
	call_pkg(1)		; CF 01 00
	call_pkg(65535)	; CF FF FF
	ex	af,af		; 08
	ex	af,af'		; 08
	fpp(1)			; DF 01
	fpp(254)		; DF FE
	im	0			; ED 46			Z80
	im	1			; ED 56			Z80
	im	2			; ED 5E			Z80
	invoke(0)		; CD 00 00
	invoke(1)		; CD 01 00
	invoke(65535)	; CD FF FF
	rst	0x00		; C7			Z80
	rst	0x08		; CF			Z80
	rst	0x10		; D7          
	rst	0x18		; DF          
	rst	0x20		; E7          
	rst	0x28		; EF          
	rst	0x30		; F7			Z80
	rst	0x38		; FF          
END


# TI83PLUS
assemble("--ti83plus", <<'END');
	invoke(0)		; EF 00 00
	invoke(1)		; EF 01 00
	invoke(65535)	; EF FF FF
END


# invalid arguments
check_errors("", <<'ASM');
	call_oz(0)      ; integer '0' out of range
	call_oz(65536)	; integer '65536' out of range
	call_pkg(-1)    ; integer '-1' out of range
	call_pkg(65536) ; integer '65536' out of range
	fpp(0)    		; integer '0' out of range
	fpp(256)	 	; integer '256' out of range
	invoke(-1)    	; integer '-1' out of range
	invoke(65536) 	; integer '65536' out of range
	im 	-1			; integer '-1' out of range
	im 	3			; integer '3' out of range
	im 	undefined	; symbol not defined
	rst	undefined   ; symbol not defined
	rst -1			; integer '-1' out of range
ASM


# not in RABBIT
check_errors("--RCMX000", <<'ASM');
	im	0			; illegal identifier
	im	1           ; illegal identifier
	im	2           ; illegal identifier
	rst	0x00        ; illegal identifier
	rst	0x08        ; illegal identifier
	rst	0x30        ; illegal identifier
ASM


unlink_testfiles();
done_testing();


# assemble the given code, compare
sub assemble {
	my($options, $code) = @_;
	
	my $addr = 0;
	my %label;
	my $asm_z80 = ""; 
	my $asm_rabbit = "";
	my $bin = "";
	
	for (split(/\n/, $code)) {
		next unless /\S/;
		if (/^(\w+):/) {
			# label:  ; all line copied
			$label{$1} = $addr;
			$asm_z80      .= "$_\n";
			$asm_rabbit   .= "$_\n";
		}
		else {
			# opcode ; bytes [Z80|RABBIT|""]
			my $variant;
			$variant = $1 if s/\s+(Z80|RABBIT)\s*$//;		# cpu type
		
			my $bytes = $_; $bytes =~ s/^[^;]+;\s*//;
			my $defb = "\tdefb "; 
			for (split(' ', $bytes)) {
				$defb .= "0x".$_.",";
				$bin  .= chr(hex($_));
				$addr++;
			}
			$defb =~ s/,$//;
			
			if ( ! $variant ) {
				$asm_z80      .= "$_\n";
				$asm_rabbit   .= "$_\n";
			}
			elsif ( $variant eq 'Z80' ) {
				$asm_z80      .= "$_\n";
				$asm_rabbit   .= "$defb\n";
			}
			elsif ( $variant eq 'RABBIT' ) {
				$asm_z80      .= "$defb\n";
				$asm_rabbit   .= "$_\n";
			}
			elsif ( $variant eq 'TI83PLUS' ) {
				$asm_z80      .= "$defb\n";
				$asm_rabbit   .= "$defb\n";
			}
			else {
				die;
			}
		}
	}
	
	length($bin) >= 0x10000 and die;

	# test asm in upper case
	t_z80asm(
		asm		=> uc($asm_z80),
		bin		=> $bin,
		options	=> $options,
	);

	# test asm 
	t_z80asm(
		asm		=> $asm_z80,
		bin		=> $bin,
		options	=> $options,
	);
	
	# test asm for RABBIT
	t_z80asm(
		asm		=> $asm_rabbit,
		bin		=> $bin,
		options	=> $options." --RCMX000",
	);
}

# assemble, check errors
sub check_errors {	
	my($options, $code) = @_;
	
	my $line = 0;
	my $asm = "";
	my $errors = "";
	
	for (split(/\n/, $code)) {
		next unless /\S/;
		
		$line++;
		$asm .= "$_\n";
		my($error_text) = /;\s*(.*)/ or die;
		$errors .= "Error at file '".asm_file()."' line ".$line.": ".$error_text."\n";
	}
	$errors .= $line." errors occurred during assembly\n";
	
	write_file(asm_file(), $asm);
	t_z80asm_capture($options." ".asm_file(), "", $errors, 1 );
}

# $Log: opcodes.t,v $
# Revision 1.6  2014-04-15 23:22:18  pauloscustodio
# FPP: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.5  2014/04/15 23:12:04  pauloscustodio
# INVOKE: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.4  2014/04/15 22:31:17  pauloscustodio
# CALL_PKG: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.3  2014/04/15 22:14:27  pauloscustodio
# CALL_OZ: no need for special treatment for parenthesis surrounding expression,
# as any axpression can be surrounded by parenthesis
#
# Revision 1.2  2014/04/15 20:45:05  pauloscustodio
# Added error message for invalid interrupt mode in IM, e.g. for "IM 3":
# Error at file 'test.asm' line 2: integer '3' out of range
#
# Revision 1.1  2014/03/29 01:19:41  pauloscustodio
# Accept both "ex af,af" and "ex af,af'"
#

__END__
List of all opcodes not yet in test list:

	adc	a,(hl)			; 8E          
	adc	a,(ix+ind)			; DD 8E 05    
	adc	a,(iy+ind)			; FD 8E 05    
	adc	a,a			; 8F          
	adc	a,b			; 88          
	adc	a,c			; 89          
	adc	a,d			; 8A          
	adc	a,e			; 8B          
	adc	a,h			; 8C          
	adc	a,l			; 8D          
	adc	a,n			; CE 20       
	adc	hl,bc			; ED 4A       
	adc	hl,de			; ED 5A       
	adc	hl,hl			; ED 6A       
	adc	hl,sp			; ED 7A       
	add	a,(hl)			; 86          
	add	a,(ix+ind)			; DD 86 05    
	add	a,(iy+ind)			; FD 86 05    
	add	a,a			; 87          
	add	a,b			; 80          
	add	a,c			; 81          
	add	a,d			; 82          
	add	a,e			; 83          
	add	a,h			; 84          
	add	a,l			; 85          
	add	a,n			; C6 20       
	add	hl,bc			; 09          
	add	hl,de			; 19          
	add	hl,hl			; 29          
	add	hl,sp			; 39          
	add	ix,bc			; DD 09       
	add	ix,de			; DD 19       
	add	ix,ix			; DD 29       
	add	ix,sp			; DD 39       
	add	iy,bc			; FD 09       
	add	iy,de			; FD 19       
	add	iy,iy			; FD 29       
	add	iy,sp			; FD 39       
	and	(hl)			; A6          
	and	(ix+ind)			; DD A6 05    
	and	(iy+ind)			; FD A6 05    
	and	a			; A7          
	and	b			; A0          
	and	c			; A1          
	and	d			; A2          
	and	e			; A3          
	and	h			; A4          
	and	l			; A5          
	and	n			; E6 20       
	bit	0,(hl)			; CB 46       
	bit	0,(ix+ind)			; DD CB 05 46 
	bit	0,(iy+ind)			; FD CB 05 46 
	bit	0,a			; CB 47       
	bit	0,b			; CB 40       
	bit	0,c			; CB 41       
	bit	0,d			; CB 42       
	bit	0,e			; CB 43       
	bit	0,h			; CB 44       
	bit	0,l			; CB 45       
	bit	1,(hl)			; CB 4E       
	bit	1,(ix+ind)			; DD CB 05 4E 
	bit	1,(iy+ind)			; FD CB 05 4E 
	bit	1,a			; CB 4F       
	bit	1,b			; CB 48       
	bit	1,c			; CB 49       
	bit	1,d			; CB 4A       
	bit	1,e			; CB 4B       
	bit	1,h			; CB 4C       
	bit	1,l			; CB 4D       
	bit	2,(hl)			; CB 56       
	bit	2,(ix+ind)			; DD CB 05 56 
	bit	2,(iy+ind)			; FD CB 05 56 
	bit	2,a			; CB 57       
	bit	2,b			; CB 50       
	bit	2,c			; CB 51       
	bit	2,d			; CB 52       
	bit	2,e			; CB 53       
	bit	2,h			; CB 54       
	bit	2,l			; CB 55       
	bit	3,(hl)			; CB 5E       
	bit	3,(ix+ind)			; DD CB 05 5E 
	bit	3,(iy+ind)			; FD CB 05 5E 
	bit	3,a			; CB 5F       
	bit	3,b			; CB 58       
	bit	3,c			; CB 59       
	bit	3,d			; CB 5A       
	bit	3,e			; CB 5B       
	bit	3,h			; CB 5C       
	bit	3,l			; CB 5D       
	bit	4,(hl)			; CB 66       
	bit	4,(ix+ind)			; DD CB 05 66 
	bit	4,(iy+ind)			; FD CB 05 66 
	bit	4,a			; CB 67       
	bit	4,b			; CB 60       
	bit	4,c			; CB 61       
	bit	4,d			; CB 62       
	bit	4,e			; CB 63       
	bit	4,h			; CB 64       
	bit	4,l			; CB 65       
	bit	5,(hl)			; CB 6E       
	bit	5,(ix+ind)			; DD CB 05 6E 
	bit	5,(iy+ind)			; FD CB 05 6E 
	bit	5,a			; CB 6F       
	bit	5,b			; CB 68       
	bit	5,c			; CB 69       
	bit	5,d			; CB 6A       
	bit	5,e			; CB 6B       
	bit	5,h			; CB 6C       
	bit	5,l			; CB 6D       
	bit	6,(hl)			; CB 76       
	bit	6,(ix+ind)			; DD CB 05 76 
	bit	6,(iy+ind)			; FD CB 05 76 
	bit	6,a			; CB 77       
	bit	6,b			; CB 70       
	bit	6,c			; CB 71       
	bit	6,d			; CB 72       
	bit	6,e			; CB 73       
	bit	6,h			; CB 74       
	bit	6,l			; CB 75       
	bit	7,(hl)			; CB 7E       
	bit	7,(ix+ind)			; DD CB 05 7E 
	bit	7,(iy+ind)			; FD CB 05 7E 
	bit	7,a			; CB 7F       
	bit	7,b			; CB 78       
	bit	7,c			; CB 79       
	bit	7,d			; CB 7A       
	bit	7,e			; CB 7B       
	bit	7,h			; CB 7C       
	bit	7,l			; CB 7D       
	call	c,nn			; DC 84 05    
	call	m,nn			; FC 84 05    
	call	nc,nn			; D4 84 05    
	call	nn			; CD 84 05    
	call	nz,nn			; C4 84 05    
	call	p,nn			; F4 84 05    
	call	pe,nn			; EC 84 05    
	call	po,nn			; E4 84 05    
	call	z,nn			; CC 84 05    
	ccf			; 3F          
	cp	(hl)			; BE          
	cp	(ix+ind)			; DD BE 05    
	cp	(iy+ind)			; FD BE 05    
	cp	a			; BF          
	cp	b			; B8          
	cp	c			; B9          
	cp	d			; BA          
	cp	e			; BB          
	cp	h			; BC          
	cp	l			; BD          
	cp	n			; FE 20       
	cpd			; ED A9       
	cpdr			; ED B9       
	cpi			; ED A1       
	cpir			; ED B1       
	cpl			; 2F          
	daa			; 27          
	dec	(hl)			; 35          
	dec	(ix+ind)			; DD 35 05    
	dec	(iy+ind)			; FD 35 05    
	dec	a			; 3D          
	dec	b			; 05          
	dec	bc			; 0B          
	dec	c			; 0D          
	dec	d			; 15          
	dec	de			; 1B          
	dec	e			; 1D          
	dec	h			; 25          
	dec	hl			; 2B          
	dec	ix			; DD 2B       
	dec	iy			; FD 2B       
	dec	l			; 2D          
	dec	sp			; 3B          
	di			; F3          
	djnz	asmpc+dis			; 10 2E       
	ei			; FB          
	ex	(sp),hl			; E3          
	ex	(sp),ix			; DD E3       
	ex	(sp),iy			; FD E3       
	ex	af,af'			; 08          
	ex	de,hl			; EB          
	exx			; D9          
	halt			; 76          
	in	a,(c)			; ED 78       
	in	a,(n)			; DB 20       
	in	b,(c)			; ED 40       
	in	c,(c)			; ED 48       
	in	d,(c)			; ED 50       
	in	e,(c)			; ED 58       
	in	h,(c)			; ED 60       
	in	l,(c)			; ED 68       
	inc	(hl)			; 34          
	inc	(ix+ind)			; DD 34 05    
	inc	(iy+ind)			; FD 34 05    
	inc	a			; 3C          
	inc	b			; 04          
	inc	bc			; 03          
	inc	c			; 0C          
	inc	d			; 14          
	inc	de			; 13          
	inc	e			; 1C          
	inc	h			; 24          
	inc	hl			; 23          
	inc	ix			; DD 23       
	inc	iy			; FD 23       
	inc	l			; 2C          
	inc	sp			; 33          
	ind			; ED AA       
	indr			; ED BA       
	ini			; ED A2       
	inir			; ED B2       
	jp	(hl)			; E9          
	jp	(ix)			; DD E9       
	jp	(iy)			; FD E9       
	jp	c,nn			; DA 84 05    
	jp	m,nn			; FA 84 05    
	jp	nc,nn			; D2 84 05    
	jp	nn			; C3 84 05    
	jp	nz,nn			; C2 84 05    
	jp	p,nn			; F2 84 05    
	jp	pe,nn			; EA 84 05    
	jp	po,nn			; E2 84 05    
	jp	z,nn			; CA 84 05    
	jr	c,asmpc+dis			; 38 2E       
	jr	asmpc+dis			; 18 2E       
	jr	nc,asmpc+dis			; 30 2E       
	jr	nz,asmpc+dis			; 20 2E       
	jr	z,asmpc+dis			; 28 2E       
	ld	(bc),a			; 02          
	ld	(de),a			; 12          
	ld	(hl),a			; 77          
	ld	(hl),b			; 70          
	ld	(hl),c			; 71          
	ld	(hl),d			; 72          
	ld	(hl),e			; 73          
	ld	(hl),h			; 74          
	ld	(hl),l			; 75          
	ld	(hl),n			; 36 20       
	ld	(ix+ind),a			; DD 36 05    
	ld	(ix+ind),b			; DD 36 05    
	ld	(ix+ind),c			; DD 36 05    
	ld	(ix+ind),d			; DD 36 05    
	ld	(ix+ind),e			; DD 36 05    
	ld	(ix+ind),h			; DD 36 05    
	ld	(ix+ind),l			; DD 36 05    
	ld	(ix+ind),n			; DD 36 05 20 
	ld	(iy+ind),a			; FD 36 05    
	ld	(iy+ind),b			; FD 36 05    
	ld	(iy+ind),c			; FD 36 05    
	ld	(iy+ind),d			; FD 36 05    
	ld	(iy+ind),e			; FD 36 05    
	ld	(iy+ind),h			; FD 36 05    
	ld	(iy+ind),l			; FD 36 05    
	ld	(iy+ind),n			; FD 36 05 20 
	ld	(nn),a			; 32 84 05    
	ld	(nn),bc			; ED 43 84 05 
	ld	(nn),de			; ED 53 84 05 
	ld	(nn),hl			; 22 84 05    
	ld	(nn),ix			; DD 22 84 05 
	ld	(nn),iy			; FD 22 84 05 
	ld	(nn),sp			; ED 73 84 05 
	ld	a,(bc)			; 0A          
	ld	a,(de)			; 1A          
	ld	a,(hl)			; 7E          
	ld	a,(ix+ind)			; DD 7E 05    
	ld	a,(iy+ind)			; FD 7E 05    
	ld	a,(nn)			; 3A 84 05    
	ld	a,a			; 7F          
	ld	a,b			; 78          
	ld	a,c			; 79          
	ld	a,d			; 7A          
	ld	a,e			; 7B          
	ld	a,h			; 7C          
	ld	a,i			; ED 57       
	ld	a,l			; 7D          
	ld	a,n			; 3E 20       
	ld	b,(hl)			; 46          
	ld	b,(ix+ind)			; DD 46 05    
	ld	b,(iy+ind)			; FD 46 05    
	ld	b,a			; 47          
	ld	b,b			; 40          
	ld	b,c			; 41          
	ld	b,d			; 42          
	ld	b,e			; 43          
	ld	b,h			; 44          
	ld	b,l			; 45          
	ld	b,n			; 06 20       
	ld	bc,(nn)			; ED 4B 84 05 
	ld	bc,nn			; 01 84 05    
	ld	c,(hl)			; 4E          
	ld	c,(ix+ind)			; DD 4E 05    
	ld	c,(iy+ind)			; FD 4E 05    
	ld	c,a			; 4F          
	ld	c,b			; 48          
	ld	c,c			; 49          
	ld	c,d			; 4A          
	ld	c,e			; 4B          
	ld	c,h			; 4C          
	ld	c,l			; 4D          
	ld	c,n			; 0E 20       
	ld	d,(hl)			; 56          
	ld	d,(ix+ind)			; DD 56 05    
	ld	d,(iy+ind)			; FD 56 05    
	ld	d,a			; 57          
	ld	d,b			; 50          
	ld	d,c			; 51          
	ld	d,d			; 52          
	ld	d,e			; 53          
	ld	d,h			; 54          
	ld	d,l			; 55          
	ld	d,n			; 16 20       
	ld	de,(nn)			; ED 5B 84 05 
	ld	de,nn			; 11 84 05    
	ld	e,(hl)			; 5E          
	ld	e,(ix+ind)			; DD 5E 05    
	ld	e,(iy+ind)			; FD 5E 05    
	ld	e,a			; 5F          
	ld	e,b			; 58          
	ld	e,c			; 59          
	ld	e,d			; 5A          
	ld	e,e			; 5B          
	ld	e,h			; 5C          
	ld	e,l			; 5D          
	ld	e,n			; 1E 20       
	ld	h,(hl)			; 66          
	ld	h,(ix+ind)			; DD 66 05    
	ld	h,(iy+ind)			; FD 66 05    
	ld	h,a			; 67          
	ld	h,b			; 60          
	ld	h,c			; 61          
	ld	h,d			; 62          
	ld	h,e			; 63          
	ld	h,h			; 64          
	ld	h,l			; 65          
	ld	h,n			; 26 20       
	ld	hl,(nn)			; 2A 84 05    
	ld	hl,nn			; 21 84 05    
	ld	i,a			; ED 47       
	ld	ix,(nn)			; DD 2A 84 05 
	ld	ix,nn			; DD 21 84 05 
	ld	iy,(nn)			; FD 2A 84 05 
	ld	iy,nn			; FD 21 84 05 
	ld	l,(hl)			; 6E          
	ld	l,(ix+ind)			; DD 6E 05    
	ld	l,(iy+ind)			; FD 6E 05    
	ld	l,a			; 6F          
	ld	l,b			; 68          
	ld	l,c			; 69          
	ld	l,d			; 6A          
	ld	l,e			; 6B          
	ld	l,h			; 6C          
	ld	l,l			; 6D          
	ld	l,n			; 2E 20       
	ld	sp,(nn)			; ED 7B 84 05 
	ld	sp,hl			; F9          
	ld	sp,ix			; DD F9       
	ld	sp,iy			; FD F9       
	ld	sp,nn			; 31 84 05    
	ldd			; ED A8       
	lddr			; ED B8       
	ldi			; ED A0       
	ldir			; ED B0       
	neg			; ED 44       
	nop			; 00          
	or	(hl)			; B6          
	or	(ix+ind)			; DD B6 05    
	or	(iy+ind)			; FD B6 05    
	or	a			; B7          
	or	b			; B0          
	or	c			; B1          
	or	d			; B2          
	or	e			; B3          
	or	h			; B4          
	or	l			; B5          
	or	n			; F6 20       
	otdr			; ED BB       
	otir			; ED B3       
	out	(c),a			; ED 79       
	out	(c),b			; ED 41       
	out	(c),c			; ED 49       
	out	(c),d			; ED 51       
	out	(c),e			; ED 59       
	out	(c),h			; ED 61       
	out	(c),l			; ED 69       
	out	(n),a			; D3 20       
	outd			; ED AB       
	outi			; ED A3       
	pop	af			; F1          
	pop	bc			; C1          
	pop	de			; D1          
	pop	hl			; E1          
	pop	ix			; DD E1       
	pop	iy			; FD E1       
	push	af			; F5          
	push	bc			; C5          
	push	de			; D5          
	push	hl			; E5          
	push	ix			; DD E5       
	push	iy			; FD E5       
	res	0,(hl)			; CB 86       
	res	0,(ix+ind)			; DD CB 05 86 
	res	0,(iy+ind)			; FD CB 05 86 
	res	0,a			; CB 87       
	res	0,b			; CB 80       
	res	0,c			; CB 81       
	res	0,d			; CB 82       
	res	0,e			; CB 83       
	res	0,h			; CB 84       
	res	0,l			; CB 85       
	res	1,(hl)			; CB 8E       
	res	1,(ix+ind)			; DD CB 05 8E 
	res	1,(iy+ind)			; FD CB 05 8E 
	res	1,a			; CB 8F       
	res	1,b			; CB 88       
	res	1,c			; CB 89       
	res	1,d			; CB 8A       
	res	1,e			; CB 8B       
	res	1,h			; CB 8C       
	res	1,l			; CB 8D       
	res	2,(hl)			; CB 96       
	res	2,(ix+ind)			; DD CB 05 96 
	res	2,(iy+ind)			; FD CB 05 96 
	res	2,a			; CB 97       
	res	2,b			; CB 90       
	res	2,c			; CB 91       
	res	2,d			; CB 92       
	res	2,e			; CB 93       
	res	2,h			; CB 94       
	res	2,l			; CB 95       
	res	3,(hl)			; CB 9E       
	res	3,(ix+ind)			; DD CB 05 9E 
	res	3,(iy+ind)			; FD CB 05 9E 
	res	3,a			; CB 9F       
	res	3,b			; CB 98       
	res	3,c			; CB 99       
	res	3,d			; CB 9A       
	res	3,e			; CB 9B       
	res	3,h			; CB 9C       
	res	3,l			; CB 9D       
	res	4,(hl)			; CB A6       
	res	4,(ix+ind)			; DD CB 05 A6 
	res	4,(iy+ind)			; FD CB 05 A6 
	res	4,a			; CB A7       
	res	4,b			; CB A0       
	res	4,c			; CB A1       
	res	4,d			; CB A2       
	res	4,e			; CB A3       
	res	4,h			; CB A4       
	res	4,l			; CB A5       
	res	5,(hl)			; CB AE       
	res	5,(ix+ind)			; DD CB 05 AE 
	res	5,(iy+ind)			; FD CB 05 AE 
	res	5,a			; CB AF       
	res	5,b			; CB A8       
	res	5,c			; CB A9       
	res	5,d			; CB AA       
	res	5,e			; CB AB       
	res	5,h			; CB AC       
	res	5,l			; CB AD       
	res	6,(hl)			; CB B6       
	res	6,(ix+ind)			; DD CB 05 B6 
	res	6,(iy+ind)			; FD CB 05 B6 
	res	6,a			; CB B7       
	res	6,b			; CB B0       
	res	6,c			; CB B1       
	res	6,d			; CB B2       
	res	6,e			; CB B3       
	res	6,h			; CB B4       
	res	6,l			; CB B5       
	res	7,(hl)			; CB BE       
	res	7,(ix+ind)			; DD CB 05 BE 
	res	7,(iy+ind)			; FD CB 05 BE 
	res	7,a			; CB BF       
	res	7,b			; CB B8       
	res	7,c			; CB B9       
	res	7,d			; CB BA       
	res	7,e			; CB BB       
	res	7,h			; CB BC       
	res	7,l			; CB BD       
	ret			; C9          
	ret	c			; D8          
	ret	m			; F8          
	ret	nc			; D0          
	ret	nz			; C0          
	ret	p			; F0          
	ret	pe			; E8          
	ret	po			; E0          
	ret	z			; C8          
	reti			; ED 4D       
	retn			; ED 45       
	rl	(hl)			; CB 16       
	rl	(ix+ind)			; DD CB 05 16 
	rl	(iy+ind)			; FD CB 05 16 
	rl	a			; CB 17       
	rl	b			; CB 10       
	rl	c			; CB 11       
	rl	d			; CB 12       
	rl	e			; CB 13       
	rl	h			; CB 14       
	rl	l			; CB 15       
	rla			; 17          
	rlc	(hl)			; CB 06       
	rlc	(ix+ind)			; DD CB 05 06 
	rlc	(iy+ind)			; FD CB 05 06 
	rlc	a			; CB 07       
	rlc	b			; CB 00       
	rlc	c			; CB 01       
	rlc	d			; CB 02       
	rlc	e			; CB 03       
	rlc	h			; CB 04       
	rlc	l			; CB 05       
	rlca			; 07          
	rld			; ED 6F       
	rr	(hl)			; CB 1E       
	rr	(ix+ind)			; DD CB 05 1E 
	rr	(iy+ind)			; FD CB 05 1E 
	rr	a			; CB 1F       
	rr	b			; CB 18       
	rr	c			; CB 19       
	rr	d			; CB 1A       
	rr	e			; CB 1B       
	rr	h			; CB 1C       
	rr	l			; CB 1D       
	rra			; 1F          
	rrc	(hl)			; CB 0E       
	rrc	(ix+ind)			; DD CB 05 0E 
	rrc	(iy+ind)			; FD CB 05 0E 
	rrc	a			; CB 0F       
	rrc	b			; CB 08       
	rrc	c			; CB 09       
	rrc	d			; CB 0A       
	rrc	e			; CB 0B       
	rrc	h			; CB 0C       
	rrc	l			; CB 0D       
	rrca			; 0F          
	rrd			; ED 67       
	sbc	a,(hl)			; 9E          
	sbc	a,(ix+ind)			; DD 9E 05    
	sbc	a,(iy+ind)			; FD 9E 05    
	sbc	a,a			; 9F          
	sbc	a,b			; 98          
	sbc	a,c			; 99          
	sbc	a,d			; 9A          
	sbc	a,e			; 9B          
	sbc	a,h			; 9C          
	sbc	a,l			; 9D          
	sbc	a,n			; DE 20       
	sbc	hl,bc			; ED 42       
	sbc	hl,de			; ED 52       
	sbc	hl,hl			; ED 62       
	sbc	hl,sp			; ED 72       
	scf			; 37          
	set	0,(hl)			; CB C6       
	set	0,(ix+ind)			; DD CB 05 C6 
	set	0,(iy+ind)			; FD CB 05 C6 
	set	0,a			; CB C7       
	set	0,b			; CB C0       
	set	0,c			; CB C1       
	set	0,d			; CB C2       
	set	0,e			; CB C3       
	set	0,h			; CB C4       
	set	0,l			; CB C5       
	set	1,(hl)			; CB CE       
	set	1,(ix+ind)			; DD CB 05 CE 
	set	1,(iy+ind)			; FD CB 05 CE 
	set	1,a			; CB CF       
	set	1,b			; CB C8       
	set	1,c			; CB C9       
	set	1,d			; CB CA       
	set	1,e			; CB CB       
	set	1,h			; CB CC       
	set	1,l			; CB CD       
	set	2,(hl)			; CB D6       
	set	2,(ix+ind)			; DD CB 05 D6 
	set	2,(iy+ind)			; FD CB 05 D6 
	set	2,a			; CB D7       
	set	2,b			; CB D0       
	set	2,c			; CB D1       
	set	2,d			; CB D2       
	set	2,e			; CB D3       
	set	2,h			; CB D4       
	set	2,l			; CB D5       
	set	3,(hl)			; CB DE       
	set	3,(ix+ind)			; DD CB 05 DE 
	set	3,(iy+ind)			; FD CB 05 DE 
	set	3,a			; CB DF       
	set	3,b			; CB D8       
	set	3,c			; CB D9       
	set	3,d			; CB DA       
	set	3,e			; CB DB       
	set	3,h			; CB DC       
	set	3,l			; CB DD       
	set	4,(hl)			; CB E6       
	set	4,(ix+ind)			; DD CB 05 E6 
	set	4,(iy+ind)			; FD CB 05 E6 
	set	4,a			; CB E7       
	set	4,b			; CB E0       
	set	4,c			; CB E1       
	set	4,d			; CB E2       
	set	4,e			; CB E3       
	set	4,h			; CB E4       
	set	4,l			; CB E5       
	set	5,(hl)			; CB EE       
	set	5,(ix+ind)			; DD CB 05 EE 
	set	5,(iy+ind)			; FD CB 05 EE 
	set	5,a			; CB EF       
	set	5,b			; CB E8       
	set	5,c			; CB E9       
	set	5,d			; CB EA       
	set	5,e			; CB EB       
	set	5,h			; CB EC       
	set	5,l			; CB ED       
	set	6,(hl)			; CB F6       
	set	6,(ix+ind)			; DD CB 05 F6 
	set	6,(iy+ind)			; FD CB 05 F6 
	set	6,a			; CB F7       
	set	6,b			; CB F0       
	set	6,c			; CB F1       
	set	6,d			; CB F2       
	set	6,e			; CB F3       
	set	6,h			; CB F4       
	set	6,l			; CB F5       
	set	7,(hl)			; CB FE       
	set	7,(ix+ind)			; DD CB 05 FE 
	set	7,(iy+ind)			; FD CB 05 FE 
	set	7,a			; CB FF       
	set	7,b			; CB F8       
	set	7,c			; CB F9       
	set	7,d			; CB FA       
	set	7,e			; CB FB       
	set	7,h			; CB FC       
	set	7,l			; CB FD       
	sla	(hl)			; CB 26       
	sla	(ix+ind)			; DD CB 05 26 
	sla	(iy+ind)			; FD CB 05 26 
	sla	a			; CB 27       
	sla	b			; CB 20       
	sla	c			; CB 21       
	sla	d			; CB 22       
	sla	e			; CB 23       
	sla	h			; CB 24       
	sla	l			; CB 25       
	sra	(hl)			; CB 2E       
	sra	(ix+ind)			; DD CB 05 2E 
	sra	(iy+ind)			; FD CB 05 2E 
	sra	a			; CB 2F       
	sra	b			; CB 28       
	sra	c			; CB 29       
	sra	d			; CB 2A       
	sra	e			; CB 2B       
	sra	h			; CB 2C       
	sra	l			; CB 2D       
	srl	(hl)			; CB 3E       
	srl	(ix+ind)			; DD CB 05 3E 
	srl	(iy+ind)			; FD CB 05 3E 
	srl	a			; CB 3F       
	srl	b			; CB 38       
	srl	c			; CB 39       
	srl	d			; CB 3A       
	srl	e			; CB 3B       
	srl	h			; CB 3C       
	srl	l			; CB 3D       
	sub	(hl)			; 96          
	sub	(ix+ind)			; DD 96 05    
	sub	(iy+ind)			; FD 96 05    
	sub	a			; 97          
	sub	b			; 90          
	sub	c			; 91          
	sub	d			; 92          
	sub	e			; 93          
	sub	h			; 94          
	sub	l			; 95          
	sub	n			; D6 20       
	xor	(hl)			; AE          
	xor	(ix+ind)			; DD AE 05    
	xor	(iy+ind)			; FD AE 05    
	xor	a			; AF          
	xor	b			; A8          
	xor	c			; A9          
	xor	d			; AA          
	xor	e			; AB          
	xor	h			; AC          
	xor	l			; AD          
	xor	n			; EE 20       
