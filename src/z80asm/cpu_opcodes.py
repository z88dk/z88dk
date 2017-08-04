#!python

#------------------------------------------------------------------------------
# Prefix
#------------------------------------------------------------------------------
P_IX = '(opts.swap_ix_iy ? 0xFD00 : 0xDD00)'
P_IY = '(opts.swap_ix_iy ? 0xDD00 : 0xFD00)'

RABBIT_P_HL = '0xDD00'
RABBIT_P_IX = '(opts.swap_ix_iy ? 0xFD00 : 0     )'
RABBIT_P_IY = '(opts.swap_ix_iy ? 0      : 0xFD00)'

#------------------------------------------------------------------------------
# Tokens
#------------------------------------------------------------------------------
class Token:
	"""Define an assembly token"""
	def __init__(self, n, asm, tok, prefix):
		self.n		= n
		self.asm	= asm
		self.tok	= tok
		self.prefix	= prefix

ALTD	= Token(0,		"altd",	"_TK_ALTD",		0x76)
COMMA	= Token(0,		",",	"_TK_COMMA",	0)
RPAREN	= Token(0,		")",	"_TK_RPAREN",	0)
LD		= Token(0,		"ld",	"_TK_LD",		0)
NEWLINE = Token(0,		"",		"_TK_NEWLINE",	0)
	
ADD		= Token(0,		"add",	"_TK_ADD",		0)
ADC		= Token(1,		"adc",	"_TK_ADC",		0)
SUB		= Token(2,		"sub",	"_TK_SUB",		0)
SBC		= Token(3,		"sbc",	"_TK_SBC",		0)
AND		= Token(4,		"and",	"_TK_AND",		0)
XOR		= Token(5,		"xor",	"_TK_XOR",		0)
OR		= Token(6,		"or",	"_TK_OR",		0)
CP		= Token(7,		"cp",	"_TK_CP",		0)
	
INC		= Token(0,		"inc",	"_TK_INC",		0)
DEC		= Token(1,		"dec",	"_TK_DEC",		0)

TST		= Token(0,		"tst",	"_TK_TST",		0)

CCF		= Token(0x3F,	"ccf",	"_TK_CCF",		0)
CPL		= Token(0x2F,	"cpl",	"_TK_CPL",		0)
DAA		= Token(0x27,	"daa",	"_TK_DAA",		0)
NEG		= Token(0x44,	"neg",	"_TK_NEG",		0)
RLD		= Token(0x6F,	"rld",	"_TK_RLD",		0)
RRD		= Token(0x67,	"rrd",	"_TK_RRD",		0)
SCF		= Token(0x37,	"scf",	"_TK_SCF",		0)

PUSH	= Token(0,		"push",	"_TK_PUSH",		0)	
POP		= Token(0,		"pop",	"_TK_POP",		0)	

expr	= Token(0,		"",		"expr",			0)
	
B		= Token(0,		"b",	"_TK_B",		0); B.ix = B; B.iy = B
C		= Token(1,		"c",	"_TK_C",		0); C.ix = C; C.iy = C
D		= Token(2,		"d",	"_TK_D",		0); D.ix = D; D.iy = D
E		= Token(3,		"e",	"_TK_E",		0); E.ix = E; E.iy = E
H		= Token(4,		"h",	"_TK_H",		0); H.ix = H; H.iy = H
L		= Token(5,		"l",	"_TK_L",		0); L.ix = L; L.iy = L
A		= Token(7,		"a",	"_TK_A",		0); A.ix = A; A.iy = A
F		= Token(0,		"f",	"_TK_F",		0); F.ix = F; F.iy = F
	
B1		= Token(0,		"b'",	"_TK_B1",		0x76); B.alt = B1
C1		= Token(1,		"c'",	"_TK_C1",		0x76); C.alt = C1
D1		= Token(2,		"d'",	"_TK_D1",		0x76); D.alt = D1
E1		= Token(3,		"e'",	"_TK_E1",		0x76); E.alt = E1
H1		= Token(4,		"h'",	"_TK_H1",		0x76); H.alt = H1
L1		= Token(5,		"l'",	"_TK_L1",		0x76); L.alt = L1
A1		= Token(7,		"a'",	"_TK_A1",		0x76); A.alt = A1
F1		= Token(0,		"f'",	"_TK_F1",		0x76); F.alt = F1
	
