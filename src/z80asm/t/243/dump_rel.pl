#!/usr/bin/env perl

# Dump a .rel file to stdout in a human-readable format.
# Handles only the subset of the .rel format used by the assembler.

use Modern::Perl;
use Path::Tiny;

@ARGV==1 or die "Usage: $0 file.rel\n";
my $rel_file = $ARGV[0];
my $rel_data = path($rel_file)->slurp_raw;
my $bits = unpack "B*", $rel_data;

my $code = { name => "CSEG", pc => 0, bytes => [] };
my $data = { name => "DSEG", pc => 0, bytes => [] };
my $current = $code;

while (1) {
    if ($bits =~ s/^(0)([01]{8})//) {
        # data byte
        my($a, $b) = ($1, $2);
        my $byte = oct("0b$b");
        say sprintf "$a $b %s 0x%04x 0x%02x", $current->{name}, $current->{pc}, $byte;
        $current->{bytes}[$current->{pc}] = $byte;
        $current->{pc}++;
    }
    elsif ($bits =~ s/^(1)(00)(0000)//) {
        # entry symbol
        my($a, $b, $c) = ($1, $2, $3);
        say "$a $b $c entry symbol";
        (my $name, $bits) = get_name($bits);
    }
    elsif ($bits =~ s/^(1)(00)(0010)//) {
        # program name
        my($a, $b, $c) = ($1, $2, $3);
        say "$a $b $c program name";
        (my $name, $bits) = get_name($bits);
    }
    elsif ($bits =~ s/^(1)(00)(0110)//) {
        # chain external
        my($a, $b, $c) = ($1, $2, $3);
        say "$a $b $c chain external";
        ( my $type, my $offset, $bits ) = get_value($bits);
        (my $name, $bits) = get_name($bits);
    }
    elsif ($bits =~ s/^(1)(00)(0111)//) {
        # entry point
        my($a, $b, $c) = ($1, $2, $3);
        say "$a $b $c entry point";
        ( my $type, my $offset, $bits ) = get_value($bits);
        (my $name, $bits) = get_name($bits);
    }
    elsif ( $bits =~ s/^(1)(00)(1010)// ) {
        # define data size
        my ( $a, $b, $c ) = ( $1, $2, $3 );
        say "$a $b $c define data size";
        ( my $type, my $offset, $bits ) = get_value($bits);
    }
    elsif ( $bits =~ s/^(1)(00)(1011)// ) {
        # set location counter
        my ( $a, $b, $c ) = ( $1, $2, $3 );
        say "$a $b $c set location counter";
        ( my $type, my $offset, $bits ) = get_value($bits);
        if ($type eq "ABS") {
            die "ABS segments not supported";
        }
        elsif ($type eq "PREL") {
            $current = $code;
        }
        elsif ($type eq "DREL") {
            $current = $data;
        }
        elsif ($type eq "CREL") {
            die "COMMON segments not supported";
        }
        $current->{pc} = $offset;
    }
    elsif ($bits =~ s/^(1)(00)(1101)//) {
        # define program size
        my($a, $b, $c) = ($1, $2, $3);
        say "$a $b $c define program size";
        (my $type, my $offset, $bits) = get_value($bits);
    }
    elsif ($bits =~ s/^(1)(00)(1110)//) {
        # end module
        my($a, $b, $c) = ($1, $2, $3);
        say "$a $b $c end module";
        (my $type, my $offset, $bits) = get_value($bits);
        last;
    }
    else {
        die "Don't know how to handle bits: $bits";
    }
}

say "Code segment: ", join(" ", map { sprintf "%02x", $_ } @{$code->{bytes}});
say "Data segment: ", join(" ", map { sprintf "%02x", $_ } @{$data->{bytes}});
say "Remaining bits: $bits";

sub get_name {
    my($bits) = @_;
    $bits =~ s/^([01]{3})// or die "Not enough bits for name";
    my $a = $1;
    my $size = oct("0b$a");
    say "    $a size $size";
    my $name = "";
    for (1..$size) {
        $bits =~ s/^([01]{8})// or die "Not enough bits for name";
        my $a = $1;
        my $byte = oct("0b$a");
        say "    $a '".chr($byte)."'";
        $name .= chr($byte);
    }
    return ($name, $bits);
}

sub get_value {
    my($bits) = @_;
    $bits =~ s/^([01]{2})([01]{8})([01]{8})// or die "Not enough bits for value";
    my($type_bits, $low_byte, $high_byte) = ($1, $2, $3);
    my $type = oct("0b$type_bits");
    my $type_str = ($type == 0 ? "ABS" :
                    $type == 1 ? "PREL" :
                    $type == 2 ? "DREL" :
                    $type == 3 ? "CREL" : die "Unknown type $type");
    my $offset = (oct("0b$high_byte") << 8) | oct("0b$low_byte");
    say "    $type_bits $low_byte $high_byte value $type_str ".sprintf("0x%04x", $offset);
    return ($type_str, $offset, $bits);
}
