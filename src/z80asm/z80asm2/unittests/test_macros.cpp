//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../macros.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Macro tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: constructor and accessors", "[model][macro]") {
    Location loc("macro.asm", 42);
    Macro macro("FOO", loc);

    REQUIRE(macro.name() == "FOO");
    REQUIRE(macro.location().filename() == "macro.asm");
    REQUIRE(macro.location().line_num() == 42);
    REQUIRE_FALSE(macro.is_function_like());
    REQUIRE(macro.parameters().empty());
    REQUIRE(macro.locals().empty());
    REQUIRE(macro.body_lines().empty());
}

TEST_CASE("Macro: function-like flag", "[model][macro]") {
    Location loc("macro.asm", 1);
    Macro macro("BAR", loc);

    REQUIRE_FALSE(macro.is_function_like());
    macro.set_function_like(true);
    REQUIRE(macro.is_function_like());
    macro.set_function_like(false);
    REQUIRE_FALSE(macro.is_function_like());
}

TEST_CASE("Macro: add unique parameters and preserve order", "[model][macro]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 10);
    Macro macro("M", loc);

    macro.add_parameter("a");
    macro.add_parameter("b");
    macro.add_parameter("c");

    const auto& params = macro.parameters();
    REQUIRE(params.size() == 3);
    REQUIRE(params[0] == "a");
    REQUIRE(params[1] == "b");
    REQUIRE(params[2] == "c");
    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Macro: duplicate parameter reports error", "[model][macro]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 20);
    Macro macro("M", loc);

    macro.add_parameter("p");
    macro.add_parameter("p"); // duplicate

    REQUIRE(macro.parameters().size() == 1);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Macro: add unique locals and preserve order", "[model][macro]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 30);
    Macro macro("M", loc);

    macro.add_local("x");
    macro.add_local("y");

    const auto& locals = macro.locals();
    REQUIRE(locals.size() == 2);
    REQUIRE(locals[0] == "x");
    REQUIRE(locals[1] == "y");
    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Macro: duplicate local reports error", "[model][macro]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 40);
    Macro macro("M", loc);

    macro.add_local("t");
    macro.add_local("t"); // duplicate

    REQUIRE(macro.locals().size() == 1);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Macro: local cannot duplicate parameter name", "[model][macro]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 50);
    Macro macro("M", loc);

    macro.add_parameter("p");
    macro.add_local("p");   // should error and not be added

    REQUIRE(macro.parameters().size() == 1);
    REQUIRE(macro.locals().size() == 0);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Macro: add body line copies and overwrites location", "[model][macro]") {
    SuppressErrors suppress;
    Location mac_loc("macro.asm", 60);
    Macro macro("M", mac_loc);

    Location other_loc("other.asm", 99);
    std::vector<Token> toks;
    toks.emplace_back(TokenType::Identifier, "LD", false);
    toks.emplace_back(TokenType::Identifier, "A", false);
    TokenLine line(other_loc, toks);

    macro.add_body_line(line);

    const auto& body = macro.body_lines();
    REQUIRE(body.size() == 1);
    REQUIRE(body[0].location().filename() == "macro.asm");
    REQUIRE(body[0].location().line_num() == 60);
    REQUIRE(body[0].tokens().size() == 2);
    REQUIRE(body[0].tokens()[0].is(TokenType::Identifier));
    REQUIRE(body[0].tokens()[0].text() == "LD");
    REQUIRE(body[0].tokens()[1].is(TokenType::Identifier));
    REQUIRE(body[0].tokens()[1].text() == "A");
}

//-----------------------------------------------------------------------------
// Macro parse_parameters tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: parse_parameters empty without parens", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 100);
    Macro macro("M", loc);

    TokenLine line(loc, {}); // no tokens
    size_t index = 0;
    REQUIRE(macro.parse_parameters(line, index));
    REQUIRE(index == 0);
    REQUIRE(macro.parameters().empty());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_parameters empty with parens", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 101);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::RightParen, ")", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE(macro.parse_parameters(line, index));
    REQUIRE(index == 2);
    REQUIRE(macro.parameters().empty());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_parameters simple list", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 102);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "a", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "b", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "c", false),
        Token(TokenType::Identifier, "NEXT", false) // extra token not parsed
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE(macro.parse_parameters(line, index));
    REQUIRE(index == 5);
    const auto& params = macro.parameters();
    REQUIRE(params.size() == 3);
    REQUIRE(params[0] == "a");
    REQUIRE(params[1] == "b");
    REQUIRE(params[2] == "c");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_parameters list in parens", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 103);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "x", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "y", false),
        Token(TokenType::RightParen, ")", false),
        Token(TokenType::Identifier, "AFTER", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE(macro.parse_parameters(line, index));
    REQUIRE(index == 5);
    const auto& params = macro.parameters();
    REQUIRE(params.size() == 2);
    REQUIRE(params[0] == "x");
    REQUIRE(params[1] == "y");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_parameters syntax error missing identifier after comma", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 104);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "p", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::RightParen, ")", false) // error: expecting identifier before ')'
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE_FALSE(macro.parse_parameters(line, index));
    REQUIRE(index == 0);               // unchanged on error
    REQUIRE(g_errors.has_errors());    // syntax error reported
    REQUIRE(macro.parameters().size() == 0);
}

TEST_CASE("Macro: parse_parameters syntax error missing closing paren", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 105);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "p", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "q", false)
        // missing ')'
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE_FALSE(macro.parse_parameters(line, index));
    REQUIRE(index == 0);
    REQUIRE(g_errors.has_errors());
    REQUIRE(macro.parameters().empty());
}

TEST_CASE("Macro: parse_parameters duplicate parameter names report error", "[model][macro][params]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 106);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "a", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "a", false), // duplicate
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "b", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE_FALSE(macro.parse_parameters(line, index));
    REQUIRE(macro.parameters().size() == 0);
    REQUIRE(g_errors.has_errors());
}