IXH		= Token(4,		"ixh",	"_TK_IXH",		0xDD); H.ix = IXH
IXL		= Token(5,		"ixl",	"_TK_IXL",		0xDD); L.ix = IXL
	
IYH		= Token(4,		"iyh",	"_TK_IYH",		0xFD); H.iy = IYH
IYL		= Token(5,		"iyl",	"_TK_IYL",		0xFD); L.iy = IYL
	
BC		= Token(0,		"bc",	"_TK_BC",		0)
DE		= Token(1,		"de",	"_TK_DE",		0)
HL		= Token(2,		"hl",	"_TK_HL",		0)   ; HL.p_ix = 0
SP		= Token(3,		"sp",	"_TK_SP",		0)
AF		= Token(3,		"af",	"_TK_AF",		0)
IX		= Token(2,		"ix",	"_TK_IX",		0xDD); IX.p_ix = P_IX
IY		= Token(2,		"iy",	"_TK_IY",		0xFD); IY.p_ix = P_IY
	
BC1		= Token(0,		"bc'",	"_TK_BC1",		0)   ; BC.alt = BC1
DE1		= Token(1,		"de'",	"_TK_DE1",		0)   ; DE.alt = DE1
HL1		= Token(2,		"hl'",	"_TK_HL1",		0)   ; HL.alt = HL1
AF1		= Token(3,		"af'",	"_TK_AF1",		0)   ; AF.alt = AF1
	
IND_BC	= Token(0,		"(bc",	"_TK_IND_BC",	0)   ; BC.ind = IND_BC
IND_DE	= Token(1,		"(de",	"_TK_IND_DE",	0)   ; DE.ind = IND_DE
IND_HL	= Token(2,		"(hl",	"_TK_IND_HL",	0)   ; HL.ind = IND_HL
IND_SP	= Token(3,		"(sp",	"_TK_IND_SP",	0)   ; SP.ind = IND_SP
IND_IX	= Token(2,		"(ix",	"_TK_IND_IX",	0xDD); IX.ind = IND_IX
IND_IY	= Token(2,		"(iy",	"_TK_IND_IY",	0xFD); IY.ind = IND_IY

IP		= Token(0,		"ip",	"_TK_IP",		0);
SU		= Token(0,		"su",	"_TK_SU",		0);

sp = " "

#------------------------------------------------------------------------------
# CPUS
#------------------------------------------------------------------------------
Z80		= 1
Z180	= 2
R2K		= 4
R3K		= 8

ALL		= Z80 + Z180 + R2K + R3K
ZILOG	= Z80 + Z180
RABBIT	= R2K + R3K
NOT_Z80 = ALL - Z80

cpu_code = [0] * (ALL+1)

cpu_code[Z80] 	 = '\nif ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }'
cpu_code[NOT_Z80]= '\nif ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; }'
cpu_code[Z180] 	 = '\nif ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }'
cpu_code[R2K] 	 = '\nif ((opts.cpu & (CPU_R2K)) == 0) { error_illegal_ident(); return FALSE; }'
cpu_code[R3K] 	 = '\nif ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }'
cpu_code[ALL] 	 = ''
cpu_code[ZILOG]	 = '\nif ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }'
cpu_code[RABBIT] = '\nif ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }'

#------------------------------------------------------------------------------
# Output files
#------------------------------------------------------------------------------
file_ok  = [0] * (ALL+1)
file_err = [0] * (ALL+1)

file_ok[Z80]  	= open("t/data/z80-ok.asm",	  "w")
file_err[Z80]  	= open("t/data/z80-err.asm",  "w")

file_ok[Z180]  	= open("t/data/z180-ok.asm",  "w")
file_err[Z180] 	= open("t/data/z180-err.asm", "w")

file_ok[R2K]  	= open("t/data/r2k-ok.asm",   "w")
file_err[R2K] 	= open("t/data/r2k-err.asm",  "w")

file_ok[R3K]  	= open("t/data/r3k-ok.asm",   "w")
file_err[R3K] 	= open("t/data/r3k-err.asm",  "w")

