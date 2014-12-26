




















static const int parser_start = 1;
static const int parser_first_final = 123;
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
                    goto st123;

                case 4:
                    goto tr2;

                case 12:
                    goto st123;

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
                    goto st77;

                case 107:
                    goto st96;

                case 108:
                    goto st97;

                case 109:
                    goto st98;

                case 110:
                    goto st99;

                case 111:
                    goto st100;

                case 112:
                    goto st101;

                case 113:
                    goto st102;

                case 114:
                    goto st103;

                case 115:
                    goto st104;

                case 116:
                    goto st105;

                case 117:
                    goto st106;

                case 118:
                    goto st115;

                case 119:
                    goto st116;

                case 120:
                    goto st117;

                case 121:
                    goto st118;

                case 122:
                    goto st119;

                case 123:
                    goto st122;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr40:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };
                }
                goto st123;
tr41:

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
                goto st123;
tr42:

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
                goto st123;
tr43:

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
                goto st123;
tr44:

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
                goto st123;
tr45:

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
                goto st123;
tr46:

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
                goto st123;
tr47:

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
                goto st123;
tr48:

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
                goto st123;
tr51:

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
                goto st123;
tr54:

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
                goto st123;
tr60:

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
                goto st123;
tr64:

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
                goto st123;
tr65:

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
                goto st123;
tr70:

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
                goto st123;
tr71:

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
                goto st123;
tr72:

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
                goto st123;
tr73:

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
                goto st123;
tr74:

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
                goto st123;
tr77:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }

                {
                    if ( !expr_error )
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
                }
                goto st123;
tr80:

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
                goto st123;
tr81:

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
                goto st123;
tr82:

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
                goto st123;
tr83:

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
                goto st123;
tr97:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_NONE ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr103:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_NZ ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr109:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_Z ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr115:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_NC ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr121:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_C ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr127:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_PO ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr133:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_PE ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr139:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_P ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr145:

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

                        if ( compile_active ) add_opcode_nn( Z80_JP( FLAG_M ), expr );
                        else OBJ_DELETE( expr );
                    };
                }
                goto st123;
tr148:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_JP_IND_HL );
                    };
                }
                goto st123;
tr150:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_JP_IND_IX );
                    };
                }
                goto st123;
tr152:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };

                    if ( compile_active )
                    {
                        add_opcode( Z80_JP_IND_IY );
                    };
                }
                goto st123;
tr159:

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
                goto st123;
tr165:

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
                goto st123;
tr171:

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
                goto st123;
tr177:

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
                goto st123;
tr183:

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
                goto st123;
tr186:

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
                goto st123;
tr187:

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
                goto st123;
tr188:

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
                goto st123;
tr189:

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
                goto st123;
tr190:

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
                goto st123;
tr191:

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
                goto st123;
tr192:

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
                goto st123;
tr193:

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
                goto st123;
tr194:

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
                goto st123;
tr195:

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
                goto st123;
tr196:

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
                goto st123;
tr205:

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
                goto st123;
tr206:

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
                goto st123;
tr207:

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
                goto st123;
tr208:

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
                goto st123;
tr209:

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
                goto st123;
tr210:

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
                goto st123;
tr211:

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
                goto st123;
tr212:

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
                goto st123;
tr213:

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
                goto st123;
tr214:

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
                goto st123;
tr215:

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
                goto st123;
tr216:

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
                goto st123;
tr219:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }

                {
                    if ( !expr_error )
                    {
                        if ( compile_active && stmt_label )
                        {
                            define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                        };

                        if ( compile_active )
                        {
                            add_opcode( Z80_RST( expr_value ) );
                        };
                    }
                }
                goto st123;
tr222:

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
                goto st123;
