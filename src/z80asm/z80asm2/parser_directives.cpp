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
#include <cstdint>
#include <memory>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

std::unordered_map<Keyword, Parser::DirectiveParseFn> Parser::directive_parsers
= {
    { Keyword::ALIGN,     &Parser::parse_ALIGN },
    { Keyword::BYTE,      &Parser::parse_BYTE },
    { Keyword::DB,        &Parser::parse_BYTE },
    { Keyword::DC,        &Parser::parse_DEFC },
    { Keyword::DDB,       &Parser::parse_WORD_BE },
    { Keyword::DEFB,      &Parser::parse_BYTE },
    { Keyword::DEFC,      &Parser::parse_DEFC },
    { Keyword::DEFDB,     &Parser::parse_WORD_BE },
    { Keyword::DEFM,      &Parser::parse_BYTE },
    { Keyword::DEFP,      &Parser::parse_PTR },
    { Keyword::DEFQ,      &Parser::parse_DWORD },
    { Keyword::DEFS,      &Parser::parse_DEFS },
    { Keyword::DEFW,      &Parser::parse_WORD },
    { Keyword::DEFW_BE,   &Parser::parse_WORD_BE },
    { Keyword::DM,        &Parser::parse_BYTE },
    { Keyword::DP,        &Parser::parse_PTR },
    { Keyword::DQ,        &Parser::parse_DWORD },
    { Keyword::DS,        &Parser::parse_DEFS },
    { Keyword::DW,        &Parser::parse_WORD },
    { Keyword::DW_BE,     &Parser::parse_WORD_BE },
    { Keyword::DWORD,     &Parser::parse_DWORD },
    { Keyword::EXTERN,    &Parser::parse_EXTERN },
    { Keyword::GLOBAL,    &Parser::parse_GLOBAL },
    { Keyword::MODULE,    &Parser::parse_MODULE },
    { Keyword::ORG,       &Parser::parse_ORG },
    { Keyword::PRAGMA,    &Parser::parse_PRAGMA },
    { Keyword::PTR,       &Parser::parse_PTR },
    { Keyword::PUBLIC,    &Parser::parse_PUBLIC },
    { Keyword::SECTION,   &Parser::parse_SECTION },
    { Keyword::WORD,      &Parser::parse_WORD },
    { Keyword::WORD_BE,   &Parser::parse_WORD_BE },
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
    uint8_t default_filler = g_args.options.filler_byte;

    // get first parameter (alignment)
    status = ParseStatus::Unknown;
    auto align_expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    // second parameter (fill byte) is optional;
    // if not present, use default from options
    if (pline.eol()) {
        auto filler_expr = std::make_unique<ExprLiteralInt>(default_filler, loc);
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

std::unique_ptr<Stmt> Parser::parse_DEFS(ParseLine& pline, const SourceLoc& loc,
        ParseStatus& status) {
    uint8_t default_filler = g_args.options.filler_byte;

    // get first parameter (size)
    status = ParseStatus::Unknown;
    auto size_expr = parse_expression_ast(pline, status);
    if (status == ParseStatus::FatalError) {
        return nullptr;    // stop immediately on error
    }

    // second parameter (fill byte) is optional;
    // if not present, use default from options
    if (pline.eol()) {
        auto filler_expr = std::make_unique<ExprLiteralInt>(default_filler, loc);
        return std::make_unique<DefsNumericStmt>(std::move(size_expr),
                std::move(filler_expr), loc);
    }

    // get second parameter (fill byte or string)
    if (pline.peek().type != TokenType::Comma) {
        pline.error("Expected comma after size expression");
        status = ParseStatus::FatalError;
        return nullptr;
    }
    pline.advance(); // consume comma

    if (pline.peek().type == TokenType::String) {
        // string literal case - convert to byte array
        auto str_value_id = pline.peek().value.str_value_id;
        pline.advance(); // consume string

        return std::make_unique<DefsStringStmt>(std::move(size_expr),
                                                str_value_id, default_filler, loc);
    }
    else {
        // expression case - evaluate to byte value
        auto filler_expr = parse_expression_ast(pline, status);
        if (status == ParseStatus::FatalError) {
            return nullptr;    // stop immediately on error
        }

        return std::make_unique<DefsNumericStmt>(std::move(size_expr),
                std::move(filler_expr), loc);
    }
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
            pline.error("CPU " + to_string(parser_cpu_id) + " does not support ADL mode");
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

// Helper to parse comma-separated list of expressions with specified patch size and type
static std::unique_ptr<Stmt> parse_data_with_size_type(
    ParseLine& pline,
    const SourceLoc& loc,
    ParseStatus& status,
    uint8_t patch_size,
    PatchType patch_type) {
    // create statement with empty byte list, and fill it with expressions until end of line
    auto stmt = std::make_unique<OpcodeStmt>(loc);

    while (true) {
        // parse expression
        auto expr = parse_expression_ast(pline, status);
        if (status == ParseStatus::FatalError) {
            return nullptr;    // stop immediately on error
        }

        if (!expr) {
            pline.error("Expression expected");
            status = ParseStatus::FatalError;
            return nullptr;
        }

        auto patch = std::make_unique<Patch>(std::move(expr), loc);
        patch->offset = stmt->bytes.size();
        patch->size = patch_size;
        patch->is_constant = false;
        patch->type = patch_type;

        // add placeholder bytes
        for (uint8_t i = 0; i < patch_size; i++) {
            stmt->bytes.push_back(0);
        }
        stmt->patches.push_back(std::move(patch));

        if (pline.peek().type == TokenType::Comma) {
            pline.advance(); // consume ','
        }
        else {
            break;  // end of list
        }
    }

    if (!pline.check_end_of_line()) {
        status = ParseStatus::FatalError;
        return nullptr;    // error already reported
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_BYTE(ParseLine& pline, const SourceLoc& loc,
        ParseStatus& status) {
    // create statement with empty byte list, and fill it with expressions until end of line
    auto stmt = std::make_unique<OpcodeStmt>(loc);

    while (true) {
        if (pline.peek().type == TokenType::String) {
            // parse string literal as a sequence of byte literals
            std::string_view str = g_strings.view(pline.peek().value.str_value_id);
            for (char c : str) {
                stmt->bytes.push_back(static_cast<uint8_t>(c));
            }
            pline.advance(); // consume string
        }
        else {
            // parse expression as a byte literal
            auto expr = parse_expression_ast(pline, status);
            if (status == ParseStatus::FatalError) {
                return nullptr;    // stop immediately on error
            }

            if (!expr) {
                pline.error("Expression expected");
                status = ParseStatus::FatalError;
                return nullptr;
            }

            auto patch = std::make_unique<Patch>(std::move(expr), loc);
            patch->offset = stmt->bytes.size();
            patch->size = 1;
            patch->is_constant = false;
            patch->type = PatchType::Unsigned;

            stmt->bytes.push_back(0);   // placeholder byte, will be replaced by patch
            stmt->patches.push_back(std::move(patch));
        }

        if (pline.peek().type == TokenType::Comma) {
            pline.advance(); // consume ','
        }
        else {
            break;  // end of byte list
        }
    }

    if (!pline.check_end_of_line()) {
        status = ParseStatus::FatalError;
        return nullptr;    // error already reported
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_WORD(ParseLine& pline, const SourceLoc& loc,
        ParseStatus& status) {
    return parse_data_with_size_type(pline, loc, status, 2, PatchType::Unsigned);
}

std::unique_ptr<Stmt> Parser::parse_WORD_BE(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    return parse_data_with_size_type(pline, loc, status, 2, PatchType::BigEndian);
}

std::unique_ptr<Stmt> Parser::parse_PTR(ParseLine& pline, const SourceLoc& loc,
                                        ParseStatus& status) {
    return parse_data_with_size_type(pline, loc, status, 3, PatchType::Unsigned);
}

std::unique_ptr<Stmt> Parser::parse_DWORD(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    return parse_data_with_size_type(pline, loc, status, 4, PatchType::Unsigned);
}

