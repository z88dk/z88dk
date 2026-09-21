//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "emit_asm.h"
#include "errors.h"
#include "lexer.h"
#include "simplify_expr.h"
#include "utils.h"
#include "zx81bas.h"
#include "zx81chars.h"
#include <algorithm>
#include <cctype>
#include <cstdint>
#include <iomanip>
#include <ios>
#include <sstream>
#include <string>
#include <vector>

static std::string string_to_zx81(const std::string& text,
                                  bool check_keywords,
                                  const SourceLoc& loc,
                                  bool invert = false) {
    constexpr size_t INDENT = 16;
    constexpr size_t MAX_WIDTH = 80 - INDENT - 2;

    std::ostringstream oss;
    const char* p = text.c_str();
    size_t width = 0;
    while (*p) {
        if (p != text.c_str()) {
            oss << ",";
            width++;
        }

        std::string encoded;
        uint8_t code;
        if (!encode_zx81_char(p, check_keywords, code, loc)) {
            encoded = int8_to_hex(code);
            p++;  // skip the invalid character
        }
        else {
            if (invert) {
                code ^= 0x80;  // invert the character
            }
            encoded = zx81_char_name(code);
        }

        if (width + encoded.length() > MAX_WIDTH) {
            oss << " \\\n" << std::string(INDENT, ' ');
            width = 0;
        }
        oss << encoded;
        width += encoded.length();
    }

    return oss.str();
}

static void emit(std::vector<std::string>& asm_source,
                 const std::string& label,
                 const std::string& opcode = "",
                 const std::string& operand = "",
                 const std::string& comment = "") {
    std::ostringstream oss;
    oss << std::setw(8) << std::left << label;
    oss << std::setw(8) << std::left << opcode;
    oss << std::setw(16) << std::left << operand;
    oss << comment;
    asm_source.push_back(str_trim(oss.str()));
}

static void emit_header(std::vector<std::string>& asm_source, int pass) {
    emit(asm_source, "; ZX81BAS generated assembly code");
    emit(asm_source, "; Pass: " + std::to_string(pass));
    emit(asm_source, "");
    emit(asm_source, "", "ORG", "0x4009", "; Start of .p file");
    emit(asm_source, "");
    emit(asm_source, "", "SETFLOAT zx81");
    emit(asm_source, "");
    emit(asm_source, "", "DEFC", "SLOW_FLAG       = 0x40");
    emit(asm_source, "", "DEFC", "FAST_FLAG       = 0x00");
    emit(asm_source, "");
}

static void emit_charset(std::vector<std::string>& asm_source) {
    emit(asm_source, "; zx81 character set");
    emit(asm_source, "");
    for (size_t i = 0; i < 256; ++i) {
        std::string char_name = zx81_char_name(static_cast<uint8_t>(i));
        if (!char_name.empty() && !isdigit(char_name[0])) {
            // defined character name
            std::ostringstream oss;
            oss << std::setw(16) << std::left << char_name;
            emit(asm_source, "", "DEFC", oss.str() + "= " +
                 int8_to_hex(static_cast<uint8_t>(i)));
        }
    }
    emit(asm_source, "");
}