//-----------------------------------------------------------------------------
// Macro parse_locals tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: parse_locals empty when next token is not identifier", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 200);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Comma, ",", false), // not an identifier
        Token(TokenType::Identifier, "x", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE(macro.parse_locals(line, index));
    REQUIRE(index == 0);                 // unchanged
    REQUIRE(macro.locals().empty());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_locals simple list without parens", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 201);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "l1", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "l2", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "l3", false),
        Token(TokenType::Identifier, "AFTER", false) // extra token not parsed
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE(macro.parse_locals(line, index));
    REQUIRE(index == 5);
    const auto& locals = macro.locals();
    REQUIRE(locals.size() == 3);
    REQUIRE(locals[0] == "l1");
    REQUIRE(locals[1] == "l2");
    REQUIRE(locals[2] == "l3");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_locals syntax error missing identifier after comma", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 202);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "a", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::RightParen, ")", false) // ')' is invalid here; expect identifier
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE_FALSE(macro.parse_locals(line, index));
    REQUIRE(index == 0);                // unchanged on error
    REQUIRE(g_errors.has_errors());
    REQUIRE(macro.locals().empty());    // cleared on error
}

TEST_CASE("Macro: parse_locals duplicate within list reports error and clears locals", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 203);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "x", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "x", false) // duplicate
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE_FALSE(macro.parse_locals(line, index));
    REQUIRE(macro.locals().size() == 0);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_locals conflicts with existing parameter name", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 204);
    Macro macro("M", loc);

    macro.add_parameter("p1");

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "p1", false) // conflicts with parameter
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE_FALSE(macro.parse_locals(line, index));
    REQUIRE(macro.locals().empty());
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_locals appends to existing locals", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 205);
    Macro macro("M", loc);

    // pre-existing locals
    macro.add_local("a");

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "b", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "c", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    REQUIRE(macro.parse_locals(line, index));
    const auto& locals = macro.locals();
    REQUIRE(locals.size() == 3);
    REQUIRE(locals[0] == "a");
    REQUIRE(locals[1] == "b");
    REQUIRE(locals[2] == "c");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_locals concatenates results across multiple calls", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 206);
    Macro macro("M", loc);

    // First parse: l1, l2
    {
        std::vector<Token> toks = {
            Token(TokenType::Identifier, "l1", false),
            Token(TokenType::Comma, ",", false),
            Token(TokenType::Identifier, "l2", false)
        };
        TokenLine line(loc, toks);
        size_t index = 0;
        REQUIRE(macro.parse_locals(line, index));
        REQUIRE(index == toks.size());
        const auto& locals = macro.locals();
        REQUIRE(locals.size() == 2);
        REQUIRE(locals[0] == "l1");
        REQUIRE(locals[1] == "l2");
    }

    // Second parse: l3, l4
    {
        std::vector<Token> toks = {
            Token(TokenType::Identifier, "l3", false),
            Token(TokenType::Comma, ",", false),
            Token(TokenType::Identifier, "l4", false)
        };
        TokenLine line(loc, toks);
        size_t index = 0;
        REQUIRE(macro.parse_locals(line, index));
        REQUIRE(index == toks.size());
    }

    // Verify concatenation: [l1, l2, l3, l4]
    const auto& locals = macro.locals();
    REQUIRE(locals.size() == 4);
    REQUIRE(locals[0] == "l1");
    REQUIRE(locals[1] == "l2");
    REQUIRE(locals[2] == "l3");
    REQUIRE(locals[3] == "l4");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_locals second failure preserves first successful results", "[model][macro][locals]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 207);
    Macro macro("M", loc);

    // First parse succeeds: l1, l2
    {
        std::vector<Token> toks = {
            Token(TokenType::Identifier, "l1", false),
            Token(TokenType::Comma, ",", false),
            Token(TokenType::Identifier, "l2", false)
        };
        TokenLine line(loc, toks);
        size_t index = 0;
        REQUIRE(macro.parse_locals(line, index));
        REQUIRE(index == toks.size());
        const auto& locals = macro.locals();
        REQUIRE(locals.size() == 2);
        REQUIRE(locals[0] == "l1");
        REQUIRE(locals[1] == "l2");
    }

    // Second parse fails: "l3 ," followed by ')' (missing identifier after comma)
    {
        std::vector<Token> toks = {
            Token(TokenType::Identifier, "l3", false),
            Token(TokenType::Comma, ",", false),
            Token(TokenType::RightParen, ")", false)
        };
        TokenLine line(loc, toks);
        size_t index = 0;
        REQUIRE_FALSE(macro.parse_locals(line, index));
        REQUIRE(index == 0); // unchanged on error
        REQUIRE(g_errors.has_errors());
    }

    // Verify locals still contain result from first parse
    const auto& locals = macro.locals();
    REQUIRE(locals.size() == 2);
    REQUIRE(locals[0] == "l1");
    REQUIRE(locals[1] == "l2");
}

//-----------------------------------------------------------------------------
// Macro parse_arguments tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: parse_arguments with no input yields no arguments", "[model][macro][args]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 300);
    Macro macro("M", loc);

    TokenLine line(loc, {}); // no tokens
    size_t index = 0;
    std::vector<TokenLine> args;
    REQUIRE(macro.parse_arguments(line, index, args));
    REQUIRE(index == 0);
    REQUIRE(args.empty());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Macro: parse_arguments simple comma-separated", "[model][macro][args]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 301);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "B", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "C", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    std::vector<TokenLine> args;
    REQUIRE(macro.parse_arguments(line, index, args));
    REQUIRE(index == toks.size());
    REQUIRE(args.size() == 3);
    REQUIRE(args[0].tokens().size() == 1);
    REQUIRE(args[0].tokens()[0].text() == "A");
    REQUIRE(args[1].tokens().size() == 1);
    REQUIRE(args[1].tokens()[0].text() == "B");
    REQUIRE(args[2].tokens().size() == 1);
    REQUIRE(args[2].tokens()[0].text() == "C");
}