file_rules 		= open("cpu_opcodes.h", "w")

#------------------------------------------------------------------------------
# emit
#------------------------------------------------------------------------------
def emit_asm(cpus, asm, bytes):
	bytes_dump = sp.join(["%02X" % x for x in bytes])
	asm_line = " %-30s ; %s\n" % (asm, bytes_dump)
	for arch in [Z80, Z180, R2K, R3K]:
		if cpus & arch:
			file_ok[arch].write(asm_line)
		else:
			file_err[arch].write(asm_line)
	file_rules.write("/* " + asm + " */\n")

def emit_rule(cpus, rule_toks, code_toks):
	rule = sp.join([x.tok for x in rule_toks])
	code = sp.join(code_toks)
	rule_line = sp.join(['| label?',
						 rule,
						 NEWLINE.tok,
						 '@{', cpu_code[cpus], 
						 code,
						 '\n}\n\n'])
	file_rules.write(rule_line)

def DO(stmt, opcode, prefix=0, dis0=0):
	arg = '0x%02X' % opcode
	if prefix:
		arg = prefix + ' + ' + arg
	if dis0:
		arg = '(' + arg + ') << 8'
	return '\n' + stmt + '(' + arg + ');'

def DO_stmt(opcode, prefix=0, dis0=0):
	return DO('DO_stmt', opcode, prefix, dis0)

def DO_stmt_n(opcode, prefix=0, dis0=0):
	return DO('DO_stmt_n', opcode, prefix, dis0)

def DO_stmt_nn(opcode, prefix=0, dis0=0):
	return DO('DO_stmt_nn', opcode, prefix, dis0)

def DO_stmt_idx(opcode, prefix=0, dis0=0):
	return DO('DO_stmt_idx', opcode, prefix, dis0)

def DO_stmt_idx_n(opcode, prefix=0, dis0=0):
	return DO('DO_stmt_idx_n', opcode, prefix, dis0)

def DO_stmt_emul(opcode, func):
	return '\nDO_stmt_emul(0x%02X, %s);' % (opcode, func)

def DO_ALTD():
	return DO_stmt(ALTD.prefix)

#------------------------------------------------------------------------------
# 8-bit arithmetic group
#------------------------------------------------------------------------------

for r in [B, C, D, E, H, L, A]:
	# tst a, r
	opcode = 0x04 + r.n*8
	emit_asm( NOT_Z80, "tst a, %s" % r.asm, [0xED, opcode])
	emit_rule(NOT_Z80, [TST, A, COMMA, r],
		[DO_stmt(0xED00 + opcode)])
			
	# tst r
	emit_asm( NOT_Z80, "tst %s" % r.asm, [0xED, opcode])
	emit_rule(NOT_Z80, [TST, r],
		[DO_stmt(0xED00 + opcode)])
			
# tst a, (hl)
opcode = 0x04 + 6*8
emit_asm( NOT_Z80, "tst a, (hl)", [0xED, opcode])
emit_rule(NOT_Z80, [TST, A, COMMA, IND_HL, RPAREN],
	[DO_stmt(0xED00 + opcode)])
		
# tst (hl)
emit_asm( NOT_Z80, "tst (hl)", [0xED, opcode])
emit_rule(NOT_Z80, [TST, IND_HL, RPAREN],
	[DO_stmt(0xED00 + opcode)])
		
# tst a, N
opcode = 0x64
emit_asm( NOT_Z80, "tst a,  42 ", [0xED, opcode, 42])
emit_asm( NOT_Z80, "tst a, (42)", [0xED, opcode, 42])
emit_rule(NOT_Z80, [TST, A, COMMA, expr],
	[DO_stmt_n(0xED00 + opcode)])
		
# tst N
emit_asm( NOT_Z80, "tst  42 ", [0xED, opcode, 42])
emit_asm( NOT_Z80, "tst (42)", [0xED, opcode, 42])
emit_rule(NOT_Z80, [TST, expr],
	[DO_stmt_n(0xED00 + opcode)])
		

#------------------------------------------------------------------------------
# General-Purpose Arithmetic Group
#------------------------------------------------------------------------------