static void emit_sysvars(Prog& prog,
                         std::vector<std::string>& asm_source) {
    std::vector<uint8_t> sysvars_data = prog.sysvars_data;
    size_t sysvars_index = 0;
    auto get_byte = [&](uint8_t def) -> uint8_t {
        if (sysvars_index < sysvars_data.size()) {
            return sysvars_data[sysvars_index++];
        }
        else {
            return def;
        }
    };
    auto get_word = [&](uint16_t def) -> uint16_t {
        uint8_t low = get_byte(static_cast<uint8_t>(def & 0xFF));
        uint8_t high = get_byte(static_cast<uint8_t>((def >> 8) & 0xFF));
        return static_cast<uint16_t>(low) | (static_cast<uint16_t>(high) << 8);
    };

    emit(asm_source, "; System variables");
    emit(asm_source, "");
    emit(asm_source, "VERSN:", "DEFB", std::to_string(get_byte(0)));
    emit(asm_source, "E_PPC:", "DEFW", std::to_string(get_word(0)));
    emit(asm_source, "D_FILE:", "DEFW", "DISPLAY");
    sysvars_index += 2;
    emit(asm_source, "DF_CC:", "DEFW", "DISPLAY+1");
    sysvars_index += 2;
    emit(asm_source, "VARS:", "DEFW", "VARIABLES");
    sysvars_index += 2;
    emit(asm_source, "DEST:", "DEFW", "0");
    sysvars_index += 2;
    emit(asm_source, "E_LINE:", "DEFW", "WORKSPACE");
    sysvars_index += 2;
    emit(asm_source, "CH_ADD:", "DEFW", "WORKSPACE");
    sysvars_index += 2;
    emit(asm_source, "X_PTR:", "DEFW", "0");
    sysvars_index += 2;
    emit(asm_source, "STKBOT:", "DEFW", "WORKSPACE");
    sysvars_index += 2;
    emit(asm_source, "STKEND:", "DEFW", "WORKSPACE");
    sysvars_index += 2;
    emit(asm_source, "BREG:", "DEFB", std::to_string(get_byte(0)));
    uint16_t mem = get_word(0x405D);
    emit(asm_source, "MEM:", "DEFW",
         mem == 0x405D ? "MEMBOT" : int16_to_hex(mem));
    emit(asm_source, "FREE1:", "DEFB", std::to_string(get_byte(0)));
    emit(asm_source, "DF_SZ:", "DEFB", std::to_string(get_byte(2)));
    emit(asm_source, "S_TOP:", "DEFW", std::to_string(get_word(0)));
    emit(asm_source, "LAST_K:", "DEFW", int16_to_hex(get_word(0xFFFF)));
    emit(asm_source, "DBOUNCE:", "DEFB", int8_to_hex(get_byte(0)));
    emit(asm_source, "MARGIN:", "DEFB", std::to_string(get_byte(55)));

    // auto execute line
    if (prog.auto_start) {
        emit(asm_source, "NXTLIN:", "DEFW", "AUTOSTART_ADDR");
    }
    else {
        emit(asm_source, "NXTLIN:", "DEFW", "DISPLAY");
    }
    sysvars_index += 2;

    emit(asm_source, "OLDPPC:", "DEFW", std::to_string(get_word(0)));
    emit(asm_source, "FLAGX:", "DEFB", int8_to_hex(get_byte(0)));
    emit(asm_source, "STRLEN:", "DEFW", std::to_string(get_word(0)));
    emit(asm_source, "T_ADDR:", "DEFW", int16_to_hex(get_word(0)));
    emit(asm_source, "SEED:", "DEFW", int16_to_hex(get_word(0)));
    emit(asm_source, "FRAMES:", "DEFW", int16_to_hex(get_word(0xFFFF)));
    emit(asm_source, "COORDS:");
    emit(asm_source, "COORDX:", "DEFB", std::to_string(get_byte(0)));
    emit(asm_source, "COORDY:", "DEFB", std::to_string(get_byte(0)));
    emit(asm_source, "PR_CC:", "DEFB", "PRBUFF & 0xFF");
    sysvars_index++;
    emit(asm_source, "S_POSN:");
    emit(asm_source, "S_POSNC:", "DEFB", std::to_string(get_byte(33)));
    emit(asm_source, "S_POSNL:", "DEFB", std::to_string(get_byte(24)));

    // FAST/SLOW flag
    if (prog.fast_mode) {
        emit(asm_source, "CDFLAG:", "DEFB", "FAST_FLAG");
    }
    else {
        emit(asm_source, "CDFLAG:", "DEFB", "SLOW_FLAG");
    }
    sysvars_index++;

    // printer buffer
    emit(asm_source, "PRBUFF:", "DEFB", "_SP,_SP,_SP,_SP,_SP,_SP,_SP,_SP");
    emit(asm_source, "", "DEFB", "_SP,_SP,_SP,_SP,_SP,_SP,_SP,_SP");
    emit(asm_source, "", "DEFB", "_SP,_SP,_SP,_SP,_SP,_SP,_SP,_SP");
    emit(asm_source, "", "DEFB", "_SP,_SP,_SP,_SP,_SP,_SP,_SP,_SP,_NL");
    sysvars_index += 33;

    // calculator workspace
    emit(asm_source, "MEMBOT:");
    for (int mem = 0; mem < 30 / 5; mem++) {
        emit(asm_source, "MEM" + std::to_string(mem) + ":", "DEFB", "0,0,0,0,0");
    }
    sysvars_index += 30;

    emit(asm_source, "FREE2:", "DEFW", int16_to_hex(get_word(0)));

    emit(asm_source, "");
}

