




















static const int parser_start = 1;
static const int parser_first_final = 80;
static const int parser_error = 0;

static const int parser_en_main = 1;




static Bool _parse_statement( Bool compile_active )
{
    p = pe = eof = NULL;



    {
        cs = parser_start;
    }



    while ( eof == NULL || eof != pe )
    {
        read_token();



        {
            if ( p == pe )
                goto _test_eof;

            switch ( cs )
            {
            case 1:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 0:
                    goto st80;

                case 4:
                    goto tr2;

                case 12:
                    goto st80;

                case 87:
                    goto st3;

                case 88:
                    goto st4;

                case 89:
                    goto st5;

                case 90:
                    goto st6;

                case 91:
                    goto st7;

                case 92:
                    goto st8;

                case 93:
                    goto st9;

                case 94:
                    goto st10;

                case 95:
                    goto st11;

                case 96:
                    goto st14;

                case 97:
                    goto st15;

                case 98:
                    goto st28;

                case 99:
                    goto st29;

                case 100:
                    goto st30;

                case 101:
                    goto st33;

                case 102:
                    goto st34;

                case 103:
                    goto st35;

                case 104:
                    goto st36;

                case 105:
                    goto st37;

                case 106:
                    goto st56;

                case 107:
                    goto st57;

                case 108:
                    goto st58;

                case 109:
                    goto st59;

                case 110:
                    goto st60;

                case 111:
                    goto st61;

                case 112:
                    goto st62;

                case 113:
                    goto st63;

                case 114:
                    goto st64;

                case 115:
                    goto st65;

                case 116:
                    goto st66;

                case 117:
                    goto st75;

                case 118:
                    goto st76;

                case 119:
                    goto st77;

                case 120:
                    goto st78;

                case 121:
                    goto st79;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr38:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };
                }
                goto st80;
tr39:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_CCF );
                    };
                }
                goto st80;
tr40:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        if ( opts.cpu & CPU_RABBIT ) insert_macro( "extern " "rcmx_cpd" "\n" "call   " "rcmx_cpd" "\n" );
                        else add_opcode( Z80_CPD );
                    }
                }
                goto st80;
tr41:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        if ( opts.cpu & CPU_RABBIT ) insert_macro( "extern " "rcmx_cpdr" "\n" "call   " "rcmx_cpdr" "\n" );
                        else add_opcode( Z80_CPDR );
                    }
                }
                goto st80;
tr42:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        if ( opts.cpu & CPU_RABBIT ) insert_macro( "extern " "rcmx_cpi" "\n" "call   " "rcmx_cpi" "\n" );
                        else add_opcode( Z80_CPI );
                    }
                }
                goto st80;
tr43:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        if ( opts.cpu & CPU_RABBIT ) insert_macro( "extern " "rcmx_cpir" "\n" "call   " "rcmx_cpir" "\n" );
                        else add_opcode( Z80_CPIR );
                    }
                }
                goto st80;
tr44:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_CPL );
                    };
                }
                goto st80;
tr45:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_DAA );
                    };
                }
                goto st80;
tr46:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_DI );
                    };
                }
                goto st80;
tr49:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    {
                        Expr *expr = pop_expr();

                        if ( compile_active ) add_opcode_jr( Z80_DJNZ, expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st80;
tr52:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EI );
                    };
                }
                goto st80;
tr58:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EX_DE_HL );
                    };
                }
                goto st80;
tr62:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EX_AF_AF );
                    };
                }
                goto st80;
tr63:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EX_AF_AF );
                    };
                }
                goto st80;
tr68:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EX_IND_SP_HL );
                    };
                }
                goto st80;
tr69:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EX_IND_SP_IX );
                    };
                }
                goto st80;
tr70:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EX_IND_SP_IY );
                    };
                }
                goto st80;
tr71:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_EXX );
                    };
                }
                goto st80;
tr72:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_HALT );
                    };
                }
                goto st80;
tr75:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    expr_value = pop_eval_expr();
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_IM( expr_value ) );
                    };
                }
                goto st80;
tr78:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_IND );
                    };
                }
                goto st80;
tr79:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_INDR );
                    };
                }
                goto st80;
tr80:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_INI );
                    };
                }
                goto st80;
tr81:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_INIR );
                    };
                }
                goto st80;