TEST_CASE("Macro: parse_arguments handles nested parentheses", "[model][macro][args]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 302);
    Macro macro("M", loc);

    // Args: A, (B, C), D  -> second argument contains a comma but inside parens
    std::vector<Token> toks = {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "B", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "C", false),
        Token(TokenType::RightParen, ")", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "D", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    std::vector<TokenLine> args;
    REQUIRE(macro.parse_arguments(line, index, args));
    REQUIRE(index == toks.size());
    REQUIRE(args.size() == 3);

    REQUIRE(args[0].tokens().size() == 1);
    REQUIRE(args[0].tokens()[0].text() == "A");

    // Argument includes parentheses and internal comma
    REQUIRE(args[1].tokens().size() == 5);
    REQUIRE(args[1].tokens()[0].is(TokenType::LeftParen));
    REQUIRE(args[1].tokens()[1].text() == "B");
    REQUIRE(args[1].tokens()[2].is(TokenType::Comma));
    REQUIRE(args[1].tokens()[3].text() == "C");
    REQUIRE(args[1].tokens()[4].is(TokenType::RightParen));

    REQUIRE(args[2].tokens().size() == 1);
    REQUIRE(args[2].tokens()[0].text() == "D");
}

TEST_CASE("Macro: parse_arguments consecutive commas produce empty arguments", "[model][macro][args]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 303);
    Macro macro("M", loc);

    // Args: , , X  -> two empty arguments then X
    std::vector<Token> toks = {
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "X", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    std::vector<TokenLine> args;
    REQUIRE(macro.parse_arguments(line, index, args));
    REQUIRE(index == toks.size());
    REQUIRE(args.size() == 3);

    // First two are empty
    REQUIRE(args[0].tokens().empty());
    REQUIRE(args[1].tokens().empty());

    REQUIRE(args[2].tokens().size() == 1);
    REQUIRE(args[2].tokens()[0].text() == "X");
}

TEST_CASE("Macro: parse_arguments stops at top-level ')' without consuming it", "[model][macro][args]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 304);
    Macro macro("M", loc);

    // Args before ')': A, B )
    std::vector<Token> toks = {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "B", false),
        Token(TokenType::RightParen, ")", false),
        Token(TokenType::Identifier, "AFTER", false)
    };
    TokenLine line(loc, toks);
    size_t index = 0;
    std::vector<TokenLine> args;
    REQUIRE(macro.parse_arguments(line, index, args));
    // Should stop at the right paren without consuming it
    REQUIRE(index == 3);
    REQUIRE(args.size() == 2);
    REQUIRE(args[0].tokens().size() == 1);
    REQUIRE(args[0].tokens()[0].text() == "A");
    REQUIRE(args[1].tokens().size() == 1);
    REQUIRE(args[1].tokens()[0].text() == "B");
}

//-----------------------------------------------------------------------------
// Macro parse_body_line tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: parse_body_line stores regular lines and returns true", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 400);
    Macro macro("M", loc);

    // A regular instruction line
    std::vector<Token> toks = {
        Token(TokenType::Identifier, "LD", false),
        Token(TokenType::Identifier, "A", false)
    };
    TokenLine line(loc, toks);

    REQUIRE(macro.parse_body_line(line)); // returns true (continue parsing)
    const auto& body = macro.body_lines();
    REQUIRE(body.size() == 1);
    REQUIRE(body[0].tokens().size() == 2);
    REQUIRE(body[0].tokens()[0].text() == "LD");
    REQUIRE(body[0].tokens()[1].text() == "A");
}

TEST_CASE("Macro: parse_body_line increments nesting on MACRO and stores line", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 401);
    Macro macro("M", loc);

    // "MACRO" line
    std::vector<Token> toks1 = {
        Token(TokenType::Identifier, "MACRO", Keyword::MACRO, false),
        Token(TokenType::Identifier, "inner", false)
    };
    TokenLine line1(loc, toks1);

    REQUIRE(macro.parse_body_line(line1)); // true, continues
    REQUIRE(macro.body_lines().size() == 1);

    // Nested body line inside inner macro
    std::vector<Token> toks2 = {
        Token(TokenType::Identifier, "NOP", false)
    };
    TokenLine line2(loc, toks2);
    REQUIRE(macro.parse_body_line(line2)); // true

    REQUIRE(macro.body_lines().size() == 2);
}

TEST_CASE("Macro: parse_body_line ENDM at nesting>0 stores line and returns true", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 402);
    Macro macro("M", loc);

    // Enter nested macro
    {
        std::vector<Token> toks = {
            Token(TokenType::Identifier, "MACRO", Keyword::MACRO, false),
            Token(TokenType::Identifier, "inner", false)
        };
        TokenLine line(loc, toks);
        REQUIRE(macro.parse_body_line(line)); // true
    }

    // ENDM for inner macro (nesting>0): store and return true
    {
        std::vector<Token> toks = { Token(TokenType::Identifier, "ENDM", Keyword::ENDM, false) };
        TokenLine line(loc, toks);
        REQUIRE(macro.parse_body_line(line)); // true
    }

    REQUIRE(macro.body_lines().size() == 2);
    REQUIRE(macro.body_lines()[0].tokens()[0].is(Keyword::MACRO));
    REQUIRE(macro.body_lines()[1].tokens()[0].is(Keyword::ENDM));
}

TEST_CASE("Macro: parse_body_line ENDM at nesting==0 returns false and does not store", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 403);
    Macro macro("M", loc);

    // A body line first
    {
        std::vector<Token> toks = { Token(TokenType::Identifier, "RET", false) };
        TokenLine line(loc, toks);
        REQUIRE(macro.parse_body_line(line)); // true
    }

    // Outermost ENDM ends macro body: return false, don't store
    {
        std::vector<Token> toks = { Token(TokenType::Identifier, "ENDM", Keyword::ENDM, false) };
        TokenLine line(loc, toks);
        REQUIRE_FALSE(macro.parse_body_line(line));
    }

    const auto& body = macro.body_lines();
    REQUIRE(body.size() == 1); // ENDM not stored
    REQUIRE(body[0].tokens()[0].text() == "RET");
}