static void emit_prog(Prog& prog, int pass,
                      std::vector<std::string>& asm_source) {
    bool did_auto_start_addr = false;

    emit(asm_source, "; BASIC program lines");
    emit(asm_source, "");
    emit(asm_source, "PROG:");
    emit(asm_source, "");
    for (size_t line_num = 0; line_num < prog.basic_lines.size(); line_num++) {
        const auto& line = prog.basic_lines[line_num];

        if (line.type != BasicLine::Type::BASIC) {
            continue;
        }

        // autostart
        if (prog.auto_start && !did_auto_start_addr) {
            if (!prog.auto_start_label.empty()) {
                if (std::find(line.labels.begin(), line.labels.end(),
                              prog.auto_start_label) != line.labels.end()) {
                    emit(asm_source, "AUTOSTART_ADDR:");
                    did_auto_start_addr = true;
                }
            }
            else if (line.line_num == prog.auto_start_line) {
                emit(asm_source, "AUTOSTART_ADDR:");
                did_auto_start_addr = true;
            }
        }

        // BASIC labels
        for (auto& label : line.labels) {
            emit(asm_source, label + ":");
        }

        // line text as comment
        BasicLine copy_line = line;
        copy_line.labels.clear();
        std::string line_text = copy_line.to_string();
        emit(asm_source, "; " + line_text);

        // line label, line number and size
        std::ostringstream oss;
        oss << std::setw(4) << std::setfill('0') << line.line_num;
        std::string line_label = "L" + oss.str();

        emit(asm_source, "", "DDB", std::to_string(line.line_num));
        emit(asm_source, "", "DEFW", line_label + "_END - " + line_label + "_START");
        emit(asm_source, line_label + "_START:");

        // line tokens as DEFB
        bool is_rem = !line.tokens.empty() && line.tokens[0].keyword == Keyword::REM;
        bool do_invert = is_rem && prog.rem_invert;

        // copy tokens and replace label references with addresses
        std::vector<Token> copy_tokens;
        copy_tokens.reserve(line.tokens.size());
        for (const auto& token : line.tokens) {
            Token copy_token = token;
            if (token.type == TokenType::LabelRefAddr) {
                auto it = prog.label_addr.find(token.svalue);
                if (it == prog.label_addr.end()) {
                    if (pass == 2) {
                        error(token.loc, "Undefined label: '" + token.svalue + "'");
                    }
                    copy_token.type = TokenType::Integer;
                    copy_token.ivalue = 0;
                    copy_token.text = "0";
                }
                else {
                    int addr = it->second;
                    copy_token.type = TokenType::Integer;
                    copy_token.ivalue = addr;
                    copy_token.text = std::to_string(addr);
                }
            }
            copy_tokens.push_back(copy_token);
        }

        // simplify expressions in tokens
        simplify_exprs(copy_tokens);

        // output tokens as DEFB
        for (auto& token : copy_tokens) {
            switch (token.type) {
            case TokenType::Float:
            case TokenType::Integer:
                emit(asm_source, "", "DEFB",
                     string_to_zx81(token.text, /*check_keywords=*/false, token.loc));
                emit(asm_source, "", "DEFB", "_NUMBER");
                emit(asm_source, "", "FLOAT", token.text);
                break;
            case TokenType::StringLiteral:
                emit(asm_source, "", "DEFB", "_QUOTE");
                emit(asm_source, "", "DEFB",
                     string_to_zx81(token.svalue, /*check_keywords=*/false, token.loc, false));
                emit(asm_source, "", "DEFB", "_QUOTE");
                break;
            case TokenType::RemComment:  // REM argument is a RemComment token
                emit(asm_source, "", "DEFB",
                     string_to_zx81(token.text, /*check_keywords=*/false, token.loc, do_invert));
                break;
            default:
                emit(asm_source, "", "DEFB", string_to_zx81(token.text, /*check_keywords=*/true,
                        token.loc));
                break;
            }
        }

        // asm lines
        bool in_asm_block = false;
        bool has_asm_block = false;
        while (line_num + 1 < prog.basic_lines.size() &&
                prog.basic_lines[line_num + 1].type == BasicLine::Type::ASM) {
            if (!in_asm_block) {
                emit(asm_source, "");
                emit(asm_source, "; ASM block");
                emit(asm_source, "");
                in_asm_block = true;
                has_asm_block = true;
            }

            const auto& asm_line = prog.basic_lines[++line_num];
            std::ostringstream oss;
            for (const auto& token : asm_line.tokens) {
                oss << token.ws_before;
                switch (token.type) {
                case TokenType::CharConstant:
                    oss << string_to_zx81(token.svalue, /*check_keywords=*/false, token.loc);
                    break;
                case TokenType::StringLiteral:
                    oss << string_to_zx81(token.svalue, /*check_keywords=*/false, token.loc);
                    break;
                case TokenType::LabelRefAddr: {
                    auto it = prog.label_addr.find(token.svalue);
                    if (it == prog.label_addr.end()) {
                        if (pass == 2) {
                            error(token.loc, "Undefined label: '" + token.svalue + "'");
                        }
                        oss << "0";
                    }
                    else {
                        int addr = it->second;
                        oss << int16_to_hex(addr);
                    }
                    break;
                }
                default:
                    oss << token.text;
                    break;
                }
            }
            emit(asm_source, oss.str());
        }

        if (has_asm_block) {
            emit(asm_source, "");
            emit(asm_source, "; End of ASM block");
            emit(asm_source, "");
        }

        // end of line
        emit(asm_source, "", "DEFB", "_NL");

        emit(asm_source, "");
        emit(asm_source, line_label + "_END:");
        emit(asm_source, "");

        if (!did_auto_start_addr) {
            emit(asm_source, "AUTOSTART_ADDR:");
            did_auto_start_addr = true;
        }
    }
}