for op in [DAA]:
	# daa
	emit_asm( ZILOG, op.asm, [op.n])
	emit_rule(ZILOG, [op],
		[DO_stmt(op.n)])
		
for op in [RRD, RLD]:
	# rrd / rld : only exist in ZILOG, but emulated in RABBIT
	emit_asm( ZILOG, op.asm, [0xED, op.n])
	emit_rule(ALL, [op],
		[DO_stmt_emul(0xED00 + op.n, 'rcmx_' + op.asm)])

for op in [CPL]:
	# cpl
	emit_asm( ALL, op.asm, [op.n])
	emit_rule(ALL, [op],
		[DO_stmt(op.n)])
		
	# cpl a
	emit_asm( ALL, "%s a" % op.asm, [op.n])
	emit_rule(ALL, [op, A],
		[DO_stmt(op.n)])
		
	# altd cpl a
	emit_asm( RABBIT, "altd %s a" % op.asm, [ALTD.prefix, op.n])
	emit_rule(RABBIT, [ALTD, op, A],
		[DO_ALTD(), DO_stmt(op.n)])
		
	# altd cpl
	emit_asm( RABBIT, "altd %s" % op.asm, [ALTD.prefix, op.n])
	emit_rule(RABBIT, [ALTD, op],
		[DO_ALTD(), DO_stmt(op.n)])
		
	# cpl a'
	emit_asm( RABBIT, "%s a'" % op.asm, [ALTD.prefix, op.n])
	emit_rule(RABBIT, [op, A1],
		[DO_ALTD(), DO_stmt(op.n)])
		
for op in [NEG]:
	# neg
	emit_asm( ALL, op.asm, [0xED, op.n])
	emit_rule(ALL, [op],
		[DO_stmt(0xED00 + op.n)])
		
	# neg a
	emit_asm( ALL, "%s a" % op.asm, [0xED, op.n])
	emit_rule(ALL, [op, A],
		[DO_stmt(0xED00 + op.n)])
		
	# altd neg a
	emit_asm( RABBIT, "altd %s a" % op.asm, [ALTD.prefix, 0xED, op.n])
	emit_rule(RABBIT, [ALTD, op, A],
		[DO_ALTD(), DO_stmt(0xED00 + op.n)])
		
	# altd neg
	emit_asm( RABBIT, "altd %s" % op.asm, [ALTD.prefix, 0xED, op.n])
	emit_rule(RABBIT, [ALTD, op],
		[DO_ALTD(), DO_stmt(0xED00 + op.n)])
		
	# neg a'
	emit_asm( RABBIT, "%s a'" % op.asm, [ALTD.prefix, 0xED, op.n])
	emit_rule(RABBIT, [op, A1],
		[DO_ALTD(), DO_stmt(0xED00 + op.n)])
		
for op in [CCF, SCF]:
	# ccf
	emit_asm( ALL, op.asm, [op.n])
	emit_rule(ALL, [op],
		[DO_stmt(op.n)])
		
	# ccf f
	emit_asm( ALL, "%s f" % op.asm, [op.n])
	emit_rule(ALL, [op, F],
		[DO_stmt(op.n)])
		
	# altd ccf f
	emit_asm( RABBIT, "altd %s f" % op.asm, [ALTD.prefix, op.n])
	emit_rule(RABBIT, [ALTD, op, F],
		[DO_ALTD(), DO_stmt(op.n)])
		
	# altd ccf
	emit_asm( RABBIT, "altd %s" % op.asm, [ALTD.prefix, op.n])
	emit_rule(RABBIT, [ALTD, op],
		[DO_ALTD(), DO_stmt(op.n)])
		
	# ccf f'
	emit_asm( RABBIT, "%s f'" % op.asm, [ALTD.prefix, op.n])
	emit_rule(RABBIT, [op, F1],
		[DO_ALTD(), DO_stmt(op.n)])
		

#------------------------------------------------------------------------------
# 16-bit load group
#------------------------------------------------------------------------------

