#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Manipulate z80asm object files
#------------------------------------------------------------------------------

my $cur_version       = 19;
my $min_version       = 1;
my $module_signature  = "Z80RMF";
my $library_signature = "Z80LMF";
my $org_not_defined   = -1;
my $org_section_split = -2;

#------------------------------------------------------------------------------
# Binary data
#------------------------------------------------------------------------------
package BinData;

use Modern::Perl;
use Object::Tiny::RW qw( bytes read_pos );

sub new {
    my ($class) = @_;
    return bless {
        bytes    => [],
        read_pos => 0,
    }, $class;
}

sub size {
    my ($self) = @_;
    return scalar @{ $self->bytes };
}

sub data {
    my $self = shift;
    return pack( "C*", @{ $self->bytes } ) if @_ == 0;

    my $raw = shift;
    $self->read_pos(0);
    $self->bytes( [ unpack "C*", $raw ] );
}

sub pack_byte {
    my ( $self, $value ) = @_;
    push @{ $self->bytes }, $value & 0xFF;
}

sub pack_bytes {
    my ( $self, @values ) = @_;
    push @{ $self->bytes }, map { $_ & 0xFF } @values;
}

sub pack_word {
    my ( $self, $value ) = @_;
    push @{ $self->bytes }, $value & 0xFF, ( $value >> 8 ) & 0xFF;
}

sub pack_dword {
    my ( $self, $value ) = @_;
    push @{ $self->bytes }, $value & 0xFF, ( $value >> 8 ) & 0xFF,
        ( $value >> 16 ) & 0xFF, ( $value >> 24 ) & 0xFF;
}

sub patch_dword {
    my ( $self, $addr, $value ) = @_;
    $addr + 4 <= $self->size or die "invalid patch dword at address $addr";
    $self->bytes->[$addr]       = $value & 0xFF;
    $self->bytes->[ $addr + 1 ] = ( $value >> 8 ) & 0xFF;
    $self->bytes->[ $addr + 2 ] = ( $value >> 16 ) & 0xFF;
    $self->bytes->[ $addr + 3 ] = ( $value >> 24 ) & 0xFF;
}

sub pack_string {
    my ( $self, $text ) = @_;
    push @{ $self->bytes }, map { ord } split //, $text;
}

sub pack_cstring {
    my ( $self, $text ) = @_;
    length($text) <= 0xFF or die "string too long: $text";
    $self->pack_byte( length($text) );
    $self->pack_string($text);
}

sub pack_lstring {
    my ( $self, $text ) = @_;
    length($text) <= 0xFFFF or die "string too long: $text";
    $self->pack_word( length($text) );
    $self->pack_string($text);
}

sub pack_signature {
    my ( $self, $signature, $version ) = @_;
    $self->pack_string( sprintf( "%-6.6s%02d", $signature, $version ) );
}

sub unpack_byte {
    my ($self) = @_;
    $self->read_pos + 1 <= $self->size or die "unpack byte outside of data";
    my $value = $self->bytes->[ $self->read_pos ];
    $self->read_pos( $self->read_pos + 1 );
    return $value;
}

sub unpack_bytes {
    my ( $self, $size ) = @_;
    $self->read_pos + $size <= $self->size
        or die "unpack bytes outside of data";
    my @values =
        @{ $self->bytes }[ $self->read_pos .. $self->read_pos + $size - 1 ];
    $self->read_pos( $self->read_pos + $size );
    return @values;
}

sub unpack_word {
    my ($self) = @_;
    $self->read_pos + 2 <= $self->size or die "unpack word outside of data";
    my $value = $self->bytes->[ $self->read_pos ] |
        ( $self->bytes->[ $self->read_pos + 1 ] << 8 );
    $value -= 0x10000 if $value >= 0x8000;
    $self->read_pos( $self->read_pos + 2 );
    return $value;
}

sub unpack_dword {
    my ($self) = @_;
    $self->read_pos + 4 <= $self->size or die "unpack dword outside of data";
    my $value =
        $self->bytes->[ $self->read_pos ] |
        ( $self->bytes->[ $self->read_pos + 1 ] << 8 ) |
        ( $self->bytes->[ $self->read_pos + 2 ] << 16 ) |
        ( $self->bytes->[ $self->read_pos + 3 ] << 24 );
    $value -= 2**32 if $value >= 0x80000000;
    $self->read_pos( $self->read_pos + 4 );
    return $value;
}

sub unpack_string {
    my ( $self, $size ) = @_;
    my $text = "";
    for ( 1 .. $size ) {
        $text .= chr( $self->unpack_byte );
    }
    return $text;
}

sub unpack_cstring {
    my ($self) = @_;
    my $size   = $self->unpack_byte;
    my $text   = $self->unpack_string($size);
    return $text;
}

sub unpack_lstring {
    my ($self) = @_;
    my $size   = $self->unpack_word;
    my $text   = $self->unpack_string($size);
    return $text;
}

sub unpack_signature {
    my ($self)    = @_;
    my $signature = $self->unpack_string( length($module_signature) );
    my $version   = 0 + $self->unpack_string(2);
    return ( $signature, $version );
}

#------------------------------------------------------------------------------
# String table
#------------------------------------------------------------------------------
package StringTable;

use Modern::Perl;
use Object::Tiny::RW qw( strs index );

sub new {
    my ($class) = @_;
    my $self    = bless { strs => [], index => {} }, $class;
    $self->add("");
    return $self;
}

sub add {
    my ( $self, $str ) = @_;
    if ( exists $self->index->{$str} ) {
        return $self->index->{$str};
    }

    my $index = $self->size;
    push @{ $self->strs }, $str;
    $self->index->{$str} = $index;
    return $index;
}

sub get {
    my ( $self, $index ) = @_;
    return $self->strs->[$index];
}

sub size {
    my ($self) = @_;
    return scalar @{ $self->strs };
}

sub pack {
    my ( $self, $bin ) = @_;

    # build blob and index
    my $blob = "";
    my @pos;
    for my $str ( @{ $self->strs } ) {
        push @pos, length($blob);
        $blob .= $str . "\0";    # string plus null terminator
    }
    while ( length($blob) % 4 != 0 ) {    # align
        $blob .= "\0";
    }

    # pack data
    $bin->pack_dword( $self->size );      # number of strings
    $bin->pack_dword( length($blob) );    # size of blob
    for my $pos (@pos) {
        $bin->pack_dword($pos);           # pos into blob
    }
    $bin->pack_string($blob);             # blob
}

sub unpack {
    my ( $class, $bin ) = @_;

    # unpack data
    my $num_strings = $bin->unpack_dword;    # number of strings
    my $blob_size   = $bin->unpack_dword;    # size of blob
    my @pos;
    for ( 1 .. $num_strings ) {
        push @pos, $bin->unpack_dword;       # pos into blob
    }
    my $blob = $bin->unpack_string($blob_size);    # blob

    # build string table
    my $self = $class->new;
    for my $pos (@pos) {
        my $str = substr( $blob, $pos );
        $str =~ s/\0.*//s;
        $self->add($str);
    }

    return $self;
}

#------------------------------------------------------------------------------
# CPU
#------------------------------------------------------------------------------
package CPU;

use Modern::Perl;
use Path::Tiny;

my @CPUS = parse("../z80asm/cpu.def");