TEST_CASE("Macro: parse_body_line ENDM with trailing tokens reports error", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 404);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "ENDM", Keyword::ENDM, false),
        Token(TokenType::Identifier, "EXTRA", false)
    };
    TokenLine line(loc, toks);

    REQUIRE_FALSE(macro.parse_body_line(line)); // outermost end; false
    REQUIRE(g_errors.has_errors()); // Unexpected token 'EXTRA'
    REQUIRE(macro.body_lines().empty()); // ENDM was not stored
}

TEST_CASE("Macro: parse_body_line LOCAL parses locals, does not store line, returns true", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 405);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "LOCAL", Keyword::LOCAL, false),
        Token(TokenType::Identifier, "l1", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "l2", false)
    };
    TokenLine line(loc, toks);

    REQUIRE(macro.parse_body_line(line)); // true
    REQUIRE(macro.body_lines().empty()); // not stored
    const auto& locals = macro.locals();
    REQUIRE(locals.size() == 2);
    REQUIRE(locals[0] == "l1");
    REQUIRE(locals[1] == "l2");
}

TEST_CASE("Macro: parse_body_line LOCAL with unexpected trailing token reports error", "[model][macro][body]") {
    SuppressErrors suppress;
    Location loc("macro.asm", 406);
    Macro macro("M", loc);

    std::vector<Token> toks = {
        Token(TokenType::Identifier, "LOCAL", Keyword::LOCAL, false),
        Token(TokenType::Identifier, "l1", false),
        Token(TokenType::Identifier, "EXTRA", false) // missing comma; extra token
    };
    TokenLine line(loc, toks);

    REQUIRE(macro.parse_body_line(line)); // true (continues)
    REQUIRE(g_errors.has_errors());
    REQUIRE(macro.body_lines().empty()); // LOCAL lines are not stored
}

//-----------------------------------------------------------------------------
// Macro expand tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: expand reports error on argument count mismatch", "[model][macro][expand]") {
    SuppressErrors suppress;

    Location macLoc("def.asm", 10);
    Macro macro("M", macLoc);
    macro.add_parameter("p1");
    macro.add_parameter("p2");
    macro.add_local("l1");

    // Body: l1: LD p1, p2
    {
        std::vector<Token> toks = {
            Token(TokenType::Identifier, "l1", false),
            Token(TokenType::Colon, ":", false),
            Token(TokenType::Identifier, "LD", false),
            Token(TokenType::Identifier, "p1", false),
            Token(TokenType::Comma, ",", false),
            Token(TokenType::Identifier, "p2", false),
        };
        macro.add_body_line(TokenLine(macLoc, toks));
    }

    // Provide only one argument -> mismatch
    std::vector<TokenLine> args;
    args.emplace_back(macLoc, std::vector<Token> { Token(TokenType::Identifier, "X", false) });

    std::vector<TokenLine> out;
    Location expLoc("use.asm", 99);
    macro.expand(expLoc, args, out);

    REQUIRE(g_errors.has_errors());
    REQUIRE(out.empty());
}

TEST_CASE("Macro: expand substitutes parameters with argument tokens", "[model][macro][expand]") {
    SuppressErrors suppress;

    Location macLoc("def.asm", 20);
    Macro macro("M", macLoc);
    macro.add_parameter("A");
    macro.add_parameter("B");

    // Body: PUSH A ; then PUSH B
    {
        std::vector<Token> toks1 = {
            Token(TokenType::Identifier, "PUSH", false),
            Token(TokenType::Identifier, "A", false)
        };
        macro.add_body_line(TokenLine(macLoc, toks1));
        std::vector<Token> toks2 = {
            Token(TokenType::Identifier, "PUSH", false),
            Token(TokenType::Identifier, "B", false)
        };
        macro.add_body_line(TokenLine(macLoc, toks2));
    }

    // Arguments: A := (HL), B := IX
    std::vector<TokenLine> args;
    args.emplace_back(macLoc, std::vector<Token> {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "HL", false),
        Token(TokenType::RightParen, ")", false)
    });
    args.emplace_back(macLoc, std::vector<Token> {
        Token(TokenType::Identifier, "IX", false)
    });

    std::vector<TokenLine> out;
    Location expLoc("use.asm", 200);
    macro.expand(expLoc, args, out);

    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE(out.size() == 2);

    // First line: PUSH (HL)
    {
        const auto& toks = out[0].tokens();
        REQUIRE(out[0].location().filename() == "use.asm");
        REQUIRE(out[0].location().line_num() == 200);
        REQUIRE(toks.size() == 4);
        REQUIRE(toks[0].text() == "PUSH");
        REQUIRE(toks[1].is(TokenType::LeftParen));
        REQUIRE(toks[2].is(TokenType::Identifier));
        REQUIRE(toks[2].text() == "HL");
        REQUIRE(toks[3].is(TokenType::RightParen));
    }

    // Second line: PUSH IX
    {
        const auto& toks = out[1].tokens();
        REQUIRE(toks.size() >= 2);
        REQUIRE(toks[0].text() == "PUSH");
        REQUIRE(toks[1].text() == "IX");
        REQUIRE(out[1].location().filename() == "use.asm");
        REQUIRE(out[1].location().line_num() == 200);
    }
}

