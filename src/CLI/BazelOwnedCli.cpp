#include "BazelOwnedCli.hpp"

#include "libslic3r/Config.hpp"
#include "libslic3r/PrintConfig.hpp"

#include <boost/nowide/iostream.hpp>

#include <optional>
#include <string>
#include <vector>

namespace {

struct OwnedSaveRequest {
    std::string save_path;
    std::vector<std::string> load_paths;
};

enum class OwnedParseResult {
    NotHandled,
    Handled,
    Error,
};

bool option_name_matches(const std::string &token, const char *long_name) {
    return token == long_name || token == std::string(long_name) + "=";
}

OwnedParseResult parse_save_request(
    int argc, char **argv, OwnedSaveRequest &request, std::string &error_message
) {
    bool saw_save = false;

    for (int i = 1; i < argc; ++i) {
        std::string token = argv[i];
        if (token == "--")
            return OwnedParseResult::NotHandled;
        if (token.empty() || token[0] != '-')
            return OwnedParseResult::NotHandled;
        if (token == "--help" || token == "-h")
            return OwnedParseResult::NotHandled;

        const auto read_value = [&](const char *name) -> std::optional<std::string> {
            const std::string prefix = std::string(name) + "=";
            if (token == name) {
                if (i + 1 >= argc) {
                    error_message = std::string("Missing value for ") + name + ".";
                    return std::nullopt;
                }
                return std::string(argv[++i]);
            }

            if (token.rfind(prefix, 0) == 0)
                return token.substr(prefix.size());

            return {};
        };

        if (option_name_matches(token, "--save")) {
            auto maybe_value = read_value("--save");
            if (!maybe_value.has_value())
                return OwnedParseResult::Error;
            request.save_path = *maybe_value;
            saw_save = true;
            continue;
        }

        if (option_name_matches(token, "--load")) {
            auto maybe_value = read_value("--load");
            if (!maybe_value.has_value())
                return OwnedParseResult::Error;
            request.load_paths.push_back(*maybe_value);
            continue;
        }

        return OwnedParseResult::NotHandled;
    }

    if (!saw_save)
        return OwnedParseResult::NotHandled;

    return OwnedParseResult::Handled;
}

int run_owned_save_request(const OwnedSaveRequest &request) {
    try {
        Slic3r::DynamicPrintConfig config = Slic3r::DynamicPrintConfig::full_print_config();
        for (const std::string &path : request.load_paths)
            config.load(path, Slic3r::ForwardCompatibilitySubstitutionRule::Enable);

        config.normalize_fdm();
        config.save(request.save_path);
        boost::nowide::cout << "Configuration saved to " << request.save_path << std::endl;
        return 0;
    } catch (const std::exception &error) {
        boost::nowide::cerr << error.what() << std::endl;
        return 1;
    }
}

} // namespace

namespace Slic3r::CLI {

int maybe_run_owned_cli(int argc, char **argv) {
    OwnedSaveRequest request;
    std::string error_message;

    switch (parse_save_request(argc, argv, request, error_message)) {
    case OwnedParseResult::NotHandled:
        return -1;
    case OwnedParseResult::Handled:
        return run_owned_save_request(request);
    case OwnedParseResult::Error:
        boost::nowide::cerr << error_message << std::endl;
        return 1;
    }

    return -1;
}

} // namespace Slic3r::CLI