# ld hl, NN | ld hl, (NN)
dd = HL
ind_opcode = 0x2A
imm_opcode = 0x01 + dd.n*16
emit_asm( ALL, "ld %s,  256"  % dd.asm, [imm_opcode, 0, 1]);
emit_asm( ALL, "ld %s, (256)" % dd.asm, [ind_opcode, 0, 1]);
emit_rule(ALL, [LD, dd, COMMA, expr], 
	['\nif (expr_in_parens) {',
	 DO_stmt_nn(ind_opcode),
	 '\n} else {',
	 DO_stmt_nn(imm_opcode),
	 '\n}'])

# altd ld hl, NN | altd ld hl, (NN)
emit_asm( RABBIT, "altd ld %s,  256"  % dd.asm, [ALTD.prefix, imm_opcode, 0, 1]);
emit_asm( RABBIT, "altd ld %s, (256)" % dd.asm, [ALTD.prefix, ind_opcode, 0, 1]);
emit_rule(RABBIT, [ALTD, LD, dd, COMMA, expr], 
	['\nif (expr_in_parens) {',
	 DO_ALTD(),
	 DO_stmt_nn(ind_opcode),
	 '\n} else {',
	 DO_ALTD(),
	 DO_stmt_nn(imm_opcode),
	 '\n}'])

# ld hl', NN | ld hl', (NN)
emit_asm( RABBIT, "ld %s,  256"  % dd.alt.asm, [ALTD.prefix, imm_opcode, 0, 1]);
emit_asm( RABBIT, "ld %s, (256)" % dd.alt.asm, [ALTD.prefix, ind_opcode, 0, 1]);
emit_rule(RABBIT, [LD, dd.alt, COMMA, expr], 
	['\nif (expr_in_parens) {',
	 DO_ALTD(),
	 DO_stmt_nn(ind_opcode),
	 '\n} else {',
	 DO_ALTD(),
	 DO_stmt_nn(imm_opcode),
	 '\n}'])

for dd in [IX, IY]:
	# ld ix, NN | ld ix, (NN)
	emit_asm( ALL, "ld %s,  256"  % dd.asm, [dd.prefix, imm_opcode, 0, 1]);
	emit_asm( ALL, "ld %s, (256)" % dd.asm, [dd.prefix, ind_opcode, 0, 1]);
	emit_rule(ALL, [LD, dd, COMMA, expr], 
		['\nif (expr_in_parens) {',
		 DO_stmt_nn(ind_opcode, dd.p_ix),
		 '\n} else {',
		 DO_stmt_nn(imm_opcode, dd.p_ix),
		 '\n}'])

for dd in [BC, DE, SP]:
	# ld bc, NN | ld bc, (NN)
	ind_opcode = 0x4B + dd.n*16
	imm_opcode = 0x01 + dd.n*16
	emit_asm( ALL, "ld %s,  256"  % dd.asm, [imm_opcode, 0, 1]);
	emit_asm( ALL, "ld %s, (256)" % dd.asm, [0xED, ind_opcode, 0, 1]);
	emit_rule(ALL, [LD, dd, COMMA, expr], 
		['\nif (expr_in_parens) {',
		 DO_stmt_nn(0xED00 + ind_opcode),
		 '\n} else {',
		 DO_stmt_nn(imm_opcode),
		 '\n}'])

	if dd != SP:
		# altd ld bc, NN | altd ld bc, (NN)
		emit_asm( RABBIT, "altd ld %s,  256"  % dd.asm, [ALTD.prefix, imm_opcode, 0, 1]);
		emit_asm( RABBIT, "altd ld %s, (256)" % dd.asm, [ALTD.prefix, 0xED, ind_opcode, 0, 1]);
		emit_rule(RABBIT, [ALTD, LD, dd, COMMA, expr], 
			['\nif (expr_in_parens) {',
			 DO_ALTD(),
			 DO_stmt_nn(0xED00 + ind_opcode),
			 '\n} else {',
			 DO_ALTD(),
			 DO_stmt_nn(imm_opcode),
			 '\n}'])

		# ld bc', NN | ld bc', (NN)
		emit_asm( RABBIT, "ld %s,  256"  % dd.alt.asm, [ALTD.prefix, imm_opcode, 0, 1]);
		emit_asm( RABBIT, "ld %s, (256)" % dd.alt.asm, [ALTD.prefix, 0xED, ind_opcode, 0, 1]);
		emit_rule(RABBIT, [LD, dd.alt, COMMA, expr], 
			['\nif (expr_in_parens) {',
			 DO_ALTD(),
			 DO_stmt_nn(0xED00 + ind_opcode),
			 '\n} else {',
			 DO_ALTD(),
			 DO_stmt_nn(imm_opcode),
			 '\n}'])

