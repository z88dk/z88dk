static const int lexer_start = 21;
static const int lexer_error = 0;
static const int lexer_en_main = 21;
static void set_scan_buf( char *text, Bool _at_bol )
{
 Str_set( input_buf, text );
 at_bol = _at_bol;
 pe = input_buf->str + input_buf->len;
 eof = pe;
	{
	cs = lexer_start;
	ts = 0;
	te = 0;
	act = 0;
	}
}
static tokid_t _scan_get( void )
{
	{
	short _widec;
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
	{{p = ((te))-1;}{
	sym.tok = TK_LPAREN;
	sym.text = "(";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr9:
	{te = p+1;{
	sym.tok = TK_IND_BC;
	sym.text = "(BC)";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr10:
	{te = p+1;{
	sym.tok = TK_IND_C;
	sym.text = "(C)";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr12:
	{te = p+1;{
	sym.tok = TK_IND_DE;
	sym.text = "(DE)";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr14:
	{te = p+1;{
	sym.tok = TK_IND_HL;
	sym.text = "(HL)";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr17:
	{te = p+1;{
	sym.tok = TK_IND_IX;
	sym.text = "(IX";
	p--; te--;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr18:
	{te = p+1;{
	sym.tok = TK_IND_IY;
	sym.text = "(IY";
	p--; te--;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr20:
	{te = p+1;{
	sym.tok = TK_IND_SP;
	sym.text = "(SP)";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr21:
	{	switch( act ) {
	case 1:
	{{p = ((te))-1;}
	sym.tok = TK_ASMPC;
	sym.text = "ASMPC";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 37:
	{{p = ((te))-1;}
	sym.tok = TK_NZ;
	sym.text = "NZ";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 38:
	{{p = ((te))-1;}
	sym.tok = TK_Z;
	sym.text = "Z";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 39:
	{{p = ((te))-1;}
	sym.tok = TK_NC;
	sym.text = "NC";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 40:
	{{p = ((te))-1;}
	sym.tok = TK_C;
	sym.text = "C";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 41:
	{{p = ((te))-1;}
	sym.tok = TK_PO;
	sym.text = "PO";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 42:
	{{p = ((te))-1;}
	sym.tok = TK_PE;
	sym.text = "PE";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 43:
	{{p = ((te))-1;}
	sym.tok = TK_P;
	sym.text = "P";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 44:
	{{p = ((te))-1;}
	sym.tok = TK_M;
	sym.text = "M";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 45:
	{{p = ((te))-1;}
	sym.tok = TK_B;
	sym.text = "B";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 46:
	{{p = ((te))-1;}
	sym.tok = TK_D;
	sym.text = "D";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 47:
	{{p = ((te))-1;}
	sym.tok = TK_E;
	sym.text = "E";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 48:
	{{p = ((te))-1;}
	sym.tok = TK_H;
	sym.text = "H";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 49:
	{{p = ((te))-1;}
	sym.tok = TK_IXH;
	sym.text = "IXH";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 50:
	{{p = ((te))-1;}
	sym.tok = TK_IYH;
	sym.text = "IYH";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 51:
	{{p = ((te))-1;}
	sym.tok = TK_L;
	sym.text = "L";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 52:
	{{p = ((te))-1;}
	sym.tok = TK_IXL;
	sym.text = "IXL";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 53:
	{{p = ((te))-1;}
	sym.tok = TK_IYL;
	sym.text = "IYL";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 54:
	{{p = ((te))-1;}
	sym.tok = TK_A;
	sym.text = "A";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 55:
	{{p = ((te))-1;}
	sym.tok = TK_F;
	sym.text = "F";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 56:
	{{p = ((te))-1;}
	sym.tok = TK_I;
	sym.text = "I";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 57:
	{{p = ((te))-1;}
	sym.tok = TK_IIR;
	sym.text = "IIR";
	if ( ! (opts.cpu & CPU_RABBIT) ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 58:
	{{p = ((te))-1;}
	sym.tok = TK_R;
	sym.text = "R";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 59:
	{{p = ((te))-1;}
	sym.tok = TK_EIR;
	sym.text = "EIR";
	if ( ! (opts.cpu & CPU_RABBIT) ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}
	break;
	case 61:
	{{p = ((te))-1;}
	sym.tok = TK_BC;
	sym.text = "BC";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 62:
	{{p = ((te))-1;}
	sym.tok = TK_DE;
	sym.text = "DE";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 63:
	{{p = ((te))-1;}
	sym.tok = TK_HL;
	sym.text = "HL";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 64:
	{{p = ((te))-1;}
	sym.tok = TK_IX;
	sym.text = "IX";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 65:
	{{p = ((te))-1;}
	sym.tok = TK_IY;
	sym.text = "IY";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 66:
	{{p = ((te))-1;}
	sym.tok = TK_AF;
	sym.text = "AF";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 67:
	{{p = ((te))-1;}
	sym.tok = TK_SP;
	sym.text = "SP";
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 75:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFGROUP;
		sym.text = "DEFGROUP";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 76:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFS;
		sym.text = "DEFS";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 77:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFVARS;
		sym.text = "DEFVARS";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 78:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ORG;
		sym.text = "ORG";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 83:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ADC;
		sym.text = "ADC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 84:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ADD;
		sym.text = "ADD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 85:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_AND;
		sym.text = "AND";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 86:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_BIT;
		sym.text = "BIT";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 87:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CALL;
		sym.text = "CALL";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 88:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CCF;
		sym.text = "CCF";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 89:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CP;
		sym.text = "CP";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 90:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPD;
		sym.text = "CPD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 91:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPDR;
		sym.text = "CPDR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 92:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPI;
		sym.text = "CPI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 93:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPIR;
		sym.text = "CPIR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 94:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPL;
		sym.text = "CPL";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 95:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DAA;
		sym.text = "DAA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 96:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEC;
		sym.text = "DEC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 97:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DI;
		sym.text = "DI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 98:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DJNZ;
		sym.text = "DJNZ";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 99:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EI;
		sym.text = "EI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 100:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EX;
		sym.text = "EX";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 101:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EXX;
		sym.text = "EXX";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 102:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_HALT;
		sym.text = "HALT";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 103:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IM;
		sym.text = "IM";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 104:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IN;
		sym.text = "IN";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 105:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INC;
		sym.text = "INC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 106:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IND;
		sym.text = "IND";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 107:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INDR;
		sym.text = "INDR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 108:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INI;
		sym.text = "INI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 109:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INIR;
		sym.text = "INIR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 110:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_JP;
		sym.text = "JP";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 111:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_JR;
		sym.text = "JR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 112:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LD;
		sym.text = "LD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 113:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDD;
		sym.text = "LDD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 114:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDDR;
		sym.text = "LDDR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 115:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDI;
		sym.text = "LDI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 116:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDIR;
		sym.text = "LDIR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 117:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_NEG;
		sym.text = "NEG";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 118:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_NOP;
		sym.text = "NOP";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 119:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OR;
		sym.text = "OR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 120:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTDR;
		sym.text = "OTDR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 121:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTIR;
		sym.text = "OTIR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 122:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUT;
		sym.text = "OUT";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 123:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUTD;
		sym.text = "OUTD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 124:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUTI;
		sym.text = "OUTI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 125:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_POP;
		sym.text = "POP";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 126:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_PUSH;
		sym.text = "PUSH";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 127:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RES;
		sym.text = "RES";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 128:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RET;
		sym.text = "RET";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 129:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RETI;
		sym.text = "RETI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 130:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RETN;
		sym.text = "RETN";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 131:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RL;
		sym.text = "RL";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 132:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLA;
		sym.text = "RLA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 133:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLC;
		sym.text = "RLC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 134:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLCA;
		sym.text = "RLCA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 135:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLD;
		sym.text = "RLD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 136:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RR;
		sym.text = "RR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 137:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRA;
		sym.text = "RRA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 138:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRC;
		sym.text = "RRC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 139:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRCA;
		sym.text = "RRCA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 140:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRD;
		sym.text = "RRD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 141:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RST;
		sym.text = "RST";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 142:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SBC;
		sym.text = "SBC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 143:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SCF;
		sym.text = "SCF";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 144:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SET;
		sym.text = "SET";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 145:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SLA;
		sym.text = "SLA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 146:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SLL;
		sym.text = "SLL";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 147:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SRA;
		sym.text = "SRA";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 148:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SRL;
		sym.text = "SRL";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 149:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SUB;
		sym.text = "SUB";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 150:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_XOR;
		sym.text = "XOR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 153:
	{{p = ((te))-1;}
  sym.tok = TK_NAME;
  set_tok_name();
  {p++; cs = 21; goto _out;}
 }
	break;
	case 155:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  {p++; cs = 21; goto _out;}
 }
	break;
	case 157:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 1, te - ts - 1, 16 );
  {p++; cs = 21; goto _out;}
 }
	break;
	case 159:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 2 );
  {p++; cs = 21; goto _out;}
 }
	break;
	case 161:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 2, 2 );
  {p++; cs = 21; goto _out;}
 }
	break;
	case 165:
	{{p = ((te))-1;}
  sym.tok = TK_NIL;
  skip_to_newline();
  {p++; cs = 21; goto _out;}
 }
	break;
	}
	}
	goto st21;
tr23:
	{te = p+1;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 16 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr24:
	{{p = ((te))-1;}{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr26:
	{{p = ((te))-1;}{
  sym.tok = TK_NIL;
  skip_to_newline();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr28:
	{te = p+1;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 3, 2 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr29:
	{{p = ((te))-1;}{
  sym.tok = TK_NAME;
  set_tok_name();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr30:
	{te = p+1;{
	sym.tok = TK_DS_B;
	sym.text = "DS.B";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr31:
	{te = p+1;{
	sym.tok = TK_DS_L;
	sym.text = "DS.L";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr32:
	{te = p+1;{
	sym.tok = TK_DS_P;
	sym.text = "DS.P";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr33:
	{te = p+1;{
	sym.tok = TK_DS_W;
	sym.text = "DS.W";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr34:
	{{p = ((te))-1;}{
	sym.tok = TK_DOT;
	sym.text = ".";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr38:
	{te = p+1;{
  while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
  while ( te[-1] == ':' || isspace(te[-1]) ) te--;
  sym.tok = TK_LABEL;
  set_tok_name();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr39:
	{te = p+1;}
	goto st21;
tr40:
	{te = p+1;{
	sym.tok = TK_NEWLINE;
	sym.text = "\n";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr42:
	{te = p+1;{
  sym.tok = TK_STRING;
  if ( ! get_sym_string() )
  {
   error_unclosed_string();
  }
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr43:
	{te = p+1;{
	sym.tok = TK_CONST_EXPR;
	sym.text = "#";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr45:
	{te = p+1;{
	sym.tok = TK_MOD;
	sym.text = "%";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr47:
	{te = p+1;{
  sym.tok = TK_NUMBER;
  if ( get_sym_string() &&
       sym_string->len == 1 )
  {
   sym.number = sym_string->str[0];
  }
  else
  {
   sym.number = 0;
   error_invalid_squoted_string();
  }
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr49:
	{te = p+1;{
	sym.tok = TK_RPAREN;
	sym.text = ")";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr51:
	{te = p+1;{
	sym.tok = TK_PLUS;
	sym.text = "+";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr52:
	{te = p+1;{
	sym.tok = TK_COMMA;
	sym.text = ",";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr53:
	{te = p+1;{
	sym.tok = TK_MINUS;
	sym.text = "-";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr54:
	{te = p+1;{
	sym.tok = TK_DIVIDE;
	sym.text = "/";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr59:
	{te = p+1;{
	sym.tok = TK_COLON;
	sym.text = ":";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr64:
	{te = p+1;{
	sym.tok = TK_QUESTION;
	sym.text = "?";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr66:
	{te = p+1;{
	sym.tok = TK_LSQUARE;
	sym.text = "[";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr67:
	{te = p+1;{
  sym.tok = TK_NIL;
  skip_to_newline();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr68:
	{te = p+1;{
	sym.tok = TK_RSQUARE;
	sym.text = "]";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr69:
	{te = p+1;{
	sym.tok = TK_BIN_XOR;
	sym.text = "^";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr70:
	{te = p+1;{
	sym.tok = TK_LCURLY;
	sym.text = "{";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr72:
	{te = p+1;{
	sym.tok = TK_RCURLY;
	sym.text = "}";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr73:
	{te = p+1;{
	sym.tok = TK_BIN_NOT;
	sym.text = "~";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr74:
	{te = p+1;{
	sym.tok = TK_DOT;
	sym.text = ".";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr114:
	{te = p;p--;{
	sym.tok = TK_LOG_NOT;
	sym.text = "!";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr115:
	{te = p+1;{
	sym.tok = TK_NOT_EQ;
	sym.text = "!=";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr117:
	{te = p;p--;{
	sym.tok = TK_BIN_AND;
	sym.text = "&";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr118:
	{te = p+1;{
	sym.tok = TK_LOG_AND;
	sym.text = "&&";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr119:
	{te = p;p--;{
	sym.tok = TK_LPAREN;
	sym.text = "(";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr120:
	{te = p;p--;{
	sym.tok = TK_MULTIPLY;
	sym.text = "*";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr121:
	{te = p+1;{
	sym.tok = TK_POWER;
	sym.text = "**";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr122:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr126:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 2 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr128:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 2, 16 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr129:
	{te = p;p--;}
	goto st21;
tr130:
	{te = p;p--;{
	sym.tok = TK_LESS;
	sym.text = "<";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr131:
	{te = p+1;{
	sym.tok = TK_LEFT_SHIFT;
	sym.text = "<<";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr132:
	{te = p+1;{
	sym.tok = TK_LESS_EQ;
	sym.text = "<=";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr133:
	{te = p+1;{
	sym.tok = TK_NOT_EQ;
	sym.text = "<>";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr134:
	{te = p;p--;{
	sym.tok = TK_EQUAL;
	sym.text = "=";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr135:
	{te = p+1;{
	sym.tok = TK_EQUAL;
	sym.text = "==";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr136:
	{te = p;p--;{
	sym.tok = TK_GREATER;
	sym.text = ">";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr137:
	{te = p+1;{
	sym.tok = TK_GREATER_EQ;
	sym.text = ">=";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr138:
	{te = p+1;{
	sym.tok = TK_RIGHT_SHIFT;
	sym.text = ">>";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr139:
	{te = p;p--;{
  sym.tok = TK_NIL;
  skip_to_newline();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr142:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 1, te - ts - 1, 2 );
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr143:
	{te = p;p--;{
	sym.tok = TK_BIN_OR;
	sym.text = "|";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr144:
	{te = p+1;{
	sym.tok = TK_LOG_OR;
	sym.text = "||";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr145:
	{te = p;p--;{
	sym.tok = TK_A;
	sym.text = "A";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr150:
	{te = p;p--;{
  sym.tok = TK_NAME;
  set_tok_name();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr153:
	{te = p;p--;{
	sym.tok = TK_AF;
	sym.text = "AF";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr154:
	{te = p+1;{
	sym.tok = TK_AF1;
	sym.text = "AF'";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr159:
	{te = p;p--;{
	sym.tok = TK_B;
	sym.text = "B";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr163:
	{te = p;p--;{
	sym.tok = TK_C;
	sym.text = "C";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr170:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CP;
		sym.text = "CP";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr174:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CPD;
		sym.text = "CPD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr176:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CPI;
		sym.text = "CPI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr178:
	{te = p;p--;{
	sym.tok = TK_D;
	sym.text = "D";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr185:
	{te = p;p--;{
	sym.tok = TK_DE;
	sym.text = "DE";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr201:
	{te = p;p--;{
	sym.tok = TK_E;
	sym.text = "E";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr204:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_EI;
		sym.text = "EI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr206:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_EX;
		sym.text = "EX";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr208:
	{te = p;p--;{
	sym.tok = TK_H;
	sym.text = "H";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr213:
	{te = p;p--;{
	sym.tok = TK_I;
	sym.text = "I";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr220:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_IN;
		sym.text = "IN";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr224:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_IND;
		sym.text = "IND";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr226:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_INI;
		sym.text = "INI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr228:
	{te = p;p--;{
	sym.tok = TK_IX;
	sym.text = "IX";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr231:
	{te = p;p--;{
	sym.tok = TK_IY;
	sym.text = "IY";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr236:
	{te = p;p--;{
	sym.tok = TK_L;
	sym.text = "L";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr238:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_LD;
		sym.text = "LD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr241:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_LDD;
		sym.text = "LDD";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr243:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_LDI;
		sym.text = "LDI";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr254:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_OR;
		sym.text = "OR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr261:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_OUT;
		sym.text = "OUT";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr264:
	{te = p;p--;{
	sym.tok = TK_P;
	sym.text = "P";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr268:
	{te = p;p--;{
	sym.tok = TK_PO;
	sym.text = "PO";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr272:
	{te = p;p--;{
	sym.tok = TK_R;
	sym.text = "R";
	if ( opts.cpu & CPU_RABBIT ) { error_illegal_ident(); };
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr279:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RET;
		sym.text = "RET";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr282:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RL;
		sym.text = "RL";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr286:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RLC;
		sym.text = "RLC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr288:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RR;
		sym.text = "RR";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr292:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RRC;
		sym.text = "RRC";
		;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		set_tok_name();
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr312:
	{te = p;p--;{
	sym.tok = TK_DOT;
	sym.text = ".";
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr313:
	{te = p;p--;{
  while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
  while ( te[-1] == ':' || isspace(te[-1]) ) te--;
  sym.tok = TK_LABEL;
  set_tok_name();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
st21:
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof21;
case 21:
	{ts = p;}
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( 46 <= (*p) && (*p) <= 46 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 10: goto tr40;
		case 33: goto st22;
		case 34: goto tr42;
		case 35: goto tr43;
		case 36: goto tr44;
		case 37: goto tr45;
		case 38: goto st24;
		case 39: goto tr47;
		case 40: goto tr48;
		case 41: goto tr49;
		case 42: goto st26;
		case 43: goto tr51;
		case 44: goto tr52;
		case 45: goto tr53;
		case 47: goto tr54;
		case 48: goto tr56;
		case 49: goto tr57;
		case 58: goto tr59;
		case 59: goto st33;
		case 60: goto st34;
		case 61: goto st35;
		case 62: goto st36;
		case 63: goto tr64;
		case 64: goto tr65;
		case 91: goto tr66;
		case 92: goto tr67;
		case 93: goto tr68;
		case 94: goto tr69;
		case 96: goto tr67;
		case 123: goto tr70;
		case 124: goto st39;
		case 125: goto tr72;
		case 126: goto tr73;
		case 127: goto tr39;
		case 302: goto tr74;
		case 321: goto st40;
		case 322: goto st48;
		case 323: goto st50;
		case 324: goto st57;
		case 325: goto st71;
		case 326: goto tr80;
		case 328: goto st74;
		case 329: goto st77;
		case 330: goto st84;
		case 332: goto st85;
		case 333: goto tr86;
		case 334: goto st89;
		case 335: goto st92;
		case 336: goto st99;
		case 338: goto st103;
		case 339: goto st111;
		case 344: goto st118;
		case 346: goto tr93;
		case 351: goto tr81;
		case 353: goto st40;
		case 354: goto st48;
		case 355: goto st50;
		case 356: goto st57;
		case 357: goto st71;
		case 358: goto tr80;
		case 360: goto st74;
		case 361: goto st77;
		case 362: goto st84;
		case 364: goto st85;
		case 365: goto tr86;
		case 366: goto st89;
		case 367: goto st92;
		case 368: goto st99;
		case 370: goto st103;
		case 371: goto st111;
		case 376: goto st118;
		case 378: goto tr93;
		case 558: goto tr94;
		case 577: goto tr95;
		case 578: goto tr96;
		case 579: goto tr97;
		case 580: goto tr98;
		case 581: goto tr99;
		case 582: goto tr100;
		case 584: goto tr102;
		case 585: goto tr103;
		case 586: goto tr104;
		case 588: goto tr105;
		case 589: goto tr106;
		case 590: goto tr107;
		case 591: goto tr108;
		case 592: goto tr109;
		case 594: goto tr110;
		case 595: goto tr111;
		case 600: goto tr112;
		case 602: goto tr113;
		case 607: goto tr101;
		case 609: goto tr95;
		case 610: goto tr96;
		case 611: goto tr97;
		case 612: goto tr98;
		case 613: goto tr99;
		case 614: goto tr100;
		case 616: goto tr102;
		case 617: goto tr103;
		case 618: goto tr104;
		case 620: goto tr105;
		case 621: goto tr106;
		case 622: goto tr107;
		case 623: goto tr108;
		case 624: goto tr109;
		case 626: goto tr110;
		case 627: goto tr111;
		case 632: goto tr112;
		case 634: goto tr113;
	}
	if ( _widec < 327 ) {
		if ( _widec > 32 ) {
			if ( 50 <= _widec && _widec <= 57 )
				goto tr58;
		} else
			goto tr39;
	} else if ( _widec > 345 ) {
		if ( _widec < 583 ) {
			if ( 359 <= _widec && _widec <= 377 )
				goto tr81;
		} else if ( _widec > 601 ) {
			if ( 615 <= _widec && _widec <= 633 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto st0;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
	if ( (*p) == 61 )
		goto tr115;
	goto tr114;
tr44:
	{te = p+1;}
	{act = 165;}
	goto st23;
tr116:
	{te = p+1;}
	{act = 157;}
	goto st23;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr116;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto tr116;
	} else
		goto tr116;
	goto tr21;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
	if ( (*p) == 38 )
		goto tr118;
	goto tr117;
tr48:
	{te = p+1;}
	goto st25;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	switch( (*p) ) {
		case 9: goto st1;
		case 32: goto st1;
		case 66: goto st2;
		case 67: goto st4;
		case 68: goto st5;
		case 72: goto st7;
		case 73: goto st9;
		case 83: goto st12;
		case 98: goto st2;
		case 99: goto st4;
		case 100: goto st5;
		case 104: goto st7;
		case 105: goto st9;
		case 115: goto st12;
	}
	goto tr119;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	switch( (*p) ) {
		case 9: goto st1;
		case 32: goto st1;
		case 66: goto st2;
		case 67: goto st4;
		case 68: goto st5;
		case 72: goto st7;
		case 73: goto st9;
		case 83: goto st12;
		case 98: goto st2;
		case 99: goto st4;
		case 100: goto st5;
		case 104: goto st7;
		case 105: goto st9;
		case 115: goto st12;
	}
	goto tr0;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	switch( (*p) ) {
		case 67: goto st3;
		case 99: goto st3;
	}
	goto tr0;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	switch( (*p) ) {
		case 9: goto st3;
		case 32: goto st3;
		case 41: goto tr9;
	}
	goto tr0;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	switch( (*p) ) {
		case 9: goto st4;
		case 32: goto st4;
		case 41: goto tr10;
	}
	goto tr0;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	switch( (*p) ) {
		case 69: goto st6;
		case 101: goto st6;
	}
	goto tr0;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	switch( (*p) ) {
		case 9: goto st6;
		case 32: goto st6;
		case 41: goto tr12;
	}
	goto tr0;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	switch( (*p) ) {
		case 76: goto st8;
		case 108: goto st8;
	}
	goto tr0;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	switch( (*p) ) {
		case 9: goto st8;
		case 32: goto st8;
		case 41: goto tr14;
	}
	goto tr0;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	switch( (*p) ) {
		case 88: goto st10;
		case 89: goto st11;
		case 120: goto st10;
		case 121: goto st11;
	}
	goto tr0;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
	switch( (*p) ) {
		case 9: goto st10;
		case 32: goto st10;
		case 41: goto tr17;
		case 43: goto tr17;
		case 45: goto tr17;
	}
	goto tr0;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
	switch( (*p) ) {
		case 9: goto st11;
		case 32: goto st11;
		case 41: goto tr18;
		case 43: goto tr18;
		case 45: goto tr18;
	}
	goto tr0;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
	switch( (*p) ) {
		case 80: goto st13;
		case 112: goto st13;
	}
	goto tr0;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	switch( (*p) ) {
		case 9: goto st13;
		case 32: goto st13;
		case 41: goto tr20;
	}
	goto tr0;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
	if ( (*p) == 42 )
		goto tr121;
	goto tr120;
st0:
cs = 0;
	goto _out;
tr56:
	{te = p+1;}
	{act = 155;}
	goto st27;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	switch( (*p) ) {
		case 66: goto tr123;
		case 72: goto tr23;
		case 88: goto st15;
		case 98: goto tr123;
		case 104: goto tr23;
		case 120: goto st15;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr57;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st14;
		} else if ( (*p) >= 65 )
			goto st14;
	} else
		goto tr58;
	goto tr122;
tr57:
	{te = p+1;}
	{act = 155;}
	goto st28;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
	switch( (*p) ) {
		case 66: goto tr125;
		case 72: goto tr23;
		case 98: goto tr125;
		case 104: goto tr23;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr57;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st14;
		} else if ( (*p) >= 65 )
			goto st14;
	} else
		goto tr58;
	goto tr122;
tr58:
	{te = p+1;}
	{act = 155;}
	goto st29;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	switch( (*p) ) {
		case 72: goto tr23;
		case 104: goto tr23;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr58;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st14;
	} else
		goto st14;
	goto tr122;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	switch( (*p) ) {
		case 72: goto tr23;
		case 104: goto tr23;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st14;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st14;
	} else
		goto st14;
	goto tr21;
tr125:
	{te = p+1;}
	{act = 159;}
	goto st30;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	switch( (*p) ) {
		case 72: goto tr23;
		case 104: goto tr23;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st14;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st14;
	} else
		goto st14;
	goto tr126;
tr123:
	{te = p+1;}
	{act = 159;}
	goto st31;
tr127:
	{te = p+1;}
	{act = 161;}
	goto st31;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	switch( (*p) ) {
		case 72: goto tr23;
		case 104: goto tr23;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr127;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st14;
		} else if ( (*p) >= 65 )
			goto st14;
	} else
		goto st14;
	goto tr21;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st32;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st32;
	} else
		goto st32;
	goto tr24;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st32;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st32;
	} else
		goto st32;
	goto tr128;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	if ( (*p) == 10 )
		goto tr129;
	goto st33;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
	switch( (*p) ) {
		case 60: goto tr131;
		case 61: goto tr132;
		case 62: goto tr133;
	}
	goto tr130;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( (*p) == 61 )
		goto tr135;
	goto tr134;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	switch( (*p) ) {
		case 61: goto tr137;
		case 62: goto tr138;
	}
	goto tr136;
tr65:
	{te = p+1;}
	goto st37;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
	if ( (*p) == 34 )
		goto st16;
	if ( 48 <= (*p) && (*p) <= 49 )
		goto st38;
	goto tr139;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
	switch( (*p) ) {
		case 35: goto st17;
		case 45: goto st17;
	}
	goto tr26;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
	switch( (*p) ) {
		case 34: goto tr28;
		case 35: goto st17;
		case 45: goto st17;
	}
	goto tr26;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
	if ( 48 <= (*p) && (*p) <= 49 )
		goto st38;
	goto tr142;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
	if ( (*p) == 124 )
		goto tr144;
	goto tr143;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
	switch( (*p) ) {
		case 68: goto st42;
		case 70: goto st43;
		case 78: goto st44;
		case 83: goto st45;
		case 95: goto tr81;
		case 100: goto st42;
		case 102: goto st43;
		case 110: goto st44;
		case 115: goto st45;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr145;
tr80:
	{te = p+1;}
	{act = 55;}
	goto st41;
tr81:
	{te = p+1;}
	{act = 153;}
	goto st41;
tr86:
	{te = p+1;}
	{act = 44;}
	goto st41;
tr93:
	{te = p+1;}
	{act = 38;}
	goto st41;
tr151:
	{te = p+1;}
	{act = 83;}
	goto st41;
tr152:
	{te = p+1;}
	{act = 84;}
	goto st41;
tr155:
	{te = p+1;}
	{act = 85;}
	goto st41;
tr158:
	{te = p+1;}
	{act = 1;}
	goto st41;
tr160:
	{te = p+1;}
	{act = 61;}
	goto st41;
tr162:
	{te = p+1;}
	{act = 86;}
	goto st41;
tr168:
	{te = p+1;}
	{act = 87;}
	goto st41;
tr169:
	{te = p+1;}
	{act = 88;}
	goto st41;
tr173:
	{te = p+1;}
	{act = 94;}
	goto st41;
tr175:
	{te = p+1;}
	{act = 91;}
	goto st41;
tr177:
	{te = p+1;}
	{act = 93;}
	goto st41;
tr181:
	{te = p+1;}
	{act = 97;}
	goto st41;
tr184:
	{te = p+1;}
	{act = 95;}
	goto st41;
tr186:
	{te = p+1;}
	{act = 96;}
	goto st41;
tr189:
	{te = p+1;}
	{act = 76;}
	goto st41;
tr194:
	{te = p+1;}
	{act = 75;}
	goto st41;
tr197:
	{te = p+1;}
	{act = 77;}
	goto st41;
tr199:
	{te = p+1;}
	{act = 98;}
	goto st41;
tr205:
	{te = p+1;}
	{act = 59;}
	goto st41;
tr207:
	{te = p+1;}
	{act = 101;}
	goto st41;
tr210:
	{te = p+1;}
	{act = 63;}
	goto st41;
tr212:
	{te = p+1;}
	{act = 102;}
	goto st41;
tr215:
	{te = p+1;}
	{act = 103;}
	goto st41;
tr219:
	{te = p+1;}
	{act = 57;}
	goto st41;
tr221:
	{te = p+1;}
	{act = 105;}
	goto st41;
tr225:
	{te = p+1;}
	{act = 107;}
	goto st41;
tr227:
	{te = p+1;}
	{act = 109;}
	goto st41;
tr229:
	{te = p+1;}
	{act = 49;}
	goto st41;
tr230:
	{te = p+1;}
	{act = 52;}
	goto st41;
tr232:
	{te = p+1;}
	{act = 50;}
	goto st41;
tr233:
	{te = p+1;}
	{act = 53;}
	goto st41;
tr234:
	{te = p+1;}
	{act = 110;}
	goto st41;
tr235:
	{te = p+1;}
	{act = 111;}
	goto st41;
tr242:
	{te = p+1;}
	{act = 114;}
	goto st41;
tr244:
	{te = p+1;}
	{act = 116;}
	goto st41;
tr245:
	{te = p+1;}
	{act = 39;}
	goto st41;
tr248:
	{te = p+1;}
	{act = 37;}
	goto st41;
tr249:
	{te = p+1;}
	{act = 117;}
	goto st41;
tr250:
	{te = p+1;}
	{act = 118;}
	goto st41;
tr255:
	{te = p+1;}
	{act = 78;}
	goto st41;
tr258:
	{te = p+1;}
	{act = 120;}
	goto st41;
tr259:
	{te = p+1;}
	{act = 121;}
	goto st41;
tr262:
	{te = p+1;}
	{act = 123;}
	goto st41;
tr263:
	{te = p+1;}
	{act = 124;}
	goto st41;
tr265:
	{te = p+1;}
	{act = 42;}
	goto st41;
tr269:
	{te = p+1;}
	{act = 125;}
	goto st41;
tr271:
	{te = p+1;}
	{act = 126;}
	goto st41;
tr277:
	{te = p+1;}
	{act = 127;}
	goto st41;
tr280:
	{te = p+1;}
	{act = 129;}
	goto st41;
tr281:
	{te = p+1;}
	{act = 130;}
	goto st41;
tr283:
	{te = p+1;}
	{act = 132;}
	goto st41;
tr285:
	{te = p+1;}
	{act = 135;}
	goto st41;
tr287:
	{te = p+1;}
	{act = 134;}
	goto st41;
tr289:
	{te = p+1;}
	{act = 137;}
	goto st41;
tr291:
	{te = p+1;}
	{act = 140;}
	goto st41;
tr293:
	{te = p+1;}
	{act = 139;}
	goto st41;
tr294:
	{te = p+1;}
	{act = 141;}
	goto st41;
tr299:
	{te = p+1;}
	{act = 67;}
	goto st41;
tr302:
	{te = p+1;}
	{act = 142;}
	goto st41;
tr303:
	{te = p+1;}
	{act = 143;}
	goto st41;
tr304:
	{te = p+1;}
	{act = 144;}
	goto st41;
tr305:
	{te = p+1;}
	{act = 145;}
	goto st41;
tr306:
	{te = p+1;}
	{act = 146;}
	goto st41;
tr307:
	{te = p+1;}
	{act = 147;}
	goto st41;
tr308:
	{te = p+1;}
	{act = 148;}
	goto st41;
tr309:
	{te = p+1;}
	{act = 149;}
	goto st41;
tr311:
	{te = p+1;}
	{act = 150;}
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
	if ( (*p) == 95 )
		goto tr81;
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr21;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
	switch( (*p) ) {
		case 67: goto tr151;
		case 68: goto tr152;
		case 95: goto tr81;
		case 99: goto tr151;
		case 100: goto tr152;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
	switch( (*p) ) {
		case 39: goto tr154;
		case 95: goto tr81;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr153;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
	switch( (*p) ) {
		case 68: goto tr155;
		case 95: goto tr81;
		case 100: goto tr155;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
	switch( (*p) ) {
		case 77: goto st46;
		case 95: goto tr81;
		case 109: goto st46;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
	switch( (*p) ) {
		case 80: goto st47;
		case 95: goto tr81;
		case 112: goto st47;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
	switch( (*p) ) {
		case 67: goto tr158;
		case 95: goto tr81;
		case 99: goto tr158;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	switch( (*p) ) {
		case 67: goto tr160;
		case 73: goto st49;
		case 95: goto tr81;
		case 99: goto tr160;
		case 105: goto st49;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr159;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	switch( (*p) ) {
		case 84: goto tr162;
		case 95: goto tr81;
		case 116: goto tr162;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st50:
	if ( ++p == pe )
		goto _test_eof50;
case 50:
	switch( (*p) ) {
		case 65: goto st51;
		case 67: goto st53;
		case 80: goto st54;
		case 95: goto tr81;
		case 97: goto st51;
		case 99: goto st53;
		case 112: goto st54;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr163;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	switch( (*p) ) {
		case 76: goto st52;
		case 95: goto tr81;
		case 108: goto st52;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
	switch( (*p) ) {
		case 76: goto tr168;
		case 95: goto tr81;
		case 108: goto tr168;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st53:
	if ( ++p == pe )
		goto _test_eof53;
case 53:
	switch( (*p) ) {
		case 70: goto tr169;
		case 95: goto tr81;
		case 102: goto tr169;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st54:
	if ( ++p == pe )
		goto _test_eof54;
case 54:
	switch( (*p) ) {
		case 68: goto st55;
		case 73: goto st56;
		case 76: goto tr173;
		case 95: goto tr81;
		case 100: goto st55;
		case 105: goto st56;
		case 108: goto tr173;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr170;
st55:
	if ( ++p == pe )
		goto _test_eof55;
case 55:
	switch( (*p) ) {
		case 82: goto tr175;
		case 95: goto tr81;
		case 114: goto tr175;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr174;
st56:
	if ( ++p == pe )
		goto _test_eof56;
case 56:
	switch( (*p) ) {
		case 82: goto tr177;
		case 95: goto tr81;
		case 114: goto tr177;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr176;
st57:
	if ( ++p == pe )
		goto _test_eof57;
case 57:
	switch( (*p) ) {
		case 65: goto st58;
		case 69: goto st59;
		case 73: goto tr181;
		case 74: goto st68;
		case 83: goto tr183;
		case 95: goto tr81;
		case 97: goto st58;
		case 101: goto st59;
		case 105: goto tr181;
		case 106: goto st68;
		case 115: goto tr183;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr178;
st58:
	if ( ++p == pe )
		goto _test_eof58;
case 58:
	switch( (*p) ) {
		case 65: goto tr184;
		case 95: goto tr81;
		case 97: goto tr184;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st59:
	if ( ++p == pe )
		goto _test_eof59;
case 59:
	switch( (*p) ) {
		case 67: goto tr186;
		case 70: goto st60;
		case 95: goto tr81;
		case 99: goto tr186;
		case 102: goto st60;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr185;
st60:
	if ( ++p == pe )
		goto _test_eof60;
case 60:
	switch( (*p) ) {
		case 71: goto st61;
		case 83: goto tr189;
		case 86: goto st65;
		case 95: goto tr81;
		case 103: goto st61;
		case 115: goto tr189;
		case 118: goto st65;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st61:
	if ( ++p == pe )
		goto _test_eof61;
case 61:
	switch( (*p) ) {
		case 82: goto st62;
		case 95: goto tr81;
		case 114: goto st62;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st62:
	if ( ++p == pe )
		goto _test_eof62;
case 62:
	switch( (*p) ) {
		case 79: goto st63;
		case 95: goto tr81;
		case 111: goto st63;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st63:
	if ( ++p == pe )
		goto _test_eof63;
case 63:
	switch( (*p) ) {
		case 85: goto st64;
		case 95: goto tr81;
		case 117: goto st64;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st64:
	if ( ++p == pe )
		goto _test_eof64;
case 64:
	switch( (*p) ) {
		case 80: goto tr194;
		case 95: goto tr81;
		case 112: goto tr194;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st65:
	if ( ++p == pe )
		goto _test_eof65;
case 65:
	switch( (*p) ) {
		case 65: goto st66;
		case 95: goto tr81;
		case 97: goto st66;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st66:
	if ( ++p == pe )
		goto _test_eof66;
case 66:
	switch( (*p) ) {
		case 82: goto st67;
		case 95: goto tr81;
		case 114: goto st67;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st67:
	if ( ++p == pe )
		goto _test_eof67;
case 67:
	switch( (*p) ) {
		case 83: goto tr197;
		case 95: goto tr81;
		case 115: goto tr197;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st68:
	if ( ++p == pe )
		goto _test_eof68;
case 68:
	switch( (*p) ) {
		case 78: goto st69;
		case 95: goto tr81;
		case 110: goto st69;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st69:
	if ( ++p == pe )
		goto _test_eof69;
case 69:
	switch( (*p) ) {
		case 90: goto tr199;
		case 95: goto tr81;
		case 122: goto tr199;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
tr183:
	{te = p+1;}
	goto st70;
st70:
	if ( ++p == pe )
		goto _test_eof70;
case 70:
	switch( (*p) ) {
		case 46: goto st18;
		case 95: goto tr81;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
	switch( (*p) ) {
		case 66: goto tr30;
		case 76: goto tr31;
		case 80: goto tr32;
		case 87: goto tr33;
		case 98: goto tr30;
		case 108: goto tr31;
		case 112: goto tr32;
		case 119: goto tr33;
	}
	goto tr29;
st71:
	if ( ++p == pe )
		goto _test_eof71;
case 71:
	switch( (*p) ) {
		case 73: goto st72;
		case 88: goto st73;
		case 95: goto tr81;
		case 105: goto st72;
		case 120: goto st73;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr201;
st72:
	if ( ++p == pe )
		goto _test_eof72;
case 72:
	switch( (*p) ) {
		case 82: goto tr205;
		case 95: goto tr81;
		case 114: goto tr205;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr204;
st73:
	if ( ++p == pe )
		goto _test_eof73;
case 73:
	switch( (*p) ) {
		case 88: goto tr207;
		case 95: goto tr81;
		case 120: goto tr207;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr206;
st74:
	if ( ++p == pe )
		goto _test_eof74;
case 74:
	switch( (*p) ) {
		case 65: goto st75;
		case 76: goto tr210;
		case 95: goto tr81;
		case 97: goto st75;
		case 108: goto tr210;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr208;
st75:
	if ( ++p == pe )
		goto _test_eof75;
case 75:
	switch( (*p) ) {
		case 76: goto st76;
		case 95: goto tr81;
		case 108: goto st76;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st76:
	if ( ++p == pe )
		goto _test_eof76;
case 76:
	switch( (*p) ) {
		case 84: goto tr212;
		case 95: goto tr81;
		case 116: goto tr212;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st77:
	if ( ++p == pe )
		goto _test_eof77;
case 77:
	switch( (*p) ) {
		case 73: goto st78;
		case 77: goto tr215;
		case 78: goto st79;
		case 88: goto st82;
		case 89: goto st83;
		case 95: goto tr81;
		case 105: goto st78;
		case 109: goto tr215;
		case 110: goto st79;
		case 120: goto st82;
		case 121: goto st83;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr213;
st78:
	if ( ++p == pe )
		goto _test_eof78;
case 78:
	switch( (*p) ) {
		case 82: goto tr219;
		case 95: goto tr81;
		case 114: goto tr219;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st79:
	if ( ++p == pe )
		goto _test_eof79;
case 79:
	switch( (*p) ) {
		case 67: goto tr221;
		case 68: goto st80;
		case 73: goto st81;
		case 95: goto tr81;
		case 99: goto tr221;
		case 100: goto st80;
		case 105: goto st81;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr220;
st80:
	if ( ++p == pe )
		goto _test_eof80;
case 80:
	switch( (*p) ) {
		case 82: goto tr225;
		case 95: goto tr81;
		case 114: goto tr225;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr224;
st81:
	if ( ++p == pe )
		goto _test_eof81;
case 81:
	switch( (*p) ) {
		case 82: goto tr227;
		case 95: goto tr81;
		case 114: goto tr227;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr226;
st82:
	if ( ++p == pe )
		goto _test_eof82;
case 82:
	switch( (*p) ) {
		case 72: goto tr229;
		case 76: goto tr230;
		case 95: goto tr81;
		case 104: goto tr229;
		case 108: goto tr230;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr228;
st83:
	if ( ++p == pe )
		goto _test_eof83;
case 83:
	switch( (*p) ) {
		case 72: goto tr232;
		case 76: goto tr233;
		case 95: goto tr81;
		case 104: goto tr232;
		case 108: goto tr233;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr231;
st84:
	if ( ++p == pe )
		goto _test_eof84;
case 84:
	switch( (*p) ) {
		case 80: goto tr234;
		case 82: goto tr235;
		case 95: goto tr81;
		case 112: goto tr234;
		case 114: goto tr235;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st85:
	if ( ++p == pe )
		goto _test_eof85;
case 85:
	switch( (*p) ) {
		case 68: goto st86;
		case 95: goto tr81;
		case 100: goto st86;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr236;
st86:
	if ( ++p == pe )
		goto _test_eof86;
case 86:
	switch( (*p) ) {
		case 68: goto st87;
		case 73: goto st88;
		case 95: goto tr81;
		case 100: goto st87;
		case 105: goto st88;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr238;
st87:
	if ( ++p == pe )
		goto _test_eof87;
case 87:
	switch( (*p) ) {
		case 82: goto tr242;
		case 95: goto tr81;
		case 114: goto tr242;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr241;
st88:
	if ( ++p == pe )
		goto _test_eof88;
case 88:
	switch( (*p) ) {
		case 82: goto tr244;
		case 95: goto tr81;
		case 114: goto tr244;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr243;
st89:
	if ( ++p == pe )
		goto _test_eof89;
case 89:
	switch( (*p) ) {
		case 67: goto tr245;
		case 69: goto st90;
		case 79: goto st91;
		case 90: goto tr248;
		case 95: goto tr81;
		case 99: goto tr245;
		case 101: goto st90;
		case 111: goto st91;
		case 122: goto tr248;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st90:
	if ( ++p == pe )
		goto _test_eof90;
case 90:
	switch( (*p) ) {
		case 71: goto tr249;
		case 95: goto tr81;
		case 103: goto tr249;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st91:
	if ( ++p == pe )
		goto _test_eof91;
case 91:
	switch( (*p) ) {
		case 80: goto tr250;
		case 95: goto tr81;
		case 112: goto tr250;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st92:
	if ( ++p == pe )
		goto _test_eof92;
case 92:
	switch( (*p) ) {
		case 82: goto st93;
		case 84: goto st94;
		case 85: goto st97;
		case 95: goto tr81;
		case 114: goto st93;
		case 116: goto st94;
		case 117: goto st97;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st93:
	if ( ++p == pe )
		goto _test_eof93;
case 93:
	switch( (*p) ) {
		case 71: goto tr255;
		case 95: goto tr81;
		case 103: goto tr255;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr254;
st94:
	if ( ++p == pe )
		goto _test_eof94;
case 94:
	switch( (*p) ) {
		case 68: goto st95;
		case 73: goto st96;
		case 95: goto tr81;
		case 100: goto st95;
		case 105: goto st96;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st95:
	if ( ++p == pe )
		goto _test_eof95;
case 95:
	switch( (*p) ) {
		case 82: goto tr258;
		case 95: goto tr81;
		case 114: goto tr258;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st96:
	if ( ++p == pe )
		goto _test_eof96;
case 96:
	switch( (*p) ) {
		case 82: goto tr259;
		case 95: goto tr81;
		case 114: goto tr259;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st97:
	if ( ++p == pe )
		goto _test_eof97;
case 97:
	switch( (*p) ) {
		case 84: goto st98;
		case 95: goto tr81;
		case 116: goto st98;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st98:
	if ( ++p == pe )
		goto _test_eof98;
case 98:
	switch( (*p) ) {
		case 68: goto tr262;
		case 73: goto tr263;
		case 95: goto tr81;
		case 100: goto tr262;
		case 105: goto tr263;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr261;
st99:
	if ( ++p == pe )
		goto _test_eof99;
case 99:
	switch( (*p) ) {
		case 69: goto tr265;
		case 79: goto st100;
		case 85: goto st101;
		case 95: goto tr81;
		case 101: goto tr265;
		case 111: goto st100;
		case 117: goto st101;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr264;
st100:
	if ( ++p == pe )
		goto _test_eof100;
case 100:
	switch( (*p) ) {
		case 80: goto tr269;
		case 95: goto tr81;
		case 112: goto tr269;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr268;
st101:
	if ( ++p == pe )
		goto _test_eof101;
case 101:
	switch( (*p) ) {
		case 83: goto st102;
		case 95: goto tr81;
		case 115: goto st102;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st102:
	if ( ++p == pe )
		goto _test_eof102;
case 102:
	switch( (*p) ) {
		case 72: goto tr271;
		case 95: goto tr81;
		case 104: goto tr271;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st103:
	if ( ++p == pe )
		goto _test_eof103;
case 103:
	switch( (*p) ) {
		case 69: goto st104;
		case 76: goto st106;
		case 82: goto st108;
		case 83: goto st110;
		case 95: goto tr81;
		case 101: goto st104;
		case 108: goto st106;
		case 114: goto st108;
		case 115: goto st110;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr272;
st104:
	if ( ++p == pe )
		goto _test_eof104;
case 104:
	switch( (*p) ) {
		case 83: goto tr277;
		case 84: goto st105;
		case 95: goto tr81;
		case 115: goto tr277;
		case 116: goto st105;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st105:
	if ( ++p == pe )
		goto _test_eof105;
case 105:
	switch( (*p) ) {
		case 73: goto tr280;
		case 78: goto tr281;
		case 95: goto tr81;
		case 105: goto tr280;
		case 110: goto tr281;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr279;
st106:
	if ( ++p == pe )
		goto _test_eof106;
case 106:
	switch( (*p) ) {
		case 65: goto tr283;
		case 67: goto st107;
		case 68: goto tr285;
		case 95: goto tr81;
		case 97: goto tr283;
		case 99: goto st107;
		case 100: goto tr285;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr282;
st107:
	if ( ++p == pe )
		goto _test_eof107;
case 107:
	switch( (*p) ) {
		case 65: goto tr287;
		case 95: goto tr81;
		case 97: goto tr287;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr286;
st108:
	if ( ++p == pe )
		goto _test_eof108;
case 108:
	switch( (*p) ) {
		case 65: goto tr289;
		case 67: goto st109;
		case 68: goto tr291;
		case 95: goto tr81;
		case 97: goto tr289;
		case 99: goto st109;
		case 100: goto tr291;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr288;
st109:
	if ( ++p == pe )
		goto _test_eof109;
case 109:
	switch( (*p) ) {
		case 65: goto tr293;
		case 95: goto tr81;
		case 97: goto tr293;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr292;
st110:
	if ( ++p == pe )
		goto _test_eof110;
case 110:
	switch( (*p) ) {
		case 84: goto tr294;
		case 95: goto tr81;
		case 116: goto tr294;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st111:
	if ( ++p == pe )
		goto _test_eof111;
case 111:
	switch( (*p) ) {
		case 66: goto st112;
		case 67: goto st113;
		case 69: goto st114;
		case 76: goto st115;
		case 80: goto tr299;
		case 82: goto st116;
		case 85: goto st117;
		case 95: goto tr81;
		case 98: goto st112;
		case 99: goto st113;
		case 101: goto st114;
		case 108: goto st115;
		case 112: goto tr299;
		case 114: goto st116;
		case 117: goto st117;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st112:
	if ( ++p == pe )
		goto _test_eof112;
case 112:
	switch( (*p) ) {
		case 67: goto tr302;
		case 95: goto tr81;
		case 99: goto tr302;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st113:
	if ( ++p == pe )
		goto _test_eof113;
case 113:
	switch( (*p) ) {
		case 70: goto tr303;
		case 95: goto tr81;
		case 102: goto tr303;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st114:
	if ( ++p == pe )
		goto _test_eof114;
case 114:
	switch( (*p) ) {
		case 84: goto tr304;
		case 95: goto tr81;
		case 116: goto tr304;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st115:
	if ( ++p == pe )
		goto _test_eof115;
case 115:
	switch( (*p) ) {
		case 65: goto tr305;
		case 76: goto tr306;
		case 95: goto tr81;
		case 97: goto tr305;
		case 108: goto tr306;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st116:
	if ( ++p == pe )
		goto _test_eof116;
case 116:
	switch( (*p) ) {
		case 65: goto tr307;
		case 76: goto tr308;
		case 95: goto tr81;
		case 97: goto tr307;
		case 108: goto tr308;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st117:
	if ( ++p == pe )
		goto _test_eof117;
case 117:
	switch( (*p) ) {
		case 66: goto tr309;
		case 95: goto tr81;
		case 98: goto tr309;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st118:
	if ( ++p == pe )
		goto _test_eof118;
case 118:
	switch( (*p) ) {
		case 79: goto st119;
		case 95: goto tr81;
		case 111: goto st119;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
st119:
	if ( ++p == pe )
		goto _test_eof119;
case 119:
	switch( (*p) ) {
		case 82: goto tr311;
		case 95: goto tr81;
		case 114: goto tr311;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr81;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr81;
	} else
		goto tr81;
	goto tr150;
tr94:
	{te = p+1;}
	goto st120;
st120:
	if ( ++p == pe )
		goto _test_eof120;
case 120:
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( (*p) > 9 ) {
			if ( 32 <= (*p) && (*p) <= 32 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 9 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st19;
		case 544: goto st19;
		case 607: goto st121;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st121;
	} else if ( _widec >= 577 )
		goto st121;
	goto tr312;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( (*p) > 9 ) {
			if ( 32 <= (*p) && (*p) <= 32 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 9 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st19;
		case 544: goto st19;
		case 607: goto st121;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st121;
	} else if ( _widec >= 577 )
		goto st121;
	goto tr34;
st121:
	if ( ++p == pe )
		goto _test_eof121;
case 121:
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	if ( _widec == 607 )
		goto st121;
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st121;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st121;
	} else
		goto st121;
	goto tr313;
tr95:
	{te = p+1;}
	{act = 54;}
	goto st122;
st122:
	if ( ++p == pe )
		goto _test_eof122;
case 122:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto st42;
		case 326: goto st43;
		case 334: goto st44;
		case 339: goto st45;
		case 351: goto tr81;
		case 356: goto st42;
		case 358: goto st43;
		case 366: goto st44;
		case 371: goto st45;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr314;
		case 582: goto tr315;
		case 590: goto tr316;
		case 595: goto tr317;
		case 607: goto tr101;
		case 612: goto tr314;
		case 614: goto tr315;
		case 622: goto tr316;
		case 627: goto tr317;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr145;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
	_widec = (*p);
	if ( (*p) < 32 ) {
		if ( 9 <= (*p) && (*p) <= 9 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 32 ) {
		if ( 58 <= (*p) && (*p) <= 58 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
	}
	goto tr21;
tr100:
	{te = p+1;}
	{act = 55;}
	goto st123;
tr101:
	{te = p+1;}
	{act = 153;}
	goto st123;
tr106:
	{te = p+1;}
	{act = 44;}
	goto st123;
tr113:
	{te = p+1;}
	{act = 38;}
	goto st123;
tr318:
	{te = p+1;}
	{act = 83;}
	goto st123;
tr319:
	{te = p+1;}
	{act = 84;}
	goto st123;
tr320:
	{te = p+1;}
	{act = 85;}
	goto st123;
tr323:
	{te = p+1;}
	{act = 1;}
	goto st123;
tr324:
	{te = p+1;}
	{act = 61;}
	goto st123;
tr326:
	{te = p+1;}
	{act = 86;}
	goto st123;
tr331:
	{te = p+1;}
	{act = 87;}
	goto st123;
tr332:
	{te = p+1;}
	{act = 88;}
	goto st123;
tr335:
	{te = p+1;}
	{act = 94;}
	goto st123;
tr336:
	{te = p+1;}
	{act = 91;}
	goto st123;
tr337:
	{te = p+1;}
	{act = 93;}
	goto st123;
tr340:
	{te = p+1;}
	{act = 97;}
	goto st123;
tr343:
	{te = p+1;}
	{act = 95;}
	goto st123;
tr344:
	{te = p+1;}
	{act = 96;}
	goto st123;
tr347:
	{te = p+1;}
	{act = 76;}
	goto st123;
tr352:
	{te = p+1;}
	{act = 75;}
	goto st123;
tr355:
	{te = p+1;}
	{act = 77;}
	goto st123;
tr357:
	{te = p+1;}
	{act = 98;}
	goto st123;
tr360:
	{te = p+1;}
	{act = 59;}
	goto st123;
tr361:
	{te = p+1;}
	{act = 101;}
	goto st123;
tr363:
	{te = p+1;}
	{act = 63;}
	goto st123;
tr365:
	{te = p+1;}
	{act = 102;}
	goto st123;
tr367:
	{te = p+1;}
	{act = 103;}
	goto st123;
tr371:
	{te = p+1;}
	{act = 57;}
	goto st123;
tr372:
	{te = p+1;}
	{act = 105;}
	goto st123;
tr375:
	{te = p+1;}
	{act = 107;}
	goto st123;
tr376:
	{te = p+1;}
	{act = 109;}
	goto st123;
tr377:
	{te = p+1;}
	{act = 49;}
	goto st123;
tr378:
	{te = p+1;}
	{act = 52;}
	goto st123;
tr379:
	{te = p+1;}
	{act = 50;}
	goto st123;
tr380:
	{te = p+1;}
	{act = 53;}
	goto st123;
tr381:
	{te = p+1;}
	{act = 110;}
	goto st123;
tr382:
	{te = p+1;}
	{act = 111;}
	goto st123;
tr386:
	{te = p+1;}
	{act = 114;}
	goto st123;
tr387:
	{te = p+1;}
	{act = 116;}
	goto st123;
tr388:
	{te = p+1;}
	{act = 39;}
	goto st123;
tr391:
	{te = p+1;}
	{act = 37;}
	goto st123;
tr392:
	{te = p+1;}
	{act = 117;}
	goto st123;
tr393:
	{te = p+1;}
	{act = 118;}
	goto st123;
tr397:
	{te = p+1;}
	{act = 78;}
	goto st123;
tr400:
	{te = p+1;}
	{act = 120;}
	goto st123;
tr401:
	{te = p+1;}
	{act = 121;}
	goto st123;
tr403:
	{te = p+1;}
	{act = 123;}
	goto st123;
tr404:
	{te = p+1;}
	{act = 124;}
	goto st123;
tr405:
	{te = p+1;}
	{act = 42;}
	goto st123;
tr408:
	{te = p+1;}
	{act = 125;}
	goto st123;
tr410:
	{te = p+1;}
	{act = 126;}
	goto st123;
tr415:
	{te = p+1;}
	{act = 127;}
	goto st123;
tr417:
	{te = p+1;}
	{act = 129;}
	goto st123;
tr418:
	{te = p+1;}
	{act = 130;}
	goto st123;
tr419:
	{te = p+1;}
	{act = 132;}
	goto st123;
tr421:
	{te = p+1;}
	{act = 135;}
	goto st123;
tr422:
	{te = p+1;}
	{act = 134;}
	goto st123;
tr423:
	{te = p+1;}
	{act = 137;}
	goto st123;
tr425:
	{te = p+1;}
	{act = 140;}
	goto st123;
tr426:
	{te = p+1;}
	{act = 139;}
	goto st123;
tr427:
	{te = p+1;}
	{act = 141;}
	goto st123;
tr432:
	{te = p+1;}
	{act = 67;}
	goto st123;
tr435:
	{te = p+1;}
	{act = 142;}
	goto st123;
tr436:
	{te = p+1;}
	{act = 143;}
	goto st123;
tr437:
	{te = p+1;}
	{act = 144;}
	goto st123;
tr438:
	{te = p+1;}
	{act = 145;}
	goto st123;
tr439:
	{te = p+1;}
	{act = 146;}
	goto st123;
tr440:
	{te = p+1;}
	{act = 147;}
	goto st123;
tr441:
	{te = p+1;}
	{act = 148;}
	goto st123;
tr442:
	{te = p+1;}
	{act = 149;}
	goto st123;
tr444:
	{te = p+1;}
	{act = 150;}
	goto st123;
st123:
	if ( ++p == pe )
		goto _test_eof123;
case 123:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 351: goto tr81;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 607: goto tr101;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr21;
tr314:
	{te = p+1;}
	{act = 153;}
	goto st124;
st124:
	if ( ++p == pe )
		goto _test_eof124;
case 124:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr151;
		case 324: goto tr152;
		case 351: goto tr81;
		case 355: goto tr151;
		case 356: goto tr152;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr318;
		case 580: goto tr319;
		case 607: goto tr101;
		case 611: goto tr318;
		case 612: goto tr319;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr315:
	{te = p+1;}
	{act = 66;}
	goto st125;
st125:
	if ( ++p == pe )
		goto _test_eof125;
case 125:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 39: goto tr154;
		case 351: goto tr81;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 607: goto tr101;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr153;
tr316:
	{te = p+1;}
	{act = 153;}
	goto st126;
st126:
	if ( ++p == pe )
		goto _test_eof126;
case 126:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto tr155;
		case 351: goto tr81;
		case 356: goto tr155;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr320;
		case 607: goto tr101;
		case 612: goto tr320;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr317:
	{te = p+1;}
	{act = 153;}
	goto st127;
st127:
	if ( ++p == pe )
		goto _test_eof127;
case 127:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 333: goto st46;
		case 351: goto tr81;
		case 365: goto st46;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 589: goto tr321;
		case 607: goto tr101;
		case 621: goto tr321;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr321:
	{te = p+1;}
	{act = 153;}
	goto st128;
st128:
	if ( ++p == pe )
		goto _test_eof128;
case 128:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 336: goto st47;
		case 351: goto tr81;
		case 368: goto st47;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 592: goto tr322;
		case 607: goto tr101;
		case 624: goto tr322;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr322:
	{te = p+1;}
	{act = 153;}
	goto st129;
st129:
	if ( ++p == pe )
		goto _test_eof129;
case 129:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr158;
		case 351: goto tr81;
		case 355: goto tr158;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr323;
		case 607: goto tr101;
		case 611: goto tr323;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr96:
	{te = p+1;}
	{act = 45;}
	goto st130;
st130:
	if ( ++p == pe )
		goto _test_eof130;
case 130:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr160;
		case 329: goto st49;
		case 351: goto tr81;
		case 355: goto tr160;
		case 361: goto st49;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr324;
		case 585: goto tr325;
		case 607: goto tr101;
		case 611: goto tr324;
		case 617: goto tr325;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr159;
tr325:
	{te = p+1;}
	{act = 153;}
	goto st131;
st131:
	if ( ++p == pe )
		goto _test_eof131;
case 131:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 340: goto tr162;
		case 351: goto tr81;
		case 372: goto tr162;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 596: goto tr326;
		case 607: goto tr101;
		case 628: goto tr326;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr97:
	{te = p+1;}
	{act = 40;}
	goto st132;
st132:
	if ( ++p == pe )
		goto _test_eof132;
case 132:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto st51;
		case 323: goto st53;
		case 336: goto st54;
		case 351: goto tr81;
		case 353: goto st51;
		case 355: goto st53;
		case 368: goto st54;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr327;
		case 579: goto tr328;
		case 592: goto tr329;
		case 607: goto tr101;
		case 609: goto tr327;
		case 611: goto tr328;
		case 624: goto tr329;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr163;
tr327:
	{te = p+1;}
	{act = 153;}
	goto st133;
st133:
	if ( ++p == pe )
		goto _test_eof133;
case 133:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 332: goto st52;
		case 351: goto tr81;
		case 364: goto st52;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 588: goto tr330;
		case 607: goto tr101;
		case 620: goto tr330;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr330:
	{te = p+1;}
	{act = 153;}
	goto st134;
st134:
	if ( ++p == pe )
		goto _test_eof134;
case 134:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 332: goto tr168;
		case 351: goto tr81;
		case 364: goto tr168;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 588: goto tr331;
		case 607: goto tr101;
		case 620: goto tr331;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr328:
	{te = p+1;}
	{act = 153;}
	goto st135;
st135:
	if ( ++p == pe )
		goto _test_eof135;
case 135:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 326: goto tr169;
		case 351: goto tr81;
		case 358: goto tr169;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 582: goto tr332;
		case 607: goto tr101;
		case 614: goto tr332;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr329:
	{te = p+1;}
	{act = 89;}
	goto st136;
st136:
	if ( ++p == pe )
		goto _test_eof136;
case 136:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto st55;
		case 329: goto st56;
		case 332: goto tr173;
		case 351: goto tr81;
		case 356: goto st55;
		case 361: goto st56;
		case 364: goto tr173;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr333;
		case 585: goto tr334;
		case 588: goto tr335;
		case 607: goto tr101;
		case 612: goto tr333;
		case 617: goto tr334;
		case 620: goto tr335;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr170;
tr333:
	{te = p+1;}
	{act = 90;}
	goto st137;
st137:
	if ( ++p == pe )
		goto _test_eof137;
case 137:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr175;
		case 351: goto tr81;
		case 370: goto tr175;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr336;
		case 607: goto tr101;
		case 626: goto tr336;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr174;
tr334:
	{te = p+1;}
	{act = 92;}
	goto st138;
st138:
	if ( ++p == pe )
		goto _test_eof138;
case 138:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr177;
		case 351: goto tr81;
		case 370: goto tr177;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr337;
		case 607: goto tr101;
		case 626: goto tr337;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr176;
tr98:
	{te = p+1;}
	{act = 46;}
	goto st139;
st139:
	if ( ++p == pe )
		goto _test_eof139;
case 139:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto st58;
		case 325: goto st59;
		case 329: goto tr181;
		case 330: goto st68;
		case 339: goto tr183;
		case 351: goto tr81;
		case 353: goto st58;
		case 357: goto st59;
		case 361: goto tr181;
		case 362: goto st68;
		case 371: goto tr183;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr338;
		case 581: goto tr339;
		case 585: goto tr340;
		case 586: goto tr341;
		case 595: goto tr342;
		case 607: goto tr101;
		case 609: goto tr338;
		case 613: goto tr339;
		case 617: goto tr340;
		case 618: goto tr341;
		case 627: goto tr342;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr178;
tr338:
	{te = p+1;}
	{act = 153;}
	goto st140;
st140:
	if ( ++p == pe )
		goto _test_eof140;
case 140:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr184;
		case 351: goto tr81;
		case 353: goto tr184;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr343;
		case 607: goto tr101;
		case 609: goto tr343;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr339:
	{te = p+1;}
	{act = 62;}
	goto st141;
st141:
	if ( ++p == pe )
		goto _test_eof141;
case 141:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr186;
		case 326: goto st60;
		case 351: goto tr81;
		case 355: goto tr186;
		case 358: goto st60;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr344;
		case 582: goto tr345;
		case 607: goto tr101;
		case 611: goto tr344;
		case 614: goto tr345;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr185;
tr345:
	{te = p+1;}
	{act = 153;}
	goto st142;
st142:
	if ( ++p == pe )
		goto _test_eof142;
case 142:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 327: goto st61;
		case 339: goto tr189;
		case 342: goto st65;
		case 351: goto tr81;
		case 359: goto st61;
		case 371: goto tr189;
		case 374: goto st65;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 583: goto tr346;
		case 595: goto tr347;
		case 598: goto tr348;
		case 607: goto tr101;
		case 615: goto tr346;
		case 627: goto tr347;
		case 630: goto tr348;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr346:
	{te = p+1;}
	{act = 153;}
	goto st143;
st143:
	if ( ++p == pe )
		goto _test_eof143;
case 143:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto st62;
		case 351: goto tr81;
		case 370: goto st62;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr349;
		case 607: goto tr101;
		case 626: goto tr349;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr349:
	{te = p+1;}
	{act = 153;}
	goto st144;
st144:
	if ( ++p == pe )
		goto _test_eof144;
case 144:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 335: goto st63;
		case 351: goto tr81;
		case 367: goto st63;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 591: goto tr350;
		case 607: goto tr101;
		case 623: goto tr350;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr350:
	{te = p+1;}
	{act = 153;}
	goto st145;
st145:
	if ( ++p == pe )
		goto _test_eof145;
case 145:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 341: goto st64;
		case 351: goto tr81;
		case 373: goto st64;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 597: goto tr351;
		case 607: goto tr101;
		case 629: goto tr351;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr351:
	{te = p+1;}
	{act = 153;}
	goto st146;
st146:
	if ( ++p == pe )
		goto _test_eof146;
case 146:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 336: goto tr194;
		case 351: goto tr81;
		case 368: goto tr194;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 592: goto tr352;
		case 607: goto tr101;
		case 624: goto tr352;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr348:
	{te = p+1;}
	{act = 153;}
	goto st147;
st147:
	if ( ++p == pe )
		goto _test_eof147;
case 147:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto st66;
		case 351: goto tr81;
		case 353: goto st66;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr353;
		case 607: goto tr101;
		case 609: goto tr353;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr353:
	{te = p+1;}
	{act = 153;}
	goto st148;
st148:
	if ( ++p == pe )
		goto _test_eof148;
case 148:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto st67;
		case 351: goto tr81;
		case 370: goto st67;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr354;
		case 607: goto tr101;
		case 626: goto tr354;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr354:
	{te = p+1;}
	{act = 153;}
	goto st149;
st149:
	if ( ++p == pe )
		goto _test_eof149;
case 149:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 339: goto tr197;
		case 351: goto tr81;
		case 371: goto tr197;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 595: goto tr355;
		case 607: goto tr101;
		case 627: goto tr355;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr341:
	{te = p+1;}
	{act = 153;}
	goto st150;
st150:
	if ( ++p == pe )
		goto _test_eof150;
case 150:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 334: goto st69;
		case 351: goto tr81;
		case 366: goto st69;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 590: goto tr356;
		case 607: goto tr101;
		case 622: goto tr356;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr356:
	{te = p+1;}
	{act = 153;}
	goto st151;
st151:
	if ( ++p == pe )
		goto _test_eof151;
case 151:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 346: goto tr199;
		case 351: goto tr81;
		case 378: goto tr199;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 602: goto tr357;
		case 607: goto tr101;
		case 634: goto tr357;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 377 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 601 ) {
			if ( 609 <= _widec && _widec <= 633 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr342:
	{te = p+1;}
	{act = 153;}
	goto st152;
st152:
	if ( ++p == pe )
		goto _test_eof152;
case 152:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 46: goto st18;
		case 351: goto tr81;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 607: goto tr101;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr99:
	{te = p+1;}
	{act = 47;}
	goto st153;
st153:
	if ( ++p == pe )
		goto _test_eof153;
case 153:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 329: goto st72;
		case 344: goto st73;
		case 351: goto tr81;
		case 361: goto st72;
		case 376: goto st73;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 585: goto tr358;
		case 600: goto tr359;
		case 607: goto tr101;
		case 617: goto tr358;
		case 632: goto tr359;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr201;
tr358:
	{te = p+1;}
	{act = 99;}
	goto st154;
st154:
	if ( ++p == pe )
		goto _test_eof154;
case 154:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr205;
		case 351: goto tr81;
		case 370: goto tr205;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr360;
		case 607: goto tr101;
		case 626: goto tr360;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr204;
tr359:
	{te = p+1;}
	{act = 100;}
	goto st155;
st155:
	if ( ++p == pe )
		goto _test_eof155;
case 155:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 344: goto tr207;
		case 351: goto tr81;
		case 376: goto tr207;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 600: goto tr361;
		case 607: goto tr101;
		case 632: goto tr361;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr206;
tr102:
	{te = p+1;}
	{act = 48;}
	goto st156;
st156:
	if ( ++p == pe )
		goto _test_eof156;
case 156:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto st75;
		case 332: goto tr210;
		case 351: goto tr81;
		case 353: goto st75;
		case 364: goto tr210;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr362;
		case 588: goto tr363;
		case 607: goto tr101;
		case 609: goto tr362;
		case 620: goto tr363;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr208;
tr362:
	{te = p+1;}
	{act = 153;}
	goto st157;
st157:
	if ( ++p == pe )
		goto _test_eof157;
case 157:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 332: goto st76;
		case 351: goto tr81;
		case 364: goto st76;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 588: goto tr364;
		case 607: goto tr101;
		case 620: goto tr364;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr364:
	{te = p+1;}
	{act = 153;}
	goto st158;
st158:
	if ( ++p == pe )
		goto _test_eof158;
case 158:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 340: goto tr212;
		case 351: goto tr81;
		case 372: goto tr212;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 596: goto tr365;
		case 607: goto tr101;
		case 628: goto tr365;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr103:
	{te = p+1;}
	{act = 56;}
	goto st159;
st159:
	if ( ++p == pe )
		goto _test_eof159;
case 159:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 329: goto st78;
		case 333: goto tr215;
		case 334: goto st79;
		case 344: goto st82;
		case 345: goto st83;
		case 351: goto tr81;
		case 361: goto st78;
		case 365: goto tr215;
		case 366: goto st79;
		case 376: goto st82;
		case 377: goto st83;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 585: goto tr366;
		case 589: goto tr367;
		case 590: goto tr368;
		case 600: goto tr369;
		case 601: goto tr370;
		case 607: goto tr101;
		case 617: goto tr366;
		case 621: goto tr367;
		case 622: goto tr368;
		case 632: goto tr369;
		case 633: goto tr370;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr213;
tr366:
	{te = p+1;}
	{act = 153;}
	goto st160;
st160:
	if ( ++p == pe )
		goto _test_eof160;
case 160:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr219;
		case 351: goto tr81;
		case 370: goto tr219;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr371;
		case 607: goto tr101;
		case 626: goto tr371;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr368:
	{te = p+1;}
	{act = 104;}
	goto st161;
st161:
	if ( ++p == pe )
		goto _test_eof161;
case 161:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr221;
		case 324: goto st80;
		case 329: goto st81;
		case 351: goto tr81;
		case 355: goto tr221;
		case 356: goto st80;
		case 361: goto st81;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr372;
		case 580: goto tr373;
		case 585: goto tr374;
		case 607: goto tr101;
		case 611: goto tr372;
		case 612: goto tr373;
		case 617: goto tr374;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr220;
tr373:
	{te = p+1;}
	{act = 106;}
	goto st162;
st162:
	if ( ++p == pe )
		goto _test_eof162;
case 162:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr225;
		case 351: goto tr81;
		case 370: goto tr225;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr375;
		case 607: goto tr101;
		case 626: goto tr375;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr224;
tr374:
	{te = p+1;}
	{act = 108;}
	goto st163;
st163:
	if ( ++p == pe )
		goto _test_eof163;
case 163:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr227;
		case 351: goto tr81;
		case 370: goto tr227;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr376;
		case 607: goto tr101;
		case 626: goto tr376;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr226;
tr369:
	{te = p+1;}
	{act = 64;}
	goto st164;
st164:
	if ( ++p == pe )
		goto _test_eof164;
case 164:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 328: goto tr229;
		case 332: goto tr230;
		case 351: goto tr81;
		case 360: goto tr229;
		case 364: goto tr230;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 584: goto tr377;
		case 588: goto tr378;
		case 607: goto tr101;
		case 616: goto tr377;
		case 620: goto tr378;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr228;
tr370:
	{te = p+1;}
	{act = 65;}
	goto st165;
st165:
	if ( ++p == pe )
		goto _test_eof165;
case 165:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 328: goto tr232;
		case 332: goto tr233;
		case 351: goto tr81;
		case 360: goto tr232;
		case 364: goto tr233;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 584: goto tr379;
		case 588: goto tr380;
		case 607: goto tr101;
		case 616: goto tr379;
		case 620: goto tr380;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr231;
tr104:
	{te = p+1;}
	{act = 153;}
	goto st166;
st166:
	if ( ++p == pe )
		goto _test_eof166;
case 166:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 336: goto tr234;
		case 338: goto tr235;
		case 351: goto tr81;
		case 368: goto tr234;
		case 370: goto tr235;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 592: goto tr381;
		case 594: goto tr382;
		case 607: goto tr101;
		case 624: goto tr381;
		case 626: goto tr382;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr105:
	{te = p+1;}
	{act = 51;}
	goto st167;
st167:
	if ( ++p == pe )
		goto _test_eof167;
case 167:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto st86;
		case 351: goto tr81;
		case 356: goto st86;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr383;
		case 607: goto tr101;
		case 612: goto tr383;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr236;
tr383:
	{te = p+1;}
	{act = 112;}
	goto st168;
st168:
	if ( ++p == pe )
		goto _test_eof168;
case 168:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto st87;
		case 329: goto st88;
		case 351: goto tr81;
		case 356: goto st87;
		case 361: goto st88;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr384;
		case 585: goto tr385;
		case 607: goto tr101;
		case 612: goto tr384;
		case 617: goto tr385;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr238;
tr384:
	{te = p+1;}
	{act = 113;}
	goto st169;
st169:
	if ( ++p == pe )
		goto _test_eof169;
case 169:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr242;
		case 351: goto tr81;
		case 370: goto tr242;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr386;
		case 607: goto tr101;
		case 626: goto tr386;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr241;
tr385:
	{te = p+1;}
	{act = 115;}
	goto st170;
st170:
	if ( ++p == pe )
		goto _test_eof170;
case 170:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr244;
		case 351: goto tr81;
		case 370: goto tr244;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr387;
		case 607: goto tr101;
		case 626: goto tr387;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr243;
tr107:
	{te = p+1;}
	{act = 153;}
	goto st171;
st171:
	if ( ++p == pe )
		goto _test_eof171;
case 171:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr245;
		case 325: goto st90;
		case 335: goto st91;
		case 346: goto tr248;
		case 351: goto tr81;
		case 355: goto tr245;
		case 357: goto st90;
		case 367: goto st91;
		case 378: goto tr248;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr388;
		case 581: goto tr389;
		case 591: goto tr390;
		case 602: goto tr391;
		case 607: goto tr101;
		case 611: goto tr388;
		case 613: goto tr389;
		case 623: goto tr390;
		case 634: goto tr391;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 377 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 601 ) {
			if ( 609 <= _widec && _widec <= 633 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr389:
	{te = p+1;}
	{act = 153;}
	goto st172;
st172:
	if ( ++p == pe )
		goto _test_eof172;
case 172:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 327: goto tr249;
		case 351: goto tr81;
		case 359: goto tr249;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 583: goto tr392;
		case 607: goto tr101;
		case 615: goto tr392;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr390:
	{te = p+1;}
	{act = 153;}
	goto st173;
st173:
	if ( ++p == pe )
		goto _test_eof173;
case 173:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 336: goto tr250;
		case 351: goto tr81;
		case 368: goto tr250;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 592: goto tr393;
		case 607: goto tr101;
		case 624: goto tr393;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr108:
	{te = p+1;}
	{act = 153;}
	goto st174;
st174:
	if ( ++p == pe )
		goto _test_eof174;
case 174:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto st93;
		case 340: goto st94;
		case 341: goto st97;
		case 351: goto tr81;
		case 370: goto st93;
		case 372: goto st94;
		case 373: goto st97;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr394;
		case 596: goto tr395;
		case 597: goto tr396;
		case 607: goto tr101;
		case 626: goto tr394;
		case 628: goto tr395;
		case 629: goto tr396;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr394:
	{te = p+1;}
	{act = 119;}
	goto st175;
st175:
	if ( ++p == pe )
		goto _test_eof175;
case 175:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 327: goto tr255;
		case 351: goto tr81;
		case 359: goto tr255;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 583: goto tr397;
		case 607: goto tr101;
		case 615: goto tr397;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr254;
tr395:
	{te = p+1;}
	{act = 153;}
	goto st176;
st176:
	if ( ++p == pe )
		goto _test_eof176;
case 176:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto st95;
		case 329: goto st96;
		case 351: goto tr81;
		case 356: goto st95;
		case 361: goto st96;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr398;
		case 585: goto tr399;
		case 607: goto tr101;
		case 612: goto tr398;
		case 617: goto tr399;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr398:
	{te = p+1;}
	{act = 153;}
	goto st177;
st177:
	if ( ++p == pe )
		goto _test_eof177;
case 177:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr258;
		case 351: goto tr81;
		case 370: goto tr258;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr400;
		case 607: goto tr101;
		case 626: goto tr400;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr399:
	{te = p+1;}
	{act = 153;}
	goto st178;
st178:
	if ( ++p == pe )
		goto _test_eof178;
case 178:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr259;
		case 351: goto tr81;
		case 370: goto tr259;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr401;
		case 607: goto tr101;
		case 626: goto tr401;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr396:
	{te = p+1;}
	{act = 153;}
	goto st179;
st179:
	if ( ++p == pe )
		goto _test_eof179;
case 179:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 340: goto st98;
		case 351: goto tr81;
		case 372: goto st98;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 596: goto tr402;
		case 607: goto tr101;
		case 628: goto tr402;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr402:
	{te = p+1;}
	{act = 122;}
	goto st180;
st180:
	if ( ++p == pe )
		goto _test_eof180;
case 180:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto tr262;
		case 329: goto tr263;
		case 351: goto tr81;
		case 356: goto tr262;
		case 361: goto tr263;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 580: goto tr403;
		case 585: goto tr404;
		case 607: goto tr101;
		case 612: goto tr403;
		case 617: goto tr404;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr261;
tr109:
	{te = p+1;}
	{act = 43;}
	goto st181;
st181:
	if ( ++p == pe )
		goto _test_eof181;
case 181:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 325: goto tr265;
		case 335: goto st100;
		case 341: goto st101;
		case 351: goto tr81;
		case 357: goto tr265;
		case 367: goto st100;
		case 373: goto st101;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 581: goto tr405;
		case 591: goto tr406;
		case 597: goto tr407;
		case 607: goto tr101;
		case 613: goto tr405;
		case 623: goto tr406;
		case 629: goto tr407;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr264;
tr406:
	{te = p+1;}
	{act = 41;}
	goto st182;
st182:
	if ( ++p == pe )
		goto _test_eof182;
case 182:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 336: goto tr269;
		case 351: goto tr81;
		case 368: goto tr269;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 592: goto tr408;
		case 607: goto tr101;
		case 624: goto tr408;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr268;
tr407:
	{te = p+1;}
	{act = 153;}
	goto st183;
st183:
	if ( ++p == pe )
		goto _test_eof183;
case 183:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 339: goto st102;
		case 351: goto tr81;
		case 371: goto st102;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 595: goto tr409;
		case 607: goto tr101;
		case 627: goto tr409;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr409:
	{te = p+1;}
	{act = 153;}
	goto st184;
st184:
	if ( ++p == pe )
		goto _test_eof184;
case 184:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 328: goto tr271;
		case 351: goto tr81;
		case 360: goto tr271;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 584: goto tr410;
		case 607: goto tr101;
		case 616: goto tr410;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr110:
	{te = p+1;}
	{act = 58;}
	goto st185;
st185:
	if ( ++p == pe )
		goto _test_eof185;
case 185:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 325: goto st104;
		case 332: goto st106;
		case 338: goto st108;
		case 339: goto st110;
		case 351: goto tr81;
		case 357: goto st104;
		case 364: goto st106;
		case 370: goto st108;
		case 371: goto st110;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 581: goto tr411;
		case 588: goto tr412;
		case 594: goto tr413;
		case 595: goto tr414;
		case 607: goto tr101;
		case 613: goto tr411;
		case 620: goto tr412;
		case 626: goto tr413;
		case 627: goto tr414;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr272;
tr411:
	{te = p+1;}
	{act = 153;}
	goto st186;
st186:
	if ( ++p == pe )
		goto _test_eof186;
case 186:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 339: goto tr277;
		case 340: goto st105;
		case 351: goto tr81;
		case 371: goto tr277;
		case 372: goto st105;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 595: goto tr415;
		case 596: goto tr416;
		case 607: goto tr101;
		case 627: goto tr415;
		case 628: goto tr416;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr416:
	{te = p+1;}
	{act = 128;}
	goto st187;
st187:
	if ( ++p == pe )
		goto _test_eof187;
case 187:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 329: goto tr280;
		case 334: goto tr281;
		case 351: goto tr81;
		case 361: goto tr280;
		case 366: goto tr281;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 585: goto tr417;
		case 590: goto tr418;
		case 607: goto tr101;
		case 617: goto tr417;
		case 622: goto tr418;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr279;
tr412:
	{te = p+1;}
	{act = 131;}
	goto st188;
st188:
	if ( ++p == pe )
		goto _test_eof188;
case 188:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr283;
		case 323: goto st107;
		case 324: goto tr285;
		case 351: goto tr81;
		case 353: goto tr283;
		case 355: goto st107;
		case 356: goto tr285;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr419;
		case 579: goto tr420;
		case 580: goto tr421;
		case 607: goto tr101;
		case 609: goto tr419;
		case 611: goto tr420;
		case 612: goto tr421;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr282;
tr420:
	{te = p+1;}
	{act = 133;}
	goto st189;
st189:
	if ( ++p == pe )
		goto _test_eof189;
case 189:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr287;
		case 351: goto tr81;
		case 353: goto tr287;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr422;
		case 607: goto tr101;
		case 609: goto tr422;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr286;
tr413:
	{te = p+1;}
	{act = 136;}
	goto st190;
st190:
	if ( ++p == pe )
		goto _test_eof190;
case 190:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr289;
		case 323: goto st109;
		case 324: goto tr291;
		case 351: goto tr81;
		case 353: goto tr289;
		case 355: goto st109;
		case 356: goto tr291;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr423;
		case 579: goto tr424;
		case 580: goto tr425;
		case 607: goto tr101;
		case 609: goto tr423;
		case 611: goto tr424;
		case 612: goto tr425;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr288;
tr424:
	{te = p+1;}
	{act = 138;}
	goto st191;
st191:
	if ( ++p == pe )
		goto _test_eof191;
case 191:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr293;
		case 351: goto tr81;
		case 353: goto tr293;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr426;
		case 607: goto tr101;
		case 609: goto tr426;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr292;
tr414:
	{te = p+1;}
	{act = 153;}
	goto st192;
st192:
	if ( ++p == pe )
		goto _test_eof192;
case 192:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 340: goto tr294;
		case 351: goto tr81;
		case 372: goto tr294;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 596: goto tr427;
		case 607: goto tr101;
		case 628: goto tr427;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr111:
	{te = p+1;}
	{act = 153;}
	goto st193;
st193:
	if ( ++p == pe )
		goto _test_eof193;
case 193:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 322: goto st112;
		case 323: goto st113;
		case 325: goto st114;
		case 332: goto st115;
		case 336: goto tr299;
		case 338: goto st116;
		case 341: goto st117;
		case 351: goto tr81;
		case 354: goto st112;
		case 355: goto st113;
		case 357: goto st114;
		case 364: goto st115;
		case 368: goto tr299;
		case 370: goto st116;
		case 373: goto st117;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 578: goto tr428;
		case 579: goto tr429;
		case 581: goto tr430;
		case 588: goto tr431;
		case 592: goto tr432;
		case 594: goto tr433;
		case 597: goto tr434;
		case 607: goto tr101;
		case 610: goto tr428;
		case 611: goto tr429;
		case 613: goto tr430;
		case 620: goto tr431;
		case 624: goto tr432;
		case 626: goto tr433;
		case 629: goto tr434;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr428:
	{te = p+1;}
	{act = 153;}
	goto st194;
st194:
	if ( ++p == pe )
		goto _test_eof194;
case 194:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 323: goto tr302;
		case 351: goto tr81;
		case 355: goto tr302;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 579: goto tr435;
		case 607: goto tr101;
		case 611: goto tr435;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr429:
	{te = p+1;}
	{act = 153;}
	goto st195;
st195:
	if ( ++p == pe )
		goto _test_eof195;
case 195:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 326: goto tr303;
		case 351: goto tr81;
		case 358: goto tr303;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 582: goto tr436;
		case 607: goto tr101;
		case 614: goto tr436;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr430:
	{te = p+1;}
	{act = 153;}
	goto st196;
st196:
	if ( ++p == pe )
		goto _test_eof196;
case 196:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 340: goto tr304;
		case 351: goto tr81;
		case 372: goto tr304;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 596: goto tr437;
		case 607: goto tr101;
		case 628: goto tr437;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr431:
	{te = p+1;}
	{act = 153;}
	goto st197;
st197:
	if ( ++p == pe )
		goto _test_eof197;
case 197:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr305;
		case 332: goto tr306;
		case 351: goto tr81;
		case 353: goto tr305;
		case 364: goto tr306;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr438;
		case 588: goto tr439;
		case 607: goto tr101;
		case 609: goto tr438;
		case 620: goto tr439;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr433:
	{te = p+1;}
	{act = 153;}
	goto st198;
st198:
	if ( ++p == pe )
		goto _test_eof198;
case 198:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 321: goto tr307;
		case 332: goto tr308;
		case 351: goto tr81;
		case 353: goto tr307;
		case 364: goto tr308;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 577: goto tr440;
		case 588: goto tr441;
		case 607: goto tr101;
		case 609: goto tr440;
		case 620: goto tr441;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr434:
	{te = p+1;}
	{act = 153;}
	goto st199;
st199:
	if ( ++p == pe )
		goto _test_eof199;
case 199:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 322: goto tr309;
		case 351: goto tr81;
		case 354: goto tr309;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 578: goto tr442;
		case 607: goto tr101;
		case 610: goto tr442;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr112:
	{te = p+1;}
	{act = 153;}
	goto st200;
st200:
	if ( ++p == pe )
		goto _test_eof200;
case 200:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 335: goto st119;
		case 351: goto tr81;
		case 367: goto st119;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 591: goto tr443;
		case 607: goto tr101;
		case 623: goto tr443;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
tr443:
	{te = p+1;}
	{act = 153;}
	goto st201;
st201:
	if ( ++p == pe )
		goto _test_eof201;
case 201:
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 338: goto tr311;
		case 351: goto tr81;
		case 370: goto tr311;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr38;
		case 594: goto tr444;
		case 607: goto tr101;
		case 626: goto tr444;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr81;
		} else if ( _widec >= 304 )
			goto tr81;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr101;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr81;
	goto tr150;
	}
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof38: cs = 38; goto _test_eof; 
	_test_eof39: cs = 39; goto _test_eof; 
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 
	_test_eof43: cs = 43; goto _test_eof; 
	_test_eof44: cs = 44; goto _test_eof; 
	_test_eof45: cs = 45; goto _test_eof; 
	_test_eof46: cs = 46; goto _test_eof; 
	_test_eof47: cs = 47; goto _test_eof; 
	_test_eof48: cs = 48; goto _test_eof; 
	_test_eof49: cs = 49; goto _test_eof; 
	_test_eof50: cs = 50; goto _test_eof; 
	_test_eof51: cs = 51; goto _test_eof; 
	_test_eof52: cs = 52; goto _test_eof; 
	_test_eof53: cs = 53; goto _test_eof; 
	_test_eof54: cs = 54; goto _test_eof; 
	_test_eof55: cs = 55; goto _test_eof; 
	_test_eof56: cs = 56; goto _test_eof; 
	_test_eof57: cs = 57; goto _test_eof; 
	_test_eof58: cs = 58; goto _test_eof; 
	_test_eof59: cs = 59; goto _test_eof; 
	_test_eof60: cs = 60; goto _test_eof; 
	_test_eof61: cs = 61; goto _test_eof; 
	_test_eof62: cs = 62; goto _test_eof; 
	_test_eof63: cs = 63; goto _test_eof; 
	_test_eof64: cs = 64; goto _test_eof; 
	_test_eof65: cs = 65; goto _test_eof; 
	_test_eof66: cs = 66; goto _test_eof; 
	_test_eof67: cs = 67; goto _test_eof; 
	_test_eof68: cs = 68; goto _test_eof; 
	_test_eof69: cs = 69; goto _test_eof; 
	_test_eof70: cs = 70; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof71: cs = 71; goto _test_eof; 
	_test_eof72: cs = 72; goto _test_eof; 
	_test_eof73: cs = 73; goto _test_eof; 
	_test_eof74: cs = 74; goto _test_eof; 
	_test_eof75: cs = 75; goto _test_eof; 
	_test_eof76: cs = 76; goto _test_eof; 
	_test_eof77: cs = 77; goto _test_eof; 
	_test_eof78: cs = 78; goto _test_eof; 
	_test_eof79: cs = 79; goto _test_eof; 
	_test_eof80: cs = 80; goto _test_eof; 
	_test_eof81: cs = 81; goto _test_eof; 
	_test_eof82: cs = 82; goto _test_eof; 
	_test_eof83: cs = 83; goto _test_eof; 
	_test_eof84: cs = 84; goto _test_eof; 
	_test_eof85: cs = 85; goto _test_eof; 
	_test_eof86: cs = 86; goto _test_eof; 
	_test_eof87: cs = 87; goto _test_eof; 
	_test_eof88: cs = 88; goto _test_eof; 
	_test_eof89: cs = 89; goto _test_eof; 
	_test_eof90: cs = 90; goto _test_eof; 
	_test_eof91: cs = 91; goto _test_eof; 
	_test_eof92: cs = 92; goto _test_eof; 
	_test_eof93: cs = 93; goto _test_eof; 
	_test_eof94: cs = 94; goto _test_eof; 
	_test_eof95: cs = 95; goto _test_eof; 
	_test_eof96: cs = 96; goto _test_eof; 
	_test_eof97: cs = 97; goto _test_eof; 
	_test_eof98: cs = 98; goto _test_eof; 
	_test_eof99: cs = 99; goto _test_eof; 
	_test_eof100: cs = 100; goto _test_eof; 
	_test_eof101: cs = 101; goto _test_eof; 
	_test_eof102: cs = 102; goto _test_eof; 
	_test_eof103: cs = 103; goto _test_eof; 
	_test_eof104: cs = 104; goto _test_eof; 
	_test_eof105: cs = 105; goto _test_eof; 
	_test_eof106: cs = 106; goto _test_eof; 
	_test_eof107: cs = 107; goto _test_eof; 
	_test_eof108: cs = 108; goto _test_eof; 
	_test_eof109: cs = 109; goto _test_eof; 
	_test_eof110: cs = 110; goto _test_eof; 
	_test_eof111: cs = 111; goto _test_eof; 
	_test_eof112: cs = 112; goto _test_eof; 
	_test_eof113: cs = 113; goto _test_eof; 
	_test_eof114: cs = 114; goto _test_eof; 
	_test_eof115: cs = 115; goto _test_eof; 
	_test_eof116: cs = 116; goto _test_eof; 
	_test_eof117: cs = 117; goto _test_eof; 
	_test_eof118: cs = 118; goto _test_eof; 
	_test_eof119: cs = 119; goto _test_eof; 
	_test_eof120: cs = 120; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof121: cs = 121; goto _test_eof; 
	_test_eof122: cs = 122; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof123: cs = 123; goto _test_eof; 
	_test_eof124: cs = 124; goto _test_eof; 
	_test_eof125: cs = 125; goto _test_eof; 
	_test_eof126: cs = 126; goto _test_eof; 
	_test_eof127: cs = 127; goto _test_eof; 
	_test_eof128: cs = 128; goto _test_eof; 
	_test_eof129: cs = 129; goto _test_eof; 
	_test_eof130: cs = 130; goto _test_eof; 
	_test_eof131: cs = 131; goto _test_eof; 
	_test_eof132: cs = 132; goto _test_eof; 
	_test_eof133: cs = 133; goto _test_eof; 
	_test_eof134: cs = 134; goto _test_eof; 
	_test_eof135: cs = 135; goto _test_eof; 
	_test_eof136: cs = 136; goto _test_eof; 
	_test_eof137: cs = 137; goto _test_eof; 
	_test_eof138: cs = 138; goto _test_eof; 
	_test_eof139: cs = 139; goto _test_eof; 
	_test_eof140: cs = 140; goto _test_eof; 
	_test_eof141: cs = 141; goto _test_eof; 
	_test_eof142: cs = 142; goto _test_eof; 
	_test_eof143: cs = 143; goto _test_eof; 
	_test_eof144: cs = 144; goto _test_eof; 
	_test_eof145: cs = 145; goto _test_eof; 
	_test_eof146: cs = 146; goto _test_eof; 
	_test_eof147: cs = 147; goto _test_eof; 
	_test_eof148: cs = 148; goto _test_eof; 
	_test_eof149: cs = 149; goto _test_eof; 
	_test_eof150: cs = 150; goto _test_eof; 
	_test_eof151: cs = 151; goto _test_eof; 
	_test_eof152: cs = 152; goto _test_eof; 
	_test_eof153: cs = 153; goto _test_eof; 
	_test_eof154: cs = 154; goto _test_eof; 
	_test_eof155: cs = 155; goto _test_eof; 
	_test_eof156: cs = 156; goto _test_eof; 
	_test_eof157: cs = 157; goto _test_eof; 
	_test_eof158: cs = 158; goto _test_eof; 
	_test_eof159: cs = 159; goto _test_eof; 
	_test_eof160: cs = 160; goto _test_eof; 
	_test_eof161: cs = 161; goto _test_eof; 
	_test_eof162: cs = 162; goto _test_eof; 
	_test_eof163: cs = 163; goto _test_eof; 
	_test_eof164: cs = 164; goto _test_eof; 
	_test_eof165: cs = 165; goto _test_eof; 
	_test_eof166: cs = 166; goto _test_eof; 
	_test_eof167: cs = 167; goto _test_eof; 
	_test_eof168: cs = 168; goto _test_eof; 
	_test_eof169: cs = 169; goto _test_eof; 
	_test_eof170: cs = 170; goto _test_eof; 
	_test_eof171: cs = 171; goto _test_eof; 
	_test_eof172: cs = 172; goto _test_eof; 
	_test_eof173: cs = 173; goto _test_eof; 
	_test_eof174: cs = 174; goto _test_eof; 
	_test_eof175: cs = 175; goto _test_eof; 
	_test_eof176: cs = 176; goto _test_eof; 
	_test_eof177: cs = 177; goto _test_eof; 
	_test_eof178: cs = 178; goto _test_eof; 
	_test_eof179: cs = 179; goto _test_eof; 
	_test_eof180: cs = 180; goto _test_eof; 
	_test_eof181: cs = 181; goto _test_eof; 
	_test_eof182: cs = 182; goto _test_eof; 
	_test_eof183: cs = 183; goto _test_eof; 
	_test_eof184: cs = 184; goto _test_eof; 
	_test_eof185: cs = 185; goto _test_eof; 
	_test_eof186: cs = 186; goto _test_eof; 
	_test_eof187: cs = 187; goto _test_eof; 
	_test_eof188: cs = 188; goto _test_eof; 
	_test_eof189: cs = 189; goto _test_eof; 
	_test_eof190: cs = 190; goto _test_eof; 
	_test_eof191: cs = 191; goto _test_eof; 
	_test_eof192: cs = 192; goto _test_eof; 
	_test_eof193: cs = 193; goto _test_eof; 
	_test_eof194: cs = 194; goto _test_eof; 
	_test_eof195: cs = 195; goto _test_eof; 
	_test_eof196: cs = 196; goto _test_eof; 
	_test_eof197: cs = 197; goto _test_eof; 
	_test_eof198: cs = 198; goto _test_eof; 
	_test_eof199: cs = 199; goto _test_eof; 
	_test_eof200: cs = 200; goto _test_eof; 
	_test_eof201: cs = 201; goto _test_eof; 
	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 22: goto tr114;
	case 23: goto tr21;
	case 24: goto tr117;
	case 25: goto tr119;
	case 1: goto tr0;
	case 2: goto tr0;
	case 3: goto tr0;
	case 4: goto tr0;
	case 5: goto tr0;
	case 6: goto tr0;
	case 7: goto tr0;
	case 8: goto tr0;
	case 9: goto tr0;
	case 10: goto tr0;
	case 11: goto tr0;
	case 12: goto tr0;
	case 13: goto tr0;
	case 26: goto tr120;
	case 27: goto tr122;
	case 28: goto tr122;
	case 29: goto tr122;
	case 14: goto tr21;
	case 30: goto tr126;
	case 31: goto tr21;
	case 15: goto tr24;
	case 32: goto tr128;
	case 33: goto tr129;
	case 34: goto tr130;
	case 35: goto tr134;
	case 36: goto tr136;
	case 37: goto tr139;
	case 16: goto tr26;
	case 17: goto tr26;
	case 38: goto tr142;
	case 39: goto tr143;
	case 40: goto tr145;
	case 41: goto tr21;
	case 42: goto tr150;
	case 43: goto tr153;
	case 44: goto tr150;
	case 45: goto tr150;
	case 46: goto tr150;
	case 47: goto tr150;
	case 48: goto tr159;
	case 49: goto tr150;
	case 50: goto tr163;
	case 51: goto tr150;
	case 52: goto tr150;
	case 53: goto tr150;
	case 54: goto tr170;
	case 55: goto tr174;
	case 56: goto tr176;
	case 57: goto tr178;
	case 58: goto tr150;
	case 59: goto tr185;
	case 60: goto tr150;
	case 61: goto tr150;
	case 62: goto tr150;
	case 63: goto tr150;
	case 64: goto tr150;
	case 65: goto tr150;
	case 66: goto tr150;
	case 67: goto tr150;
	case 68: goto tr150;
	case 69: goto tr150;
	case 70: goto tr150;
	case 18: goto tr29;
	case 71: goto tr201;
	case 72: goto tr204;
	case 73: goto tr206;
	case 74: goto tr208;
	case 75: goto tr150;
	case 76: goto tr150;
	case 77: goto tr213;
	case 78: goto tr150;
	case 79: goto tr220;
	case 80: goto tr224;
	case 81: goto tr226;
	case 82: goto tr228;
	case 83: goto tr231;
	case 84: goto tr150;
	case 85: goto tr236;
	case 86: goto tr238;
	case 87: goto tr241;
	case 88: goto tr243;
	case 89: goto tr150;
	case 90: goto tr150;
	case 91: goto tr150;
	case 92: goto tr150;
	case 93: goto tr254;
	case 94: goto tr150;
	case 95: goto tr150;
	case 96: goto tr150;
	case 97: goto tr150;
	case 98: goto tr261;
	case 99: goto tr264;
	case 100: goto tr268;
	case 101: goto tr150;
	case 102: goto tr150;
	case 103: goto tr272;
	case 104: goto tr150;
	case 105: goto tr279;
	case 106: goto tr282;
	case 107: goto tr286;
	case 108: goto tr288;
	case 109: goto tr292;
	case 110: goto tr150;
	case 111: goto tr150;
	case 112: goto tr150;
	case 113: goto tr150;
	case 114: goto tr150;
	case 115: goto tr150;
	case 116: goto tr150;
	case 117: goto tr150;
	case 118: goto tr150;
	case 119: goto tr150;
	case 120: goto tr312;
	case 19: goto tr34;
	case 121: goto tr313;
	case 122: goto tr145;
	case 20: goto tr21;
	case 123: goto tr21;
	case 124: goto tr150;
	case 125: goto tr153;
	case 126: goto tr150;
	case 127: goto tr150;
	case 128: goto tr150;
	case 129: goto tr150;
	case 130: goto tr159;
	case 131: goto tr150;
	case 132: goto tr163;
	case 133: goto tr150;
	case 134: goto tr150;
	case 135: goto tr150;
	case 136: goto tr170;
	case 137: goto tr174;
	case 138: goto tr176;
	case 139: goto tr178;
	case 140: goto tr150;
	case 141: goto tr185;
	case 142: goto tr150;
	case 143: goto tr150;
	case 144: goto tr150;
	case 145: goto tr150;
	case 146: goto tr150;
	case 147: goto tr150;
	case 148: goto tr150;
	case 149: goto tr150;
	case 150: goto tr150;
	case 151: goto tr150;
	case 152: goto tr150;
	case 153: goto tr201;
	case 154: goto tr204;
	case 155: goto tr206;
	case 156: goto tr208;
	case 157: goto tr150;
	case 158: goto tr150;
	case 159: goto tr213;
	case 160: goto tr150;
	case 161: goto tr220;
	case 162: goto tr224;
	case 163: goto tr226;
	case 164: goto tr228;
	case 165: goto tr231;
	case 166: goto tr150;
	case 167: goto tr236;
	case 168: goto tr238;
	case 169: goto tr241;
	case 170: goto tr243;
	case 171: goto tr150;
	case 172: goto tr150;
	case 173: goto tr150;
	case 174: goto tr150;
	case 175: goto tr254;
	case 176: goto tr150;
	case 177: goto tr150;
	case 178: goto tr150;
	case 179: goto tr150;
	case 180: goto tr261;
	case 181: goto tr264;
	case 182: goto tr268;
	case 183: goto tr150;
	case 184: goto tr150;
	case 185: goto tr272;
	case 186: goto tr150;
	case 187: goto tr279;
	case 188: goto tr282;
	case 189: goto tr286;
	case 190: goto tr288;
	case 191: goto tr292;
	case 192: goto tr150;
	case 193: goto tr150;
	case 194: goto tr150;
	case 195: goto tr150;
	case 196: goto tr150;
	case 197: goto tr150;
	case 198: goto tr150;
	case 199: goto tr150;
	case 200: goto tr150;
	case 201: goto tr150;
	}
	}
	_out: {}
	}
 return sym.tok;
}
