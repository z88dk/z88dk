











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

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    sym.tok = TK_LPAREN;
                    sym.text = "(";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr9:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_BC;
                    sym.text = "(BC)";
                    sym.cpu_ind_reg16 = IND_REG16_BC;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr10:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_C;
                    sym.text = "(C)";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr12:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_DE;
                    sym.text = "(DE)";
                    sym.cpu_ind_reg16 = IND_REG16_DE;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr14:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_HL;
                    sym.text = "(HL)";
                    sym.cpu_ind_reg16 = IND_REG16_HL;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr17:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_IX;
                    sym.text = "(IX";
                    p--;
                    te--;
                    sym.cpu_ind_reg16 = IND_REG16_HL;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr18:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_IY;
                    sym.text = "(IY";
                    p--;
                    te--;
                    sym.cpu_ind_reg16 = IND_REG16_HL;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr20:

            {
                te = p + 1;
                {
                    sym.tok = TK_IND_SP;
                    sym.text = "(SP)";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr21:

            {
                switch ( act )
                {
                case 1:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_ASMPC;
                    sym.text = "ASMPC";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 37:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NZ;
                    sym.text = "NZ";
                    sym.cpu_flag = FLAG_NZ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 38:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_Z;
                    sym.text = "Z";
                    sym.cpu_flag = FLAG_Z;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 39:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NC;
                    sym.text = "NC";
                    sym.cpu_flag = FLAG_NC;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 40:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_C;
                    sym.text = "C";
                    sym.cpu_flag = FLAG_C;
                    sym.cpu_reg8 = REG8_C;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 41:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_PO;
                    sym.text = "PO";
                    sym.cpu_flag = FLAG_PO;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 42:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_PE;
                    sym.text = "PE";
                    sym.cpu_flag = FLAG_PE;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 43:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_P;
                    sym.text = "P";
                    sym.cpu_flag = FLAG_P;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 44:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_M;
                    sym.text = "M";
                    sym.cpu_flag = FLAG_M;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 45:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_B;
                    sym.text = "B";
                    sym.cpu_reg8 = REG8_B;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 46:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_D;
                    sym.text = "D";
                    sym.cpu_reg8 = REG8_D;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 47:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_E;
                    sym.text = "E";
                    sym.cpu_reg8 = REG8_E;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 48:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_H;
                    sym.text = "H";
                    sym.cpu_reg8 = REG8_H;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 49:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IXH;
                    sym.text = "IXH";
                    sym.cpu_reg8 = REG8_H;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 50:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IYH;
                    sym.text = "IYH";
                    sym.cpu_reg8 = REG8_H;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 51:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_L;
                    sym.text = "L";
                    sym.cpu_reg8 = REG8_L;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 52:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IXL;
                    sym.text = "IXL";
                    sym.cpu_reg8 = REG8_L;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 53:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IYL;
                    sym.text = "IYL";
                    sym.cpu_reg8 = REG8_L;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 54:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_A;
                    sym.text = "A";
                    sym.cpu_reg8 = REG8_A;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 55:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_F;
                    sym.text = "F";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 56:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_I;
                    sym.text = "I";

                    if ( opts.cpu & CPU_RABBIT )
                    {
                        error_illegal_ident();
                    };

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 57:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IIR;
                    sym.text = "IIR";

                    if ( !( opts.cpu & CPU_RABBIT ) )
                    {
                        error_illegal_ident();
                    };

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 58:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_R;
                    sym.text = "R";

                    if ( opts.cpu & CPU_RABBIT )
                    {
                        error_illegal_ident();
                    };

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 59:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_EIR;
                    sym.text = "EIR";

                    if ( !( opts.cpu & CPU_RABBIT ) )
                    {
                        error_illegal_ident();
                    };

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 61:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_BC;
                    sym.text = "BC";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_BC;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 62:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_DE;
                    sym.text = "DE";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_DE;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 63:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_HL;
                    sym.text = "HL";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 64:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IX;
                    sym.text = "IX";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 65:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_IY;
                    sym.text = "IY";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 66:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_AF;
                    sym.text = "AF";
                    sym.cpu_reg16_af = REG16_AF;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 67:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_SP;
                    sym.text = "SP";
                    sym.cpu_reg16_sp = REG16_SP;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 79:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_CCF;
                        sym.text = "CCF";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 80:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPD;
                        sym.text = "CPD";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 81:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPDR;
                        sym.text = "CPDR";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 82:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPI;
                        sym.text = "CPI";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 83:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPIR;
                        sym.text = "CPIR";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 84:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPL;
                        sym.text = "CPL";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 85:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_DAA;
                        sym.text = "DAA";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 86:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_DI;
                        sym.text = "DI";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 87:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_DJNZ;
                        sym.text = "DJNZ";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 88:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_EI;
                        sym.text = "EI";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 89:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_EX;
                        sym.text = "EX";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 90:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_EXX;
                        sym.text = "EXX";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 91:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_HALT;
                        sym.text = "HALT";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 92:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_IM;
                        sym.text = "IM";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 93:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_IND;
                        sym.text = "IND";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 94:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_INDR;
                        sym.text = "INDR";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 95:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_INI;
                        sym.text = "INI";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 96:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_INIR;
                        sym.text = "INIR";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 97:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_JP;
                        sym.text = "JP";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 98:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_JR;
                        sym.text = "JR";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 99:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_LDD;
                        sym.text = "LDD";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 100:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_LDDR;
                        sym.text = "LDDR";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 101:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_LDI;
                        sym.text = "LDI";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 102:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_LDIR;
                        sym.text = "LDIR";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 103:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_NEG;
                        sym.text = "NEG";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 104:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_NOP;
                        sym.text = "NOP";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 105:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_OTDR;
                        sym.text = "OTDR";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 106:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_OTIR;
                        sym.text = "OTIR";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 107:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_OUTD;
                        sym.text = "OUTD";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 108:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_OUTI;
                        sym.text = "OUTI";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 109:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_RET;
                        sym.text = "RET";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 110:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_RETI;
                        sym.text = "RETI";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 111:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_RETN;
                        sym.text = "RETN";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 112:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_RLD;
                        sym.text = "RLD";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 113:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_RRD;
                        sym.text = "RRD";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 114:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_RST;
                        sym.text = "RST";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 115:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }

                    if ( expect_opcode )
                    {
                        sym.tok = TK_SCF;
                        sym.text = "SCF";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 118:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 120:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }




                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 122:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts + 1, te - ts - 1, 16 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 124:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 126:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts + 2, te - ts - 2, 2 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;

                case 130:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    sym.tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
                break;
                }
            }
            goto st21;
tr23:

            {
                te = p + 1;
                {
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts, te - ts - 1, 16 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr24:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {




                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr26:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    sym.tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr28:

            {
                te = p + 1;
                {
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts + 2, te - ts - 3, 2 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr29:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    sym.tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr30:

            {
                te = p + 1;
                {
                    sym.tok = TK_DS_B;
                    sym.text = "DS.B";
                    sym.ds_size = 1;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr31:

            {
                te = p + 1;
                {
                    sym.tok = TK_DS_L;
                    sym.text = "DS.L";
                    sym.ds_size = 4;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr32:

            {
                te = p + 1;
                {
                    sym.tok = TK_DS_P;
                    sym.text = "DS.P";
                    sym.ds_size = 3;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr33:

            {
                te = p + 1;
                {
                    sym.tok = TK_DS_W;
                    sym.text = "DS.W";
                    sym.ds_size = 2;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr34:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    sym.tok = TK_DOT;
                    sym.text = ".";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr38:

            {
                te = p + 1;
                {

                    while ( ts[ 0] == '.' || isspace( ts[ 0] ) ) ts++;

                    while ( te[-1] == ':' || isspace( te[-1] ) ) te--;


                    sym.tok = TK_LABEL;
                    set_tok_name();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr39:

            {
                te = p + 1;
            }
            goto st21;
tr40:

            {
                te = p + 1;
                {
                    sym.tok = TK_NEWLINE;
                    sym.text = "\n";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr42:

            {
                te = p + 1;
                {
                    sym.tok = TK_STRING;

                    if ( ! get_sym_string() )
                    {
                        error_unclosed_string();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr43:

            {
                te = p + 1;
                {
                    sym.tok = TK_CONST_EXPR;
                    sym.text = "#";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr45:

            {
                te = p + 1;
                {
                    sym.tok = TK_MOD;
                    sym.text = "%";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr47:

            {
                te = p + 1;
                {
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

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr49:

            {
                te = p + 1;
                {
                    sym.tok = TK_RPAREN;
                    sym.text = ")";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr51:

            {
                te = p + 1;
                {
                    sym.tok = TK_PLUS;
                    sym.text = "+";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr52:

            {
                te = p + 1;
                {
                    sym.tok = TK_COMMA;
                    sym.text = ",";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr53:

            {
                te = p + 1;
                {
                    sym.tok = TK_MINUS;
                    sym.text = "-";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr54:

            {
                te = p + 1;
                {
                    sym.tok = TK_DIVIDE;
                    sym.text = "/";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr59:

            {
                te = p + 1;
                {
                    sym.tok = TK_COLON;
                    sym.text = ":";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr64:

            {
                te = p + 1;
                {
                    sym.tok = TK_QUESTION;
                    sym.text = "?";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr66:

            {
                te = p + 1;
                {
                    sym.tok = TK_LSQUARE;
                    sym.text = "[";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr67:

            {
                te = p + 1;
                {
                    sym.tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr68:

            {
                te = p + 1;
                {
                    sym.tok = TK_RSQUARE;
                    sym.text = "]";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr69:

            {
                te = p + 1;
                {
                    sym.tok = TK_BIN_XOR;
                    sym.text = "^";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr70:

            {
                te = p + 1;
                {
                    sym.tok = TK_LCURLY;
                    sym.text = "{";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr72:

            {
                te = p + 1;
                {
                    sym.tok = TK_RCURLY;
                    sym.text = "}";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr73:

            {
                te = p + 1;
                {
                    sym.tok = TK_BIN_NOT;
                    sym.text = "~";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr74:

            {
                te = p + 1;
                {
                    sym.tok = TK_DOT;
                    sym.text = ".";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr112:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_LOG_NOT;
                    sym.text = "!";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr113:

            {
                te = p + 1;
                {
                    sym.tok = TK_NOT_EQ;
                    sym.text = "!=";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr115:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_BIN_AND;
                    sym.text = "&";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr116:

            {
                te = p + 1;
                {
                    sym.tok = TK_LOG_AND;
                    sym.text = "&&";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr117:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_LPAREN;
                    sym.text = "(";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr118:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_MULTIPLY;
                    sym.text = "*";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr119:

            {
                te = p + 1;
                {
                    sym.tok = TK_POWER;
                    sym.text = "**";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr120:

            {
                te = p;
                p--;
                {




                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr124:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr126:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts + 2, te - ts - 2, 16 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr127:

            {
                te = p;
                p--;
            }
            goto st21;
tr128:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_LESS;
                    sym.text = "<";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr129:

            {
                te = p + 1;
                {
                    sym.tok = TK_LEFT_SHIFT;
                    sym.text = "<<";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr130:

            {
                te = p + 1;
                {
                    sym.tok = TK_LESS_EQ;
                    sym.text = "<=";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr131:

            {
                te = p + 1;
                {
                    sym.tok = TK_NOT_EQ;
                    sym.text = "<>";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr132:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_EQUAL;
                    sym.text = "=";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr133:

            {
                te = p + 1;
                {
                    sym.tok = TK_EQUAL;
                    sym.text = "==";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr134:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_GREATER;
                    sym.text = ">";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr135:

            {
                te = p + 1;
                {
                    sym.tok = TK_GREATER_EQ;
                    sym.text = ">=";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr136:

            {
                te = p + 1;
                {
                    sym.tok = TK_RIGHT_SHIFT;
                    sym.text = ">>";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr137:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr140:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_NUMBER;
                    sym.number = scan_num( ts + 1, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr141:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_BIN_OR;
                    sym.text = "|";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr142:

            {
                te = p + 1;
                {
                    sym.tok = TK_LOG_OR;
                    sym.text = "||";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr143:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_A;
                    sym.text = "A";
                    sym.cpu_reg8 = REG8_A;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr146:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_AF;
                    sym.text = "AF";
                    sym.cpu_reg16_af = REG16_AF;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr147:

            {
                te = p + 1;
                {
                    sym.tok = TK_AF1;
                    sym.text = "AF'";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr148:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr152:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_B;
                    sym.text = "B";
                    sym.cpu_reg8 = REG8_B;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr154:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_C;
                    sym.text = "C";
                    sym.cpu_flag = FLAG_C;
                    sym.cpu_reg8 = REG8_C;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr161:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPD;
                        sym.text = "CPD";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr163:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_CPI;
                        sym.text = "CPI";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr165:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_D;
                    sym.text = "D";
                    sym.cpu_reg8 = REG8_D;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr175:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_E;
                    sym.text = "E";
                    sym.cpu_reg8 = REG8_E;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr178:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_EI;
                        sym.text = "EI";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr180:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_EX;
                        sym.text = "EX";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr182:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_H;
                    sym.text = "H";
                    sym.cpu_reg8 = REG8_H;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr187:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_I;
                    sym.text = "I";

                    if ( opts.cpu & CPU_RABBIT )
                    {
                        error_illegal_ident();
                    };

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr196:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_IND;
                        sym.text = "IND";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr198:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_INI;
                        sym.text = "INI";

                        if ( opts.cpu & CPU_RABBIT )
                        {
                            error_illegal_ident();
                        };

                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr200:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_IX;
                    sym.text = "IX";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr203:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_IY;
                    sym.text = "IY";
                    sym.cpu_reg16_af = sym.cpu_reg16_sp = REG16_HL;
                    sym.cpu_idx_reg = opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr208:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_L;
                    sym.text = "L";
                    sym.cpu_reg8 = REG8_L;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr212:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_LDD;
                        sym.text = "LDD";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr214:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_LDI;
                        sym.text = "LDI";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr231:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_P;
                    sym.text = "P";
                    sym.cpu_flag = FLAG_P;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr234:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_R;
                    sym.text = "R";

                    if ( opts.cpu & CPU_RABBIT )
                    {
                        error_illegal_ident();
                    };

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr240:

            {
                te = p;
                p--;
                {
                    if ( expect_opcode )
                    {
                        sym.tok = TK_RET;
                        sym.text = "RET";
                        ;
                        expect_opcode = FALSE;
                    }
                    else
                    {
                        sym.tok = TK_NAME;
                        set_tok_name();
                    }

                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr249:

            {
                te = p;
                p--;
                {
                    sym.tok = TK_DOT;
                    sym.text = ".";
                    ;
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
tr250:

            {
                te = p;
                p--;
                {

                    while ( ts[ 0] == '.' || isspace( ts[ 0] ) ) ts++;

                    while ( te[-1] == ':' || isspace( te[-1] ) ) te--;


                    sym.tok = TK_LABEL;
                    set_tok_name();
                    {
                        p++;
                        cs = 21;
                        goto _out;
                    }
                }
            }
            goto st21;
st21:

            {
                ts = 0;
            }

            if ( ++p == pe )
                goto _test_eof21;

        case 21:

        {
            ts = p;
        }

        _widec = ( *p );

        if ( ( *p ) < 65 )
        {
            if ( 46 <= ( *p ) && ( *p ) <= 46 )
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }
        }
        else if ( ( *p ) > 90 )
        {
            if ( ( *p ) > 95 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) >= 95 )
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }
        }
        else
        {
            _widec = ( short )( 128 + ( ( *p ) - -128 ) );

            if (

                at_bol ) _widec += 256;
        }

        switch ( _widec )
        {
        case 10:
            goto tr40;

        case 33:
            goto st22;

        case 34:
            goto tr42;

        case 35:
            goto tr43;

        case 36:
            goto tr44;

        case 37:
            goto tr45;

        case 38:
            goto st24;

        case 39:
            goto tr47;

        case 40:
            goto tr48;

        case 41:
            goto tr49;

        case 42:
            goto st26;

        case 43:
            goto tr51;

        case 44:
            goto tr52;

        case 45:
            goto tr53;

        case 47:
            goto tr54;

        case 48:
            goto tr56;

        case 49:
            goto tr57;

        case 58:
            goto tr59;

        case 59:
            goto st33;

        case 60:
            goto st34;

        case 61:
            goto st35;

        case 62:
            goto st36;

        case 63:
            goto tr64;

        case 64:
            goto tr65;

        case 91:
            goto tr66;

        case 92:
            goto tr67;

        case 93:
            goto tr68;

        case 94:
            goto tr69;

        case 96:
            goto tr67;

        case 123:
            goto tr70;

        case 124:
            goto st39;

        case 125:
            goto tr72;

        case 126:
            goto tr73;

        case 127:
            goto tr39;

        case 302:
            goto tr74;

        case 321:
            goto st40;

        case 322:
            goto st46;

        case 323:
            goto st47;

        case 324:
            goto st52;

        case 325:
            goto st57;

        case 326:
            goto tr80;

        case 328:
            goto st60;

        case 329:
            goto st63;

        case 330:
            goto st70;

        case 332:
            goto st71;

        case 333:
            goto tr86;

        case 334:
            goto st75;

        case 335:
            goto st78;

        case 336:
            goto st84;

        case 338:
            goto st85;

        case 339:
            goto st91;

        case 346:
            goto tr92;

        case 351:
            goto tr81;

        case 353:
            goto st40;

        case 354:
            goto st46;

        case 355:
            goto st47;

        case 356:
            goto st52;

        case 357:
            goto st57;

        case 358:
            goto tr80;

        case 360:
            goto st60;

        case 361:
            goto st63;

        case 362:
            goto st70;

        case 364:
            goto st71;

        case 365:
            goto tr86;

        case 366:
            goto st75;

        case 367:
            goto st78;

        case 368:
            goto st84;

        case 370:
            goto st85;

        case 371:
            goto st91;

        case 378:
            goto tr92;

        case 558:
            goto tr93;

        case 577:
            goto tr94;

        case 578:
            goto tr95;

        case 579:
            goto tr96;

        case 580:
            goto tr97;

        case 581:
            goto tr98;

        case 582:
            goto tr99;

        case 584:
            goto tr101;

        case 585:
            goto tr102;

        case 586:
            goto tr103;

        case 588:
            goto tr104;

        case 589:
            goto tr105;

        case 590:
            goto tr106;

        case 591:
            goto tr107;

        case 592:
            goto tr108;

        case 594:
            goto tr109;

        case 595:
            goto tr110;

        case 602:
            goto tr111;

        case 607:
            goto tr100;

        case 609:
            goto tr94;

        case 610:
            goto tr95;

        case 611:
            goto tr96;

        case 612:
            goto tr97;

        case 613:
            goto tr98;

        case 614:
            goto tr99;

        case 616:
            goto tr101;

        case 617:
            goto tr102;

        case 618:
            goto tr103;

        case 620:
            goto tr104;

        case 621:
            goto tr105;

        case 622:
            goto tr106;

        case 623:
            goto tr107;

        case 624:
            goto tr108;

        case 626:
            goto tr109;

        case 627:
            goto tr110;

        case 634:
            goto tr111;
        }

        if ( _widec < 327 )
        {
            if ( _widec > 32 )
            {
                if ( 50 <= _widec && _widec <= 57 )
                    goto tr58;
            }
            else
                goto tr39;
        }
        else if ( _widec > 345 )
        {
            if ( _widec < 583 )
            {
                if ( 359 <= _widec && _widec <= 377 )
                    goto tr81;
            }
            else if ( _widec > 601 )
            {
                if ( 615 <= _widec && _widec <= 633 )
                    goto tr100;
            }
            else
                goto tr100;
        }
        else
            goto tr81;

        goto st0;
st22:

        if ( ++p == pe )
            goto _test_eof22;

        case 22:
            if ( ( *p ) == 61 )
                goto tr113;

            goto tr112;
tr44:

            {
                te = p + 1;
            }

            {
                act = 130;
            }
            goto st23;
tr114:

            {
                te = p + 1;
            }

            {
                act = 122;
            }
            goto st23;
st23:

            if ( ++p == pe )
                goto _test_eof23;

        case 23:

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr114;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto tr114;
            }
            else
                goto tr114;

            goto tr21;
st24:

            if ( ++p == pe )
                goto _test_eof24;

        case 24:
            if ( ( *p ) == 38 )
                goto tr116;

            goto tr115;
tr48:

            {
                te = p + 1;
            }
            goto st25;
st25:

            if ( ++p == pe )
                goto _test_eof25;

        case 25:

            switch ( ( *p ) )
            {
            case 9:
                goto st1;

            case 32:
                goto st1;

            case 66:
                goto st2;

            case 67:
                goto st4;

            case 68:
                goto st5;

            case 72:
                goto st7;

            case 73:
                goto st9;

            case 83:
                goto st12;

            case 98:
                goto st2;

            case 99:
                goto st4;

            case 100:
                goto st5;

            case 104:
                goto st7;

            case 105:
                goto st9;

            case 115:
                goto st12;
            }

            goto tr117;
st1:

            if ( ++p == pe )
                goto _test_eof1;

        case 1:
            switch ( ( *p ) )
            {
            case 9:
                goto st1;

            case 32:
                goto st1;

            case 66:
                goto st2;

            case 67:
                goto st4;

            case 68:
                goto st5;

            case 72:
                goto st7;

            case 73:
                goto st9;

            case 83:
                goto st12;

            case 98:
                goto st2;

            case 99:
                goto st4;

            case 100:
                goto st5;

            case 104:
                goto st7;

            case 105:
                goto st9;

            case 115:
                goto st12;
            }

            goto tr0;
st2:

            if ( ++p == pe )
                goto _test_eof2;

        case 2:
            switch ( ( *p ) )
            {
            case 67:
                goto st3;

            case 99:
                goto st3;
            }

            goto tr0;
st3:

            if ( ++p == pe )
                goto _test_eof3;

        case 3:
            switch ( ( *p ) )
            {
            case 9:
                goto st3;

            case 32:
                goto st3;

            case 41:
                goto tr9;
            }

            goto tr0;
st4:

            if ( ++p == pe )
                goto _test_eof4;

        case 4:
            switch ( ( *p ) )
            {
            case 9:
                goto st4;

            case 32:
                goto st4;

            case 41:
                goto tr10;
            }

            goto tr0;
st5:

            if ( ++p == pe )
                goto _test_eof5;

        case 5:
            switch ( ( *p ) )
            {
            case 69:
                goto st6;

            case 101:
                goto st6;
            }

            goto tr0;
st6:

            if ( ++p == pe )
                goto _test_eof6;

        case 6:
            switch ( ( *p ) )
            {
            case 9:
                goto st6;

            case 32:
                goto st6;

            case 41:
                goto tr12;
            }

            goto tr0;
st7:

            if ( ++p == pe )
                goto _test_eof7;

        case 7:
            switch ( ( *p ) )
            {
            case 76:
                goto st8;

            case 108:
                goto st8;
            }

            goto tr0;
st8:

            if ( ++p == pe )
                goto _test_eof8;

        case 8:
            switch ( ( *p ) )
            {
            case 9:
                goto st8;

            case 32:
                goto st8;

            case 41:
                goto tr14;
            }

            goto tr0;
st9:

            if ( ++p == pe )
                goto _test_eof9;

        case 9:
            switch ( ( *p ) )
            {
            case 88:
                goto st10;

            case 89:
                goto st11;

            case 120:
                goto st10;

            case 121:
                goto st11;
            }

            goto tr0;
st10:

            if ( ++p == pe )
                goto _test_eof10;

        case 10:
            switch ( ( *p ) )
            {
            case 9:
                goto st10;

            case 32:
                goto st10;

            case 41:
                goto tr17;

            case 43:
                goto tr17;

            case 45:
                goto tr17;
            }

            goto tr0;
st11:

            if ( ++p == pe )
                goto _test_eof11;

        case 11:
            switch ( ( *p ) )
            {
            case 9:
                goto st11;

            case 32:
                goto st11;

            case 41:
                goto tr18;

            case 43:
                goto tr18;

            case 45:
                goto tr18;
            }

            goto tr0;
st12:

            if ( ++p == pe )
                goto _test_eof12;

        case 12:
            switch ( ( *p ) )
            {
            case 80:
                goto st13;

            case 112:
                goto st13;
            }

            goto tr0;
st13:

            if ( ++p == pe )
                goto _test_eof13;

        case 13:
            switch ( ( *p ) )
            {
            case 9:
                goto st13;

            case 32:
                goto st13;

            case 41:
                goto tr20;
            }

            goto tr0;
st26:

            if ( ++p == pe )
                goto _test_eof26;

        case 26:
            if ( ( *p ) == 42 )
                goto tr119;

            goto tr118;
st0:
            cs = 0;
            goto _out;
tr56:

            {
                te = p + 1;
            }

            {
                act = 120;
            }
            goto st27;
st27:

            if ( ++p == pe )
                goto _test_eof27;

        case 27:

            switch ( ( *p ) )
            {
            case 66:
                goto tr121;

            case 72:
                goto tr23;

            case 88:
                goto st15;

            case 98:
                goto tr121;

            case 104:
                goto tr23;

            case 120:
                goto st15;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr57;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st14;
                }
                else if ( ( *p ) >= 65 )
                    goto st14;
            }
            else
                goto tr58;

            goto tr120;
tr57:

            {
                te = p + 1;
            }

            {
                act = 120;
            }
            goto st28;
st28:

            if ( ++p == pe )
                goto _test_eof28;

        case 28:

            switch ( ( *p ) )
            {
            case 66:
                goto tr123;

            case 72:
                goto tr23;

            case 98:
                goto tr123;

            case 104:
                goto tr23;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr57;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st14;
                }
                else if ( ( *p ) >= 65 )
                    goto st14;
            }
            else
                goto tr58;

            goto tr120;
tr58:

            {
                te = p + 1;
            }

            {
                act = 120;
            }
            goto st29;
st29:

            if ( ++p == pe )
                goto _test_eof29;

        case 29:

            switch ( ( *p ) )
            {
            case 72:
                goto tr23;

            case 104:
                goto tr23;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr58;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st14;
            }
            else
                goto st14;

            goto tr120;
st14:

            if ( ++p == pe )
                goto _test_eof14;

        case 14:
            switch ( ( *p ) )
            {
            case 72:
                goto tr23;

            case 104:
                goto tr23;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st14;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st14;
            }
            else
                goto st14;

            goto tr21;
tr123:

            {
                te = p + 1;
            }

            {
                act = 124;
            }
            goto st30;
st30:

            if ( ++p == pe )
                goto _test_eof30;

        case 30:

            switch ( ( *p ) )
            {
            case 72:
                goto tr23;

            case 104:
                goto tr23;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st14;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st14;
            }
            else
                goto st14;

            goto tr124;
tr121:

            {
                te = p + 1;
            }

            {
                act = 124;
            }
            goto st31;
tr125:

            {
                te = p + 1;
            }

            {
                act = 126;
            }
            goto st31;
st31:

            if ( ++p == pe )
                goto _test_eof31;

        case 31:

            switch ( ( *p ) )
            {
            case 72:
                goto tr23;

            case 104:
                goto tr23;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr125;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st14;
                }
                else if ( ( *p ) >= 65 )
                    goto st14;
            }
            else
                goto st14;

            goto tr21;
st15:

            if ( ++p == pe )
                goto _test_eof15;

        case 15:
            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st32;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st32;
            }
            else
                goto st32;

            goto tr24;
st32:

            if ( ++p == pe )
                goto _test_eof32;

        case 32:
            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st32;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st32;
            }
            else
                goto st32;

            goto tr126;
st33:

            if ( ++p == pe )
                goto _test_eof33;

        case 33:
            if ( ( *p ) == 10 )
                goto tr127;

            goto st33;
st34:

            if ( ++p == pe )
                goto _test_eof34;

        case 34:
            switch ( ( *p ) )
            {
            case 60:
                goto tr129;

            case 61:
                goto tr130;

            case 62:
                goto tr131;
            }

            goto tr128;
st35:

            if ( ++p == pe )
                goto _test_eof35;

        case 35:
            if ( ( *p ) == 61 )
                goto tr133;

            goto tr132;
st36:

            if ( ++p == pe )
                goto _test_eof36;

        case 36:
            switch ( ( *p ) )
            {
            case 61:
                goto tr135;

            case 62:
                goto tr136;
            }

            goto tr134;
tr65:

            {
                te = p + 1;
            }
            goto st37;
st37:

            if ( ++p == pe )
                goto _test_eof37;

        case 37:

            if ( ( *p ) == 34 )
                goto st16;

            if ( 48 <= ( *p ) && ( *p ) <= 49 )
                goto st38;

            goto tr137;
st16:

            if ( ++p == pe )
                goto _test_eof16;

        case 16:
            switch ( ( *p ) )
            {
            case 35:
                goto st17;

            case 45:
                goto st17;
            }

            goto tr26;
st17:

            if ( ++p == pe )
                goto _test_eof17;

        case 17:
            switch ( ( *p ) )
            {
            case 34:
                goto tr28;

            case 35:
                goto st17;

            case 45:
                goto st17;
            }

            goto tr26;
st38:

            if ( ++p == pe )
                goto _test_eof38;

        case 38:
            if ( 48 <= ( *p ) && ( *p ) <= 49 )
                goto st38;

            goto tr140;
st39:

            if ( ++p == pe )
                goto _test_eof39;

        case 39:
            if ( ( *p ) == 124 )
                goto tr142;

            goto tr141;
st40:

            if ( ++p == pe )
                goto _test_eof40;

        case 40:
            switch ( ( *p ) )
            {
            case 70:
                goto st42;

            case 83:
                goto st43;

            case 95:
                goto tr81;

            case 102:
                goto st42;

            case 115:
                goto st43;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr143;
tr80:

            {
                te = p + 1;
            }

            {
                act = 55;
            }
            goto st41;
tr81:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st41;
tr86:

            {
                te = p + 1;
            }

            {
                act = 44;
            }
            goto st41;
tr92:

            {
                te = p + 1;
            }

            {
                act = 38;
            }
            goto st41;
tr151:

            {
                te = p + 1;
            }

            {
                act = 1;
            }
            goto st41;
tr153:

            {
                te = p + 1;
            }

            {
                act = 61;
            }
            goto st41;
tr157:

            {
                te = p + 1;
            }

            {
                act = 79;
            }
            goto st41;
tr160:

            {
                te = p + 1;
            }

            {
                act = 84;
            }
            goto st41;
tr162:

            {
                te = p + 1;
            }

            {
                act = 81;
            }
            goto st41;
tr164:

            {
                te = p + 1;
            }

            {
                act = 83;
            }
            goto st41;
tr167:

            {
                te = p + 1;
            }

            {
                act = 62;
            }
            goto st41;
tr168:

            {
                te = p + 1;
            }

            {
                act = 86;
            }
            goto st41;
tr171:

            {
                te = p + 1;
            }

            {
                act = 85;
            }
            goto st41;
tr173:

            {
                te = p + 1;
            }

            {
                act = 87;
            }
            goto st41;
tr179:

            {
                te = p + 1;
            }

            {
                act = 59;
            }
            goto st41;
tr181:

            {
                te = p + 1;
            }

            {
                act = 90;
            }
            goto st41;
tr184:

            {
                te = p + 1;
            }

            {
                act = 63;
            }
            goto st41;
tr186:

            {
                te = p + 1;
            }

            {
                act = 91;
            }
            goto st41;
tr189:

            {
                te = p + 1;
            }

            {
                act = 92;
            }
            goto st41;
tr193:

            {
                te = p + 1;
            }

            {
                act = 57;
            }
            goto st41;
tr197:

            {
                te = p + 1;
            }

            {
                act = 94;
            }
            goto st41;
tr199:

            {
                te = p + 1;
            }

            {
                act = 96;
            }
            goto st41;
tr201:

            {
                te = p + 1;
            }

            {
                act = 49;
            }
            goto st41;
tr202:

            {
                te = p + 1;
            }

            {
                act = 52;
            }
            goto st41;
tr204:

            {
                te = p + 1;
            }

            {
                act = 50;
            }
            goto st41;
tr205:

            {
                te = p + 1;
            }

            {
                act = 53;
            }
            goto st41;
tr206:

            {
                te = p + 1;
            }

            {
                act = 97;
            }
            goto st41;
tr207:

            {
                te = p + 1;
            }

            {
                act = 98;
            }
            goto st41;
tr213:

            {
                te = p + 1;
            }

            {
                act = 100;
            }
            goto st41;
tr215:

            {
                te = p + 1;
            }

            {
                act = 102;
            }
            goto st41;
tr216:

            {
                te = p + 1;
            }

            {
                act = 39;
            }
            goto st41;
tr219:

            {
                te = p + 1;
            }

            {
                act = 37;
            }
            goto st41;
tr220:

            {
                te = p + 1;
            }

            {
                act = 103;
            }
            goto st41;
tr221:

            {
                te = p + 1;
            }

            {
                act = 104;
            }
            goto st41;
tr226:

            {
                te = p + 1;
            }

            {
                act = 105;
            }
            goto st41;
tr227:

            {
                te = p + 1;
            }

            {
                act = 106;
            }
            goto st41;
tr229:

            {
                te = p + 1;
            }

            {
                act = 107;
            }
            goto st41;
tr230:

            {
                te = p + 1;
            }

            {
                act = 108;
            }
            goto st41;
tr232:

            {
                te = p + 1;
            }

            {
                act = 42;
            }
            goto st41;
tr233:

            {
                te = p + 1;
            }

            {
                act = 41;
            }
            goto st41;
tr241:

            {
                te = p + 1;
            }

            {
                act = 110;
            }
            goto st41;
tr242:

            {
                te = p + 1;
            }

            {
                act = 111;
            }
            goto st41;
tr243:

            {
                te = p + 1;
            }

            {
                act = 112;
            }
            goto st41;
tr244:

            {
                te = p + 1;
            }

            {
                act = 113;
            }
            goto st41;
tr245:

            {
                te = p + 1;
            }

            {
                act = 114;
            }
            goto st41;
tr247:

            {
                te = p + 1;
            }

            {
                act = 67;
            }
            goto st41;
tr248:

            {
                te = p + 1;
            }

            {
                act = 115;
            }
            goto st41;
st41:

            if ( ++p == pe )
                goto _test_eof41;

        case 41:

            if ( ( *p ) == 95 )
                goto tr81;

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr21;
st42:

            if ( ++p == pe )
                goto _test_eof42;

        case 42:
            switch ( ( *p ) )
            {
            case 39:
                goto tr147;

            case 95:
                goto tr81;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr146;
st43:

            if ( ++p == pe )
                goto _test_eof43;

        case 43:
            switch ( ( *p ) )
            {
            case 77:
                goto st44;

            case 95:
                goto tr81;

            case 109:
                goto st44;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st44:

            if ( ++p == pe )
                goto _test_eof44;

        case 44:
            switch ( ( *p ) )
            {
            case 80:
                goto st45;

            case 95:
                goto tr81;

            case 112:
                goto st45;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st45:

            if ( ++p == pe )
                goto _test_eof45;

        case 45:
            switch ( ( *p ) )
            {
            case 67:
                goto tr151;

            case 95:
                goto tr81;

            case 99:
                goto tr151;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st46:

            if ( ++p == pe )
                goto _test_eof46;

        case 46:
            switch ( ( *p ) )
            {
            case 67:
                goto tr153;

            case 95:
                goto tr81;

            case 99:
                goto tr153;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr152;
st47:

            if ( ++p == pe )
                goto _test_eof47;

        case 47:
            switch ( ( *p ) )
            {
            case 67:
                goto st48;

            case 80:
                goto st49;

            case 95:
                goto tr81;

            case 99:
                goto st48;

            case 112:
                goto st49;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr154;
st48:

            if ( ++p == pe )
                goto _test_eof48;

        case 48:
            switch ( ( *p ) )
            {
            case 70:
                goto tr157;

            case 95:
                goto tr81;

            case 102:
                goto tr157;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st49:

            if ( ++p == pe )
                goto _test_eof49;

        case 49:
            switch ( ( *p ) )
            {
            case 68:
                goto st50;

            case 73:
                goto st51;

            case 76:
                goto tr160;

            case 95:
                goto tr81;

            case 100:
                goto st50;

            case 105:
                goto st51;

            case 108:
                goto tr160;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st50:

            if ( ++p == pe )
                goto _test_eof50;

        case 50:
            switch ( ( *p ) )
            {
            case 82:
                goto tr162;

            case 95:
                goto tr81;

            case 114:
                goto tr162;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr161;
st51:

            if ( ++p == pe )
                goto _test_eof51;

        case 51:
            switch ( ( *p ) )
            {
            case 82:
                goto tr164;

            case 95:
                goto tr81;

            case 114:
                goto tr164;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr163;
st52:

            if ( ++p == pe )
                goto _test_eof52;

        case 52:
            switch ( ( *p ) )
            {
            case 65:
                goto st53;

            case 69:
                goto tr167;

            case 73:
                goto tr168;

            case 74:
                goto st54;

            case 83:
                goto tr170;

            case 95:
                goto tr81;

            case 97:
                goto st53;

            case 101:
                goto tr167;

            case 105:
                goto tr168;

            case 106:
                goto st54;

            case 115:
                goto tr170;
            }

            if ( ( *p ) < 66 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 98 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr165;
st53:

            if ( ++p == pe )
                goto _test_eof53;

        case 53:
            switch ( ( *p ) )
            {
            case 65:
                goto tr171;

            case 95:
                goto tr81;

            case 97:
                goto tr171;
            }

            if ( ( *p ) < 66 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 98 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st54:

            if ( ++p == pe )
                goto _test_eof54;

        case 54:
            switch ( ( *p ) )
            {
            case 78:
                goto st55;

            case 95:
                goto tr81;

            case 110:
                goto st55;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st55:

            if ( ++p == pe )
                goto _test_eof55;

        case 55:
            switch ( ( *p ) )
            {
            case 90:
                goto tr173;

            case 95:
                goto tr81;

            case 122:
                goto tr173;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 89 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 121 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
tr170:

            {
                te = p + 1;
            }
            goto st56;
st56:

            if ( ++p == pe )
                goto _test_eof56;

        case 56:

            switch ( ( *p ) )
            {
            case 46:
                goto st18;

            case 95:
                goto tr81;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st18:

            if ( ++p == pe )
                goto _test_eof18;

        case 18:
            switch ( ( *p ) )
            {
            case 66:
                goto tr30;

            case 76:
                goto tr31;

            case 80:
                goto tr32;

            case 87:
                goto tr33;

            case 98:
                goto tr30;

            case 108:
                goto tr31;

            case 112:
                goto tr32;

            case 119:
                goto tr33;
            }

            goto tr29;
st57:

            if ( ++p == pe )
                goto _test_eof57;

        case 57:
            switch ( ( *p ) )
            {
            case 73:
                goto st58;

            case 88:
                goto st59;

            case 95:
                goto tr81;

            case 105:
                goto st58;

            case 120:
                goto st59;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr175;
st58:

            if ( ++p == pe )
                goto _test_eof58;

        case 58:
            switch ( ( *p ) )
            {
            case 82:
                goto tr179;

            case 95:
                goto tr81;

            case 114:
                goto tr179;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr178;
st59:

            if ( ++p == pe )
                goto _test_eof59;

        case 59:
            switch ( ( *p ) )
            {
            case 88:
                goto tr181;

            case 95:
                goto tr81;

            case 120:
                goto tr181;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr180;
st60:

            if ( ++p == pe )
                goto _test_eof60;

        case 60:
            switch ( ( *p ) )
            {
            case 65:
                goto st61;

            case 76:
                goto tr184;

            case 95:
                goto tr81;

            case 97:
                goto st61;

            case 108:
                goto tr184;
            }

            if ( ( *p ) < 66 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 98 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr182;
st61:

            if ( ++p == pe )
                goto _test_eof61;

        case 61:
            switch ( ( *p ) )
            {
            case 76:
                goto st62;

            case 95:
                goto tr81;

            case 108:
                goto st62;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st62:

            if ( ++p == pe )
                goto _test_eof62;

        case 62:
            switch ( ( *p ) )
            {
            case 84:
                goto tr186;

            case 95:
                goto tr81;

            case 116:
                goto tr186;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st63:

            if ( ++p == pe )
                goto _test_eof63;

        case 63:
            switch ( ( *p ) )
            {
            case 73:
                goto st64;

            case 77:
                goto tr189;

            case 78:
                goto st65;

            case 88:
                goto st68;

            case 89:
                goto st69;

            case 95:
                goto tr81;

            case 105:
                goto st64;

            case 109:
                goto tr189;

            case 110:
                goto st65;

            case 120:
                goto st68;

            case 121:
                goto st69;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr187;
st64:

            if ( ++p == pe )
                goto _test_eof64;

        case 64:
            switch ( ( *p ) )
            {
            case 82:
                goto tr193;

            case 95:
                goto tr81;

            case 114:
                goto tr193;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st65:

            if ( ++p == pe )
                goto _test_eof65;

        case 65:
            switch ( ( *p ) )
            {
            case 68:
                goto st66;

            case 73:
                goto st67;

            case 95:
                goto tr81;

            case 100:
                goto st66;

            case 105:
                goto st67;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st66:

            if ( ++p == pe )
                goto _test_eof66;

        case 66:
            switch ( ( *p ) )
            {
            case 82:
                goto tr197;

            case 95:
                goto tr81;

            case 114:
                goto tr197;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr196;
st67:

            if ( ++p == pe )
                goto _test_eof67;

        case 67:
            switch ( ( *p ) )
            {
            case 82:
                goto tr199;

            case 95:
                goto tr81;

            case 114:
                goto tr199;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr198;
st68:

            if ( ++p == pe )
                goto _test_eof68;

        case 68:
            switch ( ( *p ) )
            {
            case 72:
                goto tr201;

            case 76:
                goto tr202;

            case 95:
                goto tr81;

            case 104:
                goto tr201;

            case 108:
                goto tr202;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr200;
st69:

            if ( ++p == pe )
                goto _test_eof69;

        case 69:
            switch ( ( *p ) )
            {
            case 72:
                goto tr204;

            case 76:
                goto tr205;

            case 95:
                goto tr81;

            case 104:
                goto tr204;

            case 108:
                goto tr205;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr203;
st70:

            if ( ++p == pe )
                goto _test_eof70;

        case 70:
            switch ( ( *p ) )
            {
            case 80:
                goto tr206;

            case 82:
                goto tr207;

            case 95:
                goto tr81;

            case 112:
                goto tr206;

            case 114:
                goto tr207;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st71:

            if ( ++p == pe )
                goto _test_eof71;

        case 71:
            switch ( ( *p ) )
            {
            case 68:
                goto st72;

            case 95:
                goto tr81;

            case 100:
                goto st72;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr208;
st72:

            if ( ++p == pe )
                goto _test_eof72;

        case 72:
            switch ( ( *p ) )
            {
            case 68:
                goto st73;

            case 73:
                goto st74;

            case 95:
                goto tr81;

            case 100:
                goto st73;

            case 105:
                goto st74;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st73:

            if ( ++p == pe )
                goto _test_eof73;

        case 73:
            switch ( ( *p ) )
            {
            case 82:
                goto tr213;

            case 95:
                goto tr81;

            case 114:
                goto tr213;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr212;
st74:

            if ( ++p == pe )
                goto _test_eof74;

        case 74:
            switch ( ( *p ) )
            {
            case 82:
                goto tr215;

            case 95:
                goto tr81;

            case 114:
                goto tr215;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr214;
st75:

            if ( ++p == pe )
                goto _test_eof75;

        case 75:
            switch ( ( *p ) )
            {
            case 67:
                goto tr216;

            case 69:
                goto st76;

            case 79:
                goto st77;

            case 90:
                goto tr219;

            case 95:
                goto tr81;

            case 99:
                goto tr216;

            case 101:
                goto st76;

            case 111:
                goto st77;

            case 122:
                goto tr219;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 89 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 121 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st76:

            if ( ++p == pe )
                goto _test_eof76;

        case 76:
            switch ( ( *p ) )
            {
            case 71:
                goto tr220;

            case 95:
                goto tr81;

            case 103:
                goto tr220;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st77:

            if ( ++p == pe )
                goto _test_eof77;

        case 77:
            switch ( ( *p ) )
            {
            case 80:
                goto tr221;

            case 95:
                goto tr81;

            case 112:
                goto tr221;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st78:

            if ( ++p == pe )
                goto _test_eof78;

        case 78:
            switch ( ( *p ) )
            {
            case 84:
                goto st79;

            case 85:
                goto st82;

            case 95:
                goto tr81;

            case 116:
                goto st79;

            case 117:
                goto st82;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st79:

            if ( ++p == pe )
                goto _test_eof79;

        case 79:
            switch ( ( *p ) )
            {
            case 68:
                goto st80;

            case 73:
                goto st81;

            case 95:
                goto tr81;

            case 100:
                goto st80;

            case 105:
                goto st81;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st80:

            if ( ++p == pe )
                goto _test_eof80;

        case 80:
            switch ( ( *p ) )
            {
            case 82:
                goto tr226;

            case 95:
                goto tr81;

            case 114:
                goto tr226;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st81:

            if ( ++p == pe )
                goto _test_eof81;

        case 81:
            switch ( ( *p ) )
            {
            case 82:
                goto tr227;

            case 95:
                goto tr81;

            case 114:
                goto tr227;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st82:

            if ( ++p == pe )
                goto _test_eof82;

        case 82:
            switch ( ( *p ) )
            {
            case 84:
                goto st83;

            case 95:
                goto tr81;

            case 116:
                goto st83;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st83:

            if ( ++p == pe )
                goto _test_eof83;

        case 83:
            switch ( ( *p ) )
            {
            case 68:
                goto tr229;

            case 73:
                goto tr230;

            case 95:
                goto tr81;

            case 100:
                goto tr229;

            case 105:
                goto tr230;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st84:

            if ( ++p == pe )
                goto _test_eof84;

        case 84:
            switch ( ( *p ) )
            {
            case 69:
                goto tr232;

            case 79:
                goto tr233;

            case 95:
                goto tr81;

            case 101:
                goto tr232;

            case 111:
                goto tr233;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr231;
st85:

            if ( ++p == pe )
                goto _test_eof85;

        case 85:
            switch ( ( *p ) )
            {
            case 69:
                goto st86;

            case 76:
                goto st88;

            case 82:
                goto st89;

            case 83:
                goto st90;

            case 95:
                goto tr81;

            case 101:
                goto st86;

            case 108:
                goto st88;

            case 114:
                goto st89;

            case 115:
                goto st90;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr234;
st86:

            if ( ++p == pe )
                goto _test_eof86;

        case 86:
            switch ( ( *p ) )
            {
            case 84:
                goto st87;

            case 95:
                goto tr81;

            case 116:
                goto st87;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st87:

            if ( ++p == pe )
                goto _test_eof87;

        case 87:
            switch ( ( *p ) )
            {
            case 73:
                goto tr241;

            case 78:
                goto tr242;

            case 95:
                goto tr81;

            case 105:
                goto tr241;

            case 110:
                goto tr242;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr240;
st88:

            if ( ++p == pe )
                goto _test_eof88;

        case 88:
            switch ( ( *p ) )
            {
            case 68:
                goto tr243;

            case 95:
                goto tr81;

            case 100:
                goto tr243;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st89:

            if ( ++p == pe )
                goto _test_eof89;

        case 89:
            switch ( ( *p ) )
            {
            case 68:
                goto tr244;

            case 95:
                goto tr81;

            case 100:
                goto tr244;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st90:

            if ( ++p == pe )
                goto _test_eof90;

        case 90:
            switch ( ( *p ) )
            {
            case 84:
                goto tr245;

            case 95:
                goto tr81;

            case 116:
                goto tr245;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st91:

            if ( ++p == pe )
                goto _test_eof91;

        case 91:
            switch ( ( *p ) )
            {
            case 67:
                goto st92;

            case 80:
                goto tr247;

            case 95:
                goto tr81;

            case 99:
                goto st92;

            case 112:
                goto tr247;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
st92:

            if ( ++p == pe )
                goto _test_eof92;

        case 92:
            switch ( ( *p ) )
            {
            case 70:
                goto tr248;

            case 95:
                goto tr81;

            case 102:
                goto tr248;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr81;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto tr81;
            }
            else
                goto tr81;

            goto tr148;
tr93:

            {
                te = p + 1;
            }
            goto st93;
st93:

            if ( ++p == pe )
                goto _test_eof93;

        case 93:

            _widec = ( *p );

            if ( ( *p ) < 65 )
            {
                if ( ( *p ) > 9 )
                {
                    if ( 32 <= ( *p ) && ( *p ) <= 32 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) >= 9 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 90 )
            {
                if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) >= 95 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 521:
                goto st19;

            case 544:
                goto st19;

            case 607:
                goto st94;
            }

            if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st94;
            }
            else if ( _widec >= 577 )
                goto st94;

            goto tr249;
st19:

            if ( ++p == pe )
                goto _test_eof19;

        case 19:
            _widec = ( *p );

            if ( ( *p ) < 65 )
            {
                if ( ( *p ) > 9 )
                {
                    if ( 32 <= ( *p ) && ( *p ) <= 32 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) >= 9 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 90 )
            {
                if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) >= 95 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 521:
                goto st19;

            case 544:
                goto st19;

            case 607:
                goto st94;
            }

            if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st94;
            }
            else if ( _widec >= 577 )
                goto st94;

            goto tr34;
st94:

            if ( ++p == pe )
                goto _test_eof94;

        case 94:
            _widec = ( *p );

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 90 )
            {
                if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) >= 95 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            if ( _widec == 607 )
                goto st94;

            if ( _widec < 577 )
            {
                if ( 560 <= _widec && _widec <= 569 )
                    goto st94;
            }
            else if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st94;
            }
            else
                goto st94;

            goto tr250;
tr94:

            {
                te = p + 1;
            }

            {
                act = 54;
            }
            goto st95;
st95:

            if ( ++p == pe )
                goto _test_eof95;

        case 95:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 326:
                goto st42;

            case 339:
                goto st43;

            case 351:
                goto tr81;

            case 358:
                goto st42;

            case 371:
                goto st43;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 582:
                goto tr251;

            case 595:
                goto tr252;

            case 607:
                goto tr100;

            case 614:
                goto tr251;

            case 627:
                goto tr252;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr143;
st20:

            if ( ++p == pe )
                goto _test_eof20;

        case 20:
            _widec = ( *p );

            if ( ( *p ) < 32 )
            {
                if ( 9 <= ( *p ) && ( *p ) <= 9 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 32 )
            {
                if ( 58 <= ( *p ) && ( *p ) <= 58 )
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;
            }

            goto tr21;
tr99:

            {
                te = p + 1;
            }

            {
                act = 55;
            }
            goto st96;
tr100:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st96;
tr105:

            {
                te = p + 1;
            }

            {
                act = 44;
            }
            goto st96;
tr111:

            {
                te = p + 1;
            }

            {
                act = 38;
            }
            goto st96;
tr255:

            {
                te = p + 1;
            }

            {
                act = 1;
            }
            goto st96;
tr256:

            {
                te = p + 1;
            }

            {
                act = 61;
            }
            goto st96;
tr259:

            {
                te = p + 1;
            }

            {
                act = 79;
            }
            goto st96;
tr262:

            {
                te = p + 1;
            }

            {
                act = 84;
            }
            goto st96;
tr263:

            {
                te = p + 1;
            }

            {
                act = 81;
            }
            goto st96;
tr264:

            {
                te = p + 1;
            }

            {
                act = 83;
            }
            goto st96;
tr266:

            {
                te = p + 1;
            }

            {
                act = 62;
            }
            goto st96;
tr267:

            {
                te = p + 1;
            }

            {
                act = 86;
            }
            goto st96;
tr270:

            {
                te = p + 1;
            }

            {
                act = 85;
            }
            goto st96;
tr272:

            {
                te = p + 1;
            }

            {
                act = 87;
            }
            goto st96;
tr275:

            {
                te = p + 1;
            }

            {
                act = 59;
            }
            goto st96;
tr276:

            {
                te = p + 1;
            }

            {
                act = 90;
            }
            goto st96;
tr278:

            {
                te = p + 1;
            }

            {
                act = 63;
            }
            goto st96;
tr280:

            {
                te = p + 1;
            }

            {
                act = 91;
            }
            goto st96;
tr282:

            {
                te = p + 1;
            }

            {
                act = 92;
            }
            goto st96;
tr286:

            {
                te = p + 1;
            }

            {
                act = 57;
            }
            goto st96;
tr289:

            {
                te = p + 1;
            }

            {
                act = 94;
            }
            goto st96;
tr290:

            {
                te = p + 1;
            }

            {
                act = 96;
            }
            goto st96;
tr291:

            {
                te = p + 1;
            }

            {
                act = 49;
            }
            goto st96;
tr292:

            {
                te = p + 1;
            }

            {
                act = 52;
            }
            goto st96;
tr293:

            {
                te = p + 1;
            }

            {
                act = 50;
            }
            goto st96;
tr294:

            {
                te = p + 1;
            }

            {
                act = 53;
            }
            goto st96;
tr295:

            {
                te = p + 1;
            }

            {
                act = 97;
            }
            goto st96;
tr296:

            {
                te = p + 1;
            }

            {
                act = 98;
            }
            goto st96;
tr300:

            {
                te = p + 1;
            }

            {
                act = 100;
            }
            goto st96;
tr301:

            {
                te = p + 1;
            }

            {
                act = 102;
            }
            goto st96;
tr302:

            {
                te = p + 1;
            }

            {
                act = 39;
            }
            goto st96;
tr305:

            {
                te = p + 1;
            }

            {
                act = 37;
            }
            goto st96;
tr306:

            {
                te = p + 1;
            }

            {
                act = 103;
            }
            goto st96;
tr307:

            {
                te = p + 1;
            }

            {
                act = 104;
            }
            goto st96;
tr312:

            {
                te = p + 1;
            }

            {
                act = 105;
            }
            goto st96;
tr313:

            {
                te = p + 1;
            }

            {
                act = 106;
            }
            goto st96;
tr315:

            {
                te = p + 1;
            }

            {
                act = 107;
            }
            goto st96;
tr316:

            {
                te = p + 1;
            }

            {
                act = 108;
            }
            goto st96;
tr317:

            {
                te = p + 1;
            }

            {
                act = 42;
            }
            goto st96;
tr318:

            {
                te = p + 1;
            }

            {
                act = 41;
            }
            goto st96;
tr324:

            {
                te = p + 1;
            }

            {
                act = 110;
            }
            goto st96;
tr325:

            {
                te = p + 1;
            }

            {
                act = 111;
            }
            goto st96;
tr326:

            {
                te = p + 1;
            }

            {
                act = 112;
            }
            goto st96;
tr327:

            {
                te = p + 1;
            }

            {
                act = 113;
            }
            goto st96;
tr328:

            {
                te = p + 1;
            }

            {
                act = 114;
            }
            goto st96;
tr330:

            {
                te = p + 1;
            }

            {
                act = 67;
            }
            goto st96;
tr331:

            {
                te = p + 1;
            }

            {
                act = 115;
            }
            goto st96;
st96:

            if ( ++p == pe )
                goto _test_eof96;

        case 96:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 351:
                goto tr81;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 607:
                goto tr100;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr21;
tr251:

            {
                te = p + 1;
            }

            {
                act = 66;
            }
            goto st97;
st97:

            if ( ++p == pe )
                goto _test_eof97;

        case 97:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 39:
                goto tr147;

            case 351:
                goto tr81;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 607:
                goto tr100;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr146;
tr252:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st98;
st98:

            if ( ++p == pe )
                goto _test_eof98;

        case 98:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 333:
                goto st44;

            case 351:
                goto tr81;

            case 365:
                goto st44;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 589:
                goto tr253;

            case 607:
                goto tr100;

            case 621:
                goto tr253;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr253:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st99;
st99:

            if ( ++p == pe )
                goto _test_eof99;

        case 99:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 336:
                goto st45;

            case 351:
                goto tr81;

            case 368:
                goto st45;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 592:
                goto tr254;

            case 607:
                goto tr100;

            case 624:
                goto tr254;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr254:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st100;
st100:

            if ( ++p == pe )
                goto _test_eof100;

        case 100:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 323:
                goto tr151;

            case 351:
                goto tr81;

            case 355:
                goto tr151;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 579:
                goto tr255;

            case 607:
                goto tr100;

            case 611:
                goto tr255;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr95:

            {
                te = p + 1;
            }

            {
                act = 45;
            }
            goto st101;
st101:

            if ( ++p == pe )
                goto _test_eof101;

        case 101:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 323:
                goto tr153;

            case 351:
                goto tr81;

            case 355:
                goto tr153;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 579:
                goto tr256;

            case 607:
                goto tr100;

            case 611:
                goto tr256;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr152;
tr96:

            {
                te = p + 1;
            }

            {
                act = 40;
            }
            goto st102;
st102:

            if ( ++p == pe )
                goto _test_eof102;

        case 102:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 323:
                goto st48;

            case 336:
                goto st49;

            case 351:
                goto tr81;

            case 355:
                goto st48;

            case 368:
                goto st49;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 579:
                goto tr257;

            case 592:
                goto tr258;

            case 607:
                goto tr100;

            case 611:
                goto tr257;

            case 624:
                goto tr258;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr154;
tr257:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st103;
st103:

            if ( ++p == pe )
                goto _test_eof103;

        case 103:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 326:
                goto tr157;

            case 351:
                goto tr81;

            case 358:
                goto tr157;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 582:
                goto tr259;

            case 607:
                goto tr100;

            case 614:
                goto tr259;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr258:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st104;
st104:

            if ( ++p == pe )
                goto _test_eof104;

        case 104:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto st50;

            case 329:
                goto st51;

            case 332:
                goto tr160;

            case 351:
                goto tr81;

            case 356:
                goto st50;

            case 361:
                goto st51;

            case 364:
                goto tr160;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr260;

            case 585:
                goto tr261;

            case 588:
                goto tr262;

            case 607:
                goto tr100;

            case 612:
                goto tr260;

            case 617:
                goto tr261;

            case 620:
                goto tr262;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr260:

            {
                te = p + 1;
            }

            {
                act = 80;
            }
            goto st105;
st105:

            if ( ++p == pe )
                goto _test_eof105;

        case 105:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr162;

            case 351:
                goto tr81;

            case 370:
                goto tr162;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr263;

            case 607:
                goto tr100;

            case 626:
                goto tr263;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr161;
tr261:

            {
                te = p + 1;
            }

            {
                act = 82;
            }
            goto st106;
st106:

            if ( ++p == pe )
                goto _test_eof106;

        case 106:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr164;

            case 351:
                goto tr81;

            case 370:
                goto tr164;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr264;

            case 607:
                goto tr100;

            case 626:
                goto tr264;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr163;
tr97:

            {
                te = p + 1;
            }

            {
                act = 46;
            }
            goto st107;
st107:

            if ( ++p == pe )
                goto _test_eof107;

        case 107:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 321:
                goto st53;

            case 325:
                goto tr167;

            case 329:
                goto tr168;

            case 330:
                goto st54;

            case 339:
                goto tr170;

            case 351:
                goto tr81;

            case 353:
                goto st53;

            case 357:
                goto tr167;

            case 361:
                goto tr168;

            case 362:
                goto st54;

            case 371:
                goto tr170;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 577:
                goto tr265;

            case 581:
                goto tr266;

            case 585:
                goto tr267;

            case 586:
                goto tr268;

            case 595:
                goto tr269;

            case 607:
                goto tr100;

            case 609:
                goto tr265;

            case 613:
                goto tr266;

            case 617:
                goto tr267;

            case 618:
                goto tr268;

            case 627:
                goto tr269;
            }

            if ( _widec < 354 )
            {
                if ( _widec > 313 )
                {
                    if ( 322 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 578 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 610 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr165;
tr265:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st108;
st108:

            if ( ++p == pe )
                goto _test_eof108;

        case 108:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 321:
                goto tr171;

            case 351:
                goto tr81;

            case 353:
                goto tr171;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 577:
                goto tr270;

            case 607:
                goto tr100;

            case 609:
                goto tr270;
            }

            if ( _widec < 354 )
            {
                if ( _widec > 313 )
                {
                    if ( 322 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 578 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 610 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr268:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st109;
st109:

            if ( ++p == pe )
                goto _test_eof109;

        case 109:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 334:
                goto st55;

            case 351:
                goto tr81;

            case 366:
                goto st55;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 590:
                goto tr271;

            case 607:
                goto tr100;

            case 622:
                goto tr271;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr271:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st110;
st110:

            if ( ++p == pe )
                goto _test_eof110;

        case 110:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 346:
                goto tr173;

            case 351:
                goto tr81;

            case 378:
                goto tr173;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 602:
                goto tr272;

            case 607:
                goto tr100;

            case 634:
                goto tr272;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 345 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 377 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 601 )
                {
                    if ( 609 <= _widec && _widec <= 633 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr269:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st111;
st111:

            if ( ++p == pe )
                goto _test_eof111;

        case 111:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 46:
                goto st18;

            case 351:
                goto tr81;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 607:
                goto tr100;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr98:

            {
                te = p + 1;
            }

            {
                act = 47;
            }
            goto st112;
st112:

            if ( ++p == pe )
                goto _test_eof112;

        case 112:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 329:
                goto st58;

            case 344:
                goto st59;

            case 351:
                goto tr81;

            case 361:
                goto st58;

            case 376:
                goto st59;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 585:
                goto tr273;

            case 600:
                goto tr274;

            case 607:
                goto tr100;

            case 617:
                goto tr273;

            case 632:
                goto tr274;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr175;
tr273:

            {
                te = p + 1;
            }

            {
                act = 88;
            }
            goto st113;
st113:

            if ( ++p == pe )
                goto _test_eof113;

        case 113:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr179;

            case 351:
                goto tr81;

            case 370:
                goto tr179;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr275;

            case 607:
                goto tr100;

            case 626:
                goto tr275;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr178;
tr274:

            {
                te = p + 1;
            }

            {
                act = 89;
            }
            goto st114;
st114:

            if ( ++p == pe )
                goto _test_eof114;

        case 114:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 344:
                goto tr181;

            case 351:
                goto tr81;

            case 376:
                goto tr181;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 600:
                goto tr276;

            case 607:
                goto tr100;

            case 632:
                goto tr276;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr180;
tr101:

            {
                te = p + 1;
            }

            {
                act = 48;
            }
            goto st115;
st115:

            if ( ++p == pe )
                goto _test_eof115;

        case 115:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 321:
                goto st61;

            case 332:
                goto tr184;

            case 351:
                goto tr81;

            case 353:
                goto st61;

            case 364:
                goto tr184;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 577:
                goto tr277;

            case 588:
                goto tr278;

            case 607:
                goto tr100;

            case 609:
                goto tr277;

            case 620:
                goto tr278;
            }

            if ( _widec < 354 )
            {
                if ( _widec > 313 )
                {
                    if ( 322 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 578 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 610 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr182;
tr277:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st116;
st116:

            if ( ++p == pe )
                goto _test_eof116;

        case 116:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 332:
                goto st62;

            case 351:
                goto tr81;

            case 364:
                goto st62;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 588:
                goto tr279;

            case 607:
                goto tr100;

            case 620:
                goto tr279;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr279:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st117;
st117:

            if ( ++p == pe )
                goto _test_eof117;

        case 117:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 340:
                goto tr186;

            case 351:
                goto tr81;

            case 372:
                goto tr186;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 596:
                goto tr280;

            case 607:
                goto tr100;

            case 628:
                goto tr280;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr102:

            {
                te = p + 1;
            }

            {
                act = 56;
            }
            goto st118;
st118:

            if ( ++p == pe )
                goto _test_eof118;

        case 118:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 329:
                goto st64;

            case 333:
                goto tr189;

            case 334:
                goto st65;

            case 344:
                goto st68;

            case 345:
                goto st69;

            case 351:
                goto tr81;

            case 361:
                goto st64;

            case 365:
                goto tr189;

            case 366:
                goto st65;

            case 376:
                goto st68;

            case 377:
                goto st69;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 585:
                goto tr281;

            case 589:
                goto tr282;

            case 590:
                goto tr283;

            case 600:
                goto tr284;

            case 601:
                goto tr285;

            case 607:
                goto tr100;

            case 617:
                goto tr281;

            case 621:
                goto tr282;

            case 622:
                goto tr283;

            case 632:
                goto tr284;

            case 633:
                goto tr285;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr187;
tr281:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st119;
st119:

            if ( ++p == pe )
                goto _test_eof119;

        case 119:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr193;

            case 351:
                goto tr81;

            case 370:
                goto tr193;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr286;

            case 607:
                goto tr100;

            case 626:
                goto tr286;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr283:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st120;
st120:

            if ( ++p == pe )
                goto _test_eof120;

        case 120:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto st66;

            case 329:
                goto st67;

            case 351:
                goto tr81;

            case 356:
                goto st66;

            case 361:
                goto st67;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr287;

            case 585:
                goto tr288;

            case 607:
                goto tr100;

            case 612:
                goto tr287;

            case 617:
                goto tr288;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr287:

            {
                te = p + 1;
            }

            {
                act = 93;
            }
            goto st121;
st121:

            if ( ++p == pe )
                goto _test_eof121;

        case 121:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr197;

            case 351:
                goto tr81;

            case 370:
                goto tr197;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr289;

            case 607:
                goto tr100;

            case 626:
                goto tr289;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr196;
tr288:

            {
                te = p + 1;
            }

            {
                act = 95;
            }
            goto st122;
st122:

            if ( ++p == pe )
                goto _test_eof122;

        case 122:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr199;

            case 351:
                goto tr81;

            case 370:
                goto tr199;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr290;

            case 607:
                goto tr100;

            case 626:
                goto tr290;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr198;
tr284:

            {
                te = p + 1;
            }

            {
                act = 64;
            }
            goto st123;
st123:

            if ( ++p == pe )
                goto _test_eof123;

        case 123:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 328:
                goto tr201;

            case 332:
                goto tr202;

            case 351:
                goto tr81;

            case 360:
                goto tr201;

            case 364:
                goto tr202;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 584:
                goto tr291;

            case 588:
                goto tr292;

            case 607:
                goto tr100;

            case 616:
                goto tr291;

            case 620:
                goto tr292;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr200;
tr285:

            {
                te = p + 1;
            }

            {
                act = 65;
            }
            goto st124;
st124:

            if ( ++p == pe )
                goto _test_eof124;

        case 124:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 328:
                goto tr204;

            case 332:
                goto tr205;

            case 351:
                goto tr81;

            case 360:
                goto tr204;

            case 364:
                goto tr205;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 584:
                goto tr293;

            case 588:
                goto tr294;

            case 607:
                goto tr100;

            case 616:
                goto tr293;

            case 620:
                goto tr294;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr203;
tr103:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st125;
st125:

            if ( ++p == pe )
                goto _test_eof125;

        case 125:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 336:
                goto tr206;

            case 338:
                goto tr207;

            case 351:
                goto tr81;

            case 368:
                goto tr206;

            case 370:
                goto tr207;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 592:
                goto tr295;

            case 594:
                goto tr296;

            case 607:
                goto tr100;

            case 624:
                goto tr295;

            case 626:
                goto tr296;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr104:

            {
                te = p + 1;
            }

            {
                act = 51;
            }
            goto st126;
st126:

            if ( ++p == pe )
                goto _test_eof126;

        case 126:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto st72;

            case 351:
                goto tr81;

            case 356:
                goto st72;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr297;

            case 607:
                goto tr100;

            case 612:
                goto tr297;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr208;
tr297:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st127;
st127:

            if ( ++p == pe )
                goto _test_eof127;

        case 127:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto st73;

            case 329:
                goto st74;

            case 351:
                goto tr81;

            case 356:
                goto st73;

            case 361:
                goto st74;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr298;

            case 585:
                goto tr299;

            case 607:
                goto tr100;

            case 612:
                goto tr298;

            case 617:
                goto tr299;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr298:

            {
                te = p + 1;
            }

            {
                act = 99;
            }
            goto st128;
st128:

            if ( ++p == pe )
                goto _test_eof128;

        case 128:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr213;

            case 351:
                goto tr81;

            case 370:
                goto tr213;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr300;

            case 607:
                goto tr100;

            case 626:
                goto tr300;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr212;
tr299:

            {
                te = p + 1;
            }

            {
                act = 101;
            }
            goto st129;
st129:

            if ( ++p == pe )
                goto _test_eof129;

        case 129:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr215;

            case 351:
                goto tr81;

            case 370:
                goto tr215;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr301;

            case 607:
                goto tr100;

            case 626:
                goto tr301;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr214;
tr106:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st130;
st130:

            if ( ++p == pe )
                goto _test_eof130;

        case 130:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 323:
                goto tr216;

            case 325:
                goto st76;

            case 335:
                goto st77;

            case 346:
                goto tr219;

            case 351:
                goto tr81;

            case 355:
                goto tr216;

            case 357:
                goto st76;

            case 367:
                goto st77;

            case 378:
                goto tr219;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 579:
                goto tr302;

            case 581:
                goto tr303;

            case 591:
                goto tr304;

            case 602:
                goto tr305;

            case 607:
                goto tr100;

            case 611:
                goto tr302;

            case 613:
                goto tr303;

            case 623:
                goto tr304;

            case 634:
                goto tr305;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 345 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 377 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 601 )
                {
                    if ( 609 <= _widec && _widec <= 633 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr303:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st131;
st131:

            if ( ++p == pe )
                goto _test_eof131;

        case 131:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 327:
                goto tr220;

            case 351:
                goto tr81;

            case 359:
                goto tr220;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 583:
                goto tr306;

            case 607:
                goto tr100;

            case 615:
                goto tr306;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr304:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st132;
st132:

            if ( ++p == pe )
                goto _test_eof132;

        case 132:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 336:
                goto tr221;

            case 351:
                goto tr81;

            case 368:
                goto tr221;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 592:
                goto tr307;

            case 607:
                goto tr100;

            case 624:
                goto tr307;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr107:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st133;
st133:

            if ( ++p == pe )
                goto _test_eof133;

        case 133:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 340:
                goto st79;

            case 341:
                goto st82;

            case 351:
                goto tr81;

            case 372:
                goto st79;

            case 373:
                goto st82;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 596:
                goto tr308;

            case 597:
                goto tr309;

            case 607:
                goto tr100;

            case 628:
                goto tr308;

            case 629:
                goto tr309;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr308:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st134;
st134:

            if ( ++p == pe )
                goto _test_eof134;

        case 134:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto st80;

            case 329:
                goto st81;

            case 351:
                goto tr81;

            case 356:
                goto st80;

            case 361:
                goto st81;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr310;

            case 585:
                goto tr311;

            case 607:
                goto tr100;

            case 612:
                goto tr310;

            case 617:
                goto tr311;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr310:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st135;
st135:

            if ( ++p == pe )
                goto _test_eof135;

        case 135:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr226;

            case 351:
                goto tr81;

            case 370:
                goto tr226;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr312;

            case 607:
                goto tr100;

            case 626:
                goto tr312;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr311:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st136;
st136:

            if ( ++p == pe )
                goto _test_eof136;

        case 136:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 338:
                goto tr227;

            case 351:
                goto tr81;

            case 370:
                goto tr227;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 594:
                goto tr313;

            case 607:
                goto tr100;

            case 626:
                goto tr313;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr309:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st137;
st137:

            if ( ++p == pe )
                goto _test_eof137;

        case 137:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 340:
                goto st83;

            case 351:
                goto tr81;

            case 372:
                goto st83;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 596:
                goto tr314;

            case 607:
                goto tr100;

            case 628:
                goto tr314;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr314:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st138;
st138:

            if ( ++p == pe )
                goto _test_eof138;

        case 138:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto tr229;

            case 329:
                goto tr230;

            case 351:
                goto tr81;

            case 356:
                goto tr229;

            case 361:
                goto tr230;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr315;

            case 585:
                goto tr316;

            case 607:
                goto tr100;

            case 612:
                goto tr315;

            case 617:
                goto tr316;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr108:

            {
                te = p + 1;
            }

            {
                act = 43;
            }
            goto st139;
st139:

            if ( ++p == pe )
                goto _test_eof139;

        case 139:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 325:
                goto tr232;

            case 335:
                goto tr233;

            case 351:
                goto tr81;

            case 357:
                goto tr232;

            case 367:
                goto tr233;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 581:
                goto tr317;

            case 591:
                goto tr318;

            case 607:
                goto tr100;

            case 613:
                goto tr317;

            case 623:
                goto tr318;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr231;
tr109:

            {
                te = p + 1;
            }

            {
                act = 58;
            }
            goto st140;
st140:

            if ( ++p == pe )
                goto _test_eof140;

        case 140:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 325:
                goto st86;

            case 332:
                goto st88;

            case 338:
                goto st89;

            case 339:
                goto st90;

            case 351:
                goto tr81;

            case 357:
                goto st86;

            case 364:
                goto st88;

            case 370:
                goto st89;

            case 371:
                goto st90;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 581:
                goto tr319;

            case 588:
                goto tr320;

            case 594:
                goto tr321;

            case 595:
                goto tr322;

            case 607:
                goto tr100;

            case 613:
                goto tr319;

            case 620:
                goto tr320;

            case 626:
                goto tr321;

            case 627:
                goto tr322;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr234;
tr319:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st141;
st141:

            if ( ++p == pe )
                goto _test_eof141;

        case 141:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 340:
                goto st87;

            case 351:
                goto tr81;

            case 372:
                goto st87;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 596:
                goto tr323;

            case 607:
                goto tr100;

            case 628:
                goto tr323;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr323:

            {
                te = p + 1;
            }

            {
                act = 109;
            }
            goto st142;
st142:

            if ( ++p == pe )
                goto _test_eof142;

        case 142:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 329:
                goto tr241;

            case 334:
                goto tr242;

            case 351:
                goto tr81;

            case 361:
                goto tr241;

            case 366:
                goto tr242;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 585:
                goto tr324;

            case 590:
                goto tr325;

            case 607:
                goto tr100;

            case 617:
                goto tr324;

            case 622:
                goto tr325;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr240;
tr320:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st143;
st143:

            if ( ++p == pe )
                goto _test_eof143;

        case 143:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto tr243;

            case 351:
                goto tr81;

            case 356:
                goto tr243;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr326;

            case 607:
                goto tr100;

            case 612:
                goto tr326;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr321:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st144;
st144:

            if ( ++p == pe )
                goto _test_eof144;

        case 144:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 324:
                goto tr244;

            case 351:
                goto tr81;

            case 356:
                goto tr244;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 580:
                goto tr327;

            case 607:
                goto tr100;

            case 612:
                goto tr327;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr322:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st145;
st145:

            if ( ++p == pe )
                goto _test_eof145;

        case 145:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 340:
                goto tr245;

            case 351:
                goto tr81;

            case 372:
                goto tr245;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 596:
                goto tr328;

            case 607:
                goto tr100;

            case 628:
                goto tr328;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr110:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st146;
st146:

            if ( ++p == pe )
                goto _test_eof146;

        case 146:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 323:
                goto st92;

            case 336:
                goto tr247;

            case 351:
                goto tr81;

            case 355:
                goto st92;

            case 368:
                goto tr247;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 579:
                goto tr329;

            case 592:
                goto tr330;

            case 607:
                goto tr100;

            case 611:
                goto tr329;

            case 624:
                goto tr330;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
tr329:

            {
                te = p + 1;
            }

            {
                act = 118;
            }
            goto st147;
st147:

            if ( ++p == pe )
                goto _test_eof147;

        case 147:

            _widec = ( *p );

            if ( ( *p ) < 58 )
            {
                if ( ( *p ) < 32 )
                {
                    if ( 9 <= ( *p ) && ( *p ) <= 9 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 32 )
                {
                    if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else if ( ( *p ) > 58 )
            {
                if ( ( *p ) < 95 )
                {
                    if ( 65 <= ( *p ) && ( *p ) <= 90 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else if ( ( *p ) > 95 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    {
                        _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                        if (

                            at_bol ) _widec += 256;
                    }
                }
                else
                {
                    _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                    if (

                        at_bol ) _widec += 256;
                }
            }
            else
            {
                _widec = ( short )( 128 + ( ( *p ) - -128 ) );

                if (

                    at_bol ) _widec += 256;
            }

            switch ( _widec )
            {
            case 326:
                goto tr248;

            case 351:
                goto tr81;

            case 358:
                goto tr248;

            case 521:
                goto st20;

            case 544:
                goto st20;

            case 570:
                goto tr38;

            case 582:
                goto tr331;

            case 607:
                goto tr100;

            case 614:
                goto tr331;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto tr81;
                }
                else if ( _widec >= 304 )
                    goto tr81;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr100;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr100;
                }
                else
                    goto tr100;
            }
            else
                goto tr81;

            goto tr148;
        }

_test_eof21:
        cs = 21;
        goto _test_eof;
_test_eof22:
        cs = 22;
        goto _test_eof;
_test_eof23:
        cs = 23;
        goto _test_eof;
_test_eof24:
        cs = 24;
        goto _test_eof;
_test_eof25:
        cs = 25;
        goto _test_eof;
_test_eof1:
        cs = 1;
        goto _test_eof;
_test_eof2:
        cs = 2;
        goto _test_eof;
_test_eof3:
        cs = 3;
        goto _test_eof;
_test_eof4:
        cs = 4;
        goto _test_eof;
_test_eof5:
        cs = 5;
        goto _test_eof;
_test_eof6:
        cs = 6;
        goto _test_eof;
_test_eof7:
        cs = 7;
        goto _test_eof;
_test_eof8:
        cs = 8;
        goto _test_eof;
_test_eof9:
        cs = 9;
        goto _test_eof;
_test_eof10:
        cs = 10;
        goto _test_eof;
_test_eof11:
        cs = 11;
        goto _test_eof;
_test_eof12:
        cs = 12;
        goto _test_eof;
_test_eof13:
        cs = 13;
        goto _test_eof;
_test_eof26:
        cs = 26;
        goto _test_eof;
_test_eof27:
        cs = 27;
        goto _test_eof;
_test_eof28:
        cs = 28;
        goto _test_eof;
_test_eof29:
        cs = 29;
        goto _test_eof;
_test_eof14:
        cs = 14;
        goto _test_eof;
_test_eof30:
        cs = 30;
        goto _test_eof;
_test_eof31:
        cs = 31;
        goto _test_eof;
_test_eof15:
        cs = 15;
        goto _test_eof;
_test_eof32:
        cs = 32;
        goto _test_eof;
_test_eof33:
        cs = 33;
        goto _test_eof;
_test_eof34:
        cs = 34;
        goto _test_eof;
_test_eof35:
        cs = 35;
        goto _test_eof;
_test_eof36:
        cs = 36;
        goto _test_eof;
_test_eof37:
        cs = 37;
        goto _test_eof;
_test_eof16:
        cs = 16;
        goto _test_eof;
_test_eof17:
        cs = 17;
        goto _test_eof;
_test_eof38:
        cs = 38;
        goto _test_eof;
_test_eof39:
        cs = 39;
        goto _test_eof;
_test_eof40:
        cs = 40;
        goto _test_eof;
_test_eof41:
        cs = 41;
        goto _test_eof;
_test_eof42:
        cs = 42;
        goto _test_eof;
_test_eof43:
        cs = 43;
        goto _test_eof;
_test_eof44:
        cs = 44;
        goto _test_eof;
_test_eof45:
        cs = 45;
        goto _test_eof;
_test_eof46:
        cs = 46;
        goto _test_eof;
_test_eof47:
        cs = 47;
        goto _test_eof;
_test_eof48:
        cs = 48;
        goto _test_eof;
_test_eof49:
        cs = 49;
        goto _test_eof;
_test_eof50:
        cs = 50;
        goto _test_eof;
_test_eof51:
        cs = 51;
        goto _test_eof;
_test_eof52:
        cs = 52;
        goto _test_eof;
_test_eof53:
        cs = 53;
        goto _test_eof;
_test_eof54:
        cs = 54;
        goto _test_eof;
_test_eof55:
        cs = 55;
        goto _test_eof;
_test_eof56:
        cs = 56;
        goto _test_eof;
_test_eof18:
        cs = 18;
        goto _test_eof;
_test_eof57:
        cs = 57;
        goto _test_eof;
_test_eof58:
        cs = 58;
        goto _test_eof;
_test_eof59:
        cs = 59;
        goto _test_eof;
_test_eof60:
        cs = 60;
        goto _test_eof;
_test_eof61:
        cs = 61;
        goto _test_eof;
_test_eof62:
        cs = 62;
        goto _test_eof;
_test_eof63:
        cs = 63;
        goto _test_eof;
_test_eof64:
        cs = 64;
        goto _test_eof;
_test_eof65:
        cs = 65;
        goto _test_eof;
_test_eof66:
        cs = 66;
        goto _test_eof;
_test_eof67:
        cs = 67;
        goto _test_eof;
_test_eof68:
        cs = 68;
        goto _test_eof;
_test_eof69:
        cs = 69;
        goto _test_eof;
_test_eof70:
        cs = 70;
        goto _test_eof;
_test_eof71:
        cs = 71;
        goto _test_eof;
_test_eof72:
        cs = 72;
        goto _test_eof;
_test_eof73:
        cs = 73;
        goto _test_eof;
_test_eof74:
        cs = 74;
        goto _test_eof;
_test_eof75:
        cs = 75;
        goto _test_eof;
_test_eof76:
        cs = 76;
        goto _test_eof;
_test_eof77:
        cs = 77;
        goto _test_eof;
_test_eof78:
        cs = 78;
        goto _test_eof;
_test_eof79:
        cs = 79;
        goto _test_eof;
_test_eof80:
        cs = 80;
        goto _test_eof;
_test_eof81:
        cs = 81;
        goto _test_eof;
_test_eof82:
        cs = 82;
        goto _test_eof;
_test_eof83:
        cs = 83;
        goto _test_eof;
_test_eof84:
        cs = 84;
        goto _test_eof;
_test_eof85:
        cs = 85;
        goto _test_eof;
_test_eof86:
        cs = 86;
        goto _test_eof;
_test_eof87:
        cs = 87;
        goto _test_eof;
_test_eof88:
        cs = 88;
        goto _test_eof;
_test_eof89:
        cs = 89;
        goto _test_eof;
_test_eof90:
        cs = 90;
        goto _test_eof;
_test_eof91:
        cs = 91;
        goto _test_eof;
_test_eof92:
        cs = 92;
        goto _test_eof;
_test_eof93:
        cs = 93;
        goto _test_eof;
_test_eof19:
        cs = 19;
        goto _test_eof;
_test_eof94:
        cs = 94;
        goto _test_eof;
_test_eof95:
        cs = 95;
        goto _test_eof;
_test_eof20:
        cs = 20;
        goto _test_eof;
_test_eof96:
        cs = 96;
        goto _test_eof;
_test_eof97:
        cs = 97;
        goto _test_eof;
_test_eof98:
        cs = 98;
        goto _test_eof;
_test_eof99:
        cs = 99;
        goto _test_eof;
_test_eof100:
        cs = 100;
        goto _test_eof;
_test_eof101:
        cs = 101;
        goto _test_eof;
_test_eof102:
        cs = 102;
        goto _test_eof;
_test_eof103:
        cs = 103;
        goto _test_eof;
_test_eof104:
        cs = 104;
        goto _test_eof;
_test_eof105:
        cs = 105;
        goto _test_eof;
_test_eof106:
        cs = 106;
        goto _test_eof;
_test_eof107:
        cs = 107;
        goto _test_eof;
_test_eof108:
        cs = 108;
        goto _test_eof;
_test_eof109:
        cs = 109;
        goto _test_eof;
_test_eof110:
        cs = 110;
        goto _test_eof;
_test_eof111:
        cs = 111;
        goto _test_eof;
_test_eof112:
        cs = 112;
        goto _test_eof;
_test_eof113:
        cs = 113;
        goto _test_eof;
_test_eof114:
        cs = 114;
        goto _test_eof;
_test_eof115:
        cs = 115;
        goto _test_eof;
_test_eof116:
        cs = 116;
        goto _test_eof;
_test_eof117:
        cs = 117;
        goto _test_eof;
_test_eof118:
        cs = 118;
        goto _test_eof;
_test_eof119:
        cs = 119;
        goto _test_eof;
_test_eof120:
        cs = 120;
        goto _test_eof;
_test_eof121:
        cs = 121;
        goto _test_eof;
_test_eof122:
        cs = 122;
        goto _test_eof;
_test_eof123:
        cs = 123;
        goto _test_eof;
_test_eof124:
        cs = 124;
        goto _test_eof;
_test_eof125:
        cs = 125;
        goto _test_eof;
_test_eof126:
        cs = 126;
        goto _test_eof;
_test_eof127:
        cs = 127;
        goto _test_eof;
_test_eof128:
        cs = 128;
        goto _test_eof;
_test_eof129:
        cs = 129;
        goto _test_eof;
_test_eof130:
        cs = 130;
        goto _test_eof;
_test_eof131:
        cs = 131;
        goto _test_eof;
_test_eof132:
        cs = 132;
        goto _test_eof;
_test_eof133:
        cs = 133;
        goto _test_eof;
_test_eof134:
        cs = 134;
        goto _test_eof;
_test_eof135:
        cs = 135;
        goto _test_eof;
_test_eof136:
        cs = 136;
        goto _test_eof;
_test_eof137:
        cs = 137;
        goto _test_eof;
_test_eof138:
        cs = 138;
        goto _test_eof;
_test_eof139:
        cs = 139;
        goto _test_eof;
_test_eof140:
        cs = 140;
        goto _test_eof;
_test_eof141:
        cs = 141;
        goto _test_eof;
_test_eof142:
        cs = 142;
        goto _test_eof;
_test_eof143:
        cs = 143;
        goto _test_eof;
_test_eof144:
        cs = 144;
        goto _test_eof;
_test_eof145:
        cs = 145;
        goto _test_eof;
_test_eof146:
        cs = 146;
        goto _test_eof;
_test_eof147:
        cs = 147;
        goto _test_eof;

_test_eof:
        {}

        if ( p == eof )
        {
            switch ( cs )
            {
            case 22:
                goto tr112;

            case 23:
                goto tr21;

            case 24:
                goto tr115;

            case 25:
                goto tr117;

            case 1:
                goto tr0;

            case 2:
                goto tr0;

            case 3:
                goto tr0;

            case 4:
                goto tr0;

            case 5:
                goto tr0;

            case 6:
                goto tr0;

            case 7:
                goto tr0;

            case 8:
                goto tr0;

            case 9:
                goto tr0;

            case 10:
                goto tr0;

            case 11:
                goto tr0;

            case 12:
                goto tr0;

            case 13:
                goto tr0;

            case 26:
                goto tr118;

            case 27:
                goto tr120;

            case 28:
                goto tr120;

            case 29:
                goto tr120;

            case 14:
                goto tr21;

            case 30:
                goto tr124;

            case 31:
                goto tr21;

            case 15:
                goto tr24;

            case 32:
                goto tr126;

            case 33:
                goto tr127;

            case 34:
                goto tr128;

            case 35:
                goto tr132;

            case 36:
                goto tr134;

            case 37:
                goto tr137;

            case 16:
                goto tr26;

            case 17:
                goto tr26;

            case 38:
                goto tr140;

            case 39:
                goto tr141;

            case 40:
                goto tr143;

            case 41:
                goto tr21;

            case 42:
                goto tr146;

            case 43:
                goto tr148;

            case 44:
                goto tr148;

            case 45:
                goto tr148;

            case 46:
                goto tr152;

            case 47:
                goto tr154;

            case 48:
                goto tr148;

            case 49:
                goto tr148;

            case 50:
                goto tr161;

            case 51:
                goto tr163;

            case 52:
                goto tr165;

            case 53:
                goto tr148;

            case 54:
                goto tr148;

            case 55:
                goto tr148;

            case 56:
                goto tr148;

            case 18:
                goto tr29;

            case 57:
                goto tr175;

            case 58:
                goto tr178;

            case 59:
                goto tr180;

            case 60:
                goto tr182;

            case 61:
                goto tr148;

            case 62:
                goto tr148;

            case 63:
                goto tr187;

            case 64:
                goto tr148;

            case 65:
                goto tr148;

            case 66:
                goto tr196;

            case 67:
                goto tr198;

            case 68:
                goto tr200;

            case 69:
                goto tr203;

            case 70:
                goto tr148;

            case 71:
                goto tr208;

            case 72:
                goto tr148;

            case 73:
                goto tr212;

            case 74:
                goto tr214;

            case 75:
                goto tr148;

            case 76:
                goto tr148;

            case 77:
                goto tr148;

            case 78:
                goto tr148;

            case 79:
                goto tr148;

            case 80:
                goto tr148;

            case 81:
                goto tr148;

            case 82:
                goto tr148;

            case 83:
                goto tr148;

            case 84:
                goto tr231;

            case 85:
                goto tr234;

            case 86:
                goto tr148;

            case 87:
                goto tr240;

            case 88:
                goto tr148;

            case 89:
                goto tr148;

            case 90:
                goto tr148;

            case 91:
                goto tr148;

            case 92:
                goto tr148;

            case 93:
                goto tr249;

            case 19:
                goto tr34;

            case 94:
                goto tr250;

            case 95:
                goto tr143;

            case 20:
                goto tr21;

            case 96:
                goto tr21;

            case 97:
                goto tr146;

            case 98:
                goto tr148;

            case 99:
                goto tr148;

            case 100:
                goto tr148;

            case 101:
                goto tr152;

            case 102:
                goto tr154;

            case 103:
                goto tr148;

            case 104:
                goto tr148;

            case 105:
                goto tr161;

            case 106:
                goto tr163;

            case 107:
                goto tr165;

            case 108:
                goto tr148;

            case 109:
                goto tr148;

            case 110:
                goto tr148;

            case 111:
                goto tr148;

            case 112:
                goto tr175;

            case 113:
                goto tr178;

            case 114:
                goto tr180;

            case 115:
                goto tr182;

            case 116:
                goto tr148;

            case 117:
                goto tr148;

            case 118:
                goto tr187;

            case 119:
                goto tr148;

            case 120:
                goto tr148;

            case 121:
                goto tr196;

            case 122:
                goto tr198;

            case 123:
                goto tr200;

            case 124:
                goto tr203;

            case 125:
                goto tr148;

            case 126:
                goto tr208;

            case 127:
                goto tr148;

            case 128:
                goto tr212;

            case 129:
                goto tr214;

            case 130:
                goto tr148;

            case 131:
                goto tr148;

            case 132:
                goto tr148;

            case 133:
                goto tr148;

            case 134:
                goto tr148;

            case 135:
                goto tr148;

            case 136:
                goto tr148;

            case 137:
                goto tr148;

            case 138:
                goto tr148;

            case 139:
                goto tr231;

            case 140:
                goto tr234;

            case 141:
                goto tr148;

            case 142:
                goto tr240;

            case 143:
                goto tr148;

            case 144:
                goto tr148;

            case 145:
                goto tr148;

            case 146:
                goto tr148;

            case 147:
                goto tr148;
            }
        }

_out:
        {}
    }


    return sym.tok;
}
