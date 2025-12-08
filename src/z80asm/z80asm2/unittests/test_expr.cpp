//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../expr.h"
#include "../model.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Expression node tests
//-----------------------------------------------------------------------------

TEST_CASE("Expression: integer literal", "[model][expr]") {
    auto node = make_integer(42);
    REQUIRE(node->op() == ExprOp::Integer);
    REQUIRE(node->to_string() == "42");

    REQUIRE(node->evaluate() == 42);
}

TEST_CASE("Expression: symbol reference throws exception", "[model][expr]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Symbol* sym = module.add_symbol("label", loc);

    auto node = make_symbol(sym);
    REQUIRE(node->op() == ExprOp::Symbol);
    REQUIRE(node->to_string() == "label");

    REQUIRE_THROWS_AS(node->evaluate(), UndefinedSymbol);

    try {
        node->evaluate();
        FAIL("Should have thrown UndefinedSymbol");
    }
    catch (const UndefinedSymbol& e) {
        REQUIRE(e.symbol_name() == "label");
    }
}

TEST_CASE("Expression: dollar throws exception", "[model][expr]") {
    Location loc("test.asm", 10);

    auto node = make_dollar(nullptr, nullptr);
    REQUIRE(node->op() == ExprOp::Dollar);
    REQUIRE(node->to_string() == "$");

    REQUIRE_THROWS_AS(node->evaluate(), InvalidDollar);
}

//-----------------------------------------------------------------------------
// Unary operators
//-----------------------------------------------------------------------------

TEST_CASE("Expression: unary plus", "[model][expr][unary]") {
    auto node = make_unary_op(ExprOp::UnaryPlus, make_integer(5));
    REQUIRE(node->op() == ExprOp::UnaryPlus);
    REQUIRE(node->to_string() == "+(5)");

    REQUIRE(node->evaluate() == 5);
}

TEST_CASE("Expression: unary minus", "[model][expr][unary]") {
    auto node = make_unary_op(ExprOp::UnaryMinus, make_integer(5));
    REQUIRE(node->op() == ExprOp::UnaryMinus);
    REQUIRE(node->to_string() == "-(5)");

    REQUIRE(node->evaluate() == -5);
}

TEST_CASE("Expression: logical not", "[model][expr][unary]") {
    {
        auto node = make_unary_op(ExprOp::LogicalNot, make_integer(5));
        REQUIRE(node->evaluate() == 0);
    }
    {
        auto node = make_unary_op(ExprOp::LogicalNot, make_integer(0));
        REQUIRE(node->evaluate() == 1);
    }
}

TEST_CASE("Expression: bitwise not", "[model][expr][unary]") {
    auto node = make_unary_op(ExprOp::BitwiseNot, make_integer(0xFF));
    REQUIRE(node->evaluate() == ~0xFF);
}

//-----------------------------------------------------------------------------
// Arithmetic binary operators
//-----------------------------------------------------------------------------

TEST_CASE("Expression: addition", "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Add, make_integer(3), make_integer(4));
    REQUIRE(node->to_string() == "(3 + 4)");

    REQUIRE(node->evaluate() == 7);
}

TEST_CASE("Expression: subtraction", "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Subtract, make_integer(10), make_integer(3));
    REQUIRE(node->evaluate() == 7);
}

TEST_CASE("Expression: multiplication", "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Multiply, make_integer(6), make_integer(7));
    REQUIRE(node->evaluate() == 42);
}

TEST_CASE("Expression: division", "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Divide, make_integer(20), make_integer(4));
    REQUIRE(node->evaluate() == 5);
}

TEST_CASE("Expression: division by zero throws exception",
          "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Divide, make_integer(20), make_integer(0));
    REQUIRE_THROWS_AS(node->evaluate(), DivisionByZero);
}

TEST_CASE("Expression: modulo", "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Modulo, make_integer(17), make_integer(5));
    REQUIRE(node->evaluate() == 2);
}

TEST_CASE("Expression: modulo by zero throws exception",
          "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Modulo, make_integer(17), make_integer(0));
    REQUIRE_THROWS_AS(node->evaluate(), DivisionByZero);
}

TEST_CASE("Expression: power", "[model][expr][binary]") {
    auto node = make_binary_op(ExprOp::Power, make_integer(2), make_integer(10));
    REQUIRE(node->to_string() == "(2 ** 10)");

    REQUIRE(node->evaluate() == 1024);
}

//-----------------------------------------------------------------------------
// Bitwise operators
//-----------------------------------------------------------------------------

TEST_CASE("Expression: bitwise AND", "[model][expr][binary][bitwise]") {
    auto node = make_binary_op(ExprOp::BitwiseAnd, make_integer(0xF0),
                               make_integer(0x3C));
    REQUIRE(node->evaluate() == 0x30);
}

TEST_CASE("Expression: bitwise OR", "[model][expr][binary][bitwise]") {
    auto node = make_binary_op(ExprOp::BitwiseOr, make_integer(0xF0),
                               make_integer(0x0F));
    REQUIRE(node->evaluate() == 0xFF);
}

TEST_CASE("Expression: bitwise XOR", "[model][expr][binary][bitwise]") {
    auto node = make_binary_op(ExprOp::BitwiseXor, make_integer(0xFF),
                               make_integer(0xAA));
    REQUIRE(node->evaluate() == 0x55);
}

TEST_CASE("Expression: left shift", "[model][expr][binary][shift]") {
    auto node = make_binary_op(ExprOp::LeftShift, make_integer(1), make_integer(8));
    REQUIRE(node->evaluate() == 256);
}

TEST_CASE("Expression: right shift", "[model][expr][binary][shift]") {
    auto node = make_binary_op(ExprOp::RightShift, make_integer(256),
                               make_integer(4));
    REQUIRE(node->evaluate() == 16);
}

//-----------------------------------------------------------------------------
// Relational operators
//-----------------------------------------------------------------------------