sub parse {
    my ($file) = @_;
    my @cpus;
    for ( path($file)->lines( { chomp => 1 } ) ) {
        next unless /^\s*X\(\s*(\d+)\s*,\s*\w+\s*,\s*"(\w+)"/;
        push @cpus, [ $1, $2 ];
    }
    return @cpus;
}

sub lookup_ {
    my ($key) = @_;
    for (@CPUS) {
        my ( $id, $name ) = @$_;

        if ( $key =~ /^\d+$/ && $key != 8080 && $key != 8085 ) {
            return [ $id, $name ] if $id == $key;
        }
        else {
            return [ $id, $name ] if $name eq $key;
        }
    }
    return undef;
}

sub lookup_id {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[0] : undef;
}

sub lookup_name {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[1] : undef;
}

sub min_id {
    my $id = $CPUS[0]->[0];
    for (@CPUS) {
        $id = $_->[0] if $_->[0] < $id;
    }
    return $id;
}

sub max_id {
    my $id = $CPUS[0]->[0];
    for (@CPUS) {
        $id = $_->[0] if $_->[0] > $id;
    }
    return $id;
}

#------------------------------------------------------------------------------
# Scanner
#------------------------------------------------------------------------------
package Line;

use Modern::Perl;
use Path::Tiny;
use Object::Tiny::RW qw( text file line );

sub new {
    my ( $class, $text, $file, $line ) = @_;
    return bless { text => $text, file => $file, line => $line }, $class;
}

#------------------------------------------------------------------------------
package Scanner;

use Modern::Perl;
use Path::Tiny;
use Object::Tiny::RW qw( lines pos file_ );

sub new {
    my ($class) = @_;
    return bless { lines => [], pos => 0, file_ => "" }, $class;
}

sub scan_file {
    my ( $self, $file ) = @_;
    my @lines = path($file)->lines( { chomp => 1 } );
    for ( 0 .. $#lines ) {
        my $text = $lines[$_];
        $text =~ s/;.*//;
        $text =~ s/^\s+|\s+$//g;
        $lines[$_] = Line->new( $text, $file, $_ + 1 );
    }
    @lines = grep { $_->text =~ /\S/ } @lines;

    $self->lines( \@lines );
    $self->pos(0);
    $self->file_($file);
}

sub end {
    my ($self) = @_;
    return $self->pos >= scalar @{ $self->lines };
}

sub advance {
    my ($self) = @_;
    if ( !$self->end ) {
        $self->{pos}++;
    }
}

sub text {
    my ($self) = @_;
    if ( !$self->end ) {
        return $self->lines->[ $self->pos ]->text;
    }
    else {
        return "";
    }
}

sub file {
    my ($self) = @_;
    if ( !$self->end ) {
        return $self->lines->[ $self->pos ]->file;
    }
    else {
        return $self->file_;
    }
}

sub line {
    my ($self) = @_;
    if ( !$self->end ) {
        return $self->lines->[ $self->pos ]->line;
    }
    else {
        return scalar @{ $self->lines };
    }
}

sub error {
    my ( $self, $message ) = @_;
    die "error at "
        . $self->file
        . " line "
        . $self->line
        . ": $message\n\t"
        . $self->text . "\n";
}

#------------------------------------------------------------------------------
# Context dumper
#------------------------------------------------------------------------------
package ContextDumper;

use Modern::Perl;
use Object::Tiny::RW qw( fh level );

sub new {
    my ( $class, $fh, $level ) = @_;
    return bless { fh => $fh // *STDOUT, level => $level // 0 }, $class;
}

sub child {
    my ($self) = @_;
    return ref($self)->new( $self->fh, $self->level + 1 );
}

sub out {
    my ( $self, $text ) = @_;
    my $fh     = $self->fh;
    my $indent = " " x ( 4 * $self->level );
    say $fh $indent . $text;
}

sub out_kv {
    my ( $self, $key, $value ) = @_;
    my $space = 32 - 4 * $self->level;
    my $text  = sprintf( "%-*s = %s", $space - 3, $key, $value );
    $self->out($text);
}

#------------------------------------------------------------------------------
# ObjExprs
#------------------------------------------------------------------------------
package ObjRangeType;

use Modern::Perl;
use Path::Tiny;

my @RANGE_TYPES = parse("../z80asm/obj_range_type.def");

sub parse {
    my ($file) = @_;
    my @types;
    for ( path($file)->lines( { chomp => 1 } ) ) {
        next unless /^\s*X\(\s*(\d+)\s*,\s*(\w+)\s*,\s*(?:'(.)'|0)/;
        push @types, [ $1, $2, $3 ];
    }
    return @types;
}

sub lookup_ {
    my ($key) = @_;
    for (@RANGE_TYPES) {
        my ( $id, $name, $char ) = @$_;

        if ( $key =~ /^\d+$/ ) {
            return [ $id, $name, $char ] if $id == $key;
        }
        elsif ( $key =~ /^(\D)$/ ) {
            return [ $id, $name, $char ] if defined($char) && $char eq $1;
        }
        else {
            return [ $id, $name, $char ] if $name eq $key;
        }
    }
    return undef;
}

sub lookup_id {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[0] : undef;
}

sub lookup_name {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[1] : undef;
}

sub lookup_char {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[2] : undef;
}

sub min_id {
    my $id = $RANGE_TYPES[0]->[0];
    for (@RANGE_TYPES) {
        $id = $_->[0] if $_->[0] < $id;
    }
    return $id;
}

sub max_id {
    my $id = $RANGE_TYPES[0]->[0];
    for (@RANGE_TYPES) {
        $id = $_->[0] if $_->[0] > $id;
    }
    return $id;
}

#------------------------------------------------------------------------------
package ObjExpr;

use Modern::Perl;
use Object::Tiny::RW qw( type file line section asmpc patch_ptr opcode_size
    target_name text );

sub new {
    my ($class) = @_;
    return bless {
        type        => "Undefined",
        file        => "",
        line        => 0,
        section     => "",
        asmpc       => 0,
        patch_ptr   => 0,
        opcode_size => 0,
        target_name => "",
        text        => "",
    }, $class;
}

sub dump {
    my ( $self, $ctx ) = @_;
    $ctx->out("begin expr");
    my $child = $ctx->child;
    $child->out_kv( "text", "\"" . $self->text . "\"" );
    $child->out_kv( "type",
        $self->type . " ; (" . ObjRangeType::lookup_id( $self->type ) . ")" );
    $child->out_kv( "section",     "\"" . $self->section . "\"" );
    $child->out_kv( "asmpc",       sprintf( "0x%04X", $self->asmpc ) );
    $child->out_kv( "patch_ptr",   sprintf( "0x%04X", $self->patch_ptr ) );
    $child->out_kv( "opcode_size", $self->opcode_size );
    $child->out_kv( "file",        "\"" . $self->file . "\"" ) if $self->file;
    $child->out_kv( "line",        $self->line )               if $self->line;
    $child->out_kv( "target_name", "\"" . $self->target_name . "\"" )
        if $self->target_name;
    $ctx->out("end expr");
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+expr$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+expr$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /type\s*=\s*(.*?)\s*$/ ) {
            my $type = $1;
            $type =~ /^\w+$/ or $scanner->error("invalid type: $type");
            my $type_id = ObjRangeType::lookup_id($type)
                or $scanner->error("invalid type: $type");
            $self->type($type);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /file\s*=\s*\"(.*?)\"\s*$/ ) {
            my $file = $1;
            $self->file($file);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /line\s*=\s*(.*?)\s*$/ ) {
            my $line = eval("($1)+0");
            $@ and $scanner->error("invalid line: $line");
            $line > 0 or $scanner->error("invalid line: $line");
            $self->line($line);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /section\s*=\s*\"(.*?)\"\s*$/ ) {
            my $section = $1;
            $self->section($section);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /asmpc\s*=\s*(.*?)\s*$/ ) {
            my $asmpc = eval("($1)+0");
            $@ and $scanner->error("invalid asmpc: $asmpc");
            $asmpc >= 0 or $scanner->error("invalid asmpc: $asmpc");
            $self->asmpc($asmpc);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /patch_ptr\s*=\s*(.*?)\s*$/ ) {
            my $patch_ptr = eval("($1)+0");
            $@ and $scanner->error("invalid patch_ptr: $patch_ptr");
            $patch_ptr >= 0 or $scanner->error("invalid patch_ptr: $patch_ptr");
            $self->patch_ptr($patch_ptr);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /opcode_size\s*=\s*(.*?)\s*$/ ) {
            my $opcode_size = eval("($1)+0");
            $@ and $scanner->error("invalid opcode_size: $opcode_size");
            $opcode_size >= 0
                or $scanner->error("invalid opcode_size: $opcode_size");
            $self->opcode_size($opcode_size);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /target_name\s*=\s*\"(.*?)\"\s*$/ ) {
            my $target_name = $1;
            $self->target_name($target_name);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /text\s*=\s*\"(.*?)\"\s*$/ ) {
            my $text = $1;
            $self->text($text);
            $scanner->advance;
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end expr");
}

sub pack {
    my ( $self, $bin, $strings, $last_file_ref, $version ) = @_;

    # pack type
    if ( $version >= 18 ) {
        my $id = ObjRangeType::lookup_id( $self->type );
        $bin->pack_dword($id);
    }
    else {
        my $char = ObjRangeType::lookup_char( $self->type );
        die "invalid expression type: " . $self->type unless defined $char;
        my $byte = ord($char);
        $bin->pack_byte($byte);
    }

    # pack filename and line number
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->file );
        $bin->pack_dword($id);
        $bin->pack_dword( $self->line );
    }
    elsif ( $version >= 4 ) {
        if ( $self->file eq $$last_file_ref ) {
            $bin->pack_lstring("");
        }
        else {
            $bin->pack_lstring( $self->file );
        }
        $$last_file_ref = $self->file;
        $bin->pack_dword( $self->line );
    }
    else {
        # no file/line
    }

    # pack section
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->section );
        $bin->pack_dword($id);
    }
    elsif ( $version >= 16 ) {
        $bin->pack_lstring( $self->section );
    }
    elsif ( $version >= 5 ) {
        $bin->pack_cstring( $self->section );
    }
    else {
        # no section
    }

    # pack ASMPC
    if ( $version >= 17 ) {
        $bin->pack_dword( $self->asmpc );
    }
    elsif ( $version >= 3 ) {
        $bin->pack_word( $self->asmpc );
    }
    else {
        # no ASMPC
    }

    # pack patch_ptr
    if ( $version >= 17 ) {
        $bin->pack_dword( $self->patch_ptr );
    }
    else {
        $bin->pack_word( $self->patch_ptr );
    }

    # pack opcode_size
    if ( $version >= 17 ) {
        $bin->pack_dword( $self->opcode_size );
    }
    else {
        # no opcode_size
    }

    # pack target_name
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->target_name );
        $bin->pack_dword($id);
    }
    elsif ( $version >= 16 ) {
        $bin->pack_lstring( $self->target_name );
    }
    elsif ( $version >= 6 ) {
        $bin->pack_cstring( $self->target_name );
    }
    else {
        # no target_name
    }

    # pack text
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->text );
        $bin->pack_dword($id);
    }
    elsif ( $version >= 4 ) {
        $bin->pack_lstring( $self->text );
    }
    else {
        $bin->pack_cstring( $self->text );
        $bin->pack_byte(0);    # terminator
    }
}

