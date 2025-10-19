//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include "lexer.h"
#include <cinttypes>

// ------------------- Expression evaluator (shunting-yard) -------------------
// Token types used by the expression parser
enum class ExprTokType { Number, Op, LParen, RParen, Question, Colon };
struct ExprTok {
    ExprTokType type;
    std::string op; // for Op tokens (includes "u-" for unary minus, "?:", etc.)
    int64_t value;  // for Number tokens
};

// Integer power by exponentiation-by-squaring.
// Returns base^exp for exp >= 0.
// For exp < 0 this implementation returns 0 (caller should handle negative exponents if needed).
static int64_t ipow(int64_t base, int64_t exp) {
    if (exp < 0) {
        // No integer result for negative exponents in this codebase;
        // choose behavior: return 0 to indicate "non-integer" or treat as error before calling.
        return 0;
    }

    // Use 64-bit intermediate to reduce immediate overflow risk.
    int64_t result = 1;
    int64_t b = base;
    while (exp > 0) {
        if (exp & 1) {
            result *= b;
        }
        b *= b;
        exp >>= 1;
    }
    return result;
}

// Operator precedence and associativity helpers
static int op_prec(const std::string& op) {
    if (op == "**") {
        return 15;
    }
    if (op == "u+" || op == "u-" || op == "!" || op == "~") {
        return 14;
    }
    if (op == "*" || op == "/" || op == "%") {
        return 13;
    }
    if (op == "+" || op == "-") {
        return 12;
    }
    if (op == "<<" || op == ">>") {
        return 11;
    }
    if (op == "<" || op == "<=" || op == ">" || op == ">=") {
        return 10;
    }
    if (op == "==" || op == "!=" || op == "=" || op == "<>") {
        return 9;
    }
    if (op == "&") {
        return 8;
    }
    if (op == "^") {
        return 7;
    }
    if (op == "|") {
        return 6;
    }
    if (op == "&&") {
        return 5;
    }
    if (op == "||" || op == "^^") {
        return 4;
    }
    if (op == "?:") {
        return 3;    // ternary operator placeholder (3- right-assoc)
    }
    return 0;
}

static bool op_is_right_assoc(const std::string& op) {
    if (op == "u+" || op == "u-" || op == "!" || op == "~" || op == "**") {
        return true;
    }
    if (op == "?:") {
        return true;
    }
    return false;
}

// Apply unary operator. Returns pair(success, result).
static std::pair<bool, int64_t> apply_unary(const std::string& op, int64_t v) {
    if (op == "u-")
        return { true, -v };
    if (op == "u+")
        return { true, v };
    if (op == "!")
        return { true, (v == 0) ? 1 : 0 };
    if (op == "~")
        return { true, ~v };
    return { false, 0 };
}

// Apply binary operator. Returns pair(success, result).
static std::pair<bool, int64_t> apply_binary(
    const std::string& op, int64_t a, int64_t b) {
    if (op == "**")
        return { true, ipow(a, b) };
    if (op == "+")
        return { true, a + b };
    if (op == "-")
        return { true, a - b };
    if (op == "*")
        return { true, a * b };
    if (op == "/") {
        if (b == 0)
            return { false, 0 };
        return { true, a / b };
    }
    if (op == "%") {
        if (b == 0)
            return { false, 0 };
        return { true, a % b };
    }
    if (op == "<<")
        return { true, a << b };
    if (op == ">>")
        return { true, a >> b };
    if (op == "<")
        return { true, (a < b) ? 1 : 0 };
    if (op == "<=")
        return { true, (a <= b) ? 1 : 0 };
    if (op == ">")
        return { true, (a > b) ? 1 : 0 };
    if (op == ">=")
        return { true, (a >= b) ? 1 : 0 };
    if (op == "==" || op == "=")
        return { true, (a == b) ? 1 : 0 };
    if (op == "!=" || op == "<>")
        return { true, (a != b) ? 1 : 0 };
    if (op == "&")
        return { true, a & b };
    if (op == "^")
        return { true, a ^ b };
    if (op == "|")
        return { true, a | b };
    if (op == "&&")
        return { true, (a&& b) ? 1 : 0 };
    if (op == "||")
        return { true, (a || b) ? 1 : 0 };
    if (op == "^^")
        return { true, (a != b) ? 1 : 0 };
    return { false, 0 };
}