TEST_CASE("Expression: less than", "[model][expr][binary][relational]") {
    {
        auto node = make_binary_op(ExprOp::LessThan, make_integer(3), make_integer(5));
        REQUIRE(node->evaluate() == 1);
    }
    {
        auto node = make_binary_op(ExprOp::LessThan, make_integer(5), make_integer(3));
        REQUIRE(node->evaluate() == 0);
    }
}

TEST_CASE("Expression: less or equal", "[model][expr][binary][relational]") {
    {
        auto node = make_binary_op(ExprOp::LessOrEqual, make_integer(3),
                                   make_integer(3));
        REQUIRE(node->evaluate() == 1);
    }
    {
        auto node = make_binary_op(ExprOp::LessOrEqual, make_integer(5),
                                   make_integer(3));
        REQUIRE(node->evaluate() == 0);
    }
}

TEST_CASE("Expression: greater than", "[model][expr][binary][relational]") {
    auto node = make_binary_op(ExprOp::GreaterThan, make_integer(5),
                               make_integer(3));
    REQUIRE(node->evaluate() == 1);
}

TEST_CASE("Expression: greater or equal", "[model][expr][binary][relational]") {
    auto node = make_binary_op(ExprOp::GreaterOrEqual, make_integer(3),
                               make_integer(3));
    REQUIRE(node->evaluate() == 1);
}

TEST_CASE("Expression: equal", "[model][expr][binary][equality]") {
    {
        auto node = make_binary_op(ExprOp::Equal, make_integer(5), make_integer(5));
        REQUIRE(node->evaluate() == 1);
    }
    {
        auto node = make_binary_op(ExprOp::Equal, make_integer(5), make_integer(3));
        REQUIRE(node->evaluate() == 0);
    }
}

TEST_CASE("Expression: not equal", "[model][expr][binary][equality]") {
    auto node = make_binary_op(ExprOp::NotEqual, make_integer(5), make_integer(3));
    REQUIRE(node->evaluate() == 1);
}

//-----------------------------------------------------------------------------
// Logical operators
//-----------------------------------------------------------------------------

TEST_CASE("Expression: logical AND", "[model][expr][binary][logical]") {
    {
        auto node = make_binary_op(ExprOp::LogicalAnd, make_integer(1),
                                   make_integer(1));
        REQUIRE(node->evaluate() == 1);
    }
    {
        auto node = make_binary_op(ExprOp::LogicalAnd, make_integer(1),
                                   make_integer(0));
        REQUIRE(node->evaluate() == 0);
    }
}

TEST_CASE("Expression: logical OR", "[model][expr][binary][logical]") {
    {
        auto node = make_binary_op(ExprOp::LogicalOr, make_integer(0), make_integer(0));
        REQUIRE(node->evaluate() == 0);
    }
    {
        auto node = make_binary_op(ExprOp::LogicalOr, make_integer(0), make_integer(1));
        REQUIRE(node->evaluate() == 1);
    }
}

TEST_CASE("Expression: logical XOR (extension)",
          "[model][expr][binary][logical]") {
    {
        auto node = make_binary_op(ExprOp::LogicalXor, make_integer(0),
                                   make_integer(0));
        REQUIRE(node->evaluate() == 0);
    }
    {
        auto node = make_binary_op(ExprOp::LogicalXor, make_integer(1),
                                   make_integer(0));
        REQUIRE(node->evaluate() == 1);
    }
    {
        auto node = make_binary_op(ExprOp::LogicalXor, make_integer(1),
                                   make_integer(1));
        REQUIRE(node->evaluate() == 0);
    }
}

//-----------------------------------------------------------------------------
// Ternary conditional
//-----------------------------------------------------------------------------

TEST_CASE("Expression: conditional true branch", "[model][expr][ternary]") {
    auto node = make_conditional(
                    make_integer(1),
                    make_integer(42),
                    make_integer(99)
                );
    REQUIRE(node->to_string() == "(1 ? 42 : 99)");

    REQUIRE(node->evaluate() == 42);
}

TEST_CASE("Expression: conditional false branch", "[model][expr][ternary]") {
    auto node = make_conditional(
                    make_integer(0),
                    make_integer(42),
                    make_integer(99)
                );

    REQUIRE(node->evaluate() == 99);
}

//-----------------------------------------------------------------------------
// Complex expressions
//-----------------------------------------------------------------------------

TEST_CASE("Expression: complex arithmetic (2 + 3) * 4",
          "[model][expr][complex]") {
    auto node = make_binary_op(
                    ExprOp::Multiply,
                    make_binary_op(ExprOp::Add, make_integer(2), make_integer(3)),
                    make_integer(4)
                );

    REQUIRE(node->evaluate() == 20);
}

TEST_CASE("Expression: power and multiply 2 ** 3 * 5",
          "[model][expr][complex]") {
    auto node = make_binary_op(
                    ExprOp::Multiply,
                    make_binary_op(ExprOp::Power, make_integer(2), make_integer(3)),
                    make_integer(5)
                );

    REQUIRE(node->evaluate() == 40);
}

TEST_CASE("Expression: nested conditional 1 ? 2 : 3 ? 4 : 5",
          "[model][expr][complex]") {
    auto node = make_conditional(
                    make_integer(1),
                    make_integer(2),
                    make_conditional(
                        make_integer(3),
                        make_integer(4),
                        make_integer(5)
                    )
                );

    REQUIRE(node->evaluate() == 2);
}

TEST_CASE("Expression: undefined symbol propagates through operators",
          "[model][expr][complex]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Symbol* sym = module.add_symbol("undefined", loc);

    auto node = make_binary_op(
                    ExprOp::Add,
                    make_integer(10),
                    make_symbol(sym)
                );

    REQUIRE_THROWS_AS(node->evaluate(), UndefinedSymbol);
}

TEST_CASE("Expression: division by zero in complex expression",
          "[model][expr][complex]") {
    auto node = make_binary_op(
                    ExprOp::Multiply,
                    make_integer(5),
                    make_binary_op(ExprOp::Divide, make_integer(10), make_integer(0))
                );

    REQUIRE_THROWS_AS(node->evaluate(), DivisionByZero);
}

