//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "cpu.h"
#include "expr.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "options.h"
#include "parser.h"
#include "source_loc.h"
#include "string_interner.h"
#include <memory>
#include <unordered_map>
#include <utility>
#include <vector>

std::unordered_map<Keyword, Parser::DirectiveParseFn> Parser::directive_parsers
= {
    { Keyword::ALIGN,     &Parser::parse_ALIGN },
    { Keyword::DEFC,      &Parser::parse_DEFC },
    { Keyword::EXTERN,    &Parser::parse_EXTERN },
    { Keyword::GLOBAL,    &Parser::parse_GLOBAL },
    { Keyword::MODULE,    &Parser::parse_MODULE },
    { Keyword::ORG,       &Parser::parse_ORG },
    { Keyword::PRAGMA,    &Parser::parse_PRAGMA },
    { Keyword::PUBLIC,    &Parser::parse_PUBLIC },
    { Keyword::SECTION,   &Parser::parse_SECTION },
    { Keyword::CALL_OZ,   &Parser::parse_CALL_OZ },
};

std::unique_ptr<Stmt> Parser::parse_directive(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    if (pline.eol()) {
        return nullptr;
    }

    Token tok = pline.peek();
    if (tok.keyword == Keyword::None) {
        return nullptr;
    }

    auto it = directive_parsers.find(tok.keyword);
    if (it == directive_parsers.end()) {
        return nullptr;
    }

    pline.advance(); // consume directive keyword
    auto result = (this->*it->second)(pline, loc, status);

    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    if (!pline.check_end_of_line()) {
        status = ParseStatus::FatalError;
        return nullptr;    // error already reported
    }

    return result;
}

// Helper to parse comma-separated list of identifiers
template<typename StmtType>
static std::unique_ptr<Stmt> parse_identifier_list(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    std::vector<StringInterner::Id> name_ids;

    while (true) {
        if (pline.peek().type != TokenType::Identifier) {
            pline.error("Identifier expected");
            status = ParseStatus::FatalError;
            return nullptr;
        }
        auto name_id = pline.peek().text_id;
        name_ids.push_back(name_id);
        pline.advance(); // consume identifier

        if (pline.peek().type == TokenType::Comma) {
            pline.advance(); // consume comma
        }
        else {
            break;
        }
    }

    return std::make_unique<StmtType>(std::move(name_ids), loc);
}

std::unique_ptr<Stmt> Parser::parse_EXTERN(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    return parse_identifier_list<ExternStmt>(pline, loc, status);
}

std::unique_ptr<Stmt> Parser::parse_PUBLIC(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    return parse_identifier_list<PublicStmt>(pline, loc, status);
}

std::unique_ptr<Stmt> Parser::parse_GLOBAL(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    return parse_identifier_list<GlobalStmt>(pline, loc, status);
}

std::unique_ptr<Stmt> Parser::parse_MODULE(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    return std::make_unique<ModuleStmt>(name_id, loc);
}

std::unique_ptr<Stmt> Parser::parse_SECTION(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    return std::make_unique<SectionStmt>(name_id, loc);
}

std::unique_ptr<Stmt> Parser::parse_ORG(ParseLine& pline, const SourceLoc& loc,
                                        ParseStatus& status) {
    status = ParseStatus::Unknown;
    auto expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    if (!expr) {
        pline.error("Expression expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }

    return std::make_unique<OrgStmt>(std::move(expr), loc);
}

std::unique_ptr<Stmt> Parser::parse_DEFC(ParseLine& pline, const SourceLoc& loc,
        ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    if (pline.peek().type != TokenType::EQ) {
        pline.error("'=' expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    pline.advance(); // consume '='

    status = ParseStatus::Unknown;
    auto expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    if (!expr) {
        pline.error("Expression expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }

    return std::make_unique<DefcStmt>(name_id, std::move(expr), loc);
}

std::unique_ptr<Stmt> Parser::parse_ALIGN(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    // get first parameter (alignment)
    status = ParseStatus::Unknown;
    auto align_expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    // second parameter (fill byte) is optional; if not present, use default from options
    if (pline.eol()) {
        auto filler_expr = std::make_unique<ExprLiteralInt>(g_args.options.filler_byte,
                           loc);
        return std::make_unique<AlignStmt>(std::move(align_expr),
                                           std::move(filler_expr), loc);
    }

    // get second parameter (fill byte)
    if (pline.peek().type != TokenType::Comma) {
        pline.error("Expected comma after alignment expression");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    pline.advance(); // consume comma

    auto fill_expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    return std::make_unique<AlignStmt>(std::move(align_expr),
                                       std::move(fill_expr), loc);
}

std::unique_ptr<Stmt> Parser::parse_PRAGMA(ParseLine& pline, const SourceLoc&,
        ParseStatus& status) {
    if (pline.peek().keyword == Keyword::CPU_ADL) {
        pline.advance(); // consume identifier

        if (pline.peek().type != TokenType::Integer ||
                (pline.peek().value.int_value != 0 && pline.peek().value.int_value != 1)) {
            pline.error("Expected 0/1 after PRAGMA CPU_ADL");
            status = ParseStatus::FatalError;
            return nullptr;
        }
        bool adl_value = (pline.peek().value.int_value != 0);
        pline.advance(); // consume integer

        if (!cpu_set_adl_mode(parser_cpu_id, adl_value)) {
            pline.error("CPU " + cpu_name(parser_cpu_id) + " does not support ADL mode");
            status = ParseStatus::FatalError;
            return nullptr;
        }

        status = ParseStatus::Ok;   // nullptr but OK
        return nullptr;
    }

    // ignore unknown pragmas, consume rest of line
    while (!pline.eol()) {
        pline.advance();
    }

    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_CALL_OZ(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    status = ParseStatus::Unknown;
    auto expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    if (!expr) {
        pline.error("Expression expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }

    return std::make_unique<CallOzStmt>(std::move(expr), loc);
}
