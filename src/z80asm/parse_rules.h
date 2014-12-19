




















static const int parser_start = 1;
static const int parser_first_final = 9;
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
                    goto st9;

                case 4:
                    goto tr2;

                case 12:
                    goto st9;

                case 87:
                    goto st3;

                case 88:
                    goto st4;

                case 89:
                    goto st5;

                case 90:
                    goto st8;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr7:

                {
                    if ( compile_active && stmt_label )
                    {
                        define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                    };
                }
                goto st9;
tr8:

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
                goto st9;
tr9:

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
                goto st9;
tr12:

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
                goto st9;
tr15:

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
                goto st9;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:

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
                    goto tr7;

                case 87:
                    goto st3;

                case 88:
                    goto st4;

                case 89:
                    goto st5;

                case 90:
                    goto st8;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr8;

                goto st0;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr9;

                goto st0;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr10;

                case 5:
                    goto tr10;

                case 8:
                    goto tr10;

                case 18:
                    goto tr11;

                case 21:
                    goto tr11;

                case 23:
                    goto tr11;

                case 36:
                    goto tr11;

                case 44:
                    goto tr11;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr11;

                goto st0;
tr10:

                {
                    expr_start = p;
                }
                goto st6;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr12;

                case 19:
                    goto st6;

                case 23:
                    goto st7;

                case 37:
                    goto st6;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st7;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st7;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st7;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st7;
                }
                else
                    goto st7;

                goto st0;
tr11:

                {
                    expr_start = p;
                }
                goto st7;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st6;

                case 5:
                    goto st6;

                case 8:
                    goto st6;

                case 13:
                    goto st7;

                case 18:
                    goto st7;

                case 21:
                    goto st7;

                case 23:
                    goto st7;

                case 36:
                    goto st7;

                case 44:
                    goto st7;
                }

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr15;

                goto st0;
            }

_test_eof9:
            cs = 9;
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

                9

           )
            return TRUE;
    }

    return FALSE;
}
