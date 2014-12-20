




















static const int parser_start = 1;
static const int parser_first_final = 33;
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
                    goto st33;

                case 4:
                    goto tr2;

                case 12:
                    goto st33;

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
                    goto st21;

                case 94:
                    goto st22;

                case 95:
                    goto st23;

                case 96:
                    goto st26;

                case 97:
                    goto st27;

                case 98:
                    goto st28;

                case 99:
                    goto st29;

                case 100:
                    goto st30;

                case 101:
                    goto st31;

                case 102:
                    goto st32;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr19:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };
                }
                goto st33;
tr20:

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
                goto st33;
tr21:

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
                goto st33;
tr22:

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
                goto st33;
tr23:

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
                goto st33;
tr24:

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
                goto st33;
tr30:

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
                goto st33;
tr34:

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
                goto st33;
tr35:

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
                goto st33;
tr40:

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
                goto st33;
tr41:

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
                goto st33;
tr42:

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
                goto st33;
tr43:

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
                goto st33;
tr44:

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
                goto st33;
tr47:

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
                goto st33;
tr50:

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
                goto st33;
tr51:

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
                goto st33;
tr52:

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
                goto st33;
tr53:

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
                goto st33;
tr54:

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
                goto st33;
tr55:

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
                goto st33;
tr56:

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
                goto st33;
st33:

                if ( ++p == pe )
                    goto _test_eof33;

            case 33:

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
                    goto tr19;

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
                    goto st21;

                case 94:
                    goto st22;

                case 95:
                    goto st23;

                case 96:
                    goto st26;

                case 97:
                    goto st27;

                case 98:
                    goto st28;

                case 99:
                    goto st29;

                case 100:
                    goto st30;

                case 101:
                    goto st31;

                case 102:
                    goto st32;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr20;

                goto st0;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr21;

                goto st0;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr22;

                goto st0;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr23;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr24;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 70:
                    goto st9;

                case 74:
                    goto st12;

                case 82:
                    goto st16;
                }

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st10;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 71 )
                    goto st11;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr30;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st13;

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 74:
                    goto st14;

                case 76:
                    goto st15;
                }

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr34;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr35;

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
                case 71:
                    goto st18;

                case 72:
                    goto st19;

                case 73:
                    goto st20;
                }

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr40;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr41;

                goto st0;
st20:

                if ( ++p == pe )
                    goto _test_eof20;

            case 20:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr42;

                goto st0;
st21:

                if ( ++p == pe )
                    goto _test_eof21;

            case 21:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr43;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr44;

                goto st0;
st23:

                if ( ++p == pe )
                    goto _test_eof23;

            case 23:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr45;

                case 5:
                    goto tr45;

                case 8:
                    goto tr45;

                case 18:
                    goto tr46;

                case 21:
                    goto tr46;

                case 23:
                    goto tr46;

                case 36:
                    goto tr46;

                case 44:
                    goto tr46;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr46;

                goto st0;
tr45:

                {
                    expr_start = p;
                }
                goto st24;
st24:

                if ( ++p == pe )
                    goto _test_eof24;

            case 24:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr47;

                case 19:
                    goto st24;

                case 23:
                    goto st25;

                case 37:
                    goto st24;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st25;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st25;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st25;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st25;
                }
                else
                    goto st25;

                goto st0;
tr46:

                {
                    expr_start = p;
                }
                goto st25;
st25:

                if ( ++p == pe )
                    goto _test_eof25;

            case 25:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st24;

                case 5:
                    goto st24;

                case 8:
                    goto st24;

                case 13:
                    goto st25;

                case 18:
                    goto st25;

                case 21:
                    goto st25;

                case 23:
                    goto st25;

                case 36:
                    goto st25;

                case 44:
                    goto st25;
                }

                goto st0;
st26:

                if ( ++p == pe )
                    goto _test_eof26;

            case 26:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr50;

                goto st0;
st27:

                if ( ++p == pe )
                    goto _test_eof27;

            case 27:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr51;

                goto st0;
st28:

                if ( ++p == pe )
                    goto _test_eof28;

            case 28:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr52;

                goto st0;
st29:

                if ( ++p == pe )
                    goto _test_eof29;

            case 29:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr53;

                goto st0;
st30:

                if ( ++p == pe )
                    goto _test_eof30;

            case 30:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr54;

                goto st0;
st31:

                if ( ++p == pe )
                    goto _test_eof31;

            case 31:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr55;

                goto st0;
st32:

                if ( ++p == pe )
                    goto _test_eof32;

            case 32:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr56;

                goto st0;
            }

_test_eof33:
            cs = 33;
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

                33

           )
            return TRUE;
    }

    return FALSE;
}