TEST_CASE("Macro: expand renames locals to unique <var>_<id> and increments id", "[model][macro][expand]") {
    SuppressErrors suppress;

    int start_id = g_unique_id_counter;

    Location macLoc("def.asm", 30);
    Macro macro("M", macLoc);
    macro.add_parameter("P");
    macro.add_local("L");
    macro.add_local("TEMP");

    // Body:
    // L:   LD A, L
    // TEMP EQU L
    {
        {
            std::vector<Token> toks = {
                Token(TokenType::Identifier, "L", false),
                Token(TokenType::Colon, ":", false),
                Token(TokenType::Identifier, "LD", false),
                Token(TokenType::Identifier, "A", false),
                Token(TokenType::Comma, ",", false),
                Token(TokenType::Identifier, "L", false)
            };
            macro.add_body_line(TokenLine(macLoc, toks));
        }
        {
            std::vector<Token> toks = {
                Token(TokenType::Identifier, "TEMP", false),
                Token(TokenType::Identifier, "EQU", false),
                Token(TokenType::Identifier, "L", false)
            };
            macro.add_body_line(TokenLine(macLoc, toks));
        }
    }

    // Argument P := 0
    std::vector<TokenLine> args;
    args.emplace_back(macLoc, std::vector<Token> { Token(TokenType::Integer, "0", 0, false) });

    std::vector<TokenLine> out1;
    Location expLoc("use1.asm", 10);
    macro.expand(expLoc, args, out1);

    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE(out1.size() == 2);

    // All locals renamed consistently to <var>_<start_id>
    std::string suffix = std::string("_") + std::to_string(start_id);

    // First expanded line identifiers: L_<id>, LD, A, L_<id>
    {
        auto toks = out1[0].tokens();
        REQUIRE(toks.size() == 6);
        REQUIRE(toks[0].text() == std::string("L") + suffix);
        REQUIRE(toks[1].is(TokenType::Colon));
        REQUIRE(toks[2].text() == "LD");
        REQUIRE(toks[3].text() == "A");
        REQUIRE(toks[4].is(TokenType::Comma));
        REQUIRE(toks[5].text() == std::string("L") + suffix);
    }
    // Second expanded line TEMP becomes unique too
    {
        auto toks = out1[1].tokens();
        REQUIRE(toks.size() == 3);
        REQUIRE(toks[0].text() == std::string("TEMP") + suffix);
        REQUIRE(toks[1].text() == "EQU");
        REQUIRE(toks[2].text() == std::string("L") + suffix);
    }

    // g_unique_id_counter incremented for the expansion
    REQUIRE(g_unique_id_counter == start_id + 1);

    // A second expansion yields different unique id
    std::vector<TokenLine> out2;
    Location expLoc2("use2.asm", 20);
    macro.expand(expLoc2, args, out2);

    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE(out1.size() == 2);

    suffix = std::string("_") + std::to_string(start_id + 1);

    // First expanded line identifiers: L_<id>, LD, A, L_<id>
    {
        auto toks = out2[0].tokens();
        REQUIRE(toks.size() == 6);
        REQUIRE(toks[0].text() == std::string("L") + suffix);
        REQUIRE(toks[1].is(TokenType::Colon));
        REQUIRE(toks[2].text() == "LD");
        REQUIRE(toks[3].text() == "A");
        REQUIRE(toks[4].is(TokenType::Comma));
        REQUIRE(toks[5].text() == std::string("L") + suffix);
    }
    // Second expanded line TEMP becomes unique too
    {
        auto toks = out2[1].tokens();
        REQUIRE(toks.size() == 3);
        REQUIRE(toks[0].text() == std::string("TEMP") + suffix);
        REQUIRE(toks[1].text() == "EQU");
        REQUIRE(toks[2].text() == std::string("L") + suffix);
    }

    REQUIRE(g_unique_id_counter == start_id + 2);
}

//-----------------------------------------------------------------------------
// Macros container tests
//-----------------------------------------------------------------------------

TEST_CASE("Macros: add and retrieve macro", "[model][macros_container]") {
    SuppressErrors suppress;
    Macros container;

    Location loc("defs.asm", 1);
    Macro m("MYMAC", loc);

    // Add parameters and body so we can verify retrieval integrity
    m.add_parameter("p1");
    std::vector<Token> toks = { Token(TokenType::Identifier, "NOP", false) };
    m.add_body_line(TokenLine(loc, toks));

    container.add_macro(m);

    REQUIRE(container.has_macro("MYMAC"));
    Macro* got = container.get_macro("MYMAC");
    REQUIRE(got != nullptr);
    REQUIRE(got->name() == "MYMAC");
    REQUIRE(got->parameters().size() == 1);
    REQUIRE(got->parameters()[0] == "p1");
    REQUIRE(got->body_lines().size() == 1);
    REQUIRE(got->body_lines()[0].tokens().size() == 1);
    REQUIRE(got->body_lines()[0].tokens()[0].text() == "NOP");

    // Negative lookups
    REQUIRE_FALSE(container.has_macro("UNKNOWN"));
    REQUIRE(container.get_macro("UNKNOWN") == nullptr);
}

TEST_CASE("Macros: macro redefinition reports error and keeps original", "[model][macros_container]") {
    SuppressErrors suppress;
    Macros container;

    Location loc1("defs.asm", 10);
    Macro m1("DUP", loc1);
    m1.add_parameter("a");
    std::vector<Token> toks1 = { Token(TokenType::Identifier, "LD", false) };
    m1.add_body_line(TokenLine(loc1, toks1));

    container.add_macro(m1);
    REQUIRE(container.has_macro("DUP"));

    // Attempt to redefine the same macro name
    Location loc2("defs.asm", 20);
    Macro m2("DUP", loc2);
    m2.add_parameter("b");
    std::vector<Token> toks2 = { Token(TokenType::Identifier, "INC", false) };
    m2.add_body_line(TokenLine(loc2, toks2));

    container.add_macro(m2);

    // Redefinition should produce an error and not overwrite original
    REQUIRE(g_errors.has_errors());
    Macro* got = container.get_macro("DUP");
    REQUIRE(got != nullptr);
    // Original definition remains
    REQUIRE(got->location().line_num() == 10);
    REQUIRE(got->parameters().size() == 1);
    REQUIRE(got->parameters()[0] == "a");
    REQUIRE(got->body_lines().size() == 1);
    REQUIRE(got->body_lines()[0].tokens()[0].text() == "LD");
}

