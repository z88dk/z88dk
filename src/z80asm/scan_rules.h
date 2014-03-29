











static const int asm_start = 9;
static const int asm_error = 0;

static const int asm_en_main = 9;




static void set_scan_buf( char *text, BOOL _at_bol )
{
    Str_set( input_buf, text );


    at_bol = _at_bol;
    pe = input_buf->str + input_buf->len;
    eof = pe;



    {
        cs = asm_start;
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
                    tok = TK_STRING;
                    Str_clear( tok_string_buf );
                    error_unclosed_string();
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr2:

            {
                te = p + 1;
                {
                    tok = TK_STRING;
                    Str_set_n( tok_string_buf, ts + 1, te - ts - 2 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr3:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_NUMBER;
                    tok_number = 0;
                    error_invalid_squoted_string();
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr4:

            {
                te = p + 1;
                {
                    tok = TK_NUMBER;
                    tok_number = ts[1];
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr5:

            {
                switch ( act )
                {
                case 5:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }




                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
                break;

                case 7:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 1, te - ts - 1, 16 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
                break;

                case 9:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
                break;

                case 11:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 2, te - ts - 2, 2 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
                break;

                case 52:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
                break;
                }
            }
            goto st9;
tr7:

            {
                te = p + 1;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts - 1, 16 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr8:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {




                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr10:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr12:

            {
                te = p + 1;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 2, te - ts - 3, 2 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr13:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_DOT;
                    tok_text = ".";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr16:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr18:

            {
                te = p + 1;
                {

                    while ( ts[ 0] == '.' || isspace( ts[ 0] ) ) ts++;

                    while ( te[-1] == ':' || isspace( te[-1] ) ) te--;


                    tok = TK_LABEL;
                    set_tok_name();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr19:

            {
                te = p + 1;
            }
            goto st9;
tr20:

            {
                te = p + 1;
                {
                    tok = TK_NEWLINE;
                    tok_text = "\n";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr23:

            {
                te = p + 1;
                {
                    tok = TK_CONST_EXPR;
                    tok_text = "#";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr25:

            {
                te = p + 1;
                {
                    tok = TK_MOD;
                    tok_text = "%";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr28:

            {
                te = p + 1;
                {
                    tok = TK_LPAREN;
                    tok_text = "(";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr29:

            {
                te = p + 1;
                {
                    tok = TK_RPAREN;
                    tok_text = ")";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr31:

            {
                te = p + 1;
                {
                    tok = TK_PLUS;
                    tok_text = "+";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr32:

            {
                te = p + 1;
                {
                    tok = TK_COMMA;
                    tok_text = ",";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr33:

            {
                te = p + 1;
                {
                    tok = TK_MINUS;
                    tok_text = "-";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr34:

            {
                te = p + 1;
                {
                    tok = TK_DIVIDE;
                    tok_text = "/";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr39:

            {
                te = p + 1;
                {
                    tok = TK_COLON;
                    tok_text = ":";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr44:

            {
                te = p + 1;
                {
                    tok = TK_QUESTION;
                    tok_text = "?";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr46:

            {
                te = p + 1;
                {
                    tok = TK_LSQUARE;
                    tok_text = "[";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr47:

            {
                te = p + 1;
                {
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr48:

            {
                te = p + 1;
                {
                    tok = TK_RSQUARE;
                    tok_text = "]";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr49:

            {
                te = p + 1;
                {
                    tok = TK_BIN_XOR;
                    tok_text = "^";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr50:

            {
                te = p + 1;
                {
                    tok = TK_LCURLY;
                    tok_text = "{";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr52:

            {
                te = p + 1;
                {
                    tok = TK_RCURLY;
                    tok_text = "}";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr53:

            {
                te = p + 1;
                {
                    tok = TK_BIN_NOT;
                    tok_text = "~";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr54:

            {
                te = p + 1;
                {
                    tok = TK_DOT;
                    tok_text = ".";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr60:

            {
                te = p;
                p--;
                {
                    tok = TK_LOG_NOT;
                    tok_text = "!";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr61:

            {
                te = p + 1;
                {
                    tok = TK_NOT_EQ;
                    tok_text = "!=";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr62:

            {
                te = p;
                p--;
                {
                    tok = TK_STRING;
                    Str_clear( tok_string_buf );
                    error_unclosed_string();
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr64:

            {
                te = p;
                p--;
                {
                    tok = TK_BIN_AND;
                    tok_text = "&";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr65:

            {
                te = p + 1;
                {
                    tok = TK_LOG_AND;
                    tok_text = "&&";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr66:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = 0;
                    error_invalid_squoted_string();
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr68:

            {
                te = p;
                p--;
                {
                    tok = TK_MULTIPLY;
                    tok_text = "*";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr69:

            {
                te = p + 1;
                {
                    tok = TK_POWER;
                    tok_text = "**";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr70:

            {
                te = p;
                p--;
                {




                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr74:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr76:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 2, te - ts - 2, 16 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr77:

            {
                te = p;
                p--;
            }
            goto st9;
tr78:

            {
                te = p;
                p--;
                {
                    tok = TK_LESS;
                    tok_text = "<";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr79:

            {
                te = p + 1;
                {
                    tok = TK_LEFT_SHIFT;
                    tok_text = "<<";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr80:

            {
                te = p + 1;
                {
                    tok = TK_LESS_EQ;
                    tok_text = "<=";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr81:

            {
                te = p + 1;
                {
                    tok = TK_NOT_EQ;
                    tok_text = "<>";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr82:

            {
                te = p;
                p--;
                {
                    tok = TK_EQUAL;
                    tok_text = "=";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr83:

            {
                te = p + 1;
                {
                    tok = TK_EQUAL;
                    tok_text = "==";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr84:

            {
                te = p;
                p--;
                {
                    tok = TK_GREATER;
                    tok_text = ">";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr85:

            {
                te = p + 1;
                {
                    tok = TK_GREATER_EQ;
                    tok_text = ">=";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr86:

            {
                te = p + 1;
                {
                    tok = TK_RIGHT_SHIFT;
                    tok_text = ">>";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr87:

            {
                te = p;
                p--;
                {
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr90:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 1, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr91:

            {
                te = p;
                p--;
                {
                    tok = TK_BIN_OR;
                    tok_text = "|";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr92:

            {
                te = p + 1;
                {
                    tok = TK_LOG_OR;
                    tok_text = "||";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr93:

            {
                te = p;
                p--;
                {
                    tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr95:

            {
                te = p + 1;
                {
                    tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr96:

            {
                te = p;
                p--;
                {
                    tok = TK_DOT;
                    tok_text = ".";
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
tr97:

            {
                te = p;
                p--;
                {

                    while ( ts[ 0] == '.' || isspace( ts[ 0] ) ) ts++;

                    while ( te[-1] == ':' || isspace( te[-1] ) ) te--;


                    tok = TK_LABEL;
                    set_tok_name();
                    {
                        p++;
                        cs = 9;
                        goto _out;
                    }
                }
            }
            goto st9;
st9:

            {
                ts = 0;
            }

            if ( ++p == pe )
                goto _test_eof9;

        case 9:

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
            goto tr20;

        case 33:
            goto st10;

        case 34:
            goto tr22;

        case 35:
            goto tr23;

        case 36:
            goto tr24;

        case 37:
            goto tr25;

        case 38:
            goto st13;

        case 39:
            goto tr27;

        case 40:
            goto tr28;

        case 41:
            goto tr29;

        case 42:
            goto st15;

        case 43:
            goto tr31;

        case 44:
            goto tr32;

        case 45:
            goto tr33;

        case 47:
            goto tr34;

        case 48:
            goto tr36;

        case 49:
            goto tr37;

        case 58:
            goto tr39;

        case 59:
            goto st22;

        case 60:
            goto st23;

        case 61:
            goto st24;

        case 62:
            goto st25;

        case 63:
            goto tr44;

        case 64:
            goto tr45;

        case 91:
            goto tr46;

        case 92:
            goto tr47;

        case 93:
            goto tr48;

        case 94:
            goto tr49;

        case 96:
            goto tr47;

        case 123:
            goto tr50;

        case 124:
            goto st28;

        case 125:
            goto tr52;

        case 126:
            goto tr53;

        case 127:
            goto tr19;

        case 302:
            goto tr54;

        case 321:
            goto st29;

        case 351:
            goto st30;

        case 353:
            goto st29;

        case 558:
            goto tr57;

        case 577:
            goto tr58;

        case 607:
            goto tr59;

        case 609:
            goto tr58;
        }

        if ( _widec < 322 )
        {
            if ( _widec > 32 )
            {
                if ( 50 <= _widec && _widec <= 57 )
                    goto tr38;
            }
            else
                goto tr19;
        }
        else if ( _widec > 346 )
        {
            if ( _widec < 578 )
            {
                if ( 354 <= _widec && _widec <= 378 )
                    goto st30;
            }
            else if ( _widec > 602 )
            {
                if ( 610 <= _widec && _widec <= 634 )
                    goto tr59;
            }
            else
                goto tr59;
        }
        else
            goto st30;

        goto st0;
st10:

        if ( ++p == pe )
            goto _test_eof10;

        case 10:
            if ( ( *p ) == 61 )
                goto tr61;

            goto tr60;
tr22:

            {
                te = p + 1;
            }
            goto st11;
st11:

            if ( ++p == pe )
                goto _test_eof11;

        case 11:

            switch ( ( *p ) )
            {
            case 10:
                goto tr62;

            case 34:
                goto tr2;
            }

            goto st1;
st1:

            if ( ++p == pe )
                goto _test_eof1;

        case 1:
            switch ( ( *p ) )
            {
            case 10:
                goto tr0;

            case 34:
                goto tr2;
            }

            goto st1;
tr24:

            {
                te = p + 1;
            }

            {
                act = 52;
            }
            goto st12;
tr63:

            {
                te = p + 1;
            }

            {
                act = 7;
            }
            goto st12;
st12:

            if ( ++p == pe )
                goto _test_eof12;

        case 12:

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr63;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto tr63;
            }
            else
                goto tr63;

            goto tr5;
st13:

            if ( ++p == pe )
                goto _test_eof13;

        case 13:
            if ( ( *p ) == 38 )
                goto tr65;

            goto tr64;
tr27:

            {
                te = p + 1;
            }
            goto st14;
st14:

            if ( ++p == pe )
                goto _test_eof14;

        case 14:

            switch ( ( *p ) )
            {
            case 10:
                goto tr66;

            case 39:
                goto tr66;
            }

            goto st2;
st2:

            if ( ++p == pe )
                goto _test_eof2;

        case 2:
            if ( ( *p ) == 39 )
                goto tr4;

            goto tr3;
st15:

            if ( ++p == pe )
                goto _test_eof15;

        case 15:
            if ( ( *p ) == 42 )
                goto tr69;

            goto tr68;
st0:
            cs = 0;
            goto _out;
tr36:

            {
                te = p + 1;
            }

            {
                act = 5;
            }
            goto st16;
st16:

            if ( ++p == pe )
                goto _test_eof16;

        case 16:

            switch ( ( *p ) )
            {
            case 66:
                goto tr71;

            case 72:
                goto tr7;

            case 88:
                goto st4;

            case 98:
                goto tr71;

            case 104:
                goto tr7;

            case 120:
                goto st4;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr37;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st3;
                }
                else if ( ( *p ) >= 65 )
                    goto st3;
            }
            else
                goto tr38;

            goto tr70;
tr37:

            {
                te = p + 1;
            }

            {
                act = 5;
            }
            goto st17;
st17:

            if ( ++p == pe )
                goto _test_eof17;

        case 17:

            switch ( ( *p ) )
            {
            case 66:
                goto tr73;

            case 72:
                goto tr7;

            case 98:
                goto tr73;

            case 104:
                goto tr7;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr37;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st3;
                }
                else if ( ( *p ) >= 65 )
                    goto st3;
            }
            else
                goto tr38;

            goto tr70;
tr38:

            {
                te = p + 1;
            }

            {
                act = 5;
            }
            goto st18;
st18:

            if ( ++p == pe )
                goto _test_eof18;

        case 18:

            switch ( ( *p ) )
            {
            case 72:
                goto tr7;

            case 104:
                goto tr7;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr38;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st3;
            }
            else
                goto st3;

            goto tr70;
st3:

            if ( ++p == pe )
                goto _test_eof3;

        case 3:
            switch ( ( *p ) )
            {
            case 72:
                goto tr7;

            case 104:
                goto tr7;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st3;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st3;
            }
            else
                goto st3;

            goto tr5;
tr73:

            {
                te = p + 1;
            }

            {
                act = 9;
            }
            goto st19;
st19:

            if ( ++p == pe )
                goto _test_eof19;

        case 19:

            switch ( ( *p ) )
            {
            case 72:
                goto tr7;

            case 104:
                goto tr7;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st3;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st3;
            }
            else
                goto st3;

            goto tr74;
tr71:

            {
                te = p + 1;
            }

            {
                act = 9;
            }
            goto st20;
tr75:

            {
                te = p + 1;
            }

            {
                act = 11;
            }
            goto st20;
st20:

            if ( ++p == pe )
                goto _test_eof20;

        case 20:

            switch ( ( *p ) )
            {
            case 72:
                goto tr7;

            case 104:
                goto tr7;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr75;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st3;
                }
                else if ( ( *p ) >= 65 )
                    goto st3;
            }
            else
                goto st3;

            goto tr5;
st4:

            if ( ++p == pe )
                goto _test_eof4;

        case 4:
            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st21;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st21;
            }
            else
                goto st21;

            goto tr8;
st21:

            if ( ++p == pe )
                goto _test_eof21;

        case 21:
            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st21;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st21;
            }
            else
                goto st21;

            goto tr76;
st22:

            if ( ++p == pe )
                goto _test_eof22;

        case 22:
            if ( ( *p ) == 10 )
                goto tr77;

            goto st22;
st23:

            if ( ++p == pe )
                goto _test_eof23;

        case 23:
            switch ( ( *p ) )
            {
            case 60:
                goto tr79;

            case 61:
                goto tr80;

            case 62:
                goto tr81;
            }

            goto tr78;
st24:

            if ( ++p == pe )
                goto _test_eof24;

        case 24:
            if ( ( *p ) == 61 )
                goto tr83;

            goto tr82;
st25:

            if ( ++p == pe )
                goto _test_eof25;

        case 25:
            switch ( ( *p ) )
            {
            case 61:
                goto tr85;

            case 62:
                goto tr86;
            }

            goto tr84;
tr45:

            {
                te = p + 1;
            }
            goto st26;
st26:

            if ( ++p == pe )
                goto _test_eof26;

        case 26:

            if ( ( *p ) == 34 )
                goto st5;

            if ( 48 <= ( *p ) && ( *p ) <= 49 )
                goto st27;

            goto tr87;
st5:

            if ( ++p == pe )
                goto _test_eof5;

        case 5:
            switch ( ( *p ) )
            {
            case 35:
                goto st6;

            case 45:
                goto st6;
            }

            goto tr10;
st6:

            if ( ++p == pe )
                goto _test_eof6;

        case 6:
            switch ( ( *p ) )
            {
            case 34:
                goto tr12;

            case 35:
                goto st6;

            case 45:
                goto st6;
            }

            goto tr10;
st27:

            if ( ++p == pe )
                goto _test_eof27;

        case 27:
            if ( 48 <= ( *p ) && ( *p ) <= 49 )
                goto st27;

            goto tr90;
st28:

            if ( ++p == pe )
                goto _test_eof28;

        case 28:
            if ( ( *p ) == 124 )
                goto tr92;

            goto tr91;
st29:

            if ( ++p == pe )
                goto _test_eof29;

        case 29:
            switch ( ( *p ) )
            {
            case 70:
                goto st31;

            case 95:
                goto st30;

            case 102:
                goto st31;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st30;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto st30;
            }
            else
                goto st30;

            goto tr93;
st30:

            if ( ++p == pe )
                goto _test_eof30;

        case 30:
            if ( ( *p ) == 95 )
                goto st30;

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st30;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto st30;
            }
            else
                goto st30;

            goto tr93;
st31:

            if ( ++p == pe )
                goto _test_eof31;

        case 31:
            switch ( ( *p ) )
            {
            case 39:
                goto tr95;

            case 95:
                goto st30;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st30;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto st30;
            }
            else
                goto st30;

            goto tr93;
tr57:

            {
                te = p + 1;
            }
            goto st32;
st32:

            if ( ++p == pe )
                goto _test_eof32;

        case 32:

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
                goto st7;

            case 544:
                goto st7;

            case 607:
                goto st33;
            }

            if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st33;
            }
            else if ( _widec >= 577 )
                goto st33;

            goto tr96;
st7:

            if ( ++p == pe )
                goto _test_eof7;

        case 7:
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
                goto st7;

            case 544:
                goto st7;

            case 607:
                goto st33;
            }

            if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st33;
            }
            else if ( _widec >= 577 )
                goto st33;

            goto tr13;
st33:

            if ( ++p == pe )
                goto _test_eof33;

        case 33:
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
                goto st33;

            if ( _widec < 577 )
            {
                if ( 560 <= _widec && _widec <= 569 )
                    goto st33;
            }
            else if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st33;
            }
            else
                goto st33;

            goto tr97;
tr58:

            {
                te = p + 1;
            }
            goto st34;
st34:

            if ( ++p == pe )
                goto _test_eof34;

        case 34:

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
                goto st31;

            case 351:
                goto st30;

            case 358:
                goto st31;

            case 521:
                goto st8;

            case 544:
                goto st8;

            case 570:
                goto tr18;

            case 582:
                goto tr98;

            case 607:
                goto tr59;

            case 614:
                goto tr98;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto st30;
                }
                else if ( _widec >= 304 )
                    goto st30;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr59;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr59;
                }
                else
                    goto tr59;
            }
            else
                goto st30;

            goto tr93;
st8:

            if ( ++p == pe )
                goto _test_eof8;

        case 8:
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
                goto st8;

            case 544:
                goto st8;

            case 570:
                goto tr18;
            }

            goto tr16;
tr59:

            {
                te = p + 1;
            }
            goto st35;
st35:

            if ( ++p == pe )
                goto _test_eof35;

        case 35:

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
                goto st30;

            case 521:
                goto st8;

            case 544:
                goto st8;

            case 570:
                goto tr18;

            case 607:
                goto tr59;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto st30;
                }
                else if ( _widec >= 304 )
                    goto st30;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr59;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr59;
                }
                else
                    goto tr59;
            }
            else
                goto st30;

            goto tr93;
tr98:

            {
                te = p + 1;
            }
            goto st36;
st36:

            if ( ++p == pe )
                goto _test_eof36;

        case 36:

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
                goto tr95;

            case 351:
                goto st30;

            case 521:
                goto st8;

            case 544:
                goto st8;

            case 570:
                goto tr18;

            case 607:
                goto tr59;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto st30;
                }
                else if ( _widec >= 304 )
                    goto st30;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr59;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr59;
                }
                else
                    goto tr59;
            }
            else
                goto st30;

            goto tr93;
        }

_test_eof9:
        cs = 9;
        goto _test_eof;
_test_eof10:
        cs = 10;
        goto _test_eof;
_test_eof11:
        cs = 11;
        goto _test_eof;
_test_eof1:
        cs = 1;
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
_test_eof2:
        cs = 2;
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
_test_eof3:
        cs = 3;
        goto _test_eof;
_test_eof19:
        cs = 19;
        goto _test_eof;
_test_eof20:
        cs = 20;
        goto _test_eof;
_test_eof4:
        cs = 4;
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
_test_eof5:
        cs = 5;
        goto _test_eof;
_test_eof6:
        cs = 6;
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
_test_eof7:
        cs = 7;
        goto _test_eof;
_test_eof33:
        cs = 33;
        goto _test_eof;
_test_eof34:
        cs = 34;
        goto _test_eof;
_test_eof8:
        cs = 8;
        goto _test_eof;
_test_eof35:
        cs = 35;
        goto _test_eof;
_test_eof36:
        cs = 36;
        goto _test_eof;

_test_eof:
        {}

        if ( p == eof )
        {
            switch ( cs )
            {
            case 10:
                goto tr60;

            case 11:
                goto tr62;

            case 1:
                goto tr0;

            case 12:
                goto tr5;

            case 13:
                goto tr64;

            case 14:
                goto tr66;

            case 2:
                goto tr3;

            case 15:
                goto tr68;

            case 16:
                goto tr70;

            case 17:
                goto tr70;

            case 18:
                goto tr70;

            case 3:
                goto tr5;

            case 19:
                goto tr74;

            case 20:
                goto tr5;

            case 4:
                goto tr8;

            case 21:
                goto tr76;

            case 22:
                goto tr77;

            case 23:
                goto tr78;

            case 24:
                goto tr82;

            case 25:
                goto tr84;

            case 26:
                goto tr87;

            case 5:
                goto tr10;

            case 6:
                goto tr10;

            case 27:
                goto tr90;

            case 28:
                goto tr91;

            case 29:
                goto tr93;

            case 30:
                goto tr93;

            case 31:
                goto tr93;

            case 32:
                goto tr96;

            case 7:
                goto tr13;

            case 33:
                goto tr97;

            case 34:
                goto tr93;

            case 8:
                goto tr16;

            case 35:
                goto tr93;

            case 36:
                goto tr93;
            }
        }

_out:
        {}
    }


    return tok;
}