//-----------------------------------------------------------------------------
// Expression container tests - UPDATED to handle exceptions
//-----------------------------------------------------------------------------

TEST_CASE("Expression: empty expression throws", "[model][expr]") {
    Expression expr;
    REQUIRE(expr.empty());
    REQUIRE(expr.root() == nullptr);
    REQUIRE(expr.to_string() == "");

    REQUIRE_THROWS_AS(expr.evaluate(), ExpressionError);
}

TEST_CASE("Expression: set and evaluate", "[model][expr]") {
    Location loc("test.asm", 10);
    Expression expr(make_integer(42), loc);
    REQUIRE_FALSE(expr.empty());
    REQUIRE(expr.root() != nullptr);
    REQUIRE(expr.location().filename() == "test.asm");
    REQUIRE(expr.location().line_num() == 10);

    int result = expr.evaluate();
    REQUIRE(result == 42);
}

TEST_CASE("Expression: copy constructor", "[model][expr]") {
    Location loc("test.asm", 20);
    Expression expr1(make_integer(42), loc);
    Expression expr2(expr1);

    int result1 = expr1.evaluate();
    int result2 = expr2.evaluate();
    REQUIRE(result1 == result2);
    REQUIRE(result1 == 42);
    REQUIRE(expr2.location().filename() == "test.asm");
    REQUIRE(expr2.location().line_num() == 20);
}

TEST_CASE("Expression: assignment operator", "[model][expr]") {
    Location loc("source.asm", 30);
    Expression expr1(make_integer(42), loc);
    Expression expr2;

    expr2 = expr1;

    int result = expr2.evaluate();
    REQUIRE(result == 42);
    REQUIRE(expr2.location().filename() == "source.asm");
    REQUIRE(expr2.location().line_num() == 30);
}

TEST_CASE("Expression: clear", "[model][expr]") {
    Location loc("file.asm", 40);
    Expression expr(make_integer(42), loc);
    REQUIRE_FALSE(expr.empty());

    expr.clear();
    REQUIRE(expr.empty());
}

TEST_CASE("Expression: error reporting with location for undefined symbol",
          "[model][expr][errors]") {
    Location loc("expr_test.asm", 123);
    Module module("TEST", loc);
    Symbol* sym = module.add_symbol("undefined", loc);
    Expression expr(make_symbol(sym), loc);

    REQUIRE_THROWS_AS(expr.evaluate(), UndefinedSymbol);
}

TEST_CASE("Expression: division by zero with location reporting",
          "[model][expr][errors]") {
    Location loc("calc.asm", 50);
    auto node = make_binary_op(ExprOp::Divide, make_integer(10), make_integer(0));
    Expression expr(std::move(node), loc);

    REQUIRE_THROWS_AS(expr.evaluate(), DivisionByZero);
}

TEST_CASE("Expression: dollar without context", "[model][expr][errors]") {
    Location loc("test.asm", 77);
    Expression expr(make_dollar(nullptr, nullptr), loc);

    REQUIRE_THROWS_AS(expr.evaluate(), InvalidDollar);
}

TEST_CASE("Expression: exception in nested expression reports correct location",
          "[model][expr][errors]") {
    Location loc("nested.asm", 100);
    auto node = make_binary_op(
                    ExprOp::Add,
                    make_integer(5),
                    make_binary_op(ExprOp::Divide, make_integer(10), make_integer(0))
                );
    Expression expr(std::move(node), loc);

    REQUIRE_THROWS_AS(expr.evaluate(), DivisionByZero);
}

//-----------------------------------------------------------------------------
// Expression parsing with symbols and $ tests
//-----------------------------------------------------------------------------

TEST_CASE("Expression: parse simple symbol reference", "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Create a constant symbol
    module.add_symbol("value", loc, 42, SymbolType::Constant);

    // Parse expression referencing the symbol
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "value", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 1);

    // Evaluate - should return symbol value
    REQUIRE(expr.evaluate() == 42);
}

TEST_CASE("Expression: parse undefined symbol creates symbol",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Parse expression with undefined symbol
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "unknown", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 1);

    // Symbol should have been created as undefined
    Symbol* sym = module.find_symbol("unknown");
    REQUIRE(sym != nullptr);
    REQUIRE(sym->is_undefined());

    // Evaluation should fail
    REQUIRE_THROWS_AS(expr.evaluate(), UndefinedSymbol);
}

TEST_CASE("Expression: parse $ (dollar) resolves to current opcode",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Add some opcodes
    section->add_opcode(Opcode({ 0x00 }, loc));          // 0x8000
    section->add_opcode(Opcode({ 0x3E, 0x42 }, loc));    // 0x8001
    section->add_opcode(Opcode({ 0x00 }, loc));          // 0x8003

    // Parse expression with $
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 1);

    // Should resolve to address of last opcode
    REQUIRE(expr.evaluate() == 0x8003);
}

TEST_CASE("Expression: parse ASMPC resolves to current opcode",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x9000);

    section->add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));  // 0x9000

    // Parse expression with ASMPC
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::ASMPC, "ASMPC", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    REQUIRE(expr.evaluate() == 0x9000);
}

TEST_CASE("Expression: parse arithmetic with symbols", "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Create constants
    module.add_symbol("base", loc, 0x8000, SymbolType::Constant);
    module.add_symbol("offset", loc, 0x100, SymbolType::Constant);

    // Parse: base + offset
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "base", true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Identifier, "offset", true));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 3);

    REQUIRE(expr.evaluate() == 0x8100);
}

TEST_CASE("Expression: parse $ with offset", "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    section->add_opcode(Opcode({ 0x00 }, loc));
    section->add_opcode(Opcode({ 0x00 }, loc));
    section->add_opcode(Opcode({ 0x18, 0x00 }, loc));  // JR at 0x8002

    // Parse: $ + 2 (for JR offset calculation)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Dollar, "$", true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    REQUIRE(expr.evaluate() == 0x8004);  // $ (0x8002) + 2
}

