#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use lib '.';
use ObjModule;

for my $v (Obj->min_version+1 .. Obj->cur_version) {
    my $old = sprintf "%02d", $v-1;
    my $new = sprintf "%02d", $v;
    system( "start \"\" WinMergeU.exe " . 
            path($0)->parent->child("obj_v$old.txt") . " " .
            path($0)->parent->child("obj_v$new.txt")
    );
}
