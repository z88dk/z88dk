#!/bin/sh

# Z88DK Z80 Macro Assembler

#set -x
tests_log=t/tests.log
rm -f $tests_log

# run my tests
for i in t/test_* ; do
    if test -f $i -a -x $i ; then
		out=`dirname $i`/`basename $i .exe`.out
		echo "" >> $tests_log
		echo "---------- $i ----------" >> $tests_log
		echo "" >> $tests_log
		if ./$i 2>> $tests_log ; then
			echo $i PASSED
		else
			echo "ERROR in test $i, $tests_log:"
			echo "--------------------"
			tail $tests_log
#			if test -f $out ; then
#				cat $out
#			fi
			exit 1
		fi
	fi
done

# run uthash tests
pushd t/uthash
	for i in test*; do
		if test -f $i -a -x $i ; then
			ans=`basename $i .exe`.ans
			out=`basename $i .exe`.out
			./$i > $out
			if diff -w $out $ans ; then
				echo $i PASSED
			else
				echo "ERROR in test $i"
				echo "--------------------"
				cat $out
				exit 1
			fi
		fi
	done
popd
echo ""