static void emit_display(Prog& prog, std::vector<std::string>& asm_source) {
    emit(asm_source, "");
    emit(asm_source, "; Display file");
    emit(asm_source, "");
    emit(asm_source, "DISPLAY:", "DEFB", "_NL");

    for (size_t line_num = 0; line_num < 24; ++line_num) {
        // get line text
        std::string line_text;
        if (line_num < prog.dfile_lines.size()) {
            line_text = prog.dfile_lines[line_num];
        }

        // make exactly 32 characters, padding with spaces if needed
        if (line_text.size() < 32) {
            line_text += std::string(32 - line_text.size(), ' ');
        }
        else if (line_text.size() > 32) {
            line_text = line_text.substr(0, 32);
        }

        // colapse end spaces if requested
        if (prog.dfile_colapsed) {
            line_text = str_trim(line_text);
        }

        std::ostringstream oss;
        oss << std::setw(2) << std::setfill('0') << line_num;
        emit(asm_source, "DSPLY" + oss.str() + ":", "DEFB",
             string_to_zx81(line_text,
                            /*check_keywords=*/false, SourceLoc()));
        emit(asm_source, "", "DEFB", "_NL");
    }
    emit(asm_source, "");
}

static void emit_var(const PragmaNumVarStmt& stmt,
                     std::vector<std::string>& asm_source) {
    // header
    std::ostringstream oss;
    oss << "; Variable: " << stmt.name << " = " << stmt.value;
    emit(asm_source, oss.str());

    // convert variable name to ZX81 bytes
    const char* p = stmt.name.c_str();
    uint8_t code = 0;
    std::string encoded;
    if (stmt.name.size() == 1) {
        // 011-letter
        if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
            error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
            return;
        }
        encoded = zx81_char_name(code);
        emit(asm_source, "", "DEFB", "(" + encoded + " & 0x3F) | 0x60");
    }
    else {
        // 101-letter, 001-letter, 101-letter
        if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
            error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
            return;
        }
        encoded = zx81_char_name(code);
        emit(asm_source, "", "DEFB", "(" + encoded + " & 0x3F) | 0xA0");

        for (size_t i = 1; i < stmt.name.size() - 1; i++) {
            if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
                error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
                return;
            }
            encoded = zx81_char_name(code);
            emit(asm_source, "", "DEFB", "(" + encoded + " & 0x3F)");
        }

        if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
            error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
            return;
        }
        encoded = zx81_char_name(code);
        emit(asm_source, "", "DEFB", "(" + encoded + " & 0x3F) | 0x80");
    }

    // put value
    emit(asm_source, "", "FLOAT", double_to_string(stmt.value));
    emit(asm_source, "");
}