tr88:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    {
                        Expr *expr = pop_expr();

                        if ( compile_active ) add_opcode_jr( Z80_JR( FLAG_NONE ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st80;
tr94:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    {
                        Expr *expr = pop_expr();

                        if ( compile_active ) add_opcode_jr( Z80_JR( FLAG_NZ ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st80;
tr100:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    {
                        Expr *expr = pop_expr();

                        if ( compile_active ) add_opcode_jr( Z80_JR( FLAG_Z ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st80;
tr106:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    {
                        Expr *expr = pop_expr();

                        if ( compile_active ) add_opcode_jr( Z80_JR( FLAG_NC ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st80;
tr112:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    {
                        Expr *expr = pop_expr();

                        if ( compile_active ) add_opcode_jr( Z80_JR( FLAG_C ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st80;
tr115:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_LDD );
                    };
                }
                goto st80;
tr116:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_LDDR );
                    };
                }
                goto st80;
tr117:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_LDI );
                    };
                }
                goto st80;
tr118:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_LDIR );
                    };
                }
                goto st80;
tr119:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_NEG );
                    };
                }
                goto st80;
tr120:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_NOP );
                    };
                }
                goto st80;
tr121:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_OTDR );
                    };
                }
                goto st80;
tr122:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_OTIR );
                    };
                }
                goto st80;
tr123:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_OUTD );
                    };
                }
                goto st80;
tr124:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_OUTI );
                    };
                }
                goto st80;
tr125:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_NONE ) );
                    };
                }
                goto st80;
tr134:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_NZ ) );
                    };
                }
                goto st80;
tr135:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_Z ) );
                    };
                }
                goto st80;
tr136:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_NC ) );
                    };
                }
                goto st80;
tr137:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_C ) );
                    };
                }
                goto st80;
tr138:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_PO ) );
                    };
                }
                goto st80;
tr139:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_PE ) );
                    };
                }
                goto st80;
tr140:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_P ) );
                    };
                }
                goto st80;
tr141:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RET( FLAG_M ) );
                    };
                }
                goto st80;
tr142:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RETI );
                    };
                }
                goto st80;
tr143:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_RETN );
                    };
                }
                goto st80;
tr144:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        if ( opts.cpu & CPU_RABBIT ) insert_macro( "extern " "rcmx_rld" "\n" "call   " "rcmx_rld" "\n" );
                        else add_opcode( Z80_RLD );
                    }
                }
                goto st80;
tr145:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        if ( opts.cpu & CPU_RABBIT ) insert_macro( "extern " "rcmx_rrd" "\n" "call   " "rcmx_rrd" "\n" );
                        else add_opcode( Z80_RRD );
                    }
                }
                goto st80;
tr146:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_SCF );
                    };
                }
                goto st80;
st80:

                if ( ++p == pe )
                    goto _test_eof80;

            case 80:

                goto st0;
tr2:

                {
                    stmt_label = p->string;
                }
                goto st2;
st2:

                if ( ++p == pe )
                    goto _test_eof2;

            case 2:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr38;

                case 87:
                    goto st3;

                case 88:
                    goto st4;

                case 89:
                    goto st5;

                case 90:
                    goto st6;

                case 91:
                    goto st7;

                case 92:
                    goto st8;

                case 93:
                    goto st9;

                case 94:
                    goto st10;

                case 95:
                    goto st11;

                case 96:
                    goto st14;

                case 97:
                    goto st15;

                case 98:
                    goto st28;

                case 99:
                    goto st29;

                case 100:
                    goto st30;

                case 101:
                    goto st33;

                case 102:
                    goto st34;

                case 103:
                    goto st35;

                case 104:
                    goto st36;

                case 105:
                    goto st37;

                case 106:
                    goto st56;

                case 107:
                    goto st57;

                case 108:
                    goto st58;

                case 109:
                    goto st59;

                case 110:
                    goto st60;

                case 111:
                    goto st61;

                case 112:
                    goto st62;

                case 113:
                    goto st63;

                case 114:
                    goto st64;

                case 115:
                    goto st65;

                case 116:
                    goto st66;

                case 117:
                    goto st75;

                case 118:
                    goto st76;

                case 119:
                    goto st77;

                case 120:
                    goto st78;

                case 121:
                    goto st79;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr39;

                goto st0;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr40;

                goto st0;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr41;

                goto st0;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr42;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr43;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr44;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr45;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr46;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr47;

                case 5:
                    goto tr47;

                case 8:
                    goto tr47;

                case 18:
                    goto tr48;

                case 21:
                    goto tr48;

                case 23:
                    goto tr48;

                case 36:
                    goto tr48;

                case 44:
                    goto tr48;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr48;

                goto st0;
