//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error_reporter.h"

Location::Location(const std::string& filename, int line_num)
    : filename_(filename), line_num_(line_num) {
}

#define X(code, msg) msg,
const char* ErrorReporter::error_messages[] = {
#include "error_codes.def"
};
#undef X

ErrorReporter::ErrorReporter() = default;

void ErrorReporter::error(ErrorCode code, const std::string& arg) {
    ++error_count_;
    print_message("error", format_message(code, arg));
}

void ErrorReporter::warning(ErrorCode code, const std::string& arg) {
    print_message("warning", format_message(code, arg));
}

void ErrorReporter::error(const Location& loc, ErrorCode code,
                          const std::string& arg) {
    ++error_count_;
    print_message(loc, "error", format_message(code, arg));
}

void ErrorReporter::warning(const Location& loc, ErrorCode code,
                            const std::string& arg) {
    print_message(loc, "warning", format_message(code, arg));
}

int ErrorReporter::error_count() const {
    return error_count_;
}

bool ErrorReporter::has_error() const
{
    return error_count_ > 0;
}

void ErrorReporter::print_message(const std::string& prefix,
                                  const std::string& message) {
    std::cerr << prefix << ": " << message << std::endl;
}

void ErrorReporter::print_message(const Location& loc,
                                  const std::string& prefix,
    const std::string& message) {
    std::cerr << loc.filename() << ":" << loc.line_num() << ": "
        << prefix << ": " << message << std::endl;
    if (!loc.source_line().empty()) {
        std::cerr << "   |" << loc.source_line() << std::endl;
    }
    if (!loc.expanded_line().empty()) {
        std::cerr << "   |" << loc.expanded_line() << std::endl;
    }
}

std::string ErrorReporter::format_message(ErrorCode code,
        const std::string& arg) const {
    std::string msg = error_messages[static_cast<int>(code)];
    if (!arg.empty()) {
        msg += ": " + arg;
    }
    return msg;
}
