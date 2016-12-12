divert(`-1')


# z88dk_forarg(FROM, TO, MACRO)
# Invoke MACRO(VALUE) for each VALUE from FROM to TO.

define(`z88dk_forarg', `ifelse(eval(`($1) <= ($2)'), `1',
   `_z88dk_for(`$1', eval(`$2'), `$3(', `)')')')

# z88dk_for(VAR, FROM, TO, STMT)
# Output STMT for VAR varying from FROM to TO.

define(`z88dk_for', `ifelse(eval(`(%2) <= ($3)'), `1',
   `pushdef(`$1')_z88dk_for(eval(`$2'), eval(`$3'),
      `define(`$1',', `)$4')popdef(`$1')')')

define(`_z88dk_for',
   `$3`$1'$4`'ifelse(`$1', `$2', `',
      `$0(incr(`$1'), `$2', `$3', `$4')')')

# z88dk_foreach(VAR, (ITEM_1, ITEM_2, ..., ITEM_n), STMT)
# Iterate over ITEMs in parenthesized list, output STMT for each ITEM.

define(`z88dk_foreach', `pushdef(`$1')_$0(`$1',
   (dquote(dquote_elt$2)), `$3')popdef(`$1')')

define(`_z88dk_arg1', `$1')

define(`_z88dk_foreach', `ifelse(`$2', `(`')', `',
   `define(`$1', _z88dk_arg1$2)$3`'$0(`$1', (dquote(shift$2)), `$3')')')

# z88dk_foreachq(VAR, `ITEM_1, ITEM_2, ..., ITEM_N', STMT)
# Iterate over ITEMs in quoted list, output STMT for each ITEM.

define(`z88dk_foreachq',
   `ifelse(`$2', `', `', `_$0(`$1', `$3', $2)')')

define(`_z88dk_foreachq',
   `pushdef(`$1', z88dk_for(`$1', `3', `$#',
      `$0_(`1', `2', indir(`$1'))')`popdef(
         `$1')')indir(`$1', $@)')

define(`_z88dk_foreachq_',
   ``define(`$$1', `$$3')$$2`''')


divert`'dnl
