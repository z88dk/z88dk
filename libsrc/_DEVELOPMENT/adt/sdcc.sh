

for file in `ls */c/sccz80/*.asm`; do
modulename=`basename $file | sed s,.asm,,g`
cat >> $file << EOD

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _${modulename}
defc _${modulename} = $modulename
ENDIF

EOD
done
