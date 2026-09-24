//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assemble.h"
#include "errors.h"
#include "options.h"
#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

static inline const std::string ASSEMBLER_COMMAND = "z88dk-z80asm -b -m";

static bool make_asm_file(const std::string& filename,
                          const std::vector<std::string>& asm_source) {
    std::ofstream ofs(filename, std::ios::binary);
    if (!ofs) {
        error("Failed to open file: " + filename);
        return false;
    }
    for (const auto& line : asm_source) {
        ofs << line << "\n";
    }
    return true;
}

static bool assemble(const std::string& asm_filename,
                     const std::string& p_file) {
    std::string cmd = ASSEMBLER_COMMAND +
                      " -o\"" + p_file +
                      "\" \"" + asm_filename + "\"";
    if (g_verbose) {
        std::cout << "% " << cmd << std::endl;
    }
    if (system(cmd.c_str()) != 0) {
        fatal("assembler failed, command line: " + cmd);
        return false;
    }
    return true;
}

// parse lines like: LABEL1 = $408F
static bool parse_map_line(const std::string& line, std::string& label,
                           int& address) {
    // get label
    const char* p = line.c_str();
    if (!isalpha(*p) && *p != '_') {
        return false;
    }
    while (*p && (isalnum(*p) || *p == '_')) {
        p++;
    }
    label = line.substr(0, p - line.c_str());

    // skip whitespace
    while (*p && isspace(*p)) {
        p++;
    }

    // need '='
    if (*p != '=') {
        return false;
    }
    p++;

    // skip whitespace
    while (*p && isspace(*p)) {
        p++;
    }

    // skip '$'
    if (*p != '$') {
        return false;
    }
    p++;

    // collect hex digits
    const char* addr_start = p;
    while (*p && isxdigit(*p)) {
        p++;
    }
    std::string addr_str(addr_start, p - addr_start);
    if (addr_str.empty()) {
        return false;
    }

    address = std::stoi(addr_str, nullptr, 16);
    return true;
}

static bool read_map_symbols(const std::string& map_filename,
                             std::unordered_map<std::string, int>& label_addr) {
    std::ifstream map_file(map_filename);
    if (!map_file) {
        error("Failed to open file: " + map_filename);
        return false;
    }

    std::string line;
    while (std::getline(map_file, line)) {
        std::string label;
        int address = 0;
        if (parse_map_line(line, label, address)) {
            label_addr[label] = address;
        }
    }
    return true;
}

// make .sym file for Eightyone: HHHH name
static bool make_sym_file(const std::string& sym_filename,
                          const std::unordered_map<std::string, int>& label_addr) {
    std::ofstream ofs(sym_filename, std::ios::binary);
    if (!ofs) {
        error("Failed to open file: " + sym_filename);
        return false;
    }

    // sort labels by address
    std::vector<std::pair<std::string, int>> sorted_labels(label_addr.begin(),
                                          label_addr.end());
    std::sort(sorted_labels.begin(), sorted_labels.end(),
    [](const auto & a, const auto & b) {
        if (a.second != b.second) {
            return a.second < b.second;
        }
        return a.first < b.first;
    });

    // output labels in range __head to __tail
    int head_addr = 0x4000;
    auto it = label_addr.find("__head");
    if (it != label_addr.end()) {
        head_addr = it->second;
    }

    int tail_addr = 0x10000;
    it = label_addr.find("__tail");
    if (it != label_addr.end()) {
        tail_addr = it->second;
    }

    for (const auto& [label, addr] : sorted_labels) {
        if (addr < head_addr || addr >= tail_addr) {
            continue;
        }

        std::ostringstream oss;
        oss << std::hex << std::uppercase << std::setw(4) << std::setfill('0') << addr;
        ofs << oss.str() << " " << label << std::endl;
    }
    return true;
}

bool assemble_link(const std::vector<std::string>& asm_source,
                   const std::string& input_basename,
                   std::unordered_map<std::string, int>& label_addr) {
    // make asm file
    std::string asm_filename = input_basename + ".asm";
    g_temp_files.push_back(asm_filename);
    if (!make_asm_file(asm_filename, asm_source)) {
        return false;
    }

    // run assembler and linker
    std::string o_filename = input_basename + ".o";
    g_temp_files.push_back(o_filename);
    std::string lis_filename = input_basename + ".lis";
    g_temp_files.push_back(lis_filename);
    std::string bin_filename = input_basename + ".bin";
    g_temp_files.push_back(bin_filename);

    std::string map_filename = input_basename + ".map";
    std::string p_filename = input_basename + ".p";

    if (!assemble(asm_filename, p_filename)) {
        return false;
    }

    // read map file and get label addresses
    if (!read_map_symbols(map_filename, label_addr)) {
        return false;
    }

    // generate .sym file
    std::string sym_filename = input_basename + ".sym";
    if (!make_sym_file(sym_filename, label_addr)) {
        return false;
    }

    return get_error_count() == 0;
}