# ld (NN), hl
dd = HL
opcode = 0x22
emit_asm( ALL, "ld (256), %s" % dd.asm, [opcode, 0, 1])
emit_rule(ALL, [LD, expr, COMMA, dd],
	['\nif (!expr_in_parens) return FALSE;',
	 DO_stmt_nn(opcode)])

for dd in [IX, IY]:
	# ld (NN), ix
	emit_asm( ALL, "ld (256), %s" % dd.asm, [dd.prefix, opcode, 0, 1])
	emit_rule(ALL, [LD, expr, COMMA, dd],
		['\nif (!expr_in_parens) return FALSE;',
		 DO_stmt_nn(opcode, dd.p_ix)])

for dd in [BC, DE, SP]:
	# ld (NN), bc
	opcode = 0x43 + dd.n*16
	emit_asm( ALL, "ld (256), %s" % dd.asm, [0xED, opcode, 0, 1])
	emit_rule(ALL, [LD, expr, COMMA, dd],
		['\nif (!expr_in_parens) return FALSE;',
		 DO_stmt_nn(0xED00 + opcode)])

# ld sp, hl
opcode = 0xF9
dd = HL
emit_asm( ALL, "ld sp, %s" % dd.asm, [opcode])
emit_rule(ALL, [LD, SP, COMMA, dd],
	[DO_stmt(opcode)])

for dd in [IX, IY]:
	# ld sp, ix
	emit_asm( ALL, "ld sp, %s" % dd.asm, [dd.prefix, opcode])
	emit_rule(ALL, [LD, SP, COMMA, dd],
		[DO_stmt(opcode, dd.p_ix)])

for dd in [BC, DE, HL, AF]:
	# push bc
	opcode = 0xC5 + dd.n*16
	emit_asm( ALL, "push %s" % dd.asm, [opcode])
	emit_rule(ALL, [PUSH, dd],
		[DO_stmt(opcode)])

for dd in [IX, IY]:
	# push ix
	opcode = 0xC5 + dd.n*16
	emit_asm( ALL, "push %s" % dd.asm, [dd.prefix, opcode])
	emit_rule(ALL, [PUSH, dd],
		[DO_stmt(opcode, dd.p_ix)])

for dd in [BC, DE, HL, AF]:
	# pop bc
	opcode = 0xC1 + dd.n*16
	emit_asm( ALL, "pop %s" % dd.asm, [opcode])
	emit_rule(ALL, [POP, dd],
		[DO_stmt(opcode)])

	# altd pop bc
	emit_asm( RABBIT, "altd pop %s" % dd.asm, [ALTD.prefix, opcode])
	emit_rule(RABBIT, [ALTD, POP, dd],
		[DO_ALTD(),
		 DO_stmt(opcode)])

	# pop bc'
	emit_asm( RABBIT, "pop %s" % dd.alt.asm, [ALTD.prefix, opcode])
	emit_rule(RABBIT, [POP, dd.alt],
		[DO_ALTD(),
		 DO_stmt(opcode)])

for dd in [IX, IY]:
	# pop ix
	opcode = 0xC1 + dd.n*16
	emit_asm( ALL, "pop %s" % dd.asm, [dd.prefix, opcode])
	emit_rule(ALL, [POP, dd],
		[DO_stmt(opcode, dd.p_ix)])

# push ip
emit_asm( RABBIT, "push %s" % IP.asm, [0xED, 0x76])
emit_rule(RABBIT, [PUSH, IP], [DO_stmt(0xED76)])

# pop ip
emit_asm( RABBIT, "pop %s" % IP.asm, [0xED, 0x7E])
emit_rule(RABBIT, [POP, IP], [DO_stmt(0xED7E)])

