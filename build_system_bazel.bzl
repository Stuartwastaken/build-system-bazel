load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_cc",
    sha256 = "d6fd2dd2429e5b354f9e9f8f92dd5046b7a6f2e6d909a6d17d6c7e6be939a0c8",
    strip_prefix = "rules_cc-d6fd2dd2429e5b354f9e9f8f92dd5046b7a6f2e6d909a6d17d6c7e6be939a0c8",
    urls = ["https://github.com/bazelbuild/rules_cc/archive/d6fd2dd2429e5b354f9e9f8f92dd5046b7a6f2e6d909a6d17d6c7e6be939a0c8.tar.gz"],
)

load("@rules_cc//cc:defs.bzl", "cc_import", "cc_library", "cc_binary")


load("@rules_cc//cc:defs.bzl", "cc_library")

config_setting(
    name = "win32",
    values = {"cpu": "x64_windows"},
)

cc_library(
    name = "json-c",
    srcs = glob([
        "src/*.c",
    ]),
    hdrs = glob([
        "include/json/*.h",
    ]),
    copts = [
        "-DJSON_C_DLL",
    ],
    includes = [
        "include",
    ],
    linkopts = select({
        "//conditions:default": [],
        ":win32": ["/DEBUG"],
    }),
)

cc_library(
    name = "tests",
    srcs = glob([
        "tests/*.c",
    ]),
    deps = [
        ":json-c",
    ],
    copts = [
        "-DJSON_C_DLL",
    ],
    includes = [
        "include",
    ],
)

cc_binary(
    name = "distcheck",
    srcs = ["distcheck.c"],
    deps = [
        ":json-c",
        ":tests",
    ],
)