sub unpack {
    my ( $class, $bin, $strings, $last_file_ref, $version ) = @_;
    my $self = $class->new;

    # unpack type or end marker
    if ( $version >= 18 ) {
        my $id = $bin->unpack_dword;
        if ( $id == 0 ) {
            return undef;    # end marker
        }
        my $type = ObjRangeType::lookup_name($id);
        $type or die "invalid expression type id: $id";
        $self->type($type);
    }
    else {
        my $byte = $bin->unpack_byte;
        if ( $byte == 0 ) {
            return undef;    # end marker
        }
        my $char = chr($byte);
        my $type = ObjRangeType::lookup_name($char);
        $type or die "invalid expression type char: '$char'";
        $self->type($type);
    }

    # unpack filename and line number
    if ( $version >= 18 ) {
        my $id   = $bin->unpack_dword;
        my $file = $strings->get($id);
        $self->file($file);

        my $line = $bin->unpack_dword;
        $self->line($line);
    }
    elsif ( $version >= 4 ) {
        my $file = $bin->unpack_lstring;
        if ( $file eq "" ) {
            $file = $$last_file_ref;
        }
        else {
            $$last_file_ref = $file;
        }
        $self->file($file);

        my $line = $bin->unpack_dword;
        $self->line($line);
    }
    else {
        # no file/line
    }

    # unpack section
    if ( $version >= 18 ) {
        my $id      = $bin->unpack_dword;
        my $section = $strings->get($id);
        $self->section($section);
    }
    elsif ( $version >= 16 ) {
        my $section = $bin->unpack_lstring;
        $self->section($section);
    }
    elsif ( $version >= 5 ) {
        my $section = $bin->unpack_cstring;
        $self->section($section);
    }
    else {
        # no section
    }

    # unpack ASMPC
    if ( $version >= 17 ) {
        my $asmpc = $bin->unpack_dword;
        $self->asmpc($asmpc);
    }
    elsif ( $version >= 3 ) {
        my $asmpc = $bin->unpack_word;
        $self->asmpc($asmpc);
    }
    else {
        # no ASMPC
    }

    # unpack patch_ptr
    if ( $version >= 17 ) {
        my $patch_ptr = $bin->unpack_dword;
        $self->patch_ptr($patch_ptr);
    }
    else {
        my $patch_ptr = $bin->unpack_word;
        $self->patch_ptr($patch_ptr);
    }

    # unpack opcode_size
    if ( $version >= 17 ) {
        my $opcode_size = $bin->unpack_dword;
        $self->opcode_size($opcode_size);
    }
    else {
        # no opcode_size
    }

    # unpack target_name
    if ( $version >= 18 ) {
        my $id          = $bin->unpack_dword;
        my $target_name = $strings->get($id);
        $self->target_name($target_name);
    }
    elsif ( $version >= 16 ) {
        my $target_name = $bin->unpack_lstring;
        $self->target_name($target_name);
    }
    elsif ( $version >= 6 ) {
        my $target_name = $bin->unpack_cstring;
        $self->target_name($target_name);
    }
    else {
        # no target_name
    }

    # unpack text
    if ( $version >= 18 ) {
        my $id   = $bin->unpack_dword;
        my $text = $strings->get($id);
        $self->text($text);
    }
    elsif ( $version >= 4 ) {
        my $text = $bin->unpack_lstring;
        $self->text($text);
    }
    else {
        my $text = $bin->unpack_cstring;
        $self->text($text);
        my $terminator = $bin->unpack_byte;
        $terminator == 0
            or die "invalid expression text terminator: $terminator";
    }

    return $self;
}

#------------------------------------------------------------------------------
package ObjExprs;

use Modern::Perl;
use Object::Tiny::RW qw( exprs );

sub new {
    my ($class) = @_;
    return bless { exprs => [] }, $class;
}

sub add {
    my ( $self, $expr ) = @_;
    push @{ $self->exprs }, $expr;
}

