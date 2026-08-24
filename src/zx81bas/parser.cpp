//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast_stmt.h"
#include "dump_context.h"
#include "errors.h"
#include "lexer.h"
#include "options.h"
#include "parser.h"
#include "release_assert.h"
#include "scan.h"
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

std::unordered_map<Keyword, Parser::StmtParser> Parser::pragma_parsers_lut = {
    { Keyword::AUTOSTART,       &Parser::parse_pragma_autostart },
    { Keyword::AUTOSTART_LINE,  &Parser::parse_pragma_autostart_line },
    { Keyword::INCREMENT,       &Parser::parse_pragma_increment },
    { Keyword::REMINVERT,       &Parser::parse_pragma_reminvert },
    { Keyword::FAST,            &Parser::parse_pragma_fast },
    { Keyword::VERBOSE,         &Parser::parse_pragma_verbose },
    { Keyword::VARS,            &Parser::parse_pragma_vars },
    { Keyword::DFILE,           &Parser::parse_pragma_dfile },
    { Keyword::DFILE_COLAPSED,  &Parser::parse_pragma_dfile_colapsed },
    { Keyword::SYSVARS,         &Parser::parse_pragma_sysvars },
};

std::unordered_map<Keyword, Parser::StmtParser> Parser::stmt_parsers_lut = {
    { Keyword::REM,             &Parser::parse_stmt_rem },
};

static bool is_string_variable(const std::string& name) {
    return !name.empty() && name.back() == '$';
}

bool Parser::at_end() const {
    return pos >= line().tokens.size();
}

bool Parser::at_end_of_stmt() const {
    return at_end() ||
           peek().type == TokenType::Colon ||
           peek().keyword == Keyword::ELSE ||
           peek().keyword == Keyword::UNTIL ||
           peek().keyword == Keyword::WEND ||
           peek().keyword == Keyword::NEXT;
}

void Parser::check_end_of_stmt() {
    if (at_end_of_stmt()) {
        return;     // end of input
    }

    // expect end of statement or colon, but found something else
    syntax_error("expected end of statement, found '" + peek().text + "'");
}

bool Parser::match(TokenType type) {
    if (peek().type == type) {
        ++pos;
        return true;
    }
    return false;
}

bool Parser::match(Keyword keyword) {
    if (peek().keyword == keyword) {
        ++pos;
        return true;
    }
    return false;
}

const Token& Parser::expect(TokenType type) {
    if (peek().type == type) {
        return line().tokens[pos++];
    }

    if (at_end()) {
        syntax_error("expected '" + token_type_name(type) +
                     "', found end of line");
    }
    else {
        syntax_error("expected '" + token_type_name(type) + "', " +
                     "found '" + peek().text + "'");
    }

    static const Token dummy;
    return dummy;  // unreachable, but avoids compiler warning
}

const Token& Parser::expect(Keyword keyword) {
    if (peek().keyword == keyword) {
        return line().tokens[pos++];
    }

    if (at_end()) {
        syntax_error("expected '" + keyword_name(keyword) +
                     "', found end of line");
    }
    else {
        syntax_error("expected '" + keyword_name(keyword) + "', " +
                     "found '" + peek().text + "'");
    }

    static const Token dummy;
    return dummy;  // unreachable, but avoids compiler warning
}

const Token& Parser::peek(size_t offset) const {
    static const Token end_of_line;
    size_t p = pos + offset;
    if (p >= line().tokens.size()) {
        return end_of_line;
    }
    return line().tokens[p];
}

const TokLine& Parser::line() const {
    return tok_file.lines[cur_line];
}

bool Parser::parse() {
    Keyword stop_kw = Keyword::None;
    bool ok = parse_stmt_block({}, stop_kw, prog.stmts);
    return ok && get_error_count() == 0;
}

bool Parser::parse_stmt_block(const std::unordered_set<Keyword>& stop_keywords,
                              Keyword& out_stop_keyword,
                              std::vector<std::unique_ptr<Stmt>>& out_stmts) {
    bool ok = true;
    while (cur_line < tok_file.lines.size()) {
        try {
            parse_stmt_line(stop_keywords, out_stop_keyword, out_stmts);
        }
        catch (const ParseError&) {
            // syntax_error() already reported the error
            ok = false;
        }

        cur_line++;
    }

    return ok;
}