TEST_CASE("Expression: parse address-relative symbol", "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Add opcodes and create label
    section->add_opcode(Opcode({ 0x00 }, loc));
    Opcode* label_opcode = section->add_opcode(Opcode({ 0x3E, 0x42 }, loc));

    // Create label symbol
    Symbol* label = module.add_symbol("start", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(label_opcode);
    label->set_offset(0);  // Offset from opcode start

    // Parse expression referencing label
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "start", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    section->compute_opcodes_addresses();
    REQUIRE(expr.evaluate() == 0x8001);
}

TEST_CASE("Expression: parse complex expression with symbols and $",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Setup
    module.add_symbol("target", loc, 0x8100, SymbolType::Constant);
    section->add_opcode(Opcode({ 0x18, 0x00 }, loc));  // JR at 0x8000

    // Parse: target - ($ + 2)  (JR offset calculation)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "target", true));
    line.tokens().push_back(Token(TokenType::Minus, "-", true));
    line.tokens().push_back(Token(TokenType::LeftParen, "(", true));
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 7);

    REQUIRE(expr.evaluate() == 0xFE);  // 0x8100 - 0x8002 = 254
}

TEST_CASE("Expression: multiple symbols in expression",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    module.add_symbol("a", loc, 10, SymbolType::Constant);
    module.add_symbol("b", loc, 20, SymbolType::Constant);
    module.add_symbol("c", loc, 5, SymbolType::Constant);

    // Parse: a * b + c
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "a", true));
    line.tokens().push_back(Token(TokenType::Multiply, "*", true));
    line.tokens().push_back(Token(TokenType::Identifier, "b", true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Identifier, "c", true));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    REQUIRE(expr.evaluate() == 205);  // 10 * 20 + 5
}

TEST_CASE("Expression: symbol with bitwise operations",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    module.add_symbol("flags", loc, 0xFF, SymbolType::Constant);

    // Parse: flags & 0x0F
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "flags", true));
    line.tokens().push_back(Token(TokenType::BitwiseAnd, "&", true));
    line.tokens().push_back(Token(TokenType::Integer, "0x0F", 0x0F, true));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    REQUIRE(expr.evaluate() == 0x0F);
}

TEST_CASE("Expression: parse without module context throws",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "symbol", false));

    Expression expr;
    size_t i = 0;

    // Parsing without module should throw
    REQUIRE_THROWS_AS(expr.parse(line, i, nullptr, nullptr), UndefinedSymbol);
}

TEST_CASE("Expression: parse $ without section context throws",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr;
    size_t i = 0;

    // Parsing $ without section should throw
    REQUIRE_THROWS_AS(expr.parse(line, i, nullptr, nullptr), InvalidDollar);
}

TEST_CASE("Expression: parse $ without opcodes throws",
          "[model][expr][parse]") {
    Location loc("test.asm", 10);
    // No opcodes added

    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr;
    size_t i = 0;

    // Parsing $ with empty section should throw
    REQUIRE_THROWS_AS(expr.parse(line, i, nullptr, nullptr), InvalidDollar);
}

//-----------------------------------------------------------------------------
// Expression is_constant() tests
//-----------------------------------------------------------------------------

TEST_CASE("Expression: integer is constant", "[model][expr][constant]") {
    auto node = make_integer(42);
    REQUIRE(node->is_constant());
}

TEST_CASE("Expression: simple arithmetic is constant",
          "[model][expr][constant]") {
    auto node = make_binary_op(ExprOp::Add, make_integer(3), make_integer(4));
    REQUIRE(node->is_constant());
}

TEST_CASE("Expression: complex arithmetic is constant",
          "[model][expr][constant]") {
    auto node = make_binary_op(
                    ExprOp::Multiply,
                    make_binary_op(ExprOp::Add, make_integer(2), make_integer(3)),
                    make_integer(4)
                );
    REQUIRE(node->is_constant());
}

TEST_CASE("Expression: unary operators preserve constant",
          "[model][expr][constant]") {
    {
        auto node = make_unary_op(ExprOp::UnaryMinus, make_integer(5));
        REQUIRE(node->is_constant());
    }
    {
        auto node = make_unary_op(ExprOp::BitwiseNot, make_integer(0xFF));
        REQUIRE(node->is_constant());
    }
}

TEST_CASE("Expression: ternary with all constants is constant",
          "[model][expr][constant]") {
    auto node = make_conditional(
                    make_integer(1),
                    make_integer(42),
                    make_integer(99)
                );
    REQUIRE(node->is_constant());
}

TEST_CASE("Expression: constant symbol is constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Symbol* sym = module.add_symbol("MAX", loc, 100, SymbolType::Constant);

    auto node = make_symbol(sym);
    REQUIRE(node->is_constant());
}

TEST_CASE("Expression: undefined symbol is not constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Symbol* sym = module.add_symbol("undefined", loc);

    auto node = make_symbol(sym);
    REQUIRE_FALSE(node->is_constant());
}

TEST_CASE("Expression: address-relative symbol is not constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    Opcode* opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* sym = module.add_symbol("label", loc);
    sym->set_type(SymbolType::AddressRelative);
    sym->set_opcode(opcode);

    auto node = make_symbol(sym);
    REQUIRE_FALSE(node->is_constant());
}

TEST_CASE("Expression: computed symbol with constant expr is constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Expression expr(make_binary_op(
                        ExprOp::Add,
                        make_integer(10),
                        make_integer(32)
                    ), loc);

    Symbol* sym = module.add_symbol("computed", loc);
    sym->set_type(SymbolType::Computed);
    sym->set_expression(expr);

    auto node = make_symbol(sym);
    REQUIRE(node->is_constant());
}

