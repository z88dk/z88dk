#!/bin/sh

(for f in t/*.t ; do time prove $f ; done) 2>&1 | \
perl -nE 'if (/^(t\/\S+)/) { $file=$1; } if (/^real\s+(\S+)/) { $time=$1; say "$time\t$file"; }' | sort