tr47:

                {
                    expr_start = p;
                }
                goto st12;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr49;

                case 19:
                    goto st12;

                case 23:
                    goto st13;

                case 37:
                    goto st12;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st13;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st13;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st13;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st13;
                }
                else
                    goto st13;

                goto st0;
tr48:

                {
                    expr_start = p;
                }
                goto st13;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st12;

                case 5:
                    goto st12;

                case 8:
                    goto st12;

                case 13:
                    goto st13;

                case 18:
                    goto st13;

                case 21:
                    goto st13;

                case 23:
                    goto st13;

                case 36:
                    goto st13;

                case 44:
                    goto st13;
                }

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr52;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 70:
                    goto st16;

                case 74:
                    goto st19;

                case 82:
                    goto st23;
                }

                goto st0;
st16:

                if ( ++p == pe )
                    goto _test_eof16;

            case 16:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st17;

                goto st0;
st17:

                if ( ++p == pe )
                    goto _test_eof17;

            case 17:
                if ( ( ( ( int ) p->tok ) ) == 71 )
                    goto st18;

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr58;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st20;

                goto st0;
st20:

                if ( ++p == pe )
                    goto _test_eof20;

            case 20:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 74:
                    goto st21;

                case 76:
                    goto st22;
                }

                goto st0;
st21:

                if ( ++p == pe )
                    goto _test_eof21;

            case 21:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr62;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr63;

                goto st0;
st23:

                if ( ++p == pe )
                    goto _test_eof23;

            case 23:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st24;

                goto st0;
st24:

                if ( ++p == pe )
                    goto _test_eof24;

            case 24:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 71:
                    goto st25;

                case 72:
                    goto st26;

                case 73:
                    goto st27;
                }

                goto st0;
st25:

                if ( ++p == pe )
                    goto _test_eof25;

            case 25:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr68;

                goto st0;
st26:

                if ( ++p == pe )
                    goto _test_eof26;

            case 26:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr69;

                goto st0;
st27:

                if ( ++p == pe )
                    goto _test_eof27;

            case 27:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr70;

                goto st0;
st28:

                if ( ++p == pe )
                    goto _test_eof28;

            case 28:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr71;

                goto st0;
st29:

                if ( ++p == pe )
                    goto _test_eof29;

            case 29:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr72;

                goto st0;
st30:

                if ( ++p == pe )
                    goto _test_eof30;

            case 30:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr73;

                case 5:
                    goto tr73;

                case 8:
                    goto tr73;

                case 18:
                    goto tr74;

                case 21:
                    goto tr74;

                case 23:
                    goto tr74;

                case 36:
                    goto tr74;

                case 44:
                    goto tr74;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr74;

                goto st0;
tr73:

                {
                    expr_start = p;
                }
                goto st31;
st31:

                if ( ++p == pe )
                    goto _test_eof31;

            case 31:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr75;

                case 19:
                    goto st31;

                case 23:
                    goto st32;

                case 37:
                    goto st31;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st32;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st32;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st32;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st32;
                }
                else
                    goto st32;

                goto st0;
tr74:

                {
                    expr_start = p;
                }
                goto st32;
st32:

                if ( ++p == pe )
                    goto _test_eof32;

            case 32:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st31;

                case 5:
                    goto st31;

                case 8:
                    goto st31;

                case 13:
                    goto st32;

                case 18:
                    goto st32;

                case 21:
                    goto st32;

                case 23:
                    goto st32;

                case 36:
                    goto st32;

                case 44:
                    goto st32;
                }

                goto st0;
st33:

                if ( ++p == pe )
                    goto _test_eof33;

            case 33:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr78;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr79;

                goto st0;
st35:

                if ( ++p == pe )
                    goto _test_eof35;

            case 35:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr80;

                goto st0;
st36:

                if ( ++p == pe )
                    goto _test_eof36;

            case 36:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr81;

                goto st0;
st37:

                if ( ++p == pe )
                    goto _test_eof37;

            case 37:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr82;

                case 5:
                    goto tr82;

                case 8:
                    goto tr82;

                case 18:
                    goto tr83;

                case 21:
                    goto tr83;

                case 23:
                    goto tr83;

                case 36:
                    goto tr83;

                case 44:
                    goto tr83;

                case 45:
                    goto st40;

                case 46:
                    goto st44;

                case 47:
                    goto st48;

                case 48:
                    goto st52;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr83;

                goto st0;