static void emit_var(Prog& prog, int pass, const PragmaStrVarStmt& stmt,
                     std::vector<std::string>& asm_source) {
    // header
    std::ostringstream oss;
    oss << "; Variable: " << stmt.name << " = " << "\"" << stmt.value << "\"";
    emit(asm_source, oss.str());

    // convert variable name to ZX81 bytes
    const char* p = stmt.name.c_str();
    uint8_t code = 0;
    std::string encoded;
    // 010-letter
    if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
        error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
        return;
    }
    encoded = zx81_char_name(code);
    emit(asm_source, "", "DEFB", "(" + encoded + " & 0x1F) | 0x40");

    // size field
    std::string name_without_dollar = stmt.name.substr(0, stmt.name.size() - 1);
    std::string label_radix = "VAR_" + name_without_dollar;
    emit(asm_source, "", "DEFW", label_radix + "_END - " + label_radix + "_START");
    emit(asm_source, label_radix + "_START:");

    // emit string value as ZX81 bytes
    if (!stmt.value.empty()) {
        emit(asm_source, "", "DEFB", string_to_zx81(stmt.value,/*check_keywords=*/false,
                stmt.loc));
    }

    // emit assembly lines if any
    bool in_asm_block = false;
    bool has_asm_block = false;
    for (const auto& asm_line : stmt.asm_lines) {
        if (!in_asm_block) {
            emit(asm_source, "");
            emit(asm_source, "; ASM block");
            emit(asm_source, "");
            in_asm_block = true;
            has_asm_block = true;
        }

        std::ostringstream oss;
        for (const auto& token : asm_line.tokens) {
            oss << token.ws_before;
            switch (token.type) {
            case TokenType::CharConstant:
                oss << string_to_zx81(token.svalue, /*check_keywords=*/false, token.loc);
                break;
            case TokenType::StringLiteral:
                oss << string_to_zx81(token.svalue, /*check_keywords=*/false, token.loc);
                break;
            case TokenType::LabelRefAddr: {
                auto it = prog.label_addr.find(token.svalue);
                if (it == prog.label_addr.end()) {
                    if (pass == 2) {
                        error(token.loc, "Undefined label: '" + token.svalue + "'");
                    }
                    oss << "0";
                }
                else {
                    int addr = it->second;
                    oss << int16_to_hex(addr);
                }
                break;
            }
            default:
                oss << token.text;
                break;
            }
        }
        emit(asm_source, oss.str());
    }

    if (has_asm_block) {
        emit(asm_source, "");
        emit(asm_source, "; End of ASM block");
        emit(asm_source, "");
    }

    emit(asm_source, label_radix + "_END:");
    emit(asm_source, "");
}

static void emit_var(const PragmaNumVarArrayStmt& stmt,
                     std::vector<std::string>& asm_source) {
    // header
    size_t num_values = 1;
    std::ostringstream oss;
    oss << "; Array: " << stmt.name << "(";
    bool first = true;
    for (auto dim : stmt.dims) {
        if (!first) {
            oss << ",";
        }
        first = false;

        oss << dim;
        num_values *= dim;
    }
    oss << ") = (";
    for (size_t i = 0; i < num_values; ++i) {
        if (i > 0) {
            oss << ",";
        }
        double value = (i < stmt.values.size()) ? stmt.values[i] : 0.0;
        oss << value;
    }
    oss << ")";
    emit(asm_source, oss.str());

    // convert variable name to ZX81 bytes
    const char* p = stmt.name.c_str();
    uint8_t code = 0;
    std::string encoded;
    // 100-letter
    if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
        error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
        return;
    }
    encoded = zx81_char_name(code);
    emit(asm_source, "", "DEFB", "(" + encoded + " & 0x1F) | 0x80");

    // dimensions
    emit(asm_source, "", "DEFW", "1 + "
         "2 * " + std::to_string(stmt.dims.size()) + " + " +
         "5 * " + std::to_string(num_values));

    emit(asm_source, "", "DEFB", std::to_string(stmt.dims.size() & 0xff));

    for (auto dim : stmt.dims) {
        emit(asm_source, "", "DEFW", std::to_string(dim));
    }

    for (size_t i = 0; i < num_values; ++i) {
        double value = (i < stmt.values.size()) ? stmt.values[i] : 0.0;
        emit(asm_source, "", "FLOAT", double_to_string(value));
    }

    emit(asm_source, "");
}

