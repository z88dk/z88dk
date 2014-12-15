
















static const int parser_start = 1;
static const int parser_first_final = 5;
static const int parser_error = 0;

static const int parser_en_main = 1;




static Bool _parse_statement( Bool compile_active )
{
    p = ( Sym * )utarray_front( tokens );
    pe = eof = ( Sym * )utarray_back( tokens ) + 1;



    {
        cs = parser_start;
    }





    {
        if ( p == pe )
            goto _test_eof;

        switch ( cs )
        {
        case 1:
            switch ( ( ( ( int ) p->tok ) ) )
            {
            case 0:
                goto st5;

            case 4:
                goto tr2;

            case 12:
                goto st5;

            case 87:
                goto st3;

            case 88:
                goto st4;
            }

            goto st0;
st0:
            cs = 0;
            goto _out;
tr5:

            {
                if ( compile_active && stmt_label )
                {
                    define_symbol( stmt_label, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
                };
            }
            goto st5;
tr6:

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
            goto st5;
tr7:

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
            goto st5;
st5:

            if ( ++p == pe )
                goto _test_eof5;

        case 5:

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
                goto tr5;

            case 87:
                goto st3;

            case 88:
                goto st4;
            }

            goto st0;
st3:

            if ( ++p == pe )
                goto _test_eof3;

        case 3:
            if ( ( ( ( int ) p->tok ) ) == 12 )
                goto tr6;

            goto st0;
st4:

            if ( ++p == pe )
                goto _test_eof4;

        case 4:
            if ( ( ( ( int ) p->tok ) ) == 12 )
                goto tr7;

            goto st0;
        }

_test_eof5:
        cs = 5;
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

_test_eof:
        {}
_out:
        {}
    }




    if ( cs <

            5

       )
        return FALSE;

    return TRUE;
}
