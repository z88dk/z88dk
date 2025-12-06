#!/usr/bin/perl

local $/;
$_ = <>;

s{^(\s*tl\w+)\.push_back}{$1.tokens().push_back}gm;

print $_
