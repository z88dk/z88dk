#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use lib path($0)->parent->stringify;
use ObjModule;
use Getopt::Long;

my $progname    = path($0)->basename;
my $min_version = Obj::min_version;
my $max_version = Obj::max_version;
my $version     = Obj::cur_version;
my $USAGE       = <<END;
Usage: $progname [options] <input-file|-> [<output-file|->]

Read a Z80 object file or text dump and display its contents. If an
output file is supplied, write the object or dump to that file. This
can be used to convert between versions or formats, or to extract to
a text dump, edit it, and convert back.

Input format detection:
  If --in-format is not specified, the format is inferred from the
  file extension or magic bytes. If the input is '-', the format is
  assumed to be 'dump'.

Output format detection:
  If --out-format is not specified, the format is inferred from the
  output file extension. If the output is '-', the format is assumed
  to be 'dump'.

Formats:
  obj   - Z80 object file (binary .o or .lib)
  dump  - text dump (ASCII .def)

Options:
  --in-format F     Set input format (obj|dump|auto)
  --out-format F    Set output format (obj|dump|auto)
  -v N, --version N Set output object file version $min_version..$max_version (default $version)
  -h, --help        Show this help message

Notes:
  - Binary 'obj' format cannot be read from stdin or written to stdout.
  - Use '-' for stdin/stdout only with the 'dump' format.
END

# get options
my $in_format  = 'auto';
my $out_format = 'auto';
GetOptions(
    'in-format=s'  => \$in_format,
    'out-format=s' => \$out_format,
    'version|v=i'  => \$version,
    'help|h'       => sub { say $USAGE; exit 0 },
) or die $USAGE;

# version
if ( defined $version
    && ( $version < Obj::min_version || $version > Obj::max_version ) )
{
    die "invalid version $version\n";
}

# input format
if ( $in_format !~ /^(obj|dump|auto)$/ ) {
    die "invalid input format: $in_format\n";
}

# output format
if ( $out_format !~ /^(obj|dump|auto)$/ ) {
    die "invalid output format: $out_format\n";
}

# get input file
my $input_file = shift @ARGV             or die $USAGE;
( $input_file eq '-' || -f $input_file ) or die "file not found: $input_file\n";

# get optional output file
my $output_file = shift @ARGV;

@ARGV == 0 or die "too many arguments\n$USAGE";

# detect input format if auto
if ( $in_format eq 'auto' ) {
    if ( $input_file =~ /\.o$|\.lib$/ ) {
        $in_format = 'obj';
    }
    elsif ( $input_file eq '-' || $input_file =~ /\.def$/ ) {
        $in_format = 'dump';
    }
    else {
        # try to detect by magic bytes
        my $magic = Obj->peek_magic($input_file);
        if ( !defined $magic ) {
            die "cannot detect input format for $input_file\n";
        }
        $in_format = 'obj';
    }
}

# detect output format if auto
if ( $out_format eq 'auto' ) {
    if ( defined $output_file ) {
        if ( $output_file =~ /\.o$|\.lib$/ ) {
            $out_format = 'obj';
        }
        elsif ( $output_file eq '-' || $output_file =~ /\.def$/ ) {
            $out_format = 'dump';
        }
        else {
            die "cannot detect output format for $output_file\n";
        }
    }
    else {
        # default to dump if no output file is specified
        $out_format = 'dump';
    }
}

# read input file
my $obj;
if ( $in_format eq 'obj' ) {
    if ( $input_file eq '-' ) {
        die "cannot read binary object file from stdin\n";
    }
    my $bin = BinData->new;
    $bin->data( path($input_file)->slurp_raw );
    $obj = Obj->unpack($bin);
}
elsif ( $in_format eq 'dump' ) {
    my $scanner = Scanner->new;
    if ( $input_file eq '-' ) {
        $scanner->scan_fh( \*STDIN );
    }
    else {
        $scanner->scan_file($input_file);
    }
    $obj = Obj->parse($scanner);
}
else {
    die "invalid input format: $in_format\n";
}

# update version
if ( defined $version ) {
    $obj->version($version);
    if ( $obj->can('modules') ) {
        for my $module ( @{ $obj->modules } ) {
            $module->version($version);
        }
    }
}

# write output file
if ( $out_format eq 'obj' ) {
    if ( !defined $output_file || $output_file eq '-' ) {
        die "cannot write binary object file to stdout\n";
    }
    my $bin = BinData->new;
    $obj->pack($bin);
    path($output_file)->spew_raw( $bin->data );
}
elsif ( $out_format eq 'dump' ) {
    my $fh;
    if ( defined $output_file && $output_file ne '-' ) {
        open $fh, '>', $output_file or die "cannot open $output_file: $!\n";
    }
    else {
        $fh = \*STDOUT;
    }
    my $ctx = ContextDumper->new($fh);
    $obj->dump($ctx);
}
else {
    die "invalid output format: $out_format\n";
}