void Parser::parse_stmt_line(const std::unordered_set<Keyword>& stop_keywords,
                             Keyword& out_stop_keyword,
                             std::vector<std::unique_ptr<Stmt>>& out_stmts) {
    // if line is ASM, create and parse a RemStmt
    if (line().source_type == SourceType::ASM) {
        auto rem_stmt = create_rem_stmt();
        if (rem_stmt) {
            out_stmts.push_back(std::move(rem_stmt));
        }
        return;
    }

    // source type is BASIC, parse line number and label if any
    release_assert(line().source_type == SourceType::BASIC);
    pos = 0;
    std::string label;
    int basic_line_num = -1;
    if (parse_label_line_num(label, basic_line_num)) {
        auto jump_target_stmt =
            std::make_unique<JumpTargetStmt>(line(), label, basic_line_num);
        out_stmts.push_back(std::move(jump_target_stmt));
    }

    // check for a stop-keyword (end of block)
    if (!stop_keywords.empty()) {
        Keyword kw = peek().keyword;
        if (kw != Keyword::None && stop_keywords.count(kw) > 0) {
            out_stop_keyword = kw;
            pos++;
            check_end_of_stmt();
            return;
        }
    }

    // parse a colon-sepatated statement list
    parse_stmt_list(stop_keywords, out_stop_keyword, out_stmts);
}

void Parser::parse_stmt_list(const std::unordered_set<Keyword>& stop_keywords,
                             Keyword& out_stop_keyword,
                             std::vector<std::unique_ptr<Stmt>>& out_stmts) {
    while (!at_end()) {
        if (peek().type == TokenType::Colon) {
            pos++;  // skip colons
            continue;
        }

        // check for a stop-keyword (end of block)
        if (!stop_keywords.empty()) {
            Keyword kw = peek().keyword;
            if (kw != Keyword::None && stop_keywords.count(kw) > 0) {
                out_stop_keyword = kw;
                pos++;
                check_end_of_stmt();
                return;
            }
        }

        // parse a statement
        std::unique_ptr<Stmt> stmt = parse_stmt();
        if (stmt) {
            out_stmts.push_back(std::move(stmt));
        }
    }
}

std::unique_ptr<Stmt> Parser::parse_stmt() {
    std::unique_ptr<Stmt> stmt;

    // BASIC pragma statement
    if (peek().type == TokenType::Exclamation ||
            peek().type == TokenType::Hash) {
        pos++;  // consume '!' or '#'
        const Token& keyword_tok = expect(TokenType::Identifier);
        auto it = pragma_parsers_lut.find(keyword_tok.keyword);
        if (it != pragma_parsers_lut.end()) {
            StmtParser fn = it->second;
            stmt = (this->*fn)();
            check_end_of_stmt();
            return stmt;
        }
        else {
            syntax_error("unrecognized pragma statement '" + keyword_tok.text + "'");
        }
    }

    // BASIC statement
    auto it = stmt_parsers_lut.find(peek().keyword);
    if (it != stmt_parsers_lut.end()) {
        pos++;  // consume keyword
        StmtParser fn = it->second;
        auto stmt = (this->*fn)();
        check_end_of_stmt();
        return stmt;
    }

    // fall through : unrecognized statement
    if (peek().type == TokenType::Identifier) {
        syntax_error("unrecognized statement '" + peek().text + "'");
    }
    else {
        syntax_error("expected a BASIC language statement, found '" +
                     peek().text + "'");
    }
    return nullptr;
}

bool Parser::parse_label_line_num(std::string& out_label,
                                  int& out_basic_line_num) {
    bool found_label = false;
    bool found_line_num = false;
    bool found_any = true;
    while (found_any) {
        found_any = false;

        if (peek().type == TokenType::At) {
            pos++;
            const Token& label_token = expect(TokenType::Identifier);
            expect(TokenType::Colon);

            if (found_label) {
                syntax_error("multiple labels in the same line are not allowed");
            }
            out_label = label_token.text;
            found_label = true;
            found_any = true;
        }

        if (peek().type == TokenType::Integer) {
            if (found_line_num) {
                syntax_error("multiple line numbers in the same line are not allowed");
            }
            out_basic_line_num = peek().ivalue;
            pos++;
            found_line_num = true;
            found_any = true;
        }
    }
    return found_label || found_line_num;
}

