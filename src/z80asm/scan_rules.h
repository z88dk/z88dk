











static const int asm_start = 7;
static const int asm_error = 0;

static const int asm_en_main = 7;




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
                        cs = 7;
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
                        cs = 7;
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
                        cs = 7;
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
                        cs = 7;
                        goto _out;
                    }
                }
                break;

                case 50:
                {
                    {
                        p = ( ( te ) ) - 1;
                    }
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
                break;
                }
            }
            goto st7;
tr2:

            {
                te = p + 1;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts - 1, 16 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr3:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {




                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr5:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr7:

            {
                te = p + 1;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 2, te - ts - 3, 2 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr8:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_DOT;
                    tok_text = ".";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr11:

            {
                {
                    p = ( ( te ) ) - 1;
                }
                {
                    tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr13:

            {
                te = p + 1;
                {

                    while ( ts[ 0] == '.' || isspace( ts[ 0] ) ) ts++;

                    while ( te[-1] == ':' || isspace( te[-1] ) ) te--;


                    tok = TK_LABEL;
                    set_tok_name();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr14:

            {
                te = p + 1;
            }
            goto st7;
tr15:

            {
                te = p + 1;
                {
                    tok = TK_NEWLINE;
                    tok_text = "\n";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr17:

            {
                te = p + 1;
                {
                    tok = TK_STRING;

                    if ( ! get_tok_string() )
                        error_unclosed_string();

                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr18:

            {
                te = p + 1;
                {
                    tok = TK_CONST_EXPR;
                    tok_text = "#";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr20:

            {
                te = p + 1;
                {
                    tok = TK_MOD;
                    tok_text = "%";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr22:

            {
                te = p + 1;
                {
                    tok = TK_NUMBER;

                    if ( get_tok_string() &&
                            tok_string_buf->len == 1 )
                    {
                        tok_number = tok_string[0];
                    }
                    else
                    {
                        tok_number = 0;
                        error_invalid_squoted_string();
                    }

                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr23:

            {
                te = p + 1;
                {
                    tok = TK_LPAREN;
                    tok_text = "(";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr24:

            {
                te = p + 1;
                {
                    tok = TK_RPAREN;
                    tok_text = ")";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr26:

            {
                te = p + 1;
                {
                    tok = TK_PLUS;
                    tok_text = "+";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr27:

            {
                te = p + 1;
                {
                    tok = TK_COMMA;
                    tok_text = ",";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr28:

            {
                te = p + 1;
                {
                    tok = TK_MINUS;
                    tok_text = "-";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr29:

            {
                te = p + 1;
                {
                    tok = TK_DIVIDE;
                    tok_text = "/";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr34:

            {
                te = p + 1;
                {
                    tok = TK_COLON;
                    tok_text = ":";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr39:

            {
                te = p + 1;
                {
                    tok = TK_QUESTION;
                    tok_text = "?";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr41:

            {
                te = p + 1;
                {
                    tok = TK_LSQUARE;
                    tok_text = "[";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr42:

            {
                te = p + 1;
                {
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr43:

            {
                te = p + 1;
                {
                    tok = TK_RSQUARE;
                    tok_text = "]";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr44:

            {
                te = p + 1;
                {
                    tok = TK_BIN_XOR;
                    tok_text = "^";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr45:

            {
                te = p + 1;
                {
                    tok = TK_LCURLY;
                    tok_text = "{";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr47:

            {
                te = p + 1;
                {
                    tok = TK_RCURLY;
                    tok_text = "}";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr48:

            {
                te = p + 1;
                {
                    tok = TK_BIN_NOT;
                    tok_text = "~";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr49:

            {
                te = p + 1;
                {
                    tok = TK_DOT;
                    tok_text = ".";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr55:

            {
                te = p;
                p--;
                {
                    tok = TK_LOG_NOT;
                    tok_text = "!";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr56:

            {
                te = p + 1;
                {
                    tok = TK_NOT_EQ;
                    tok_text = "!=";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr58:

            {
                te = p;
                p--;
                {
                    tok = TK_BIN_AND;
                    tok_text = "&";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr59:

            {
                te = p + 1;
                {
                    tok = TK_LOG_AND;
                    tok_text = "&&";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr60:

            {
                te = p;
                p--;
                {
                    tok = TK_MULTIPLY;
                    tok_text = "*";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr61:

            {
                te = p + 1;
                {
                    tok = TK_POWER;
                    tok_text = "**";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr62:

            {
                te = p;
                p--;
                {




                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts, 10 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr66:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr68:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 2, te - ts - 2, 16 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr69:

            {
                te = p;
                p--;
            }
            goto st7;
tr70:

            {
                te = p;
                p--;
                {
                    tok = TK_LESS;
                    tok_text = "<";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr71:

            {
                te = p + 1;
                {
                    tok = TK_LEFT_SHIFT;
                    tok_text = "<<";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr72:

            {
                te = p + 1;
                {
                    tok = TK_LESS_EQ;
                    tok_text = "<=";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr73:

            {
                te = p + 1;
                {
                    tok = TK_NOT_EQ;
                    tok_text = "<>";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr74:

            {
                te = p;
                p--;
                {
                    tok = TK_EQUAL;
                    tok_text = "=";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr75:

            {
                te = p + 1;
                {
                    tok = TK_EQUAL;
                    tok_text = "==";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr76:

            {
                te = p;
                p--;
                {
                    tok = TK_GREATER;
                    tok_text = ">";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr77:

            {
                te = p + 1;
                {
                    tok = TK_GREATER_EQ;
                    tok_text = ">=";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr78:

            {
                te = p + 1;
                {
                    tok = TK_RIGHT_SHIFT;
                    tok_text = ">>";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr79:

            {
                te = p;
                p--;
                {
                    tok = TK_NIL;
                    skip_to_newline();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr82:

            {
                te = p;
                p--;
                {
                    tok = TK_NUMBER;
                    tok_number = scan_num( ts + 1, te - ts - 1, 2 );
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr83:

            {
                te = p;
                p--;
                {
                    tok = TK_BIN_OR;
                    tok_text = "|";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr84:

            {
                te = p + 1;
                {
                    tok = TK_LOG_OR;
                    tok_text = "||";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr85:

            {
                te = p;
                p--;
                {
                    tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr87:

            {
                te = p + 1;
                {
                    tok = TK_NAME;
                    set_tok_name();
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr88:

            {
                te = p;
                p--;
                {
                    tok = TK_DOT;
                    tok_text = ".";
                    {
                        p++;
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
tr89:

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
                        cs = 7;
                        goto _out;
                    }
                }
            }
            goto st7;
st7:

            {
                ts = 0;
            }

            if ( ++p == pe )
                goto _test_eof7;

        case 7:

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
            goto tr15;

        case 33:
            goto st8;

        case 34:
            goto tr17;

        case 35:
            goto tr18;

        case 36:
            goto tr19;

        case 37:
            goto tr20;

        case 38:
            goto st10;

        case 39:
            goto tr22;

        case 40:
            goto tr23;

        case 41:
            goto tr24;

        case 42:
            goto st11;

        case 43:
            goto tr26;

        case 44:
            goto tr27;

        case 45:
            goto tr28;

        case 47:
            goto tr29;

        case 48:
            goto tr31;

        case 49:
            goto tr32;

        case 58:
            goto tr34;

        case 59:
            goto st18;

        case 60:
            goto st19;

        case 61:
            goto st20;

        case 62:
            goto st21;

        case 63:
            goto tr39;

        case 64:
            goto tr40;

        case 91:
            goto tr41;

        case 92:
            goto tr42;

        case 93:
            goto tr43;

        case 94:
            goto tr44;

        case 96:
            goto tr42;

        case 123:
            goto tr45;

        case 124:
            goto st24;

        case 125:
            goto tr47;

        case 126:
            goto tr48;

        case 127:
            goto tr14;

        case 302:
            goto tr49;

        case 321:
            goto st25;

        case 351:
            goto st26;

        case 353:
            goto st25;

        case 558:
            goto tr52;

        case 577:
            goto tr53;

        case 607:
            goto tr54;

        case 609:
            goto tr53;
        }

        if ( _widec < 322 )
        {
            if ( _widec > 32 )
            {
                if ( 50 <= _widec && _widec <= 57 )
                    goto tr33;
            }
            else
                goto tr14;
        }
        else if ( _widec > 346 )
        {
            if ( _widec < 578 )
            {
                if ( 354 <= _widec && _widec <= 378 )
                    goto st26;
            }
            else if ( _widec > 602 )
            {
                if ( 610 <= _widec && _widec <= 634 )
                    goto tr54;
            }
            else
                goto tr54;
        }
        else
            goto st26;

        goto st0;
st8:

        if ( ++p == pe )
            goto _test_eof8;

        case 8:
            if ( ( *p ) == 61 )
                goto tr56;

            goto tr55;
tr19:

            {
                te = p + 1;
            }

            {
                act = 50;
            }
            goto st9;
tr57:

            {
                te = p + 1;
            }

            {
                act = 7;
            }
            goto st9;
st9:

            if ( ++p == pe )
                goto _test_eof9;

        case 9:

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr57;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto tr57;
            }
            else
                goto tr57;

            goto tr0;
st10:

            if ( ++p == pe )
                goto _test_eof10;

        case 10:
            if ( ( *p ) == 38 )
                goto tr59;

            goto tr58;
st11:

            if ( ++p == pe )
                goto _test_eof11;

        case 11:
            if ( ( *p ) == 42 )
                goto tr61;

            goto tr60;
st0:
            cs = 0;
            goto _out;
tr31:

            {
                te = p + 1;
            }

            {
                act = 5;
            }
            goto st12;
st12:

            if ( ++p == pe )
                goto _test_eof12;

        case 12:

            switch ( ( *p ) )
            {
            case 66:
                goto tr63;

            case 72:
                goto tr2;

            case 88:
                goto st2;

            case 98:
                goto tr63;

            case 104:
                goto tr2;

            case 120:
                goto st2;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr32;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st1;
                }
                else if ( ( *p ) >= 65 )
                    goto st1;
            }
            else
                goto tr33;

            goto tr62;
tr32:

            {
                te = p + 1;
            }

            {
                act = 5;
            }
            goto st13;
st13:

            if ( ++p == pe )
                goto _test_eof13;

        case 13:

            switch ( ( *p ) )
            {
            case 66:
                goto tr65;

            case 72:
                goto tr2;

            case 98:
                goto tr65;

            case 104:
                goto tr2;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr32;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st1;
                }
                else if ( ( *p ) >= 65 )
                    goto st1;
            }
            else
                goto tr33;

            goto tr62;
tr33:

            {
                te = p + 1;
            }

            {
                act = 5;
            }
            goto st14;
st14:

            if ( ++p == pe )
                goto _test_eof14;

        case 14:

            switch ( ( *p ) )
            {
            case 72:
                goto tr2;

            case 104:
                goto tr2;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto tr33;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st1;
            }
            else
                goto st1;

            goto tr62;
st1:

            if ( ++p == pe )
                goto _test_eof1;

        case 1:
            switch ( ( *p ) )
            {
            case 72:
                goto tr2;

            case 104:
                goto tr2;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st1;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st1;
            }
            else
                goto st1;

            goto tr0;
tr65:

            {
                te = p + 1;
            }

            {
                act = 9;
            }
            goto st15;
st15:

            if ( ++p == pe )
                goto _test_eof15;

        case 15:

            switch ( ( *p ) )
            {
            case 72:
                goto tr2;

            case 104:
                goto tr2;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st1;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st1;
            }
            else
                goto st1;

            goto tr66;
tr63:

            {
                te = p + 1;
            }

            {
                act = 9;
            }
            goto st16;
tr67:

            {
                te = p + 1;
            }

            {
                act = 11;
            }
            goto st16;
st16:

            if ( ++p == pe )
                goto _test_eof16;

        case 16:

            switch ( ( *p ) )
            {
            case 72:
                goto tr2;

            case 104:
                goto tr2;
            }

            if ( ( *p ) < 50 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 49 )
                    goto tr67;
            }
            else if ( ( *p ) > 57 )
            {
                if ( ( *p ) > 70 )
                {
                    if ( 97 <= ( *p ) && ( *p ) <= 102 )
                        goto st1;
                }
                else if ( ( *p ) >= 65 )
                    goto st1;
            }
            else
                goto st1;

            goto tr0;
st2:

            if ( ++p == pe )
                goto _test_eof2;

        case 2:
            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st17;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st17;
            }
            else
                goto st17;

            goto tr3;
st17:

            if ( ++p == pe )
                goto _test_eof17;

        case 17:
            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st17;
            }
            else if ( ( *p ) > 70 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 102 )
                    goto st17;
            }
            else
                goto st17;

            goto tr68;
st18:

            if ( ++p == pe )
                goto _test_eof18;

        case 18:
            if ( ( *p ) == 10 )
                goto tr69;

            goto st18;
st19:

            if ( ++p == pe )
                goto _test_eof19;

        case 19:
            switch ( ( *p ) )
            {
            case 60:
                goto tr71;

            case 61:
                goto tr72;

            case 62:
                goto tr73;
            }

            goto tr70;
st20:

            if ( ++p == pe )
                goto _test_eof20;

        case 20:
            if ( ( *p ) == 61 )
                goto tr75;

            goto tr74;
st21:

            if ( ++p == pe )
                goto _test_eof21;

        case 21:
            switch ( ( *p ) )
            {
            case 61:
                goto tr77;

            case 62:
                goto tr78;
            }

            goto tr76;
tr40:

            {
                te = p + 1;
            }
            goto st22;
st22:

            if ( ++p == pe )
                goto _test_eof22;

        case 22:

            if ( ( *p ) == 34 )
                goto st3;

            if ( 48 <= ( *p ) && ( *p ) <= 49 )
                goto st23;

            goto tr79;
st3:

            if ( ++p == pe )
                goto _test_eof3;

        case 3:
            switch ( ( *p ) )
            {
            case 35:
                goto st4;

            case 45:
                goto st4;
            }

            goto tr5;
st4:

            if ( ++p == pe )
                goto _test_eof4;

        case 4:
            switch ( ( *p ) )
            {
            case 34:
                goto tr7;

            case 35:
                goto st4;

            case 45:
                goto st4;
            }

            goto tr5;
st23:

            if ( ++p == pe )
                goto _test_eof23;

        case 23:
            if ( 48 <= ( *p ) && ( *p ) <= 49 )
                goto st23;

            goto tr82;
st24:

            if ( ++p == pe )
                goto _test_eof24;

        case 24:
            if ( ( *p ) == 124 )
                goto tr84;

            goto tr83;
st25:

            if ( ++p == pe )
                goto _test_eof25;

        case 25:
            switch ( ( *p ) )
            {
            case 70:
                goto st27;

            case 95:
                goto st26;

            case 102:
                goto st27;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st26;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto st26;
            }
            else
                goto st26;

            goto tr85;
st26:

            if ( ++p == pe )
                goto _test_eof26;

        case 26:
            if ( ( *p ) == 95 )
                goto st26;

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st26;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto st26;
            }
            else
                goto st26;

            goto tr85;
st27:

            if ( ++p == pe )
                goto _test_eof27;

        case 27:
            switch ( ( *p ) )
            {
            case 39:
                goto tr87;

            case 95:
                goto st26;
            }

            if ( ( *p ) < 65 )
            {
                if ( 48 <= ( *p ) && ( *p ) <= 57 )
                    goto st26;
            }
            else if ( ( *p ) > 90 )
            {
                if ( 97 <= ( *p ) && ( *p ) <= 122 )
                    goto st26;
            }
            else
                goto st26;

            goto tr85;
tr52:

            {
                te = p + 1;
            }
            goto st28;
st28:

            if ( ++p == pe )
                goto _test_eof28;

        case 28:

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
                goto st5;

            case 544:
                goto st5;

            case 607:
                goto st29;
            }

            if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st29;
            }
            else if ( _widec >= 577 )
                goto st29;

            goto tr88;
st5:

            if ( ++p == pe )
                goto _test_eof5;

        case 5:
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
                goto st5;

            case 544:
                goto st5;

            case 607:
                goto st29;
            }

            if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st29;
            }
            else if ( _widec >= 577 )
                goto st29;

            goto tr8;
st29:

            if ( ++p == pe )
                goto _test_eof29;

        case 29:
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
                goto st29;

            if ( _widec < 577 )
            {
                if ( 560 <= _widec && _widec <= 569 )
                    goto st29;
            }
            else if ( _widec > 602 )
            {
                if ( 609 <= _widec && _widec <= 634 )
                    goto st29;
            }
            else
                goto st29;

            goto tr89;
tr53:

            {
                te = p + 1;
            }
            goto st30;
st30:

            if ( ++p == pe )
                goto _test_eof30;

        case 30:

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
                goto st27;

            case 351:
                goto st26;

            case 358:
                goto st27;

            case 521:
                goto st6;

            case 544:
                goto st6;

            case 570:
                goto tr13;

            case 582:
                goto tr90;

            case 607:
                goto tr54;

            case 614:
                goto tr90;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto st26;
                }
                else if ( _widec >= 304 )
                    goto st26;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr54;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr54;
                }
                else
                    goto tr54;
            }
            else
                goto st26;

            goto tr85;
st6:

            if ( ++p == pe )
                goto _test_eof6;

        case 6:
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
                goto st6;

            case 544:
                goto st6;

            case 570:
                goto tr13;
            }

            goto tr11;
tr54:

            {
                te = p + 1;
            }
            goto st31;
st31:

            if ( ++p == pe )
                goto _test_eof31;

        case 31:

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
                goto st26;

            case 521:
                goto st6;

            case 544:
                goto st6;

            case 570:
                goto tr13;

            case 607:
                goto tr54;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto st26;
                }
                else if ( _widec >= 304 )
                    goto st26;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr54;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr54;
                }
                else
                    goto tr54;
            }
            else
                goto st26;

            goto tr85;
tr90:

            {
                te = p + 1;
            }
            goto st32;
st32:

            if ( ++p == pe )
                goto _test_eof32;

        case 32:

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
                goto tr87;

            case 351:
                goto st26;

            case 521:
                goto st6;

            case 544:
                goto st6;

            case 570:
                goto tr13;

            case 607:
                goto tr54;
            }

            if ( _widec < 353 )
            {
                if ( _widec > 313 )
                {
                    if ( 321 <= _widec && _widec <= 346 )
                        goto st26;
                }
                else if ( _widec >= 304 )
                    goto st26;
            }
            else if ( _widec > 378 )
            {
                if ( _widec < 577 )
                {
                    if ( 560 <= _widec && _widec <= 569 )
                        goto tr54;
                }
                else if ( _widec > 602 )
                {
                    if ( 609 <= _widec && _widec <= 634 )
                        goto tr54;
                }
                else
                    goto tr54;
            }
            else
                goto st26;

            goto tr85;
        }

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
_test_eof1:
        cs = 1;
        goto _test_eof;
_test_eof15:
        cs = 15;
        goto _test_eof;
_test_eof16:
        cs = 16;
        goto _test_eof;
_test_eof2:
        cs = 2;
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
_test_eof3:
        cs = 3;
        goto _test_eof;
_test_eof4:
        cs = 4;
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
_test_eof5:
        cs = 5;
        goto _test_eof;
_test_eof29:
        cs = 29;
        goto _test_eof;
_test_eof30:
        cs = 30;
        goto _test_eof;
_test_eof6:
        cs = 6;
        goto _test_eof;
_test_eof31:
        cs = 31;
        goto _test_eof;
_test_eof32:
        cs = 32;
        goto _test_eof;

_test_eof:
        {}

        if ( p == eof )
        {
            switch ( cs )
            {
            case 8:
                goto tr55;

            case 9:
                goto tr0;

            case 10:
                goto tr58;

            case 11:
                goto tr60;

            case 12:
                goto tr62;

            case 13:
                goto tr62;

            case 14:
                goto tr62;

            case 1:
                goto tr0;

            case 15:
                goto tr66;

            case 16:
                goto tr0;

            case 2:
                goto tr3;

            case 17:
                goto tr68;

            case 18:
                goto tr69;

            case 19:
                goto tr70;

            case 20:
                goto tr74;

            case 21:
                goto tr76;

            case 22:
                goto tr79;

            case 3:
                goto tr5;

            case 4:
                goto tr5;

            case 23:
                goto tr82;

            case 24:
                goto tr83;

            case 25:
                goto tr85;

            case 26:
                goto tr85;

            case 27:
                goto tr85;

            case 28:
                goto tr88;

            case 5:
                goto tr8;

            case 29:
                goto tr89;

            case 30:
                goto tr85;

            case 6:
                goto tr11;

            case 31:
                goto tr85;

            case 32:
                goto tr85;
            }
        }

_out:
        {}
    }


    return tok;
}