tr82:

                {
                    expr_start = p;
                }
                goto st38;
st38:

                if ( ++p == pe )
                    goto _test_eof38;

            case 38:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr88;

                case 19:
                    goto st38;

                case 23:
                    goto st39;

                case 37:
                    goto st38;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st39;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st39;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st39;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st39;
                }
                else
                    goto st39;

                goto st0;
tr83:

                {
                    expr_start = p;
                }
                goto st39;
st39:

                if ( ++p == pe )
                    goto _test_eof39;

            case 39:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st38;

                case 5:
                    goto st38;

                case 8:
                    goto st38;

                case 13:
                    goto st39;

                case 18:
                    goto st39;

                case 21:
                    goto st39;

                case 23:
                    goto st39;

                case 36:
                    goto st39;

                case 44:
                    goto st39;
                }

                goto st0;
st40:

                if ( ++p == pe )
                    goto _test_eof40;

            case 40:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st41;

                goto st0;
st41:

                if ( ++p == pe )
                    goto _test_eof41;

            case 41:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr92;

                case 5:
                    goto tr92;

                case 8:
                    goto tr92;

                case 18:
                    goto tr93;

                case 21:
                    goto tr93;

                case 23:
                    goto tr93;

                case 36:
                    goto tr93;

                case 44:
                    goto tr93;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr93;

                goto st0;
tr92:

                {
                    expr_start = p;
                }
                goto st42;
st42:

                if ( ++p == pe )
                    goto _test_eof42;

            case 42:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr94;

                case 19:
                    goto st42;

                case 23:
                    goto st43;

                case 37:
                    goto st42;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st43;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st43;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st43;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st43;
                }
                else
                    goto st43;

                goto st0;
tr93:

                {
                    expr_start = p;
                }
                goto st43;
st43:

                if ( ++p == pe )
                    goto _test_eof43;

            case 43:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st42;

                case 5:
                    goto st42;

                case 8:
                    goto st42;

                case 13:
                    goto st43;

                case 18:
                    goto st43;

                case 21:
                    goto st43;

                case 23:
                    goto st43;

                case 36:
                    goto st43;

                case 44:
                    goto st43;
                }

                goto st0;
st44:

                if ( ++p == pe )
                    goto _test_eof44;

            case 44:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st45;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr98;

                case 5:
                    goto tr98;

                case 8:
                    goto tr98;

                case 18:
                    goto tr99;

                case 21:
                    goto tr99;

                case 23:
                    goto tr99;

                case 36:
                    goto tr99;

                case 44:
                    goto tr99;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr99;

                goto st0;
tr98:

                {
                    expr_start = p;
                }
                goto st46;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr100;

                case 19:
                    goto st46;

                case 23:
                    goto st47;

                case 37:
                    goto st46;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st47;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st47;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st47;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st47;
                }
                else
                    goto st47;

                goto st0;
tr99:

                {
                    expr_start = p;
                }
                goto st47;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st46;

                case 5:
                    goto st46;

                case 8:
                    goto st46;

                case 13:
                    goto st47;

                case 18:
                    goto st47;

                case 21:
                    goto st47;

                case 23:
                    goto st47;

                case 36:
                    goto st47;

                case 44:
                    goto st47;
                }

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st49;

                goto st0;
st49:

                if ( ++p == pe )
                    goto _test_eof49;

            case 49:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr104;

                case 5:
                    goto tr104;

                case 8:
                    goto tr104;

                case 18:
                    goto tr105;

                case 21:
                    goto tr105;

                case 23:
                    goto tr105;

                case 36:
                    goto tr105;

                case 44:
                    goto tr105;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr105;

                goto st0;
tr104:

                {
                    expr_start = p;
                }
                goto st50;
st50:

                if ( ++p == pe )
                    goto _test_eof50;

            case 50:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr106;

                case 19:
                    goto st50;

                case 23:
                    goto st51;

                case 37:
                    goto st50;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st51;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st51;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st51;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st51;
                }
                else
                    goto st51;

                goto st0;
tr105:

                {
                    expr_start = p;
                }
                goto st51;