TEST_CASE("Expression: computed symbol with non-constant expr is not constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Create address-relative symbol
    Opcode* opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* label = module.add_symbol("label", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(opcode);

    // Create computed symbol that references the label
    Expression expr(make_binary_op(
                        ExprOp::Add,
                        make_symbol(label),
                        make_integer(10)
                    ), loc);

    Symbol* computed = module.add_symbol("computed", loc);
    computed->set_type(SymbolType::Computed);
    computed->set_expression(expr);

    auto node = make_symbol(computed);
    REQUIRE_FALSE(node->is_constant());
}

TEST_CASE("Expression: $ (dollar) is not constant", "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    section->add_opcode(Opcode({ 0x00 }, loc));

    auto node = make_dollar(section->last_opcode(), section);
    REQUIRE_FALSE(node->is_constant());
}

TEST_CASE("Expression: expression with $ is not constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    section->add_opcode(Opcode({ 0x00 }, loc));

    auto node = make_binary_op(
                    ExprOp::Add,
                    make_dollar(section->last_opcode(), section),
                    make_integer(10)
                );
    REQUIRE_FALSE(node->is_constant());
}

TEST_CASE("Expression: mixed constant and non-constant is not constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    Symbol* constant = module.add_symbol("MAX", loc, 100, SymbolType::Constant);

    Opcode* opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* label = module.add_symbol("label", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(opcode);

    auto node = make_binary_op(
                    ExprOp::Add,
                    make_symbol(constant),
                    make_symbol(label)
                );
    REQUIRE_FALSE(node->is_constant());
}

TEST_CASE("Expression: Expression container is_constant",
          "[model][expr][constant]") {
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(42), loc);
        REQUIRE(expr.is_constant());
    }

    {
        Expression expr(make_binary_op(
                            ExprOp::Add,
                            make_integer(10),
                            make_integer(32)
                        ), loc);
        REQUIRE(expr.is_constant());
    }

    {
        Expression expr;  // Empty
        REQUIRE_FALSE(expr.is_constant());
    }
}

// Additional tests: ASMPC arithmetic, unary minus with power precedence, $ mixed arithmetic, deeply nested ternary

TEST_CASE("Expression: ASMPC participates in arithmetic",
          "[model][expr][asmcp][parse]") {
    Location loc("asmpc_test.asm", 12);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0xA000);

    // Add a single opcode so ASMPC resolves to base address
    section->add_opcode(Opcode({ 0x00 }, loc));  // address 0xA000

    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::ASMPC, "ASMPC", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Integer, "16", 16, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 3);

    REQUIRE(expr.evaluate() == 0xA000 + 16);
}

TEST_CASE("Expression: unary minus has lower precedence than power",
          "[model][expr][precedence][unary-power]") {
    // -2 ** 4 -> -(2 ** 4) == -16
    auto node = make_binary_op(
                    ExprOp::Subtract,
                    make_integer(0),
                    make_binary_op(ExprOp::Power, make_integer(2), make_integer(4))
                );
    Expression expr(std::move(node), Location("prec.asm", 1));
    REQUIRE(expr.evaluate() == -16);
}

TEST_CASE("Expression: $ mixed with arithmetic and parentheses",
          "[model][expr][Dollar][parse]") {
    Location loc("dollar_mix.asm", 20);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // opcodes at 0x8000 and 0x8001; last opcode address is 0x8001
    section->add_opcode(Opcode({ 0x00 }, loc));      // 0x8000
    section->add_opcode(Opcode({ 0x3E, 0x00 }, loc)); // 0x8001

    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::LeftParen, "(", false));
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));
    line.tokens().push_back(Token(TokenType::Minus, "-", false));
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 7);

    REQUIRE(expr.evaluate() == (0x8001 + 3) - 1);
}

TEST_CASE("Expression: deeply nested ternary parses and evaluates",
          "[model][expr][ternary][nested]") {
    // ((1 ? 2 : 3) ? (0 ? 7 : 8) : (1 ? 9 : 10)) -> (2 ? 8 : 9) -> true -> 8
    auto t_inner_true = make_conditional(make_integer(0), make_integer(7),
                                         make_integer(8));
    auto t_inner_false = make_conditional(make_integer(1), make_integer(9),
                                          make_integer(10));
    auto cond1 = make_conditional(make_integer(1), make_integer(2),
                                  make_integer(3));
    auto root = make_conditional(std::move(cond1), std::move(t_inner_true),
                                 std::move(t_inner_false));
    Expression expr(std::move(root), Location("tern.asm", 3));
    REQUIRE(expr.evaluate() == 8);
}

TEST_CASE("Expression: ASMPC with parentheses and addition then subtraction",
          "[model][expr][asmcp][complex]") {
    Location loc("asmpc_mix.asm", 33);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x9000);

    // Add two opcodes; ASMPC resolves to 0x9001 (last opcode)
    section->add_opcode(Opcode({ 0x00 }, loc));       // 0x9000
    section->add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc)); // 0x9001

    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::LeftParen, "(", false));
    line.tokens().push_back(Token(TokenType::ASMPC, "ASMPC", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));
    line.tokens().push_back(Token(TokenType::Minus, "-", false));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 7);

    REQUIRE(expr.evaluate() == (0x9001 + 4) - 2);
}

// Parsing: Basic arithmetic and precedence
TEST_CASE("Expression::parse respects operator precedence (multiplication over addition)",
          "[model][expr][parse][precedence]") {
    Location loc("precedence.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 2 + 3 * 4 => 2 + (12) => 14
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, true));
    line.tokens().push_back(Token(TokenType::Multiply, "*", true));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    // Entire line consumed
    REQUIRE(i == line.tokens().size());
    REQUIRE(expr.to_string() == "2 + 3 * 4");
    REQUIRE(expr.evaluate() == 14);
}

TEST_CASE("Expression::parse honors parentheses overriding precedence",
          "[model][expr][parse][precedence]") {
    Location loc("precedence_paren.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // (2 + 3) * 4 => 5 * 4 => 20
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::LeftParen, "(", false));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
    line.tokens().push_back(Token(TokenType::RightParen, ")", true));
    line.tokens().push_back(Token(TokenType::Multiply, "*", true));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == line.tokens().size());
    REQUIRE(expr.to_string() == "(2 + 3) * 4");
    REQUIRE(expr.evaluate() == 20);
}