st123:

                if ( ++p == pe )
                    goto _test_eof123;

            case 123:

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
                    goto tr40;

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
                    goto st77;

                case 107:
                    goto st96;

                case 108:
                    goto st97;

                case 109:
                    goto st98;

                case 110:
                    goto st99;

                case 111:
                    goto st100;

                case 112:
                    goto st101;

                case 113:
                    goto st102;

                case 114:
                    goto st103;

                case 115:
                    goto st104;

                case 116:
                    goto st105;

                case 117:
                    goto st106;

                case 118:
                    goto st115;

                case 119:
                    goto st116;

                case 120:
                    goto st117;

                case 121:
                    goto st118;

                case 122:
                    goto st119;

                case 123:
                    goto st122;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr41;

                goto st0;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr42;

                goto st0;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr43;

                goto st0;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr44;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr45;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr46;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr47;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr48;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr49;

                case 5:
                    goto tr49;

                case 8:
                    goto tr49;

                case 18:
                    goto tr50;

                case 21:
                    goto tr50;

                case 23:
                    goto tr50;

                case 36:
                    goto tr50;

                case 44:
                    goto tr50;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr50;

                goto st0;
tr49:

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
                    goto tr51;

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
tr50:

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
                    goto tr54;

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
                    goto tr60;

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
                    goto tr64;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr65;

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
                    goto tr70;

                goto st0;
st26:

                if ( ++p == pe )
                    goto _test_eof26;

            case 26:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr71;

                goto st0;
st27:

                if ( ++p == pe )
                    goto _test_eof27;

            case 27:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr72;

                goto st0;
st28:

                if ( ++p == pe )
                    goto _test_eof28;

            case 28:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr73;

                goto st0;
st29:

                if ( ++p == pe )
                    goto _test_eof29;

            case 29:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr74;

                goto st0;
st30:

                if ( ++p == pe )
                    goto _test_eof30;

            case 30:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr75;

                case 5:
                    goto tr75;

                case 8:
                    goto tr75;

                case 18:
                    goto tr76;

                case 21:
                    goto tr76;

                case 23:
                    goto tr76;

                case 36:
                    goto tr76;

                case 44:
                    goto tr76;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr76;

                goto st0;
tr75:

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
                    goto tr77;

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
tr76:

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
                    goto tr80;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr81;

                goto st0;
st35:

                if ( ++p == pe )
                    goto _test_eof35;

            case 35:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr82;

                goto st0;
st36:

                if ( ++p == pe )
                    goto _test_eof36;

            case 36:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr83;

                goto st0;
st37:

                if ( ++p == pe )
                    goto _test_eof37;

            case 37:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr84;

                case 5:
                    goto tr84;

                case 8:
                    goto tr84;

                case 18:
                    goto tr85;

                case 21:
                    goto tr85;

                case 23:
                    goto tr85;

                case 36:
                    goto tr85;

                case 44:
                    goto tr85;

                case 45:
                    goto st40;

                case 46:
                    goto st44;

                case 47:
                    goto st48;

                case 48:
                    goto st52;

                case 49:
                    goto st56;

                case 50:
                    goto st60;

                case 51:
                    goto st64;

                case 52:
                    goto st68;

                case 79:
                    goto st72;

                case 80:
                    goto st73;

                case 81:
                    goto st75;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr85;

                goto st0;
tr84:

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
                    goto tr97;

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
tr85:

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
                    goto tr101;

                case 5:
                    goto tr101;

                case 8:
                    goto tr101;

                case 18:
                    goto tr102;

                case 21:
                    goto tr102;

                case 23:
                    goto tr102;

                case 36:
                    goto tr102;

                case 44:
                    goto tr102;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr102;

                goto st0;
tr101:

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
                    goto tr103;

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
tr102:

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
                    goto tr107;

                case 5:
                    goto tr107;

                case 8:
                    goto tr107;

                case 18:
                    goto tr108;

                case 21:
                    goto tr108;

                case 23:
                    goto tr108;

                case 36:
                    goto tr108;

                case 44:
                    goto tr108;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr108;

                goto st0;
tr107:

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
                    goto tr109;

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
tr108:

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
                    goto tr113;

                case 5:
                    goto tr113;

                case 8:
                    goto tr113;

                case 18:
                    goto tr114;

                case 21:
                    goto tr114;

                case 23:
                    goto tr114;

                case 36:
                    goto tr114;

                case 44:
                    goto tr114;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr114;

                goto st0;
