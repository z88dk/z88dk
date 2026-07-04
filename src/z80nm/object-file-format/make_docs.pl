#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use lib '.';
use ObjModule;

Obj->make_docs(path($0)->parent);

if ($ENV{DEBUG}) {
    for my $v (Obj->min_version .. Obj->cur_version) {
        my $version = sprintf "%02d", $v;
        system( "start \"\" WinMergeU.exe " . 
                path($0)->parent->child("to-reconstruct")->child("v$version.txt") . " " .
                path($0)->parent->child("obj_v$version.txt")
        );
    }
}