// Tokenize an expression starting at p. Advances p to the first char after the tokenized portion.
// Returns token vector on success. If an invalid token is found, returns empty vector.
static std::vector<ExprTok> tokenize_expression(const char*& p) {
    std::vector<ExprTok> toks;
    const char* s = p;
    bool expect_unary = true;
    while (*s) {
        // Stop at first character that cannot be part of an expression token (we'll accept a broad set).
        // But we allow whitespace to continue; break on chars like ';' or end-of-string.
        // We'll stop tokenization if we reach a character that is not part of expression syntax.
        // Acceptable characters: digits, quotes (handled by scan_integer), operators and parentheses, whitespace, '?', ':'.
        // We'll attempt to parse numbers using scan_integer which handles many formats.
        // Skip whitespace
        skip_whitespace(s);
        if (!*s) {
            break;
        }

        // Parentheses
        if (*s == '(') {
            toks.push_back({ ExprTokType::LParen, "(", 0 });
            ++s;
            expect_unary = true;
            continue;
        }
        if (*s == ')') {
            toks.push_back({ ExprTokType::RParen, ")", 0 });
            ++s;
            expect_unary = false;
            continue;
        }

        // Ternary tokens
        if (*s == '?') {
            toks.push_back({ ExprTokType::Question, "?", 0 });
            ++s;
            expect_unary = true;
            continue;
        }
        if (*s == ':') {
            toks.push_back({ ExprTokType::Colon, ":", 0 });
            ++s;
            expect_unary = true;
            continue;
        }

        // Attempt number scan (uses existing scan_integer). Need to pass a local pointer.
        const char* save = s;
        int intval = 0;
        if (scan_integer(s, intval)) {
            toks.push_back({ ExprTokType::Number, "", static_cast<int64_t>(intval) });
            expect_unary = false;
            continue;
        }
        s = save; // restore if not a number

        // operators
        std::string op;
        save = s;
        if (scan_operator(s, op)) {
            if (op == "&&" || op == "||" || op == "^^" ||
                    op == "==" || op == "=" || op == "!=" || op == "<>" ||
                    op == "<=" || op == ">=" || op == "<<" || op == ">>" ||
                    op == "**" ||
                    op == "+" || op == "-" || op == "*" || op == "/" ||
                    op == "%" || op == "<" || op == ">" ||
                    op == "&" || op == "|" || op == "^" ||
                    op == "!" || op == "~") {

                // Distinguish unary + and - by context
                if ((op == "+" || op == "-") && expect_unary) {
                    std::string u = (op == "+") ? "u+" : "u-";
                    toks.push_back({ ExprTokType::Op, u, 0 });
                }
                else {
                    toks.push_back({ ExprTokType::Op, op, 0 });
                }

                expect_unary = true;
                continue;
            }
        }
        s = save;

        // If we reach here, token is unrecognized -> stop tokenization
        break;
    }

    // Advance caller pointer to s (consumed portion)
    p = s;
    return toks;
}

