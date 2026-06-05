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

    return std::make_unique<StmtType>(loc, std::move(name_ids));
}

static std::unique_ptr<Stmt> parse_extern(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    return parse_identifier_list<ExternStmt>(pline, loc, status);
}

static std::unique_ptr<Stmt> parse_public(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    return parse_identifier_list<PublicStmt>(pline, loc, status);
}

static std::unique_ptr<Stmt> parse_global(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    return parse_identifier_list<GlobalStmt>(pline, loc, status);
}

static std::unique_ptr<Stmt> parse_module(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    return std::make_unique<ModuleStmt>(loc, name_id);
}

static std::unique_ptr<Stmt> parse_section(ParseLine& pline,
        const SourceLoc& loc,
        ParseStatus& status) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Identifier expected");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    auto name_id = pline.peek().text_id;
    pline.advance(); // consume identifier

    return std::make_unique<SectionStmt>(loc, name_id);
}

static std::unique_ptr<Stmt> parse_org(ParseLine& pline, const SourceLoc& loc,
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

    return std::make_unique<OrgStmt>(loc, std::move(expr));
}

static std::unique_ptr<Stmt> parse_defc(ParseLine& pline, const SourceLoc& loc,
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

    return std::make_unique<DefcStmt>(loc, name_id, std::move(expr));
}

static const std::unordered_map<Keyword, DirectiveParseFn> directive_table = {
    { Keyword::EXTERN,  parse_extern },
    { Keyword::PUBLIC,  parse_public },
    { Keyword::GLOBAL,  parse_global },
    { Keyword::MODULE,  parse_module },
    { Keyword::SECTION, parse_section },
    { Keyword::ORG,     parse_org },
    { Keyword::DEFC,    parse_defc },
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

