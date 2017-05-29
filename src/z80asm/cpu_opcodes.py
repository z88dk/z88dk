#!python

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

ALTD	= Token(0,	"altd",	"_TK_ALTD",		0x76)
COMMA	= Token(0,	",",	"_TK_COMMA",	0)
LD		= Token(0,	"ld",	"_TK_LD",		0)
NL		= Token(0,	"",		"_TK_NEWLINE",	0)

B		= Token(0,	"b",	"_TK_B",		0); B.ix = B; B.iy = B
C		= Token(1,	"c",	"_TK_C",		0); C.ix = C; C.iy = C
D		= Token(2,	"d",	"_TK_D",		0); D.ix = D; D.iy = D
E		= Token(3,	"e",	"_TK_E",		0); E.ix = E; E.iy = E
H		= Token(4,	"h",	"_TK_H",		0); H.ix = H; H.iy = H
L		= Token(5,	"l",	"_TK_L",		0); L.ix = L; L.iy = L
A		= Token(7,	"a",	"_TK_A",		0); A.ix = A; A.iy = A

B1		= Token(0,	"b'",	"_TK_B1",		0x76); B.alt = B1
C1		= Token(1,	"c'",	"_TK_C1",		0x76); C.alt = C1
D1		= Token(2,	"d'",	"_TK_D1",		0x76); D.alt = D1
E1		= Token(3,	"e'",	"_TK_E1",		0x76); E.alt = E1
H1		= Token(4,	"h'",	"_TK_H1",		0x76); H.alt = H1
L1		= Token(5,	"l'",	"_TK_L1",		0x76); L.alt = L1
A1		= Token(7,	"a'",	"_TK_A1",		0x76); A.alt = A1

IXH		= Token(4,	"ixh",	"_TK_IXH",		0xDD); H.ix = IXH
IXL		= Token(5,	"ixl",	"_TK_IXL",		0xDD); L.ix = IXL

IYH		= Token(4,	"iyh",	"_TK_IYH",		0xFD); H.iy = IYH
IYL		= Token(5,	"iyl",	"_TK_IYL",		0xFD); L.iy = IYL

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

cpu_code[Z80] 	= 'if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }\n'
cpu_code[NOT_Z80]= 'if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; }\n'
cpu_code[Z180] 	= 'if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }\n'
cpu_code[R2K] 	= 'if ((opts.cpu & (CPU_R2K)) == 0) { error_illegal_ident(); return FALSE; }\n'
cpu_code[R3K] 	= 'if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }\n'
cpu_code[ALL] 	= ''
cpu_code[ZILOG]	= 'if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }\n'
cpu_code[RABBIT]= 'if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }\n'


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

file_rules 		= open("cpu_opcodes2.h", "w")

#------------------------------------------------------------------------------
# emit
#------------------------------------------------------------------------------
def emit(cpus, asm_toks, bytes, rule_toks, code_toks):
	asm = sp.join(asm_toks)
	dump = sp.join(["%02X" % x for x in bytes])
	
	asm_line = " %-30s ; %s\n" % (asm, dump)
	for arch in (Z80, Z180, R2K, R3K):
		if cpus & arch:
			file_ok[arch].write(asm_line)
		else:
			file_err[arch].write(asm_line)
	
	rule_line = sp.join(['| label?', '\n',
						 sp.join(rule_toks),
						 NL.tok,
						 '@{', '\n', cpu_code[cpus], 
						 sp.join(code_toks), '\n',
						 '}\n\n'])
	file_rules.write(rule_line)
	
#------------------------------------------------------------------------------
# 8-bit load group
#------------------------------------------------------------------------------

for r1 in (B, C, D, E, H, L, A):
	for r2 in (B, C, D, E, H, L, A):
		opcode = 0x40 + r1.n*8 + r2.n
		
		# ld r,r
		emit(ALL,
			[LD.asm, r1.asm, COMMA.asm, r2.asm],
			[opcode],
			[LD.tok, r1.tok, COMMA.tok, r2.tok],
			['DO_stmt(0x%02X);' % opcode])
			
		# altd ld r,r
		emit(RABBIT,
			[ALTD.asm, LD.asm, r1.asm, COMMA.asm, r2.asm],
			[ALTD.prefix, opcode],
			[ALTD.tok, LD.tok, r1.tok, COMMA.tok, r2.tok],
			['DO_stmt(0x%02X);' % ALTD.prefix,
			 'DO_stmt(0x%02X);' % opcode])
			 
		# ld r',r
		emit(RABBIT,
			[LD.asm, r1.alt.asm, COMMA.asm, r2.asm],
			[r1.alt.prefix, opcode],
			[LD.tok, r1.alt.tok, COMMA.tok, r2.tok],
			['DO_stmt(0x%02X);' % r1.alt.prefix,
			 'DO_stmt(0x%02X);' % opcode])
			 
		dd = r1.ix.prefix or r2.ix.prefix
		fd = r1.iy.prefix or r2.iy.prefix
		if dd or fd:
		
			# ld ld ixh,r
			emit(Z80,
				[LD.asm, r1.ix.asm, COMMA.asm, r2.ix.asm],
				[dd, opcode],
				[LD.tok, r1.ix.tok, COMMA.tok, r2.ix.tok],
				['DO_stmt(P_IX + 0x%02X);' % opcode])
		
			# ld ld iyh,r
			emit(Z80,
				[LD.asm, r1.iy.asm, COMMA.asm, r2.iy.asm],
				[fd, opcode],
				[LD.tok, r1.iy.tok, COMMA.tok, r2.iy.tok],
				['DO_stmt(P_IY + 0x%02X);' % opcode])