sub dump {
    my ( $self, $ctx ) = @_;
    if ( @{ $self->exprs } ) {
        $ctx->out("begin exprs");
        my $child = $ctx->child;
        for my $expr ( @{ $self->exprs } ) {
            $expr->dump($child);
        }
        $ctx->out("end exprs");
    }
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+exprs$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+exprs$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( my $expr = ObjExpr->parse($scanner) ) {
            $self->add($expr);
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end exprs");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;
    if ( @{ $self->exprs } ) {
        my $pos       = $bin->size;
        my $last_file = "";

        # pack expressions
        for my $expr ( @{ $self->exprs } ) {
            $expr->pack( $bin, $strings, \$last_file, $version );
        }

        # pack end terminator
        if ( $version >= 18 ) {
            $bin->pack_dword(0);
        }
        elsif ( $version >= 4 ) {
            $bin->pack_byte(0);
        }
        else {
            # no end marker
        }

        return $pos;
    }
    else {
        return -1;
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version, $limit_pos ) = @_;
    my $last_file = "";
    my $self      = $class->new;
    while ( $bin->read_pos < $limit_pos ) {
        if ( my $expr =
            ObjExpr->unpack( $bin, $strings, \$last_file, $version ) )
        {
            $self->add($expr);
        }
        else {
            last;    # end marker
        }
    }
    return $self;
}

#------------------------------------------------------------------------------
# ObjRelocs
#------------------------------------------------------------------------------
package ObjReloc;

use Modern::Perl;
use Object::Tiny::RW qw( type symbol addend section patch_ptr file line );

sub new {
    my ($class) = @_;
    return bless {
        type      => "Undefined",
        symbol    => "",
        addend    => 0,
        section   => "",
        patch_ptr => 0,
        file      => "",
        line      => 0,
    }, $class;
}

sub dump {
    my ( $self, $ctx ) = @_;
    $ctx->out("begin reloc");
    my $child = $ctx->child;
    $child->out_kv( "type",
        $self->type . " ; (" . ObjRangeType::lookup_id( $self->type ) . ")" );
    $child->out_kv( "symbol",    $self->symbol );
    $child->out_kv( "addend",    sprintf( "0x%04X", $self->addend ) );
    $child->out_kv( "section",   "\"" . $self->section . "\"" );
    $child->out_kv( "patch_ptr", sprintf( "0x%04X", $self->patch_ptr ) );
    $child->out_kv( "file",      "\"" . $self->file . "\"" ) if $self->file;
    $child->out_kv( "line",      $self->line )               if $self->line;
    $ctx->out("end reloc");
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+reloc$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+reloc$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /type\s*=\s*(.*?)\s*$/ ) {
            my $type = $1;
            $type =~ /^\w+$/ or $scanner->error("invalid type: $type");
            my $type_id = ObjRangeType::lookup_id($type)
                or $scanner->error("invalid type: $type");
            $self->type($type);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /symbol\s*=\s*(.*?)\s*$/ ) {
            my $symbol = $1;
            $symbol =~ /^\w+$/ or $scanner->error("invalid symbol: $symbol");
            $self->symbol($symbol);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /addend\s*=\s*(.*?)\s*$/ ) {
            my $addend = eval("($1)+0");
            $@ and $scanner->error("invalid addend: $addend");
            $addend >= 0 or $scanner->error("invalid addend: $addend");
            $self->addend($addend);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /section\s*=\s*\"(.*?)\"\s*$/ ) {
            my $section = $1;
            $self->section($section);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /patch_ptr\s*=\s*(.*?)\s*$/ ) {
            my $patch_ptr = eval("($1)+0");
            $@ and $scanner->error("invalid patch_ptr: $patch_ptr");
            $patch_ptr >= 0 or $scanner->error("invalid patch_ptr: $patch_ptr");
            $self->patch_ptr($patch_ptr);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /file\s*=\s*\"(.*?)\"\s*$/ ) {
            my $file = $1;
            $self->file($file);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /line\s*=\s*(.*?)\s*$/ ) {
            my $line = eval("($1)+0");
            $@ and $scanner->error("invalid line: $line");
            $line > 0 or $scanner->error("invalid line: $line");
            $self->line($line);
            $scanner->advance;
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end reloc");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;

    # pack type
    my $id = ObjRangeType::lookup_id( $self->type );
    $bin->pack_dword($id);

    # pack filename and line number
    $id = $strings->add( $self->file );
    $bin->pack_dword($id);
    $bin->pack_dword( $self->line );

    # pack section
    $id = $strings->add( $self->section );
    $bin->pack_dword($id);

    # pack patch_ptr
    $bin->pack_dword( $self->patch_ptr );

    # pack symbol
    $id = $strings->add( $self->symbol );
    $bin->pack_dword($id);

    # pack addend
    $bin->pack_dword( $self->addend );
}

sub unpack {
    my ( $class, $bin, $strings, $version ) = @_;
    my $self = $class->new;

    # unpack type or end marker
    my $id = $bin->unpack_dword;
    if ( $id == 0 ) {
        return undef;    # end marker
    }
    my $type = ObjRangeType::lookup_name($id);
    $type or die "invalid reloc type id: $id";
    $self->type($type);

    # unpack filename and line number
    $id = $bin->unpack_dword;
    my $file = $strings->get($id);
    $self->file($file);

    my $line = $bin->unpack_dword;
    $self->line($line);

    # unpack section
    $id = $bin->unpack_dword;
    my $section = $strings->get($id);
    $self->section($section);

    # unpack patch_ptr
    my $patch_ptr = $bin->unpack_dword;
    $self->patch_ptr($patch_ptr);

    # unpack symbol
    $id = $bin->unpack_dword;
    my $symbol = $strings->get($id);
    $self->symbol($symbol);

    # unpack addend
    my $addend = $bin->unpack_dword;
    $self->addend($addend);

    return $self;
}

#------------------------------------------------------------------------------
package ObjRelocs;

use Modern::Perl;
use Object::Tiny::RW qw( relocs );

sub new {
    my ($class) = @_;
    return bless { relocs => [] }, $class;
}

sub add {
    my ( $self, $reloc ) = @_;
    push @{ $self->relocs }, $reloc;
}

sub dump {
    my ( $self, $ctx ) = @_;
    if ( @{ $self->relocs } ) {
        $ctx->out("begin relocs");
        my $child = $ctx->child;
        for my $reloc ( @{ $self->relocs } ) {
            $reloc->dump($child);
        }
        $ctx->out("end relocs");
    }
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+relocs$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+relocs$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( my $reloc = ObjReloc->parse($scanner) ) {
            $self->add($reloc);
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end relocs");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;
    if ( @{ $self->relocs } ) {
        my $pos = $bin->size;

        # pack relocations
        for my $reloc ( @{ $self->relocs } ) {
            $reloc->pack( $bin, $strings, $version );
        }

        # pack end terminator
        $bin->pack_dword(0);

        return $pos;
    }
    else {
        return -1;
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version ) = @_;
    my $self = $class->new;
    while ( my $reloc = ObjReloc->unpack( $bin, $strings, $version ) ) {
        $self->add($reloc);
    }
    return $self;
}

#------------------------------------------------------------------------------
# ObjSymbols
#------------------------------------------------------------------------------
package ObjSymbolScope;

use Modern::Perl;
use Path::Tiny;

my @SYMBOL_SCOPES = parse("../z80asm/obj_symbol_scope.def");

sub parse {
    my ($file) = @_;
    my @scopes;
    for ( path($file)->lines( { chomp => 1 } ) ) {
        next unless /^\s*X\(\s*(\d+)\s*,\s*(\w+)\s*,\s*(?:'(.)'|0)/;
        push @scopes, [ $1, $2, $3 ];
    }
    return @scopes;
}

sub lookup_ {
    my ($key) = @_;
    for (@SYMBOL_SCOPES) {
        my ( $id, $name, $char ) = @$_;

        if ( $key =~ /^\d+$/ ) {
            return [ $id, $name, $char ] if $id == $key;
        }
        elsif ( $key =~ /^(\D)$/ ) {
            return [ $id, $name, $char ] if defined($char) && $char eq $1;
        }
        else {
            return [ $id, $name, $char ] if $name eq $key;
        }
    }
    return undef;
}

sub lookup_id {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[0] : undef;
}

sub lookup_name {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[1] : undef;
}

sub lookup_char {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[2] : undef;
}

sub min_id {
    my $id = $SYMBOL_SCOPES[0]->[0];
    for (@SYMBOL_SCOPES) {
        $id = $_->[0] if $_->[0] < $id;
    }
    return $id;
}

sub max_id {
    my $id = $SYMBOL_SCOPES[0]->[0];
    for (@SYMBOL_SCOPES) {
        $id = $_->[0] if $_->[0] > $id;
    }
    return $id;
}

#------------------------------------------------------------------------------
package ObjSymbolType;

use Modern::Perl;
use Path::Tiny;

my @SYMBOL_TYPES = parse("../z80asm/obj_symbol_type.def");

sub parse {
    my ($file) = @_;
    my @types;
    for ( path($file)->lines( { chomp => 1 } ) ) {
        next unless /^\s*X\(\s*(\d+)\s*,\s*(\w+)\s*,\s*(?:'(.)'|0)/;
        push @types, [ $1, $2, $3 ];
    }
    return @types;
}

sub lookup_ {
    my ($key) = @_;
    for (@SYMBOL_TYPES) {
        my ( $id, $name, $char ) = @$_;

        if ( $key =~ /^\d+$/ ) {
            return [ $id, $name, $char ] if $id == $key;
        }
        elsif ( $key =~ /^(\D)$/ ) {
            return [ $id, $name, $char ] if defined($char) && $char eq $1;
        }
        else {
            return [ $id, $name, $char ] if $name eq $key;
        }
    }
    return undef;
}

sub lookup_id {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[0] : undef;
}

sub lookup_name {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[1] : undef;
}

sub lookup_char {
    my ($key) = @_;
    my $found = lookup_($key);
    return $found ? $found->[2] : undef;
}

sub min_id {
    my $id = $SYMBOL_TYPES[0]->[0];
    for (@SYMBOL_TYPES) {
        $id = $_->[0] if $_->[0] < $id;
    }
    return $id;
}

sub max_id {
    my $id = $SYMBOL_TYPES[0]->[0];
    for (@SYMBOL_TYPES) {
        $id = $_->[0] if $_->[0] > $id;
    }
    return $id;
}

#------------------------------------------------------------------------------
package ObjSymbol;

use Modern::Perl;
use Object::Tiny::RW qw( scope type section value name file line );

sub new {
    my ($class) = @_;
    return bless {
        scope   => "Undefined",
        type    => "Constant",
        section => "",
        value   => 0,
        name    => "",
        file    => "",
        line    => 0,
    }, $class;
}

sub dump {
    my ( $self, $ctx ) = @_;
    $ctx->out("begin symbol");
    my $child = $ctx->child;
    $child->out_kv( "name", $self->name );
    $child->out_kv( "scope",
              $self->scope . " ; ("
            . ObjSymbolScope::lookup_id( $self->scope )
            . ")" );
    $child->out_kv( "type",
        $self->type . " ; (" . ObjSymbolType::lookup_id( $self->type ) . ")" );
    $child->out_kv( "section", "\"" . $self->section . "\"" );
    $child->out_kv( "value",   sprintf( "0x%04X", $self->value ) );
    $child->out_kv( "file",    "\"" . $self->file . "\"" ) if $self->file;
    $child->out_kv( "line",    $self->line )               if $self->line;
    $ctx->out("end symbol");
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+symbol$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+symbol$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /scope\s*=\s*(.*?)\s*$/ ) {
            my $scope = $1;
            $scope =~ /^\w+$/ or $scanner->error("invalid scope: $scope");
            my $scope_id = ObjSymbolScope::lookup_id($scope)
                or $scanner->error("invalid scope: $scope");
            $self->scope($scope);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /type\s*=\s*(.*?)\s*$/ ) {
            my $type = $1;
            $type =~ /^\w+$/ or $scanner->error("invalid type: $type");
            my $type_id = ObjSymbolType::lookup_id($type)
                or $scanner->error("invalid type: $type");
            $self->type($type);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /section\s*=\s*\"(.*?)\"\s*$/ ) {
            my $section = $1;
            $self->section($section);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /value\s*=\s*(.*?)\s*$/ ) {
            my $value = eval("($1)+0");
            $@ and $scanner->error("invalid value: $value");
            $self->value($value);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /name\s*=\s*(.*?)\s*$/ ) {
            my $name = $1;
            $name =~ /^\w+$/ or $scanner->error("invalid name: $name");
            $self->name($name);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /file\s*=\s*\"(.*?)\"\s*$/ ) {
            my $file = $1;
            $self->file($file);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /line\s*=\s*(.*?)\s*$/ ) {
            my $line = eval("($1)+0");
            $@ and $scanner->error("invalid line: $line");
            $line > 0 or $scanner->error("invalid line: $line");
            $self->line($line);
            $scanner->advance;
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end symbol");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;

    # scope
    if ( $version >= 18 ) {
        my $scope_id = ObjSymbolScope::lookup_id( $self->scope );
        $bin->pack_dword($scope_id);
    }
    else {
        my $char = ObjSymbolScope::lookup_char( $self->scope );
        my $byte = ord($char);
        $bin->pack_byte($byte);
    }

    # type
    if ( $version >= 18 ) {
        my $type_id = ObjSymbolType::lookup_id( $self->type );
        $bin->pack_dword($type_id);
    }
    else {
        my $char = ObjSymbolType::lookup_char( $self->type );
        my $byte = ord($char);
        $bin->pack_byte($byte);
    }

    # section
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->section );
        $bin->pack_dword($id);
    }
    elsif ( $version >= 16 ) {
        $bin->pack_lstring( $self->section );
    }
    elsif ( $version >= 5 ) {
        $bin->pack_cstring( $self->section );
    }
    else {
        # no section
    }

    # value
    $bin->pack_dword( $self->value );

    # name
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->name );
        $bin->pack_dword($id);
    }
    elsif ( $version >= 16 ) {
        $bin->pack_lstring( $self->name );
    }
    else {
        $bin->pack_cstring( $self->name );
    }

    # definition location
    if ( $version >= 18 ) {
        my $id = $strings->add( $self->file );
        $bin->pack_dword($id);
        $bin->pack_dword( $self->line );
    }
    elsif ( $version >= 16 ) {
        $bin->pack_lstring( $self->file );
        $bin->pack_dword( $self->line );
    }
    elsif ( $version >= 9 ) {
        $bin->pack_cstring( $self->file );
        $bin->pack_dword( $self->line );
    }
    else {
        # no file, line
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version ) = @_;
    my $self = $class->new;

    # scope
    if ( $version >= 18 ) {
        my $scope_id = $bin->unpack_dword;
        if ( $scope_id == 0 ) {
            return undef;    # end marker
        }
        my $scope = ObjSymbolScope::lookup_name($scope_id)
            or die "invalid scope: $scope_id";
        $self->scope($scope);
    }
    else {
        my $byte = $bin->unpack_byte;
        if ( $byte == 0 ) {
            return undef;    # end marker
        }
        my $char  = chr($byte);
        my $scope = ObjSymbolScope::lookup_name($char)
            or die "invalid scope: $char";
        $self->scope($scope);
    }

    # type
    if ( $version >= 18 ) {
        my $type_id = $bin->unpack_dword;
        my $type    = ObjSymbolType::lookup_name($type_id)
            or die "invalid type: $type_id";
        $self->type($type);
    }
    else {
        my $byte = $bin->unpack_byte;
        my $char = chr($byte);
        my $type = ObjSymbolType::lookup_name($char)
            or die "invalid type: $char";
        $self->type($type);
    }

    # section
    if ( $version >= 18 ) {
        my $id      = $bin->unpack_dword;
        my $section = $strings->get($id);
        $self->section($section);
    }
    elsif ( $version >= 16 ) {
        my $section = $bin->unpack_lstring;
        $self->section($section);
    }
    elsif ( $version >= 5 ) {
        my $section = $bin->unpack_cstring;
        $self->section($section);
    }
    else {
        # no section
    }

    # value
    my $value = $bin->unpack_dword;
    $self->value($value);

    # name
    if ( $version >= 18 ) {
        my $id   = $bin->unpack_dword;
        my $name = $strings->get($id);
        $self->name($name);
    }
    elsif ( $version >= 16 ) {
        my $name = $bin->unpack_lstring;
        $self->name($name);
    }
    else {
        my $name = $bin->unpack_cstring;
        $self->name($name);
    }

    # definition location
    if ( $version >= 18 ) {
        my $id   = $bin->unpack_dword;
        my $file = $strings->get($id);
        $self->file($file);

        my $line = $bin->unpack_dword;
        $self->line($line);
    }
    elsif ( $version >= 16 ) {
        my $file = $bin->unpack_lstring;
        $self->file($file);

        my $line = $bin->unpack_dword;
        $self->line($line);
    }
    elsif ( $version >= 9 ) {
        my $file = $bin->unpack_cstring;
        $self->file($file);

        my $line = $bin->unpack_dword;
        $self->line($line);
    }
    else {
        # no file, line
    }

    return $self;
}