static void emit_var(const PragmaStrVarArrayStmt& stmt,
                     std::vector<std::string>& asm_source) {
    // header
    size_t num_values = 1;
    std::ostringstream oss;
    oss << "; Array: " << stmt.name << "(";
    bool first = true;
    for (auto dim : stmt.dims) {
        if (!first) {
            oss << ",";
        }
        first = false;

        oss << dim;
        num_values *= dim;
    }
    oss << ") = (";
    size_t last_dimension = stmt.dims.back();
    num_values /= last_dimension;
    std::vector<std::string> trimmed_strs;
    trimmed_strs.reserve(num_values);
    for (size_t i = 0; i < num_values; ++i) {
        if (i > 0) {
            oss << ",";
        }
        std::string value = (i < stmt.values.size()) ? stmt.values[i] : "";
        if (value.length() < last_dimension) {
            value += std::string(last_dimension - value.length(), ' ');
        }
        else if (value.length() > last_dimension) {
            value = value.substr(0, last_dimension);
        }
        trimmed_strs.push_back(value);
        oss << "\"" << value << "\"";
    }
    oss << ")";
    emit(asm_source, oss.str());

    // convert variable name to ZX81 bytes
    const char* p = stmt.name.c_str();
    uint8_t code = 0;
    std::string encoded;
    // 110-letter
    if (!encode_zx81_char(p, /*check_keywords=*/false, code, stmt.loc)) {
        error(stmt.loc, "Invalid variable name: '" + stmt.name + "'");
        return;
    }
    encoded = zx81_char_name(code);
    emit(asm_source, "", "DEFB", "(" + encoded + " & 0x1F) | 0xC0");

    // dimensions
    emit(asm_source, "", "DEFW", "1 + "
         "2 * " + std::to_string(stmt.dims.size()) + " + " +
         std::to_string(last_dimension) + " * " + std::to_string(num_values));

    emit(asm_source, "", "DEFB", std::to_string(stmt.dims.size() & 0xff));

    for (auto dim : stmt.dims) {
        emit(asm_source, "", "DEFW", std::to_string(dim));
    }

    for (auto& str : trimmed_strs) {
        emit(asm_source, "", "DEFB", string_to_zx81(str,/*check_keywords=*/false,
                stmt.loc));
    }

    emit(asm_source, "");
}

static void emit_vars(Prog& prog, int pass,
                      std::vector<std::string>& asm_source) {
    emit(asm_source, "");
    emit(asm_source, "; Variable definitions");
    emit(asm_source, "");
    emit(asm_source, "VARIABLES:");
    emit(asm_source, "");

    for (const auto& stmt : prog.pragma_vars) {
        if (auto var_stmt = dynamic_cast<const PragmaNumVarStmt*>(stmt.get())) {
            emit_var(*var_stmt, asm_source);
            continue;
        }
        if (auto var_stmt = dynamic_cast<const PragmaStrVarStmt*>(stmt.get())) {
            emit_var(prog, pass, *var_stmt, asm_source);
            continue;
        }
        if (auto var_stmt = dynamic_cast<const PragmaNumVarArrayStmt*>(stmt.get())) {
            emit_var(*var_stmt, asm_source);
            continue;
        }
        if (auto var_stmt = dynamic_cast<const PragmaStrVarArrayStmt*>(stmt.get())) {
            emit_var(*var_stmt, asm_source);
            continue;
        }
    }

    emit(asm_source, "", "DEFB", "0x80");
    emit(asm_source, "WORKSPACE:");
}

bool emit_asm(Prog& prog, int pass, std::vector<std::string>& asm_source) {
    emit_header(asm_source, pass);
    emit_charset(asm_source);
    emit_sysvars(prog, asm_source);
    emit_prog(prog, pass, asm_source);
    emit_display(prog, asm_source);
    emit_vars(prog, pass, asm_source);

    return get_error_count() == 0;
}