tr113:

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
                    goto tr115;

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
tr114:

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
                    goto tr119;

                case 5:
                    goto tr119;

                case 8:
                    goto tr119;

                case 18:
                    goto tr120;

                case 21:
                    goto tr120;

                case 23:
                    goto tr120;

                case 36:
                    goto tr120;

                case 44:
                    goto tr120;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr120;

                goto st0;
tr119:

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
                    goto tr121;

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
tr120:

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st57;

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr125;

                case 5:
                    goto tr125;

                case 8:
                    goto tr125;

                case 18:
                    goto tr126;

                case 21:
                    goto tr126;

                case 23:
                    goto tr126;

                case 36:
                    goto tr126;

                case 44:
                    goto tr126;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr126;

                goto st0;
tr125:

                {
                    expr_start = p;
                }
                goto st58;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr127;

                case 19:
                    goto st58;

                case 23:
                    goto st59;

                case 37:
                    goto st58;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st59;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st59;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st59;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st59;
                }
                else
                    goto st59;

                goto st0;
tr126:

                {
                    expr_start = p;
                }
                goto st59;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st58;

                case 5:
                    goto st58;

                case 8:
                    goto st58;

                case 13:
                    goto st59;

                case 18:
                    goto st59;

                case 21:
                    goto st59;

                case 23:
                    goto st59;

                case 36:
                    goto st59;

                case 44:
                    goto st59;
                }

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st61;

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr131;

                case 5:
                    goto tr131;

                case 8:
                    goto tr131;

                case 18:
                    goto tr132;

                case 21:
                    goto tr132;

                case 23:
                    goto tr132;

                case 36:
                    goto tr132;

                case 44:
                    goto tr132;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr132;

                goto st0;
tr131:

                {
                    expr_start = p;
                }
                goto st62;
st62:

                if ( ++p == pe )
                    goto _test_eof62;

            case 62:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr133;

                case 19:
                    goto st62;

                case 23:
                    goto st63;

                case 37:
                    goto st62;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st63;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st63;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st63;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st63;
                }
                else
                    goto st63;

                goto st0;
tr132:

                {
                    expr_start = p;
                }
                goto st63;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st62;

                case 5:
                    goto st62;

                case 8:
                    goto st62;

                case 13:
                    goto st63;

                case 18:
                    goto st63;

                case 21:
                    goto st63;

                case 23:
                    goto st63;

                case 36:
                    goto st63;

                case 44:
                    goto st63;
                }

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st65;

                goto st0;
st65:

                if ( ++p == pe )
                    goto _test_eof65;

            case 65:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr137;

                case 5:
                    goto tr137;

                case 8:
                    goto tr137;

                case 18:
                    goto tr138;

                case 21:
                    goto tr138;

                case 23:
                    goto tr138;

                case 36:
                    goto tr138;

                case 44:
                    goto tr138;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr138;

                goto st0;
tr137:

                {
                    expr_start = p;
                }
                goto st66;
st66:

                if ( ++p == pe )
                    goto _test_eof66;

            case 66:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr139;

                case 19:
                    goto st66;

                case 23:
                    goto st67;

                case 37:
                    goto st66;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st67;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st67;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st67;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st67;
                }
                else
                    goto st67;

                goto st0;
tr138:

                {
                    expr_start = p;
                }
                goto st67;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st66;

                case 5:
                    goto st66;

                case 8:
                    goto st66;

                case 13:
                    goto st67;

                case 18:
                    goto st67;

                case 21:
                    goto st67;

                case 23:
                    goto st67;

                case 36:
                    goto st67;

                case 44:
                    goto st67;
                }

                goto st0;
st68:

                if ( ++p == pe )
                    goto _test_eof68;

            case 68:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st69;

                goto st0;
st69:

                if ( ++p == pe )
                    goto _test_eof69;

            case 69:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr143;

                case 5:
                    goto tr143;

                case 8:
                    goto tr143;

                case 18:
                    goto tr144;

                case 21:
                    goto tr144;

                case 23:
                    goto tr144;

                case 36:
                    goto tr144;

                case 44:
                    goto tr144;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr144;

                goto st0;
tr143:

                {
                    expr_start = p;
                }
                goto st70;
