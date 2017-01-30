static const int lexer_start = 21;
static const int lexer_error = 0;
static const int lexer_en_main = 21;
static void set_scan_buf( char *text, Bool _at_bol )
{
 str_set( input_buf, text );
 p = str_data(input_buf);
 at_bol = _at_bol;
 pe = str_data(input_buf) + str_len(input_buf);
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
	{	switch( act ) {
	case 1:
	{{p = ((te))-1;}
	sym.tok = TK_ASMPC;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 5:
	{{p = ((te))-1;}
	sym.tok = TK_MOD;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 37:
	{{p = ((te))-1;}
	sym.tok = TK_NZ;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 38:
	{{p = ((te))-1;}
	sym.tok = TK_Z;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 39:
	{{p = ((te))-1;}
	sym.tok = TK_NC;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 40:
	{{p = ((te))-1;}
	sym.tok = TK_C;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 41:
	{{p = ((te))-1;}
	sym.tok = TK_PO;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 42:
	{{p = ((te))-1;}
	sym.tok = TK_PE;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 43:
	{{p = ((te))-1;}
	sym.tok = TK_P;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 44:
	{{p = ((te))-1;}
	sym.tok = TK_M;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 45:
	{{p = ((te))-1;}
	sym.tok = TK_B;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 46:
	{{p = ((te))-1;}
	sym.tok = TK_D;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 47:
	{{p = ((te))-1;}
	sym.tok = TK_E;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 48:
	{{p = ((te))-1;}
	sym.tok = TK_H;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 49:
	{{p = ((te))-1;}
	sym.tok = TK_IXH;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 50:
	{{p = ((te))-1;}
	sym.tok = TK_IYH;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 51:
	{{p = ((te))-1;}
	sym.tok = TK_L;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 52:
	{{p = ((te))-1;}
	sym.tok = TK_IXL;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 53:
	{{p = ((te))-1;}
	sym.tok = TK_IYL;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 54:
	{{p = ((te))-1;}
	sym.tok = TK_A;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 55:
	{{p = ((te))-1;}
	sym.tok = TK_F;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 56:
	{{p = ((te))-1;}
	sym.tok = TK_I;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 57:
	{{p = ((te))-1;}
	sym.tok = TK_IIR;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 58:
	{{p = ((te))-1;}
	sym.tok = TK_R;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 59:
	{{p = ((te))-1;}
	sym.tok = TK_EIR;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 61:
	{{p = ((te))-1;}
	sym.tok = TK_BC;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 62:
	{{p = ((te))-1;}
	sym.tok = TK_DE;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 63:
	{{p = ((te))-1;}
	sym.tok = TK_HL;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 64:
	{{p = ((te))-1;}
	sym.tok = TK_IX;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 65:
	{{p = ((te))-1;}
	sym.tok = TK_IY;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 66:
	{{p = ((te))-1;}
	sym.tok = TK_AF;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 67:
	{{p = ((te))-1;}
	sym.tok = TK_SP;
	;
	{p++; cs = 21; goto _out;}
}
	break;
	case 75:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_BINARY;
		sym.tok_opcode = TK_BINARY;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_BINARY;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 76:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFB;
		sym.tok_opcode = TK_DEFB;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFB;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 77:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFC;
		sym.tok_opcode = TK_DEFC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 78:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFGROUP;
		sym.tok_opcode = TK_DEFGROUP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFGROUP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 79:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFINE;
		sym.tok_opcode = TK_DEFINE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFINE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 80:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFQ;
		sym.tok_opcode = TK_DEFQ;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFQ;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 81:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFM;
		sym.tok_opcode = TK_DEFM;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFM;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 82:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFS;
		sym.tok_opcode = TK_DEFS;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFS;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 83:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFVARS;
		sym.tok_opcode = TK_DEFVARS;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFVARS;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 84:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEFW;
		sym.tok_opcode = TK_DEFW;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFW;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 85:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ELSE;
		sym.tok_opcode = TK_ELSE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_ELSE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 86:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ENDIF;
		sym.tok_opcode = TK_ENDIF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_ENDIF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 87:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EXTERN;
		sym.tok_opcode = TK_EXTERN;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_EXTERN;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 88:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_GLOBAL;
		sym.tok_opcode = TK_GLOBAL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_GLOBAL;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 89:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IF;
		sym.tok_opcode = TK_IF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 90:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IFDEF;
		sym.tok_opcode = TK_IFDEF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IFDEF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 91:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IFNDEF;
		sym.tok_opcode = TK_IFNDEF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IFNDEF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 92:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INCLUDE;
		sym.tok_opcode = TK_INCLUDE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INCLUDE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 93:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LINE;
		sym.tok_opcode = TK_LINE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LINE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 94:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LSTOFF;
		sym.tok_opcode = TK_LSTOFF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LSTOFF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 95:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LSTON;
		sym.tok_opcode = TK_LSTON;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LSTON;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 96:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_MODULE;
		sym.tok_opcode = TK_MODULE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_MODULE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 97:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ORG;
		sym.tok_opcode = TK_ORG;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_ORG;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 98:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_PUBLIC;
		sym.tok_opcode = TK_PUBLIC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_PUBLIC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 99:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SECTION;
		sym.tok_opcode = TK_SECTION;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SECTION;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 100:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_UNDEFINE;
		sym.tok_opcode = TK_UNDEFINE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_UNDEFINE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 105:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ADC;
		sym.tok_opcode = TK_ADC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_ADC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 106:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_ADD;
		sym.tok_opcode = TK_ADD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_ADD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 107:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_AND;
		sym.tok_opcode = TK_AND;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_AND;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 108:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_BIT;
		sym.tok_opcode = TK_BIT;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_BIT;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 109:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CALL;
		sym.tok_opcode = TK_CALL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CALL;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 110:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CCF;
		sym.tok_opcode = TK_CCF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CCF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 111:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CP;
		sym.tok_opcode = TK_CP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 112:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPD;
		sym.tok_opcode = TK_CPD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 113:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPDR;
		sym.tok_opcode = TK_CPDR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPDR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 114:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPI;
		sym.tok_opcode = TK_CPI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 115:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPIR;
		sym.tok_opcode = TK_CPIR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPIR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 116:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CPL;
		sym.tok_opcode = TK_CPL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPL;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 117:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DAA;
		sym.tok_opcode = TK_DAA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DAA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 118:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DEC;
		sym.tok_opcode = TK_DEC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 119:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DI;
		sym.tok_opcode = TK_DI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 120:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_DJNZ;
		sym.tok_opcode = TK_DJNZ;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DJNZ;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 121:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EI;
		sym.tok_opcode = TK_EI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_EI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 122:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EX;
		sym.tok_opcode = TK_EX;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_EX;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 123:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_EXX;
		sym.tok_opcode = TK_EXX;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_EXX;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 124:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_HALT;
		sym.tok_opcode = TK_HALT;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_HALT;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 125:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IM;
		sym.tok_opcode = TK_IM;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IM;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 126:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IN;
		sym.tok_opcode = TK_IN;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IN;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 127:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INC;
		sym.tok_opcode = TK_INC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 128:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IND;
		sym.tok_opcode = TK_IND;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IND;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 129:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INDR;
		sym.tok_opcode = TK_INDR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INDR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 130:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INI;
		sym.tok_opcode = TK_INI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 131:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INIR;
		sym.tok_opcode = TK_INIR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INIR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 132:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_JP;
		sym.tok_opcode = TK_JP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_JP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 133:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_JR;
		sym.tok_opcode = TK_JR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_JR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 134:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LD;
		sym.tok_opcode = TK_LD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 135:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDD;
		sym.tok_opcode = TK_LDD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LDD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 136:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDDR;
		sym.tok_opcode = TK_LDDR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LDDR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 137:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDI;
		sym.tok_opcode = TK_LDI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LDI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 138:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LDIR;
		sym.tok_opcode = TK_LDIR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LDIR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 139:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_NEG;
		sym.tok_opcode = TK_NEG;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_NEG;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 140:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_NOP;
		sym.tok_opcode = TK_NOP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_NOP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 141:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OR;
		sym.tok_opcode = TK_OR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 142:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTDR;
		sym.tok_opcode = TK_OTDR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTDR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 143:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTIR;
		sym.tok_opcode = TK_OTIR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTIR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 144:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUT;
		sym.tok_opcode = TK_OUT;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OUT;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 145:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUTD;
		sym.tok_opcode = TK_OUTD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OUTD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 146:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUTI;
		sym.tok_opcode = TK_OUTI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OUTI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 147:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_POP;
		sym.tok_opcode = TK_POP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_POP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 148:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_PUSH;
		sym.tok_opcode = TK_PUSH;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_PUSH;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 149:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RES;
		sym.tok_opcode = TK_RES;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RES;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 150:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RET;
		sym.tok_opcode = TK_RET;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RET;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 151:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RETI;
		sym.tok_opcode = TK_RETI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RETI;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 152:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RETN;
		sym.tok_opcode = TK_RETN;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RETN;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 153:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RL;
		sym.tok_opcode = TK_RL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RL;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 154:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLA;
		sym.tok_opcode = TK_RLA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RLA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 155:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLC;
		sym.tok_opcode = TK_RLC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RLC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 156:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLCA;
		sym.tok_opcode = TK_RLCA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RLCA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 157:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RLD;
		sym.tok_opcode = TK_RLD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RLD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 158:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RR;
		sym.tok_opcode = TK_RR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 159:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRA;
		sym.tok_opcode = TK_RRA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RRA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 160:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRC;
		sym.tok_opcode = TK_RRC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RRC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 161:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRCA;
		sym.tok_opcode = TK_RRCA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RRCA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 162:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RRD;
		sym.tok_opcode = TK_RRD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RRD;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 163:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_RST;
		sym.tok_opcode = TK_RST;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RST;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 164:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SBC;
		sym.tok_opcode = TK_SBC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SBC;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 165:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SCF;
		sym.tok_opcode = TK_SCF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SCF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 166:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SET;
		sym.tok_opcode = TK_SET;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SET;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 167:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SLA;
		sym.tok_opcode = TK_SLA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SLA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 168:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SLL;
		sym.tok_opcode = TK_SLL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SLL;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 169:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SRA;
		sym.tok_opcode = TK_SRA;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SRA;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 170:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SRL;
		sym.tok_opcode = TK_SRL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SRL;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 171:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SUB;
		sym.tok_opcode = TK_SUB;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SUB;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 172:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_XOR;
		sym.tok_opcode = TK_XOR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_XOR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 173:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_SLP;
		sym.tok_opcode = TK_SLP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_SLP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 174:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_MLT;
		sym.tok_opcode = TK_MLT;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_MLT;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 175:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_IN0;
		sym.tok_opcode = TK_IN0;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IN0;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 176:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OUT0;
		sym.tok_opcode = TK_OUT0;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OUT0;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 177:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTIM;
		sym.tok_opcode = TK_OTIM;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTIM;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 178:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTIMR;
		sym.tok_opcode = TK_OTIMR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTIMR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 179:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTDM;
		sym.tok_opcode = TK_OTDM;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTDM;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 180:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OTDMR;
		sym.tok_opcode = TK_OTDMR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTDMR;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 181:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_TST;
		sym.tok_opcode = TK_TST;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_TST;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 182:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_TSTIO;
		sym.tok_opcode = TK_TSTIO;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_TSTIO;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 183:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CALL_OZ;
		sym.tok_opcode = TK_CALL_OZ;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CALL_OZ;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 184:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_CALL_PKG;
		sym.tok_opcode = TK_CALL_PKG;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CALL_PKG;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 185:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_FPP;
		sym.tok_opcode = TK_FPP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_FPP;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 186:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_INVOKE;
		sym.tok_opcode = TK_INVOKE;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INVOKE;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 189:
	{{p = ((te))-1;}
  sym.tok = TK_NAME;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 191:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 193:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 1, te - ts - 1, 16 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 195:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 197:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 2, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 201:
	{{p = ((te))-1;}
  sym.tok = TK_NIL;
  skip_to_newline();
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	}
	}
	goto st21;
tr2:
	{te = p+1;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 3, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr3:
	{{p = ((te))-1;}{
	sym.tok = TK_LPAREN;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr12:
	{te = p+1;{
	sym.tok = TK_IND_BC;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr13:
	{te = p+1;{
	sym.tok = TK_IND_C;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr15:
	{te = p+1;{
	sym.tok = TK_IND_DE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr17:
	{te = p+1;{
	sym.tok = TK_IND_HL;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr20:
	{te = p+1;{
	sym.tok = TK_IND_IX;
	p--; te--;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr21:
	{te = p+1;{
	sym.tok = TK_IND_IY;
	p--; te--;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr23:
	{te = p+1;{
	sym.tok = TK_IND_SP;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr25:
	{te = p+1;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 16 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr26:
	{{p = ((te))-1;}{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr28:
	{{p = ((te))-1;}{
  sym.tok = TK_NAME;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr29:
	{te = p+1;{
	sym.tok = TK_DS_B;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr30:
	{te = p+1;{
	sym.tok = TK_DS_P;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr31:
	{te = p+1;{
	sym.tok = TK_DS_Q;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr32:
	{te = p+1;{
	sym.tok = TK_DS_W;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr33:
	{{p = ((te))-1;}{
	sym.tok = TK_DOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr37:
	{te = p+1;{
  while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
  while ( te[-1] == ':' || isspace(te[-1]) ) te--;
  sym.tok = TK_LABEL;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr38:
	{te = p+1;}
	goto st21;
tr39:
	{te = p+1;{
	sym.tok = TK_NEWLINE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr41:
	{te = p+1;{
  sym.tok = TK_STRING;
  if ( ! get_sym_string() )
   error_unclosed_string();
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr42:
	{te = p+1;{
	sym.tok = TK_CONST_EXPR;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr46:
	{te = p+1;{
  sym.tok = TK_NUMBER;
  if ( get_sym_string() &&
                             te - ts == 1 )
  {
   sym.number = *ts;
  }
  else
  {
   sym.number = 0;
   error_invalid_squoted_string();
  }
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr48:
	{te = p+1;{
	sym.tok = TK_RPAREN;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr50:
	{te = p+1;{
	sym.tok = TK_PLUS;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr51:
	{te = p+1;{
	sym.tok = TK_COMMA;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr52:
	{te = p+1;{
	sym.tok = TK_MINUS;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr53:
	{te = p+1;{
	sym.tok = TK_DIVIDE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr58:
	{te = p+1;{
	sym.tok = TK_COLON;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr63:
	{te = p+1;{
	sym.tok = TK_QUESTION;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr65:
	{te = p+1;{
	sym.tok = TK_LSQUARE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr66:
	{te = p+1;{
  sym.tok = TK_NIL;
  skip_to_newline();
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr67:
	{te = p+1;{
	sym.tok = TK_RSQUARE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr68:
	{te = p+1;{
	sym.tok = TK_BIN_XOR;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr69:
	{te = p+1;{
	sym.tok = TK_LCURLY;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr71:
	{te = p+1;{
	sym.tok = TK_RCURLY;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr72:
	{te = p+1;{
	sym.tok = TK_BIN_NOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr73:
	{te = p+1;{
	sym.tok = TK_DOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr119:
	{te = p;p--;{
	sym.tok = TK_LOG_NOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr120:
	{te = p+1;{
	sym.tok = TK_NOT_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr124:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 1, te - ts - 1, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr125:
	{te = p;p--;{
	sym.tok = TK_BIN_AND;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr126:
	{te = p+1;{
	sym.tok = TK_LOG_AND;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr127:
	{te = p;p--;{
	sym.tok = TK_LPAREN;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr128:
	{te = p;p--;{
	sym.tok = TK_MULTIPLY;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr129:
	{te = p+1;{
	sym.tok = TK_POWER;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr130:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr134:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr136:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 2, 16 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr137:
	{te = p;p--;}
	goto st21;
tr138:
	{te = p;p--;{
	sym.tok = TK_LESS;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr139:
	{te = p+1;{
	sym.tok = TK_LEFT_SHIFT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr140:
	{te = p+1;{
	sym.tok = TK_LESS_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr141:
	{te = p+1;{
	sym.tok = TK_NOT_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr142:
	{te = p;p--;{
	sym.tok = TK_EQUAL;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr143:
	{te = p+1;{
	sym.tok = TK_EQUAL;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr144:
	{te = p;p--;{
	sym.tok = TK_GREATER;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr145:
	{te = p+1;{
	sym.tok = TK_GREATER_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr146:
	{te = p+1;{
	sym.tok = TK_RIGHT_SHIFT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr147:
	{te = p;p--;{
	sym.tok = TK_BIN_OR;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr148:
	{te = p+1;{
	sym.tok = TK_LOG_OR;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr149:
	{te = p;p--;{
	sym.tok = TK_A;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr154:
	{te = p;p--;{
  sym.tok = TK_NAME;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr157:
	{te = p;p--;{
	sym.tok = TK_AF;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr158:
	{te = p+1;{
	sym.tok = TK_AF1;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr163:
	{te = p;p--;{
	sym.tok = TK_B;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr171:
	{te = p;p--;{
	sym.tok = TK_C;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr177:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CALL;
		sym.tok_opcode = TK_CALL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CALL;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr185:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CP;
		sym.tok_opcode = TK_CP;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CP;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr189:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CPD;
		sym.tok_opcode = TK_CPD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPD;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr191:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_CPI;
		sym.tok_opcode = TK_CPI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_CPI;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr193:
	{te = p;p--;{
	sym.tok = TK_D;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr200:
	{te = p;p--;{
	sym.tok = TK_DE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr224:
	{te = p;p--;{
	sym.tok = TK_E;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr229:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_EI;
		sym.tok_opcode = TK_EI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_EI;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr236:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_EX;
		sym.tok_opcode = TK_EX;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_EX;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr242:
	{te = p;p--;{
	sym.tok = TK_F;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr250:
	{te = p;p--;{
	sym.tok = TK_H;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr255:
	{te = p;p--;{
	sym.tok = TK_I;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr262:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_IF;
		sym.tok_opcode = TK_IF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IF;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr271:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_IN;
		sym.tok_opcode = TK_IN;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IN;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr277:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_INC;
		sym.tok_opcode = TK_INC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INC;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr282:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_IND;
		sym.tok_opcode = TK_IND;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_IND;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr284:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_INI;
		sym.tok_opcode = TK_INI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_INI;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr289:
	{te = p;p--;{
	sym.tok = TK_IX;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr292:
	{te = p;p--;{
	sym.tok = TK_IY;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr297:
	{te = p;p--;{
	sym.tok = TK_L;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr301:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_LD;
		sym.tok_opcode = TK_LD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LD;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr304:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_LDD;
		sym.tok_opcode = TK_LDD;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LDD;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr306:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_LDI;
		sym.tok_opcode = TK_LDI;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LDI;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr315:
	{te = p;p--;{
	sym.tok = TK_M;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr332:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_OR;
		sym.tok_opcode = TK_OR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OR;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr338:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_OTDM;
		sym.tok_opcode = TK_OTDM;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTDM;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr342:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_OTIM;
		sym.tok_opcode = TK_OTIM;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OTIM;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr345:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_OUT;
		sym.tok_opcode = TK_OUT;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OUT;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr349:
	{te = p;p--;{
	sym.tok = TK_P;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr353:
	{te = p;p--;{
	sym.tok = TK_PO;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr361:
	{te = p;p--;{
	sym.tok = TK_R;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr368:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RET;
		sym.tok_opcode = TK_RET;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RET;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr371:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RL;
		sym.tok_opcode = TK_RL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RL;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr375:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RLC;
		sym.tok_opcode = TK_RLC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RLC;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr377:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RR;
		sym.tok_opcode = TK_RR;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RR;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr381:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_RRC;
		sym.tok_opcode = TK_RRC;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_RRC;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr407:
	{te = p;p--;{
	if (expect_opcode) {
		sym.tok = TK_TST;
		sym.tok_opcode = TK_TST;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_TST;
	}
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr419:
	{te = p;p--;{
	sym.tok = TK_DOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr420:
	{te = p;p--;{
  while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
  while ( te[-1] == ':' || isspace(te[-1]) ) te--;
  sym.tok = TK_LABEL;
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
		case 10: goto tr39;
		case 33: goto st22;
		case 34: goto tr41;
		case 35: goto tr42;
		case 36: goto tr43;
		case 37: goto tr44;
		case 38: goto st26;
		case 39: goto tr46;
		case 40: goto tr47;
		case 41: goto tr48;
		case 42: goto st28;
		case 43: goto tr50;
		case 44: goto tr51;
		case 45: goto tr52;
		case 47: goto tr53;
		case 48: goto tr55;
		case 49: goto tr56;
		case 58: goto tr58;
		case 59: goto st35;
		case 60: goto st36;
		case 61: goto st37;
		case 62: goto st38;
		case 63: goto tr63;
		case 64: goto tr64;
		case 91: goto tr65;
		case 92: goto tr66;
		case 93: goto tr67;
		case 94: goto tr68;
		case 96: goto tr66;
		case 123: goto tr69;
		case 124: goto st39;
		case 125: goto tr71;
		case 126: goto tr72;
		case 127: goto tr38;
		case 302: goto tr73;
		case 321: goto st40;
		case 322: goto st48;
		case 323: goto st53;
		case 324: goto st65;
		case 325: goto st81;
		case 326: goto st92;
		case 327: goto st94;
		case 328: goto st99;
		case 329: goto st102;
		case 330: goto st122;
		case 332: goto st123;
		case 333: goto st133;
		case 334: goto st139;
		case 335: goto st142;
		case 336: goto st151;
		case 338: goto st158;
		case 339: goto st166;
		case 340: goto st177;
		case 341: goto st181;
		case 344: goto st188;
		case 346: goto tr95;
		case 351: goto tr84;
		case 353: goto st40;
		case 354: goto st48;
		case 355: goto st53;
		case 356: goto st65;
		case 357: goto st81;
		case 358: goto st92;
		case 359: goto st94;
		case 360: goto st99;
		case 361: goto st102;
		case 362: goto st122;
		case 364: goto st123;
		case 365: goto st133;
		case 366: goto st139;
		case 367: goto st142;
		case 368: goto st151;
		case 370: goto st158;
		case 371: goto st166;
		case 372: goto st177;
		case 373: goto st181;
		case 376: goto st188;
		case 378: goto tr95;
		case 558: goto tr96;
		case 577: goto tr97;
		case 578: goto tr98;
		case 579: goto tr99;
		case 580: goto tr100;
		case 581: goto tr101;
		case 582: goto tr102;
		case 583: goto tr103;
		case 584: goto tr104;
		case 585: goto tr105;
		case 586: goto tr106;
		case 588: goto tr108;
		case 589: goto tr109;
		case 590: goto tr110;
		case 591: goto tr111;
		case 592: goto tr112;
		case 594: goto tr113;
		case 595: goto tr114;
		case 596: goto tr115;
		case 597: goto tr116;
		case 600: goto tr117;
		case 602: goto tr118;
		case 607: goto tr107;
		case 609: goto tr97;
		case 610: goto tr98;
		case 611: goto tr99;
		case 612: goto tr100;
		case 613: goto tr101;
		case 614: goto tr102;
		case 615: goto tr103;
		case 616: goto tr104;
		case 617: goto tr105;
		case 618: goto tr106;
		case 620: goto tr108;
		case 621: goto tr109;
		case 622: goto tr110;
		case 623: goto tr111;
		case 624: goto tr112;
		case 626: goto tr113;
		case 627: goto tr114;
		case 628: goto tr115;
		case 629: goto tr116;
		case 632: goto tr117;
		case 634: goto tr118;
	}
	if ( _widec < 331 ) {
		if ( _widec > 32 ) {
			if ( 50 <= _widec && _widec <= 57 )
				goto tr57;
		} else
			goto tr38;
	} else if ( _widec > 345 ) {
		if ( _widec < 587 ) {
			if ( 363 <= _widec && _widec <= 377 )
				goto tr84;
		} else if ( _widec > 601 ) {
			if ( 619 <= _widec && _widec <= 633 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto st0;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
	if ( (*p) == 61 )
		goto tr120;
	goto tr119;
tr43:
	{te = p+1;}
	{act = 201;}
	goto st23;
tr121:
	{te = p+1;}
	{act = 193;}
	goto st23;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr121;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto tr121;
	} else
		goto tr121;
	goto tr0;
tr64:
	{te = p+1;}
	{act = 201;}
	goto st24;
tr44:
	{te = p+1;}
	{act = 5;}
	goto st24;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
	if ( (*p) == 34 )
		goto st1;
	if ( 48 <= (*p) && (*p) <= 49 )
		goto st25;
	goto tr0;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	switch( (*p) ) {
		case 35: goto st2;
		case 45: goto st2;
	}
	goto tr0;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	switch( (*p) ) {
		case 34: goto tr2;
		case 35: goto st2;
		case 45: goto st2;
	}
	goto tr0;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	if ( 48 <= (*p) && (*p) <= 49 )
		goto st25;
	goto tr124;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
	if ( (*p) == 38 )
		goto tr126;
	goto tr125;
tr47:
	{te = p+1;}
	goto st27;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	switch( (*p) ) {
		case 9: goto st3;
		case 32: goto st3;
		case 66: goto st4;
		case 67: goto st6;
		case 68: goto st7;
		case 72: goto st9;
		case 73: goto st11;
		case 83: goto st14;
		case 98: goto st4;
		case 99: goto st6;
		case 100: goto st7;
		case 104: goto st9;
		case 105: goto st11;
		case 115: goto st14;
	}
	goto tr127;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	switch( (*p) ) {
		case 9: goto st3;
		case 32: goto st3;
		case 66: goto st4;
		case 67: goto st6;
		case 68: goto st7;
		case 72: goto st9;
		case 73: goto st11;
		case 83: goto st14;
		case 98: goto st4;
		case 99: goto st6;
		case 100: goto st7;
		case 104: goto st9;
		case 105: goto st11;
		case 115: goto st14;
	}
	goto tr3;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	switch( (*p) ) {
		case 67: goto st5;
		case 99: goto st5;
	}
	goto tr3;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	switch( (*p) ) {
		case 9: goto st5;
		case 32: goto st5;
		case 41: goto tr12;
	}
	goto tr3;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	switch( (*p) ) {
		case 9: goto st6;
		case 32: goto st6;
		case 41: goto tr13;
	}
	goto tr3;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	switch( (*p) ) {
		case 69: goto st8;
		case 101: goto st8;
	}
	goto tr3;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	switch( (*p) ) {
		case 9: goto st8;
		case 32: goto st8;
		case 41: goto tr15;
	}
	goto tr3;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	switch( (*p) ) {
		case 76: goto st10;
		case 108: goto st10;
	}
	goto tr3;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
	switch( (*p) ) {
		case 9: goto st10;
		case 32: goto st10;
		case 41: goto tr17;
	}
	goto tr3;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
	switch( (*p) ) {
		case 88: goto st12;
		case 89: goto st13;
		case 120: goto st12;
		case 121: goto st13;
	}
	goto tr3;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
	switch( (*p) ) {
		case 9: goto st12;
		case 32: goto st12;
		case 41: goto tr20;
		case 43: goto tr20;
		case 45: goto tr20;
	}
	goto tr3;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	switch( (*p) ) {
		case 9: goto st13;
		case 32: goto st13;
		case 41: goto tr21;
		case 43: goto tr21;
		case 45: goto tr21;
	}
	goto tr3;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	switch( (*p) ) {
		case 80: goto st15;
		case 112: goto st15;
	}
	goto tr3;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	switch( (*p) ) {
		case 9: goto st15;
		case 32: goto st15;
		case 41: goto tr23;
	}
	goto tr3;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
	if ( (*p) == 42 )
		goto tr129;
	goto tr128;
st0:
cs = 0;
	goto _out;
tr55:
	{te = p+1;}
	{act = 191;}
	goto st29;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	switch( (*p) ) {
		case 66: goto tr131;
		case 72: goto tr25;
		case 88: goto st17;
		case 98: goto tr131;
		case 104: goto tr25;
		case 120: goto st17;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr56;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st16;
		} else if ( (*p) >= 65 )
			goto st16;
	} else
		goto tr57;
	goto tr130;
tr56:
	{te = p+1;}
	{act = 191;}
	goto st30;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	switch( (*p) ) {
		case 66: goto tr133;
		case 72: goto tr25;
		case 98: goto tr133;
		case 104: goto tr25;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr56;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st16;
		} else if ( (*p) >= 65 )
			goto st16;
	} else
		goto tr57;
	goto tr130;
tr57:
	{te = p+1;}
	{act = 191;}
	goto st31;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	switch( (*p) ) {
		case 72: goto tr25;
		case 104: goto tr25;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr57;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st16;
	} else
		goto st16;
	goto tr130;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
	switch( (*p) ) {
		case 72: goto tr25;
		case 104: goto tr25;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st16;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st16;
	} else
		goto st16;
	goto tr0;
tr133:
	{te = p+1;}
	{act = 195;}
	goto st32;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
	switch( (*p) ) {
		case 72: goto tr25;
		case 104: goto tr25;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st16;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st16;
	} else
		goto st16;
	goto tr134;
tr131:
	{te = p+1;}
	{act = 195;}
	goto st33;
tr135:
	{te = p+1;}
	{act = 197;}
	goto st33;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	switch( (*p) ) {
		case 72: goto tr25;
		case 104: goto tr25;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr135;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st16;
		} else if ( (*p) >= 65 )
			goto st16;
	} else
		goto st16;
	goto tr0;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st34;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st34;
	} else
		goto st34;
	goto tr26;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st34;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st34;
	} else
		goto st34;
	goto tr136;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( (*p) == 10 )
		goto tr137;
	goto st35;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	switch( (*p) ) {
		case 60: goto tr139;
		case 61: goto tr140;
		case 62: goto tr141;
	}
	goto tr138;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
	if ( (*p) == 61 )
		goto tr143;
	goto tr142;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
	switch( (*p) ) {
		case 61: goto tr145;
		case 62: goto tr146;
	}
	goto tr144;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
	if ( (*p) == 124 )
		goto tr148;
	goto tr147;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
	switch( (*p) ) {
		case 68: goto st42;
		case 70: goto st43;
		case 78: goto st44;
		case 83: goto st45;
		case 95: goto tr84;
		case 100: goto st42;
		case 102: goto st43;
		case 110: goto st44;
		case 115: goto st45;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr149;
tr84:
	{te = p+1;}
	{act = 189;}
	goto st41;
tr95:
	{te = p+1;}
	{act = 38;}
	goto st41;
tr155:
	{te = p+1;}
	{act = 105;}
	goto st41;
tr156:
	{te = p+1;}
	{act = 106;}
	goto st41;
tr159:
	{te = p+1;}
	{act = 107;}
	goto st41;
tr162:
	{te = p+1;}
	{act = 1;}
	goto st41;
tr164:
	{te = p+1;}
	{act = 61;}
	goto st41;
tr167:
	{te = p+1;}
	{act = 108;}
	goto st41;
tr170:
	{te = p+1;}
	{act = 75;}
	goto st41;
tr181:
	{te = p+1;}
	{act = 183;}
	goto st41;
tr183:
	{te = p+1;}
	{act = 184;}
	goto st41;
tr184:
	{te = p+1;}
	{act = 110;}
	goto st41;
tr188:
	{te = p+1;}
	{act = 116;}
	goto st41;
tr190:
	{te = p+1;}
	{act = 113;}
	goto st41;
tr192:
	{te = p+1;}
	{act = 115;}
	goto st41;
tr196:
	{te = p+1;}
	{act = 119;}
	goto st41;
tr199:
	{te = p+1;}
	{act = 117;}
	goto st41;
tr201:
	{te = p+1;}
	{act = 118;}
	goto st41;
tr203:
	{te = p+1;}
	{act = 76;}
	goto st41;
tr204:
	{te = p+1;}
	{act = 77;}
	goto st41;
tr207:
	{te = p+1;}
	{act = 81;}
	goto st41;
tr208:
	{te = p+1;}
	{act = 80;}
	goto st41;
tr209:
	{te = p+1;}
	{act = 82;}
	goto st41;
tr211:
	{te = p+1;}
	{act = 84;}
	goto st41;
tr215:
	{te = p+1;}
	{act = 78;}
	goto st41;
tr217:
	{te = p+1;}
	{act = 79;}
	goto st41;
tr220:
	{te = p+1;}
	{act = 83;}
	goto st41;
tr222:
	{te = p+1;}
	{act = 120;}
	goto st41;
tr230:
	{te = p+1;}
	{act = 59;}
	goto st41;
tr232:
	{te = p+1;}
	{act = 85;}
	goto st41;
tr235:
	{te = p+1;}
	{act = 86;}
	goto st41;
tr238:
	{te = p+1;}
	{act = 123;}
	goto st41;
tr241:
	{te = p+1;}
	{act = 87;}
	goto st41;
tr244:
	{te = p+1;}
	{act = 185;}
	goto st41;
tr249:
	{te = p+1;}
	{act = 88;}
	goto st41;
tr252:
	{te = p+1;}
	{act = 63;}
	goto st41;
tr254:
	{te = p+1;}
	{act = 124;}
	goto st41;
tr258:
	{te = p+1;}
	{act = 125;}
	goto st41;
tr266:
	{te = p+1;}
	{act = 90;}
	goto st41;
tr269:
	{te = p+1;}
	{act = 91;}
	goto st41;
tr270:
	{te = p+1;}
	{act = 57;}
	goto st41;
tr272:
	{te = p+1;}
	{act = 175;}
	goto st41;
tr281:
	{te = p+1;}
	{act = 92;}
	goto st41;
tr283:
	{te = p+1;}
	{act = 129;}
	goto st41;
tr285:
	{te = p+1;}
	{act = 131;}
	goto st41;
tr288:
	{te = p+1;}
	{act = 186;}
	goto st41;
tr290:
	{te = p+1;}
	{act = 49;}
	goto st41;
tr291:
	{te = p+1;}
	{act = 52;}
	goto st41;
tr293:
	{te = p+1;}
	{act = 50;}
	goto st41;
tr294:
	{te = p+1;}
	{act = 53;}
	goto st41;
tr295:
	{te = p+1;}
	{act = 132;}
	goto st41;
tr296:
	{te = p+1;}
	{act = 133;}
	goto st41;
tr305:
	{te = p+1;}
	{act = 136;}
	goto st41;
tr307:
	{te = p+1;}
	{act = 138;}
	goto st41;
tr309:
	{te = p+1;}
	{act = 93;}
	goto st41;
tr313:
	{te = p+1;}
	{act = 95;}
	goto st41;
tr314:
	{te = p+1;}
	{act = 94;}
	goto st41;
tr318:
	{te = p+1;}
	{act = 174;}
	goto st41;
tr322:
	{te = p+1;}
	{act = 96;}
	goto st41;
tr323:
	{te = p+1;}
	{act = 39;}
	goto st41;
tr326:
	{te = p+1;}
	{act = 37;}
	goto st41;
tr327:
	{te = p+1;}
	{act = 139;}
	goto st41;
tr328:
	{te = p+1;}
	{act = 140;}
	goto st41;
tr333:
	{te = p+1;}
	{act = 97;}
	goto st41;
tr337:
	{te = p+1;}
	{act = 142;}
	goto st41;
tr339:
	{te = p+1;}
	{act = 180;}
	goto st41;
tr341:
	{te = p+1;}
	{act = 143;}
	goto st41;
tr343:
	{te = p+1;}
	{act = 178;}
	goto st41;
tr346:
	{te = p+1;}
	{act = 176;}
	goto st41;
tr347:
	{te = p+1;}
	{act = 145;}
	goto st41;
tr348:
	{te = p+1;}
	{act = 146;}
	goto st41;
tr350:
	{te = p+1;}
	{act = 42;}
	goto st41;
tr354:
	{te = p+1;}
	{act = 147;}
	goto st41;
tr359:
	{te = p+1;}
	{act = 98;}
	goto st41;
tr360:
	{te = p+1;}
	{act = 148;}
	goto st41;
tr366:
	{te = p+1;}
	{act = 149;}
	goto st41;
tr369:
	{te = p+1;}
	{act = 151;}
	goto st41;
tr370:
	{te = p+1;}
	{act = 152;}
	goto st41;
tr372:
	{te = p+1;}
	{act = 154;}
	goto st41;
tr374:
	{te = p+1;}
	{act = 157;}
	goto st41;
tr376:
	{te = p+1;}
	{act = 156;}
	goto st41;
tr378:
	{te = p+1;}
	{act = 159;}
	goto st41;
tr380:
	{te = p+1;}
	{act = 162;}
	goto st41;
tr382:
	{te = p+1;}
	{act = 161;}
	goto st41;
tr383:
	{te = p+1;}
	{act = 163;}
	goto st41;
tr388:
	{te = p+1;}
	{act = 67;}
	goto st41;
tr391:
	{te = p+1;}
	{act = 164;}
	goto st41;
tr392:
	{te = p+1;}
	{act = 165;}
	goto st41;
tr394:
	{te = p+1;}
	{act = 166;}
	goto st41;
tr398:
	{te = p+1;}
	{act = 99;}
	goto st41;
tr399:
	{te = p+1;}
	{act = 167;}
	goto st41;
tr400:
	{te = p+1;}
	{act = 168;}
	goto st41;
tr401:
	{te = p+1;}
	{act = 173;}
	goto st41;
tr402:
	{te = p+1;}
	{act = 169;}
	goto st41;
tr403:
	{te = p+1;}
	{act = 170;}
	goto st41;
tr404:
	{te = p+1;}
	{act = 171;}
	goto st41;
tr409:
	{te = p+1;}
	{act = 182;}
	goto st41;
tr416:
	{te = p+1;}
	{act = 100;}
	goto st41;
tr418:
	{te = p+1;}
	{act = 172;}
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
	if ( (*p) == 95 )
		goto tr84;
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr0;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
	switch( (*p) ) {
		case 67: goto tr155;
		case 68: goto tr156;
		case 95: goto tr84;
		case 99: goto tr155;
		case 100: goto tr156;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
	switch( (*p) ) {
		case 39: goto tr158;
		case 95: goto tr84;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr157;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
	switch( (*p) ) {
		case 68: goto tr159;
		case 95: goto tr84;
		case 100: goto tr159;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
	switch( (*p) ) {
		case 77: goto st46;
		case 95: goto tr84;
		case 109: goto st46;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
	switch( (*p) ) {
		case 80: goto st47;
		case 95: goto tr84;
		case 112: goto st47;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
	switch( (*p) ) {
		case 67: goto tr162;
		case 95: goto tr84;
		case 99: goto tr162;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	switch( (*p) ) {
		case 67: goto tr164;
		case 73: goto st49;
		case 95: goto tr84;
		case 99: goto tr164;
		case 105: goto st49;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr163;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	switch( (*p) ) {
		case 78: goto st50;
		case 84: goto tr167;
		case 95: goto tr84;
		case 110: goto st50;
		case 116: goto tr167;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st50:
	if ( ++p == pe )
		goto _test_eof50;
case 50:
	switch( (*p) ) {
		case 65: goto st51;
		case 95: goto tr84;
		case 97: goto st51;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	switch( (*p) ) {
		case 82: goto st52;
		case 95: goto tr84;
		case 114: goto st52;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
	switch( (*p) ) {
		case 89: goto tr170;
		case 95: goto tr84;
		case 121: goto tr170;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st53:
	if ( ++p == pe )
		goto _test_eof53;
case 53:
	switch( (*p) ) {
		case 65: goto st54;
		case 67: goto st61;
		case 80: goto st62;
		case 95: goto tr84;
		case 97: goto st54;
		case 99: goto st61;
		case 112: goto st62;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr171;
st54:
	if ( ++p == pe )
		goto _test_eof54;
case 54:
	switch( (*p) ) {
		case 76: goto st55;
		case 95: goto tr84;
		case 108: goto st55;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st55:
	if ( ++p == pe )
		goto _test_eof55;
case 55:
	switch( (*p) ) {
		case 76: goto st56;
		case 95: goto tr84;
		case 108: goto st56;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st56:
	if ( ++p == pe )
		goto _test_eof56;
case 56:
	if ( (*p) == 95 )
		goto st57;
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr177;
st57:
	if ( ++p == pe )
		goto _test_eof57;
case 57:
	switch( (*p) ) {
		case 79: goto st58;
		case 80: goto st59;
		case 95: goto tr84;
		case 111: goto st58;
		case 112: goto st59;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st58:
	if ( ++p == pe )
		goto _test_eof58;
case 58:
	switch( (*p) ) {
		case 90: goto tr181;
		case 95: goto tr84;
		case 122: goto tr181;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st59:
	if ( ++p == pe )
		goto _test_eof59;
case 59:
	switch( (*p) ) {
		case 75: goto st60;
		case 95: goto tr84;
		case 107: goto st60;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st60:
	if ( ++p == pe )
		goto _test_eof60;
case 60:
	switch( (*p) ) {
		case 71: goto tr183;
		case 95: goto tr84;
		case 103: goto tr183;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st61:
	if ( ++p == pe )
		goto _test_eof61;
case 61:
	switch( (*p) ) {
		case 70: goto tr184;
		case 95: goto tr84;
		case 102: goto tr184;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st62:
	if ( ++p == pe )
		goto _test_eof62;
case 62:
	switch( (*p) ) {
		case 68: goto st63;
		case 73: goto st64;
		case 76: goto tr188;
		case 95: goto tr84;
		case 100: goto st63;
		case 105: goto st64;
		case 108: goto tr188;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr185;
st63:
	if ( ++p == pe )
		goto _test_eof63;
case 63:
	switch( (*p) ) {
		case 82: goto tr190;
		case 95: goto tr84;
		case 114: goto tr190;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr189;
st64:
	if ( ++p == pe )
		goto _test_eof64;
case 64:
	switch( (*p) ) {
		case 82: goto tr192;
		case 95: goto tr84;
		case 114: goto tr192;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr191;
st65:
	if ( ++p == pe )
		goto _test_eof65;
case 65:
	switch( (*p) ) {
		case 65: goto st66;
		case 69: goto st67;
		case 73: goto tr196;
		case 74: goto st78;
		case 83: goto tr198;
		case 95: goto tr84;
		case 97: goto st66;
		case 101: goto st67;
		case 105: goto tr196;
		case 106: goto st78;
		case 115: goto tr198;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr193;
st66:
	if ( ++p == pe )
		goto _test_eof66;
case 66:
	switch( (*p) ) {
		case 65: goto tr199;
		case 95: goto tr84;
		case 97: goto tr199;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st67:
	if ( ++p == pe )
		goto _test_eof67;
case 67:
	switch( (*p) ) {
		case 67: goto tr201;
		case 70: goto st68;
		case 95: goto tr84;
		case 99: goto tr201;
		case 102: goto st68;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr200;
st68:
	if ( ++p == pe )
		goto _test_eof68;
case 68:
	switch( (*p) ) {
		case 66: goto tr203;
		case 67: goto tr204;
		case 71: goto st69;
		case 73: goto st73;
		case 77: goto tr207;
		case 81: goto tr208;
		case 83: goto tr209;
		case 86: goto st75;
		case 87: goto tr211;
		case 95: goto tr84;
		case 98: goto tr203;
		case 99: goto tr204;
		case 103: goto st69;
		case 105: goto st73;
		case 109: goto tr207;
		case 113: goto tr208;
		case 115: goto tr209;
		case 118: goto st75;
		case 119: goto tr211;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st69:
	if ( ++p == pe )
		goto _test_eof69;
case 69:
	switch( (*p) ) {
		case 82: goto st70;
		case 95: goto tr84;
		case 114: goto st70;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st70:
	if ( ++p == pe )
		goto _test_eof70;
case 70:
	switch( (*p) ) {
		case 79: goto st71;
		case 95: goto tr84;
		case 111: goto st71;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st71:
	if ( ++p == pe )
		goto _test_eof71;
case 71:
	switch( (*p) ) {
		case 85: goto st72;
		case 95: goto tr84;
		case 117: goto st72;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st72:
	if ( ++p == pe )
		goto _test_eof72;
case 72:
	switch( (*p) ) {
		case 80: goto tr215;
		case 95: goto tr84;
		case 112: goto tr215;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st73:
	if ( ++p == pe )
		goto _test_eof73;
case 73:
	switch( (*p) ) {
		case 78: goto st74;
		case 95: goto tr84;
		case 110: goto st74;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st74:
	if ( ++p == pe )
		goto _test_eof74;
case 74:
	switch( (*p) ) {
		case 69: goto tr217;
		case 95: goto tr84;
		case 101: goto tr217;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st75:
	if ( ++p == pe )
		goto _test_eof75;
case 75:
	switch( (*p) ) {
		case 65: goto st76;
		case 95: goto tr84;
		case 97: goto st76;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st76:
	if ( ++p == pe )
		goto _test_eof76;
case 76:
	switch( (*p) ) {
		case 82: goto st77;
		case 95: goto tr84;
		case 114: goto st77;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st77:
	if ( ++p == pe )
		goto _test_eof77;
case 77:
	switch( (*p) ) {
		case 83: goto tr220;
		case 95: goto tr84;
		case 115: goto tr220;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st78:
	if ( ++p == pe )
		goto _test_eof78;
case 78:
	switch( (*p) ) {
		case 78: goto st79;
		case 95: goto tr84;
		case 110: goto st79;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st79:
	if ( ++p == pe )
		goto _test_eof79;
case 79:
	switch( (*p) ) {
		case 90: goto tr222;
		case 95: goto tr84;
		case 122: goto tr222;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
tr198:
	{te = p+1;}
	goto st80;
st80:
	if ( ++p == pe )
		goto _test_eof80;
case 80:
	switch( (*p) ) {
		case 46: goto st18;
		case 95: goto tr84;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
	switch( (*p) ) {
		case 66: goto tr29;
		case 80: goto tr30;
		case 81: goto tr31;
		case 87: goto tr32;
		case 98: goto tr29;
		case 112: goto tr30;
		case 113: goto tr31;
		case 119: goto tr32;
	}
	goto tr28;
st81:
	if ( ++p == pe )
		goto _test_eof81;
case 81:
	switch( (*p) ) {
		case 73: goto st82;
		case 76: goto st83;
		case 78: goto st85;
		case 88: goto st88;
		case 95: goto tr84;
		case 105: goto st82;
		case 108: goto st83;
		case 110: goto st85;
		case 120: goto st88;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr224;
st82:
	if ( ++p == pe )
		goto _test_eof82;
case 82:
	switch( (*p) ) {
		case 82: goto tr230;
		case 95: goto tr84;
		case 114: goto tr230;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr229;
st83:
	if ( ++p == pe )
		goto _test_eof83;
case 83:
	switch( (*p) ) {
		case 83: goto st84;
		case 95: goto tr84;
		case 115: goto st84;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st84:
	if ( ++p == pe )
		goto _test_eof84;
case 84:
	switch( (*p) ) {
		case 69: goto tr232;
		case 95: goto tr84;
		case 101: goto tr232;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st85:
	if ( ++p == pe )
		goto _test_eof85;
case 85:
	switch( (*p) ) {
		case 68: goto st86;
		case 95: goto tr84;
		case 100: goto st86;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st86:
	if ( ++p == pe )
		goto _test_eof86;
case 86:
	switch( (*p) ) {
		case 73: goto st87;
		case 95: goto tr84;
		case 105: goto st87;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st87:
	if ( ++p == pe )
		goto _test_eof87;
case 87:
	switch( (*p) ) {
		case 70: goto tr235;
		case 95: goto tr84;
		case 102: goto tr235;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st88:
	if ( ++p == pe )
		goto _test_eof88;
case 88:
	switch( (*p) ) {
		case 84: goto st89;
		case 88: goto tr238;
		case 95: goto tr84;
		case 116: goto st89;
		case 120: goto tr238;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr236;
st89:
	if ( ++p == pe )
		goto _test_eof89;
case 89:
	switch( (*p) ) {
		case 69: goto st90;
		case 95: goto tr84;
		case 101: goto st90;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st90:
	if ( ++p == pe )
		goto _test_eof90;
case 90:
	switch( (*p) ) {
		case 82: goto st91;
		case 95: goto tr84;
		case 114: goto st91;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st91:
	if ( ++p == pe )
		goto _test_eof91;
case 91:
	switch( (*p) ) {
		case 78: goto tr241;
		case 95: goto tr84;
		case 110: goto tr241;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st92:
	if ( ++p == pe )
		goto _test_eof92;
case 92:
	switch( (*p) ) {
		case 80: goto st93;
		case 95: goto tr84;
		case 112: goto st93;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr242;
st93:
	if ( ++p == pe )
		goto _test_eof93;
case 93:
	switch( (*p) ) {
		case 80: goto tr244;
		case 95: goto tr84;
		case 112: goto tr244;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st94:
	if ( ++p == pe )
		goto _test_eof94;
case 94:
	switch( (*p) ) {
		case 76: goto st95;
		case 95: goto tr84;
		case 108: goto st95;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st95:
	if ( ++p == pe )
		goto _test_eof95;
case 95:
	switch( (*p) ) {
		case 79: goto st96;
		case 95: goto tr84;
		case 111: goto st96;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st96:
	if ( ++p == pe )
		goto _test_eof96;
case 96:
	switch( (*p) ) {
		case 66: goto st97;
		case 95: goto tr84;
		case 98: goto st97;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st97:
	if ( ++p == pe )
		goto _test_eof97;
case 97:
	switch( (*p) ) {
		case 65: goto st98;
		case 95: goto tr84;
		case 97: goto st98;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st98:
	if ( ++p == pe )
		goto _test_eof98;
case 98:
	switch( (*p) ) {
		case 76: goto tr249;
		case 95: goto tr84;
		case 108: goto tr249;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st99:
	if ( ++p == pe )
		goto _test_eof99;
case 99:
	switch( (*p) ) {
		case 65: goto st100;
		case 76: goto tr252;
		case 95: goto tr84;
		case 97: goto st100;
		case 108: goto tr252;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr250;
st100:
	if ( ++p == pe )
		goto _test_eof100;
case 100:
	switch( (*p) ) {
		case 76: goto st101;
		case 95: goto tr84;
		case 108: goto st101;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st101:
	if ( ++p == pe )
		goto _test_eof101;
case 101:
	switch( (*p) ) {
		case 84: goto tr254;
		case 95: goto tr84;
		case 116: goto tr254;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st102:
	if ( ++p == pe )
		goto _test_eof102;
case 102:
	switch( (*p) ) {
		case 70: goto st103;
		case 73: goto st109;
		case 77: goto tr258;
		case 78: goto st110;
		case 88: goto st120;
		case 89: goto st121;
		case 95: goto tr84;
		case 102: goto st103;
		case 105: goto st109;
		case 109: goto tr258;
		case 110: goto st110;
		case 120: goto st120;
		case 121: goto st121;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr255;
st103:
	if ( ++p == pe )
		goto _test_eof103;
case 103:
	switch( (*p) ) {
		case 68: goto st104;
		case 78: goto st106;
		case 95: goto tr84;
		case 100: goto st104;
		case 110: goto st106;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr262;
st104:
	if ( ++p == pe )
		goto _test_eof104;
case 104:
	switch( (*p) ) {
		case 69: goto st105;
		case 95: goto tr84;
		case 101: goto st105;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st105:
	if ( ++p == pe )
		goto _test_eof105;
case 105:
	switch( (*p) ) {
		case 70: goto tr266;
		case 95: goto tr84;
		case 102: goto tr266;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st106:
	if ( ++p == pe )
		goto _test_eof106;
case 106:
	switch( (*p) ) {
		case 68: goto st107;
		case 95: goto tr84;
		case 100: goto st107;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st107:
	if ( ++p == pe )
		goto _test_eof107;
case 107:
	switch( (*p) ) {
		case 69: goto st108;
		case 95: goto tr84;
		case 101: goto st108;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st108:
	if ( ++p == pe )
		goto _test_eof108;
case 108:
	switch( (*p) ) {
		case 70: goto tr269;
		case 95: goto tr84;
		case 102: goto tr269;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st109:
	if ( ++p == pe )
		goto _test_eof109;
case 109:
	switch( (*p) ) {
		case 82: goto tr270;
		case 95: goto tr84;
		case 114: goto tr270;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st110:
	if ( ++p == pe )
		goto _test_eof110;
case 110:
	switch( (*p) ) {
		case 48: goto tr272;
		case 67: goto st111;
		case 68: goto st115;
		case 73: goto st116;
		case 86: goto st117;
		case 95: goto tr84;
		case 99: goto st111;
		case 100: goto st115;
		case 105: goto st116;
		case 118: goto st117;
	}
	if ( (*p) < 65 ) {
		if ( 49 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr271;
st111:
	if ( ++p == pe )
		goto _test_eof111;
case 111:
	switch( (*p) ) {
		case 76: goto st112;
		case 95: goto tr84;
		case 108: goto st112;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr277;
st112:
	if ( ++p == pe )
		goto _test_eof112;
case 112:
	switch( (*p) ) {
		case 85: goto st113;
		case 95: goto tr84;
		case 117: goto st113;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st113:
	if ( ++p == pe )
		goto _test_eof113;
case 113:
	switch( (*p) ) {
		case 68: goto st114;
		case 95: goto tr84;
		case 100: goto st114;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st114:
	if ( ++p == pe )
		goto _test_eof114;
case 114:
	switch( (*p) ) {
		case 69: goto tr281;
		case 95: goto tr84;
		case 101: goto tr281;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st115:
	if ( ++p == pe )
		goto _test_eof115;
case 115:
	switch( (*p) ) {
		case 82: goto tr283;
		case 95: goto tr84;
		case 114: goto tr283;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr282;
st116:
	if ( ++p == pe )
		goto _test_eof116;
case 116:
	switch( (*p) ) {
		case 82: goto tr285;
		case 95: goto tr84;
		case 114: goto tr285;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr284;
st117:
	if ( ++p == pe )
		goto _test_eof117;
case 117:
	switch( (*p) ) {
		case 79: goto st118;
		case 95: goto tr84;
		case 111: goto st118;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st118:
	if ( ++p == pe )
		goto _test_eof118;
case 118:
	switch( (*p) ) {
		case 75: goto st119;
		case 95: goto tr84;
		case 107: goto st119;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st119:
	if ( ++p == pe )
		goto _test_eof119;
case 119:
	switch( (*p) ) {
		case 69: goto tr288;
		case 95: goto tr84;
		case 101: goto tr288;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st120:
	if ( ++p == pe )
		goto _test_eof120;
case 120:
	switch( (*p) ) {
		case 72: goto tr290;
		case 76: goto tr291;
		case 95: goto tr84;
		case 104: goto tr290;
		case 108: goto tr291;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr289;
st121:
	if ( ++p == pe )
		goto _test_eof121;
case 121:
	switch( (*p) ) {
		case 72: goto tr293;
		case 76: goto tr294;
		case 95: goto tr84;
		case 104: goto tr293;
		case 108: goto tr294;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr292;
st122:
	if ( ++p == pe )
		goto _test_eof122;
case 122:
	switch( (*p) ) {
		case 80: goto tr295;
		case 82: goto tr296;
		case 95: goto tr84;
		case 112: goto tr295;
		case 114: goto tr296;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st123:
	if ( ++p == pe )
		goto _test_eof123;
case 123:
	switch( (*p) ) {
		case 68: goto st124;
		case 73: goto st127;
		case 83: goto st129;
		case 95: goto tr84;
		case 100: goto st124;
		case 105: goto st127;
		case 115: goto st129;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr297;
st124:
	if ( ++p == pe )
		goto _test_eof124;
case 124:
	switch( (*p) ) {
		case 68: goto st125;
		case 73: goto st126;
		case 95: goto tr84;
		case 100: goto st125;
		case 105: goto st126;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr301;
st125:
	if ( ++p == pe )
		goto _test_eof125;
case 125:
	switch( (*p) ) {
		case 82: goto tr305;
		case 95: goto tr84;
		case 114: goto tr305;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr304;
st126:
	if ( ++p == pe )
		goto _test_eof126;
case 126:
	switch( (*p) ) {
		case 82: goto tr307;
		case 95: goto tr84;
		case 114: goto tr307;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr306;
st127:
	if ( ++p == pe )
		goto _test_eof127;
case 127:
	switch( (*p) ) {
		case 78: goto st128;
		case 95: goto tr84;
		case 110: goto st128;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st128:
	if ( ++p == pe )
		goto _test_eof128;
case 128:
	switch( (*p) ) {
		case 69: goto tr309;
		case 95: goto tr84;
		case 101: goto tr309;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st129:
	if ( ++p == pe )
		goto _test_eof129;
case 129:
	switch( (*p) ) {
		case 84: goto st130;
		case 95: goto tr84;
		case 116: goto st130;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st130:
	if ( ++p == pe )
		goto _test_eof130;
case 130:
	switch( (*p) ) {
		case 79: goto st131;
		case 95: goto tr84;
		case 111: goto st131;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st131:
	if ( ++p == pe )
		goto _test_eof131;
case 131:
	switch( (*p) ) {
		case 70: goto st132;
		case 78: goto tr313;
		case 95: goto tr84;
		case 102: goto st132;
		case 110: goto tr313;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st132:
	if ( ++p == pe )
		goto _test_eof132;
case 132:
	switch( (*p) ) {
		case 70: goto tr314;
		case 95: goto tr84;
		case 102: goto tr314;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st133:
	if ( ++p == pe )
		goto _test_eof133;
case 133:
	switch( (*p) ) {
		case 76: goto st134;
		case 79: goto st135;
		case 95: goto tr84;
		case 108: goto st134;
		case 111: goto st135;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr315;
st134:
	if ( ++p == pe )
		goto _test_eof134;
case 134:
	switch( (*p) ) {
		case 84: goto tr318;
		case 95: goto tr84;
		case 116: goto tr318;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st135:
	if ( ++p == pe )
		goto _test_eof135;
case 135:
	switch( (*p) ) {
		case 68: goto st136;
		case 95: goto tr84;
		case 100: goto st136;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st136:
	if ( ++p == pe )
		goto _test_eof136;
case 136:
	switch( (*p) ) {
		case 85: goto st137;
		case 95: goto tr84;
		case 117: goto st137;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st137:
	if ( ++p == pe )
		goto _test_eof137;
case 137:
	switch( (*p) ) {
		case 76: goto st138;
		case 95: goto tr84;
		case 108: goto st138;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st138:
	if ( ++p == pe )
		goto _test_eof138;
case 138:
	switch( (*p) ) {
		case 69: goto tr322;
		case 95: goto tr84;
		case 101: goto tr322;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st139:
	if ( ++p == pe )
		goto _test_eof139;
case 139:
	switch( (*p) ) {
		case 67: goto tr323;
		case 69: goto st140;
		case 79: goto st141;
		case 90: goto tr326;
		case 95: goto tr84;
		case 99: goto tr323;
		case 101: goto st140;
		case 111: goto st141;
		case 122: goto tr326;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st140:
	if ( ++p == pe )
		goto _test_eof140;
case 140:
	switch( (*p) ) {
		case 71: goto tr327;
		case 95: goto tr84;
		case 103: goto tr327;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st141:
	if ( ++p == pe )
		goto _test_eof141;
case 141:
	switch( (*p) ) {
		case 80: goto tr328;
		case 95: goto tr84;
		case 112: goto tr328;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st142:
	if ( ++p == pe )
		goto _test_eof142;
case 142:
	switch( (*p) ) {
		case 82: goto st143;
		case 84: goto st144;
		case 85: goto st149;
		case 95: goto tr84;
		case 114: goto st143;
		case 116: goto st144;
		case 117: goto st149;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st143:
	if ( ++p == pe )
		goto _test_eof143;
case 143:
	switch( (*p) ) {
		case 71: goto tr333;
		case 95: goto tr84;
		case 103: goto tr333;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr332;
st144:
	if ( ++p == pe )
		goto _test_eof144;
case 144:
	switch( (*p) ) {
		case 68: goto st145;
		case 73: goto st147;
		case 95: goto tr84;
		case 100: goto st145;
		case 105: goto st147;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st145:
	if ( ++p == pe )
		goto _test_eof145;
case 145:
	switch( (*p) ) {
		case 77: goto st146;
		case 82: goto tr337;
		case 95: goto tr84;
		case 109: goto st146;
		case 114: goto tr337;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st146:
	if ( ++p == pe )
		goto _test_eof146;
case 146:
	switch( (*p) ) {
		case 82: goto tr339;
		case 95: goto tr84;
		case 114: goto tr339;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr338;
st147:
	if ( ++p == pe )
		goto _test_eof147;
case 147:
	switch( (*p) ) {
		case 77: goto st148;
		case 82: goto tr341;
		case 95: goto tr84;
		case 109: goto st148;
		case 114: goto tr341;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st148:
	if ( ++p == pe )
		goto _test_eof148;
case 148:
	switch( (*p) ) {
		case 82: goto tr343;
		case 95: goto tr84;
		case 114: goto tr343;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr342;
st149:
	if ( ++p == pe )
		goto _test_eof149;
case 149:
	switch( (*p) ) {
		case 84: goto st150;
		case 95: goto tr84;
		case 116: goto st150;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st150:
	if ( ++p == pe )
		goto _test_eof150;
case 150:
	switch( (*p) ) {
		case 48: goto tr346;
		case 68: goto tr347;
		case 73: goto tr348;
		case 95: goto tr84;
		case 100: goto tr347;
		case 105: goto tr348;
	}
	if ( (*p) < 65 ) {
		if ( 49 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr345;
st151:
	if ( ++p == pe )
		goto _test_eof151;
case 151:
	switch( (*p) ) {
		case 69: goto tr350;
		case 79: goto st152;
		case 85: goto st153;
		case 95: goto tr84;
		case 101: goto tr350;
		case 111: goto st152;
		case 117: goto st153;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr349;
st152:
	if ( ++p == pe )
		goto _test_eof152;
case 152:
	switch( (*p) ) {
		case 80: goto tr354;
		case 95: goto tr84;
		case 112: goto tr354;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr353;
st153:
	if ( ++p == pe )
		goto _test_eof153;
case 153:
	switch( (*p) ) {
		case 66: goto st154;
		case 83: goto st157;
		case 95: goto tr84;
		case 98: goto st154;
		case 115: goto st157;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st154:
	if ( ++p == pe )
		goto _test_eof154;
case 154:
	switch( (*p) ) {
		case 76: goto st155;
		case 95: goto tr84;
		case 108: goto st155;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st155:
	if ( ++p == pe )
		goto _test_eof155;
case 155:
	switch( (*p) ) {
		case 73: goto st156;
		case 95: goto tr84;
		case 105: goto st156;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st156:
	if ( ++p == pe )
		goto _test_eof156;
case 156:
	switch( (*p) ) {
		case 67: goto tr359;
		case 95: goto tr84;
		case 99: goto tr359;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st157:
	if ( ++p == pe )
		goto _test_eof157;
case 157:
	switch( (*p) ) {
		case 72: goto tr360;
		case 95: goto tr84;
		case 104: goto tr360;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st158:
	if ( ++p == pe )
		goto _test_eof158;
case 158:
	switch( (*p) ) {
		case 69: goto st159;
		case 76: goto st161;
		case 82: goto st163;
		case 83: goto st165;
		case 95: goto tr84;
		case 101: goto st159;
		case 108: goto st161;
		case 114: goto st163;
		case 115: goto st165;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr361;
st159:
	if ( ++p == pe )
		goto _test_eof159;
case 159:
	switch( (*p) ) {
		case 83: goto tr366;
		case 84: goto st160;
		case 95: goto tr84;
		case 115: goto tr366;
		case 116: goto st160;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st160:
	if ( ++p == pe )
		goto _test_eof160;
case 160:
	switch( (*p) ) {
		case 73: goto tr369;
		case 78: goto tr370;
		case 95: goto tr84;
		case 105: goto tr369;
		case 110: goto tr370;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr368;
st161:
	if ( ++p == pe )
		goto _test_eof161;
case 161:
	switch( (*p) ) {
		case 65: goto tr372;
		case 67: goto st162;
		case 68: goto tr374;
		case 95: goto tr84;
		case 97: goto tr372;
		case 99: goto st162;
		case 100: goto tr374;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr371;
st162:
	if ( ++p == pe )
		goto _test_eof162;
case 162:
	switch( (*p) ) {
		case 65: goto tr376;
		case 95: goto tr84;
		case 97: goto tr376;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr375;
st163:
	if ( ++p == pe )
		goto _test_eof163;
case 163:
	switch( (*p) ) {
		case 65: goto tr378;
		case 67: goto st164;
		case 68: goto tr380;
		case 95: goto tr84;
		case 97: goto tr378;
		case 99: goto st164;
		case 100: goto tr380;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr377;
st164:
	if ( ++p == pe )
		goto _test_eof164;
case 164:
	switch( (*p) ) {
		case 65: goto tr382;
		case 95: goto tr84;
		case 97: goto tr382;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr381;
st165:
	if ( ++p == pe )
		goto _test_eof165;
case 165:
	switch( (*p) ) {
		case 84: goto tr383;
		case 95: goto tr84;
		case 116: goto tr383;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st166:
	if ( ++p == pe )
		goto _test_eof166;
case 166:
	switch( (*p) ) {
		case 66: goto st167;
		case 67: goto st168;
		case 69: goto st169;
		case 76: goto st174;
		case 80: goto tr388;
		case 82: goto st175;
		case 85: goto st176;
		case 95: goto tr84;
		case 98: goto st167;
		case 99: goto st168;
		case 101: goto st169;
		case 108: goto st174;
		case 112: goto tr388;
		case 114: goto st175;
		case 117: goto st176;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st167:
	if ( ++p == pe )
		goto _test_eof167;
case 167:
	switch( (*p) ) {
		case 67: goto tr391;
		case 95: goto tr84;
		case 99: goto tr391;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st168:
	if ( ++p == pe )
		goto _test_eof168;
case 168:
	switch( (*p) ) {
		case 70: goto tr392;
		case 95: goto tr84;
		case 102: goto tr392;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st169:
	if ( ++p == pe )
		goto _test_eof169;
case 169:
	switch( (*p) ) {
		case 67: goto st170;
		case 84: goto tr394;
		case 95: goto tr84;
		case 99: goto st170;
		case 116: goto tr394;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st170:
	if ( ++p == pe )
		goto _test_eof170;
case 170:
	switch( (*p) ) {
		case 84: goto st171;
		case 95: goto tr84;
		case 116: goto st171;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st171:
	if ( ++p == pe )
		goto _test_eof171;
case 171:
	switch( (*p) ) {
		case 73: goto st172;
		case 95: goto tr84;
		case 105: goto st172;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st172:
	if ( ++p == pe )
		goto _test_eof172;
case 172:
	switch( (*p) ) {
		case 79: goto st173;
		case 95: goto tr84;
		case 111: goto st173;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st173:
	if ( ++p == pe )
		goto _test_eof173;
case 173:
	switch( (*p) ) {
		case 78: goto tr398;
		case 95: goto tr84;
		case 110: goto tr398;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st174:
	if ( ++p == pe )
		goto _test_eof174;
case 174:
	switch( (*p) ) {
		case 65: goto tr399;
		case 76: goto tr400;
		case 80: goto tr401;
		case 95: goto tr84;
		case 97: goto tr399;
		case 108: goto tr400;
		case 112: goto tr401;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st175:
	if ( ++p == pe )
		goto _test_eof175;
case 175:
	switch( (*p) ) {
		case 65: goto tr402;
		case 76: goto tr403;
		case 95: goto tr84;
		case 97: goto tr402;
		case 108: goto tr403;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st176:
	if ( ++p == pe )
		goto _test_eof176;
case 176:
	switch( (*p) ) {
		case 66: goto tr404;
		case 95: goto tr84;
		case 98: goto tr404;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st177:
	if ( ++p == pe )
		goto _test_eof177;
case 177:
	switch( (*p) ) {
		case 83: goto st178;
		case 95: goto tr84;
		case 115: goto st178;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st178:
	if ( ++p == pe )
		goto _test_eof178;
case 178:
	switch( (*p) ) {
		case 84: goto st179;
		case 95: goto tr84;
		case 116: goto st179;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st179:
	if ( ++p == pe )
		goto _test_eof179;
case 179:
	switch( (*p) ) {
		case 73: goto st180;
		case 95: goto tr84;
		case 105: goto st180;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr407;
st180:
	if ( ++p == pe )
		goto _test_eof180;
case 180:
	switch( (*p) ) {
		case 79: goto tr409;
		case 95: goto tr84;
		case 111: goto tr409;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st181:
	if ( ++p == pe )
		goto _test_eof181;
case 181:
	switch( (*p) ) {
		case 78: goto st182;
		case 95: goto tr84;
		case 110: goto st182;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st182:
	if ( ++p == pe )
		goto _test_eof182;
case 182:
	switch( (*p) ) {
		case 68: goto st183;
		case 95: goto tr84;
		case 100: goto st183;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st183:
	if ( ++p == pe )
		goto _test_eof183;
case 183:
	switch( (*p) ) {
		case 69: goto st184;
		case 95: goto tr84;
		case 101: goto st184;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st184:
	if ( ++p == pe )
		goto _test_eof184;
case 184:
	switch( (*p) ) {
		case 70: goto st185;
		case 95: goto tr84;
		case 102: goto st185;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st185:
	if ( ++p == pe )
		goto _test_eof185;
case 185:
	switch( (*p) ) {
		case 73: goto st186;
		case 95: goto tr84;
		case 105: goto st186;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st186:
	if ( ++p == pe )
		goto _test_eof186;
case 186:
	switch( (*p) ) {
		case 78: goto st187;
		case 95: goto tr84;
		case 110: goto st187;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st187:
	if ( ++p == pe )
		goto _test_eof187;
case 187:
	switch( (*p) ) {
		case 69: goto tr416;
		case 95: goto tr84;
		case 101: goto tr416;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st188:
	if ( ++p == pe )
		goto _test_eof188;
case 188:
	switch( (*p) ) {
		case 79: goto st189;
		case 95: goto tr84;
		case 111: goto st189;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
st189:
	if ( ++p == pe )
		goto _test_eof189;
case 189:
	switch( (*p) ) {
		case 82: goto tr418;
		case 95: goto tr84;
		case 114: goto tr418;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr84;
	} else
		goto tr84;
	goto tr154;
tr96:
	{te = p+1;}
	goto st190;
st190:
	if ( ++p == pe )
		goto _test_eof190;
case 190:
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
		case 607: goto st191;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st191;
	} else if ( _widec >= 577 )
		goto st191;
	goto tr419;
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
		case 607: goto st191;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st191;
	} else if ( _widec >= 577 )
		goto st191;
	goto tr33;
st191:
	if ( ++p == pe )
		goto _test_eof191;
case 191:
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
		goto st191;
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st191;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st191;
	} else
		goto st191;
	goto tr420;
tr97:
	{te = p+1;}
	{act = 54;}
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
		case 324: goto st42;
		case 326: goto st43;
		case 334: goto st44;
		case 339: goto st45;
		case 351: goto tr84;
		case 356: goto st42;
		case 358: goto st43;
		case 366: goto st44;
		case 371: goto st45;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr421;
		case 582: goto tr422;
		case 590: goto tr423;
		case 595: goto tr424;
		case 607: goto tr107;
		case 612: goto tr421;
		case 614: goto tr422;
		case 622: goto tr423;
		case 627: goto tr424;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr149;
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
		case 570: goto tr37;
	}
	goto tr0;
tr107:
	{te = p+1;}
	{act = 189;}
	goto st193;
tr118:
	{te = p+1;}
	{act = 38;}
	goto st193;
tr425:
	{te = p+1;}
	{act = 105;}
	goto st193;
tr426:
	{te = p+1;}
	{act = 106;}
	goto st193;
tr427:
	{te = p+1;}
	{act = 107;}
	goto st193;
tr430:
	{te = p+1;}
	{act = 1;}
	goto st193;
tr431:
	{te = p+1;}
	{act = 61;}
	goto st193;
tr434:
	{te = p+1;}
	{act = 108;}
	goto st193;
tr437:
	{te = p+1;}
	{act = 75;}
	goto st193;
tr446:
	{te = p+1;}
	{act = 183;}
	goto st193;
tr448:
	{te = p+1;}
	{act = 184;}
	goto st193;
tr449:
	{te = p+1;}
	{act = 110;}
	goto st193;
tr452:
	{te = p+1;}
	{act = 116;}
	goto st193;
tr453:
	{te = p+1;}
	{act = 113;}
	goto st193;
tr454:
	{te = p+1;}
	{act = 115;}
	goto st193;
tr457:
	{te = p+1;}
	{act = 119;}
	goto st193;
tr460:
	{te = p+1;}
	{act = 117;}
	goto st193;
tr461:
	{te = p+1;}
	{act = 118;}
	goto st193;
tr463:
	{te = p+1;}
	{act = 76;}
	goto st193;
tr464:
	{te = p+1;}
	{act = 77;}
	goto st193;
tr467:
	{te = p+1;}
	{act = 81;}
	goto st193;
tr468:
	{te = p+1;}
	{act = 80;}
	goto st193;
tr469:
	{te = p+1;}
	{act = 82;}
	goto st193;
tr471:
	{te = p+1;}
	{act = 84;}
	goto st193;
tr475:
	{te = p+1;}
	{act = 78;}
	goto st193;
tr477:
	{te = p+1;}
	{act = 79;}
	goto st193;
tr480:
	{te = p+1;}
	{act = 83;}
	goto st193;
tr482:
	{te = p+1;}
	{act = 120;}
	goto st193;
tr487:
	{te = p+1;}
	{act = 59;}
	goto st193;
tr489:
	{te = p+1;}
	{act = 85;}
	goto st193;
tr492:
	{te = p+1;}
	{act = 86;}
	goto st193;
tr494:
	{te = p+1;}
	{act = 123;}
	goto st193;
tr497:
	{te = p+1;}
	{act = 87;}
	goto st193;
tr499:
	{te = p+1;}
	{act = 185;}
	goto st193;
tr504:
	{te = p+1;}
	{act = 88;}
	goto st193;
tr506:
	{te = p+1;}
	{act = 63;}
	goto st193;
tr508:
	{te = p+1;}
	{act = 124;}
	goto st193;
tr511:
	{te = p+1;}
	{act = 125;}
	goto st193;
tr518:
	{te = p+1;}
	{act = 90;}
	goto st193;
tr521:
	{te = p+1;}
	{act = 91;}
	goto st193;
tr522:
	{te = p+1;}
	{act = 57;}
	goto st193;
tr523:
	{te = p+1;}
	{act = 175;}
	goto st193;
tr531:
	{te = p+1;}
	{act = 92;}
	goto st193;
tr532:
	{te = p+1;}
	{act = 129;}
	goto st193;
tr533:
	{te = p+1;}
	{act = 131;}
	goto st193;
tr536:
	{te = p+1;}
	{act = 186;}
	goto st193;
tr537:
	{te = p+1;}
	{act = 49;}
	goto st193;
tr538:
	{te = p+1;}
	{act = 52;}
	goto st193;
tr539:
	{te = p+1;}
	{act = 50;}
	goto st193;
tr540:
	{te = p+1;}
	{act = 53;}
	goto st193;
tr541:
	{te = p+1;}
	{act = 132;}
	goto st193;
tr542:
	{te = p+1;}
	{act = 133;}
	goto st193;
tr548:
	{te = p+1;}
	{act = 136;}
	goto st193;
tr549:
	{te = p+1;}
	{act = 138;}
	goto st193;
tr551:
	{te = p+1;}
	{act = 93;}
	goto st193;
tr555:
	{te = p+1;}
	{act = 95;}
	goto st193;
tr556:
	{te = p+1;}
	{act = 94;}
	goto st193;
tr559:
	{te = p+1;}
	{act = 174;}
	goto st193;
tr563:
	{te = p+1;}
	{act = 96;}
	goto st193;
tr564:
	{te = p+1;}
	{act = 39;}
	goto st193;
tr567:
	{te = p+1;}
	{act = 37;}
	goto st193;
tr568:
	{te = p+1;}
	{act = 139;}
	goto st193;
tr569:
	{te = p+1;}
	{act = 140;}
	goto st193;
tr573:
	{te = p+1;}
	{act = 97;}
	goto st193;
tr577:
	{te = p+1;}
	{act = 142;}
	goto st193;
tr578:
	{te = p+1;}
	{act = 180;}
	goto st193;
tr580:
	{te = p+1;}
	{act = 143;}
	goto st193;
tr581:
	{te = p+1;}
	{act = 178;}
	goto st193;
tr583:
	{te = p+1;}
	{act = 176;}
	goto st193;
tr584:
	{te = p+1;}
	{act = 145;}
	goto st193;
tr585:
	{te = p+1;}
	{act = 146;}
	goto st193;
tr586:
	{te = p+1;}
	{act = 42;}
	goto st193;
tr589:
	{te = p+1;}
	{act = 147;}
	goto st193;
tr594:
	{te = p+1;}
	{act = 98;}
	goto st193;
tr595:
	{te = p+1;}
	{act = 148;}
	goto st193;
tr600:
	{te = p+1;}
	{act = 149;}
	goto st193;
tr602:
	{te = p+1;}
	{act = 151;}
	goto st193;
tr603:
	{te = p+1;}
	{act = 152;}
	goto st193;
tr604:
	{te = p+1;}
	{act = 154;}
	goto st193;
tr606:
	{te = p+1;}
	{act = 157;}
	goto st193;
tr607:
	{te = p+1;}
	{act = 156;}
	goto st193;
tr608:
	{te = p+1;}
	{act = 159;}
	goto st193;
tr610:
	{te = p+1;}
	{act = 162;}
	goto st193;
tr611:
	{te = p+1;}
	{act = 161;}
	goto st193;
tr612:
	{te = p+1;}
	{act = 163;}
	goto st193;
tr617:
	{te = p+1;}
	{act = 67;}
	goto st193;
tr620:
	{te = p+1;}
	{act = 164;}
	goto st193;
tr621:
	{te = p+1;}
	{act = 165;}
	goto st193;
tr623:
	{te = p+1;}
	{act = 166;}
	goto st193;
tr627:
	{te = p+1;}
	{act = 99;}
	goto st193;
tr628:
	{te = p+1;}
	{act = 167;}
	goto st193;
tr629:
	{te = p+1;}
	{act = 168;}
	goto st193;
tr630:
	{te = p+1;}
	{act = 173;}
	goto st193;
tr631:
	{te = p+1;}
	{act = 169;}
	goto st193;
tr632:
	{te = p+1;}
	{act = 170;}
	goto st193;
tr633:
	{te = p+1;}
	{act = 171;}
	goto st193;
tr637:
	{te = p+1;}
	{act = 182;}
	goto st193;
tr644:
	{te = p+1;}
	{act = 100;}
	goto st193;
tr646:
	{te = p+1;}
	{act = 172;}
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
		case 351: goto tr84;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr107;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr0;
tr421:
	{te = p+1;}
	{act = 189;}
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
		case 323: goto tr155;
		case 324: goto tr156;
		case 351: goto tr84;
		case 355: goto tr155;
		case 356: goto tr156;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr425;
		case 580: goto tr426;
		case 607: goto tr107;
		case 611: goto tr425;
		case 612: goto tr426;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr422:
	{te = p+1;}
	{act = 66;}
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
		case 39: goto tr158;
		case 351: goto tr84;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr107;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr157;
tr423:
	{te = p+1;}
	{act = 189;}
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
		case 324: goto tr159;
		case 351: goto tr84;
		case 356: goto tr159;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr427;
		case 607: goto tr107;
		case 612: goto tr427;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr424:
	{te = p+1;}
	{act = 189;}
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
		case 333: goto st46;
		case 351: goto tr84;
		case 365: goto st46;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 589: goto tr428;
		case 607: goto tr107;
		case 621: goto tr428;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr428:
	{te = p+1;}
	{act = 189;}
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
		case 336: goto st47;
		case 351: goto tr84;
		case 368: goto st47;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr429;
		case 607: goto tr107;
		case 624: goto tr429;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr429:
	{te = p+1;}
	{act = 189;}
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
		case 323: goto tr162;
		case 351: goto tr84;
		case 355: goto tr162;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr430;
		case 607: goto tr107;
		case 611: goto tr430;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr98:
	{te = p+1;}
	{act = 45;}
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
		case 323: goto tr164;
		case 329: goto st49;
		case 351: goto tr84;
		case 355: goto tr164;
		case 361: goto st49;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr431;
		case 585: goto tr432;
		case 607: goto tr107;
		case 611: goto tr431;
		case 617: goto tr432;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr163;
tr432:
	{te = p+1;}
	{act = 189;}
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
		case 334: goto st50;
		case 340: goto tr167;
		case 351: goto tr84;
		case 366: goto st50;
		case 372: goto tr167;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr433;
		case 596: goto tr434;
		case 607: goto tr107;
		case 622: goto tr433;
		case 628: goto tr434;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr433:
	{te = p+1;}
	{act = 189;}
	goto st202;
st202:
	if ( ++p == pe )
		goto _test_eof202;
case 202:
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
		case 351: goto tr84;
		case 353: goto st51;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr435;
		case 607: goto tr107;
		case 609: goto tr435;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr435:
	{te = p+1;}
	{act = 189;}
	goto st203;
st203:
	if ( ++p == pe )
		goto _test_eof203;
case 203:
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
		case 338: goto st52;
		case 351: goto tr84;
		case 370: goto st52;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr436;
		case 607: goto tr107;
		case 626: goto tr436;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr436:
	{te = p+1;}
	{act = 189;}
	goto st204;
st204:
	if ( ++p == pe )
		goto _test_eof204;
case 204:
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
		case 345: goto tr170;
		case 351: goto tr84;
		case 377: goto tr170;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 601: goto tr437;
		case 607: goto tr107;
		case 633: goto tr437;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr99:
	{te = p+1;}
	{act = 40;}
	goto st205;
st205:
	if ( ++p == pe )
		goto _test_eof205;
case 205:
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
		case 321: goto st54;
		case 323: goto st61;
		case 336: goto st62;
		case 351: goto tr84;
		case 353: goto st54;
		case 355: goto st61;
		case 368: goto st62;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr438;
		case 579: goto tr439;
		case 592: goto tr440;
		case 607: goto tr107;
		case 609: goto tr438;
		case 611: goto tr439;
		case 624: goto tr440;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr171;
tr438:
	{te = p+1;}
	{act = 189;}
	goto st206;
st206:
	if ( ++p == pe )
		goto _test_eof206;
case 206:
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
		case 332: goto st55;
		case 351: goto tr84;
		case 364: goto st55;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr441;
		case 607: goto tr107;
		case 620: goto tr441;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr441:
	{te = p+1;}
	{act = 189;}
	goto st207;
st207:
	if ( ++p == pe )
		goto _test_eof207;
case 207:
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
		case 332: goto st56;
		case 351: goto tr84;
		case 364: goto st56;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr442;
		case 607: goto tr107;
		case 620: goto tr442;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr442:
	{te = p+1;}
	{act = 109;}
	goto st208;
st208:
	if ( ++p == pe )
		goto _test_eof208;
case 208:
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
		case 351: goto st57;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr443;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr177;
tr443:
	{te = p+1;}
	{act = 189;}
	goto st209;
st209:
	if ( ++p == pe )
		goto _test_eof209;
case 209:
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
		case 335: goto st58;
		case 336: goto st59;
		case 351: goto tr84;
		case 367: goto st58;
		case 368: goto st59;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr444;
		case 592: goto tr445;
		case 607: goto tr107;
		case 623: goto tr444;
		case 624: goto tr445;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr444:
	{te = p+1;}
	{act = 189;}
	goto st210;
st210:
	if ( ++p == pe )
		goto _test_eof210;
case 210:
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
		case 346: goto tr181;
		case 351: goto tr84;
		case 378: goto tr181;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 602: goto tr446;
		case 607: goto tr107;
		case 634: goto tr446;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 377 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 601 ) {
			if ( 609 <= _widec && _widec <= 633 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr445:
	{te = p+1;}
	{act = 189;}
	goto st211;
st211:
	if ( ++p == pe )
		goto _test_eof211;
case 211:
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
		case 331: goto st60;
		case 351: goto tr84;
		case 363: goto st60;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 587: goto tr447;
		case 607: goto tr107;
		case 619: goto tr447;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr447:
	{te = p+1;}
	{act = 189;}
	goto st212;
st212:
	if ( ++p == pe )
		goto _test_eof212;
case 212:
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
		case 327: goto tr183;
		case 351: goto tr84;
		case 359: goto tr183;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 583: goto tr448;
		case 607: goto tr107;
		case 615: goto tr448;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr439:
	{te = p+1;}
	{act = 189;}
	goto st213;
st213:
	if ( ++p == pe )
		goto _test_eof213;
case 213:
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
		case 326: goto tr184;
		case 351: goto tr84;
		case 358: goto tr184;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr449;
		case 607: goto tr107;
		case 614: goto tr449;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr440:
	{te = p+1;}
	{act = 111;}
	goto st214;
st214:
	if ( ++p == pe )
		goto _test_eof214;
case 214:
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
		case 324: goto st63;
		case 329: goto st64;
		case 332: goto tr188;
		case 351: goto tr84;
		case 356: goto st63;
		case 361: goto st64;
		case 364: goto tr188;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr450;
		case 585: goto tr451;
		case 588: goto tr452;
		case 607: goto tr107;
		case 612: goto tr450;
		case 617: goto tr451;
		case 620: goto tr452;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr185;
tr450:
	{te = p+1;}
	{act = 112;}
	goto st215;
st215:
	if ( ++p == pe )
		goto _test_eof215;
case 215:
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
		case 338: goto tr190;
		case 351: goto tr84;
		case 370: goto tr190;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr453;
		case 607: goto tr107;
		case 626: goto tr453;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr189;
tr451:
	{te = p+1;}
	{act = 114;}
	goto st216;
st216:
	if ( ++p == pe )
		goto _test_eof216;
case 216:
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
		case 338: goto tr192;
		case 351: goto tr84;
		case 370: goto tr192;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr454;
		case 607: goto tr107;
		case 626: goto tr454;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr191;
tr100:
	{te = p+1;}
	{act = 46;}
	goto st217;
st217:
	if ( ++p == pe )
		goto _test_eof217;
case 217:
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
		case 325: goto st67;
		case 329: goto tr196;
		case 330: goto st78;
		case 339: goto tr198;
		case 351: goto tr84;
		case 353: goto st66;
		case 357: goto st67;
		case 361: goto tr196;
		case 362: goto st78;
		case 371: goto tr198;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr455;
		case 581: goto tr456;
		case 585: goto tr457;
		case 586: goto tr458;
		case 595: goto tr459;
		case 607: goto tr107;
		case 609: goto tr455;
		case 613: goto tr456;
		case 617: goto tr457;
		case 618: goto tr458;
		case 627: goto tr459;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr193;
tr455:
	{te = p+1;}
	{act = 189;}
	goto st218;
st218:
	if ( ++p == pe )
		goto _test_eof218;
case 218:
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
		case 321: goto tr199;
		case 351: goto tr84;
		case 353: goto tr199;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr460;
		case 607: goto tr107;
		case 609: goto tr460;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr456:
	{te = p+1;}
	{act = 62;}
	goto st219;
st219:
	if ( ++p == pe )
		goto _test_eof219;
case 219:
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
		case 323: goto tr201;
		case 326: goto st68;
		case 351: goto tr84;
		case 355: goto tr201;
		case 358: goto st68;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr461;
		case 582: goto tr462;
		case 607: goto tr107;
		case 611: goto tr461;
		case 614: goto tr462;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr200;
tr462:
	{te = p+1;}
	{act = 189;}
	goto st220;
st220:
	if ( ++p == pe )
		goto _test_eof220;
case 220:
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
		case 322: goto tr203;
		case 323: goto tr204;
		case 327: goto st69;
		case 329: goto st73;
		case 333: goto tr207;
		case 337: goto tr208;
		case 339: goto tr209;
		case 342: goto st75;
		case 343: goto tr211;
		case 351: goto tr84;
		case 354: goto tr203;
		case 355: goto tr204;
		case 359: goto st69;
		case 361: goto st73;
		case 365: goto tr207;
		case 369: goto tr208;
		case 371: goto tr209;
		case 374: goto st75;
		case 375: goto tr211;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr463;
		case 579: goto tr464;
		case 583: goto tr465;
		case 585: goto tr466;
		case 589: goto tr467;
		case 593: goto tr468;
		case 595: goto tr469;
		case 598: goto tr470;
		case 599: goto tr471;
		case 607: goto tr107;
		case 610: goto tr463;
		case 611: goto tr464;
		case 615: goto tr465;
		case 617: goto tr466;
		case 621: goto tr467;
		case 625: goto tr468;
		case 627: goto tr469;
		case 630: goto tr470;
		case 631: goto tr471;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr465:
	{te = p+1;}
	{act = 189;}
	goto st221;
st221:
	if ( ++p == pe )
		goto _test_eof221;
case 221:
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
		case 338: goto st70;
		case 351: goto tr84;
		case 370: goto st70;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr472;
		case 607: goto tr107;
		case 626: goto tr472;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr472:
	{te = p+1;}
	{act = 189;}
	goto st222;
st222:
	if ( ++p == pe )
		goto _test_eof222;
case 222:
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
		case 335: goto st71;
		case 351: goto tr84;
		case 367: goto st71;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr473;
		case 607: goto tr107;
		case 623: goto tr473;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr473:
	{te = p+1;}
	{act = 189;}
	goto st223;
st223:
	if ( ++p == pe )
		goto _test_eof223;
case 223:
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
		case 341: goto st72;
		case 351: goto tr84;
		case 373: goto st72;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 597: goto tr474;
		case 607: goto tr107;
		case 629: goto tr474;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr474:
	{te = p+1;}
	{act = 189;}
	goto st224;
st224:
	if ( ++p == pe )
		goto _test_eof224;
case 224:
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
		case 336: goto tr215;
		case 351: goto tr84;
		case 368: goto tr215;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr475;
		case 607: goto tr107;
		case 624: goto tr475;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr466:
	{te = p+1;}
	{act = 189;}
	goto st225;
st225:
	if ( ++p == pe )
		goto _test_eof225;
case 225:
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
		case 334: goto st74;
		case 351: goto tr84;
		case 366: goto st74;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr476;
		case 607: goto tr107;
		case 622: goto tr476;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr476:
	{te = p+1;}
	{act = 189;}
	goto st226;
st226:
	if ( ++p == pe )
		goto _test_eof226;
case 226:
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
		case 325: goto tr217;
		case 351: goto tr84;
		case 357: goto tr217;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr477;
		case 607: goto tr107;
		case 613: goto tr477;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr470:
	{te = p+1;}
	{act = 189;}
	goto st227;
st227:
	if ( ++p == pe )
		goto _test_eof227;
case 227:
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
		case 321: goto st76;
		case 351: goto tr84;
		case 353: goto st76;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr478;
		case 607: goto tr107;
		case 609: goto tr478;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr478:
	{te = p+1;}
	{act = 189;}
	goto st228;
st228:
	if ( ++p == pe )
		goto _test_eof228;
case 228:
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
		case 338: goto st77;
		case 351: goto tr84;
		case 370: goto st77;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr479;
		case 607: goto tr107;
		case 626: goto tr479;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr479:
	{te = p+1;}
	{act = 189;}
	goto st229;
st229:
	if ( ++p == pe )
		goto _test_eof229;
case 229:
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
		case 339: goto tr220;
		case 351: goto tr84;
		case 371: goto tr220;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr480;
		case 607: goto tr107;
		case 627: goto tr480;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr458:
	{te = p+1;}
	{act = 189;}
	goto st230;
st230:
	if ( ++p == pe )
		goto _test_eof230;
case 230:
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
		case 334: goto st79;
		case 351: goto tr84;
		case 366: goto st79;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr481;
		case 607: goto tr107;
		case 622: goto tr481;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr481:
	{te = p+1;}
	{act = 189;}
	goto st231;
st231:
	if ( ++p == pe )
		goto _test_eof231;
case 231:
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
		case 346: goto tr222;
		case 351: goto tr84;
		case 378: goto tr222;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 602: goto tr482;
		case 607: goto tr107;
		case 634: goto tr482;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 377 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 601 ) {
			if ( 609 <= _widec && _widec <= 633 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr459:
	{te = p+1;}
	{act = 189;}
	goto st232;
st232:
	if ( ++p == pe )
		goto _test_eof232;
case 232:
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
		case 351: goto tr84;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr107;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr101:
	{te = p+1;}
	{act = 47;}
	goto st233;
st233:
	if ( ++p == pe )
		goto _test_eof233;
case 233:
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
		case 329: goto st82;
		case 332: goto st83;
		case 334: goto st85;
		case 344: goto st88;
		case 351: goto tr84;
		case 361: goto st82;
		case 364: goto st83;
		case 366: goto st85;
		case 376: goto st88;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr483;
		case 588: goto tr484;
		case 590: goto tr485;
		case 600: goto tr486;
		case 607: goto tr107;
		case 617: goto tr483;
		case 620: goto tr484;
		case 622: goto tr485;
		case 632: goto tr486;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr224;
tr483:
	{te = p+1;}
	{act = 121;}
	goto st234;
st234:
	if ( ++p == pe )
		goto _test_eof234;
case 234:
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
		case 338: goto tr230;
		case 351: goto tr84;
		case 370: goto tr230;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr487;
		case 607: goto tr107;
		case 626: goto tr487;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr229;
tr484:
	{te = p+1;}
	{act = 189;}
	goto st235;
st235:
	if ( ++p == pe )
		goto _test_eof235;
case 235:
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
		case 339: goto st84;
		case 351: goto tr84;
		case 371: goto st84;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr488;
		case 607: goto tr107;
		case 627: goto tr488;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr488:
	{te = p+1;}
	{act = 189;}
	goto st236;
st236:
	if ( ++p == pe )
		goto _test_eof236;
case 236:
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
		case 325: goto tr232;
		case 351: goto tr84;
		case 357: goto tr232;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr489;
		case 607: goto tr107;
		case 613: goto tr489;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr485:
	{te = p+1;}
	{act = 189;}
	goto st237;
st237:
	if ( ++p == pe )
		goto _test_eof237;
case 237:
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
		case 351: goto tr84;
		case 356: goto st86;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr490;
		case 607: goto tr107;
		case 612: goto tr490;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr490:
	{te = p+1;}
	{act = 189;}
	goto st238;
st238:
	if ( ++p == pe )
		goto _test_eof238;
case 238:
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
		case 329: goto st87;
		case 351: goto tr84;
		case 361: goto st87;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr491;
		case 607: goto tr107;
		case 617: goto tr491;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr491:
	{te = p+1;}
	{act = 189;}
	goto st239;
st239:
	if ( ++p == pe )
		goto _test_eof239;
case 239:
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
		case 326: goto tr235;
		case 351: goto tr84;
		case 358: goto tr235;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr492;
		case 607: goto tr107;
		case 614: goto tr492;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr486:
	{te = p+1;}
	{act = 122;}
	goto st240;
st240:
	if ( ++p == pe )
		goto _test_eof240;
case 240:
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
		case 340: goto st89;
		case 344: goto tr238;
		case 351: goto tr84;
		case 372: goto st89;
		case 376: goto tr238;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr493;
		case 600: goto tr494;
		case 607: goto tr107;
		case 628: goto tr493;
		case 632: goto tr494;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr236;
tr493:
	{te = p+1;}
	{act = 189;}
	goto st241;
st241:
	if ( ++p == pe )
		goto _test_eof241;
case 241:
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
		case 325: goto st90;
		case 351: goto tr84;
		case 357: goto st90;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr495;
		case 607: goto tr107;
		case 613: goto tr495;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr495:
	{te = p+1;}
	{act = 189;}
	goto st242;
st242:
	if ( ++p == pe )
		goto _test_eof242;
case 242:
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
		case 338: goto st91;
		case 351: goto tr84;
		case 370: goto st91;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr496;
		case 607: goto tr107;
		case 626: goto tr496;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr496:
	{te = p+1;}
	{act = 189;}
	goto st243;
st243:
	if ( ++p == pe )
		goto _test_eof243;
case 243:
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
		case 334: goto tr241;
		case 351: goto tr84;
		case 366: goto tr241;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr497;
		case 607: goto tr107;
		case 622: goto tr497;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr102:
	{te = p+1;}
	{act = 55;}
	goto st244;
st244:
	if ( ++p == pe )
		goto _test_eof244;
case 244:
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
		case 336: goto st93;
		case 351: goto tr84;
		case 368: goto st93;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr498;
		case 607: goto tr107;
		case 624: goto tr498;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr242;
tr498:
	{te = p+1;}
	{act = 189;}
	goto st245;
st245:
	if ( ++p == pe )
		goto _test_eof245;
case 245:
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
		case 336: goto tr244;
		case 351: goto tr84;
		case 368: goto tr244;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr499;
		case 607: goto tr107;
		case 624: goto tr499;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr103:
	{te = p+1;}
	{act = 189;}
	goto st246;
st246:
	if ( ++p == pe )
		goto _test_eof246;
case 246:
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
		case 332: goto st95;
		case 351: goto tr84;
		case 364: goto st95;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr500;
		case 607: goto tr107;
		case 620: goto tr500;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr500:
	{te = p+1;}
	{act = 189;}
	goto st247;
st247:
	if ( ++p == pe )
		goto _test_eof247;
case 247:
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
		case 335: goto st96;
		case 351: goto tr84;
		case 367: goto st96;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr501;
		case 607: goto tr107;
		case 623: goto tr501;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr501:
	{te = p+1;}
	{act = 189;}
	goto st248;
st248:
	if ( ++p == pe )
		goto _test_eof248;
case 248:
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
		case 322: goto st97;
		case 351: goto tr84;
		case 354: goto st97;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr502;
		case 607: goto tr107;
		case 610: goto tr502;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr502:
	{te = p+1;}
	{act = 189;}
	goto st249;
st249:
	if ( ++p == pe )
		goto _test_eof249;
case 249:
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
		case 321: goto st98;
		case 351: goto tr84;
		case 353: goto st98;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr503;
		case 607: goto tr107;
		case 609: goto tr503;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr503:
	{te = p+1;}
	{act = 189;}
	goto st250;
st250:
	if ( ++p == pe )
		goto _test_eof250;
case 250:
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
		case 332: goto tr249;
		case 351: goto tr84;
		case 364: goto tr249;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr504;
		case 607: goto tr107;
		case 620: goto tr504;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr104:
	{te = p+1;}
	{act = 48;}
	goto st251;
st251:
	if ( ++p == pe )
		goto _test_eof251;
case 251:
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
		case 321: goto st100;
		case 332: goto tr252;
		case 351: goto tr84;
		case 353: goto st100;
		case 364: goto tr252;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr505;
		case 588: goto tr506;
		case 607: goto tr107;
		case 609: goto tr505;
		case 620: goto tr506;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr250;
tr505:
	{te = p+1;}
	{act = 189;}
	goto st252;
st252:
	if ( ++p == pe )
		goto _test_eof252;
case 252:
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
		case 332: goto st101;
		case 351: goto tr84;
		case 364: goto st101;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr507;
		case 607: goto tr107;
		case 620: goto tr507;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr507:
	{te = p+1;}
	{act = 189;}
	goto st253;
st253:
	if ( ++p == pe )
		goto _test_eof253;
case 253:
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
		case 340: goto tr254;
		case 351: goto tr84;
		case 372: goto tr254;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr508;
		case 607: goto tr107;
		case 628: goto tr508;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr105:
	{te = p+1;}
	{act = 56;}
	goto st254;
st254:
	if ( ++p == pe )
		goto _test_eof254;
case 254:
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
		case 326: goto st103;
		case 329: goto st109;
		case 333: goto tr258;
		case 334: goto st110;
		case 344: goto st120;
		case 345: goto st121;
		case 351: goto tr84;
		case 358: goto st103;
		case 361: goto st109;
		case 365: goto tr258;
		case 366: goto st110;
		case 376: goto st120;
		case 377: goto st121;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr509;
		case 585: goto tr510;
		case 589: goto tr511;
		case 590: goto tr512;
		case 600: goto tr513;
		case 601: goto tr514;
		case 607: goto tr107;
		case 614: goto tr509;
		case 617: goto tr510;
		case 621: goto tr511;
		case 622: goto tr512;
		case 632: goto tr513;
		case 633: goto tr514;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr255;
tr509:
	{te = p+1;}
	{act = 89;}
	goto st255;
st255:
	if ( ++p == pe )
		goto _test_eof255;
case 255:
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
		case 324: goto st104;
		case 334: goto st106;
		case 351: goto tr84;
		case 356: goto st104;
		case 366: goto st106;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr515;
		case 590: goto tr516;
		case 607: goto tr107;
		case 612: goto tr515;
		case 622: goto tr516;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr262;
tr515:
	{te = p+1;}
	{act = 189;}
	goto st256;
st256:
	if ( ++p == pe )
		goto _test_eof256;
case 256:
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
		case 325: goto st105;
		case 351: goto tr84;
		case 357: goto st105;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr517;
		case 607: goto tr107;
		case 613: goto tr517;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr517:
	{te = p+1;}
	{act = 189;}
	goto st257;
st257:
	if ( ++p == pe )
		goto _test_eof257;
case 257:
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
		case 326: goto tr266;
		case 351: goto tr84;
		case 358: goto tr266;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr518;
		case 607: goto tr107;
		case 614: goto tr518;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr516:
	{te = p+1;}
	{act = 189;}
	goto st258;
st258:
	if ( ++p == pe )
		goto _test_eof258;
case 258:
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
		case 324: goto st107;
		case 351: goto tr84;
		case 356: goto st107;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr519;
		case 607: goto tr107;
		case 612: goto tr519;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr519:
	{te = p+1;}
	{act = 189;}
	goto st259;
st259:
	if ( ++p == pe )
		goto _test_eof259;
case 259:
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
		case 325: goto st108;
		case 351: goto tr84;
		case 357: goto st108;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr520;
		case 607: goto tr107;
		case 613: goto tr520;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr520:
	{te = p+1;}
	{act = 189;}
	goto st260;
st260:
	if ( ++p == pe )
		goto _test_eof260;
case 260:
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
		case 326: goto tr269;
		case 351: goto tr84;
		case 358: goto tr269;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr521;
		case 607: goto tr107;
		case 614: goto tr521;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr510:
	{te = p+1;}
	{act = 189;}
	goto st261;
st261:
	if ( ++p == pe )
		goto _test_eof261;
case 261:
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
		case 338: goto tr270;
		case 351: goto tr84;
		case 370: goto tr270;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr522;
		case 607: goto tr107;
		case 626: goto tr522;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr512:
	{te = p+1;}
	{act = 126;}
	goto st262;
st262:
	if ( ++p == pe )
		goto _test_eof262;
case 262:
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
		case 304: goto tr272;
		case 323: goto st111;
		case 324: goto st115;
		case 329: goto st116;
		case 342: goto st117;
		case 351: goto tr84;
		case 355: goto st111;
		case 356: goto st115;
		case 361: goto st116;
		case 374: goto st117;
		case 521: goto st20;
		case 544: goto st20;
		case 560: goto tr523;
		case 570: goto tr37;
		case 579: goto tr524;
		case 580: goto tr525;
		case 585: goto tr526;
		case 598: goto tr527;
		case 607: goto tr107;
		case 611: goto tr524;
		case 612: goto tr525;
		case 617: goto tr526;
		case 630: goto tr527;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 305 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 561 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr271;
tr524:
	{te = p+1;}
	{act = 127;}
	goto st263;
st263:
	if ( ++p == pe )
		goto _test_eof263;
case 263:
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
		case 332: goto st112;
		case 351: goto tr84;
		case 364: goto st112;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr528;
		case 607: goto tr107;
		case 620: goto tr528;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr277;
tr528:
	{te = p+1;}
	{act = 189;}
	goto st264;
st264:
	if ( ++p == pe )
		goto _test_eof264;
case 264:
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
		case 341: goto st113;
		case 351: goto tr84;
		case 373: goto st113;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 597: goto tr529;
		case 607: goto tr107;
		case 629: goto tr529;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr529:
	{te = p+1;}
	{act = 189;}
	goto st265;
st265:
	if ( ++p == pe )
		goto _test_eof265;
case 265:
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
		case 324: goto st114;
		case 351: goto tr84;
		case 356: goto st114;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr530;
		case 607: goto tr107;
		case 612: goto tr530;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr530:
	{te = p+1;}
	{act = 189;}
	goto st266;
st266:
	if ( ++p == pe )
		goto _test_eof266;
case 266:
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
		case 325: goto tr281;
		case 351: goto tr84;
		case 357: goto tr281;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr531;
		case 607: goto tr107;
		case 613: goto tr531;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr525:
	{te = p+1;}
	{act = 128;}
	goto st267;
st267:
	if ( ++p == pe )
		goto _test_eof267;
case 267:
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
		case 338: goto tr283;
		case 351: goto tr84;
		case 370: goto tr283;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr532;
		case 607: goto tr107;
		case 626: goto tr532;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr282;
tr526:
	{te = p+1;}
	{act = 130;}
	goto st268;
st268:
	if ( ++p == pe )
		goto _test_eof268;
case 268:
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
		case 338: goto tr285;
		case 351: goto tr84;
		case 370: goto tr285;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr533;
		case 607: goto tr107;
		case 626: goto tr533;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr284;
tr527:
	{te = p+1;}
	{act = 189;}
	goto st269;
st269:
	if ( ++p == pe )
		goto _test_eof269;
case 269:
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
		case 335: goto st118;
		case 351: goto tr84;
		case 367: goto st118;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr534;
		case 607: goto tr107;
		case 623: goto tr534;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr534:
	{te = p+1;}
	{act = 189;}
	goto st270;
st270:
	if ( ++p == pe )
		goto _test_eof270;
case 270:
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
		case 331: goto st119;
		case 351: goto tr84;
		case 363: goto st119;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 587: goto tr535;
		case 607: goto tr107;
		case 619: goto tr535;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr535:
	{te = p+1;}
	{act = 189;}
	goto st271;
st271:
	if ( ++p == pe )
		goto _test_eof271;
case 271:
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
		case 325: goto tr288;
		case 351: goto tr84;
		case 357: goto tr288;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr536;
		case 607: goto tr107;
		case 613: goto tr536;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr513:
	{te = p+1;}
	{act = 64;}
	goto st272;
st272:
	if ( ++p == pe )
		goto _test_eof272;
case 272:
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
		case 328: goto tr290;
		case 332: goto tr291;
		case 351: goto tr84;
		case 360: goto tr290;
		case 364: goto tr291;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 584: goto tr537;
		case 588: goto tr538;
		case 607: goto tr107;
		case 616: goto tr537;
		case 620: goto tr538;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr289;
tr514:
	{te = p+1;}
	{act = 65;}
	goto st273;
st273:
	if ( ++p == pe )
		goto _test_eof273;
case 273:
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
		case 328: goto tr293;
		case 332: goto tr294;
		case 351: goto tr84;
		case 360: goto tr293;
		case 364: goto tr294;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 584: goto tr539;
		case 588: goto tr540;
		case 607: goto tr107;
		case 616: goto tr539;
		case 620: goto tr540;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr292;
tr106:
	{te = p+1;}
	{act = 189;}
	goto st274;
st274:
	if ( ++p == pe )
		goto _test_eof274;
case 274:
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
		case 336: goto tr295;
		case 338: goto tr296;
		case 351: goto tr84;
		case 368: goto tr295;
		case 370: goto tr296;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr541;
		case 594: goto tr542;
		case 607: goto tr107;
		case 624: goto tr541;
		case 626: goto tr542;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr108:
	{te = p+1;}
	{act = 51;}
	goto st275;
st275:
	if ( ++p == pe )
		goto _test_eof275;
case 275:
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
		case 324: goto st124;
		case 329: goto st127;
		case 339: goto st129;
		case 351: goto tr84;
		case 356: goto st124;
		case 361: goto st127;
		case 371: goto st129;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr543;
		case 585: goto tr544;
		case 595: goto tr545;
		case 607: goto tr107;
		case 612: goto tr543;
		case 617: goto tr544;
		case 627: goto tr545;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr297;
tr543:
	{te = p+1;}
	{act = 134;}
	goto st276;
st276:
	if ( ++p == pe )
		goto _test_eof276;
case 276:
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
		case 324: goto st125;
		case 329: goto st126;
		case 351: goto tr84;
		case 356: goto st125;
		case 361: goto st126;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr546;
		case 585: goto tr547;
		case 607: goto tr107;
		case 612: goto tr546;
		case 617: goto tr547;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr301;
tr546:
	{te = p+1;}
	{act = 135;}
	goto st277;
st277:
	if ( ++p == pe )
		goto _test_eof277;
case 277:
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
		case 338: goto tr305;
		case 351: goto tr84;
		case 370: goto tr305;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr548;
		case 607: goto tr107;
		case 626: goto tr548;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr304;
tr547:
	{te = p+1;}
	{act = 137;}
	goto st278;
st278:
	if ( ++p == pe )
		goto _test_eof278;
case 278:
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
		case 338: goto tr307;
		case 351: goto tr84;
		case 370: goto tr307;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr549;
		case 607: goto tr107;
		case 626: goto tr549;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr306;
tr544:
	{te = p+1;}
	{act = 189;}
	goto st279;
st279:
	if ( ++p == pe )
		goto _test_eof279;
case 279:
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
		case 334: goto st128;
		case 351: goto tr84;
		case 366: goto st128;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr550;
		case 607: goto tr107;
		case 622: goto tr550;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr550:
	{te = p+1;}
	{act = 189;}
	goto st280;
st280:
	if ( ++p == pe )
		goto _test_eof280;
case 280:
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
		case 325: goto tr309;
		case 351: goto tr84;
		case 357: goto tr309;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr551;
		case 607: goto tr107;
		case 613: goto tr551;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr545:
	{te = p+1;}
	{act = 189;}
	goto st281;
st281:
	if ( ++p == pe )
		goto _test_eof281;
case 281:
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
		case 340: goto st130;
		case 351: goto tr84;
		case 372: goto st130;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr552;
		case 607: goto tr107;
		case 628: goto tr552;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr552:
	{te = p+1;}
	{act = 189;}
	goto st282;
st282:
	if ( ++p == pe )
		goto _test_eof282;
case 282:
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
		case 335: goto st131;
		case 351: goto tr84;
		case 367: goto st131;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr553;
		case 607: goto tr107;
		case 623: goto tr553;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr553:
	{te = p+1;}
	{act = 189;}
	goto st283;
st283:
	if ( ++p == pe )
		goto _test_eof283;
case 283:
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
		case 326: goto st132;
		case 334: goto tr313;
		case 351: goto tr84;
		case 358: goto st132;
		case 366: goto tr313;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr554;
		case 590: goto tr555;
		case 607: goto tr107;
		case 614: goto tr554;
		case 622: goto tr555;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr554:
	{te = p+1;}
	{act = 189;}
	goto st284;
st284:
	if ( ++p == pe )
		goto _test_eof284;
case 284:
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
		case 326: goto tr314;
		case 351: goto tr84;
		case 358: goto tr314;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr556;
		case 607: goto tr107;
		case 614: goto tr556;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr109:
	{te = p+1;}
	{act = 44;}
	goto st285;
st285:
	if ( ++p == pe )
		goto _test_eof285;
case 285:
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
		case 332: goto st134;
		case 335: goto st135;
		case 351: goto tr84;
		case 364: goto st134;
		case 367: goto st135;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr557;
		case 591: goto tr558;
		case 607: goto tr107;
		case 620: goto tr557;
		case 623: goto tr558;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr315;
tr557:
	{te = p+1;}
	{act = 189;}
	goto st286;
st286:
	if ( ++p == pe )
		goto _test_eof286;
case 286:
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
		case 340: goto tr318;
		case 351: goto tr84;
		case 372: goto tr318;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr559;
		case 607: goto tr107;
		case 628: goto tr559;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr558:
	{te = p+1;}
	{act = 189;}
	goto st287;
st287:
	if ( ++p == pe )
		goto _test_eof287;
case 287:
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
		case 324: goto st136;
		case 351: goto tr84;
		case 356: goto st136;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr560;
		case 607: goto tr107;
		case 612: goto tr560;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr560:
	{te = p+1;}
	{act = 189;}
	goto st288;
st288:
	if ( ++p == pe )
		goto _test_eof288;
case 288:
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
		case 341: goto st137;
		case 351: goto tr84;
		case 373: goto st137;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 597: goto tr561;
		case 607: goto tr107;
		case 629: goto tr561;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr561:
	{te = p+1;}
	{act = 189;}
	goto st289;
st289:
	if ( ++p == pe )
		goto _test_eof289;
case 289:
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
		case 332: goto st138;
		case 351: goto tr84;
		case 364: goto st138;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr562;
		case 607: goto tr107;
		case 620: goto tr562;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr562:
	{te = p+1;}
	{act = 189;}
	goto st290;
st290:
	if ( ++p == pe )
		goto _test_eof290;
case 290:
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
		case 325: goto tr322;
		case 351: goto tr84;
		case 357: goto tr322;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr563;
		case 607: goto tr107;
		case 613: goto tr563;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr110:
	{te = p+1;}
	{act = 189;}
	goto st291;
st291:
	if ( ++p == pe )
		goto _test_eof291;
case 291:
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
		case 323: goto tr323;
		case 325: goto st140;
		case 335: goto st141;
		case 346: goto tr326;
		case 351: goto tr84;
		case 355: goto tr323;
		case 357: goto st140;
		case 367: goto st141;
		case 378: goto tr326;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr564;
		case 581: goto tr565;
		case 591: goto tr566;
		case 602: goto tr567;
		case 607: goto tr107;
		case 611: goto tr564;
		case 613: goto tr565;
		case 623: goto tr566;
		case 634: goto tr567;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 377 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 601 ) {
			if ( 609 <= _widec && _widec <= 633 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr565:
	{te = p+1;}
	{act = 189;}
	goto st292;
st292:
	if ( ++p == pe )
		goto _test_eof292;
case 292:
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
		case 327: goto tr327;
		case 351: goto tr84;
		case 359: goto tr327;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 583: goto tr568;
		case 607: goto tr107;
		case 615: goto tr568;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr566:
	{te = p+1;}
	{act = 189;}
	goto st293;
st293:
	if ( ++p == pe )
		goto _test_eof293;
case 293:
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
		case 336: goto tr328;
		case 351: goto tr84;
		case 368: goto tr328;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr569;
		case 607: goto tr107;
		case 624: goto tr569;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr111:
	{te = p+1;}
	{act = 189;}
	goto st294;
st294:
	if ( ++p == pe )
		goto _test_eof294;
case 294:
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
		case 338: goto st143;
		case 340: goto st144;
		case 341: goto st149;
		case 351: goto tr84;
		case 370: goto st143;
		case 372: goto st144;
		case 373: goto st149;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr570;
		case 596: goto tr571;
		case 597: goto tr572;
		case 607: goto tr107;
		case 626: goto tr570;
		case 628: goto tr571;
		case 629: goto tr572;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr570:
	{te = p+1;}
	{act = 141;}
	goto st295;
st295:
	if ( ++p == pe )
		goto _test_eof295;
case 295:
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
		case 327: goto tr333;
		case 351: goto tr84;
		case 359: goto tr333;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 583: goto tr573;
		case 607: goto tr107;
		case 615: goto tr573;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr332;
tr571:
	{te = p+1;}
	{act = 189;}
	goto st296;
st296:
	if ( ++p == pe )
		goto _test_eof296;
case 296:
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
		case 324: goto st145;
		case 329: goto st147;
		case 351: goto tr84;
		case 356: goto st145;
		case 361: goto st147;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr574;
		case 585: goto tr575;
		case 607: goto tr107;
		case 612: goto tr574;
		case 617: goto tr575;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr574:
	{te = p+1;}
	{act = 189;}
	goto st297;
st297:
	if ( ++p == pe )
		goto _test_eof297;
case 297:
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
		case 333: goto st146;
		case 338: goto tr337;
		case 351: goto tr84;
		case 365: goto st146;
		case 370: goto tr337;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 589: goto tr576;
		case 594: goto tr577;
		case 607: goto tr107;
		case 621: goto tr576;
		case 626: goto tr577;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr576:
	{te = p+1;}
	{act = 179;}
	goto st298;
st298:
	if ( ++p == pe )
		goto _test_eof298;
case 298:
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
		case 338: goto tr339;
		case 351: goto tr84;
		case 370: goto tr339;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr578;
		case 607: goto tr107;
		case 626: goto tr578;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr338;
tr575:
	{te = p+1;}
	{act = 189;}
	goto st299;
st299:
	if ( ++p == pe )
		goto _test_eof299;
case 299:
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
		case 333: goto st148;
		case 338: goto tr341;
		case 351: goto tr84;
		case 365: goto st148;
		case 370: goto tr341;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 589: goto tr579;
		case 594: goto tr580;
		case 607: goto tr107;
		case 621: goto tr579;
		case 626: goto tr580;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr579:
	{te = p+1;}
	{act = 177;}
	goto st300;
st300:
	if ( ++p == pe )
		goto _test_eof300;
case 300:
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
		case 338: goto tr343;
		case 351: goto tr84;
		case 370: goto tr343;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr581;
		case 607: goto tr107;
		case 626: goto tr581;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr342;
tr572:
	{te = p+1;}
	{act = 189;}
	goto st301;
st301:
	if ( ++p == pe )
		goto _test_eof301;
case 301:
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
		case 340: goto st150;
		case 351: goto tr84;
		case 372: goto st150;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr582;
		case 607: goto tr107;
		case 628: goto tr582;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr582:
	{te = p+1;}
	{act = 144;}
	goto st302;
st302:
	if ( ++p == pe )
		goto _test_eof302;
case 302:
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
		case 304: goto tr346;
		case 324: goto tr347;
		case 329: goto tr348;
		case 351: goto tr84;
		case 356: goto tr347;
		case 361: goto tr348;
		case 521: goto st20;
		case 544: goto st20;
		case 560: goto tr583;
		case 570: goto tr37;
		case 580: goto tr584;
		case 585: goto tr585;
		case 607: goto tr107;
		case 612: goto tr584;
		case 617: goto tr585;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 305 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 561 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr345;
tr112:
	{te = p+1;}
	{act = 43;}
	goto st303;
st303:
	if ( ++p == pe )
		goto _test_eof303;
case 303:
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
		case 325: goto tr350;
		case 335: goto st152;
		case 341: goto st153;
		case 351: goto tr84;
		case 357: goto tr350;
		case 367: goto st152;
		case 373: goto st153;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr586;
		case 591: goto tr587;
		case 597: goto tr588;
		case 607: goto tr107;
		case 613: goto tr586;
		case 623: goto tr587;
		case 629: goto tr588;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr349;
tr587:
	{te = p+1;}
	{act = 41;}
	goto st304;
st304:
	if ( ++p == pe )
		goto _test_eof304;
case 304:
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
		case 336: goto tr354;
		case 351: goto tr84;
		case 368: goto tr354;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr589;
		case 607: goto tr107;
		case 624: goto tr589;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr353;
tr588:
	{te = p+1;}
	{act = 189;}
	goto st305;
st305:
	if ( ++p == pe )
		goto _test_eof305;
case 305:
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
		case 322: goto st154;
		case 339: goto st157;
		case 351: goto tr84;
		case 354: goto st154;
		case 371: goto st157;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr590;
		case 595: goto tr591;
		case 607: goto tr107;
		case 610: goto tr590;
		case 627: goto tr591;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr590:
	{te = p+1;}
	{act = 189;}
	goto st306;
st306:
	if ( ++p == pe )
		goto _test_eof306;
case 306:
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
		case 332: goto st155;
		case 351: goto tr84;
		case 364: goto st155;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr592;
		case 607: goto tr107;
		case 620: goto tr592;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr592:
	{te = p+1;}
	{act = 189;}
	goto st307;
st307:
	if ( ++p == pe )
		goto _test_eof307;
case 307:
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
		case 329: goto st156;
		case 351: goto tr84;
		case 361: goto st156;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr593;
		case 607: goto tr107;
		case 617: goto tr593;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr593:
	{te = p+1;}
	{act = 189;}
	goto st308;
st308:
	if ( ++p == pe )
		goto _test_eof308;
case 308:
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
		case 323: goto tr359;
		case 351: goto tr84;
		case 355: goto tr359;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr594;
		case 607: goto tr107;
		case 611: goto tr594;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr591:
	{te = p+1;}
	{act = 189;}
	goto st309;
st309:
	if ( ++p == pe )
		goto _test_eof309;
case 309:
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
		case 328: goto tr360;
		case 351: goto tr84;
		case 360: goto tr360;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 584: goto tr595;
		case 607: goto tr107;
		case 616: goto tr595;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr113:
	{te = p+1;}
	{act = 58;}
	goto st310;
st310:
	if ( ++p == pe )
		goto _test_eof310;
case 310:
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
		case 325: goto st159;
		case 332: goto st161;
		case 338: goto st163;
		case 339: goto st165;
		case 351: goto tr84;
		case 357: goto st159;
		case 364: goto st161;
		case 370: goto st163;
		case 371: goto st165;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr596;
		case 588: goto tr597;
		case 594: goto tr598;
		case 595: goto tr599;
		case 607: goto tr107;
		case 613: goto tr596;
		case 620: goto tr597;
		case 626: goto tr598;
		case 627: goto tr599;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr361;
tr596:
	{te = p+1;}
	{act = 189;}
	goto st311;
st311:
	if ( ++p == pe )
		goto _test_eof311;
case 311:
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
		case 339: goto tr366;
		case 340: goto st160;
		case 351: goto tr84;
		case 371: goto tr366;
		case 372: goto st160;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr600;
		case 596: goto tr601;
		case 607: goto tr107;
		case 627: goto tr600;
		case 628: goto tr601;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr601:
	{te = p+1;}
	{act = 150;}
	goto st312;
st312:
	if ( ++p == pe )
		goto _test_eof312;
case 312:
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
		case 329: goto tr369;
		case 334: goto tr370;
		case 351: goto tr84;
		case 361: goto tr369;
		case 366: goto tr370;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr602;
		case 590: goto tr603;
		case 607: goto tr107;
		case 617: goto tr602;
		case 622: goto tr603;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr368;
tr597:
	{te = p+1;}
	{act = 153;}
	goto st313;
st313:
	if ( ++p == pe )
		goto _test_eof313;
case 313:
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
		case 321: goto tr372;
		case 323: goto st162;
		case 324: goto tr374;
		case 351: goto tr84;
		case 353: goto tr372;
		case 355: goto st162;
		case 356: goto tr374;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr604;
		case 579: goto tr605;
		case 580: goto tr606;
		case 607: goto tr107;
		case 609: goto tr604;
		case 611: goto tr605;
		case 612: goto tr606;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr371;
tr605:
	{te = p+1;}
	{act = 155;}
	goto st314;
st314:
	if ( ++p == pe )
		goto _test_eof314;
case 314:
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
		case 321: goto tr376;
		case 351: goto tr84;
		case 353: goto tr376;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr607;
		case 607: goto tr107;
		case 609: goto tr607;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr375;
tr598:
	{te = p+1;}
	{act = 158;}
	goto st315;
st315:
	if ( ++p == pe )
		goto _test_eof315;
case 315:
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
		case 321: goto tr378;
		case 323: goto st164;
		case 324: goto tr380;
		case 351: goto tr84;
		case 353: goto tr378;
		case 355: goto st164;
		case 356: goto tr380;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr608;
		case 579: goto tr609;
		case 580: goto tr610;
		case 607: goto tr107;
		case 609: goto tr608;
		case 611: goto tr609;
		case 612: goto tr610;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr377;
tr609:
	{te = p+1;}
	{act = 160;}
	goto st316;
st316:
	if ( ++p == pe )
		goto _test_eof316;
case 316:
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
		case 321: goto tr382;
		case 351: goto tr84;
		case 353: goto tr382;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr611;
		case 607: goto tr107;
		case 609: goto tr611;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr381;
tr599:
	{te = p+1;}
	{act = 189;}
	goto st317;
st317:
	if ( ++p == pe )
		goto _test_eof317;
case 317:
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
		case 340: goto tr383;
		case 351: goto tr84;
		case 372: goto tr383;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr612;
		case 607: goto tr107;
		case 628: goto tr612;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr114:
	{te = p+1;}
	{act = 189;}
	goto st318;
st318:
	if ( ++p == pe )
		goto _test_eof318;
case 318:
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
		case 322: goto st167;
		case 323: goto st168;
		case 325: goto st169;
		case 332: goto st174;
		case 336: goto tr388;
		case 338: goto st175;
		case 341: goto st176;
		case 351: goto tr84;
		case 354: goto st167;
		case 355: goto st168;
		case 357: goto st169;
		case 364: goto st174;
		case 368: goto tr388;
		case 370: goto st175;
		case 373: goto st176;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr613;
		case 579: goto tr614;
		case 581: goto tr615;
		case 588: goto tr616;
		case 592: goto tr617;
		case 594: goto tr618;
		case 597: goto tr619;
		case 607: goto tr107;
		case 610: goto tr613;
		case 611: goto tr614;
		case 613: goto tr615;
		case 620: goto tr616;
		case 624: goto tr617;
		case 626: goto tr618;
		case 629: goto tr619;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr613:
	{te = p+1;}
	{act = 189;}
	goto st319;
st319:
	if ( ++p == pe )
		goto _test_eof319;
case 319:
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
		case 323: goto tr391;
		case 351: goto tr84;
		case 355: goto tr391;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr620;
		case 607: goto tr107;
		case 611: goto tr620;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr614:
	{te = p+1;}
	{act = 189;}
	goto st320;
st320:
	if ( ++p == pe )
		goto _test_eof320;
case 320:
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
		case 326: goto tr392;
		case 351: goto tr84;
		case 358: goto tr392;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr621;
		case 607: goto tr107;
		case 614: goto tr621;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr615:
	{te = p+1;}
	{act = 189;}
	goto st321;
st321:
	if ( ++p == pe )
		goto _test_eof321;
case 321:
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
		case 323: goto st170;
		case 340: goto tr394;
		case 351: goto tr84;
		case 355: goto st170;
		case 372: goto tr394;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr622;
		case 596: goto tr623;
		case 607: goto tr107;
		case 611: goto tr622;
		case 628: goto tr623;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr622:
	{te = p+1;}
	{act = 189;}
	goto st322;
st322:
	if ( ++p == pe )
		goto _test_eof322;
case 322:
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
		case 340: goto st171;
		case 351: goto tr84;
		case 372: goto st171;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr624;
		case 607: goto tr107;
		case 628: goto tr624;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr624:
	{te = p+1;}
	{act = 189;}
	goto st323;
st323:
	if ( ++p == pe )
		goto _test_eof323;
case 323:
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
		case 329: goto st172;
		case 351: goto tr84;
		case 361: goto st172;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr625;
		case 607: goto tr107;
		case 617: goto tr625;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr625:
	{te = p+1;}
	{act = 189;}
	goto st324;
st324:
	if ( ++p == pe )
		goto _test_eof324;
case 324:
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
		case 335: goto st173;
		case 351: goto tr84;
		case 367: goto st173;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr626;
		case 607: goto tr107;
		case 623: goto tr626;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr626:
	{te = p+1;}
	{act = 189;}
	goto st325;
st325:
	if ( ++p == pe )
		goto _test_eof325;
case 325:
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
		case 334: goto tr398;
		case 351: goto tr84;
		case 366: goto tr398;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr627;
		case 607: goto tr107;
		case 622: goto tr627;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr616:
	{te = p+1;}
	{act = 189;}
	goto st326;
st326:
	if ( ++p == pe )
		goto _test_eof326;
case 326:
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
		case 321: goto tr399;
		case 332: goto tr400;
		case 336: goto tr401;
		case 351: goto tr84;
		case 353: goto tr399;
		case 364: goto tr400;
		case 368: goto tr401;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr628;
		case 588: goto tr629;
		case 592: goto tr630;
		case 607: goto tr107;
		case 609: goto tr628;
		case 620: goto tr629;
		case 624: goto tr630;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr618:
	{te = p+1;}
	{act = 189;}
	goto st327;
st327:
	if ( ++p == pe )
		goto _test_eof327;
case 327:
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
		case 321: goto tr402;
		case 332: goto tr403;
		case 351: goto tr84;
		case 353: goto tr402;
		case 364: goto tr403;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr631;
		case 588: goto tr632;
		case 607: goto tr107;
		case 609: goto tr631;
		case 620: goto tr632;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 578 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 610 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr619:
	{te = p+1;}
	{act = 189;}
	goto st328;
st328:
	if ( ++p == pe )
		goto _test_eof328;
case 328:
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
		case 322: goto tr404;
		case 351: goto tr84;
		case 354: goto tr404;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr633;
		case 607: goto tr107;
		case 610: goto tr633;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr115:
	{te = p+1;}
	{act = 189;}
	goto st329;
st329:
	if ( ++p == pe )
		goto _test_eof329;
case 329:
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
		case 339: goto st178;
		case 351: goto tr84;
		case 371: goto st178;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr634;
		case 607: goto tr107;
		case 627: goto tr634;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr634:
	{te = p+1;}
	{act = 189;}
	goto st330;
st330:
	if ( ++p == pe )
		goto _test_eof330;
case 330:
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
		case 340: goto st179;
		case 351: goto tr84;
		case 372: goto st179;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr635;
		case 607: goto tr107;
		case 628: goto tr635;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr635:
	{te = p+1;}
	{act = 181;}
	goto st331;
st331:
	if ( ++p == pe )
		goto _test_eof331;
case 331:
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
		case 329: goto st180;
		case 351: goto tr84;
		case 361: goto st180;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr636;
		case 607: goto tr107;
		case 617: goto tr636;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr407;
tr636:
	{te = p+1;}
	{act = 189;}
	goto st332;
st332:
	if ( ++p == pe )
		goto _test_eof332;
case 332:
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
		case 335: goto tr409;
		case 351: goto tr84;
		case 367: goto tr409;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr637;
		case 607: goto tr107;
		case 623: goto tr637;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr116:
	{te = p+1;}
	{act = 189;}
	goto st333;
st333:
	if ( ++p == pe )
		goto _test_eof333;
case 333:
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
		case 334: goto st182;
		case 351: goto tr84;
		case 366: goto st182;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr638;
		case 607: goto tr107;
		case 622: goto tr638;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr638:
	{te = p+1;}
	{act = 189;}
	goto st334;
st334:
	if ( ++p == pe )
		goto _test_eof334;
case 334:
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
		case 324: goto st183;
		case 351: goto tr84;
		case 356: goto st183;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr639;
		case 607: goto tr107;
		case 612: goto tr639;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr639:
	{te = p+1;}
	{act = 189;}
	goto st335;
st335:
	if ( ++p == pe )
		goto _test_eof335;
case 335:
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
		case 325: goto st184;
		case 351: goto tr84;
		case 357: goto st184;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr640;
		case 607: goto tr107;
		case 613: goto tr640;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr640:
	{te = p+1;}
	{act = 189;}
	goto st336;
st336:
	if ( ++p == pe )
		goto _test_eof336;
case 336:
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
		case 326: goto st185;
		case 351: goto tr84;
		case 358: goto st185;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr641;
		case 607: goto tr107;
		case 614: goto tr641;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr641:
	{te = p+1;}
	{act = 189;}
	goto st337;
st337:
	if ( ++p == pe )
		goto _test_eof337;
case 337:
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
		case 329: goto st186;
		case 351: goto tr84;
		case 361: goto st186;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr642;
		case 607: goto tr107;
		case 617: goto tr642;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr642:
	{te = p+1;}
	{act = 189;}
	goto st338;
st338:
	if ( ++p == pe )
		goto _test_eof338;
case 338:
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
		case 334: goto st187;
		case 351: goto tr84;
		case 366: goto st187;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr643;
		case 607: goto tr107;
		case 622: goto tr643;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr643:
	{te = p+1;}
	{act = 189;}
	goto st339;
st339:
	if ( ++p == pe )
		goto _test_eof339;
case 339:
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
		case 325: goto tr416;
		case 351: goto tr84;
		case 357: goto tr416;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr644;
		case 607: goto tr107;
		case 613: goto tr644;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr117:
	{te = p+1;}
	{act = 189;}
	goto st340;
st340:
	if ( ++p == pe )
		goto _test_eof340;
case 340:
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
		case 335: goto st189;
		case 351: goto tr84;
		case 367: goto st189;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr645;
		case 607: goto tr107;
		case 623: goto tr645;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
tr645:
	{te = p+1;}
	{act = 189;}
	goto st341;
st341:
	if ( ++p == pe )
		goto _test_eof341;
case 341:
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
		case 338: goto tr418;
		case 351: goto tr84;
		case 370: goto tr418;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr646;
		case 607: goto tr107;
		case 626: goto tr646;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr84;
		} else if ( _widec >= 304 )
			goto tr84;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr107;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr107;
		} else
			goto tr107;
	} else
		goto tr84;
	goto tr154;
	}
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
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
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
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
	_test_eof18: cs = 18; goto _test_eof; 
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
	_test_eof121: cs = 121; goto _test_eof; 
	_test_eof122: cs = 122; goto _test_eof; 
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
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof191: cs = 191; goto _test_eof; 
	_test_eof192: cs = 192; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof193: cs = 193; goto _test_eof; 
	_test_eof194: cs = 194; goto _test_eof; 
	_test_eof195: cs = 195; goto _test_eof; 
	_test_eof196: cs = 196; goto _test_eof; 
	_test_eof197: cs = 197; goto _test_eof; 
	_test_eof198: cs = 198; goto _test_eof; 
	_test_eof199: cs = 199; goto _test_eof; 
	_test_eof200: cs = 200; goto _test_eof; 
	_test_eof201: cs = 201; goto _test_eof; 
	_test_eof202: cs = 202; goto _test_eof; 
	_test_eof203: cs = 203; goto _test_eof; 
	_test_eof204: cs = 204; goto _test_eof; 
	_test_eof205: cs = 205; goto _test_eof; 
	_test_eof206: cs = 206; goto _test_eof; 
	_test_eof207: cs = 207; goto _test_eof; 
	_test_eof208: cs = 208; goto _test_eof; 
	_test_eof209: cs = 209; goto _test_eof; 
	_test_eof210: cs = 210; goto _test_eof; 
	_test_eof211: cs = 211; goto _test_eof; 
	_test_eof212: cs = 212; goto _test_eof; 
	_test_eof213: cs = 213; goto _test_eof; 
	_test_eof214: cs = 214; goto _test_eof; 
	_test_eof215: cs = 215; goto _test_eof; 
	_test_eof216: cs = 216; goto _test_eof; 
	_test_eof217: cs = 217; goto _test_eof; 
	_test_eof218: cs = 218; goto _test_eof; 
	_test_eof219: cs = 219; goto _test_eof; 
	_test_eof220: cs = 220; goto _test_eof; 
	_test_eof221: cs = 221; goto _test_eof; 
	_test_eof222: cs = 222; goto _test_eof; 
	_test_eof223: cs = 223; goto _test_eof; 
	_test_eof224: cs = 224; goto _test_eof; 
	_test_eof225: cs = 225; goto _test_eof; 
	_test_eof226: cs = 226; goto _test_eof; 
	_test_eof227: cs = 227; goto _test_eof; 
	_test_eof228: cs = 228; goto _test_eof; 
	_test_eof229: cs = 229; goto _test_eof; 
	_test_eof230: cs = 230; goto _test_eof; 
	_test_eof231: cs = 231; goto _test_eof; 
	_test_eof232: cs = 232; goto _test_eof; 
	_test_eof233: cs = 233; goto _test_eof; 
	_test_eof234: cs = 234; goto _test_eof; 
	_test_eof235: cs = 235; goto _test_eof; 
	_test_eof236: cs = 236; goto _test_eof; 
	_test_eof237: cs = 237; goto _test_eof; 
	_test_eof238: cs = 238; goto _test_eof; 
	_test_eof239: cs = 239; goto _test_eof; 
	_test_eof240: cs = 240; goto _test_eof; 
	_test_eof241: cs = 241; goto _test_eof; 
	_test_eof242: cs = 242; goto _test_eof; 
	_test_eof243: cs = 243; goto _test_eof; 
	_test_eof244: cs = 244; goto _test_eof; 
	_test_eof245: cs = 245; goto _test_eof; 
	_test_eof246: cs = 246; goto _test_eof; 
	_test_eof247: cs = 247; goto _test_eof; 
	_test_eof248: cs = 248; goto _test_eof; 
	_test_eof249: cs = 249; goto _test_eof; 
	_test_eof250: cs = 250; goto _test_eof; 
	_test_eof251: cs = 251; goto _test_eof; 
	_test_eof252: cs = 252; goto _test_eof; 
	_test_eof253: cs = 253; goto _test_eof; 
	_test_eof254: cs = 254; goto _test_eof; 
	_test_eof255: cs = 255; goto _test_eof; 
	_test_eof256: cs = 256; goto _test_eof; 
	_test_eof257: cs = 257; goto _test_eof; 
	_test_eof258: cs = 258; goto _test_eof; 
	_test_eof259: cs = 259; goto _test_eof; 
	_test_eof260: cs = 260; goto _test_eof; 
	_test_eof261: cs = 261; goto _test_eof; 
	_test_eof262: cs = 262; goto _test_eof; 
	_test_eof263: cs = 263; goto _test_eof; 
	_test_eof264: cs = 264; goto _test_eof; 
	_test_eof265: cs = 265; goto _test_eof; 
	_test_eof266: cs = 266; goto _test_eof; 
	_test_eof267: cs = 267; goto _test_eof; 
	_test_eof268: cs = 268; goto _test_eof; 
	_test_eof269: cs = 269; goto _test_eof; 
	_test_eof270: cs = 270; goto _test_eof; 
	_test_eof271: cs = 271; goto _test_eof; 
	_test_eof272: cs = 272; goto _test_eof; 
	_test_eof273: cs = 273; goto _test_eof; 
	_test_eof274: cs = 274; goto _test_eof; 
	_test_eof275: cs = 275; goto _test_eof; 
	_test_eof276: cs = 276; goto _test_eof; 
	_test_eof277: cs = 277; goto _test_eof; 
	_test_eof278: cs = 278; goto _test_eof; 
	_test_eof279: cs = 279; goto _test_eof; 
	_test_eof280: cs = 280; goto _test_eof; 
	_test_eof281: cs = 281; goto _test_eof; 
	_test_eof282: cs = 282; goto _test_eof; 
	_test_eof283: cs = 283; goto _test_eof; 
	_test_eof284: cs = 284; goto _test_eof; 
	_test_eof285: cs = 285; goto _test_eof; 
	_test_eof286: cs = 286; goto _test_eof; 
	_test_eof287: cs = 287; goto _test_eof; 
	_test_eof288: cs = 288; goto _test_eof; 
	_test_eof289: cs = 289; goto _test_eof; 
	_test_eof290: cs = 290; goto _test_eof; 
	_test_eof291: cs = 291; goto _test_eof; 
	_test_eof292: cs = 292; goto _test_eof; 
	_test_eof293: cs = 293; goto _test_eof; 
	_test_eof294: cs = 294; goto _test_eof; 
	_test_eof295: cs = 295; goto _test_eof; 
	_test_eof296: cs = 296; goto _test_eof; 
	_test_eof297: cs = 297; goto _test_eof; 
	_test_eof298: cs = 298; goto _test_eof; 
	_test_eof299: cs = 299; goto _test_eof; 
	_test_eof300: cs = 300; goto _test_eof; 
	_test_eof301: cs = 301; goto _test_eof; 
	_test_eof302: cs = 302; goto _test_eof; 
	_test_eof303: cs = 303; goto _test_eof; 
	_test_eof304: cs = 304; goto _test_eof; 
	_test_eof305: cs = 305; goto _test_eof; 
	_test_eof306: cs = 306; goto _test_eof; 
	_test_eof307: cs = 307; goto _test_eof; 
	_test_eof308: cs = 308; goto _test_eof; 
	_test_eof309: cs = 309; goto _test_eof; 
	_test_eof310: cs = 310; goto _test_eof; 
	_test_eof311: cs = 311; goto _test_eof; 
	_test_eof312: cs = 312; goto _test_eof; 
	_test_eof313: cs = 313; goto _test_eof; 
	_test_eof314: cs = 314; goto _test_eof; 
	_test_eof315: cs = 315; goto _test_eof; 
	_test_eof316: cs = 316; goto _test_eof; 
	_test_eof317: cs = 317; goto _test_eof; 
	_test_eof318: cs = 318; goto _test_eof; 
	_test_eof319: cs = 319; goto _test_eof; 
	_test_eof320: cs = 320; goto _test_eof; 
	_test_eof321: cs = 321; goto _test_eof; 
	_test_eof322: cs = 322; goto _test_eof; 
	_test_eof323: cs = 323; goto _test_eof; 
	_test_eof324: cs = 324; goto _test_eof; 
	_test_eof325: cs = 325; goto _test_eof; 
	_test_eof326: cs = 326; goto _test_eof; 
	_test_eof327: cs = 327; goto _test_eof; 
	_test_eof328: cs = 328; goto _test_eof; 
	_test_eof329: cs = 329; goto _test_eof; 
	_test_eof330: cs = 330; goto _test_eof; 
	_test_eof331: cs = 331; goto _test_eof; 
	_test_eof332: cs = 332; goto _test_eof; 
	_test_eof333: cs = 333; goto _test_eof; 
	_test_eof334: cs = 334; goto _test_eof; 
	_test_eof335: cs = 335; goto _test_eof; 
	_test_eof336: cs = 336; goto _test_eof; 
	_test_eof337: cs = 337; goto _test_eof; 
	_test_eof338: cs = 338; goto _test_eof; 
	_test_eof339: cs = 339; goto _test_eof; 
	_test_eof340: cs = 340; goto _test_eof; 
	_test_eof341: cs = 341; goto _test_eof; 
	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 22: goto tr119;
	case 23: goto tr0;
	case 24: goto tr0;
	case 1: goto tr0;
	case 2: goto tr0;
	case 25: goto tr124;
	case 26: goto tr125;
	case 27: goto tr127;
	case 3: goto tr3;
	case 4: goto tr3;
	case 5: goto tr3;
	case 6: goto tr3;
	case 7: goto tr3;
	case 8: goto tr3;
	case 9: goto tr3;
	case 10: goto tr3;
	case 11: goto tr3;
	case 12: goto tr3;
	case 13: goto tr3;
	case 14: goto tr3;
	case 15: goto tr3;
	case 28: goto tr128;
	case 29: goto tr130;
	case 30: goto tr130;
	case 31: goto tr130;
	case 16: goto tr0;
	case 32: goto tr134;
	case 33: goto tr0;
	case 17: goto tr26;
	case 34: goto tr136;
	case 35: goto tr137;
	case 36: goto tr138;
	case 37: goto tr142;
	case 38: goto tr144;
	case 39: goto tr147;
	case 40: goto tr149;
	case 41: goto tr0;
	case 42: goto tr154;
	case 43: goto tr157;
	case 44: goto tr154;
	case 45: goto tr154;
	case 46: goto tr154;
	case 47: goto tr154;
	case 48: goto tr163;
	case 49: goto tr154;
	case 50: goto tr154;
	case 51: goto tr154;
	case 52: goto tr154;
	case 53: goto tr171;
	case 54: goto tr154;
	case 55: goto tr154;
	case 56: goto tr177;
	case 57: goto tr154;
	case 58: goto tr154;
	case 59: goto tr154;
	case 60: goto tr154;
	case 61: goto tr154;
	case 62: goto tr185;
	case 63: goto tr189;
	case 64: goto tr191;
	case 65: goto tr193;
	case 66: goto tr154;
	case 67: goto tr200;
	case 68: goto tr154;
	case 69: goto tr154;
	case 70: goto tr154;
	case 71: goto tr154;
	case 72: goto tr154;
	case 73: goto tr154;
	case 74: goto tr154;
	case 75: goto tr154;
	case 76: goto tr154;
	case 77: goto tr154;
	case 78: goto tr154;
	case 79: goto tr154;
	case 80: goto tr154;
	case 18: goto tr28;
	case 81: goto tr224;
	case 82: goto tr229;
	case 83: goto tr154;
	case 84: goto tr154;
	case 85: goto tr154;
	case 86: goto tr154;
	case 87: goto tr154;
	case 88: goto tr236;
	case 89: goto tr154;
	case 90: goto tr154;
	case 91: goto tr154;
	case 92: goto tr242;
	case 93: goto tr154;
	case 94: goto tr154;
	case 95: goto tr154;
	case 96: goto tr154;
	case 97: goto tr154;
	case 98: goto tr154;
	case 99: goto tr250;
	case 100: goto tr154;
	case 101: goto tr154;
	case 102: goto tr255;
	case 103: goto tr262;
	case 104: goto tr154;
	case 105: goto tr154;
	case 106: goto tr154;
	case 107: goto tr154;
	case 108: goto tr154;
	case 109: goto tr154;
	case 110: goto tr271;
	case 111: goto tr277;
	case 112: goto tr154;
	case 113: goto tr154;
	case 114: goto tr154;
	case 115: goto tr282;
	case 116: goto tr284;
	case 117: goto tr154;
	case 118: goto tr154;
	case 119: goto tr154;
	case 120: goto tr289;
	case 121: goto tr292;
	case 122: goto tr154;
	case 123: goto tr297;
	case 124: goto tr301;
	case 125: goto tr304;
	case 126: goto tr306;
	case 127: goto tr154;
	case 128: goto tr154;
	case 129: goto tr154;
	case 130: goto tr154;
	case 131: goto tr154;
	case 132: goto tr154;
	case 133: goto tr315;
	case 134: goto tr154;
	case 135: goto tr154;
	case 136: goto tr154;
	case 137: goto tr154;
	case 138: goto tr154;
	case 139: goto tr154;
	case 140: goto tr154;
	case 141: goto tr154;
	case 142: goto tr154;
	case 143: goto tr332;
	case 144: goto tr154;
	case 145: goto tr154;
	case 146: goto tr338;
	case 147: goto tr154;
	case 148: goto tr342;
	case 149: goto tr154;
	case 150: goto tr345;
	case 151: goto tr349;
	case 152: goto tr353;
	case 153: goto tr154;
	case 154: goto tr154;
	case 155: goto tr154;
	case 156: goto tr154;
	case 157: goto tr154;
	case 158: goto tr361;
	case 159: goto tr154;
	case 160: goto tr368;
	case 161: goto tr371;
	case 162: goto tr375;
	case 163: goto tr377;
	case 164: goto tr381;
	case 165: goto tr154;
	case 166: goto tr154;
	case 167: goto tr154;
	case 168: goto tr154;
	case 169: goto tr154;
	case 170: goto tr154;
	case 171: goto tr154;
	case 172: goto tr154;
	case 173: goto tr154;
	case 174: goto tr154;
	case 175: goto tr154;
	case 176: goto tr154;
	case 177: goto tr154;
	case 178: goto tr154;
	case 179: goto tr407;
	case 180: goto tr154;
	case 181: goto tr154;
	case 182: goto tr154;
	case 183: goto tr154;
	case 184: goto tr154;
	case 185: goto tr154;
	case 186: goto tr154;
	case 187: goto tr154;
	case 188: goto tr154;
	case 189: goto tr154;
	case 190: goto tr419;
	case 19: goto tr33;
	case 191: goto tr420;
	case 192: goto tr149;
	case 20: goto tr0;
	case 193: goto tr0;
	case 194: goto tr154;
	case 195: goto tr157;
	case 196: goto tr154;
	case 197: goto tr154;
	case 198: goto tr154;
	case 199: goto tr154;
	case 200: goto tr163;
	case 201: goto tr154;
	case 202: goto tr154;
	case 203: goto tr154;
	case 204: goto tr154;
	case 205: goto tr171;
	case 206: goto tr154;
	case 207: goto tr154;
	case 208: goto tr177;
	case 209: goto tr154;
	case 210: goto tr154;
	case 211: goto tr154;
	case 212: goto tr154;
	case 213: goto tr154;
	case 214: goto tr185;
	case 215: goto tr189;
	case 216: goto tr191;
	case 217: goto tr193;
	case 218: goto tr154;
	case 219: goto tr200;
	case 220: goto tr154;
	case 221: goto tr154;
	case 222: goto tr154;
	case 223: goto tr154;
	case 224: goto tr154;
	case 225: goto tr154;
	case 226: goto tr154;
	case 227: goto tr154;
	case 228: goto tr154;
	case 229: goto tr154;
	case 230: goto tr154;
	case 231: goto tr154;
	case 232: goto tr154;
	case 233: goto tr224;
	case 234: goto tr229;
	case 235: goto tr154;
	case 236: goto tr154;
	case 237: goto tr154;
	case 238: goto tr154;
	case 239: goto tr154;
	case 240: goto tr236;
	case 241: goto tr154;
	case 242: goto tr154;
	case 243: goto tr154;
	case 244: goto tr242;
	case 245: goto tr154;
	case 246: goto tr154;
	case 247: goto tr154;
	case 248: goto tr154;
	case 249: goto tr154;
	case 250: goto tr154;
	case 251: goto tr250;
	case 252: goto tr154;
	case 253: goto tr154;
	case 254: goto tr255;
	case 255: goto tr262;
	case 256: goto tr154;
	case 257: goto tr154;
	case 258: goto tr154;
	case 259: goto tr154;
	case 260: goto tr154;
	case 261: goto tr154;
	case 262: goto tr271;
	case 263: goto tr277;
	case 264: goto tr154;
	case 265: goto tr154;
	case 266: goto tr154;
	case 267: goto tr282;
	case 268: goto tr284;
	case 269: goto tr154;
	case 270: goto tr154;
	case 271: goto tr154;
	case 272: goto tr289;
	case 273: goto tr292;
	case 274: goto tr154;
	case 275: goto tr297;
	case 276: goto tr301;
	case 277: goto tr304;
	case 278: goto tr306;
	case 279: goto tr154;
	case 280: goto tr154;
	case 281: goto tr154;
	case 282: goto tr154;
	case 283: goto tr154;
	case 284: goto tr154;
	case 285: goto tr315;
	case 286: goto tr154;
	case 287: goto tr154;
	case 288: goto tr154;
	case 289: goto tr154;
	case 290: goto tr154;
	case 291: goto tr154;
	case 292: goto tr154;
	case 293: goto tr154;
	case 294: goto tr154;
	case 295: goto tr332;
	case 296: goto tr154;
	case 297: goto tr154;
	case 298: goto tr338;
	case 299: goto tr154;
	case 300: goto tr342;
	case 301: goto tr154;
	case 302: goto tr345;
	case 303: goto tr349;
	case 304: goto tr353;
	case 305: goto tr154;
	case 306: goto tr154;
	case 307: goto tr154;
	case 308: goto tr154;
	case 309: goto tr154;
	case 310: goto tr361;
	case 311: goto tr154;
	case 312: goto tr368;
	case 313: goto tr371;
	case 314: goto tr375;
	case 315: goto tr377;
	case 316: goto tr381;
	case 317: goto tr154;
	case 318: goto tr154;
	case 319: goto tr154;
	case 320: goto tr154;
	case 321: goto tr154;
	case 322: goto tr154;
	case 323: goto tr154;
	case 324: goto tr154;
	case 325: goto tr154;
	case 326: goto tr154;
	case 327: goto tr154;
	case 328: goto tr154;
	case 329: goto tr154;
	case 330: goto tr154;
	case 331: goto tr407;
	case 332: goto tr154;
	case 333: goto tr154;
	case 334: goto tr154;
	case 335: goto tr154;
	case 336: goto tr154;
	case 337: goto tr154;
	case 338: goto tr154;
	case 339: goto tr154;
	case 340: goto tr154;
	case 341: goto tr154;
	}
	}
	_out: {}
	}
 return sym.tok;
}