//-----------------------------------------------------------------------------
// Macro expand_flat tests
//-----------------------------------------------------------------------------

TEST_CASE("Macro: expand_flat substitutes parameters and flattens into single line", "[model][macro][expand_flat]") {
    SuppressErrors suppress;

    Location macLoc("def.asm", 500);
    Macro macro("M", macLoc);
    macro.add_parameter("P1");
    macro.add_parameter("P2");

    // Body:
    //   PUSH P1
    //   POP  P2
    {
        std::vector<Token> toks1 = {
            Token(TokenType::Identifier, "PUSH", false),
            Token(TokenType::Identifier, "P1", false)
        };
        macro.add_body_line(TokenLine(macLoc, toks1));
        std::vector<Token> toks2 = {
            Token(TokenType::Identifier, "POP", false),
            Token(TokenType::Identifier, "P2", false)
        };
        macro.add_body_line(TokenLine(macLoc, toks2));
    }

    // Arguments: P1 := (HL), P2 := BC
    std::vector<TokenLine> args;
    args.emplace_back(macLoc, std::vector<Token> {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "HL", false),
        Token(TokenType::RightParen, ")", false)
    });
    args.emplace_back(macLoc, std::vector<Token> {
        Token(TokenType::Identifier, "BC", false)
    });

    Location expLoc("use.asm", 600);
    TokenLine flat = macro.expand_flat(expLoc, args);

    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE(flat.location().filename() == "use.asm");
    REQUIRE(flat.location().line_num() == 600);

    const auto& toks = flat.tokens();
    // Expect sequence: PUSH (HL) POP BC flattened
    REQUIRE(toks.size() >= 6);
    REQUIRE(toks[0].text() == "PUSH");
    REQUIRE(toks[1].is(TokenType::LeftParen));
    REQUIRE(toks[2].text() == "HL");
    REQUIRE(toks[3].is(TokenType::RightParen));
    REQUIRE(toks[4].text() == "POP");
    REQUIRE(toks[5].text() == "BC");
}

TEST_CASE("Macro: expand_flat copies as-is when no params and no locals", "[model][macro][expand_flat]") {
    SuppressErrors suppress;

    Location macLoc("def.asm", 510);
    Macro macro("M", macLoc);

    // Body:
    //   NOP
    //   RET
    {
        macro.add_body_line(TokenLine(macLoc, { Token(TokenType::Identifier, "NOP", false) }));
        macro.add_body_line(TokenLine(macLoc, { Token(TokenType::Identifier, "RET", false) }));
    }

    // No arguments needed
    std::vector<TokenLine> args;
    Location expLoc("use.asm", 610);
    TokenLine flat = macro.expand_flat(expLoc, args);

    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE(flat.location().filename() == "use.asm");
    REQUIRE(flat.location().line_num() == 610);

    const auto& toks = flat.tokens();
    REQUIRE(toks.size() == 2);
    REQUIRE(toks[0].text() == "NOP");
    REQUIRE(toks[1].text() == "RET");
}

TEST_CASE("Macro: expand_flat reports error and returns empty when argument mismatch", "[model][macro][expand_flat]") {
    SuppressErrors suppress;

    Location macLoc("def.asm", 520);
    Macro macro("M", macLoc);
    macro.add_parameter("X");
    macro.add_body_line(TokenLine(macLoc, { Token(TokenType::Identifier, "LD", false),
                                            Token(TokenType::Identifier, "X", false)
                                          }));

    // No arguments provided -> mismatch
    std::vector<TokenLine> args;
    Location expLoc("use.asm", 620);
    TokenLine flat = macro.expand_flat(expLoc, args);

    REQUIRE(g_errors.has_errors());
    REQUIRE(flat.location().filename() == "use.asm");
    REQUIRE(flat.location().line_num() == 620);
    REQUIRE(flat.tokens().empty());
}

TEST_CASE("Macro: expand_flat reflects local renaming with unique suffix", "[model][macro][expand_flat]") {
    SuppressErrors suppress;

    int start = g_unique_id_counter;

    Location macLoc("def.asm", 530);
    Macro macro("M", macLoc);
    macro.add_parameter("P");
    macro.add_local("L");

    // Body:
    //   L: EQU L
    macro.add_body_line(TokenLine(macLoc, {
        Token(TokenType::Identifier, "L", false),
        Token(TokenType::Identifier, "EQU", false),
        Token(TokenType::Identifier, "L", false)
    }));

    // Argument: P := 0
    std::vector<TokenLine> args;
    args.emplace_back(macLoc, std::vector<Token> { Token(TokenType::Integer, "0", 0, false) });

    Location expLoc("use.asm", 630);
    TokenLine flat = macro.expand_flat(expLoc, args);

    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE(g_unique_id_counter == start + 1);

    const auto& toks = flat.tokens();
    // Expect both occurrences of L replaced to "L_<id>"
    std::string expected = "L_" + std::to_string(start);
    int count = 0;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier) && t.text() == expected) {
            ++count;
        }
    }
    REQUIRE(count >= 2);
}

