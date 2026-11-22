#!/usr/bin/perl

use bytes;

sub genpad($$) {
    my($left, $final) = @_;

    my $o = ($final ? "\x01" : "\x00") . ("\x00" x $$left);
    $$left = 252;		# Bytes left in block minus end marker

    return $o;
}

sub bacstmt($$$) {
    my($line, $left, $data) = @_;
    my $l = length($data) + 4;
    my $d = pack("Cv", $l, $line) . $data . "\x0d";

    if ($l > $$left) {
	$d = genpad($left,0).$d;
    }

    $$left -= $l;
    return $pad.$d;
}

sub makebac($$$) {
    my($data, $addr, $entrypt) = @_;

    my @bld;

    if (defined($addr)) {
	# <bacldr.asm code> - fixed load address
	$bld[0] = "\x2a\x1c\xfe\x01";
	# 16-bit offset from BOFA to first data line, must be <= 255
	$bld[1] = "\x09\x11";
	# 16-bit load address
	$bld[2] = "\x06\x00\x3e\xf8\x86\xd2";
	# 16-bit entry point
	$bld[3] = "\x0e\x06\x09\x4f\xed\xb0\x23\x23\x18\xf0";

	# 0x00C9 is the address for END in all ABC80 BASIC interpreters
	$entrypt = 0x00c9 unless(defined($entrypt));
    } else {
	# <bacldr2.asm> - relocatable data loaded at BOFA
	$bld[0] = "\x2a\x1c\xfe\xe5\x5d\x54\x01";
	# 16-bit offset from BOFA to first data line, must be <= 255
	$bld[1]  = "\x09\x3e\xf8\x86\x30\x0a\x0e\0x6\x09\x4f\xed\xb0";
	$bld[1] .= "\x23\x23\x18\xf1";
	$bld[1] .= "\xc1\xeb\x2b\x56\x2b\x5e\x7b\xa2\x3c\x28\x0b";
	$bld[1] .= "\xeb\x09\x7e\x81\x77\x23\x7e\x88\x77\x18\xeb\x21";
	# 16-bit offset for entry point
	$bld[2] = "\x09\xe9";

	# Default to entry = BOFA
	$entrypt = 0 unless(defined($entrypt));
    }

    my $bld;
    my $bldlen = 0;
    foreach $bld (@bld) {
	# +2 for a 16-bit value between each chunk, +2 for final BB 0D
	$bldlen += length($bld) + 2;
    }

    my $q  = "\x82";		# Output (program start marker)
    my $left = 251;		# Bytes left in block
    my $r = 0;			# Last emitted line number

    # Address 65054 is EOFA
    # 1 Z%=CALL(PEEK(65054%)+SWAP%(PEEK(65055%))-<loader offset>)
    $q .= bacstmt(++$r, \$left,
		  "\x83\xc1\xf1\x5a\x00\xbb\xc7\x1e\xfe\xce\x36\xc7".
		  "\x1f\xfe\xce\x36\xce\x34\xf5\xc7".
		  pack("v",$bldlen)."\xf8\xce\x3a\xb7");

    my $pfxlen = length($q) - 1; # The initial 0x82 isn't stored in RAM

    die if ($pfxlen > 255);	# Should not happen

    if (defined($addr)) {
	$bld = $bld[0] . pack("v", $pfxlen) .
	       $bld[1] . pack("v", $addr) .
	       $bld[2] . pack("v", $entrypt) .
	       $bld[3];
    } else {
	$bld = $bld[0] . pack("v", $pfxlen);
	       $bld[1] . pack("v", $entrypt) .
	       $bld[2];
    }

    my $i = 0;
    my $dl = length($data);
    while ($i < $dl) {
	my $l = $dl - $i;

	# 8 = 3 byte BAC header + 4 byte overhead + CR
	$q .= genpad(\$left,0) if ($left <= 8);
	$l = $left-8 if ($l > $left-8);

	# String expression + address + data + return
	$q .= bacstmt(++$r, \$left,
		      "\xcb\"" . pack("C", $l) . substr($data,$i,$l)."\xbb");

	$i += $l;
	$addr += $l;
    }

    # Terminal END statement
    $q .= bacstmt(++$r, \$left, "\x86\x8a"); # END

    # Loader code (string expression)
    $q .= bacstmt(++$r, \$left, "\xcb\"".pack("C",length($bld)).$bld."\xbb");
    $q .= genpad(\$left,1);

    return $q;
}

($file, $org, $entry) = @ARGV;

$org = oct $org if ( $org =~ /^0/ );
$entry = oct $entry if ( $entry =~ /^0/ );

open(FILE, '<:raw', $file) or die "$0: $file: $!\n";
$l = read(FILE, $dd, 65536);
close(FILE);

undef $org if ($org =~ /^(bofa|reloc|\-)$/i);

print makebac($dd, $org, $entry);
