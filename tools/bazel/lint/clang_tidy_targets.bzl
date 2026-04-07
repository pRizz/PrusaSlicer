"""Bounded Phase 4 clang-tidy surface."""

CLANG_TIDY_TARGETS = [
    "src/BazelMain.cpp",
    "src/CLI/BazelHandoff.cpp",
    "src/libslic3r/BazelConfigCompat.cpp",
    "tests/libslic3r/BazelCatchMain.cpp",
    "tests/thumbnails/BazelCatchMain.cpp",
    "tests/thumbnails/test_thumbnails_ini_string.cpp",
    "tests/thumbnails/test_thumbnails_input_string.cpp",
]

CLANG_TIDY_DEFERRED = [
    "readability and modernization checks across the broader legacy tree",
    "the inherited proof-slice core translation units in src/libslic3r/BoundingBox.cpp, Config.cpp, Point.cpp, and PrintConfig.cpp",
    "tests/libslic3r/test_config.cpp because current Catch SCENARIO macro patterns trigger compiler diagnostics before the bounded clang-tidy checks become signal-rich",
    "GUI, packaging, and larger CTest-only suites outside the migrated proof slice",
]
