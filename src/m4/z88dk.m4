divert(`-1')

# Z88DK_FORARG(FROM, TO, MACRO)
# Invoke MACRO(VALUE) for each VALUE from FROM to TO.

define(`Z88DK_FORARG', `ifelse(eval(`($1) <= ($2)'), `1',
   `_Z88DK_FOR(`$1', eval(`$2'), `$3(', `)')')')

# Z88DK_FOR(VAR, FROM, TO, STMT)
# Output STMT for VAR varying from FROM to TO.

define(`Z88DK_FOR', `ifelse(eval(`($2) <= ($3)'), `1',
   `pushdef(`$1')_Z88DK_FOR(eval(`$2'), eval(`$3'),
      `define(`$1',', `)$4')popdef(`$1')')')

define(`_Z88DK_FOR',
   `$3`$1'$4`'ifelse(`$1', `$2', `',
      `$0(incr(`$1'), `$2', `$3', `$4')')')

# Z88DK_FOREACH(VAR, (ITEM_1, ITEM_2, ..., ITEM_n), STMT)
# Iterate over ITEMs in parenthesized list, output STMT for each ITEM.

define(`Z88DK_FOREACH', `pushdef(`$1')_$0(`$1',
   (dquote(dquote_elt$2)), `$3')popdef(`$1')')

define(`_Z88DK_ARG1', `$1')

define(`_Z88DK_FOREACH', `ifelse(`$2', `(`')', `',
   `define(`$1', _Z88DK_ARG1$2)$3`'$0(`$1', (dquote(shift$2)), `$3')')')

# Z88DK_FOREACHQ(VAR, `ITEM_1, ITEM_2, ..., ITEM_N', STMT)
# Iterate over ITEMs in quoted list, output STMT for each ITEM.

define(`Z88DK_FOREACHQ',
   `ifelse(`$2', `', `', `_$0(`$1', `$3', $2)')')

define(`_Z88DK_FOREACHQ',
   `pushdef(`$1', Z88DK_FOR(`$1', `3', `$#',
      `$0_(`1', `2', indir(`$1'))')`popdef(
         `$1')')indir(`$1', $@)')

define(`_Z88DK_FOREACHQ_',
   ``define(`$$1', `$$3')$$2`''')

# Z88DK_ULBL([PREFIX])
# Generate a label unique to the file using optional PREFIX

define(`Z88DK_ULBL', `define(`_Z88DK_UNIQ_ID_$1', ifdef(`_Z88DK_UNIQ_ID_$1', `incr(_Z88DK_UNIQ_ID_$1)', 0))dnl
ifelse($1,, __uniq_, $1_)`'eval(_Z88DK_UNIQ_ID_$1, 10, 4)')

# Z88DK_CLBL([OFFSET][,PREFIX])
# Generate the label with optional numerical OFFSET from the
# last generated unique label with optional PREFIX

define(`Z88DK_CLBL', `define(`_Z88DK_UNIQ_ID_$2', ifdef(`_Z88DK_UNIQ_ID_$2', _Z88DK_UNIQ_ID_$2, 0))dnl
ifelse($2,, __uniq_, $2_)`'ifelse($1,, eval(_Z88DK_UNIQ_ID_$2, 10, 4), `eval(_Z88DK_UNIQ_ID_$2 + $1, 10, 4)')')

divert`'dnl