TEST_CASE("Expression::to_string returns parsed token text when available",
          "[model][expr][to_string][parsed]") {
    Location loc("expr_tokens.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Build a simple token line: 3+4 (no spaces)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));

    // Parse collects tokens inside Expression
    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 3);

    // to_string must return exactly the tokenized text, not the AST format
    REQUIRE(expr.to_string() == "3+4");
}

TEST_CASE("Expression::to_string falls back to AST when no parsed tokens exist",
          "[model][expr][to_string][ast]") {
    // Construct expression programmatically (no tokens captured)
    Expression expr(
        make_binary_op(ExprOp::Add, make_integer(3), make_integer(4)),
        Location("expr_ast.asm", 2));

    // to_string should use the node formatting
    REQUIRE(expr.to_string() == "(3 + 4)");
}

TEST_CASE("Expression::parse power (**) is right-associative",
          "[model][expr][parse][power]") {
    Location loc("power_assoc.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 2 ** 3 ** 2 => 2 ** (3 ** 2) => 2 ** 9 => 512
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::Power, "**", true));
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, true));
    line.tokens().push_back(Token(TokenType::Power, "**", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);

    // to_string returns the exact parsed tokens
    REQUIRE(expr.to_string() == "2 ** 3 ** 2");
    REQUIRE(expr.evaluate() == 512);
}

TEST_CASE("Expression::parse power (**) handles negative exponent as zero",
          "[model][expr][parse][power]") {
    Location loc("power_negexp.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 2 ** -1 => 0 (by implementation)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::Power, "**", true));
    line.tokens().push_back(Token(TokenType::Minus, "-", false));  // unary minus
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 4);

    REQUIRE(expr.to_string() == "2 ** -1");
    REQUIRE(expr.evaluate() == 0);
}

TEST_CASE("Expression::parse left associativity for subtraction",
          "[model][expr][parse][associativity]") {
    Location loc("assoc_sub.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 10 - 3 - 2 => (10 - 3) - 2 => 5
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "10", 10, true));
    line.tokens().push_back(Token(TokenType::Minus, "-", true));
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, true));
    line.tokens().push_back(Token(TokenType::Minus, "-", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);

    REQUIRE(expr.to_string() == "10 - 3 - 2");
    REQUIRE(expr.evaluate() == 5);
}

TEST_CASE("Expression::parse left associativity for division",
          "[model][expr][parse][associativity]") {
    Location loc("assoc_div.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 20 / 2 / 2 => (20 / 2) / 2 => 5
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "20", 20, true));
    line.tokens().push_back(Token(TokenType::Divide, "/", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::Divide, "/", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);

    REQUIRE(expr.to_string() == "20 / 2 / 2");
    REQUIRE(expr.evaluate() == 5);
}

TEST_CASE("Expression::parse left associativity for shifts",
          "[model][expr][parse][associativity][shift]") {
    Location loc("assoc_shift.asm", 3);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 << 2 << 1 => (1 << 2) << 1 => 8
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::LeftShift, "<<", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::LeftShift, "<<", true));
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);

    REQUIRE(expr.to_string() == "1 << 2 << 1");
    REQUIRE(expr.evaluate() == 8);
}

TEST_CASE("Expression::parse bitwise AND has higher precedence than bitwise OR",
          "[model][expr][parse][precedence][bitwise]") {
    Location loc("bitwise_precedence.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 & 2 | 4 => (1 & 2) | 4 => 0 | 4 => 4
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::BitwiseAnd, "&", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::BitwiseOr, "|", true));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);
    REQUIRE(expr.to_string() == "1 & 2 | 4");
    REQUIRE(expr.evaluate() == 4);
}

TEST_CASE("Expression::parse bitwise XOR has higher precedence than logical XOR",
          "[model][expr][parse][precedence][xor]") {
    Location loc("xor_precedence.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 ^ 2 ^^ 2 => (1 ^ 2) ^^ 2 => 3 ^^ 2 => (1) ^^ (1) => 0
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::BitwiseXor, "^", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::LogicalXor, "^^", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);
    REQUIRE(expr.to_string() == "1 ^ 2 ^^ 2");
    REQUIRE(expr.evaluate() == 0);
}

TEST_CASE("Expression::parse bitwise vs logical precedence: '&' binds tighter than '||'",
          "[model][expr][parse][precedence][bitwise-logical]") {
    Location loc("bitwise_logical_precedence.asm", 3);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 0 & 1 || 1 => (0 & 1) || 1 => 0 || 1 => 1
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "0", 0, true));
    line.tokens().push_back(Token(TokenType::BitwiseAnd, "&", true));
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::LogicalOr, "||", true));
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == 5);
    REQUIRE(expr.to_string() == "0 & 1 || 1");
    REQUIRE(expr.evaluate() == 1);
}

TEST_CASE("Expression::parse logical AND binds tighter than logical OR",
          "[model][expr][parse][precedence][logical]") {
    Location loc("logical_precedence.asm", 4);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 && 0 || 0 => (1 && 0) || 0 => 0 || 0 => 0
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::LogicalAnd, "&&", true));
        line.tokens().push_back(Token(TokenType::Integer, "0", 0, true));
        line.tokens().push_back(Token(TokenType::LogicalOr, "||", true));
        line.tokens().push_back(Token(TokenType::Integer, "0", 0, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 5);
        REQUIRE(expr.to_string() == "1 && 0 || 0");
        REQUIRE(expr.evaluate() == 0);
    }

    // 1 || 0 && 0 => 1 || (0 && 0) => 1 || 0 => 1
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::LogicalOr, "||", true));
        line.tokens().push_back(Token(TokenType::Integer, "0", 0, true));
        line.tokens().push_back(Token(TokenType::LogicalAnd, "&&", true));
        line.tokens().push_back(Token(TokenType::Integer, "0", 0, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 5);
        REQUIRE(expr.to_string() == "1 || 0 && 0");
        REQUIRE(expr.evaluate() == 1);
    }
}

