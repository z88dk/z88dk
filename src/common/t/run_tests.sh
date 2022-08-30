#!/bin/bash

set +e        # allow tests to fail without aborting make test

fail=0
nr=0
for t in $( cat t/test1.hh | sed -e 's/^[^"]*"//' -e 's/".*//'); do
	f=t/test.$t.out
	if [ ! -f $f ] ; then
		touch $f
	fi
	
	nr=$[$nr+1]
	t/test $t > $f.mine.stdout 2> $f.mine.stderr
	rv=$?
	(echo stdout: ; cat $f.mine.stdout ; echo stderr: ; cat $f.mine.stderr ; echo exit: $rv ) > $f.mine
	
	if diff -q -w $f $f.mine ; then
		echo ok $nr, $t
	else
		echo not ok $nr, $t
		echo \# test $nr: t/test $t \> $f.mine
		if [ "$DIFF" != "" ] ; then
			$DIFF -w $f $f.mine &
		else
			diff -w $f $f.mine | sed -e 's/^/\# /'
		fi
		fail=$[$fail+1]
	fi
done

echo 1..$nr
if [ $fail = 0 ] ; then
	echo OK
	rm -f t/*.bak t/*.out.mine* test.*
	exit 0
else
	echo \# Looks like you failed $fail test of $nr.
	exit 1
fi