st70:

                if ( ++p == pe )
                    goto _test_eof70;

            case 70:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr145;

                case 19:
                    goto st70;

                case 23:
                    goto st71;

                case 37:
                    goto st70;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st71;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st71;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st71;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st71;
                }
                else
                    goto st71;

                goto st0;
tr144:

                {
                    expr_start = p;
                }
                goto st71;
st71:

                if ( ++p == pe )
                    goto _test_eof71;

            case 71:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st70;

                case 5:
                    goto st70;

                case 8:
                    goto st70;

                case 13:
                    goto st71;

                case 18:
                    goto st71;

                case 21:
                    goto st71;

                case 23:
                    goto st71;

                case 36:
                    goto st71;

                case 44:
                    goto st71;
                }

                goto st0;
st72:

                if ( ++p == pe )
                    goto _test_eof72;

            case 72:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr148;

                goto st0;
st73:

                if ( ++p == pe )
                    goto _test_eof73;

            case 73:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st74;

                goto st0;
st74:

                if ( ++p == pe )
                    goto _test_eof74;

            case 74:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr150;

                goto st0;
st75:

                if ( ++p == pe )
                    goto _test_eof75;

            case 75:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st76;

                goto st0;
st76:

                if ( ++p == pe )
                    goto _test_eof76;

            case 76:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr152;

                goto st0;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr153;

                case 5:
                    goto tr153;

                case 8:
                    goto tr153;

                case 18:
                    goto tr154;

                case 21:
                    goto tr154;

                case 23:
                    goto tr154;

                case 36:
                    goto tr154;

                case 44:
                    goto tr154;

                case 45:
                    goto st80;

                case 46:
                    goto st84;

                case 47:
                    goto st88;

                case 48:
                    goto st92;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr154;

                goto st0;
tr153:

                {
                    expr_start = p;
                }
                goto st78;
st78:

                if ( ++p == pe )
                    goto _test_eof78;

            case 78:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr159;

                case 19:
                    goto st78;

                case 23:
                    goto st79;

                case 37:
                    goto st78;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st79;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st79;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st79;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st79;
                }
                else
                    goto st79;

                goto st0;
tr154:

                {
                    expr_start = p;
                }
                goto st79;
st79:

                if ( ++p == pe )
                    goto _test_eof79;

            case 79:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st78;

                case 5:
                    goto st78;

                case 8:
                    goto st78;

                case 13:
                    goto st79;

                case 18:
                    goto st79;

                case 21:
                    goto st79;

                case 23:
                    goto st79;

                case 36:
                    goto st79;

                case 44:
                    goto st79;
                }

                goto st0;
st80:

                if ( ++p == pe )
                    goto _test_eof80;

            case 80:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st81;

                goto st0;
st81:

                if ( ++p == pe )
                    goto _test_eof81;

            case 81:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr163;

                case 5:
                    goto tr163;

                case 8:
                    goto tr163;

                case 18:
                    goto tr164;

                case 21:
                    goto tr164;

                case 23:
                    goto tr164;

                case 36:
                    goto tr164;

                case 44:
                    goto tr164;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr164;

                goto st0;
tr163:

                {
                    expr_start = p;
                }
                goto st82;
st82:

                if ( ++p == pe )
                    goto _test_eof82;

            case 82:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr165;

                case 19:
                    goto st82;

                case 23:
                    goto st83;

                case 37:
                    goto st82;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st83;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st83;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st83;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st83;
                }
                else
                    goto st83;

                goto st0;
tr164:

                {
                    expr_start = p;
                }
                goto st83;
st83:

                if ( ++p == pe )
                    goto _test_eof83;

            case 83:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st82;

                case 5:
                    goto st82;

                case 8:
                    goto st82;

                case 13:
                    goto st83;

                case 18:
                    goto st83;

                case 21:
                    goto st83;

                case 23:
                    goto st83;

                case 36:
                    goto st83;

                case 44:
                    goto st83;
                }

                goto st0;
st84:

                if ( ++p == pe )
                    goto _test_eof84;

            case 84:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st85;

                goto st0;