std::unique_ptr<Stmt> Parser::create_rem_stmt() {
    // create virtual REM statement
    TokLine rem_line;
    rem_line.source_type = SourceType::BASIC;
    rem_line.src_line.text = "REM";
    rem_line.src_line.filename = line().src_line.filename;
    rem_line.src_line.line_num = line().src_line.line_num;
    tokenize_line(rem_line.src_line.text, rem_line.source_type,
                  rem_line.src_line.filename, rem_line.src_line.line_num,
                  rem_line.tokens);

    auto stmt = std::make_unique<RemStmt>(rem_line);
    collect_asm_lines(cur_line, stmt->asm_lines);
    return stmt;
}

void Parser::collect_asm_lines(size_t start_line,
                               std::vector<TokLine>& out_asm_lines) {
    bool collected = false;
    size_t last_line = 0;

    for (size_t i = start_line; i < tok_file.lines.size(); ++i) {
        if (tok_file.lines[i].source_type == SourceType::ASM) {
            out_asm_lines.push_back(tok_file.lines[i]);
            collected = true;
            last_line = i;
        }
        else {
            break;
        }
    }

    // point to last asm line collected, so that the main loop can continue from there
    if (collected) {
        cur_line = last_line;
        pos = line().tokens.size();
    }
}

std::unique_ptr<Stmt> Parser::parse_pragma_autostart() {
    expect(TokenType::Equal);

    // #AUTOSTART = 0 or 1
    const Token& num_tok = expect(TokenType::Integer);
    prog.auto_start = num_tok.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_autostart_line() {
	expect(TokenType::Equal);

    // #AUTOSTART_LINE = line_number
	if (peek().type == TokenType::Integer) {
        prog.auto_start_line = peek().ivalue;
		pos++;
        return nullptr;
    }

    // #AUTOSTART_LINE = label_name
    if (peek().type == TokenType::At) {
		pos++;
		const Token& ident = expect(TokenType::Identifier);
        prog.auto_start_label = ident.text;
        return nullptr;
    }

    syntax_error("expected '= number|@label' after '#AUTOSTART_LINE'");
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_increment() {
    // #INCREMENT = number
	expect(TokenType::Equal);
	const Token& num = expect(TokenType::Integer);
    if (num.ivalue < 1) {
        syntax_error("#INCREMENT must be positive");
    }
	prog.increment = num.ivalue;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_reminvert() {
    // #REMINVERT = 0 or 1
	expect(TokenType::Equal);
	const Token& num = expect(TokenType::Integer);
	prog.rem_invert = num.ivalue != 0;
	return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_fast() {
    // #FAST = 0 or 1
	expect(TokenType::Equal);
	const Token& num = expect(TokenType::Integer);
	prog.fast_mode = num.ivalue != 0;
	return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_verbose() {
    // #VERBOSE = 0 or 1
	expect(TokenType::Equal);
	const Token& num = expect(TokenType::Integer);
	g_verbose = num.ivalue != 0;
	return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_vars() {
    // parse var[$][(n,n...,n)]
    std::string var_name;
    std::vector<int> dims;
    parse_vars_def(var_name, dims);
    expect(TokenType::Equal);

    if (is_string_variable(var_name)) {
        if (dims.size() == 0) {
            // #VARS A$="XXX"
            auto stmt = std::make_unique<PragmaStrVarStmt>(line());
            stmt->var_name = var_name;
            const Token& str = expect(TokenType::StringLiteral);
			stmt->value = str.svalue;
            collect_asm_lines(cur_line + 1, stmt->asm_lines);
            return stmt;
        }
        else {
            // #VARS A$(n,n,...,n)="XXX","XXX",...
            auto stmt = std::make_unique<PragmaStrVarArrayStmt>(line());
            stmt->var_name = var_name;
            stmt->dims = std::move(dims);
            while (true) {
				const Token& str = expect(TokenType::StringLiteral);
				stmt->values.push_back(str.svalue);
				if (match(TokenType::Comma)) {
					continue;
				}
                else {
                    break;
                }
            }
            return stmt;
        }
    }
    else {
        if (dims.size() == 0) {
            // #VARS A=123
            auto stmt = std::make_unique<PragmaNumVarStmt>(line());
            stmt->var_name = var_name;
            if (peek().type == TokenType::Integer) {
                const Token& num = expect(TokenType::Integer);
                stmt->value = num.ivalue;
            }
            else {
                const Token& num = expect(TokenType::Float);
                stmt->value = num.nvalue;
            }
            return stmt;
        }
        else {
            // #VARS A(n,n,...,n)=123,456,...
            auto stmt = std::make_unique<PragmaNumVarArrayStmt>(line());
            stmt->var_name = var_name;
            stmt->dims = std::move(dims);
            while (true) {
                if (peek().type == TokenType::Integer) {
                    const Token& num = expect(TokenType::Integer);
                    stmt->values.push_back(num.ivalue);
                }
                else {
                    const Token& num = expect(TokenType::Float);
                    stmt->values.push_back(num.nvalue);
                }
				if (match(TokenType::Comma)) {
					continue;
				}
                else {
                    break;
                }
            }
            return stmt;
        }
    }
}

void Parser::parse_vars_def(std::string &out_var_name, std::vector<int> &out_dims) {
    out_dims.clear();

    // variable name
    const Token& ident = expect(TokenType::Identifier);
    out_var_name = ident.text;

    // either '(' for array or '=' for plain variable
    if (peek().type == TokenType::LeftParen) {
        pos++;  // skip '('
        while (true) {
            const Token& num = expect(TokenType::Integer);
            out_dims.push_back(num.ivalue);
            if (match(TokenType::Comma)) {
                continue;
            }
            else {
                break;
            }
        }
        expect(TokenType::RightParen);
    }
    // end with pos pointing at the '='
}

std::unique_ptr<Stmt> Parser::parse_pragma_dfile() {
    // #DFILE = "line 1", "line 2", ...
	expect(TokenType::Equal);
	prog.dfile_lines.clear();
	while (true) {
		const Token& str = expect(TokenType::StringLiteral);
		prog.dfile_lines.push_back(str.svalue);
		if (match(TokenType::Comma)) {
			continue;
		}
		else {
			break;
		}
	}
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_dfile_colapsed() {
    // #DFILE_COLAPSED = 0 or 1
	expect(TokenType::Equal);
	const Token& num = expect(TokenType::Integer);
	prog.dfile_colapsed = num.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_sysvars() {
    // !SYSVARS = nn,nn,nn,...
	expect(TokenType::Equal);
	prog.sysvars_data.clear();
	while (true) {
		const Token& num = expect(TokenType::Integer);
		if (num.ivalue > 255) {
			syntax_error("values must be in range 0..255, found " +
                 std::to_string(num.ivalue));
		}
		prog.sysvars_data.push_back(static_cast<uint8_t>(num.ivalue));
		if (match(TokenType::Comma)) {
			continue;
		}
		else {
			break;
		}
	}
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_stmt_rem() {
    auto stmt = std::make_unique<RemStmt>(line());

    // concatenate all remaining tokens in the line into a
    // single string for the REM statement
    // include the whitespace before each token to preserve the original formatting
    std::string text;
    while (!at_end()) {
        text += peek().ws_before + peek().text;
        pos++;
    }

    // remove the first blank after REM
    if (!text.empty() && isspace(text[0])) {
        text.erase(0, 1);
    }

    stmt->text = text;
    check_end_of_stmt();

    // collect assembly following REM
    collect_asm_lines(cur_line + 1, stmt->asm_lines);

    return stmt;
}

[[noreturn]]
void Parser::syntax_error(const std::string& msg) const {
    if (tok_file.lines.empty()) {
        error(msg);
    }
    else if (cur_line >= tok_file.lines.size()) {
        size_t last_line = tok_file.lines.size() - 1;
        error(tok_file.lines[last_line].src_line.filename,
              tok_file.lines[last_line].src_line.line_num + 1,
              msg);
    }
    else {
        const Token& tok = at_end()
                           ? line().tokens.back()
                           : peek();
        error(tok.filename, tok.line_num, msg);
    }
    throw ParseError(msg);
}

bool parse_basic_program(const TokFile& tok_file,
                         std::unique_ptr<Prog>& out_prog) {
    auto prog = std::make_unique<Prog>();

    Parser parser{ *prog, tok_file, 0, 0 };
    bool ok = parser.parse();
    if (ok) {
        out_prog = std::move(prog);
    }

#ifdef _DEBUG
    if (g_dump_step == 5) {
        if (ok) {
            DumpContext ctx(std::cout);
            out_prog->dump(ctx);
            exit(EXIT_SUCCESS);
        }
        else {
            std::cout << "Parsing failed with errors." << std::endl;
            exit(EXIT_FAILURE);
        }
    }
#endif

    return ok;
}