st51:

                if ( ++p == pe )
                    goto _test_eof51;

            case 51:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st50;

                case 5:
                    goto st50;

                case 8:
                    goto st50;

                case 13:
                    goto st51;

                case 18:
                    goto st51;

                case 21:
                    goto st51;

                case 23:
                    goto st51;

                case 36:
                    goto st51;

                case 44:
                    goto st51;
                }

                goto st0;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st53;

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr110;

                case 5:
                    goto tr110;

                case 8:
                    goto tr110;

                case 18:
                    goto tr111;

                case 21:
                    goto tr111;

                case 23:
                    goto tr111;

                case 36:
                    goto tr111;

                case 44:
                    goto tr111;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr111;

                goto st0;
tr110:

                {
                    expr_start = p;
                }
                goto st54;
st54:

                if ( ++p == pe )
                    goto _test_eof54;

            case 54:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr112;

                case 19:
                    goto st54;

                case 23:
                    goto st55;

                case 37:
                    goto st54;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st55;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st55;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st55;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st55;
                }
                else
                    goto st55;

                goto st0;
tr111:

                {
                    expr_start = p;
                }
                goto st55;
st55:

                if ( ++p == pe )
                    goto _test_eof55;

            case 55:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st54;

                case 5:
                    goto st54;

                case 8:
                    goto st54;

                case 13:
                    goto st55;

                case 18:
                    goto st55;

                case 21:
                    goto st55;

                case 23:
                    goto st55;

                case 36:
                    goto st55;

                case 44:
                    goto st55;
                }

                goto st0;
st56:

                if ( ++p == pe )
                    goto _test_eof56;

            case 56:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr115;

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr116;

                goto st0;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr117;

                goto st0;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr118;

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr119;

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr120;

                goto st0;
st62:

                if ( ++p == pe )
                    goto _test_eof62;

            case 62:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr121;

                goto st0;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr122;

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr123;

                goto st0;
st65:

                if ( ++p == pe )
                    goto _test_eof65;

            case 65:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr124;

                goto st0;
st66:

                if ( ++p == pe )
                    goto _test_eof66;

            case 66:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr125;

                case 45:
                    goto st67;

                case 46:
                    goto st68;

                case 47:
                    goto st69;

                case 48:
                    goto st70;

                case 49:
                    goto st71;

                case 50:
                    goto st72;

                case 51:
                    goto st73;

                case 52:
                    goto st74;
                }

                goto st0;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr134;

                goto st0;
st68:

                if ( ++p == pe )
                    goto _test_eof68;

            case 68:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr135;

                goto st0;
st69:

                if ( ++p == pe )
                    goto _test_eof69;

            case 69:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr136;

                goto st0;
st70:

                if ( ++p == pe )
                    goto _test_eof70;

            case 70:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr137;

                goto st0;
st71:

                if ( ++p == pe )
                    goto _test_eof71;

            case 71:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr138;

                goto st0;
st72:

                if ( ++p == pe )
                    goto _test_eof72;

            case 72:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr139;

                goto st0;
st73:

                if ( ++p == pe )
                    goto _test_eof73;

            case 73:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr140;

                goto st0;
st74:

                if ( ++p == pe )
                    goto _test_eof74;

            case 74:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr141;

                goto st0;
st75:

                if ( ++p == pe )
                    goto _test_eof75;

            case 75:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr142;

                goto st0;
st76:

                if ( ++p == pe )
                    goto _test_eof76;

            case 76:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr143;

                goto st0;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr144;

                goto st0;
st78:

                if ( ++p == pe )
                    goto _test_eof78;

            case 78:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr145;

                goto st0;
st79:

                if ( ++p == pe )
                    goto _test_eof79;

            case 79:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr146;

                goto st0;
            }

_test_eof80:
            cs = 80;
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
_test_eof14:
            cs = 14;
            goto _test_eof;
_test_eof15:
            cs = 15;
            goto _test_eof;
_test_eof16:
            cs = 16;
            goto _test_eof;
_test_eof17:
            cs = 17;
            goto _test_eof;
_test_eof18:
            cs = 18;
            goto _test_eof;
_test_eof19:
            cs = 19;
            goto _test_eof;
_test_eof20:
            cs = 20;
            goto _test_eof;
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
_test_eof30:
            cs = 30;
            goto _test_eof;
_test_eof31:
            cs = 31;
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

_test_eof:
            {}
_out:
            {}
        }




        if ( cs ==

                0

           )
            return FALSE;

        if ( cs >=

                80

           )
            return TRUE;
    }

    return FALSE;
}