#------------------------------------------------------------------------------
package ObjSymbols;

use Modern::Perl;
use Object::Tiny::RW qw( symbols );

sub new {
    my ($class) = @_;
    return bless { symbols => [] }, $class;
}

sub add {
    my ( $self, $symbol ) = @_;
    push @{ $self->symbols }, $symbol;
}

sub dump {
    my ( $self, $ctx ) = @_;
    if ( @{ $self->symbols } ) {
        $ctx->out("begin symbols");
        my $child = $ctx->child;
        for my $symbol ( @{ $self->symbols } ) {
            $symbol->dump($child);
        }
        $ctx->out("end symbols");
    }
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+symbols$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+symbols$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( my $symbol = ObjSymbol->parse($scanner) ) {
            $self->add($symbol);
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end symbols");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;
    if ( @{ $self->symbols } ) {
        my $pos = $bin->size;

        # pack symbols
        for my $symbol ( @{ $self->symbols } ) {
            $symbol->pack( $bin, $strings, $version );
        }

        # pack end terminator
        if ( $version >= 18 ) {
            $bin->pack_dword(0);
        }
        elsif ( $version >= 5 ) {
            $bin->pack_byte(0);
        }
        else {
            # no end marker
        }

        return $pos;
    }
    else {
        return -1;
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version, $limit_pos ) = @_;
    my $self = $class->new;
    while ( $bin->read_pos < $limit_pos ) {
        if ( my $symbol = ObjSymbol->unpack( $bin, $strings, $version ) ) {
            push @{ $self->symbols }, $symbol;
        }
        else {
            last;    # end marker
        }
    }
    return $self;
}

#------------------------------------------------------------------------------
# ObjExterns
#------------------------------------------------------------------------------
package ObjExterns;

use Modern::Perl;
use Object::Tiny::RW qw( externs );

sub new {
    my ($class) = @_;
    return bless { externs => [] }, $class;
}

sub add {
    my ( $self, $name ) = @_;
    push @{ $self->externs }, $name;
}

sub dump {
    my ( $self, $ctx ) = @_;
    if ( @{ $self->externs } ) {
        $ctx->out("begin externs");
        my $child = $ctx->child;
        for my $name ( @{ $self->externs } ) {
            $child->out_kv( "name", $name );
        }
        $ctx->out("end externs");
    }
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+externs$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+externs$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /name\s*=\s*(.*?)\s*$/ ) {
            my $name = $1;
            $name =~ /^\w+$/ or $scanner->error("invalid name: $name");
            $self->add($name);
            $scanner->advance;
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end externs");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;

    if ( @{ $self->externs } ) {
        my $pos = $bin->size;

        for my $name ( @{ $self->externs } ) {
            if ( $version >= 18 ) {
                my $id = $strings->add($name);
                $bin->pack_dword($id);
            }
            elsif ( $version >= 16 ) {
                $bin->pack_lstring($name);
            }
            else {
                $bin->pack_cstring($name);
            }
        }

        if ( $version >= 18 ) {
            $bin->pack_dword(0);    # end marker
        }

        return $pos;
    }
    else {
        return -1;
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version, $limit_pos ) = @_;
    my $self = $class->new;
    while ( $bin->read_pos < $limit_pos ) {
        if ( $version >= 18 ) {
            my $id = $bin->unpack_dword;
            if ( $id == 0 ) {
                last;    # end marker
            }
            my $name = $strings->get($id);
            $self->add($name);
        }
        elsif ( $version >= 16 ) {
            my $name = $bin->unpack_lstring;
            $self->add($name);
        }
        else {
            my $name = $bin->unpack_cstring;
            $self->add($name);
        }
    }
    return $self;
}

#------------------------------------------------------------------------------
# ObjSections
#------------------------------------------------------------------------------
package ObjSection;

use Modern::Perl;
use Object::Tiny::RW qw( name org align split bytes );

sub new {
    my ($class) = @_;
    return bless {
        name  => "",
        org   => undef,
        align => 1,
        split => 0,
        bytes => [],
    }, $class;
}

sub dump {
    my ( $self, $ctx ) = @_;
    $ctx->out("begin section");
    my $child = $ctx->child;
    $child->out_kv( "name", "\"" . $self->name . "\"" );
    if ( defined $self->org && !$self->split ) {
        $child->out_kv( "org", sprintf( "0x%04X", $self->org ) );
    }
    $child->out_kv( "align", $self->align );
    $child->out_kv( "split", $self->split );
    if ( @{ $self->bytes } ) {
        $child->out("begin bytes");
        my $grandchild = $child->child;
        for ( my $base = 0 ; $base < scalar @{ $self->bytes } ; $base += 16 ) {
            my $line = "";
            for (
                my $addr = $base ;
                $addr < $base + 16 && $addr < scalar @{ $self->bytes } ;
                $addr++
                )
            {
                $line .= sprintf( "%02X ", $self->bytes->[$addr] );
            }
            $line .= sprintf( "; 0x%04X", $base );
            $grandchild->out($line);
        }
        $child->out("end bytes");
    }
    $ctx->out("end section");
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+section$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+section$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /name\s*=\s*\"(.*?)\"\s*$/ ) {
            my $name = $1;
            $self->name($name);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /org\s*=\s*(.*?)\s*$/ ) {
            my $org = eval("($1)+0");
            $@ and $scanner->error("invalid org: $org");
            $org >= 0 or $scanner->error("invalid org: $org");
            $self->org($org);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /align\s*=\s*(.*?)\s*$/ ) {
            my $align = eval("($1)+0");
            $@ and $scanner->error("invalid align: $align");
            ( $align != 0 ) && ( ( $align & ( $align - 1 ) ) == 0 )
                or $scanner->error("invalid align: $align");
            $self->align($align);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /split\s*=\s*(.*?)\s*$/ ) {
            my $split = eval("($1)+0");
            $@ and $scanner->error("invalid split: $split");
            $split == 0 || $split == 1
                or $scanner->error("invalid split: $split");
            $self->split($split);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /^begin\s+bytes$/ ) {
            $scanner->advance;
            while ( $scanner->text =~ /^[0-9a-fA-F\s]+$/ ) {
                my @bytes = map { hex } split ' ', $scanner->text;
                push @{ $self->bytes }, @bytes;
                $scanner->advance;
            }
            if ( $scanner->text !~ /^end\s+bytes$/ ) {
                $scanner->error("expected end bytes");
            }
            $scanner->advance;
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end section");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;
    if ( $version >= 5 ) {

        # size
        my $size = scalar @{ $self->bytes };
        $bin->pack_dword($size);

        # section name
        if ( $version >= 18 ) {
            my $id = $strings->add( $self->name );
            $bin->pack_dword($id);
        }
        elsif ( $version >= 16 ) {
            $bin->pack_lstring( $self->name );
        }
        else {
            $bin->pack_cstring( $self->name );
        }

        # org
        if ( $version >= 8 ) {
            if ( $self->split ) {
                $bin->pack_dword($org_section_split);
            }
            elsif ( defined $self->org ) {
                $bin->pack_dword( $self->org );
            }
            else {
                $bin->pack_dword($org_not_defined);
            }
        }

        # align
        if ( $version >= 10 ) {
            $bin->pack_dword( $self->align );
        }

        # bytes
        $bin->pack_bytes( @{ $self->bytes } );

        # padding
        if ( $version >= 18 ) {
            my $pad = ( 4 - ( $size % 4 ) ) % 4;
            $bin->pack_bytes( (0) x $pad ) if $pad > 0;
        }
    }
    else {
        my $size = scalar @{ $self->bytes };
        if ( $size > 0x10000 ) {
            die "section size exceeds 64K: $size";
        }
        elsif ( $size == 0 ) {
            die "cannot pack empty section";
        }
        elsif ( $size == 0x10000 ) {
            $bin->pack_word(0);
        }
        else {
            $bin->pack_word($size);
        }
        $bin->pack_bytes( @{ $self->bytes } );
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version ) = @_;
    my $self = $class->new;

    if ( $version >= 5 ) {

        # size
        my $size = $bin->unpack_dword;
        if ( $size < 0 ) {
            return undef;    # end marker
        }

        # section name
        if ( $version >= 18 ) {
            my $id   = $bin->unpack_dword;
            my $name = $strings->get($id);
            $self->name($name);
        }
        elsif ( $version >= 16 ) {
            my $name = $bin->unpack_lstring;
            $self->name($name);
        }
        else {
            my $name = $bin->unpack_cstring;
            $self->name($name);
        }

        # org
        if ( $version >= 8 ) {
            my $org = $bin->unpack_dword;
            if ( $org == $org_section_split ) {
                $self->split(1);
                $self->org(undef);
            }
            elsif ( $org == $org_not_defined ) {
                $self->split(0);
                $self->org(undef);
            }
            else {
                $self->split(0);
                $self->org($org);
            }
        }

        # align
        if ( $version >= 10 ) {
            my $align = $bin->unpack_dword;
            if ( $align < 1 ) {
                $self->align(1);
            }
            else {
                $self->align($align);
            }
        }

        # bytes
        my @bytes = $bin->unpack_bytes($size);
        $self->bytes( \@bytes );

        # padding
        if ( $version >= 18 ) {
            my $pad = ( 4 - ( $size % 4 ) ) % 4;
            $bin->unpack_bytes($pad) if $pad > 0;
        }
    }
    else {
        my $size = $bin->unpack_word;
        if ( $size == 0 ) {
            $size = 0x10000;
        }
        my @bytes = $bin->unpack_bytes($size);
        $self->bytes( \@bytes );
    }

    return $self;
}

#------------------------------------------------------------------------------
package ObjSections;

use Modern::Perl;
use Object::Tiny::RW qw( sections );

sub new {
    my ($class) = @_;
    return bless { sections => [] }, $class;
}

sub add {
    my ( $self, $section ) = @_;
    push @{ $self->sections }, $section;
}

sub dump {
    my ( $self, $ctx ) = @_;
    if ( @{ $self->sections } ) {
        $ctx->out("begin sections");
        my $child = $ctx->child;
        for my $section ( @{ $self->sections } ) {
            $section->dump($child);
        }
        $ctx->out("end sections");
    }
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+sections$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+sections$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( my $section = ObjSection->parse($scanner) ) {
            $self->add($section);
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end sections");
}

sub pack {
    my ( $self, $bin, $strings, $version ) = @_;
    if ( $version >= 5 ) {

        # multiple sections
        if ( @{ $self->sections } ) {
            my $pos = $bin->size;

            # pack sections
            for my $section ( @{ $self->sections } ) {
                $section->pack( $bin, $strings, $version );
            }

            # pack end terminator
            if ( $version >= 5 ) {
                $bin->pack_dword(-1);
            }
            else {
                # no end marker
            }

            return $pos;
        }
        else {
            return -1;
        }
    }
    else {
        # only one section
        if ( @{ $self->sections } == 0 ) {
            return -1;    # no code
        }
        elsif ( @{ $self->sections->[0]->bytes } == 0 ) {
            return -1;    # no code
        }
        else {
            my $pos = $bin->size;
            $self->sections->[0]->pack( $bin, $strings, $version );
            return $pos;
        }
    }
}

sub unpack {
    my ( $class, $bin, $strings, $version ) = @_;
    my $self = $class->new;

    if ( $version >= 5 ) {
        while ( my $section = ObjSection->unpack( $bin, $strings, $version ) ) {
            push @{ $self->sections }, $section;
        }
    }
    else {
        if ( my $section = ObjSection->unpack( $bin, $strings, $version ) ) {
            push @{ $self->sections }, $section;
        }
    }
    return $self;
}

#------------------------------------------------------------------------------
# ObjModule
#------------------------------------------------------------------------------
package ObjModule;

use Modern::Perl;
use Object::Tiny::RW qw(
    version name cpu swap_ixiy org
    exprs relocs symbols externs sections
    strings
);

sub new {
    my ($class) = @_;
    return bless {
        version   => $cur_version,
        name      => "",
        cpu       => "z80",
        swap_ixiy => 0,
        org       => undef,
        exprs     => ObjExprs->new,
        relocs    => ObjRelocs->new,
        symbols   => ObjSymbols->new,
        externs   => ObjExterns->new,
        sections  => ObjSections->new,
        strings   => StringTable->new,
    }, $class;
}

sub dump {
    my ( $self, $ctx ) = @_;
    $ctx->out("begin module");
    my $child = $ctx->child;
    $child->out_kv( "name",    $self->name ) if $self->name;
    $child->out_kv( "version", $self->version );
    if ( $self->version >= 18 ) {
        $child->out_kv( "cpu",
            $self->cpu . " ; (" . CPU::lookup_id( $self->cpu ) . ")" );
        $child->out_kv( "swap_ixiy", $self->swap_ixiy );
    }
    if ( $self->version < 8 ) {
        $child->out_kv( "org", sprintf( "0x%04X", $self->org ) )
            if defined $self->org;
    }
    $self->exprs->dump($child);
    if ( $self->version >= 19 ) {
        $self->relocs->dump($child);
    }
    $self->symbols->dump($child);
    $self->externs->dump($child);
    $self->sections->dump($child);
    $ctx->out("end module");
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+module$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+module$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /version\s*=\s*(.*?)\s*$/ ) {
            my $version = $1;
            $version =~ /^\d+$/ or $scanner->error("invalid version: $version");
            $version >= $min_version && $version <= $cur_version
                or $scanner->error("invalid version: $version");
            $self->version($version);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /name\s*=\s*(.*?)\s*$/ ) {
            my $name = $1;
            $name =~ /^\w+$/ or $scanner->error("invalid name: $name");
            $self->name($name);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /cpu\s*=\s*(.*?)\s*$/ ) {
            my $cpu = $1;
            $cpu =~ /^\w+$/ or $scanner->error("invalid cpu: $cpu");
            my $cpu_name = CPU::lookup_name($cpu)
                or $scanner->error("invalid cpu: $cpu");
            $self->cpu($cpu_name);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /swap_ixiy\s*=\s*(.*?)\s*$/ ) {
            my $swap_ixiy = $1;
            $swap_ixiy =~ /^\d+$/
                or $scanner->error("invalid swap_ixiy: $swap_ixiy");
            $swap_ixiy >= 0 && $swap_ixiy <= 1
                or $scanner->error("invalid swap_ixiy: $swap_ixiy");
            $self->swap_ixiy($swap_ixiy);
            $scanner->advance;
        }
        elsif ( $scanner->text =~ /org\s*=\s*(.*?)\s*$/ ) {
            my $org = eval("($1)+0");
            $@ and $scanner->error("invalid org: $org");
            $org >= 0 or $scanner->error("invalid org: $org");
            $self->org($org);
            $scanner->advance;
        }
        elsif ( my $exprs = ObjExprs->parse($scanner) ) {
            $self->exprs($exprs);
        }
        elsif ( my $relocs = ObjRelocs->parse($scanner) ) {
            $self->relocs($relocs);
        }
        elsif ( my $symbols = ObjSymbols->parse($scanner) ) {
            $self->symbols($symbols);
        }
        elsif ( my $externs = ObjExterns->parse($scanner) ) {
            $self->externs($externs);
        }
        elsif ( my $sections = ObjSections->parse($scanner) ) {
            $self->sections($sections);
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end module");
}

sub pack {
    my ( $self, $bin ) = @_;

    $self->strings( StringTable->new );    # new string table
    my $pos0 = $bin->size;

    # signature
    $bin->pack_signature( $module_signature, $self->version );

    # CPU
    if ( $self->version >= 18 ) {
        $bin->pack_dword( CPU::lookup_id( $self->cpu ) );
        $bin->pack_dword( !!$self->swap_ixiy );
    }

    # global ORG (for old versions)
    if ( $self->version >= 8 ) {

        # org defined at the section level, not the module level
    }
    elsif ( $self->version >= 5 ) {
        $bin->pack_dword( defined $self->org ? $self->org : $org_not_defined );
    }
    else {
        $bin->pack_word( defined $self->org ? $self->org : $org_not_defined );
    }

    # write placeholders for section pointers
    my $header_pos = $bin->size;
    for ( 1 .. 5 ) {
        $bin->pack_dword(-1);
    }

    if ( $self->version >= 19 ) {
        $bin->pack_dword(-1);    # relocs
    }

    if ( $self->version >= 18 ) {
        $bin->pack_dword(-1);    # string table
    }

    # write expressions
    my $exprs_pos = $self->exprs->pack( $bin, $self->strings, $self->version );

    # write relocs
    my $relocs_pos =
        $self->relocs->pack( $bin, $self->strings, $self->version );

    # write symbols
    my $symbols_pos =
        $self->symbols->pack( $bin, $self->strings, $self->version );

    # write externs
    my $externs_pos =
        $self->externs->pack( $bin, $self->strings, $self->version );

    # write module name
    my $modname_pos = $bin->size;
    if ( $self->version >= 18 ) {
        my $id = $self->strings->add( $self->name );
        $bin->pack_dword($id);
    }
    elsif ( $self->version >= 16 ) {
        $bin->pack_lstring( $self->name );
    }
    else {
        $bin->pack_cstring( $self->name );
    }

    # write sections
    my $sections_pos =
        $self->sections->pack( $bin, $self->strings, $self->version );

    # write string table
    my $strings_pos = -1;
    if ( $self->version >= 18 ) {
        $strings_pos = $bin->size;
        $self->strings->pack($bin);
    }

    # write pointers
    my $pos_f = sub { my ($pos) = @_; return $pos < 0 ? $pos : $pos - $pos0; };
    my $patch_pos = $header_pos;

    $bin->patch_dword( $patch_pos, $pos_f->($modname_pos) );
    $patch_pos += 4;

    $bin->patch_dword( $patch_pos, $pos_f->($exprs_pos) );
    $patch_pos += 4;

    if ( $self->version >= 19 ) {
        $bin->patch_dword( $patch_pos, $pos_f->($relocs_pos) );
        $patch_pos += 4;
    }

    $bin->patch_dword( $patch_pos, $pos_f->($symbols_pos) );
    $patch_pos += 4;

    $bin->patch_dword( $patch_pos, $pos_f->($externs_pos) );
    $patch_pos += 4;

    $bin->patch_dword( $patch_pos, $pos_f->($sections_pos) );
    $patch_pos += 4;

    if ( $self->version >= 18 ) {
        $bin->patch_dword( $patch_pos, $pos_f->($strings_pos) );
        $patch_pos += 4;
    }

    return $bin;
}

sub unpack {
    my ( $class, $bin ) = @_;

    my $self = $class->new;
    my $pos0 = $bin->read_pos;

    # signature
    my ( $signature, $version ) = $bin->unpack_signature;

    if ( $signature ne $module_signature ) {
        die "invalid signature: $signature";
    }

    if ( $version < $min_version || $version > $cur_version ) {
        die "invalid version: $version";
    }

    $self->version($version);

    # CPU
    if ( $self->version >= 18 ) {
        my $cpu_id   = $bin->unpack_dword;
        my $cpu_name = CPU::lookup_name($cpu_id) or die "invalid cpu: $cpu_id";
        $self->cpu($cpu_name);

        my $swap_ixiy = $bin->unpack_dword;
        $swap_ixiy == 0 || $swap_ixiy == 1
            or die "invalid swap_ixiy: $swap_ixiy";
        $self->swap_ixiy($swap_ixiy);
    }

    # global ORG (for old versions)
    if ( $self->version >= 8 ) {

        # org defined at the section level, not the module level
    }
    elsif ( $self->version >= 5 ) {
        my $org = $bin->unpack_dword;
        $self->org( $org == $org_not_defined ? undef : $org );
    }
    else {
        my $org = $bin->unpack_word;
        $self->org( $org == $org_not_defined ? undef : $org );
    }

    # read section pointers
    my $modname_pos = $bin->unpack_dword;
    my $exprs_pos   = $bin->unpack_dword;

    my $relocs_pos = -1;
    if ( $self->version >= 19 ) {
        $relocs_pos = $bin->unpack_dword;
    }

    my $symbols_pos  = $bin->unpack_dword;
    my $externs_pos  = $bin->unpack_dword;
    my $sections_pos = $bin->unpack_dword;

    # string table
    if ( $self->version >= 18 ) {
        my $strings_pos = $bin->unpack_dword;
        $bin->read_pos( $strings_pos + $pos0 );
        my $strings = StringTable->unpack($bin);
        $self->strings($strings);
    }

    # module name
    $bin->read_pos( $modname_pos + $pos0 );
    if ( $self->version >= 18 ) {
        my $id   = $bin->unpack_dword;
        my $name = $self->strings->get($id);
        $self->name($name);
    }
    elsif ( $self->version >= 16 ) {
        my $name = $bin->unpack_lstring;
        $self->name($name);
    }
    else {
        my $name = $bin->unpack_cstring;
        $self->name($name);
    }

    # expressions
    if ( $exprs_pos >= 0 ) {
        $bin->read_pos( $exprs_pos + $pos0 );
        my $limit_pos = (
              $symbols_pos >= 0 ? $symbols_pos
            : $externs_pos >= 0 ? $externs_pos
            :                     $modname_pos
            ) +
            $pos0;
        my $exprs = ObjExprs->unpack( $bin, $self->strings,
            $self->version, $limit_pos );
        $self->exprs($exprs);
    }

    # relocations
    if ( $relocs_pos >= 0 ) {
        $bin->read_pos( $relocs_pos + $pos0 );
        my $relocs = ObjRelocs->unpack( $bin, $self->strings, $self->version );
        $self->relocs($relocs);
    }

    # symbols
    if ( $symbols_pos >= 0 ) {
        $bin->read_pos( $symbols_pos + $pos0 );
        my $limit_pos = (
              $externs_pos >= 0
            ? $externs_pos
            : $modname_pos
            ) +
            $pos0;
        my $symbols = ObjSymbols->unpack( $bin, $self->strings,
            $self->version, $limit_pos );
        $self->symbols($symbols);
    }

    # externs
    if ( $externs_pos >= 0 ) {
        $bin->read_pos( $externs_pos + $pos0 );
        my $limit_pos = $modname_pos + $pos0;
        my $externs   = ObjExterns->unpack( $bin, $self->strings,
            $self->version, $limit_pos );
        $self->externs($externs);
    }

    # sections
    if ( $sections_pos >= 0 ) {
        $bin->read_pos( $sections_pos + $pos0 );
        my $sections =
            ObjSections->unpack( $bin, $self->strings, $self->version );
        $self->sections($sections);
    }

    return $self;
}

#------------------------------------------------------------------------------
# ObjLibrary
#------------------------------------------------------------------------------
package ObjLibrary;

use Modern::Perl;
use Object::Tiny::RW qw( version modules strings );

sub new {
    my ($class) = @_;
    return bless {
        version => $cur_version,
        modules => [],
        strings => StringTable->new,
    }, $class;
}

sub add {
    my ( $self, $module ) = @_;
    push @{ $self->modules }, $module;
}

sub dump {
    my ( $self, $ctx ) = @_;
    $ctx->out("begin library");
    my $child = $ctx->child;
    $child->out_kv( "version", $self->version );
    for my $module ( @{ $self->modules } ) {
        $module->dump($child);
    }
    $ctx->out("end library");
}

sub parse {
    my ( $class, $scanner ) = @_;

    if ( $scanner->text !~ /^begin\s+library$/ ) {
        return undef;
    }

    $scanner->advance;
    my $self = $class->new;
    while ( !$scanner->end ) {
        if ( $scanner->text =~ /^end\s+library$/ ) {
            $scanner->advance;
            return $self;
        }
        elsif ( $scanner->text =~ /version\s*=\s*(.*?)\s*$/ ) {
            my $version = $1;
            $version =~ /^\d+$/ or $scanner->error("invalid version: $version");
            $version >= $min_version && $version <= $cur_version
                or $scanner->error("invalid version: $version");
            $self->version($version);
            $scanner->advance;
        }
        elsif ( my $module = ObjModule->parse($scanner) ) {
            $self->add($module);
        }
        else {
            $scanner->error("cannot parse");
        }
    }
    $scanner->error("expected end library");
}

sub pack {
    my ( $self, $bin ) = @_;

    $self->strings( StringTable->new );    # new string table

    # signature
    $bin->pack_signature( $library_signature, $self->version );

    # pointers
    my $header_pos = $bin->size;
    if ( $self->version >= 18 ) {
        $bin->pack_dword(-1);    # placeholder for string table
    }

    # list of modules
    if ( @{ $self->modules } == 0 ) {    # empty module list
        $bin->pack_dword(-1);            # signal this is the last module
        $bin->pack_dword( 0);            # signal this is deleted
    }
    else {
        my $next_module_pos;
        for my $module ( @{ $self->modules } ) {
            $next_module_pos = $bin->size;
            $bin->pack_dword(0);    # placeholder for next module
            $bin->pack_dword(0);    # placeholder for this module size

            my $module_start = $bin->size;
            $module->pack($bin);
            my $module_end = $bin->size;

            my $module_size = $module_end - $module_start;

            # patch placeholders
            $bin->patch_dword( $next_module_pos + 0 * 4, $bin->size );
            $bin->patch_dword( $next_module_pos + 1 * 4, $module_size );
        }

        # mark end of list
        $next_module_pos or die;
        $bin->patch_dword( $next_module_pos, -1 );    # end marker
    }

    # library index
    if ( $self->version >= 18 ) {

        # list of all public symbols of all modules
        for my $module ( @{ $self->modules } ) {
            for my $symbol ( @{ $module->symbols->symbols } ) {
                if ( $symbol->scope eq "Public" ) {
                    $self->strings->add( $symbol->name );
                }
            }
        }
    }

    # string table
    if ( $self->version >= 18 ) {
        my $strings_pos = $bin->size;
        $self->strings->pack($bin);
        $bin->patch_dword( $header_pos + 0 * 4, $strings_pos );
    }
}

sub unpack {
    my ( $class, $bin ) = @_;

    my $self = $class->new;

    # signature
    my ( $signature, $version ) = $bin->unpack_signature;

    if ( $signature ne $library_signature ) {
        die "invalid signature: $signature";
    }

    if ( $version < $min_version || $version > $cur_version ) {
        die "invalid version: $version";
    }

    $self->version($version);

    # get string table
    if ( $self->version >= 18 ) {
        my $strings_pos = $bin->unpack_dword;
        my $save_pos    = $bin->read_pos;
        $bin->read_pos($strings_pos);
        my $strings = StringTable->unpack($bin);
        $self->strings($strings);
        $bin->read_pos($save_pos);
    }

    # get modules
    my $next_module_pos = $bin->read_pos;
    while ( $next_module_pos >= 0 ) {
        $next_module_pos = $bin->unpack_dword;
        my $size = $bin->unpack_dword;
        if ( $size > 0 ) {    # not deleted
            my $module = ObjModule->unpack($bin);
            $self->add($module);
        }

        if ( $next_module_pos < 0 ) {
            last;             # end marker
        }
        else {
            $bin->read_pos($next_module_pos);
        }
    }

    return $self;
}

#------------------------------------------------------------------------------
# Obj - read either a ObjModule or ObjLibrary
#------------------------------------------------------------------------------
package Obj;

use Modern::Perl;

sub min_version { return $min_version; }
sub cur_version { return $cur_version; }

sub parse {
    my ( $class, $scanner ) = @_;

    if ( my $library = ObjLibrary->parse($scanner) ) {
        return $library;
    }
    elsif ( my $module = ObjModule->parse($scanner) ) {
        return $module;
    }
    else {
        $scanner->error("cannot parse");
    }
}

sub unpack {
    my ( $class, $bin ) = @_;

    my $pos0 = $bin->read_pos;
    my ( $signature, $version ) = $bin->unpack_signature;
    $bin->read_pos($pos0);

    if ( $version < $min_version || $version > $cur_version ) {
        die "invalid version: $version";
    }

    if ( $signature eq $module_signature ) {
        return ObjModule->unpack($bin);
    }
    elsif ( $signature eq $library_signature ) {
        return ObjLibrary->unpack($bin);
    }
    else {
        die "invalid signature: $signature";
    }
}

1;