TEST_CASE("Expression::parse comparisons and equality produce boolean 1/0",
          "[model][expr][parse][comparison]") {
    Location loc("compare_bool.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 3 < 4 -> 1
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
        line.tokens().push_back(Token(TokenType::LT, "<", false));
        line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 3);
        REQUIRE(expr.evaluate() == 1);
    }

    // 3 >= 4 -> 0
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
        line.tokens().push_back(Token(TokenType::GE, ">=", false));
        line.tokens().push_back(Token(TokenType::Integer, "4", 4, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 3);
        REQUIRE(expr.evaluate() == 0);
    }

    // 2 = 2 -> 1
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
        line.tokens().push_back(Token(TokenType::EQ, "=", false));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 3);
        REQUIRE(expr.evaluate() == 1);
    }

    // 5 = 3 -> 0
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "5", 5, false));
        line.tokens().push_back(Token(TokenType::EQ, "=", false));
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 3);
        REQUIRE(expr.evaluate() == 0);
    }

    // 2 != 3 -> 1
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
        line.tokens().push_back(Token(TokenType::NE, "!=", false));
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 3);
        REQUIRE(expr.evaluate() == 1);
    }
}

TEST_CASE("Expression::parse ternary operator selects correct branch",
          "[model][expr][parse][ternary]") {
    Location loc("ternary_basic.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 ? 2 : 3 -> 2
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Question, "?", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
        line.tokens().push_back(Token(TokenType::Colon, ":", true));
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 5);
        REQUIRE(expr.evaluate() == 2);
    }

    // 0 ? 2 : 3 -> 3
    {
        TokenLine line(loc);
        line.tokens().push_back(Token(TokenType::Integer, "0", 0, true));
        line.tokens().push_back(Token(TokenType::Question, "?", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
        line.tokens().push_back(Token(TokenType::Colon, ":", true));
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));

        Expression expr;
        size_t i = 0;
        REQUIRE(expr.parse(line, i, &module, section));
        REQUIRE(i == 5);
        REQUIRE(expr.evaluate() == 3);
    }
}