# push su
emit_asm( R3K, "push %s" % SU.asm, [0xED, 0x66])
emit_rule(R3K, [PUSH, SU], [DO_stmt(0xED66)])

# pop su
emit_asm( R3K, "pop %s" % SU.asm, [0xED, 0x6E])
emit_rule(R3K, [POP, SU], [DO_stmt(0xED6E)])

for dd in [IX, IY]:
	# ld hl, ix
	opcode = 0x7C
	emit_asm( RABBIT, "ld %s, %s" % (HL.asm, dd.asm), [dd.prefix, opcode])
	emit_rule(RABBIT, [LD, HL, COMMA, dd], 
		[DO_stmt(opcode, dd.p_ix)])
		
	# altd ld hl, ix
	emit_asm( RABBIT, "altd ld %s, %s" % (HL.asm, dd.asm), 
		[ALTD.prefix, dd.prefix, opcode])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, dd], 
		[DO_ALTD(),
		 DO_stmt(opcode, dd.p_ix)])
		
	# ld hl', ix
	emit_asm( RABBIT, "ld %s, %s" % (HL.alt.asm, dd.asm), 
		[ALTD.prefix, dd.prefix, opcode])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, dd], 
		[DO_ALTD(),
		 DO_stmt(opcode, dd.p_ix)])
		 
	# ld ix, hl
	opcode = 0x7D
	emit_asm( RABBIT, "ld %s, %s" % (dd.asm, HL.asm), [dd.prefix, opcode])
	emit_rule(RABBIT, [LD, dd, COMMA, HL], 
		[DO_stmt(opcode, dd.p_ix)])

		
		
