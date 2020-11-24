VERSION = 0.1.0

PREFIX = /usr
MANPREFIX = $(PREFIX)/share/man

CPPFLAGS := $(CFLAGS) -D_FILE_OFFSET_BITS=64 -D_XOPEN_SOURCE=700 -D_GNU_SOURCE
CFLAGS   := $(CFLAGS) -std=c99 -Wall -Wextra
LDFLAGS  := $(CFLAGS) -s
