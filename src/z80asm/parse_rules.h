




















static const int parser_start = 1;
static const int parser_first_final = 72;
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
                    goto st72;

                case 4:
                    goto tr2;

                case 12:
                    goto st72;

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
                    goto st12;

                case 97:
                    goto st25;

                case 98:
                    goto st26;

                case 99:
                    goto st27;

                case 100:
                    goto st30;

                case 101:
                    goto st31;

                case 102:
                    goto st32;

                case 103:
                    goto st33;

                case 104:
                    goto st34;

                case 105:
                    goto st35;

                case 106:
                    goto st36;

                case 107:
                    goto st37;

                case 108:
                    goto st38;

                case 109:
                    goto st39;

                case 110:
                    goto st48;

                case 111:
                    goto st49;

                case 112:
                    goto st50;

                case 113:
                    goto st53;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr30:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };
                }
                goto st72;
tr31:

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
                goto st72;
tr32:

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
                goto st72;
tr33:

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
                goto st72;
tr34:

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
                goto st72;
tr35:

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
                goto st72;
tr36:

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
                goto st72;
tr37:

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
                goto st72;
tr38:

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
                goto st72;
tr39:

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
                goto st72;
tr45:

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
                goto st72;
tr49:

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
                goto st72;
tr50:

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
                goto st72;
tr55:

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
                goto st72;
tr56:

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
                goto st72;
tr57:

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
                goto st72;
tr58:

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
                goto st72;
tr59:

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
                goto st72;
tr62:

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
                goto st72;
tr65:

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
                goto st72;
tr66:

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
                goto st72;
tr67:

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
                goto st72;
tr68:

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
                goto st72;
tr69:

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
                goto st72;
tr70:

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
                goto st72;
tr71:

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
                goto st72;
tr72:

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
                goto st72;
tr73:

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
                goto st72;
tr74:

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
                goto st72;
tr83:

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
                goto st72;
tr84:

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
                goto st72;
tr85:

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
                goto st72;
tr86:

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
                goto st72;
tr87:

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
                goto st72;
tr88:

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
                goto st72;
tr89:

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
                goto st72;
tr90:

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
                goto st72;
tr91:

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
                goto st72;
tr92:

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
                goto st72;
tr95:

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
                goto st72;
tr104:

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
                goto st72;
tr110:

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
                goto st72;
tr116:

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
                goto st72;
tr122:

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
                goto st72;
tr128:

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
                goto st72;
st72:

                if ( ++p == pe )
                    goto _test_eof72;

            case 72:

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
                    goto tr30;

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
                    goto st12;

                case 97:
                    goto st25;

                case 98:
                    goto st26;

                case 99:
                    goto st27;

                case 100:
                    goto st30;

                case 101:
                    goto st31;

                case 102:
                    goto st32;

                case 103:
                    goto st33;

                case 104:
                    goto st34;

                case 105:
                    goto st35;

                case 106:
                    goto st36;

                case 107:
                    goto st37;

                case 108:
                    goto st38;

                case 109:
                    goto st39;

                case 110:
                    goto st48;

                case 111:
                    goto st49;

                case 112:
                    goto st50;

                case 113:
                    goto st53;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr31;

                goto st0;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr32;

                goto st0;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr33;

                goto st0;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr34;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr35;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr36;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr37;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr38;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr39;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 70:
                    goto st13;

                case 74:
                    goto st16;

                case 82:
                    goto st20;
                }

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st14;

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 71 )
                    goto st15;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr45;

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
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 74:
                    goto st18;

                case 76:
                    goto st19;
                }

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr49;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr50;

                goto st0;
st20:

                if ( ++p == pe )
                    goto _test_eof20;

            case 20:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st21;

                goto st0;
st21:

                if ( ++p == pe )
                    goto _test_eof21;

            case 21:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 71:
                    goto st22;

                case 72:
                    goto st23;

                case 73:
                    goto st24;
                }

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr55;

                goto st0;
st23:

                if ( ++p == pe )
                    goto _test_eof23;

            case 23:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr56;

                goto st0;
st24:

                if ( ++p == pe )
                    goto _test_eof24;

            case 24:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr57;

                goto st0;
st25:

                if ( ++p == pe )
                    goto _test_eof25;

            case 25:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr58;

                goto st0;
st26:

                if ( ++p == pe )
                    goto _test_eof26;

            case 26:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr59;

                goto st0;
st27:

                if ( ++p == pe )
                    goto _test_eof27;

            case 27:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr60;

                case 5:
                    goto tr60;

                case 8:
                    goto tr60;

                case 18:
                    goto tr61;

                case 21:
                    goto tr61;

                case 23:
                    goto tr61;

                case 36:
                    goto tr61;

                case 44:
                    goto tr61;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr61;

                goto st0;
tr60:

                {
                    expr_start = p;
                }
                goto st28;
st28:

                if ( ++p == pe )
                    goto _test_eof28;

            case 28:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr62;

                case 19:
                    goto st28;

                case 23:
                    goto st29;

                case 37:
                    goto st28;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st29;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st29;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st29;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st29;
                }
                else
                    goto st29;

                goto st0;
tr61:

                {
                    expr_start = p;
                }
                goto st29;