if 0:
	# ld hl, (hl+d)
	opcode = 0xE4
	emit_asm( RABBIT, "ld hl, (hl + 127)", [0xDD, opcode, 0x7F])
	emit_asm( RABBIT, "ld hl, (hl - 128)", [0xDD, opcode, 0x80])
	emit_rule(RABBIT, [LD, HL, COMMA, IND_HL, expr, RPAREN], 
		[DO_stmt_idx(opcode, RABBIT_P_HL)])

	# ld hl, (hl)
	emit_asm( RABBIT, "ld hl, (hl)", [0xDD, opcode, 0])
	emit_rule(RABBIT, [LD, HL, COMMA, IND_HL, RPAREN], 
		[DO_stmt(opcode, RABBIT_P_HL, 1)])

	# altd ld hl, (hl+d)
	emit_asm( RABBIT, "altd ld hl, (hl + 127)", [ALTD.prefix, 0xDD, opcode, 0x7F])
	emit_asm( RABBIT, "altd ld hl, (hl - 128)", [ALTD.prefix, 0xDD, opcode, 0x80])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, IND_HL, expr, RPAREN], 
		[DO_ALTD(),
		 DO_stmt_idx(opcode, RABBIT_P_HL)])

	# altd ld hl, (hl)
	emit_asm( RABBIT, "altd ld hl, (hl)", [ALTD.prefix, 0xDD, opcode, 0])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, IND_HL, RPAREN], 
		[DO_ALTD(),
		 DO_stmt(opcode, RABBIT_P_HL, 1)])

	# ld hl', (hl+d)
	emit_asm( RABBIT, "ld hl', (hl + 127)", [ALTD.prefix, 0xDD, opcode, 0x7F])
	emit_asm( RABBIT, "ld hl', (hl - 128)", [ALTD.prefix, 0xDD, opcode, 0x80])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, IND_HL, expr, RPAREN], 
		[DO_ALTD(),
		 DO_stmt_idx(opcode, RABBIT_P_HL)])

	# ld hl', (hl)
	emit_asm( RABBIT, "ld hl', (hl)", [ALTD.prefix, 0xDD, opcode, 0])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, IND_HL, RPAREN], 
		[DO_ALTD(),
		 DO_stmt(opcode, RABBIT_P_HL, 1)])


		 
		 
		 
		 
		 
	# ld hl, (ix+d)
	emit_asm( RABBIT, "ld hl, (ix + 127)", [opcode, 0x7F])
	emit_asm( RABBIT, "ld hl, (ix - 128)", [opcode, 0x80])
	emit_rule(RABBIT, [LD, HL, COMMA, IND_IX, expr, RPAREN], 
		[DO_stmt_idx(opcode, RABBIT_P_IX)])

	# ld hl, (ix)
	emit_asm( RABBIT, "ld hl, (ix)", [opcode, 0])
	emit_rule(RABBIT, [LD, HL, COMMA, IND_IX, RPAREN], 
		[DO_stmt(opcode, RABBIT_P_IX, 1)])

	# altd ld hl, (ix+d)
	emit_asm( RABBIT, "altd ld hl, (ix + 127)", [ALTD.prefix, opcode, 0x7F])
	emit_asm( RABBIT, "altd ld hl, (ix - 128)", [ALTD.prefix, opcode, 0x80])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, IND_IX, expr, RPAREN], 
		[DO_ALTD(),
		 DO_stmt_idx(opcode, RABBIT_P_IX)])

	# altd ld hl, (ix)
	emit_asm( RABBIT, "altd ld hl, (ix)", [ALTD.prefix, opcode, 0])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, IND_IX, RPAREN], 
		[DO_ALTD(),
		 DO_stmt(opcode, RABBIT_P_IX, 1)])

	# ld hl', (ix+d)
	emit_asm( RABBIT, "ld hl', (ix + 127)", [ALTD.prefix, opcode, 0x7F])
	emit_asm( RABBIT, "ld hl', (ix - 128)", [ALTD.prefix, opcode, 0x80])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, IND_IX, expr, RPAREN], 
		[DO_ALTD(),
		 DO_stmt_idx(opcode, RABBIT_P_IX)])

	# ld hl', (ix)
	emit_asm( RABBIT, "ld hl', (ix)", [ALTD.prefix, opcode, 0])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, IND_IX, RPAREN], 
		[DO_ALTD(),
		 DO_stmt(opcode, RABBIT_P_IX, 1)])


		 
		 
		 
		 
		 
	# ld hl, (iy+d)
	emit_asm( RABBIT, "ld hl, (iy + 127)", [opcode, 0x7F])
	emit_asm( RABBIT, "ld hl, (iy - 128)", [opcode, 0x80])
	emit_rule(RABBIT, [LD, HL, COMMA, IND_IX, expr, RPAREN], 
		[DO_stmt_idx(opcode, RABBIT_P_IX)])

	# ld hl, (iy)
	emit_asm( RABBIT, "ld hl, (iy)", [opcode, 0])
	emit_rule(RABBIT, [LD, HL, COMMA, IND_IX, RPAREN], 
		[DO_stmt(opcode, RABBIT_P_IX, 1)])

	# altd ld hl, (iy+d)
	emit_asm( RABBIT, "altd ld hl, (iy + 127)", [ALTD.prefix, opcode, 0x7F])
	emit_asm( RABBIT, "altd ld hl, (iy - 128)", [ALTD.prefix, opcode, 0x80])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, IND_IX, expr, RPAREN], 
		[DO_ALTD(),
		 DO_stmt_idx(opcode, RABBIT_P_IX)])

	# altd ld hl, (iy)
	emit_asm( RABBIT, "altd ld hl, (iy)", [ALTD.prefix, opcode, 0])
	emit_rule(RABBIT, [ALTD, LD, HL, COMMA, IND_IX, RPAREN], 
		[DO_ALTD(),
		 DO_stmt(opcode, RABBIT_P_IX, 1)])

	# ld hl', (iy+d)
	emit_asm( RABBIT, "ld hl', (iy + 127)", [ALTD.prefix, opcode, 0x7F])
	emit_asm( RABBIT, "ld hl', (iy - 128)", [ALTD.prefix, opcode, 0x80])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, IND_IX, expr, RPAREN], 
		[DO_ALTD(),
		 DO_stmt_idx(opcode, RABBIT_P_IX)])

	# ld hl', (iy)
	emit_asm( RABBIT, "ld hl', (iy)", [ALTD.prefix, opcode, 0])
	emit_rule(RABBIT, [LD, HL.alt, COMMA, IND_IX, RPAREN], 
		[DO_ALTD(),
		 DO_stmt(opcode, RABBIT_P_IX, 1)])