st85:

                if ( ++p == pe )
                    goto _test_eof85;

            case 85:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr169;

                case 5:
                    goto tr169;

                case 8:
                    goto tr169;

                case 18:
                    goto tr170;

                case 21:
                    goto tr170;

                case 23:
                    goto tr170;

                case 36:
                    goto tr170;

                case 44:
                    goto tr170;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr170;

                goto st0;
tr169:

                {
                    expr_start = p;
                }
                goto st86;
st86:

                if ( ++p == pe )
                    goto _test_eof86;

            case 86:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr171;

                case 19:
                    goto st86;

                case 23:
                    goto st87;

                case 37:
                    goto st86;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st87;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st87;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st87;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st87;
                }
                else
                    goto st87;

                goto st0;
tr170:

                {
                    expr_start = p;
                }
                goto st87;
st87:

                if ( ++p == pe )
                    goto _test_eof87;

            case 87:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st86;

                case 5:
                    goto st86;

                case 8:
                    goto st86;

                case 13:
                    goto st87;

                case 18:
                    goto st87;

                case 21:
                    goto st87;

                case 23:
                    goto st87;

                case 36:
                    goto st87;

                case 44:
                    goto st87;
                }

                goto st0;
st88:

                if ( ++p == pe )
                    goto _test_eof88;

            case 88:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st89;

                goto st0;
st89:

                if ( ++p == pe )
                    goto _test_eof89;

            case 89:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr175;

                case 5:
                    goto tr175;

                case 8:
                    goto tr175;

                case 18:
                    goto tr176;

                case 21:
                    goto tr176;

                case 23:
                    goto tr176;

                case 36:
                    goto tr176;

                case 44:
                    goto tr176;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr176;

                goto st0;
tr175:

                {
                    expr_start = p;
                }
                goto st90;
st90:

                if ( ++p == pe )
                    goto _test_eof90;

            case 90:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr177;

                case 19:
                    goto st90;

                case 23:
                    goto st91;

                case 37:
                    goto st90;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st91;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st91;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st91;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st91;
                }
                else
                    goto st91;

                goto st0;
tr176:

                {
                    expr_start = p;
                }
                goto st91;
st91:

                if ( ++p == pe )
                    goto _test_eof91;

            case 91:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st90;

                case 5:
                    goto st90;

                case 8:
                    goto st90;

                case 13:
                    goto st91;

                case 18:
                    goto st91;

                case 21:
                    goto st91;

                case 23:
                    goto st91;

                case 36:
                    goto st91;

                case 44:
                    goto st91;
                }

                goto st0;
st92:

                if ( ++p == pe )
                    goto _test_eof92;

            case 92:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st93;

                goto st0;
st93:

                if ( ++p == pe )
                    goto _test_eof93;

            case 93:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr181;

                case 5:
                    goto tr181;

                case 8:
                    goto tr181;

                case 18:
                    goto tr182;

                case 21:
                    goto tr182;

                case 23:
                    goto tr182;

                case 36:
                    goto tr182;

                case 44:
                    goto tr182;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr182;

                goto st0;
tr181:

                {
                    expr_start = p;
                }
                goto st94;
st94:

                if ( ++p == pe )
                    goto _test_eof94;

            case 94:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr183;

                case 19:
                    goto st94;

                case 23:
                    goto st95;

                case 37:
                    goto st94;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st95;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st95;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st95;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st95;
                }
                else
                    goto st95;

                goto st0;
tr182:

                {
                    expr_start = p;
                }
                goto st95;
st95:

                if ( ++p == pe )
                    goto _test_eof95;

            case 95:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st94;

                case 5:
                    goto st94;

                case 8:
                    goto st94;

                case 13:
                    goto st95;

                case 18:
                    goto st95;

                case 21:
                    goto st95;

                case 23:
                    goto st95;

                case 36:
                    goto st95;

                case 44:
                    goto st95;
                }

                goto st0;
st96:

                if ( ++p == pe )
                    goto _test_eof96;

            case 96:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr186;

                goto st0;
st97:

                if ( ++p == pe )
                    goto _test_eof97;

            case 97:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr187;

                goto st0;
st98:

                if ( ++p == pe )
                    goto _test_eof98;

            case 98:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr188;

                goto st0;
