//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "catch_amalgamated.hpp"
#include "../error_reporter.h"
#include <sstream>
#include <iostream>

// Helper to capture std::cerr output
class CerrRedirect {
    std::streambuf* old;
    std::ostringstream ss;
public:
    CerrRedirect() : old(std::cerr.rdbuf(ss.rdbuf())) {}
    ~CerrRedirect() {
        std::cerr.rdbuf(old);
    }
    std::string str() const {
        return ss.str();
    }
};

TEST_CASE("ErrorReporter counts errors", "[ErrorReporter]") {
    ErrorReporter er;
    er.error(ErrorCode::FileNotFound);
    er.error(ErrorCode::InvalidSyntax, "foo");
    REQUIRE(er.error_count() == 2);
}

TEST_CASE("ErrorReporter does not count warnings", "[ErrorReporter]") {
    ErrorReporter er;
    er.warning(ErrorCode::FileNotFound);
    er.warning(ErrorCode::InvalidSyntax, "foo");
    REQUIRE(er.error_count() == 0);
}

TEST_CASE("ErrorReporter prints error", "[ErrorReporter]") {
    ErrorReporter er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "test.asm");
    std::string output = redirect.str();
    REQUIRE(output.find("error: File not found: test.asm") != std::string::npos);
}

TEST_CASE("ErrorReporter prints warning", "[ErrorReporter]") {
    ErrorReporter er;
    CerrRedirect redirect;
    er.warning(ErrorCode::FileNotFound, "test.asm");
    std::string output = redirect.str();
    REQUIRE(output.find("warning: File not found: test.asm") != std::string::npos);
}

TEST_CASE("ErrorReporter prints with Location", "[ErrorReporter]") {
    ErrorReporter er;
    Location loc("foo.asm", 42);
    loc.source_line = "LD A, 42";
    loc.expanded_line = "LD A,42";
    CerrRedirect redirect;
    er.error(loc, ErrorCode::InvalidSyntax, "bad token");
    std::string output = redirect.str();
    REQUIRE(output.find("foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
    REQUIRE(output.find("   |LD A, 42") != std::string::npos);
    REQUIRE(output.find("   |LD A,42") != std::string::npos);
}