TEST_CASE("Expression::parse nested ternary associates correctly",
          "[model][expr][parse][ternary][nested]") {
    Location loc("ternary_nested.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 ? 0 ? 5 : 6 : 7 -> inner: (0 ? 5 : 6) = 6; outer: 1 ? 6 : 7 = 6
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::Question, "?", true));
    line.tokens().push_back(Token(TokenType::Integer, "0", 0, true));
    line.tokens().push_back(Token(TokenType::Question, "?", true));
    line.tokens().push_back(Token(TokenType::Integer, "5", 5, true));
    line.tokens().push_back(Token(TokenType::Colon, ":", true));
    line.tokens().push_back(Token(TokenType::Integer, "6", 6, true));
    line.tokens().push_back(Token(TokenType::Colon, ":", true));
    line.tokens().push_back(Token(TokenType::Integer, "7", 7, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(i == line.tokens().size());
    REQUIRE(expr.evaluate() == 6);
}

TEST_CASE("Expression::parse ternary stops at following colon after expression",
          "[model][expr][parse][ternary][stop-index]") {
    Location loc("ternary_stop.asm", 3);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // 1 ? 2 : 3 : after -> parse should stop before the second colon
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::Question, "?", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::Colon, ":", true));
    line.tokens().push_back(Token(TokenType::Integer, "3", 3, true));
    line.tokens().push_back(Token(TokenType::Colon, ":", true));
    line.tokens().push_back(Token(TokenType::Identifier, "after", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // Must stop at the colon that is not part of the ternary
    REQUIRE(i < line.tokens().size());
    REQUIRE(line.tokens()[i].type() == TokenType::Colon);

    // The parsed expression should evaluate to the true branch result (2)
    REQUIRE(expr.evaluate() == 2);
}

TEST_CASE("Expression::parse division by zero throws exception",
          "[model][expr][parse][divzero]") {
    Location loc("divzero_parse.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "10", 10, true));
    line.tokens().push_back(Token(TokenType::Divide, "/", true));
    line.tokens().push_back(Token(TokenType::Integer, "0", 0, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE_THROWS_AS(expr.evaluate(), DivisionByZero);
}

TEST_CASE("Expression::parse modulo by zero throws exception",
          "[model][expr][parse][modzero]") {
    Location loc("modzero_parse.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "10", 10, true));
    line.tokens().push_back(Token(TokenType::Modulo, "%", true));
    line.tokens().push_back(Token(TokenType::Integer, "0", 0, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE_THROWS_AS(expr.evaluate(), DivisionByZero);
}

TEST_CASE("Expression::parse silent returns false and keeps index on empty input",
          "[model][expr][parse][silent][tokenize]") {
    Location loc("silent_empty.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    TokenLine line(loc); // no tokens

    Expression expr;
    size_t i = 0;

    REQUIRE_FALSE(expr.parse(line, i, &module, section));
    REQUIRE(i == 0);                 // index unchanged
    REQUIRE(expr.to_string() == ""); // no tokens captured
}

TEST_CASE("Expression::parse silent returns false and keeps index on unexpected token",
          "[model][expr][parse][silent][syntax]") {
    Location loc("silent_unexpected.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Start with an unexpected ')' so parsing fails immediately
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));

    Expression expr;
    size_t i = 0;

    REQUIRE_FALSE(expr.parse(line, i, &module, section));
    REQUIRE(i == 0);                 // index unchanged on failure
    REQUIRE(expr.to_string() == ""); // no tokens captured
}

TEST_CASE("Expression::parse syntax errors return false and leave index unchanged",
          "[model][expr][parse][syntax]") {
    auto make_loc = [](int n) {
        return Location("syntax_errors.asm", n);
    };
    Module module("TEST", make_loc(1));
    Section* section = module.current_section();

    // 1) unexpected closing paren: ")"
    {
        TokenLine line(make_loc(1));
        line.tokens().push_back(Token(TokenType::RightParen, ")", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 2) unterminated opening paren: "("
    {
        TokenLine line(make_loc(2));
        line.tokens().push_back(Token(TokenType::LeftParen, "(", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 3) lone unary '+'
    {
        TokenLine line(make_loc(3));
        line.tokens().push_back(Token(TokenType::Plus, "+", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 4) lone unary '!'
    {
        TokenLine line(make_loc(4));
        line.tokens().push_back(Token(TokenType::LogicalNot, "!", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 5) lone unary '~'
    {
        TokenLine line(make_loc(5));
        line.tokens().push_back(Token(TokenType::BitwiseNot, "~", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 6) lone unary '!' (duplicate on purpose)
    {
        TokenLine line(make_loc(6));
        line.tokens().push_back(Token(TokenType::LogicalNot, "!", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 7) "(1 + 2" - missing closing paren
    {
        TokenLine line(make_loc(7));
        line.tokens().push_back(Token(TokenType::LeftParen, "(", false));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Plus, "+", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 8) "1 + (2 * 3" - missing closing paren in nested expr
    {
        TokenLine line(make_loc(8));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Plus, "+", true));
        line.tokens().push_back(Token(TokenType::LeftParen, "(", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
        line.tokens().push_back(Token(TokenType::Multiply, "*", true));
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 9) "1 +"
    {
        TokenLine line(make_loc(9));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Plus, "+", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 10) "1 * !" - missing RHS operand
    {
        TokenLine line(make_loc(10));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Multiply, "*", true));
        line.tokens().push_back(Token(TokenType::LogicalNot, "!", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 11) "* 1" - missing LHS (prefix '*')
    {
        TokenLine line(make_loc(11));
        line.tokens().push_back(Token(TokenType::Multiply, "*", true));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 12) "1 <<" - missing RHS shift amount
    {
        TokenLine line(make_loc(12));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::LeftShift, "<<", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 13) "<< 1" - missing LHS value for shift
    {
        TokenLine line(make_loc(13));
        line.tokens().push_back(Token(TokenType::LeftShift, "<<", true));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 14) ":" - lone colon
    {
        TokenLine line(make_loc(14));
        line.tokens().push_back(Token(TokenType::Colon, ":", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 15) "1 ?" - ternary missing true/false parts
    {
        TokenLine line(make_loc(15));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Question, "?", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 16) "1 ? 2" - ternary missing ':' and false part
    {
        TokenLine line(make_loc(16));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Question, "?", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 17) "1 ? : 2" - ternary missing true part
    {
        TokenLine line(make_loc(17));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Question, "?", true));
        line.tokens().push_back(Token(TokenType::Colon, ":", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 18) "? 2 : 3" - ternary missing condition
    {
        TokenLine line(make_loc(18));
        line.tokens().push_back(Token(TokenType::Question, "?", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
        line.tokens().push_back(Token(TokenType::Colon, ":", true));
        line.tokens().push_back(Token(TokenType::Integer, "3", 3, false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }

    // 19) "1 ? 2 : " - ternary missing false part
    {
        TokenLine line(make_loc(19));
        line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
        line.tokens().push_back(Token(TokenType::Question, "?", true));
        line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
        line.tokens().push_back(Token(TokenType::Colon, ":", false));
        Expression expr;
        size_t i = 0;
        REQUIRE_FALSE(expr.parse(line, i, &module, section));
        REQUIRE(i == 0);
    }
}

TEST_CASE("Expression::parse stops before trailing binary operator when followed by comma",
          "[model][expr][parse][stop-index][trailing-op]") {
    Location loc("trail_binop_comma.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Tokens: 1 + 2 , rest
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
    line.tokens().push_back(Token(TokenType::Comma, ",", false));
    line.tokens().push_back(Token(TokenType::Identifier, "rest", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // Must stop at the comma; it should remain unconsumed
    REQUIRE(i == 3);
    REQUIRE(line.tokens()[i].type() == TokenType::Comma);

    // Only the valid prefix "1+2" is captured
    REQUIRE(expr.to_string() == "1+2");
    REQUIRE(expr.evaluate() == 3);
}

TEST_CASE("Expression::parse stops before extra closing parenthesis after binary expression",
          "[model][expr][parse][stop-index][paren]") {
    Location loc("trail_binop_paren.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Tokens: ( 1 + 2 ) )
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::LeftParen, "(", false));
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false)); // extra

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // The extra ')' must remain unconsumed
    REQUIRE(i == 5);
    REQUIRE(line.tokens()[i].type() == TokenType::RightParen);

    // Only the valid prefix "(1+2)" is captured
    REQUIRE(expr.to_string() == "(1+2)");
    REQUIRE(expr.evaluate() == 3);
}

TEST_CASE("Expression::parse reports error on unexpected '?' at start and leaves index unchanged",
          "[model][expr][parse][ternary][errors]") {
    Location loc("ternary_unexpected_qmark.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Input: "?"
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Question, "?", false));

    Expression expr;
    size_t i = 0;

    REQUIRE_FALSE(expr.parse(line, i, &module, section));
    REQUIRE(i == 0);                 // index unchanged on failure
    REQUIRE(expr.to_string() == ""); // nothing captured
}

TEST_CASE("Expression::parse reports error on missing ':' in ternary and leaves index unchanged",
          "[model][expr][parse][ternary][errors]") {
    Location loc("ternary_missing_colon.asm", 2);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Input: "1 ? 2" (no ':' and false-branch)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Integer, "1", 1, true));
    line.tokens().push_back(Token(TokenType::Question, "?", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;

    REQUIRE_FALSE(expr.parse(line, i, &module, section));
    REQUIRE(i == 0);                 // index unchanged on failure
    REQUIRE(expr.to_string() == ""); // nothing captured
}