st99:

                if ( ++p == pe )
                    goto _test_eof99;

            case 99:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr189;

                goto st0;
st100:

                if ( ++p == pe )
                    goto _test_eof100;

            case 100:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr190;

                goto st0;
st101:

                if ( ++p == pe )
                    goto _test_eof101;

            case 101:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr191;

                goto st0;
st102:

                if ( ++p == pe )
                    goto _test_eof102;

            case 102:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr192;

                goto st0;
st103:

                if ( ++p == pe )
                    goto _test_eof103;

            case 103:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr193;

                goto st0;
st104:

                if ( ++p == pe )
                    goto _test_eof104;

            case 104:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr194;

                goto st0;
st105:

                if ( ++p == pe )
                    goto _test_eof105;

            case 105:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr195;

                goto st0;
st106:

                if ( ++p == pe )
                    goto _test_eof106;

            case 106:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr196;

                case 45:
                    goto st107;

                case 46:
                    goto st108;

                case 47:
                    goto st109;

                case 48:
                    goto st110;

                case 49:
                    goto st111;

                case 50:
                    goto st112;

                case 51:
                    goto st113;

                case 52:
                    goto st114;
                }

                goto st0;
st107:

                if ( ++p == pe )
                    goto _test_eof107;

            case 107:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr205;

                goto st0;
st108:

                if ( ++p == pe )
                    goto _test_eof108;

            case 108:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr206;

                goto st0;
st109:

                if ( ++p == pe )
                    goto _test_eof109;

            case 109:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr207;

                goto st0;
st110:

                if ( ++p == pe )
                    goto _test_eof110;

            case 110:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr208;

                goto st0;
st111:

                if ( ++p == pe )
                    goto _test_eof111;

            case 111:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr209;

                goto st0;
st112:

                if ( ++p == pe )
                    goto _test_eof112;

            case 112:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr210;

                goto st0;
st113:

                if ( ++p == pe )
                    goto _test_eof113;

            case 113:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr211;

                goto st0;
st114:

                if ( ++p == pe )
                    goto _test_eof114;

            case 114:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr212;

                goto st0;
st115:

                if ( ++p == pe )
                    goto _test_eof115;

            case 115:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr213;

                goto st0;
st116:

                if ( ++p == pe )
                    goto _test_eof116;

            case 116:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr214;

                goto st0;
st117:

                if ( ++p == pe )
                    goto _test_eof117;

            case 117:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr215;

                goto st0;
st118:

                if ( ++p == pe )
                    goto _test_eof118;

            case 118:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr216;

                goto st0;
st119:

                if ( ++p == pe )
                    goto _test_eof119;

            case 119:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr217;

                case 5:
                    goto tr217;

                case 8:
                    goto tr217;

                case 18:
                    goto tr218;

                case 21:
                    goto tr218;

                case 23:
                    goto tr218;

                case 36:
                    goto tr218;

                case 44:
                    goto tr218;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr218;

                goto st0;
tr217:

                {
                    expr_start = p;
                }
                goto st120;
st120:

                if ( ++p == pe )
                    goto _test_eof120;

            case 120:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr219;

                case 19:
                    goto st120;

                case 23:
                    goto st121;

                case 37:
                    goto st120;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st121;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st121;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st121;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st121;
                }
                else
                    goto st121;

                goto st0;
tr218:

                {
                    expr_start = p;
                }
                goto st121;
st121:

                if ( ++p == pe )
                    goto _test_eof121;

            case 121:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st120;

                case 5:
                    goto st120;

                case 8:
                    goto st120;

                case 13:
                    goto st121;

                case 18:
                    goto st121;

                case 21:
                    goto st121;

                case 23:
                    goto st121;

                case 36:
                    goto st121;

                case 44:
                    goto st121;
                }

                goto st0;
st122:

                if ( ++p == pe )
                    goto _test_eof122;

            case 122:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr222;

                goto st0;
            }

_test_eof123:
            cs = 123;
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
_test_eof94:
            cs = 94;
            goto _test_eof;
_test_eof95:
            cs = 95;
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

                123

           )
            return TRUE;
    }

    return FALSE;
}
