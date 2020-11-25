# sbase version
VERSION = 0.1.0

# paths
PREFIX = /usr/
MANPREFIX = $(PREFIX)/share/man

CC = cc
AR = ar
RANLIB = ranlib

# for NetBSD add -D_NETBSD_SOURCE
# -lrt might be needed on some systems
CPPFLAGS = -D_FILE_OFFSET_BITS=64 -D_XOPEN_SOURCE=700 -D_GNU_SOURCE
CFLAGS   = -std=c99 -Wall -Wextra -O3 -march=x86-64 -pipe
LDLIBS   = -lcrypt
LDFLAGS  = -s