// Convert token list (infix) to RPN using shunting-yard and special handling for ternary operator.
static bool to_rpn(const std::vector<ExprTok>& infix,
                   std::vector<ExprTok>& out_rpn) {
    out_rpn.clear();
    std::vector<ExprTok> ops;
    for (size_t i = 0; i < infix.size(); ++i) {
        const ExprTok& tk = infix[i];
        if (tk.type == ExprTokType::Number) {
            out_rpn.push_back(tk);
        }
        else if (tk.type == ExprTokType::Op) {
            std::string op = tk.op;
            while (!ops.empty()) {
                const ExprTok& top = ops.back();
                if (top.type == ExprTokType::Op) {
                    int p1 = op_prec(top.op);
                    int p2 = op_prec(op);
                    if ((op_is_right_assoc(op) && p1 > p2) ||
                            (!op_is_right_assoc(op) && p1 >= p2)) {
                        out_rpn.push_back(top);
                        ops.pop_back();
                        continue;
                    }
                }
                break;
            }
            ops.push_back(tk);
        }
        else if (tk.type == ExprTokType::LParen) {
            ops.push_back(tk);
        }
        else if (tk.type == ExprTokType::RParen) {
            bool found = false;
            while (!ops.empty()) {
                if (ops.back().type == ExprTokType::LParen) {
                    ops.pop_back();
                    found = true;
                    break;
                }
                out_rpn.push_back(ops.back());
                ops.pop_back();
            }
            if (!found) {
                return false;    // mismatched parens
            }
        }
        else if (tk.type == ExprTokType::Question) {
            // push '?' as an operator marker
            ops.push_back(tk);
        }
        else if (tk.type == ExprTokType::Colon) {
            // pop operators to output until '?' is on top
            bool found_q = false;
            while (!ops.empty()) {
                if (ops.back().type == ExprTokType::Question) {
                    ops.pop_back(); // pop '?'
                    found_q = true;
                    // Push a special operator token '?:' onto ops so it will be applied after false expr
                    ops.push_back({ ExprTokType::Op, "?:", 0 });
                    break;
                }
                out_rpn.push_back(ops.back());
                ops.pop_back();
            }
            if (!found_q) {
                return false;    // mismatched ?: pair
            }
        }
    }
    while (!ops.empty()) {
        if (ops.back().type == ExprTokType::LParen
                || ops.back().type == ExprTokType::RParen ||
                ops.back().type == ExprTokType::Question) {
            return false; // mismatched parens or question
        }
        out_rpn.push_back(ops.back());
        ops.pop_back();
    }
    return true;
}

// Evaluate RPN expression. Returns true on success and sets result.
static bool eval_rpn(const std::vector<ExprTok>& rpn, int64_t& result) {
    std::vector<int64_t> st;
    for (const auto& tk : rpn) {
        if (tk.type == ExprTokType::Number) {
            st.push_back(tk.value);
        }
        else if (tk.type == ExprTokType::Op) {
            const std::string& op = tk.op;
            if (op == "u-" || op == "u+" || op == "!" || op == "~") {
                if (st.empty()) {
                    return false;
                }
                int64_t v = st.back();
                st.pop_back();
                auto pr = apply_unary(op, v);
                if (!pr.first) {
                    return false;
                }
                st.push_back(pr.second);
            }
            else if (op == "?:") {
                // ternary: need three operands: cond, trueVal, falseVal
                if (st.size() < 3) {
                    return false;
                }
                int64_t falseVal = st.back();
                st.pop_back();
                int64_t trueVal = st.back();
                st.pop_back();
                int64_t cond = st.back();
                st.pop_back();
                st.push_back(cond ? trueVal : falseVal);
            }
            else {
                if (st.size() < 2) {
                    return false;
                }
                int64_t b = st.back();
                st.pop_back();
                int64_t a = st.back();
                st.pop_back();
                auto pr = apply_binary(op, a, b);
                if (!pr.first) {
                    return false;
                }
                st.push_back(pr.second);
            }
        }
        else {
            return false;
        }
    }
    if (st.size() != 1) {
        return false;
    }
    result = st.back();
    return true;
}

// Main evaluator entry. Parses an expression starting at p, advances p to the char after the expression.
bool eval_const_expr(const char*& p, int& value) {
    value = 0;
    const char* s = p;

    // Tokenize (tokenize_expression advances s to consumed portion)
    std::vector<ExprTok> infix = tokenize_expression(s);
    if (infix.empty()) {
        return false;
    }

    std::vector<ExprTok> rpn;
    if (!to_rpn(infix, rpn)) {
        return false;
    }

    int64_t res = 0;
    if (!eval_rpn(rpn, res)) {
        return false;
    }

    value = static_cast<int>(res);

    // Advance caller pointer to the position after the parsed expression
    p = s;
    return true;
}
