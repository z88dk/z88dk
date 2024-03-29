divert(-1)

###################################################################
# SET APPROPRIATE FUNCTION LINKAGE DEPENDING ON THE ACTIVE COMPILER
###################################################################

# define(`m4_SCCZ80_NOLIB', 1)   - disables __LIB__ in sccz80 prototypes
# undefine(`m4_SCCZ80_NOLIB')    - restores __LIB__ in sccz80 prototypes

undefine(`__DPROTO')
undefine(`__D2PROTO')
undefine(`__OPROTO')
undefine(`__VPROTO')

# DECORATED PROTOTYPES (FASTCALL & CALLEE)

define(`__DPROTO', `ifdef(`m4_SDCC',dnl
`ifelse(eval($# == 6),1,dnl
dnl
ifelse(`$2',,dnl
extern `$3' `$4'```$5'''`'(`$6');
,dnl
extern `$3' `$4'```$5'''`'(`$6') __preserves_regs(`$2');
)dnl
ifelse(`$1',,dnl
extern `$3' `$4'```$5'''_fastcall`'(`$6') __z88dk_fastcall;
,dnl
extern `$3' `$4'``$5''_fastcall`'(`$6') __preserves_regs(`$1') __z88dk_fastcall;
)dnl
`#define' `$5'`'(a) `$5'_fastcall`'(a)

,dnl
ifelse(`$2',,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))');
,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))') __preserves_regs(`$2');
)dnl
ifelse(`$1',,dnl
extern `$3' `$4'```$5'''_callee`'(`shift(shift(shift(shift(shift($@)))))') __z88dk_callee;
,dnl
extern `$3' `$4'```$5'''_callee`'(`shift(shift(shift(shift(shift($@)))))') __preserves_regs(`$1') __z88dk_callee;
)dnl
`#define' `$5'`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11))) `$5'_callee`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11)))

)',`ifdef(`m4_SCCZ80',dnl
dnl
`ifelse(eval($# == 6),1,dnl
dnl
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''`'(`$6') __smallc __z88dk_fastcall;

,dnl
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))') __smallc;
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''_callee`'(`shift(shift(shift(shift(shift($@)))))') __smallc __z88dk_callee;
`#define' `$5'`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11))) `$5'_callee`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11)))

)',dnl
extern `$3' `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))');

)')')

# DECORATED PROTOTYPES (FASTCALL & CALLEE) - sccz80 uses fastcall bridge

define(`__D2PROTO', `ifdef(`m4_SDCC',dnl
`ifelse(eval($# == 6),1,dnl
dnl
ifelse(`$2',,dnl
extern `$3' `$4'```$5'''`'(`$6');
,dnl
extern `$3' `$4'```$5'''`'(`$6') __preserves_regs(`$2');
)dnl
ifelse(`$1',,dnl
extern `$3' `$4'```$5'''_fastcall`'(`$6') __z88dk_fastcall;
,dnl
extern `$3' `$4'``$5''_fastcall`'(`$6') __preserves_regs(`$1') __z88dk_fastcall;
)dnl
`#define' `$5'`'(a) `$5'_fastcall`'(a)

,dnl
ifelse(`$2',,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))');
,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))') __preserves_regs(`$2');
)dnl
ifelse(`$1',,dnl
extern `$3' `$4'```$5'''_callee`'(`shift(shift(shift(shift(shift($@)))))') __z88dk_callee;
,dnl
extern `$3' `$4'```$5'''_callee`'(`shift(shift(shift(shift(shift($@)))))') __preserves_regs(`$1') __z88dk_callee;
)dnl
`#define' `$5'`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11))) `$5'_callee`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11)))

)',`ifdef(`m4_SCCZ80',dnl
dnl
`ifelse(eval($# == 6),1,dnl
dnl
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''`'(`$6') __smallc ;
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'`$5'_fastcall`'(`$6') __z88dk_fastcall;
`#define' `$5'`'(a) `$5'_fastcall`'(a)

,dnl
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))') __smallc;
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''_callee`'(`shift(shift(shift(shift(shift($@)))))') __smallc __z88dk_callee;
`#define' `$5'`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11))) `$5'_callee`'(substr(`a,b,c,d,e,f,g,h,i,j',0,eval($#+$#-11)))

)',dnl
extern `$3' `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))');

)')')



# ORDINARY PROTOTYPES (UNEMBELLISHED)

define(`__OPROTO', `ifdef(`m4_SDCC',dnl
ifelse(`$2',,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))');
,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))') __preserves_regs(`$2');
)dnl
,dnl
`ifdef(`m4_SCCZ80',dnl
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))') __smallc;

,dnl
extern `$3' `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))');

)')')


# VARARG PROTOTYPES

define(`__VPROTO', `ifdef(`m4_SDCC',dnl
ifelse(`$2',,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))');
,dnl
extern `$3' `$4'```$5'''`'(`shift(shift(shift(shift(shift($@)))))') __preserves_regs(`$2');
)dnl

,`ifdef(`m4_SCCZ80',dnl
extern `$3' ifdef(`m4_SCCZ80_NOLIB',,__LIB__) `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))') __smallc;

,dnl
extern `$3' `$4'``$5''`'(`shift(shift(shift(shift(shift($@)))))');

)')')


###################################################################

divert(0)
// automatically generated by m4 from headers in proto subdir