TEST_CASE("Macros: inline splicing for function-like macro with parentheses", "[model][macros_container][expand]") {
    SuppressErrors suppress;

    // Define SUM(A,B) -> A + B
    Location defLoc("defs.asm", 700);
    Macro sum("SUM", defLoc);
    sum.set_function_like(true);
    sum.add_parameter("A");
    sum.add_parameter("B");
    sum.add_body_line(TokenLine(defLoc, {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Plus, "+", false),
        Token(TokenType::Identifier, "B", false)
    }));

    Macros container;
    container.add_macro(sum);

    // Input: LD A, SUM(2,4)
    Location useLoc("use.asm", 701);
    TokenLine line(useLoc, {
        Token(TokenType::Identifier, "LD", false),
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "SUM", false),
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Integer, "2", 2, false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Integer, "4", 4, false),
        Token(TokenType::RightParen, ")", false)
    });

    std::vector<TokenLine> out;
    REQUIRE(container.expand(line, out));
    REQUIRE(out.size() == 1);
    const auto& toks = out[0].tokens();
    REQUIRE(toks.size() == 6);
    REQUIRE(toks[0].text() == "LD");
    REQUIRE(toks[1].text() == "A");
    REQUIRE(toks[2].is(TokenType::Comma));
    REQUIRE(toks[3].text() == "2");
    REQUIRE(toks[4].is(TokenType::Plus));
    REQUIRE(toks[5].text() == "4");
}

TEST_CASE("Macros: inline splicing for function-like macro without parentheses", "[model][macros_container][expand]") {
    SuppressErrors suppress;

    // Define SUM(A,B) -> A + B
    Location defLoc("defs.asm", 710);
    Macro sum("SUM", defLoc);
    sum.set_function_like(true);
    sum.add_parameter("A");
    sum.add_parameter("B");
    sum.add_body_line(TokenLine(defLoc, {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Plus, "+", false),
        Token(TokenType::Identifier, "B", false)
    }));

    Macros container;
    container.add_macro(sum);

    // Input: LD A, SUM 2,4   (no parentheses)
    Location useLoc("use.asm", 711);
    TokenLine line(useLoc, {
        Token(TokenType::Identifier, "LD", false),
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "SUM", false),
        Token(TokenType::Integer, "2", 2, false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Integer, "4", 4, false)
    });

    std::vector<TokenLine> out;
    REQUIRE(container.expand(line, out));
    REQUIRE(out.size() == 1);
    const auto& toks = out[0].tokens();
    REQUIRE(toks.size() == 6);
    REQUIRE(toks[0].text() == "LD");
    REQUIRE(toks[1].text() == "A");
    REQUIRE(toks[2].is(TokenType::Comma));
    REQUIRE(toks[3].text() == "2");
    REQUIRE(toks[4].is(TokenType::Plus));
    REQUIRE(toks[5].text() == "4");
}

TEST_CASE("Macros: multi-line function-like macro splices first line inline and emits subsequent lines",
          "[model][macros_container][expand]") {
    SuppressErrors suppress;

    // Define:
    // MACRO PP(A,B)
    //   PUSH A
    //   PUSH B
    // ENDM
    Location defLoc("defs.asm", 800);
    Macro pp("PP", defLoc);
    pp.set_function_like(true);
    pp.add_parameter("A");
    pp.add_parameter("B");
    pp.add_body_line(TokenLine(defLoc, {
        Token(TokenType::Identifier, "PUSH", false),
        Token(TokenType::Identifier, "A", false)
    }));
    pp.add_body_line(TokenLine(defLoc, {
        Token(TokenType::Identifier, "PUSH", false),
        Token(TokenType::Identifier, "B", false)
    }));

    Macros container;
    container.add_macro(pp);

    // Input:
    // label: PP(BC,DE) EXTRA
    Location useLoc("use.asm", 801);
    TokenLine line(useLoc, {
        Token(TokenType::Identifier, "label", false),
        Token(TokenType::Colon, ":", false),
        Token(TokenType::Identifier, "PP", false),
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "BC", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "DE", false),
        Token(TokenType::RightParen, ")", false),
        Token(TokenType::Identifier, "EXTRA", false)
    });

    std::vector<TokenLine> out;
    REQUIRE(container.expand(line, out));
    REQUIRE(out.size() == 2);

    // First output line should be: label: PUSH BC EXTRA
    {
        const auto& toks = out[0].tokens();
        REQUIRE(toks.size() == 5);
        REQUIRE(toks[0].text() == "label");
        REQUIRE(toks[0].is(TokenType::Identifier));
        REQUIRE(toks[1].is(TokenType::Colon));
        REQUIRE(toks[2].text() == "PUSH");
        REQUIRE(toks[3].text() == "BC");
        REQUIRE(toks[4].text() == "EXTRA");
    }

    // Second output line should be: PUSH DE
    {
        const auto& toks = out[1].tokens();
        REQUIRE(toks.size() == 2);
        REQUIRE(toks[0].text() == "PUSH");
        REQUIRE(toks[1].text() == "DE");
    }
}

TEST_CASE("Macros: object-like macro without arguments expands two lines; first spliced inline, second verbatim",
          "[model][macros_container][expand]") {
    SuppressErrors suppress;

    // Define:
    // MACRO NOARG
    //   PUSH HL
    //   POP  DE
    // ENDM
    Location defLoc("defs.asm", 820);
    Macro noarg("NOARG", defLoc);
    // Object-like: do not set function_like
    noarg.add_body_line(TokenLine(defLoc, {
        Token(TokenType::Identifier, "PUSH", false),
        Token(TokenType::Identifier, "HL", false)
    }));
    noarg.add_body_line(TokenLine(defLoc, {
        Token(TokenType::Identifier, "POP", false),
        Token(TokenType::Identifier, "DE", false)
    }));

    Macros container;
    container.add_macro(noarg);

    // Input:
    // label: NOARG EXTRA
    Location useLoc("use.asm", 821);
    TokenLine line(useLoc, {
        Token(TokenType::Identifier, "label", false),
        Token(TokenType::Colon, ":", false),
        Token(TokenType::Identifier, "NOARG", false),
        Token(TokenType::Identifier, "EXTRA", false)
    });

    std::vector<TokenLine> out;
    REQUIRE(container.expand(line, out));
    REQUIRE(out.size() == 2);

    // First output line should be: label: PUSH HL EXTRA
    {
        const auto& toks = out[0].tokens();
        REQUIRE(toks.size() == 5);
        REQUIRE(toks[0].is(TokenType::Identifier));
        REQUIRE(toks[0].text() == "label");
        REQUIRE(toks[1].is(TokenType::Colon));
        REQUIRE(toks[2].is(TokenType::Identifier));
        REQUIRE(toks[2].text() == "PUSH");
        REQUIRE(toks[3].is(TokenType::Identifier));
        REQUIRE(toks[3].text() == "HL");
        REQUIRE(toks[4].is(TokenType::Identifier));
        REQUIRE(toks[4].text() == "EXTRA");
    }

    // Second output line should be verbatim from macro body: POP DE
    {
        const auto& toks = out[1].tokens();
        REQUIRE(toks.size() == 2);
        REQUIRE(toks[0].is(TokenType::Identifier));
        REQUIRE(toks[0].text() == "POP");
        REQUIRE(toks[1].is(TokenType::Identifier));
        REQUIRE(toks[1].text() == "DE");
    }
}