st29:

                if ( ++p == pe )
                    goto _test_eof29;

            case 29:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st28;

                case 5:
                    goto st28;

                case 8:
                    goto st28;

                case 13:
                    goto st29;

                case 18:
                    goto st29;

                case 21:
                    goto st29;

                case 23:
                    goto st29;

                case 36:
                    goto st29;

                case 44:
                    goto st29;
                }

                goto st0;
st30:

                if ( ++p == pe )
                    goto _test_eof30;

            case 30:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr65;

                goto st0;
st31:

                if ( ++p == pe )
                    goto _test_eof31;

            case 31:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr66;

                goto st0;
st32:

                if ( ++p == pe )
                    goto _test_eof32;

            case 32:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr67;

                goto st0;
st33:

                if ( ++p == pe )
                    goto _test_eof33;

            case 33:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr68;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr69;

                goto st0;
st35:

                if ( ++p == pe )
                    goto _test_eof35;

            case 35:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr70;

                goto st0;
st36:

                if ( ++p == pe )
                    goto _test_eof36;

            case 36:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr71;

                goto st0;
st37:

                if ( ++p == pe )
                    goto _test_eof37;

            case 37:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr72;

                goto st0;
st38:

                if ( ++p == pe )
                    goto _test_eof38;

            case 38:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr73;

                goto st0;
st39:

                if ( ++p == pe )
                    goto _test_eof39;

            case 39:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr74;

                case 45:
                    goto st40;

                case 46:
                    goto st41;

                case 47:
                    goto st42;

                case 48:
                    goto st43;

                case 49:
                    goto st44;

                case 50:
                    goto st45;

                case 51:
                    goto st46;

                case 52:
                    goto st47;
                }

                goto st0;
st40:

                if ( ++p == pe )
                    goto _test_eof40;

            case 40:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr83;

                goto st0;
st41:

                if ( ++p == pe )
                    goto _test_eof41;

            case 41:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr84;

                goto st0;
st42:

                if ( ++p == pe )
                    goto _test_eof42;

            case 42:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr85;

                goto st0;
st43:

                if ( ++p == pe )
                    goto _test_eof43;

            case 43:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr86;

                goto st0;
st44:

                if ( ++p == pe )
                    goto _test_eof44;

            case 44:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr87;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr88;

                goto st0;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr89;

                goto st0;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr90;

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr91;

                goto st0;
st49:

                if ( ++p == pe )
                    goto _test_eof49;

            case 49:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr92;

                goto st0;
st50:

                if ( ++p == pe )
                    goto _test_eof50;

            case 50:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr93;

                case 5:
                    goto tr93;

                case 8:
                    goto tr93;

                case 18:
                    goto tr94;

                case 21:
                    goto tr94;

                case 23:
                    goto tr94;

                case 36:
                    goto tr94;

                case 44:
                    goto tr94;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr94;

                goto st0;
tr93:

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
                case 12:
                    goto tr95;

                case 19:
                    goto st51;

                case 23:
                    goto st52;

                case 37:
                    goto st51;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st52;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st52;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st52;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st52;
                }
                else
                    goto st52;

                goto st0;
tr94:

                {
                    expr_start = p;
                }
                goto st52;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st51;

                case 5:
                    goto st51;

                case 8:
                    goto st51;

                case 13:
                    goto st52;

                case 18:
                    goto st52;

                case 21:
                    goto st52;

                case 23:
                    goto st52;

                case 36:
                    goto st52;

                case 44:
                    goto st52;
                }

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
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

                case 45:
                    goto st56;

                case 46:
                    goto st60;

                case 47:
                    goto st64;

                case 48:
                    goto st68;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr99;

                goto st0;
tr98:

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
                    goto tr104;

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
tr99:

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
                    goto tr108;

                case 5:
                    goto tr108;

                case 8:
                    goto tr108;

                case 18:
                    goto tr109;

                case 21:
                    goto tr109;

                case 23:
                    goto tr109;

                case 36:
                    goto tr109;

                case 44:
                    goto tr109;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr109;

                goto st0;
tr108:

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
                    goto tr110;

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
tr109:

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
                    goto tr114;

                case 5:
                    goto tr114;

                case 8:
                    goto tr114;

                case 18:
                    goto tr115;

                case 21:
                    goto tr115;

                case 23:
                    goto tr115;

                case 36:
                    goto tr115;

                case 44:
                    goto tr115;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr115;

                goto st0;
tr114:

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
                    goto tr116;

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
tr115:

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
                    goto tr120;

                case 5:
                    goto tr120;

                case 8:
                    goto tr120;

                case 18:
                    goto tr121;

                case 21:
                    goto tr121;

                case 23:
                    goto tr121;

                case 36:
                    goto tr121;

                case 44:
                    goto tr121;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr121;

                goto st0;
tr120:

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
                    goto tr122;

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
tr121:

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
                    goto tr126;

                case 5:
                    goto tr126;

                case 8:
                    goto tr126;

                case 18:
                    goto tr127;

                case 21:
                    goto tr127;

                case 23:
                    goto tr127;

                case 36:
                    goto tr127;

                case 44:
                    goto tr127;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr127;

                goto st0;
tr126:

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
                    goto tr128;

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
tr127:

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
            }

_test_eof72:
            cs = 72;
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

                72

           )
            return TRUE;
    }

    return FALSE;
}
