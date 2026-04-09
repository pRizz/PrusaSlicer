"""Bounded Phase 4 clang-format surface."""

CLANG_FORMAT_TARGETS = [
    "src/PrusaSlicer.cpp",
    "src/CLI/BazelHandoff.cpp",
    "src/libslic3r/BazelConfigCompat.cpp",
    "tests/libslic3r/BazelCatchMain.cpp",
    "tests/libslic3r/test_config.cpp",
    "tests/thumbnails/BazelCatchMain.cpp",
    "tests/thumbnails/test_thumbnails_ini_string.cpp",
    "tests/thumbnails/test_thumbnails_input_string.cpp",
]

CLANG_FORMAT_EXCLUSIONS = [
    "src/libslic3r/BoundingBox.cpp",
    "src/libslic3r/Config.cpp",
    "src/libslic3r/Point.cpp",
    "src/libslic3r/PrintConfig.cpp",
    "tests/fff_print",
    "tests/sla_print",
    "tests/slic3rutils",
    "tests/arrange",
    "the broader GUI and packaging-heavy source tree outside the migrated proof slice",
]
