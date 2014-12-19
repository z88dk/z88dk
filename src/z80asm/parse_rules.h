




















static const int parser_start = 1;
static const int parser_first_final = 14;
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
                    goto st14;

                case 4:
                    goto tr2;

                case 12:
                    goto st14;

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
                    goto st11;

                case 94:
                    goto st12;

                case 95:
                    goto st13;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr12:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };
                }
                goto st14;
tr13:

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
                goto st14;
tr14:

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
                goto st14;
tr15:

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
                goto st14;
tr16:

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
                goto st14;
tr17:

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
                goto st14;
tr20:

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
                goto st14;
tr23:

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
                goto st14;
tr24:

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
                goto st14;
tr25:

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
                goto st14;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:

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
                    goto tr12;

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
                    goto st11;

                case 94:
                    goto st12;

                case 95:
                    goto st13;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr13;

                goto st0;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr14;

                goto st0;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr15;

                goto st0;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr16;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr17;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr18;

                case 5:
                    goto tr18;

                case 8:
                    goto tr18;

                case 18:
                    goto tr19;

                case 21:
                    goto tr19;

                case 23:
                    goto tr19;

                case 36:
                    goto tr19;

                case 44:
                    goto tr19;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr19;

                goto st0;
tr18:

                {
                    expr_start = p;
                }
                goto st9;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr20;

                case 19:
                    goto st9;

                case 23:
                    goto st10;

                case 37:
                    goto st9;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st10;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st10;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st10;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st10;
                }
                else
                    goto st10;

                goto st0;
tr19:

                {
                    expr_start = p;
                }
                goto st10;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st9;

                case 5:
                    goto st9;

                case 8:
                    goto st9;

                case 13:
                    goto st10;

                case 18:
                    goto st10;

                case 21:
                    goto st10;

                case 23:
                    goto st10;

                case 36:
                    goto st10;

                case 44:
                    goto st10;
                }

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr23;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr24;

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr25;

                goto st0;
            }

_test_eof14:
            cs = 14;
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

                14

           )
            return TRUE;
    }

    return FALSE;
}
