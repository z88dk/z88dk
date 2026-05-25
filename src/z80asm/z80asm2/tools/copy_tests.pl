#!/usr/bin/env perl

use Modern::Perl;
use Path::Tiny;

@ARGV == 2 or die "usage: $0 from_text to_text\n";
my ( $from_text, $to_text ) = @ARGV;

my ($dir) = path("t");
my $iter = $dir->iterator( { recurse => 1 } );
while ( my $next = $iter->() ) {
    next if $next =~ /\.bak$/;
    if ( $next =~ /$from_text/ ) {
        my $new = path( $next =~ s/$from_text/$to_text/gr );
        if ( -f $new ) {
            die "error: $new exists\n";
        }
        say $new;
        $new->parent->mkdir;
        my $content = $next->slurp_raw;
        $content =~ s/$from_text/$to_text/g;
        $new->spew_raw($content);
    }
}
