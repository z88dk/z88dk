//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "directives.h"
#include "expr.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "options.h"
#include "source_loc.h"
#include "string_interner.h"
#include <memory>
#include <unordered_map>
#include <utility>
#include <vector>

using DirectiveParseFn = std::unique_ptr<Stmt>(*)(ParseLine&, const SourceLoc&,
                         ParseStatus&);

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

static std::unique_ptr<Stmt> parse_EXTERN(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    return parse_identifier_list<ExternStmt>(pline, loc, status);
}

static std::unique_ptr<Stmt> parse_PUBLIC(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    return parse_identifier_list<PublicStmt>(pline, loc, status);
}

static std::unique_ptr<Stmt> parse_GLOBAL(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    return parse_identifier_list<GlobalStmt>(pline, loc, status);
}

static std::unique_ptr<Stmt> parse_MODULE(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    return std::make_unique<ModuleStmt>(name_id, loc);
}

static std::unique_ptr<Stmt> parse_SECTION(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    return std::make_unique<SectionStmt>(name_id, loc);
}

static std::unique_ptr<Stmt> parse_ORG(ParseLine& pline, const SourceLoc& loc,
                                       ParseStatus& status) {
    status = ParseStatus::Ok;
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

static std::unique_ptr<Stmt> parse_DEFC(ParseLine& pline, const SourceLoc& loc,
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

    status = ParseStatus::Ok;
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

static std::unique_ptr<Stmt> parse_ALIGN(ParseLine& pline, const SourceLoc& loc,
        ParseStatus& status) {

    // get first parameter (alignment)
    status = ParseStatus::Ok;
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

static const std::unordered_map<Keyword, DirectiveParseFn> directive_table = {
    { Keyword::ALIGN,   parse_ALIGN },
    { Keyword::DEFC,    parse_DEFC },
    { Keyword::EXTERN,  parse_EXTERN },
    { Keyword::GLOBAL,  parse_GLOBAL },
    { Keyword::MODULE,  parse_MODULE },
    { Keyword::ORG,     parse_ORG },
    { Keyword::PUBLIC,  parse_PUBLIC },
    { Keyword::SECTION, parse_SECTION },
};

std::unique_ptr<Stmt> parse_directive(ParseLine& pline, const SourceLoc& loc,
                                      ParseStatus& status) {
    if (pline.eol()) {
        return nullptr;
    }

    Token tok = pline.peek();
    if (tok.keyword == Keyword::None) {
        return nullptr;
    }

    auto it = directive_table.find(tok.keyword);
    if (it == directive_table.end()) {
        return nullptr;
    }

    pline.advance(); // consume directive keyword
    return it->second(pline, loc, status);
}