TEST_CASE("Macros: argument macro expands first and is flattened before top-level expansion",
          "[model][macros_container][expand][nested]") {
    SuppressErrors suppress;

    // Define ADDR -> IX , HL  (object-like, expands to two tokens separated by comma)
    Location defLoc1("defs.asm", 900);
    Macro addr("ADDR", defLoc1);
    addr.add_body_line(TokenLine(defLoc1, {
        Token(TokenType::Identifier, "IX", false),
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "HL", false)
    }));

    // Define PAIR(A,B) -> A:B (function-like, single line)
    Location defLoc2("defs.asm", 901);
    Macro pair("PAIR", defLoc2);
    pair.set_function_like(true);
    pair.add_parameter("A");
    pair.add_parameter("B");
    pair.add_body_line(TokenLine(defLoc2, {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Colon, ":", false),
        Token(TokenType::Identifier, "B", false)
    }));

    Macros container;
    container.add_macro(addr);
    container.add_macro(pair);

    // Input:  PAIR(ADDR, DE)
    // Expect: IX,HL:DE on the same line (argument ADDR is expanded first and flattened)
    Location useLoc("use.asm", 902);
    TokenLine line(useLoc, {
        Token(TokenType::Identifier, "PAIR", false),
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "ADDR", false), // argument macro
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "DE", false),
        Token(TokenType::RightParen, ")", false)
    });

    std::vector<TokenLine> out;
    REQUIRE(container.expand(line, out));
    REQUIRE(out.size() == 1);

    const auto& toks = out[0].tokens();
    // Expected sequence: IX,HL:DE
    REQUIRE(toks.size() == 5);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "IX");
    REQUIRE(toks[1].is(TokenType::Comma));
    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "HL");
    REQUIRE(toks[3].is(TokenType::Colon));
    REQUIRE(toks[4].is(TokenType::Identifier));
    REQUIRE(toks[4].text() == "DE");
}

TEST_CASE("Macros: argument is a two-line macro; argument expands then flattens before top-level expansion",
          "[model][macros_container][expand][nested]") {
    SuppressErrors suppress;

    // Two-line argument macro: ADDR2 -> (IX)  \n  , (HL)
    // When flattened as an argument, we expect "(IX) , (HL)" tokens sequence.
    Location defLoc1("defs.asm", 910);
    Macro addr2("ADDR2", defLoc1);
    addr2.add_body_line(TokenLine(defLoc1, {
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "IX", false),
        Token(TokenType::RightParen, ")", false)
    }));
    addr2.add_body_line(TokenLine(defLoc1, {
        Token(TokenType::Comma, ",", false),
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "HL", false),
        Token(TokenType::RightParen, ")", false)
    }));

    // Top-level macro PAIR(A,B) -> A:B (single-line)
    Location defLoc2("defs.asm", 911);
    Macro pair("PAIR", defLoc2);
    pair.set_function_like(true);
    pair.add_parameter("A");
    pair.add_parameter("B");
    pair.add_body_line(TokenLine(defLoc2, {
        Token(TokenType::Identifier, "A", false),
        Token(TokenType::Colon, ":", false),
        Token(TokenType::Identifier, "B", false)
    }));

    Macros container;
    container.add_macro(addr2);
    container.add_macro(pair);

    // Input:  PAIR(ADDR2, DE)
    // Expect: (IX):(HL),DE on the same line (ADDR2 expanded first to "(IX) , (HL)" then used as A)
    Location useLoc("use.asm", 912);
    TokenLine line(useLoc, {
        Token(TokenType::Identifier, "PAIR", false),
        Token(TokenType::LeftParen, "(", false),
        Token(TokenType::Identifier, "ADDR2", false), // argument macro (two-line)
        Token(TokenType::Comma, ",", false),
        Token(TokenType::Identifier, "DE", false),
        Token(TokenType::RightParen, ")", false)
    });

    std::vector<TokenLine> out;
    REQUIRE(container.expand(line, out));
    REQUIRE(out.size() == 1);

    const auto& toks = out[0].tokens();
    // Expected sequence: ( IX ) , ( HL ) : DE
    REQUIRE(toks.size() == 9);
    REQUIRE(toks[0].is(TokenType::LeftParen));
    REQUIRE(toks[1].is(TokenType::Identifier));
    REQUIRE(toks[1].text() == "IX");
    REQUIRE(toks[2].is(TokenType::RightParen));
    REQUIRE(toks[3].is(TokenType::Comma));
    REQUIRE(toks[4].is(TokenType::LeftParen));
    REQUIRE(toks[5].is(TokenType::Identifier));
    REQUIRE(toks[5].text() == "HL");
    REQUIRE(toks[6].is(TokenType::RightParen));
    REQUIRE(toks[7].is(TokenType::Colon));
    REQUIRE(toks[8].is(TokenType::Identifier));
    REQUIRE(toks[8].text() == "DE");
}
