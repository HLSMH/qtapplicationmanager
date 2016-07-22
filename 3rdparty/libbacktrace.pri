
load(fix-library-path)

LIBBACKTRACE_PATH = $$PWD/libbacktrace
LIBBACKTRACE_BUILD_PATH = $$shadowed($$LIBBACKTRACE_PATH)

INCLUDEPATH += $$LIBBACKTRACE_PATH
LIBS += $$fixLibraryPath(-L$$LIBBACKTRACE_BUILD_PATH) -lbacktrace

CONFIG *= link_prl
