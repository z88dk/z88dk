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
		sym.tok = TK_DEFL;
		sym.tok_opcode = TK_DEFL;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_DEFL;
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
	case 89:
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
	case 90:
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
	case 91:
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
	case 92:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_LIB;
		sym.tok_opcode = TK_LIB;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_LIB;
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
	case 101:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_XDEF;
		sym.tok_opcode = TK_XDEF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_XDEF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 102:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_XLIB;
		sym.tok_opcode = TK_XLIB;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_XLIB;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 103:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_XREF;
		sym.tok_opcode = TK_XREF;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_XREF;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 108:
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
	case 109:
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
	case 110:
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
	case 111:
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
	case 112:
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
	case 113:
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
	case 114:
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
	case 115:
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
	case 116:
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
	case 117:
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
	case 118:
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
	case 119:
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
	case 120:
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
	case 121:
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
	case 122:
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
	case 123:
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
	case 124:
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
	case 125:
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
	case 126:
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
	case 127:
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
	case 128:
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
	case 129:
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
	case 130:
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
	case 131:
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
	case 132:
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
	case 133:
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
	case 134:
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
	case 135:
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
	case 136:
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
	case 137:
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
	case 138:
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
	case 139:
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
	case 140:
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
	case 141:
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
	case 142:
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
	case 143:
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
	case 144:
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
	case 145:
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
	case 146:
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
	case 147:
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
	case 148:
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
	case 149:
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
	case 150:
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
	case 151:
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
	case 152:
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
	case 153:
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
	case 154:
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
	case 155:
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
	case 156:
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
	case 157:
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
	case 158:
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
	case 159:
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
	case 160:
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
	case 161:
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
	case 162:
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
	case 163:
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
	case 164:
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
	case 165:
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
	case 166:
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
	case 167:
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
	case 168:
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
	case 169:
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
	case 170:
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
	case 171:
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
	case 172:
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
	case 173:
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
	case 174:
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
	case 175:
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
	case 176:
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
	case 177:
	{{p = ((te))-1;}
	if (expect_opcode) {
		sym.tok = TK_OZ;
		sym.tok_opcode = TK_OZ;
		expect_opcode = FALSE;
	}
	else {
		sym.tok = TK_NAME;
		sym.tok_opcode = TK_OZ;
	}
	{p++; cs = 21; goto _out;}
}
	break;
	case 178:
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
	case 179:
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
	case 180:
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
	case 183:
	{{p = ((te))-1;}
  sym.tok = TK_NAME;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 185:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 187:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 1, te - ts - 1, 16 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 189:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 191:
	{{p = ((te))-1;}
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 2, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }
	break;
	case 195:
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
	sym.tok = TK_DS_L;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr31:
	{te = p+1;{
	sym.tok = TK_DS_P;
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
tr115:
	{te = p;p--;{
	sym.tok = TK_LOG_NOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr116:
	{te = p+1;{
	sym.tok = TK_NOT_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr120:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 1, te - ts - 1, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr121:
	{te = p;p--;{
	sym.tok = TK_BIN_AND;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr122:
	{te = p+1;{
	sym.tok = TK_LOG_AND;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr123:
	{te = p;p--;{
	sym.tok = TK_LPAREN;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr124:
	{te = p;p--;{
	sym.tok = TK_MULTIPLY;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr125:
	{te = p+1;{
	sym.tok = TK_POWER;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr126:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts, 10 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr130:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts, te - ts - 1, 2 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr132:
	{te = p;p--;{
  sym.tok = TK_NUMBER;
  sym.number = scan_num( ts + 2, te - ts - 2, 16 );
  ts = te = p;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr133:
	{te = p;p--;}
	goto st21;
tr134:
	{te = p;p--;{
	sym.tok = TK_LESS;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr135:
	{te = p+1;{
	sym.tok = TK_LEFT_SHIFT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr136:
	{te = p+1;{
	sym.tok = TK_LESS_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr137:
	{te = p+1;{
	sym.tok = TK_NOT_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr138:
	{te = p;p--;{
	sym.tok = TK_EQUAL;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr139:
	{te = p+1;{
	sym.tok = TK_EQUAL;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr140:
	{te = p;p--;{
	sym.tok = TK_GREATER;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr141:
	{te = p+1;{
	sym.tok = TK_GREATER_EQ;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr142:
	{te = p+1;{
	sym.tok = TK_RIGHT_SHIFT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr143:
	{te = p;p--;{
	sym.tok = TK_BIN_OR;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr144:
	{te = p+1;{
	sym.tok = TK_LOG_OR;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr145:
	{te = p;p--;{
	sym.tok = TK_A;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr150:
	{te = p;p--;{
  sym.tok = TK_NAME;
  {p++; cs = 21; goto _out;}
 }}
	goto st21;
tr153:
	{te = p;p--;{
	sym.tok = TK_AF;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr154:
	{te = p+1;{
	sym.tok = TK_AF1;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr159:
	{te = p;p--;{
	sym.tok = TK_B;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr167:
	{te = p;p--;{
	sym.tok = TK_C;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr173:
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
tr181:
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
tr185:
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
tr187:
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
tr189:
	{te = p;p--;{
	sym.tok = TK_D;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr196:
	{te = p;p--;{
	sym.tok = TK_DE;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr220:
	{te = p;p--;{
	sym.tok = TK_E;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr225:
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
tr232:
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
tr238:
	{te = p;p--;{
	sym.tok = TK_F;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr241:
	{te = p;p--;{
	sym.tok = TK_H;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr246:
	{te = p;p--;{
	sym.tok = TK_I;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr253:
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
tr262:
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
tr267:
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
tr272:
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
tr274:
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
tr279:
	{te = p;p--;{
	sym.tok = TK_IX;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr282:
	{te = p;p--;{
	sym.tok = TK_IY;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr287:
	{te = p;p--;{
	sym.tok = TK_L;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr291:
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
tr294:
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
tr296:
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
tr306:
	{te = p;p--;{
	sym.tok = TK_M;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr322:
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
tr329:
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
tr332:
	{te = p;p--;{
	sym.tok = TK_P;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr336:
	{te = p;p--;{
	sym.tok = TK_PO;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr344:
	{te = p;p--;{
	sym.tok = TK_R;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr351:
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
tr354:
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
tr358:
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
tr360:
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
tr364:
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
tr405:
	{te = p;p--;{
	sym.tok = TK_DOT;
	;
	{p++; cs = 21; goto _out;}
}}
	goto st21;
tr406:
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
		case 328: goto st94;
		case 329: goto st97;
		case 330: goto st117;
		case 332: goto st118;
		case 333: goto st128;
		case 334: goto st133;
		case 335: goto st136;
		case 336: goto st143;
		case 338: goto st150;
		case 339: goto st158;
		case 341: goto st169;
		case 344: goto st176;
		case 346: goto tr93;
		case 351: goto tr80;
		case 353: goto st40;
		case 354: goto st48;
		case 355: goto st53;
		case 356: goto st65;
		case 357: goto st81;
		case 358: goto st92;
		case 360: goto st94;
		case 361: goto st97;
		case 362: goto st117;
		case 364: goto st118;
		case 365: goto st128;
		case 366: goto st133;
		case 367: goto st136;
		case 368: goto st143;
		case 370: goto st150;
		case 371: goto st158;
		case 373: goto st169;
		case 376: goto st176;
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
		case 597: goto tr112;
		case 600: goto tr113;
		case 602: goto tr114;
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
		case 629: goto tr112;
		case 632: goto tr113;
		case 634: goto tr114;
	}
	if ( _widec < 327 ) {
		if ( _widec > 32 ) {
			if ( 50 <= _widec && _widec <= 57 )
				goto tr57;
		} else
			goto tr38;
	} else if ( _widec > 345 ) {
		if ( _widec < 583 ) {
			if ( 359 <= _widec && _widec <= 377 )
				goto tr80;
		} else if ( _widec > 601 ) {
			if ( 615 <= _widec && _widec <= 633 )
				goto tr101;
		} else
			goto tr101;
	} else
		goto tr80;
	goto st0;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
	if ( (*p) == 61 )
		goto tr116;
	goto tr115;
tr43:
	{te = p+1;}
	{act = 195;}
	goto st23;
tr117:
	{te = p+1;}
	{act = 187;}
	goto st23;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr117;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto tr117;
	} else
		goto tr117;
	goto tr0;
tr64:
	{te = p+1;}
	{act = 195;}
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
	goto tr120;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
	if ( (*p) == 38 )
		goto tr122;
	goto tr121;
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
	goto tr123;
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
		goto tr125;
	goto tr124;
st0:
cs = 0;
	goto _out;
tr55:
	{te = p+1;}
	{act = 185;}
	goto st29;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	switch( (*p) ) {
		case 66: goto tr127;
		case 72: goto tr25;
		case 88: goto st17;
		case 98: goto tr127;
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
	goto tr126;
tr56:
	{te = p+1;}
	{act = 185;}
	goto st30;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	switch( (*p) ) {
		case 66: goto tr129;
		case 72: goto tr25;
		case 98: goto tr129;
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
	goto tr126;
tr57:
	{te = p+1;}
	{act = 185;}
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
	goto tr126;
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
tr129:
	{te = p+1;}
	{act = 189;}
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
	goto tr130;
tr127:
	{te = p+1;}
	{act = 189;}
	goto st33;
tr131:
	{te = p+1;}
	{act = 191;}
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
			goto tr131;
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
	goto tr132;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( (*p) == 10 )
		goto tr133;
	goto st35;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	switch( (*p) ) {
		case 60: goto tr135;
		case 61: goto tr136;
		case 62: goto tr137;
	}
	goto tr134;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
	if ( (*p) == 61 )
		goto tr139;
	goto tr138;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
	switch( (*p) ) {
		case 61: goto tr141;
		case 62: goto tr142;
	}
	goto tr140;
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
		case 95: goto tr80;
		case 100: goto st42;
		case 102: goto st43;
		case 110: goto st44;
		case 115: goto st45;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr145;
tr80:
	{te = p+1;}
	{act = 183;}
	goto st41;
tr93:
	{te = p+1;}
	{act = 38;}
	goto st41;
tr151:
	{te = p+1;}
	{act = 108;}
	goto st41;
tr152:
	{te = p+1;}
	{act = 109;}
	goto st41;
tr155:
	{te = p+1;}
	{act = 110;}
	goto st41;
tr158:
	{te = p+1;}
	{act = 1;}
	goto st41;
tr160:
	{te = p+1;}
	{act = 61;}
	goto st41;
tr163:
	{te = p+1;}
	{act = 111;}
	goto st41;
tr166:
	{te = p+1;}
	{act = 75;}
	goto st41;
tr177:
	{te = p+1;}
	{act = 176;}
	goto st41;
tr179:
	{te = p+1;}
	{act = 178;}
	goto st41;
tr180:
	{te = p+1;}
	{act = 113;}
	goto st41;
tr184:
	{te = p+1;}
	{act = 119;}
	goto st41;
tr186:
	{te = p+1;}
	{act = 116;}
	goto st41;
tr188:
	{te = p+1;}
	{act = 118;}
	goto st41;
tr192:
	{te = p+1;}
	{act = 122;}
	goto st41;
tr195:
	{te = p+1;}
	{act = 120;}
	goto st41;
tr197:
	{te = p+1;}
	{act = 121;}
	goto st41;
tr199:
	{te = p+1;}
	{act = 76;}
	goto st41;
tr200:
	{te = p+1;}
	{act = 77;}
	goto st41;
tr203:
	{te = p+1;}
	{act = 80;}
	goto st41;
tr204:
	{te = p+1;}
	{act = 81;}
	goto st41;
tr205:
	{te = p+1;}
	{act = 82;}
	goto st41;
tr207:
	{te = p+1;}
	{act = 84;}
	goto st41;
tr211:
	{te = p+1;}
	{act = 78;}
	goto st41;
tr213:
	{te = p+1;}
	{act = 79;}
	goto st41;
tr216:
	{te = p+1;}
	{act = 83;}
	goto st41;
tr218:
	{te = p+1;}
	{act = 123;}
	goto st41;
tr226:
	{te = p+1;}
	{act = 59;}
	goto st41;
tr228:
	{te = p+1;}
	{act = 85;}
	goto st41;
tr231:
	{te = p+1;}
	{act = 86;}
	goto st41;
tr234:
	{te = p+1;}
	{act = 126;}
	goto st41;
tr237:
	{te = p+1;}
	{act = 87;}
	goto st41;
tr240:
	{te = p+1;}
	{act = 179;}
	goto st41;
tr243:
	{te = p+1;}
	{act = 63;}
	goto st41;
tr245:
	{te = p+1;}
	{act = 127;}
	goto st41;
tr249:
	{te = p+1;}
	{act = 128;}
	goto st41;
tr257:
	{te = p+1;}
	{act = 89;}
	goto st41;
tr260:
	{te = p+1;}
	{act = 90;}
	goto st41;
tr261:
	{te = p+1;}
	{act = 57;}
	goto st41;
tr271:
	{te = p+1;}
	{act = 91;}
	goto st41;
tr273:
	{te = p+1;}
	{act = 132;}
	goto st41;
tr275:
	{te = p+1;}
	{act = 134;}
	goto st41;
tr278:
	{te = p+1;}
	{act = 180;}
	goto st41;
tr280:
	{te = p+1;}
	{act = 49;}
	goto st41;
tr281:
	{te = p+1;}
	{act = 52;}
	goto st41;
tr283:
	{te = p+1;}
	{act = 50;}
	goto st41;
tr284:
	{te = p+1;}
	{act = 53;}
	goto st41;
tr285:
	{te = p+1;}
	{act = 135;}
	goto st41;
tr286:
	{te = p+1;}
	{act = 136;}
	goto st41;
tr295:
	{te = p+1;}
	{act = 139;}
	goto st41;
tr297:
	{te = p+1;}
	{act = 141;}
	goto st41;
tr298:
	{te = p+1;}
	{act = 92;}
	goto st41;
tr300:
	{te = p+1;}
	{act = 93;}
	goto st41;
tr304:
	{te = p+1;}
	{act = 95;}
	goto st41;
tr305:
	{te = p+1;}
	{act = 94;}
	goto st41;
tr311:
	{te = p+1;}
	{act = 96;}
	goto st41;
tr312:
	{te = p+1;}
	{act = 39;}
	goto st41;
tr315:
	{te = p+1;}
	{act = 37;}
	goto st41;
tr316:
	{te = p+1;}
	{act = 142;}
	goto st41;
tr317:
	{te = p+1;}
	{act = 143;}
	goto st41;
tr321:
	{te = p+1;}
	{act = 177;}
	goto st41;
tr323:
	{te = p+1;}
	{act = 97;}
	goto st41;
tr326:
	{te = p+1;}
	{act = 145;}
	goto st41;
tr327:
	{te = p+1;}
	{act = 146;}
	goto st41;
tr330:
	{te = p+1;}
	{act = 148;}
	goto st41;
tr331:
	{te = p+1;}
	{act = 149;}
	goto st41;
tr333:
	{te = p+1;}
	{act = 42;}
	goto st41;
tr337:
	{te = p+1;}
	{act = 150;}
	goto st41;
tr342:
	{te = p+1;}
	{act = 98;}
	goto st41;
tr343:
	{te = p+1;}
	{act = 151;}
	goto st41;
tr349:
	{te = p+1;}
	{act = 152;}
	goto st41;
tr352:
	{te = p+1;}
	{act = 154;}
	goto st41;
tr353:
	{te = p+1;}
	{act = 155;}
	goto st41;
tr355:
	{te = p+1;}
	{act = 157;}
	goto st41;
tr357:
	{te = p+1;}
	{act = 160;}
	goto st41;
tr359:
	{te = p+1;}
	{act = 159;}
	goto st41;
tr361:
	{te = p+1;}
	{act = 162;}
	goto st41;
tr363:
	{te = p+1;}
	{act = 165;}
	goto st41;
tr365:
	{te = p+1;}
	{act = 164;}
	goto st41;
tr366:
	{te = p+1;}
	{act = 166;}
	goto st41;
tr371:
	{te = p+1;}
	{act = 67;}
	goto st41;
tr374:
	{te = p+1;}
	{act = 167;}
	goto st41;
tr375:
	{te = p+1;}
	{act = 168;}
	goto st41;
tr377:
	{te = p+1;}
	{act = 169;}
	goto st41;
tr381:
	{te = p+1;}
	{act = 99;}
	goto st41;
tr382:
	{te = p+1;}
	{act = 170;}
	goto st41;
tr383:
	{te = p+1;}
	{act = 171;}
	goto st41;
tr384:
	{te = p+1;}
	{act = 172;}
	goto st41;
tr385:
	{te = p+1;}
	{act = 173;}
	goto st41;
tr386:
	{te = p+1;}
	{act = 174;}
	goto st41;
tr393:
	{te = p+1;}
	{act = 100;}
	goto st41;
tr399:
	{te = p+1;}
	{act = 101;}
	goto st41;
tr401:
	{te = p+1;}
	{act = 102;}
	goto st41;
tr402:
	{te = p+1;}
	{act = 175;}
	goto st41;
tr404:
	{te = p+1;}
	{act = 103;}
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
	if ( (*p) == 95 )
		goto tr80;
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr0;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
	switch( (*p) ) {
		case 67: goto tr151;
		case 68: goto tr152;
		case 95: goto tr80;
		case 99: goto tr151;
		case 100: goto tr152;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
	switch( (*p) ) {
		case 39: goto tr154;
		case 95: goto tr80;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr153;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
	switch( (*p) ) {
		case 68: goto tr155;
		case 95: goto tr80;
		case 100: goto tr155;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
	switch( (*p) ) {
		case 77: goto st46;
		case 95: goto tr80;
		case 109: goto st46;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
	switch( (*p) ) {
		case 80: goto st47;
		case 95: goto tr80;
		case 112: goto st47;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
	switch( (*p) ) {
		case 67: goto tr158;
		case 95: goto tr80;
		case 99: goto tr158;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	switch( (*p) ) {
		case 67: goto tr160;
		case 73: goto st49;
		case 95: goto tr80;
		case 99: goto tr160;
		case 105: goto st49;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr159;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	switch( (*p) ) {
		case 78: goto st50;
		case 84: goto tr163;
		case 95: goto tr80;
		case 110: goto st50;
		case 116: goto tr163;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st50:
	if ( ++p == pe )
		goto _test_eof50;
case 50:
	switch( (*p) ) {
		case 65: goto st51;
		case 95: goto tr80;
		case 97: goto st51;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	switch( (*p) ) {
		case 82: goto st52;
		case 95: goto tr80;
		case 114: goto st52;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
	switch( (*p) ) {
		case 89: goto tr166;
		case 95: goto tr80;
		case 121: goto tr166;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st53:
	if ( ++p == pe )
		goto _test_eof53;
case 53:
	switch( (*p) ) {
		case 65: goto st54;
		case 67: goto st61;
		case 80: goto st62;
		case 95: goto tr80;
		case 97: goto st54;
		case 99: goto st61;
		case 112: goto st62;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr167;
st54:
	if ( ++p == pe )
		goto _test_eof54;
case 54:
	switch( (*p) ) {
		case 76: goto st55;
		case 95: goto tr80;
		case 108: goto st55;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st55:
	if ( ++p == pe )
		goto _test_eof55;
case 55:
	switch( (*p) ) {
		case 76: goto st56;
		case 95: goto tr80;
		case 108: goto st56;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st56:
	if ( ++p == pe )
		goto _test_eof56;
case 56:
	if ( (*p) == 95 )
		goto st57;
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr173;
st57:
	if ( ++p == pe )
		goto _test_eof57;
case 57:
	switch( (*p) ) {
		case 79: goto st58;
		case 80: goto st59;
		case 95: goto tr80;
		case 111: goto st58;
		case 112: goto st59;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st58:
	if ( ++p == pe )
		goto _test_eof58;
case 58:
	switch( (*p) ) {
		case 90: goto tr177;
		case 95: goto tr80;
		case 122: goto tr177;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st59:
	if ( ++p == pe )
		goto _test_eof59;
case 59:
	switch( (*p) ) {
		case 75: goto st60;
		case 95: goto tr80;
		case 107: goto st60;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st60:
	if ( ++p == pe )
		goto _test_eof60;
case 60:
	switch( (*p) ) {
		case 71: goto tr179;
		case 95: goto tr80;
		case 103: goto tr179;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st61:
	if ( ++p == pe )
		goto _test_eof61;
case 61:
	switch( (*p) ) {
		case 70: goto tr180;
		case 95: goto tr80;
		case 102: goto tr180;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st62:
	if ( ++p == pe )
		goto _test_eof62;
case 62:
	switch( (*p) ) {
		case 68: goto st63;
		case 73: goto st64;
		case 76: goto tr184;
		case 95: goto tr80;
		case 100: goto st63;
		case 105: goto st64;
		case 108: goto tr184;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr181;
st63:
	if ( ++p == pe )
		goto _test_eof63;
case 63:
	switch( (*p) ) {
		case 82: goto tr186;
		case 95: goto tr80;
		case 114: goto tr186;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr185;
st64:
	if ( ++p == pe )
		goto _test_eof64;
case 64:
	switch( (*p) ) {
		case 82: goto tr188;
		case 95: goto tr80;
		case 114: goto tr188;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr187;
st65:
	if ( ++p == pe )
		goto _test_eof65;
case 65:
	switch( (*p) ) {
		case 65: goto st66;
		case 69: goto st67;
		case 73: goto tr192;
		case 74: goto st78;
		case 83: goto tr194;
		case 95: goto tr80;
		case 97: goto st66;
		case 101: goto st67;
		case 105: goto tr192;
		case 106: goto st78;
		case 115: goto tr194;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr189;
st66:
	if ( ++p == pe )
		goto _test_eof66;
case 66:
	switch( (*p) ) {
		case 65: goto tr195;
		case 95: goto tr80;
		case 97: goto tr195;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st67:
	if ( ++p == pe )
		goto _test_eof67;
case 67:
	switch( (*p) ) {
		case 67: goto tr197;
		case 70: goto st68;
		case 95: goto tr80;
		case 99: goto tr197;
		case 102: goto st68;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr196;
st68:
	if ( ++p == pe )
		goto _test_eof68;
case 68:
	switch( (*p) ) {
		case 66: goto tr199;
		case 67: goto tr200;
		case 71: goto st69;
		case 73: goto st73;
		case 76: goto tr203;
		case 77: goto tr204;
		case 83: goto tr205;
		case 86: goto st75;
		case 87: goto tr207;
		case 95: goto tr80;
		case 98: goto tr199;
		case 99: goto tr200;
		case 103: goto st69;
		case 105: goto st73;
		case 108: goto tr203;
		case 109: goto tr204;
		case 115: goto tr205;
		case 118: goto st75;
		case 119: goto tr207;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st69:
	if ( ++p == pe )
		goto _test_eof69;
case 69:
	switch( (*p) ) {
		case 82: goto st70;
		case 95: goto tr80;
		case 114: goto st70;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st70:
	if ( ++p == pe )
		goto _test_eof70;
case 70:
	switch( (*p) ) {
		case 79: goto st71;
		case 95: goto tr80;
		case 111: goto st71;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st71:
	if ( ++p == pe )
		goto _test_eof71;
case 71:
	switch( (*p) ) {
		case 85: goto st72;
		case 95: goto tr80;
		case 117: goto st72;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st72:
	if ( ++p == pe )
		goto _test_eof72;
case 72:
	switch( (*p) ) {
		case 80: goto tr211;
		case 95: goto tr80;
		case 112: goto tr211;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st73:
	if ( ++p == pe )
		goto _test_eof73;
case 73:
	switch( (*p) ) {
		case 78: goto st74;
		case 95: goto tr80;
		case 110: goto st74;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st74:
	if ( ++p == pe )
		goto _test_eof74;
case 74:
	switch( (*p) ) {
		case 69: goto tr213;
		case 95: goto tr80;
		case 101: goto tr213;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st75:
	if ( ++p == pe )
		goto _test_eof75;
case 75:
	switch( (*p) ) {
		case 65: goto st76;
		case 95: goto tr80;
		case 97: goto st76;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st76:
	if ( ++p == pe )
		goto _test_eof76;
case 76:
	switch( (*p) ) {
		case 82: goto st77;
		case 95: goto tr80;
		case 114: goto st77;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st77:
	if ( ++p == pe )
		goto _test_eof77;
case 77:
	switch( (*p) ) {
		case 83: goto tr216;
		case 95: goto tr80;
		case 115: goto tr216;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st78:
	if ( ++p == pe )
		goto _test_eof78;
case 78:
	switch( (*p) ) {
		case 78: goto st79;
		case 95: goto tr80;
		case 110: goto st79;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st79:
	if ( ++p == pe )
		goto _test_eof79;
case 79:
	switch( (*p) ) {
		case 90: goto tr218;
		case 95: goto tr80;
		case 122: goto tr218;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
tr194:
	{te = p+1;}
	goto st80;
st80:
	if ( ++p == pe )
		goto _test_eof80;
case 80:
	switch( (*p) ) {
		case 46: goto st18;
		case 95: goto tr80;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
	switch( (*p) ) {
		case 66: goto tr29;
		case 76: goto tr30;
		case 80: goto tr31;
		case 87: goto tr32;
		case 98: goto tr29;
		case 108: goto tr30;
		case 112: goto tr31;
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
		case 95: goto tr80;
		case 105: goto st82;
		case 108: goto st83;
		case 110: goto st85;
		case 120: goto st88;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr220;
st82:
	if ( ++p == pe )
		goto _test_eof82;
case 82:
	switch( (*p) ) {
		case 82: goto tr226;
		case 95: goto tr80;
		case 114: goto tr226;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr225;
st83:
	if ( ++p == pe )
		goto _test_eof83;
case 83:
	switch( (*p) ) {
		case 83: goto st84;
		case 95: goto tr80;
		case 115: goto st84;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st84:
	if ( ++p == pe )
		goto _test_eof84;
case 84:
	switch( (*p) ) {
		case 69: goto tr228;
		case 95: goto tr80;
		case 101: goto tr228;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st85:
	if ( ++p == pe )
		goto _test_eof85;
case 85:
	switch( (*p) ) {
		case 68: goto st86;
		case 95: goto tr80;
		case 100: goto st86;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st86:
	if ( ++p == pe )
		goto _test_eof86;
case 86:
	switch( (*p) ) {
		case 73: goto st87;
		case 95: goto tr80;
		case 105: goto st87;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st87:
	if ( ++p == pe )
		goto _test_eof87;
case 87:
	switch( (*p) ) {
		case 70: goto tr231;
		case 95: goto tr80;
		case 102: goto tr231;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st88:
	if ( ++p == pe )
		goto _test_eof88;
case 88:
	switch( (*p) ) {
		case 84: goto st89;
		case 88: goto tr234;
		case 95: goto tr80;
		case 116: goto st89;
		case 120: goto tr234;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr232;
st89:
	if ( ++p == pe )
		goto _test_eof89;
case 89:
	switch( (*p) ) {
		case 69: goto st90;
		case 95: goto tr80;
		case 101: goto st90;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st90:
	if ( ++p == pe )
		goto _test_eof90;
case 90:
	switch( (*p) ) {
		case 82: goto st91;
		case 95: goto tr80;
		case 114: goto st91;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st91:
	if ( ++p == pe )
		goto _test_eof91;
case 91:
	switch( (*p) ) {
		case 78: goto tr237;
		case 95: goto tr80;
		case 110: goto tr237;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st92:
	if ( ++p == pe )
		goto _test_eof92;
case 92:
	switch( (*p) ) {
		case 80: goto st93;
		case 95: goto tr80;
		case 112: goto st93;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr238;
st93:
	if ( ++p == pe )
		goto _test_eof93;
case 93:
	switch( (*p) ) {
		case 80: goto tr240;
		case 95: goto tr80;
		case 112: goto tr240;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st94:
	if ( ++p == pe )
		goto _test_eof94;
case 94:
	switch( (*p) ) {
		case 65: goto st95;
		case 76: goto tr243;
		case 95: goto tr80;
		case 97: goto st95;
		case 108: goto tr243;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr241;
st95:
	if ( ++p == pe )
		goto _test_eof95;
case 95:
	switch( (*p) ) {
		case 76: goto st96;
		case 95: goto tr80;
		case 108: goto st96;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st96:
	if ( ++p == pe )
		goto _test_eof96;
case 96:
	switch( (*p) ) {
		case 84: goto tr245;
		case 95: goto tr80;
		case 116: goto tr245;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st97:
	if ( ++p == pe )
		goto _test_eof97;
case 97:
	switch( (*p) ) {
		case 70: goto st98;
		case 73: goto st104;
		case 77: goto tr249;
		case 78: goto st105;
		case 88: goto st115;
		case 89: goto st116;
		case 95: goto tr80;
		case 102: goto st98;
		case 105: goto st104;
		case 109: goto tr249;
		case 110: goto st105;
		case 120: goto st115;
		case 121: goto st116;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr246;
st98:
	if ( ++p == pe )
		goto _test_eof98;
case 98:
	switch( (*p) ) {
		case 68: goto st99;
		case 78: goto st101;
		case 95: goto tr80;
		case 100: goto st99;
		case 110: goto st101;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr253;
st99:
	if ( ++p == pe )
		goto _test_eof99;
case 99:
	switch( (*p) ) {
		case 69: goto st100;
		case 95: goto tr80;
		case 101: goto st100;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st100:
	if ( ++p == pe )
		goto _test_eof100;
case 100:
	switch( (*p) ) {
		case 70: goto tr257;
		case 95: goto tr80;
		case 102: goto tr257;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st101:
	if ( ++p == pe )
		goto _test_eof101;
case 101:
	switch( (*p) ) {
		case 68: goto st102;
		case 95: goto tr80;
		case 100: goto st102;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st102:
	if ( ++p == pe )
		goto _test_eof102;
case 102:
	switch( (*p) ) {
		case 69: goto st103;
		case 95: goto tr80;
		case 101: goto st103;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st103:
	if ( ++p == pe )
		goto _test_eof103;
case 103:
	switch( (*p) ) {
		case 70: goto tr260;
		case 95: goto tr80;
		case 102: goto tr260;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st104:
	if ( ++p == pe )
		goto _test_eof104;
case 104:
	switch( (*p) ) {
		case 82: goto tr261;
		case 95: goto tr80;
		case 114: goto tr261;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st105:
	if ( ++p == pe )
		goto _test_eof105;
case 105:
	switch( (*p) ) {
		case 67: goto st106;
		case 68: goto st110;
		case 73: goto st111;
		case 86: goto st112;
		case 95: goto tr80;
		case 99: goto st106;
		case 100: goto st110;
		case 105: goto st111;
		case 118: goto st112;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr262;
st106:
	if ( ++p == pe )
		goto _test_eof106;
case 106:
	switch( (*p) ) {
		case 76: goto st107;
		case 95: goto tr80;
		case 108: goto st107;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr267;
st107:
	if ( ++p == pe )
		goto _test_eof107;
case 107:
	switch( (*p) ) {
		case 85: goto st108;
		case 95: goto tr80;
		case 117: goto st108;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st108:
	if ( ++p == pe )
		goto _test_eof108;
case 108:
	switch( (*p) ) {
		case 68: goto st109;
		case 95: goto tr80;
		case 100: goto st109;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st109:
	if ( ++p == pe )
		goto _test_eof109;
case 109:
	switch( (*p) ) {
		case 69: goto tr271;
		case 95: goto tr80;
		case 101: goto tr271;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st110:
	if ( ++p == pe )
		goto _test_eof110;
case 110:
	switch( (*p) ) {
		case 82: goto tr273;
		case 95: goto tr80;
		case 114: goto tr273;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr272;
st111:
	if ( ++p == pe )
		goto _test_eof111;
case 111:
	switch( (*p) ) {
		case 82: goto tr275;
		case 95: goto tr80;
		case 114: goto tr275;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr274;
st112:
	if ( ++p == pe )
		goto _test_eof112;
case 112:
	switch( (*p) ) {
		case 79: goto st113;
		case 95: goto tr80;
		case 111: goto st113;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st113:
	if ( ++p == pe )
		goto _test_eof113;
case 113:
	switch( (*p) ) {
		case 75: goto st114;
		case 95: goto tr80;
		case 107: goto st114;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st114:
	if ( ++p == pe )
		goto _test_eof114;
case 114:
	switch( (*p) ) {
		case 69: goto tr278;
		case 95: goto tr80;
		case 101: goto tr278;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st115:
	if ( ++p == pe )
		goto _test_eof115;
case 115:
	switch( (*p) ) {
		case 72: goto tr280;
		case 76: goto tr281;
		case 95: goto tr80;
		case 104: goto tr280;
		case 108: goto tr281;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr279;
st116:
	if ( ++p == pe )
		goto _test_eof116;
case 116:
	switch( (*p) ) {
		case 72: goto tr283;
		case 76: goto tr284;
		case 95: goto tr80;
		case 104: goto tr283;
		case 108: goto tr284;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr282;
st117:
	if ( ++p == pe )
		goto _test_eof117;
case 117:
	switch( (*p) ) {
		case 80: goto tr285;
		case 82: goto tr286;
		case 95: goto tr80;
		case 112: goto tr285;
		case 114: goto tr286;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st118:
	if ( ++p == pe )
		goto _test_eof118;
case 118:
	switch( (*p) ) {
		case 68: goto st119;
		case 73: goto st122;
		case 83: goto st124;
		case 95: goto tr80;
		case 100: goto st119;
		case 105: goto st122;
		case 115: goto st124;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr287;
st119:
	if ( ++p == pe )
		goto _test_eof119;
case 119:
	switch( (*p) ) {
		case 68: goto st120;
		case 73: goto st121;
		case 95: goto tr80;
		case 100: goto st120;
		case 105: goto st121;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr291;
st120:
	if ( ++p == pe )
		goto _test_eof120;
case 120:
	switch( (*p) ) {
		case 82: goto tr295;
		case 95: goto tr80;
		case 114: goto tr295;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr294;
st121:
	if ( ++p == pe )
		goto _test_eof121;
case 121:
	switch( (*p) ) {
		case 82: goto tr297;
		case 95: goto tr80;
		case 114: goto tr297;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr296;
st122:
	if ( ++p == pe )
		goto _test_eof122;
case 122:
	switch( (*p) ) {
		case 66: goto tr298;
		case 78: goto st123;
		case 95: goto tr80;
		case 98: goto tr298;
		case 110: goto st123;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st123:
	if ( ++p == pe )
		goto _test_eof123;
case 123:
	switch( (*p) ) {
		case 69: goto tr300;
		case 95: goto tr80;
		case 101: goto tr300;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st124:
	if ( ++p == pe )
		goto _test_eof124;
case 124:
	switch( (*p) ) {
		case 84: goto st125;
		case 95: goto tr80;
		case 116: goto st125;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st125:
	if ( ++p == pe )
		goto _test_eof125;
case 125:
	switch( (*p) ) {
		case 79: goto st126;
		case 95: goto tr80;
		case 111: goto st126;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st126:
	if ( ++p == pe )
		goto _test_eof126;
case 126:
	switch( (*p) ) {
		case 70: goto st127;
		case 78: goto tr304;
		case 95: goto tr80;
		case 102: goto st127;
		case 110: goto tr304;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st127:
	if ( ++p == pe )
		goto _test_eof127;
case 127:
	switch( (*p) ) {
		case 70: goto tr305;
		case 95: goto tr80;
		case 102: goto tr305;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st128:
	if ( ++p == pe )
		goto _test_eof128;
case 128:
	switch( (*p) ) {
		case 79: goto st129;
		case 95: goto tr80;
		case 111: goto st129;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr306;
st129:
	if ( ++p == pe )
		goto _test_eof129;
case 129:
	switch( (*p) ) {
		case 68: goto st130;
		case 95: goto tr80;
		case 100: goto st130;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st130:
	if ( ++p == pe )
		goto _test_eof130;
case 130:
	switch( (*p) ) {
		case 85: goto st131;
		case 95: goto tr80;
		case 117: goto st131;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st131:
	if ( ++p == pe )
		goto _test_eof131;
case 131:
	switch( (*p) ) {
		case 76: goto st132;
		case 95: goto tr80;
		case 108: goto st132;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st132:
	if ( ++p == pe )
		goto _test_eof132;
case 132:
	switch( (*p) ) {
		case 69: goto tr311;
		case 95: goto tr80;
		case 101: goto tr311;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st133:
	if ( ++p == pe )
		goto _test_eof133;
case 133:
	switch( (*p) ) {
		case 67: goto tr312;
		case 69: goto st134;
		case 79: goto st135;
		case 90: goto tr315;
		case 95: goto tr80;
		case 99: goto tr312;
		case 101: goto st134;
		case 111: goto st135;
		case 122: goto tr315;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st134:
	if ( ++p == pe )
		goto _test_eof134;
case 134:
	switch( (*p) ) {
		case 71: goto tr316;
		case 95: goto tr80;
		case 103: goto tr316;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st135:
	if ( ++p == pe )
		goto _test_eof135;
case 135:
	switch( (*p) ) {
		case 80: goto tr317;
		case 95: goto tr80;
		case 112: goto tr317;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st136:
	if ( ++p == pe )
		goto _test_eof136;
case 136:
	switch( (*p) ) {
		case 82: goto st137;
		case 84: goto st138;
		case 85: goto st141;
		case 90: goto tr321;
		case 95: goto tr80;
		case 114: goto st137;
		case 116: goto st138;
		case 117: goto st141;
		case 122: goto tr321;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 89 ) {
		if ( 97 <= (*p) && (*p) <= 121 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st137:
	if ( ++p == pe )
		goto _test_eof137;
case 137:
	switch( (*p) ) {
		case 71: goto tr323;
		case 95: goto tr80;
		case 103: goto tr323;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr322;
st138:
	if ( ++p == pe )
		goto _test_eof138;
case 138:
	switch( (*p) ) {
		case 68: goto st139;
		case 73: goto st140;
		case 95: goto tr80;
		case 100: goto st139;
		case 105: goto st140;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st139:
	if ( ++p == pe )
		goto _test_eof139;
case 139:
	switch( (*p) ) {
		case 82: goto tr326;
		case 95: goto tr80;
		case 114: goto tr326;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st140:
	if ( ++p == pe )
		goto _test_eof140;
case 140:
	switch( (*p) ) {
		case 82: goto tr327;
		case 95: goto tr80;
		case 114: goto tr327;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st141:
	if ( ++p == pe )
		goto _test_eof141;
case 141:
	switch( (*p) ) {
		case 84: goto st142;
		case 95: goto tr80;
		case 116: goto st142;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st142:
	if ( ++p == pe )
		goto _test_eof142;
case 142:
	switch( (*p) ) {
		case 68: goto tr330;
		case 73: goto tr331;
		case 95: goto tr80;
		case 100: goto tr330;
		case 105: goto tr331;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr329;
st143:
	if ( ++p == pe )
		goto _test_eof143;
case 143:
	switch( (*p) ) {
		case 69: goto tr333;
		case 79: goto st144;
		case 85: goto st145;
		case 95: goto tr80;
		case 101: goto tr333;
		case 111: goto st144;
		case 117: goto st145;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr332;
st144:
	if ( ++p == pe )
		goto _test_eof144;
case 144:
	switch( (*p) ) {
		case 80: goto tr337;
		case 95: goto tr80;
		case 112: goto tr337;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr336;
st145:
	if ( ++p == pe )
		goto _test_eof145;
case 145:
	switch( (*p) ) {
		case 66: goto st146;
		case 83: goto st149;
		case 95: goto tr80;
		case 98: goto st146;
		case 115: goto st149;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st146:
	if ( ++p == pe )
		goto _test_eof146;
case 146:
	switch( (*p) ) {
		case 76: goto st147;
		case 95: goto tr80;
		case 108: goto st147;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st147:
	if ( ++p == pe )
		goto _test_eof147;
case 147:
	switch( (*p) ) {
		case 73: goto st148;
		case 95: goto tr80;
		case 105: goto st148;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st148:
	if ( ++p == pe )
		goto _test_eof148;
case 148:
	switch( (*p) ) {
		case 67: goto tr342;
		case 95: goto tr80;
		case 99: goto tr342;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st149:
	if ( ++p == pe )
		goto _test_eof149;
case 149:
	switch( (*p) ) {
		case 72: goto tr343;
		case 95: goto tr80;
		case 104: goto tr343;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st150:
	if ( ++p == pe )
		goto _test_eof150;
case 150:
	switch( (*p) ) {
		case 69: goto st151;
		case 76: goto st153;
		case 82: goto st155;
		case 83: goto st157;
		case 95: goto tr80;
		case 101: goto st151;
		case 108: goto st153;
		case 114: goto st155;
		case 115: goto st157;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr344;
st151:
	if ( ++p == pe )
		goto _test_eof151;
case 151:
	switch( (*p) ) {
		case 83: goto tr349;
		case 84: goto st152;
		case 95: goto tr80;
		case 115: goto tr349;
		case 116: goto st152;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st152:
	if ( ++p == pe )
		goto _test_eof152;
case 152:
	switch( (*p) ) {
		case 73: goto tr352;
		case 78: goto tr353;
		case 95: goto tr80;
		case 105: goto tr352;
		case 110: goto tr353;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr351;
st153:
	if ( ++p == pe )
		goto _test_eof153;
case 153:
	switch( (*p) ) {
		case 65: goto tr355;
		case 67: goto st154;
		case 68: goto tr357;
		case 95: goto tr80;
		case 97: goto tr355;
		case 99: goto st154;
		case 100: goto tr357;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr354;
st154:
	if ( ++p == pe )
		goto _test_eof154;
case 154:
	switch( (*p) ) {
		case 65: goto tr359;
		case 95: goto tr80;
		case 97: goto tr359;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr358;
st155:
	if ( ++p == pe )
		goto _test_eof155;
case 155:
	switch( (*p) ) {
		case 65: goto tr361;
		case 67: goto st156;
		case 68: goto tr363;
		case 95: goto tr80;
		case 97: goto tr361;
		case 99: goto st156;
		case 100: goto tr363;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr360;
st156:
	if ( ++p == pe )
		goto _test_eof156;
case 156:
	switch( (*p) ) {
		case 65: goto tr365;
		case 95: goto tr80;
		case 97: goto tr365;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr364;
st157:
	if ( ++p == pe )
		goto _test_eof157;
case 157:
	switch( (*p) ) {
		case 84: goto tr366;
		case 95: goto tr80;
		case 116: goto tr366;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st158:
	if ( ++p == pe )
		goto _test_eof158;
case 158:
	switch( (*p) ) {
		case 66: goto st159;
		case 67: goto st160;
		case 69: goto st161;
		case 76: goto st166;
		case 80: goto tr371;
		case 82: goto st167;
		case 85: goto st168;
		case 95: goto tr80;
		case 98: goto st159;
		case 99: goto st160;
		case 101: goto st161;
		case 108: goto st166;
		case 112: goto tr371;
		case 114: goto st167;
		case 117: goto st168;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st159:
	if ( ++p == pe )
		goto _test_eof159;
case 159:
	switch( (*p) ) {
		case 67: goto tr374;
		case 95: goto tr80;
		case 99: goto tr374;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st160:
	if ( ++p == pe )
		goto _test_eof160;
case 160:
	switch( (*p) ) {
		case 70: goto tr375;
		case 95: goto tr80;
		case 102: goto tr375;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st161:
	if ( ++p == pe )
		goto _test_eof161;
case 161:
	switch( (*p) ) {
		case 67: goto st162;
		case 84: goto tr377;
		case 95: goto tr80;
		case 99: goto st162;
		case 116: goto tr377;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st162:
	if ( ++p == pe )
		goto _test_eof162;
case 162:
	switch( (*p) ) {
		case 84: goto st163;
		case 95: goto tr80;
		case 116: goto st163;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st163:
	if ( ++p == pe )
		goto _test_eof163;
case 163:
	switch( (*p) ) {
		case 73: goto st164;
		case 95: goto tr80;
		case 105: goto st164;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st164:
	if ( ++p == pe )
		goto _test_eof164;
case 164:
	switch( (*p) ) {
		case 79: goto st165;
		case 95: goto tr80;
		case 111: goto st165;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st165:
	if ( ++p == pe )
		goto _test_eof165;
case 165:
	switch( (*p) ) {
		case 78: goto tr381;
		case 95: goto tr80;
		case 110: goto tr381;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st166:
	if ( ++p == pe )
		goto _test_eof166;
case 166:
	switch( (*p) ) {
		case 65: goto tr382;
		case 76: goto tr383;
		case 95: goto tr80;
		case 97: goto tr382;
		case 108: goto tr383;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st167:
	if ( ++p == pe )
		goto _test_eof167;
case 167:
	switch( (*p) ) {
		case 65: goto tr384;
		case 76: goto tr385;
		case 95: goto tr80;
		case 97: goto tr384;
		case 108: goto tr385;
	}
	if ( (*p) < 66 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 98 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st168:
	if ( ++p == pe )
		goto _test_eof168;
case 168:
	switch( (*p) ) {
		case 66: goto tr386;
		case 95: goto tr80;
		case 98: goto tr386;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st169:
	if ( ++p == pe )
		goto _test_eof169;
case 169:
	switch( (*p) ) {
		case 78: goto st170;
		case 95: goto tr80;
		case 110: goto st170;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st170:
	if ( ++p == pe )
		goto _test_eof170;
case 170:
	switch( (*p) ) {
		case 68: goto st171;
		case 95: goto tr80;
		case 100: goto st171;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st171:
	if ( ++p == pe )
		goto _test_eof171;
case 171:
	switch( (*p) ) {
		case 69: goto st172;
		case 95: goto tr80;
		case 101: goto st172;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st172:
	if ( ++p == pe )
		goto _test_eof172;
case 172:
	switch( (*p) ) {
		case 70: goto st173;
		case 95: goto tr80;
		case 102: goto st173;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st173:
	if ( ++p == pe )
		goto _test_eof173;
case 173:
	switch( (*p) ) {
		case 73: goto st174;
		case 95: goto tr80;
		case 105: goto st174;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st174:
	if ( ++p == pe )
		goto _test_eof174;
case 174:
	switch( (*p) ) {
		case 78: goto st175;
		case 95: goto tr80;
		case 110: goto st175;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st175:
	if ( ++p == pe )
		goto _test_eof175;
case 175:
	switch( (*p) ) {
		case 69: goto tr393;
		case 95: goto tr80;
		case 101: goto tr393;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st176:
	if ( ++p == pe )
		goto _test_eof176;
case 176:
	switch( (*p) ) {
		case 68: goto st177;
		case 76: goto st179;
		case 79: goto st181;
		case 82: goto st182;
		case 95: goto tr80;
		case 100: goto st177;
		case 108: goto st179;
		case 111: goto st181;
		case 114: goto st182;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st177:
	if ( ++p == pe )
		goto _test_eof177;
case 177:
	switch( (*p) ) {
		case 69: goto st178;
		case 95: goto tr80;
		case 101: goto st178;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st178:
	if ( ++p == pe )
		goto _test_eof178;
case 178:
	switch( (*p) ) {
		case 70: goto tr399;
		case 95: goto tr80;
		case 102: goto tr399;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st179:
	if ( ++p == pe )
		goto _test_eof179;
case 179:
	switch( (*p) ) {
		case 73: goto st180;
		case 95: goto tr80;
		case 105: goto st180;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st180:
	if ( ++p == pe )
		goto _test_eof180;
case 180:
	switch( (*p) ) {
		case 66: goto tr401;
		case 95: goto tr80;
		case 98: goto tr401;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st181:
	if ( ++p == pe )
		goto _test_eof181;
case 181:
	switch( (*p) ) {
		case 82: goto tr402;
		case 95: goto tr80;
		case 114: goto tr402;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st182:
	if ( ++p == pe )
		goto _test_eof182;
case 182:
	switch( (*p) ) {
		case 69: goto st183;
		case 95: goto tr80;
		case 101: goto st183;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
st183:
	if ( ++p == pe )
		goto _test_eof183;
case 183:
	switch( (*p) ) {
		case 70: goto tr404;
		case 95: goto tr80;
		case 102: goto tr404;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr80;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr80;
	} else
		goto tr80;
	goto tr150;
tr94:
	{te = p+1;}
	goto st184;
st184:
	if ( ++p == pe )
		goto _test_eof184;
case 184:
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
		case 607: goto st185;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st185;
	} else if ( _widec >= 577 )
		goto st185;
	goto tr405;
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
		case 607: goto st185;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st185;
	} else if ( _widec >= 577 )
		goto st185;
	goto tr33;
st185:
	if ( ++p == pe )
		goto _test_eof185;
case 185:
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
		goto st185;
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st185;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st185;
	} else
		goto st185;
	goto tr406;
tr95:
	{te = p+1;}
	{act = 54;}
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
		case 324: goto st42;
		case 326: goto st43;
		case 334: goto st44;
		case 339: goto st45;
		case 351: goto tr80;
		case 356: goto st42;
		case 358: goto st43;
		case 366: goto st44;
		case 371: goto st45;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr407;
		case 582: goto tr408;
		case 590: goto tr409;
		case 595: goto tr410;
		case 607: goto tr101;
		case 612: goto tr407;
		case 614: goto tr408;
		case 622: goto tr409;
		case 627: goto tr410;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
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
		case 570: goto tr37;
	}
	goto tr0;
tr101:
	{te = p+1;}
	{act = 183;}
	goto st187;
tr114:
	{te = p+1;}
	{act = 38;}
	goto st187;
tr411:
	{te = p+1;}
	{act = 108;}
	goto st187;
tr412:
	{te = p+1;}
	{act = 109;}
	goto st187;
tr413:
	{te = p+1;}
	{act = 110;}
	goto st187;
tr416:
	{te = p+1;}
	{act = 1;}
	goto st187;
tr417:
	{te = p+1;}
	{act = 61;}
	goto st187;
tr420:
	{te = p+1;}
	{act = 111;}
	goto st187;
tr423:
	{te = p+1;}
	{act = 75;}
	goto st187;
tr432:
	{te = p+1;}
	{act = 176;}
	goto st187;
tr434:
	{te = p+1;}
	{act = 178;}
	goto st187;
tr435:
	{te = p+1;}
	{act = 113;}
	goto st187;
tr438:
	{te = p+1;}
	{act = 119;}
	goto st187;
tr439:
	{te = p+1;}
	{act = 116;}
	goto st187;
tr440:
	{te = p+1;}
	{act = 118;}
	goto st187;
tr443:
	{te = p+1;}
	{act = 122;}
	goto st187;
tr446:
	{te = p+1;}
	{act = 120;}
	goto st187;
tr447:
	{te = p+1;}
	{act = 121;}
	goto st187;
tr449:
	{te = p+1;}
	{act = 76;}
	goto st187;
tr450:
	{te = p+1;}
	{act = 77;}
	goto st187;
tr453:
	{te = p+1;}
	{act = 80;}
	goto st187;
tr454:
	{te = p+1;}
	{act = 81;}
	goto st187;
tr455:
	{te = p+1;}
	{act = 82;}
	goto st187;
tr457:
	{te = p+1;}
	{act = 84;}
	goto st187;
tr461:
	{te = p+1;}
	{act = 78;}
	goto st187;
tr463:
	{te = p+1;}
	{act = 79;}
	goto st187;
tr466:
	{te = p+1;}
	{act = 83;}
	goto st187;
tr468:
	{te = p+1;}
	{act = 123;}
	goto st187;
tr473:
	{te = p+1;}
	{act = 59;}
	goto st187;
tr475:
	{te = p+1;}
	{act = 85;}
	goto st187;
tr478:
	{te = p+1;}
	{act = 86;}
	goto st187;
tr480:
	{te = p+1;}
	{act = 126;}
	goto st187;
tr483:
	{te = p+1;}
	{act = 87;}
	goto st187;
tr485:
	{te = p+1;}
	{act = 179;}
	goto st187;
tr487:
	{te = p+1;}
	{act = 63;}
	goto st187;
tr489:
	{te = p+1;}
	{act = 127;}
	goto st187;
tr492:
	{te = p+1;}
	{act = 128;}
	goto st187;
tr499:
	{te = p+1;}
	{act = 89;}
	goto st187;
tr502:
	{te = p+1;}
	{act = 90;}
	goto st187;
tr503:
	{te = p+1;}
	{act = 57;}
	goto st187;
tr511:
	{te = p+1;}
	{act = 91;}
	goto st187;
tr512:
	{te = p+1;}
	{act = 132;}
	goto st187;
tr513:
	{te = p+1;}
	{act = 134;}
	goto st187;
tr516:
	{te = p+1;}
	{act = 180;}
	goto st187;
tr517:
	{te = p+1;}
	{act = 49;}
	goto st187;
tr518:
	{te = p+1;}
	{act = 52;}
	goto st187;
tr519:
	{te = p+1;}
	{act = 50;}
	goto st187;
tr520:
	{te = p+1;}
	{act = 53;}
	goto st187;
tr521:
	{te = p+1;}
	{act = 135;}
	goto st187;
tr522:
	{te = p+1;}
	{act = 136;}
	goto st187;
tr528:
	{te = p+1;}
	{act = 139;}
	goto st187;
tr529:
	{te = p+1;}
	{act = 141;}
	goto st187;
tr530:
	{te = p+1;}
	{act = 92;}
	goto st187;
tr532:
	{te = p+1;}
	{act = 93;}
	goto st187;
tr536:
	{te = p+1;}
	{act = 95;}
	goto st187;
tr537:
	{te = p+1;}
	{act = 94;}
	goto st187;
tr542:
	{te = p+1;}
	{act = 96;}
	goto st187;
tr543:
	{te = p+1;}
	{act = 39;}
	goto st187;
tr546:
	{te = p+1;}
	{act = 37;}
	goto st187;
tr547:
	{te = p+1;}
	{act = 142;}
	goto st187;
tr548:
	{te = p+1;}
	{act = 143;}
	goto st187;
tr552:
	{te = p+1;}
	{act = 177;}
	goto st187;
tr553:
	{te = p+1;}
	{act = 97;}
	goto st187;
tr556:
	{te = p+1;}
	{act = 145;}
	goto st187;
tr557:
	{te = p+1;}
	{act = 146;}
	goto st187;
tr559:
	{te = p+1;}
	{act = 148;}
	goto st187;
tr560:
	{te = p+1;}
	{act = 149;}
	goto st187;
tr561:
	{te = p+1;}
	{act = 42;}
	goto st187;
tr564:
	{te = p+1;}
	{act = 150;}
	goto st187;
tr569:
	{te = p+1;}
	{act = 98;}
	goto st187;
tr570:
	{te = p+1;}
	{act = 151;}
	goto st187;
tr575:
	{te = p+1;}
	{act = 152;}
	goto st187;
tr577:
	{te = p+1;}
	{act = 154;}
	goto st187;
tr578:
	{te = p+1;}
	{act = 155;}
	goto st187;
tr579:
	{te = p+1;}
	{act = 157;}
	goto st187;
tr581:
	{te = p+1;}
	{act = 160;}
	goto st187;
tr582:
	{te = p+1;}
	{act = 159;}
	goto st187;
tr583:
	{te = p+1;}
	{act = 162;}
	goto st187;
tr585:
	{te = p+1;}
	{act = 165;}
	goto st187;
tr586:
	{te = p+1;}
	{act = 164;}
	goto st187;
tr587:
	{te = p+1;}
	{act = 166;}
	goto st187;
tr592:
	{te = p+1;}
	{act = 67;}
	goto st187;
tr595:
	{te = p+1;}
	{act = 167;}
	goto st187;
tr596:
	{te = p+1;}
	{act = 168;}
	goto st187;
tr598:
	{te = p+1;}
	{act = 169;}
	goto st187;
tr602:
	{te = p+1;}
	{act = 99;}
	goto st187;
tr603:
	{te = p+1;}
	{act = 170;}
	goto st187;
tr604:
	{te = p+1;}
	{act = 171;}
	goto st187;
tr605:
	{te = p+1;}
	{act = 172;}
	goto st187;
tr606:
	{te = p+1;}
	{act = 173;}
	goto st187;
tr607:
	{te = p+1;}
	{act = 174;}
	goto st187;
tr614:
	{te = p+1;}
	{act = 100;}
	goto st187;
tr620:
	{te = p+1;}
	{act = 101;}
	goto st187;
tr622:
	{te = p+1;}
	{act = 102;}
	goto st187;
tr623:
	{te = p+1;}
	{act = 175;}
	goto st187;
tr625:
	{te = p+1;}
	{act = 103;}
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
		case 351: goto tr80;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr101;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr0;
tr407:
	{te = p+1;}
	{act = 183;}
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
		case 323: goto tr151;
		case 324: goto tr152;
		case 351: goto tr80;
		case 355: goto tr151;
		case 356: goto tr152;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr411;
		case 580: goto tr412;
		case 607: goto tr101;
		case 611: goto tr411;
		case 612: goto tr412;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr408:
	{te = p+1;}
	{act = 66;}
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
		case 39: goto tr154;
		case 351: goto tr80;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr101;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr153;
tr409:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto tr155;
		case 351: goto tr80;
		case 356: goto tr155;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr413;
		case 607: goto tr101;
		case 612: goto tr413;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr410:
	{te = p+1;}
	{act = 183;}
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
		case 333: goto st46;
		case 351: goto tr80;
		case 365: goto st46;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 589: goto tr414;
		case 607: goto tr101;
		case 621: goto tr414;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr414:
	{te = p+1;}
	{act = 183;}
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
		case 336: goto st47;
		case 351: goto tr80;
		case 368: goto st47;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr415;
		case 607: goto tr101;
		case 624: goto tr415;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr415:
	{te = p+1;}
	{act = 183;}
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
		case 323: goto tr158;
		case 351: goto tr80;
		case 355: goto tr158;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr416;
		case 607: goto tr101;
		case 611: goto tr416;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr96:
	{te = p+1;}
	{act = 45;}
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
		case 323: goto tr160;
		case 329: goto st49;
		case 351: goto tr80;
		case 355: goto tr160;
		case 361: goto st49;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr417;
		case 585: goto tr418;
		case 607: goto tr101;
		case 611: goto tr417;
		case 617: goto tr418;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr159;
tr418:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto st50;
		case 340: goto tr163;
		case 351: goto tr80;
		case 366: goto st50;
		case 372: goto tr163;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr419;
		case 596: goto tr420;
		case 607: goto tr101;
		case 622: goto tr419;
		case 628: goto tr420;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr419:
	{te = p+1;}
	{act = 183;}
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
		case 321: goto st51;
		case 351: goto tr80;
		case 353: goto st51;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr421;
		case 607: goto tr101;
		case 609: goto tr421;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr421:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto st52;
		case 351: goto tr80;
		case 370: goto st52;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr422;
		case 607: goto tr101;
		case 626: goto tr422;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr422:
	{te = p+1;}
	{act = 183;}
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
		case 345: goto tr166;
		case 351: goto tr80;
		case 377: goto tr166;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 601: goto tr423;
		case 607: goto tr101;
		case 633: goto tr423;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr97:
	{te = p+1;}
	{act = 40;}
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
		case 321: goto st54;
		case 323: goto st61;
		case 336: goto st62;
		case 351: goto tr80;
		case 353: goto st54;
		case 355: goto st61;
		case 368: goto st62;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr424;
		case 579: goto tr425;
		case 592: goto tr426;
		case 607: goto tr101;
		case 609: goto tr424;
		case 611: goto tr425;
		case 624: goto tr426;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr167;
tr424:
	{te = p+1;}
	{act = 183;}
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
		case 332: goto st55;
		case 351: goto tr80;
		case 364: goto st55;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr427;
		case 607: goto tr101;
		case 620: goto tr427;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr427:
	{te = p+1;}
	{act = 183;}
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
		case 332: goto st56;
		case 351: goto tr80;
		case 364: goto st56;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr428;
		case 607: goto tr101;
		case 620: goto tr428;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr428:
	{te = p+1;}
	{act = 112;}
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
		case 351: goto st57;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr429;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr173;
tr429:
	{te = p+1;}
	{act = 183;}
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
		case 335: goto st58;
		case 336: goto st59;
		case 351: goto tr80;
		case 367: goto st58;
		case 368: goto st59;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr430;
		case 592: goto tr431;
		case 607: goto tr101;
		case 623: goto tr430;
		case 624: goto tr431;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr430:
	{te = p+1;}
	{act = 183;}
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
		case 346: goto tr177;
		case 351: goto tr80;
		case 378: goto tr177;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 602: goto tr432;
		case 607: goto tr101;
		case 634: goto tr432;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr431:
	{te = p+1;}
	{act = 183;}
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
		case 331: goto st60;
		case 351: goto tr80;
		case 363: goto st60;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 587: goto tr433;
		case 607: goto tr101;
		case 619: goto tr433;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr433:
	{te = p+1;}
	{act = 183;}
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
		case 327: goto tr179;
		case 351: goto tr80;
		case 359: goto tr179;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 583: goto tr434;
		case 607: goto tr101;
		case 615: goto tr434;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr425:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr180;
		case 351: goto tr80;
		case 358: goto tr180;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr435;
		case 607: goto tr101;
		case 614: goto tr435;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr426:
	{te = p+1;}
	{act = 114;}
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
		case 324: goto st63;
		case 329: goto st64;
		case 332: goto tr184;
		case 351: goto tr80;
		case 356: goto st63;
		case 361: goto st64;
		case 364: goto tr184;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr436;
		case 585: goto tr437;
		case 588: goto tr438;
		case 607: goto tr101;
		case 612: goto tr436;
		case 617: goto tr437;
		case 620: goto tr438;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr181;
tr436:
	{te = p+1;}
	{act = 115;}
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
		case 338: goto tr186;
		case 351: goto tr80;
		case 370: goto tr186;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr439;
		case 607: goto tr101;
		case 626: goto tr439;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr185;
tr437:
	{te = p+1;}
	{act = 117;}
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
		case 338: goto tr188;
		case 351: goto tr80;
		case 370: goto tr188;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr440;
		case 607: goto tr101;
		case 626: goto tr440;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr187;
tr98:
	{te = p+1;}
	{act = 46;}
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
		case 321: goto st66;
		case 325: goto st67;
		case 329: goto tr192;
		case 330: goto st78;
		case 339: goto tr194;
		case 351: goto tr80;
		case 353: goto st66;
		case 357: goto st67;
		case 361: goto tr192;
		case 362: goto st78;
		case 371: goto tr194;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr441;
		case 581: goto tr442;
		case 585: goto tr443;
		case 586: goto tr444;
		case 595: goto tr445;
		case 607: goto tr101;
		case 609: goto tr441;
		case 613: goto tr442;
		case 617: goto tr443;
		case 618: goto tr444;
		case 627: goto tr445;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr189;
tr441:
	{te = p+1;}
	{act = 183;}
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
		case 321: goto tr195;
		case 351: goto tr80;
		case 353: goto tr195;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr446;
		case 607: goto tr101;
		case 609: goto tr446;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr442:
	{te = p+1;}
	{act = 62;}
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
		case 323: goto tr197;
		case 326: goto st68;
		case 351: goto tr80;
		case 355: goto tr197;
		case 358: goto st68;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr447;
		case 582: goto tr448;
		case 607: goto tr101;
		case 611: goto tr447;
		case 614: goto tr448;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr196;
tr448:
	{te = p+1;}
	{act = 183;}
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
		case 322: goto tr199;
		case 323: goto tr200;
		case 327: goto st69;
		case 329: goto st73;
		case 332: goto tr203;
		case 333: goto tr204;
		case 339: goto tr205;
		case 342: goto st75;
		case 343: goto tr207;
		case 351: goto tr80;
		case 354: goto tr199;
		case 355: goto tr200;
		case 359: goto st69;
		case 361: goto st73;
		case 364: goto tr203;
		case 365: goto tr204;
		case 371: goto tr205;
		case 374: goto st75;
		case 375: goto tr207;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr449;
		case 579: goto tr450;
		case 583: goto tr451;
		case 585: goto tr452;
		case 588: goto tr453;
		case 589: goto tr454;
		case 595: goto tr455;
		case 598: goto tr456;
		case 599: goto tr457;
		case 607: goto tr101;
		case 610: goto tr449;
		case 611: goto tr450;
		case 615: goto tr451;
		case 617: goto tr452;
		case 620: goto tr453;
		case 621: goto tr454;
		case 627: goto tr455;
		case 630: goto tr456;
		case 631: goto tr457;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr451:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto st70;
		case 351: goto tr80;
		case 370: goto st70;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr458;
		case 607: goto tr101;
		case 626: goto tr458;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr458:
	{te = p+1;}
	{act = 183;}
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
		case 335: goto st71;
		case 351: goto tr80;
		case 367: goto st71;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr459;
		case 607: goto tr101;
		case 623: goto tr459;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr459:
	{te = p+1;}
	{act = 183;}
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
		case 341: goto st72;
		case 351: goto tr80;
		case 373: goto st72;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 597: goto tr460;
		case 607: goto tr101;
		case 629: goto tr460;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr460:
	{te = p+1;}
	{act = 183;}
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
		case 336: goto tr211;
		case 351: goto tr80;
		case 368: goto tr211;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr461;
		case 607: goto tr101;
		case 624: goto tr461;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr452:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto st74;
		case 351: goto tr80;
		case 366: goto st74;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr462;
		case 607: goto tr101;
		case 622: goto tr462;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr462:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr213;
		case 351: goto tr80;
		case 357: goto tr213;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr463;
		case 607: goto tr101;
		case 613: goto tr463;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr456:
	{te = p+1;}
	{act = 183;}
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
		case 321: goto st76;
		case 351: goto tr80;
		case 353: goto st76;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr464;
		case 607: goto tr101;
		case 609: goto tr464;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr464:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto st77;
		case 351: goto tr80;
		case 370: goto st77;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr465;
		case 607: goto tr101;
		case 626: goto tr465;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr465:
	{te = p+1;}
	{act = 183;}
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
		case 339: goto tr216;
		case 351: goto tr80;
		case 371: goto tr216;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr466;
		case 607: goto tr101;
		case 627: goto tr466;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr444:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto st79;
		case 351: goto tr80;
		case 366: goto st79;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr467;
		case 607: goto tr101;
		case 622: goto tr467;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr467:
	{te = p+1;}
	{act = 183;}
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
		case 346: goto tr218;
		case 351: goto tr80;
		case 378: goto tr218;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 602: goto tr468;
		case 607: goto tr101;
		case 634: goto tr468;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr445:
	{te = p+1;}
	{act = 183;}
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
		case 46: goto st18;
		case 351: goto tr80;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 607: goto tr101;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr99:
	{te = p+1;}
	{act = 47;}
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
		case 329: goto st82;
		case 332: goto st83;
		case 334: goto st85;
		case 344: goto st88;
		case 351: goto tr80;
		case 361: goto st82;
		case 364: goto st83;
		case 366: goto st85;
		case 376: goto st88;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr469;
		case 588: goto tr470;
		case 590: goto tr471;
		case 600: goto tr472;
		case 607: goto tr101;
		case 617: goto tr469;
		case 620: goto tr470;
		case 622: goto tr471;
		case 632: goto tr472;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr220;
tr469:
	{te = p+1;}
	{act = 124;}
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
		case 338: goto tr226;
		case 351: goto tr80;
		case 370: goto tr226;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr473;
		case 607: goto tr101;
		case 626: goto tr473;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr225;
tr470:
	{te = p+1;}
	{act = 183;}
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
		case 339: goto st84;
		case 351: goto tr80;
		case 371: goto st84;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr474;
		case 607: goto tr101;
		case 627: goto tr474;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr474:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr228;
		case 351: goto tr80;
		case 357: goto tr228;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr475;
		case 607: goto tr101;
		case 613: goto tr475;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr471:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st86;
		case 351: goto tr80;
		case 356: goto st86;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr476;
		case 607: goto tr101;
		case 612: goto tr476;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr476:
	{te = p+1;}
	{act = 183;}
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
		case 329: goto st87;
		case 351: goto tr80;
		case 361: goto st87;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr477;
		case 607: goto tr101;
		case 617: goto tr477;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr477:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr231;
		case 351: goto tr80;
		case 358: goto tr231;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr478;
		case 607: goto tr101;
		case 614: goto tr478;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr472:
	{te = p+1;}
	{act = 125;}
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
		case 340: goto st89;
		case 344: goto tr234;
		case 351: goto tr80;
		case 372: goto st89;
		case 376: goto tr234;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr479;
		case 600: goto tr480;
		case 607: goto tr101;
		case 628: goto tr479;
		case 632: goto tr480;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr232;
tr479:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto st90;
		case 351: goto tr80;
		case 357: goto st90;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr481;
		case 607: goto tr101;
		case 613: goto tr481;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr481:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto st91;
		case 351: goto tr80;
		case 370: goto st91;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr482;
		case 607: goto tr101;
		case 626: goto tr482;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr482:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto tr237;
		case 351: goto tr80;
		case 366: goto tr237;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr483;
		case 607: goto tr101;
		case 622: goto tr483;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr100:
	{te = p+1;}
	{act = 55;}
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
		case 336: goto st93;
		case 351: goto tr80;
		case 368: goto st93;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr484;
		case 607: goto tr101;
		case 624: goto tr484;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr238;
tr484:
	{te = p+1;}
	{act = 183;}
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
		case 336: goto tr240;
		case 351: goto tr80;
		case 368: goto tr240;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr485;
		case 607: goto tr101;
		case 624: goto tr485;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr102:
	{te = p+1;}
	{act = 48;}
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
		case 321: goto st95;
		case 332: goto tr243;
		case 351: goto tr80;
		case 353: goto st95;
		case 364: goto tr243;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr486;
		case 588: goto tr487;
		case 607: goto tr101;
		case 609: goto tr486;
		case 620: goto tr487;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr241;
tr486:
	{te = p+1;}
	{act = 183;}
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
		case 332: goto st96;
		case 351: goto tr80;
		case 364: goto st96;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr488;
		case 607: goto tr101;
		case 620: goto tr488;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr488:
	{te = p+1;}
	{act = 183;}
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
		case 340: goto tr245;
		case 351: goto tr80;
		case 372: goto tr245;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr489;
		case 607: goto tr101;
		case 628: goto tr489;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr103:
	{te = p+1;}
	{act = 56;}
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
		case 326: goto st98;
		case 329: goto st104;
		case 333: goto tr249;
		case 334: goto st105;
		case 344: goto st115;
		case 345: goto st116;
		case 351: goto tr80;
		case 358: goto st98;
		case 361: goto st104;
		case 365: goto tr249;
		case 366: goto st105;
		case 376: goto st115;
		case 377: goto st116;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr490;
		case 585: goto tr491;
		case 589: goto tr492;
		case 590: goto tr493;
		case 600: goto tr494;
		case 601: goto tr495;
		case 607: goto tr101;
		case 614: goto tr490;
		case 617: goto tr491;
		case 621: goto tr492;
		case 622: goto tr493;
		case 632: goto tr494;
		case 633: goto tr495;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr246;
tr490:
	{te = p+1;}
	{act = 88;}
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
		case 324: goto st99;
		case 334: goto st101;
		case 351: goto tr80;
		case 356: goto st99;
		case 366: goto st101;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr496;
		case 590: goto tr497;
		case 607: goto tr101;
		case 612: goto tr496;
		case 622: goto tr497;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr253;
tr496:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto st100;
		case 351: goto tr80;
		case 357: goto st100;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr498;
		case 607: goto tr101;
		case 613: goto tr498;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr498:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr257;
		case 351: goto tr80;
		case 358: goto tr257;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr499;
		case 607: goto tr101;
		case 614: goto tr499;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr497:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st102;
		case 351: goto tr80;
		case 356: goto st102;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr500;
		case 607: goto tr101;
		case 612: goto tr500;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr500:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto st103;
		case 351: goto tr80;
		case 357: goto st103;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr501;
		case 607: goto tr101;
		case 613: goto tr501;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr501:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr260;
		case 351: goto tr80;
		case 358: goto tr260;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr502;
		case 607: goto tr101;
		case 614: goto tr502;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr491:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto tr261;
		case 351: goto tr80;
		case 370: goto tr261;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr503;
		case 607: goto tr101;
		case 626: goto tr503;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr493:
	{te = p+1;}
	{act = 129;}
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
		case 323: goto st106;
		case 324: goto st110;
		case 329: goto st111;
		case 342: goto st112;
		case 351: goto tr80;
		case 355: goto st106;
		case 356: goto st110;
		case 361: goto st111;
		case 374: goto st112;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr504;
		case 580: goto tr505;
		case 585: goto tr506;
		case 598: goto tr507;
		case 607: goto tr101;
		case 611: goto tr504;
		case 612: goto tr505;
		case 617: goto tr506;
		case 630: goto tr507;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr262;
tr504:
	{te = p+1;}
	{act = 130;}
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
		case 332: goto st107;
		case 351: goto tr80;
		case 364: goto st107;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr508;
		case 607: goto tr101;
		case 620: goto tr508;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr267;
tr508:
	{te = p+1;}
	{act = 183;}
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
		case 341: goto st108;
		case 351: goto tr80;
		case 373: goto st108;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 597: goto tr509;
		case 607: goto tr101;
		case 629: goto tr509;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr509:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st109;
		case 351: goto tr80;
		case 356: goto st109;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr510;
		case 607: goto tr101;
		case 612: goto tr510;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr510:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr271;
		case 351: goto tr80;
		case 357: goto tr271;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr511;
		case 607: goto tr101;
		case 613: goto tr511;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr505:
	{te = p+1;}
	{act = 131;}
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
		case 338: goto tr273;
		case 351: goto tr80;
		case 370: goto tr273;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr512;
		case 607: goto tr101;
		case 626: goto tr512;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr272;
tr506:
	{te = p+1;}
	{act = 133;}
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
		case 338: goto tr275;
		case 351: goto tr80;
		case 370: goto tr275;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr513;
		case 607: goto tr101;
		case 626: goto tr513;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr274;
tr507:
	{te = p+1;}
	{act = 183;}
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
		case 335: goto st113;
		case 351: goto tr80;
		case 367: goto st113;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr514;
		case 607: goto tr101;
		case 623: goto tr514;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr514:
	{te = p+1;}
	{act = 183;}
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
		case 331: goto st114;
		case 351: goto tr80;
		case 363: goto st114;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 587: goto tr515;
		case 607: goto tr101;
		case 619: goto tr515;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr515:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr278;
		case 351: goto tr80;
		case 357: goto tr278;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr516;
		case 607: goto tr101;
		case 613: goto tr516;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr494:
	{te = p+1;}
	{act = 64;}
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
		case 328: goto tr280;
		case 332: goto tr281;
		case 351: goto tr80;
		case 360: goto tr280;
		case 364: goto tr281;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 584: goto tr517;
		case 588: goto tr518;
		case 607: goto tr101;
		case 616: goto tr517;
		case 620: goto tr518;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr279;
tr495:
	{te = p+1;}
	{act = 65;}
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
		case 328: goto tr283;
		case 332: goto tr284;
		case 351: goto tr80;
		case 360: goto tr283;
		case 364: goto tr284;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 584: goto tr519;
		case 588: goto tr520;
		case 607: goto tr101;
		case 616: goto tr519;
		case 620: goto tr520;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr282;
tr104:
	{te = p+1;}
	{act = 183;}
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
		case 336: goto tr285;
		case 338: goto tr286;
		case 351: goto tr80;
		case 368: goto tr285;
		case 370: goto tr286;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr521;
		case 594: goto tr522;
		case 607: goto tr101;
		case 624: goto tr521;
		case 626: goto tr522;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr105:
	{te = p+1;}
	{act = 51;}
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
		case 324: goto st119;
		case 329: goto st122;
		case 339: goto st124;
		case 351: goto tr80;
		case 356: goto st119;
		case 361: goto st122;
		case 371: goto st124;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr523;
		case 585: goto tr524;
		case 595: goto tr525;
		case 607: goto tr101;
		case 612: goto tr523;
		case 617: goto tr524;
		case 627: goto tr525;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr287;
tr523:
	{te = p+1;}
	{act = 137;}
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
		case 324: goto st120;
		case 329: goto st121;
		case 351: goto tr80;
		case 356: goto st120;
		case 361: goto st121;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr526;
		case 585: goto tr527;
		case 607: goto tr101;
		case 612: goto tr526;
		case 617: goto tr527;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr291;
tr526:
	{te = p+1;}
	{act = 138;}
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
		case 338: goto tr295;
		case 351: goto tr80;
		case 370: goto tr295;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr528;
		case 607: goto tr101;
		case 626: goto tr528;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr294;
tr527:
	{te = p+1;}
	{act = 140;}
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
		case 338: goto tr297;
		case 351: goto tr80;
		case 370: goto tr297;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr529;
		case 607: goto tr101;
		case 626: goto tr529;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr296;
tr524:
	{te = p+1;}
	{act = 183;}
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
		case 322: goto tr298;
		case 334: goto st123;
		case 351: goto tr80;
		case 354: goto tr298;
		case 366: goto st123;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr530;
		case 590: goto tr531;
		case 607: goto tr101;
		case 610: goto tr530;
		case 622: goto tr531;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr531:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr300;
		case 351: goto tr80;
		case 357: goto tr300;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr532;
		case 607: goto tr101;
		case 613: goto tr532;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr525:
	{te = p+1;}
	{act = 183;}
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
		case 340: goto st125;
		case 351: goto tr80;
		case 372: goto st125;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr533;
		case 607: goto tr101;
		case 628: goto tr533;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr533:
	{te = p+1;}
	{act = 183;}
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
		case 335: goto st126;
		case 351: goto tr80;
		case 367: goto st126;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr534;
		case 607: goto tr101;
		case 623: goto tr534;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr534:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto st127;
		case 334: goto tr304;
		case 351: goto tr80;
		case 358: goto st127;
		case 366: goto tr304;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr535;
		case 590: goto tr536;
		case 607: goto tr101;
		case 614: goto tr535;
		case 622: goto tr536;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr535:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr305;
		case 351: goto tr80;
		case 358: goto tr305;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr537;
		case 607: goto tr101;
		case 614: goto tr537;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr106:
	{te = p+1;}
	{act = 44;}
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
		case 335: goto st129;
		case 351: goto tr80;
		case 367: goto st129;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr538;
		case 607: goto tr101;
		case 623: goto tr538;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr306;
tr538:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st130;
		case 351: goto tr80;
		case 356: goto st130;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr539;
		case 607: goto tr101;
		case 612: goto tr539;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr539:
	{te = p+1;}
	{act = 183;}
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
		case 341: goto st131;
		case 351: goto tr80;
		case 373: goto st131;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 597: goto tr540;
		case 607: goto tr101;
		case 629: goto tr540;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr540:
	{te = p+1;}
	{act = 183;}
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
		case 332: goto st132;
		case 351: goto tr80;
		case 364: goto st132;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr541;
		case 607: goto tr101;
		case 620: goto tr541;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr541:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr311;
		case 351: goto tr80;
		case 357: goto tr311;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr542;
		case 607: goto tr101;
		case 613: goto tr542;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr107:
	{te = p+1;}
	{act = 183;}
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
		case 323: goto tr312;
		case 325: goto st134;
		case 335: goto st135;
		case 346: goto tr315;
		case 351: goto tr80;
		case 355: goto tr312;
		case 357: goto st134;
		case 367: goto st135;
		case 378: goto tr315;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr543;
		case 581: goto tr544;
		case 591: goto tr545;
		case 602: goto tr546;
		case 607: goto tr101;
		case 611: goto tr543;
		case 613: goto tr544;
		case 623: goto tr545;
		case 634: goto tr546;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr544:
	{te = p+1;}
	{act = 183;}
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
		case 327: goto tr316;
		case 351: goto tr80;
		case 359: goto tr316;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 583: goto tr547;
		case 607: goto tr101;
		case 615: goto tr547;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr545:
	{te = p+1;}
	{act = 183;}
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
		case 336: goto tr317;
		case 351: goto tr80;
		case 368: goto tr317;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr548;
		case 607: goto tr101;
		case 624: goto tr548;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr108:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto st137;
		case 340: goto st138;
		case 341: goto st141;
		case 346: goto tr321;
		case 351: goto tr80;
		case 370: goto st137;
		case 372: goto st138;
		case 373: goto st141;
		case 378: goto tr321;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr549;
		case 596: goto tr550;
		case 597: goto tr551;
		case 602: goto tr552;
		case 607: goto tr101;
		case 626: goto tr549;
		case 628: goto tr550;
		case 629: goto tr551;
		case 634: goto tr552;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 345 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr549:
	{te = p+1;}
	{act = 144;}
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
		case 327: goto tr323;
		case 351: goto tr80;
		case 359: goto tr323;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 583: goto tr553;
		case 607: goto tr101;
		case 615: goto tr553;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr322;
tr550:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st139;
		case 329: goto st140;
		case 351: goto tr80;
		case 356: goto st139;
		case 361: goto st140;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr554;
		case 585: goto tr555;
		case 607: goto tr101;
		case 612: goto tr554;
		case 617: goto tr555;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr554:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto tr326;
		case 351: goto tr80;
		case 370: goto tr326;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr556;
		case 607: goto tr101;
		case 626: goto tr556;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr555:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto tr327;
		case 351: goto tr80;
		case 370: goto tr327;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr557;
		case 607: goto tr101;
		case 626: goto tr557;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr551:
	{te = p+1;}
	{act = 183;}
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
		case 340: goto st142;
		case 351: goto tr80;
		case 372: goto st142;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr558;
		case 607: goto tr101;
		case 628: goto tr558;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr558:
	{te = p+1;}
	{act = 147;}
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
		case 324: goto tr330;
		case 329: goto tr331;
		case 351: goto tr80;
		case 356: goto tr330;
		case 361: goto tr331;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr559;
		case 585: goto tr560;
		case 607: goto tr101;
		case 612: goto tr559;
		case 617: goto tr560;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr329;
tr109:
	{te = p+1;}
	{act = 43;}
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
		case 325: goto tr333;
		case 335: goto st144;
		case 341: goto st145;
		case 351: goto tr80;
		case 357: goto tr333;
		case 367: goto st144;
		case 373: goto st145;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr561;
		case 591: goto tr562;
		case 597: goto tr563;
		case 607: goto tr101;
		case 613: goto tr561;
		case 623: goto tr562;
		case 629: goto tr563;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr332;
tr562:
	{te = p+1;}
	{act = 41;}
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
		case 336: goto tr337;
		case 351: goto tr80;
		case 368: goto tr337;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 592: goto tr564;
		case 607: goto tr101;
		case 624: goto tr564;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr336;
tr563:
	{te = p+1;}
	{act = 183;}
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
		case 322: goto st146;
		case 339: goto st149;
		case 351: goto tr80;
		case 354: goto st146;
		case 371: goto st149;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr565;
		case 595: goto tr566;
		case 607: goto tr101;
		case 610: goto tr565;
		case 627: goto tr566;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr565:
	{te = p+1;}
	{act = 183;}
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
		case 332: goto st147;
		case 351: goto tr80;
		case 364: goto st147;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 588: goto tr567;
		case 607: goto tr101;
		case 620: goto tr567;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr567:
	{te = p+1;}
	{act = 183;}
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
		case 329: goto st148;
		case 351: goto tr80;
		case 361: goto st148;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr568;
		case 607: goto tr101;
		case 617: goto tr568;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr568:
	{te = p+1;}
	{act = 183;}
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
		case 323: goto tr342;
		case 351: goto tr80;
		case 355: goto tr342;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr569;
		case 607: goto tr101;
		case 611: goto tr569;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr566:
	{te = p+1;}
	{act = 183;}
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
		case 328: goto tr343;
		case 351: goto tr80;
		case 360: goto tr343;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 584: goto tr570;
		case 607: goto tr101;
		case 616: goto tr570;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr110:
	{te = p+1;}
	{act = 58;}
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
		case 325: goto st151;
		case 332: goto st153;
		case 338: goto st155;
		case 339: goto st157;
		case 351: goto tr80;
		case 357: goto st151;
		case 364: goto st153;
		case 370: goto st155;
		case 371: goto st157;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr571;
		case 588: goto tr572;
		case 594: goto tr573;
		case 595: goto tr574;
		case 607: goto tr101;
		case 613: goto tr571;
		case 620: goto tr572;
		case 626: goto tr573;
		case 627: goto tr574;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr344;
tr571:
	{te = p+1;}
	{act = 183;}
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
		case 339: goto tr349;
		case 340: goto st152;
		case 351: goto tr80;
		case 371: goto tr349;
		case 372: goto st152;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 595: goto tr575;
		case 596: goto tr576;
		case 607: goto tr101;
		case 627: goto tr575;
		case 628: goto tr576;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr576:
	{te = p+1;}
	{act = 153;}
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
		case 329: goto tr352;
		case 334: goto tr353;
		case 351: goto tr80;
		case 361: goto tr352;
		case 366: goto tr353;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr577;
		case 590: goto tr578;
		case 607: goto tr101;
		case 617: goto tr577;
		case 622: goto tr578;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr351;
tr572:
	{te = p+1;}
	{act = 156;}
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
		case 321: goto tr355;
		case 323: goto st154;
		case 324: goto tr357;
		case 351: goto tr80;
		case 353: goto tr355;
		case 355: goto st154;
		case 356: goto tr357;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr579;
		case 579: goto tr580;
		case 580: goto tr581;
		case 607: goto tr101;
		case 609: goto tr579;
		case 611: goto tr580;
		case 612: goto tr581;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr354;
tr580:
	{te = p+1;}
	{act = 158;}
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
		case 321: goto tr359;
		case 351: goto tr80;
		case 353: goto tr359;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr582;
		case 607: goto tr101;
		case 609: goto tr582;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr358;
tr573:
	{te = p+1;}
	{act = 161;}
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
		case 321: goto tr361;
		case 323: goto st156;
		case 324: goto tr363;
		case 351: goto tr80;
		case 353: goto tr361;
		case 355: goto st156;
		case 356: goto tr363;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr583;
		case 579: goto tr584;
		case 580: goto tr585;
		case 607: goto tr101;
		case 609: goto tr583;
		case 611: goto tr584;
		case 612: goto tr585;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr360;
tr584:
	{te = p+1;}
	{act = 163;}
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
		case 321: goto tr365;
		case 351: goto tr80;
		case 353: goto tr365;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr586;
		case 607: goto tr101;
		case 609: goto tr586;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr364;
tr574:
	{te = p+1;}
	{act = 183;}
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
		case 340: goto tr366;
		case 351: goto tr80;
		case 372: goto tr366;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr587;
		case 607: goto tr101;
		case 628: goto tr587;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr111:
	{te = p+1;}
	{act = 183;}
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
		case 322: goto st159;
		case 323: goto st160;
		case 325: goto st161;
		case 332: goto st166;
		case 336: goto tr371;
		case 338: goto st167;
		case 341: goto st168;
		case 351: goto tr80;
		case 354: goto st159;
		case 355: goto st160;
		case 357: goto st161;
		case 364: goto st166;
		case 368: goto tr371;
		case 370: goto st167;
		case 373: goto st168;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr588;
		case 579: goto tr589;
		case 581: goto tr590;
		case 588: goto tr591;
		case 592: goto tr592;
		case 594: goto tr593;
		case 597: goto tr594;
		case 607: goto tr101;
		case 610: goto tr588;
		case 611: goto tr589;
		case 613: goto tr590;
		case 620: goto tr591;
		case 624: goto tr592;
		case 626: goto tr593;
		case 629: goto tr594;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr588:
	{te = p+1;}
	{act = 183;}
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
		case 323: goto tr374;
		case 351: goto tr80;
		case 355: goto tr374;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr595;
		case 607: goto tr101;
		case 611: goto tr595;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr589:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr375;
		case 351: goto tr80;
		case 358: goto tr375;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr596;
		case 607: goto tr101;
		case 614: goto tr596;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr590:
	{te = p+1;}
	{act = 183;}
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
		case 323: goto st162;
		case 340: goto tr377;
		case 351: goto tr80;
		case 355: goto st162;
		case 372: goto tr377;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 579: goto tr597;
		case 596: goto tr598;
		case 607: goto tr101;
		case 611: goto tr597;
		case 628: goto tr598;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr597:
	{te = p+1;}
	{act = 183;}
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
		case 340: goto st163;
		case 351: goto tr80;
		case 372: goto st163;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 596: goto tr599;
		case 607: goto tr101;
		case 628: goto tr599;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr599:
	{te = p+1;}
	{act = 183;}
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
		case 329: goto st164;
		case 351: goto tr80;
		case 361: goto st164;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr600;
		case 607: goto tr101;
		case 617: goto tr600;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr600:
	{te = p+1;}
	{act = 183;}
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
		case 335: goto st165;
		case 351: goto tr80;
		case 367: goto st165;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 591: goto tr601;
		case 607: goto tr101;
		case 623: goto tr601;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr601:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto tr381;
		case 351: goto tr80;
		case 366: goto tr381;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr602;
		case 607: goto tr101;
		case 622: goto tr602;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr591:
	{te = p+1;}
	{act = 183;}
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
		case 321: goto tr382;
		case 332: goto tr383;
		case 351: goto tr80;
		case 353: goto tr382;
		case 364: goto tr383;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr603;
		case 588: goto tr604;
		case 607: goto tr101;
		case 609: goto tr603;
		case 620: goto tr604;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr593:
	{te = p+1;}
	{act = 183;}
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
		case 321: goto tr384;
		case 332: goto tr385;
		case 351: goto tr80;
		case 353: goto tr384;
		case 364: goto tr385;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 577: goto tr605;
		case 588: goto tr606;
		case 607: goto tr101;
		case 609: goto tr605;
		case 620: goto tr606;
	}
	if ( _widec < 354 ) {
		if ( _widec > 313 ) {
			if ( 322 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr594:
	{te = p+1;}
	{act = 183;}
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
		case 322: goto tr386;
		case 351: goto tr80;
		case 354: goto tr386;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr607;
		case 607: goto tr101;
		case 610: goto tr607;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr112:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto st170;
		case 351: goto tr80;
		case 366: goto st170;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr608;
		case 607: goto tr101;
		case 622: goto tr608;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr608:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st171;
		case 351: goto tr80;
		case 356: goto st171;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr609;
		case 607: goto tr101;
		case 612: goto tr609;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr609:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto st172;
		case 351: goto tr80;
		case 357: goto st172;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr610;
		case 607: goto tr101;
		case 613: goto tr610;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr610:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto st173;
		case 351: goto tr80;
		case 358: goto st173;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr611;
		case 607: goto tr101;
		case 614: goto tr611;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr611:
	{te = p+1;}
	{act = 183;}
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
		case 329: goto st174;
		case 351: goto tr80;
		case 361: goto st174;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr612;
		case 607: goto tr101;
		case 617: goto tr612;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr612:
	{te = p+1;}
	{act = 183;}
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
		case 334: goto st175;
		case 351: goto tr80;
		case 366: goto st175;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 590: goto tr613;
		case 607: goto tr101;
		case 622: goto tr613;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr613:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto tr393;
		case 351: goto tr80;
		case 357: goto tr393;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr614;
		case 607: goto tr101;
		case 613: goto tr614;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr113:
	{te = p+1;}
	{act = 183;}
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
		case 324: goto st177;
		case 332: goto st179;
		case 335: goto st181;
		case 338: goto st182;
		case 351: goto tr80;
		case 356: goto st177;
		case 364: goto st179;
		case 367: goto st181;
		case 370: goto st182;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 580: goto tr615;
		case 588: goto tr616;
		case 591: goto tr617;
		case 594: goto tr618;
		case 607: goto tr101;
		case 612: goto tr615;
		case 620: goto tr616;
		case 623: goto tr617;
		case 626: goto tr618;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr615:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto st178;
		case 351: goto tr80;
		case 357: goto st178;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr619;
		case 607: goto tr101;
		case 613: goto tr619;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr619:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr399;
		case 351: goto tr80;
		case 358: goto tr399;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr620;
		case 607: goto tr101;
		case 614: goto tr620;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr616:
	{te = p+1;}
	{act = 183;}
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
		case 329: goto st180;
		case 351: goto tr80;
		case 361: goto st180;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 585: goto tr621;
		case 607: goto tr101;
		case 617: goto tr621;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr621:
	{te = p+1;}
	{act = 183;}
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
		case 322: goto tr401;
		case 351: goto tr80;
		case 354: goto tr401;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 578: goto tr622;
		case 607: goto tr101;
		case 610: goto tr622;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr617:
	{te = p+1;}
	{act = 183;}
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
		case 338: goto tr402;
		case 351: goto tr80;
		case 370: goto tr402;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 594: goto tr623;
		case 607: goto tr101;
		case 626: goto tr623;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr618:
	{te = p+1;}
	{act = 183;}
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
		case 325: goto st183;
		case 351: goto tr80;
		case 357: goto st183;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 581: goto tr624;
		case 607: goto tr101;
		case 613: goto tr624;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
tr624:
	{te = p+1;}
	{act = 183;}
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
		case 326: goto tr404;
		case 351: goto tr80;
		case 358: goto tr404;
		case 521: goto st20;
		case 544: goto st20;
		case 570: goto tr37;
		case 582: goto tr625;
		case 607: goto tr101;
		case 614: goto tr625;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr80;
		} else if ( _widec >= 304 )
			goto tr80;
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
		goto tr80;
	goto tr150;
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
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof185: cs = 185; goto _test_eof; 
	_test_eof186: cs = 186; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
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
	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 22: goto tr115;
	case 23: goto tr0;
	case 24: goto tr0;
	case 1: goto tr0;
	case 2: goto tr0;
	case 25: goto tr120;
	case 26: goto tr121;
	case 27: goto tr123;
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
	case 28: goto tr124;
	case 29: goto tr126;
	case 30: goto tr126;
	case 31: goto tr126;
	case 16: goto tr0;
	case 32: goto tr130;
	case 33: goto tr0;
	case 17: goto tr26;
	case 34: goto tr132;
	case 35: goto tr133;
	case 36: goto tr134;
	case 37: goto tr138;
	case 38: goto tr140;
	case 39: goto tr143;
	case 40: goto tr145;
	case 41: goto tr0;
	case 42: goto tr150;
	case 43: goto tr153;
	case 44: goto tr150;
	case 45: goto tr150;
	case 46: goto tr150;
	case 47: goto tr150;
	case 48: goto tr159;
	case 49: goto tr150;
	case 50: goto tr150;
	case 51: goto tr150;
	case 52: goto tr150;
	case 53: goto tr167;
	case 54: goto tr150;
	case 55: goto tr150;
	case 56: goto tr173;
	case 57: goto tr150;
	case 58: goto tr150;
	case 59: goto tr150;
	case 60: goto tr150;
	case 61: goto tr150;
	case 62: goto tr181;
	case 63: goto tr185;
	case 64: goto tr187;
	case 65: goto tr189;
	case 66: goto tr150;
	case 67: goto tr196;
	case 68: goto tr150;
	case 69: goto tr150;
	case 70: goto tr150;
	case 71: goto tr150;
	case 72: goto tr150;
	case 73: goto tr150;
	case 74: goto tr150;
	case 75: goto tr150;
	case 76: goto tr150;
	case 77: goto tr150;
	case 78: goto tr150;
	case 79: goto tr150;
	case 80: goto tr150;
	case 18: goto tr28;
	case 81: goto tr220;
	case 82: goto tr225;
	case 83: goto tr150;
	case 84: goto tr150;
	case 85: goto tr150;
	case 86: goto tr150;
	case 87: goto tr150;
	case 88: goto tr232;
	case 89: goto tr150;
	case 90: goto tr150;
	case 91: goto tr150;
	case 92: goto tr238;
	case 93: goto tr150;
	case 94: goto tr241;
	case 95: goto tr150;
	case 96: goto tr150;
	case 97: goto tr246;
	case 98: goto tr253;
	case 99: goto tr150;
	case 100: goto tr150;
	case 101: goto tr150;
	case 102: goto tr150;
	case 103: goto tr150;
	case 104: goto tr150;
	case 105: goto tr262;
	case 106: goto tr267;
	case 107: goto tr150;
	case 108: goto tr150;
	case 109: goto tr150;
	case 110: goto tr272;
	case 111: goto tr274;
	case 112: goto tr150;
	case 113: goto tr150;
	case 114: goto tr150;
	case 115: goto tr279;
	case 116: goto tr282;
	case 117: goto tr150;
	case 118: goto tr287;
	case 119: goto tr291;
	case 120: goto tr294;
	case 121: goto tr296;
	case 122: goto tr150;
	case 123: goto tr150;
	case 124: goto tr150;
	case 125: goto tr150;
	case 126: goto tr150;
	case 127: goto tr150;
	case 128: goto tr306;
	case 129: goto tr150;
	case 130: goto tr150;
	case 131: goto tr150;
	case 132: goto tr150;
	case 133: goto tr150;
	case 134: goto tr150;
	case 135: goto tr150;
	case 136: goto tr150;
	case 137: goto tr322;
	case 138: goto tr150;
	case 139: goto tr150;
	case 140: goto tr150;
	case 141: goto tr150;
	case 142: goto tr329;
	case 143: goto tr332;
	case 144: goto tr336;
	case 145: goto tr150;
	case 146: goto tr150;
	case 147: goto tr150;
	case 148: goto tr150;
	case 149: goto tr150;
	case 150: goto tr344;
	case 151: goto tr150;
	case 152: goto tr351;
	case 153: goto tr354;
	case 154: goto tr358;
	case 155: goto tr360;
	case 156: goto tr364;
	case 157: goto tr150;
	case 158: goto tr150;
	case 159: goto tr150;
	case 160: goto tr150;
	case 161: goto tr150;
	case 162: goto tr150;
	case 163: goto tr150;
	case 164: goto tr150;
	case 165: goto tr150;
	case 166: goto tr150;
	case 167: goto tr150;
	case 168: goto tr150;
	case 169: goto tr150;
	case 170: goto tr150;
	case 171: goto tr150;
	case 172: goto tr150;
	case 173: goto tr150;
	case 174: goto tr150;
	case 175: goto tr150;
	case 176: goto tr150;
	case 177: goto tr150;
	case 178: goto tr150;
	case 179: goto tr150;
	case 180: goto tr150;
	case 181: goto tr150;
	case 182: goto tr150;
	case 183: goto tr150;
	case 184: goto tr405;
	case 19: goto tr33;
	case 185: goto tr406;
	case 186: goto tr145;
	case 20: goto tr0;
	case 187: goto tr0;
	case 188: goto tr150;
	case 189: goto tr153;
	case 190: goto tr150;
	case 191: goto tr150;
	case 192: goto tr150;
	case 193: goto tr150;
	case 194: goto tr159;
	case 195: goto tr150;
	case 196: goto tr150;
	case 197: goto tr150;
	case 198: goto tr150;
	case 199: goto tr167;
	case 200: goto tr150;
	case 201: goto tr150;
	case 202: goto tr173;
	case 203: goto tr150;
	case 204: goto tr150;
	case 205: goto tr150;
	case 206: goto tr150;
	case 207: goto tr150;
	case 208: goto tr181;
	case 209: goto tr185;
	case 210: goto tr187;
	case 211: goto tr189;
	case 212: goto tr150;
	case 213: goto tr196;
	case 214: goto tr150;
	case 215: goto tr150;
	case 216: goto tr150;
	case 217: goto tr150;
	case 218: goto tr150;
	case 219: goto tr150;
	case 220: goto tr150;
	case 221: goto tr150;
	case 222: goto tr150;
	case 223: goto tr150;
	case 224: goto tr150;
	case 225: goto tr150;
	case 226: goto tr150;
	case 227: goto tr220;
	case 228: goto tr225;
	case 229: goto tr150;
	case 230: goto tr150;
	case 231: goto tr150;
	case 232: goto tr150;
	case 233: goto tr150;
	case 234: goto tr232;
	case 235: goto tr150;
	case 236: goto tr150;
	case 237: goto tr150;
	case 238: goto tr238;
	case 239: goto tr150;
	case 240: goto tr241;
	case 241: goto tr150;
	case 242: goto tr150;
	case 243: goto tr246;
	case 244: goto tr253;
	case 245: goto tr150;
	case 246: goto tr150;
	case 247: goto tr150;
	case 248: goto tr150;
	case 249: goto tr150;
	case 250: goto tr150;
	case 251: goto tr262;
	case 252: goto tr267;
	case 253: goto tr150;
	case 254: goto tr150;
	case 255: goto tr150;
	case 256: goto tr272;
	case 257: goto tr274;
	case 258: goto tr150;
	case 259: goto tr150;
	case 260: goto tr150;
	case 261: goto tr279;
	case 262: goto tr282;
	case 263: goto tr150;
	case 264: goto tr287;
	case 265: goto tr291;
	case 266: goto tr294;
	case 267: goto tr296;
	case 268: goto tr150;
	case 269: goto tr150;
	case 270: goto tr150;
	case 271: goto tr150;
	case 272: goto tr150;
	case 273: goto tr150;
	case 274: goto tr306;
	case 275: goto tr150;
	case 276: goto tr150;
	case 277: goto tr150;
	case 278: goto tr150;
	case 279: goto tr150;
	case 280: goto tr150;
	case 281: goto tr150;
	case 282: goto tr150;
	case 283: goto tr322;
	case 284: goto tr150;
	case 285: goto tr150;
	case 286: goto tr150;
	case 287: goto tr150;
	case 288: goto tr329;
	case 289: goto tr332;
	case 290: goto tr336;
	case 291: goto tr150;
	case 292: goto tr150;
	case 293: goto tr150;
	case 294: goto tr150;
	case 295: goto tr150;
	case 296: goto tr344;
	case 297: goto tr150;
	case 298: goto tr351;
	case 299: goto tr354;
	case 300: goto tr358;
	case 301: goto tr360;
	case 302: goto tr364;
	case 303: goto tr150;
	case 304: goto tr150;
	case 305: goto tr150;
	case 306: goto tr150;
	case 307: goto tr150;
	case 308: goto tr150;
	case 309: goto tr150;
	case 310: goto tr150;
	case 311: goto tr150;
	case 312: goto tr150;
	case 313: goto tr150;
	case 314: goto tr150;
	case 315: goto tr150;
	case 316: goto tr150;
	case 317: goto tr150;
	case 318: goto tr150;
	case 319: goto tr150;
	case 320: goto tr150;
	case 321: goto tr150;
	case 322: goto tr150;
	case 323: goto tr150;
	case 324: goto tr150;
	case 325: goto tr150;
	case 326: goto tr150;
	case 327: goto tr150;
	case 328: goto tr150;
	case 329: goto tr150;
	}
	}
	_out: {}
	}
 return sym.tok;
}
