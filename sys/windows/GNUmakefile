# NetHack 3.7	GNUmakefile
# Copyright (c) 2022 by Feiyun Wang
#-Copyright (c) 2022 by Michael Allison
# NetHack may be freely redistributed.  See license for details.
#
#==============================================================================
#
#   Win32 Compilers Tested with this GNUmakefile:
#       mingw-w64
#   from:
#       https://sourceforge.net/p/mingw-w64/wiki2/GeneralUsageInstructions/
#           Toolchain for 32 and 64 bit Windows target
#
#==============================================================================
#   This is used for building two versions of NetHack:
#
#   A tty port utilizing the Win32 Console I/O subsystem, Console
#       NetHack.
#
#   A Win32 native port built on the Windows API, Graphical NetHack or
#       NetHackW.
#
#   If you have any questions read the sys/windows/Install.windows file included
#   with the distribution.
#
#==============================================================================
#
# The default make target (so just typing 'mingw32-make').
#

default: package

#---------------------------------------------------------------
# Where do you want the game to be built (which folder)?
# If not present prior to compilation it gets created.
#

GAMEDIR = ../binary

#
#---------------------------------------------------------------
# Do you want to include integration with any sound libraries that work with
# this Makefile?  Add the list below. If you change the list do 'nmake clean'.
#
# There is glue in here for the following: windsound fmod
# Obtaining the 3rd party library, including its .h files, is up to you.
#
# windsound uses built-in Microsoft API's, no 3rd party download is required.

SOUND_LIBRARIES = windsound

#
#---------------------------------------------------------------
# Do you want debug information in the executable?
#

DEBUGINFO = Y

#
#---------------------------------------------------------------
# Required for CRASHREPORT (but doesn't work yet, so off).

CRASHREPORT = N

#
#---------------------------------------------------------------
# Do you have a connection to the internet available that you want
# to utilize for obtaining prerequisite Lua source code and pdcursesmod
# source code. Defaults to Y.

INTERNET_AVAILABLE = Y

#
#---------------------------------------------------------------
# Do you have git commands available and NetHack in a git repository?
#

GIT_AVAILABLE = N

#
#---------------------------------------------------------------
# Do you want to turn on the same gcc warnings as on Unix builds?
#

GCC_EXTRA_WARNINGS = N

#
#===============================================
#======= End of Modification Section ===========
#===============================================
#
################################################
#                                              #
# Nothing below here should have to be changed.#
#                                              #
################################################
#
#==============================================================================

$(info Using $(lastword $(MAKEFILE_LIST)))

SKIP_NETHACKW = N
USE_LUADLL = Y
WANT_LUAC = N

ifndef LUA_VERSION
LUAVER=5.4.6
else
LUAVER=$(LUA_VERSION)
endif

# if GIT=1 is passed on the make command, allow use of git and internet
ifeq "$(GIT)" "1"
INTERNET_AVAILABLE=Y
GIT_AVAILABLE=Y
endif
ifeq "$(git)" "1"
INTERNET_AVAILABLE=Y
GIT_AVAILABLE=Y
endif

PDCURSES=pdcursesmod
PDCURSESFLAGS = -DPDC_WIDE -DPDC_RGB

#
#==============================================================================
# Sanity checks for prerequisite Lua and pdcurses
#
LUA_MAY_PROCEED=N
ADD_CURSES=N
PDCURSES_TOP=

# First, Lua
ifeq "$(INTERNET_AVAILABLE)" "Y"
ifeq "$(GIT_AVAILABLE)" "Y"
LUATOP=../submodules/lua
LUASRC=$(LUATOP)
LUA_MAY_PROCEED=Y
else    # GIT_AVAILABLE
LUATOP = ../lib/lua-$(LUAVER)
LUASRC = $(LUATOP)/src
LUA_MAY_PROCEED=Y
endif   # GIT_AVAILABLE
else    # INTERNET_AVAILABLE not
# The internet is not available for obtaining Lua using either
# method (git or download). Check to see if it is available already, with
# precedence given to ../submodules, then ../lib.
#
ifneq ("$(wildcard ../submodules/lua/lua.h)", "")
LUATOP=../submodules/lua
LUASRC=$(LUATOP)
LUA_MAY_PROCEED=Y
else ifneq ("$(wildcard ../lib/lua-$(LUAVER)/src/lua.h)", "")
LUATOP = ../lib/lua-$(LUAVER)
LUASRC = $(LUATOP)/src
LUA_MAY_PROCEED=Y
else
endif   # Lua sources
ifeq "$(LUA_MAY_PROCEED)" "Y"
$(info No internet connection was authorized in the Makefile,)
$(info but a copy of lua-$(LUAVER) was found in $(LUASRC), so that will be used.)
endif  # LUA_MAY_PROCEED
endif  # INTERNET_AVAILABLE

ifneq "$(LUA_MAY_PROCEED)" "Y"
ifneq "$(INTERNET_AVAILABLE)" "Y"
$(info Your Makefile settings do not allow use of the internet to obtain Lua)
endif  # INTERNET_AVAILABLE
$(info and no copy of Lua was found in either ../submodules/lua or ../lib/lua-$(LUAVER).)
$(info Change your make command line to include:)
$(info     GIT=1)
$(info or modify your Makefile to set the following:)
$(info     INTERNET_AVAILABLE=Y)
$(info     GIT_AVAILABLE=Y)
$(error Stopping because NetHack 3.7 requires Lua for its build.)
endif  # LUA_MAY_PROCEED

# Now, pdcurses
ifeq "$(INTERNET_AVAILABLE)" "Y"
ifeq "$(GIT_AVAILABLE)" "Y"
PDCURSES_TOP=../submodules/$(PDCURSES)
ADD_CURSES=Y
else  # GIT_AVAILABLE
PDCURSES_TOP=../lib/$(PDCURSES)
ADD_CURSES=Y
endif  # GIT_AVAILABLE
else   # INTERNET_AVAILABLE is not Y below
# Your Makefile settings to not allow $(PDCURSES) to be obtained by
# git or by download). Check to see if it is available at one of
# the expected locations already, with precedence given to ../submodules,
# then ../lib.
#
ifneq ("$(wildcard ../submodules/$(PDCURSES)/curses.h)", "")
PDCURSES_TOP=../submodules/$(PDCURSES)
ADD_CURSES=Y
else ifneq ("$(wildcard ../lib/$(PDCURSES)/curses.h)", "")
PDCURSES_TOP=../lib/$(PDCURSES)
ADD_CURSES=Y
endif  # $(PDCURSES) sources available somewhere

ifeq "$(ADD_CURSES)" "Y"
$(info Your Makefile settings do not allow $(PDCURSES) to be obtained by)
$(info git or by download, but a copy of $(PDCURSES) was found in $(PDCURSES_TOP),)
$(info so that will be used.)
endif  # ADD_CURSES == Y
endif  # INTERNET_AVAILABLE

ifneq "$(ADD_CURSES)" "Y"
$(info NetHack 3.7 will be built without support for the curses window-port.)
endif

ifeq "$(INTERNET_AVAILABLE)" "Y"
ifeq "$(GIT_AVAILABLE)" "Y"
GIT_HASH := $(shell echo `git rev-parse --verify HEAD` 2>&1)
GIT_BRANCH := $(shell echo `git rev-parse --abbrev-ref HEAD` 2>&1)
GIT_PREFIX := $(shell echo `git config nethack.substprefix` 2>&1)
ifdef GIT_HASH
GITHASH = -DNETHACK_GIT_SHA=\"$(GIT_HASH)\"
endif
ifdef GIT_BRANCH
GITBRANCH = -DNETHACK_GIT_BRANCH=\"$(GIT_BRANCH)\"
endif
ifdef GIT_PREFIX
GITPREFIX = -DNETHACK_GIT_PREFIX=\"$(GIT_PREFIX)\"
endif
endif
endif

#==============================================================================

#  The version of the game this Makefile was designed for
NETHACK_VERSION="3.7.0"

# A brief version for use in macros
NHV1=$(subst .,,$(NETHACK_VERSION))
NHV=$(subst ",,$(NHV1))

#
#  Source directories.    Makedefs hardcodes these, don't change them.
#

# INCL    - NetHack include files
# DAT     - NetHack data files
# DOC     - NetHack documentation files
# UTIL    - Utility source
# SRC     - Main source
# SSYS    - Shared system files
# MSWSYS  - mswin specific files
# TTY     - window port files (tty)
# MSWIN   - window port files (win32)
# WCURSES - window port files (curses)
# WCHAIN  - window port files (chain)
# WSHR    - Tile support files
# SNDSYS  - sound support files for win32
# QT      - QT window support files

INCL    =../include
DAT     =../dat
DOC     =../doc
UTIL    =../util
SRC     =../src
SSYS    =../sys/share
SNDSYS  =../sound/windsound
MSWSYS  =../sys/windows
TTY     =../win/tty
MSWIN   =../win/win32
WCHAIN  =../win/chain
WCURSES =../win/curses
WSHR    =../win/share
QT      =../win/Qt
SNDWAVDIR = ../sound/wav
BinDir = ../binary
PkgDir = ../package

#
#  Object directory.
#

OBJ = o

#
# Shorten up the location for some files
#

O  = $(OBJ)/

U  = $(UTIL)/

# To store all the level files,
# help files, etc. in a single library file.
# USE_DLB = Y is left uncommented

USE_DLB = Y

#==========================================
#==========================================
# Setting up the compiler and linker
# macros. All builds include the base ones.
#==========================================
#==========================================

ifdef CI_COMPILER
cc = gcc -c
ld = gcc
else
cc = gcc -c
ld = gcc
endif
ifeq "$(MSYSTEM)" "MINGW32"
rc = windres --target=pe-i386
else # MINGW64
rc = windres --target=pe-x86-64
endif

ifeq "$(MSYSTEM)" "MINGW32"
arch = x86
else # MINGW64
arch = x64
endif

#
# Handle user settings
#
CFLAGS = -mms-bitfields -I../include -I../sys/windows
LDFLAGS =
ifeq "$(DEBUGINFO)" "Y"
CFLAGS += -g -D_DEBUG
else
CFLAGS += -DNDEBUG
LDFLAGS += -s
endif

ifeq "$(USE_DLB)" "Y"
DLBFLG = -DDLB
else
DLBFLG =
endif


ifeq "$(GCC_EXTRA_WARNINGS)" "Y"
#
# These match the warnings enabled on the linux.370 and macOS.370 hints builds
#
CFLAGSXTRA = -Wall -Wextra -Wreturn-type -Wunused -Wswitch -Wshadow \
	     -Wwrite-strings -pedantic -Wmissing-declarations \
	     -Wunreachable-code -Wimplicit \
	     -Wimplicit-function-declaration -Wimplicit-int \
	     -Wmissing-prototypes -Wold-style-definition \
	     -Wstrict-prototypes -Wnonnull -Wformat-overflow \
	     -Wmissing-parameter-type -Wimplicit-fallthrough \
	     -Wno-cast-function-type -Wno-format

CPPFLAGSXTRA = -Wall -Wextra -Wno-missing-field-initializers -Wreturn-type \
		-Wunused -Wformat -Wswitch -Wshadow -Wwrite-strings -pedantic \
		-Wmissing-declarations -Wformat-nonliteral -Wunreachable-code
endif

COMMONDEF = -DWIN32 -DWINVER=0x0601 -D_WIN32_WINNT=0x0601
DLLDEF = $(COMMONDEF) -D_WINDOWS -D_USRDLL -D_WINDLL
CONSOLEDEF = $(COMMONDEF) -D_CONSOLE

# To build util targets
CFLAGSU = $(CFLAGS) $(CONSOLEDEF) $(DLBFLG)

LIBS = -lcomctl32 -lgdi32 -lole32 -lshell32 -luserenv -luuid -lwinmm -lbcrypt

$(GAMEDIR):
	@mkdir -p $@

$(OBJ):
	@mkdir -p $@

CLEAN_DIR = $(GAMEDIR) $(OBJ)

#=================================================================
# LUA library
# Source from http://www.lua.org/ftp/lua-5.4.6.tar.gz
#=================================================================

OLUA = $(O)lua
LUAOBJS = $(addprefix $(OLUA)/, $(addsuffix .o, lapi lauxlib lbaselib lcode lcorolib lctype \
	  ldblib ldebug ldo ldump lfunc lgc linit liolib llex lmathlib lmem \
	  loadlib lobject lopcodes loslib lparser lstate lstring lstrlib ltable ltablib ltm \
	  lundump lutf8lib lvm lzio))
LUADLL = $(GAMEDIR)/lua-$(LUAVER).dll
LUAIMP = $(OLUA)/lua-$(LUAVER).dll.a
ULUADLL = $(U)$(notdir $(LUADLL))
LUASTATIC = $(OLUA)/lua-$(LUAVER).a
LUATARGETS = $(U)lua.exe

ifeq "$(USE_LUADLL)" "Y"
LUALIB = $(LUAIMP)
LUATARGETS += $(LUADLL) $(ULUADLL) $(LUAIMP)
else
LUALIB = $(LUASTATIC)
LUATARGETS += $(LUASTATIC)
endif

ifeq "$(WANT_LUAC)" "Y"
LUATARGETS += $(U)luac.exe
endif

lua: $(LUATARGETS)

$(U)lua.exe: $(OLUA)/lua.o $(LUALIB)
	$(ld) $(LDFLAGS) $^ -o$@

$(LUADLL): $(ULUADLL)
	cp $< $@

$(ULUADLL) $(LUAIMP): $(LUAOBJS) | $(OLUA)
	$(ld) $(LDFLAGS) -fPIC -shared -Wl,--export-all-symbols -Wl,--add-stdcall-alias \
		-Wl,--out-implib=$(LUAIMP) $^ -o$(ULUADLL)

$(LUASTATIC): $(LUAOBJS) | $(OLUA) 
	ar rcs $@ $^

$(OLUA)/%.o: $(LUASRC)/%.c | $(OLUA)
	$(cc) $(CFLAGS) $< -o$@

$(U)luac.exe: $(OLUA)/luac.o $(LUALIB)
	$(ld) $(LDFLAGS) $^ -o$@

$(OLUA):
	@mkdir -p $@

CLEAN_DIR += $(OLUA)
CLEAN_FILE += $(LUATARGETS) $(LUAOBJS) $(OLUA)/lua.o $(OLUA)/luac.o

#==========================================
# nhlua.h
#==========================================
NHLUAH = $(INCL)/nhlua.h

$(NHLUAH):
	echo "/* nhlua.h - generated by GNUmakefile */" > $@
	@echo "#include \"$(LUASRC)/lua.h\"" >> $@
	@echo "LUA_API int (lua_error) (lua_State *L) NORETURN;" >>$@
	@echo "#include \"$(LUASRC)/lualib.h\"" >> $@
	@echo "#include \"$(LUASRC)/lauxlib.h\"" >> $@
	@echo "/*nhlua.h*/" >> $@

CLEAN_FILE += $(NHLUAH)

#===========================================
# Lua level files, dungeon file, quest files
#===========================================

LUALIST = air Arc-fila Arc-filb Arc-goal Arc-loca Arc-strt \
	asmodeus astral baalz Bar-fila Bar-filb Bar-goal \
	Bar-loca Bar-strt bigrm-1 bigrm-10 bigrm-11 bigrm-2 \
	bigrm-12 \
	bigrm-3 bigrm-4 bigrm-5 bigrm-6 bigrm-7 bigrm-8 \
	bigrm-9 castle Cav-fila Cav-filb Cav-goal Cav-loca \
	Cav-strt dungeon earth fakewiz1 fakewiz2 fire \
	Hea-fila Hea-filb Hea-goal Hea-loca Hea-strt hellfill \
	juiblex Kni-fila Kni-filb Kni-goal Kni-loca Kni-strt \
	knox medusa-1 medusa-2 medusa-3 medusa-4 minefill \
	minend-1 minend-2 minend-3 minetn-1 minetn-2 minetn-3 \
	minetn-4 minetn-5 minetn-6 minetn-7 Mon-fila Mon-filb \
	Mon-goal Mon-loca Mon-strt nhcore nhlib oracle \
	orcus Pri-fila Pri-filb Pri-goal Pri-loca Pri-strt \
	quest Ran-fila Ran-filb Ran-goal Ran-loca Ran-strt \
	Rog-fila Rog-filb Rog-goal Rog-loca Rog-strt Sam-fila \
	Sam-filb Sam-goal Sam-loca Sam-strt sanctum soko1-1 \
	soko1-2 soko2-1 soko2-2 soko3-1 soko3-2 soko4-1 \
	soko4-2 themerms Tou-fila Tou-filb Tou-goal Tou-loca \
	Tou-strt tower1 tower2 tower3 Val-fila Val-filb \
	Val-goal Val-loca Val-strt valley water Wiz-fila \
	Wiz-filb Wiz-goal Wiz-loca Wiz-strt wizard1 wizard2 \
	wizard3 tut-1 tut-2

LUAFILES = $(addprefix $(DAT)/, $(addsuffix .lua, $(LUALIST)))

#==========================================
# Hacklib
#==========================================
HACKLIBLIST = hacklib
HACKLIBSRC = $(addprefix ../src/,$(addsuffix .c, $(HACKLIBLIST)))
HL = $(O)hacklib
HLHACKLIB = $(HL)/hacklib.a
HLHACKLIBOBJS = $(addprefix $(HL)/, $(addsuffix .o, $(HACKLIBLIST)))
HLTARGETS = $(HLHACKLIB) $(HLHACKLIBOBJS)

$(HL)/hacklib.a: $(HLHACKLIBOBJS)
	ar rcs $@ $^

$(HL)/hacklib.o: $(HACKLIBSRC) | $(HL)	

$(HL)/%.o: $(SRC)/%.c | $(HL)
	$(cc) $(CFLAGSU) $< -o$@
$(HL):
	@mkdir -p $@

CLEAN_DIR += $(HL)
CLEAN_FILE += $(HLTARGETS)

#==========================================
# Makedefs
#==========================================
OM = $(O)makedefs
MOBJS = $(addprefix $(OM)/, alloc.o date.o makedefs.o monst.o objects.o panic.o)
MTARGETS = $(U)makedefs.exe

makedefs: $(MTARGETS)

$(U)makedefs.exe: $(MOBJS) $(HLHACKLIB)
	$(ld) $(LDFLAGS) $^ -o$@

$(OM)/%.o: $(SRC)/%.c $(NHLUAH) | $(OM)
	$(cc) $(CFLAGSU) -DENUM_PM $< -o$@

$(OM)/%.o: $(U)%.c $(NHLUAH) | $(OM)
	$(cc) $(CFLAGSU) -DENUM_PM $< -o$@

$(OM):
	@mkdir -p $@

CLEAN_DIR += $(OM)
CLEAN_FILE += $(MTARGETS) $(MOBJS)

#==========================================
# Recover
#==========================================
OR = $(OBJ)
ROBJS = $(OR)/recover.o $(OR)/rversion.o
RTARGETS = $(GAMEDIR)/recover.txt $(GAMEDIR)/recover.exe

recover: $(RTARGETS)

$(GAMEDIR)/recover.txt: $(DOC)/recover.txt | $(GAMEDIR)
	cp $< $@

$(GAMEDIR)/recover.exe: $(ROBJS) $(HLHACKLIB) | $(GAMEDIR)
	$(ld) $(LDFLAGS) $^ -o$@

$(OR)/recover.o: $(U)recover.c | $(OR)
	$(cc) $(CFLAGSU) $< -o$@
$(OR)/rversion.o: $(SRC)/version.c | $(OR)
	$(cc) $(CFLAGSU) -DMINIMAL_FOR_RECOVER $< -o$@

# $(OR):
#	@mkdir -p $@

CLEAN_FILE += $(RTARGETS) $(ROBJS)

#==========================================
# PDCurses
#==========================================
ifeq "$(ADD_CURSES)" "Y"
PDCCOMMONSRC = addch addchstr addstr attr beep bkgd border clear \
	color debug delch deleteln getch getstr getyx inch \
	inchstr initscr inopts insch insstr kernel keyname \
	mouse move outopts overlay pad panel printw refresh \
	scanw scr_dump scroll slk termattr touch util window
PDCCOMMONOBJS = $(addsuffix .o, $(PDCCOMMONSRC))

OP = $(O)$(PDCURSES)
PDCOBJS = $(addprefix $(OP)/, $(PDCCOMMONOBJS) \
	  pdcclip.o pdcdisp.o pdcgetsc.o pdckbd.o pdcscrn.o pdcsetsc.o pdcutil.o)
PDCSRC = $(PDCURSES_TOP)/pdcurses
PDCWINCON = $(PDCURSES_TOP)/wincon
PDCINCL = -I$(PDCURSES_TOP) -I$(PDCSRC)
PDCLIB = $(O)$(PDCURSES).a
PDCDEP = $(PDCURSES_TOP)/curses.h

$(PDCURSES): $(PDCLIB)

$(PDCLIB): $(PDCOBJS)
	ar rcs $@ $^

$(OP)/%.o: $(PDCSRC)/%.c | $(OP)
	$(cc) $(CFLAGS) $(PDCURSESFLAGS) $(PDCINCL) -D_LIB $< -o$@

$(OP)/%.o: $(PDCWINCON)/%.c | $(OP)
	$(cc) $(CFLAGS) $(PDCURSESFLAGS) $(PDCINCL) -I$(PDCWINCON) -D_LIB $< -o$@

$(OP):
	@mkdir -p $@

CLEAN_DIR += $(OP)
CLEAN_FILE += $(PDCLIB) $(PDCOBJS)

ifneq ("$(wildcard $(PDCURSES_TOP)/wingui/pdcwin.h)", "")
# $(PDCURSES) in use; enable Curses graphics on NetHackW
OPW = $(O)$(PDCURSES)w
PDCWOBJS = $(addprefix $(OPW)/, $(PDCCOMMONOBJS) \
	  pdcclip.o pdcdisp.o pdcgetsc.o pdckbd.o pdcscrn.o pdcsetsc.o pdcutil.o)
PDCWINGUI = $(PDCURSES_TOP)/wingui
PDCWLIB = $(O)$(PDCURSES)w.a

$(PDCURSES)w: $(PDCWLIB)

$(PDCWLIB): $(PDCWOBJS)
	ar rcs $@ $^

$(OPW)/%.o: $(PDCSRC)/%.c | $(OPW)
	$(cc) $(CFLAGS) $(PDCURSESFLAGS) $(PDCINCL) -D_LIB $< -o$@

$(OPW)/%.o: $(PDCWINGUI)/%.c | $(OPW)
	$(cc) $(CFLAGS) $(PDCURSESFLAGS) $(PDCINCL) -I$(PDCWINGUI) -D_LIB $< -o$@

$(OPW):
	@mkdir -p $@

CLEAN_DIR += $(OPW)
CLEAN_FILE += $(PDCWLIB) $(PDCWOBJS)
endif

endif

#==========================================
# tile2bmp
#==========================================
OT = $(O)tile2bmp
TOBJS = $(addprefix $(OT)/, drawing.o monst.o objects.o tile2bmp.o tiletext.o tiletxt.o)
TTARGETS = $(U)tile2bmp.exe

tile2bmp: $(TTARGETS)

$(U)tile2bmp.exe: $(TOBJS) $(HLHACKLIB)
	$(ld) $(LDFLAGS) $(HLHACKLIB) $^ -o$@

$(OT)/tiletxt.o: $(WSHR)/tilemap.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) -DTILETEXT $< -o$@

$(OT)/%.o: $(WSHR)/%.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) $< -o$@

$(OT)/%.o: $(SRC)/%.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) $< -o$@

$(OT):
	@mkdir -p $@

CLEAN_DIR += $(OT)
CLEAN_FILE += $(TTARGETS) $(TOBJS)

#==========================================
# Optional Tile Utilities
#==========================================
TEXT_IO = $(addprefix $(OT)/, drawing.o monst.o objects.o tiletext.o tiletxt.o)
TUCOMMON = $(OT)/alloc.o $(OT)/panic.o
TUOBJS = $(TUCOMMON) $(TEXT_IO)

T32OBJS = $(OT)/tilete32.o $(OT)/tiletx32.o
TEXT_IO32 = $(addprefix $(OT)/, drawing.o monst.o objects.o) $(T32OBJS)
TU32OBJS = $(TUCOMMON) $(TEXT_IO32)

GIFOBJ = $(OT)/gifread.o
GIF32OBJ = $(OT)/gifrd32.o
PPMOBJ = $(OT)/ppmwrite.o
BMP32OBJ = $(OT)/til2bm32.o
TILEFILES32 = $(addprefix $(WSHR)/, mon32.txt obj32.txt oth32.txt)
TUTARGETS = $(U)gif2txt.exe $(U)gif2tx32.exe $(U)txt2ppm.exe $(U)til2bm32.exe

tileutil: $(TUTARGETS)

$(U)gif2txt.exe: $(GIFOBJ) $(TUOBJS)
	$(ld) $(LDFLAGS) $^ -o$@

$(U)gif2tx32.exe: $(GIF32OBJ) $(TU32OBJS)
	$(ld) $(LDFLAGS) $^ -o$@

$(U)txt2ppm.exe: $(PPMOBJ) $(TUOBJS)
	$(ld) $(LDFLAGS) $^ -o$@

$(U)til2bm32.exe: $(BMP32OBJ) $(TEXT_IO32)
	$(ld) $(LDFLAGS) $^ -o$@

$(OT)/tilete32.o: $(WSHR)/tiletext.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) -DTILE_X=32 -DTILE_Y=32 $< -o$@

$(OT)/tiletx32.o: $(WSHR)/tilemap.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) -DTILETEXT -DTILE_X=32 -DTILE_Y=32 $< -o$@

$(GIF32OBJ): $(WSHR)/gifread.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) -DTILE_X=32 -DTILE_Y=32 $< -o$@

$(BMP32OBJ): $(WSHR)/tile2bmp.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) -DTILE_X=32 -DTILE_Y=32 $< -o$@

$(OT)/panic.o: $(UTIL)/panic.c $(NHLUAH) | $(OT)
	$(cc) $(CFLAGSU) $< -o$@

$(MSWIN)/tiles32.bmp: $(U)til2bm32.exe $(TILEFILES32)
	$< $@

CLEAN_FILE += $(TUTARGETS) $(GIFOBJ) $(GIF32OBJ) $(PPMOBJ) $(BMP32OBJ) \
	      $(T32OBJS) $(TUCOMMON)

#==========================================
# tilemap
#==========================================
OTM = $(OBJ)/tilemap
TMOBJS = $(addprefix $(OTM)/, drawing.o monst.o objects.o tilemap.o)
TMTARGETS = $(SRC)/tile.c $(U)tilemap.exe

tilemap: $(SRC)/tile.c

$(SRC)/tile.c: $(U)tilemap.exe
	$<

$(U)tilemap.exe: $(TMOBJS) $(HLHACKLIB)
	$(ld) $(LDFLAGS) $(HLHACKLIB) $^ -o$@

$(OTM)/tilemap.o: $(WSHR)/tilemap.c $(NHLUAH) | $(OTM)
	$(cc) $(CFLAGSU) $< -o$@

$(OTM)/%.o: $(SRC)/%.c $(NHLUAH) | $(OTM)
	$(cc) $(CFLAGSU) $< -o$@

$(OTM):
	@mkdir -p $@

CLEAN_DIR += $(OTM)
# tilemap.exe will create tilemappings.lst
CLEAN_FILE += $(TMTARGETS) $(TMOBJS) $(SRC)/tilemappings.lst

#==========================================
# uudecode
#==========================================
OU = $(OBJ)
UOBJS = $(OU)/uudecode.o
UTARGETS = $(U)uudecode.exe $(MSWIN)/NetHack.ico

uudecode: $(UTARGETS)

$(U)uudecode.exe: $(UOBJS)
	$(ld) $(LDFLAGS) $^ -o$@

$(OU)/uudecode.o: $(SSYS)/uudecode.c | $(OU)
	$(cc) $(CFLAGS) $(CONSOLEDEF) $< -o$@

# $(OU):
#	@mkdir -p $@

$(MSWIN)/NetHack.ico: $(U)uudecode.exe $(MSWSYS)/nhico.uu
	$^
	mv nethack.ico $@

CLEAN_FILE += $(UTARGETS) $(UOBJS)

#==========================================
# Data librarian
#==========================================
ODLB = $(O)dlb
DLBOBJS = $(addprefix $(ODLB)/, alloc.o dlb.o dlb_main.o panic.o)
DAT_CLEAN = $(addprefix $(DAT)/, data oracles options porthelp rumors engrave epitaph bogusmon)
DAT_NOCLEAN = $(addprefix $(DAT)/, help hh cmdhelp keyhelp history opthelp optmenu \
	      wizhelp license engrave epitaph bogusmon tribute)
DLBLST = $(DAT)/dlb.lst
DLB = $(GAMEDIR)/nhdat$(NHV)
DTARGETS = $(U)dlb.exe $(DAT_CLEAN) $(DLBLST) $(DLB)

dlb: $(DTARGETS)

$(U)dlb.exe: $(DLBOBJS) $(HLHACKLIB)
	$(ld) $(LDFLAGS) $(HLHACKLIB) $^ -o$@

$(ODLB)/%.o: $(SRC)/%.c $(NHLUAH) | $(ODLB)
	$(cc) $(CFLAGSU) $< -o$@

$(ODLB)/%.o: $(U)%.c $(NHLUAH) | $(ODLB)
	$(cc) $(CFLAGSU) $< -o$@

$(ODLB):
	@mkdir -p $@

$(DAT)/data: $(U)makedefs.exe $(DAT)/data.base
	$< -d

$(DAT)/oracles: $(U)makedefs.exe $(DAT)/oracles.txt
	$< -h

$(DAT)/options $(INCL)/date.h: $(U)makedefs.exe
	$< -v

$(DAT)/porthelp: $(MSWSYS)/porthelp
	cp $< $@

$(DAT)/rumors: $(U)makedefs.exe $(DAT)/rumors.tru $(DAT)/rumors.fal
	$< -r

$(DAT)/engrave: $(DAT)/bogusmon

$(DAT)/epitaph: $(DAT)/bogusmon

$(DAT)/bogusmon: $(U)makedefs.exe $(DAT)/bogusmon.txt $(DAT)/engrave.txt $(DAT)/epitaph.txt
	$< -s

$(DLBLST): $(LUAFILES) | $(DAT_CLEAN) $(DAT_NOCLEAN)
	echo data > $(DLBLST)
	echo oracles >> $(DLBLST)
	echo options >> $(DLBLST)
	if [ -f $(DAT)/ttyoptions ] ; then echo ttyoptions >> $(DLBLST) ; fi
	if [ -f $(DAT)/guioptions ] ; then echo guioptions >> $(DLBLST) ; fi
	echo porthelp >> $(DLBLST)
	echo rumors >> $(DLBLST)
	echo help >> $(DLBLST)
	echo hh >> $(DLBLST)
	echo cmdhelp >> $(DLBLST)
	echo keyhelp >> $(DLBLST)
	echo history >> $(DLBLST)
	echo opthelp >> $(DLBLST)
	echo optmenu >> $(DLBLST)
	echo wizhelp >> $(DLBLST)
	echo license >> $(DLBLST)
	echo engrave >> $(DLBLST)
	echo epitaph >> $(DLBLST)
	echo bogusmon >> $(DLBLST)
	echo tribute >> $(DLBLST)
	cd $(DAT) ; ls -1 *.lua >> $(DLBLST)

$(DLB): $(U)dlb.exe $(DLBLST) | $(GAMEDIR)
	$(U)dlb.exe CcIf $(dir $(DLBLST)) $(notdir $(DLBLST)) $(SRC)/nhdat
	mv $(SRC)/nhdat$(NHV) $@

CLEAN_DIR += $(ODLB)
CLEAN_FILE += $(DTARGETS) $(DLBOBJS) $(INCL)/date.h

#============================================
# Fetching other source files that are needed
#============================================

ifeq "$(INTERNET_AVAILABLE)" "Y"
ifeq "$(GIT_AVAILABLE)" "Y"

fetchlua:
	@if [ ! -f $(LUASRC)/lua.h ] ; then \
	git submodule init ../submodules/lua && \
	git submodule update ../submodules/lua ; fi
#	git submodule update --remote ../submodules/lua ; fi
fetchpdcurses:
	@if [ ! -f $(PDCURSES_TOP)/curses.h ] ; then \
	git submodule init ../submodules/$(PDCURSES) && \
	git submodule update ../submodules/$(PDCURSES) ; fi
#	git submodule update --remote ../submodules/$(PDCURSES) ; fi
else  # GIT_AVAILABLE no
CURLLUASRC=http://www.lua.org/ftp/lua-5.4.6.tar.gz
CURLLUADST=lua-5.4.6.tar.gz

CURLPDCSRC=https://github.com/Bill-Gray/PDCursesMod/archive/refs/tags/v4.4.0.zip
CURLPDCDST=$(PDCURSES).zip

fetchlua:
	@if [ ! -f $(LUASRC)/lua.h ] ; then \
	mkdir -p ../lib ; \
	cd ../lib ; \
	curl -L $(CURLLUASRC) -o $(CURLLUADST) ; \
	/c/Windows/System32/tar -xvf $(CURLLUADST) ; \
	cd ../src ;  \
	fi
fetchpdcurses:
	mkdir -p ../lib
	@if [ ! -f $(PDCURSES_TOP)/curses.h ] ; then \
	cd ../lib ; \
	curl -L $(CURLPDCSRC) -o $(CURLPDCDST) ; \
	mkdir -p $(PDCURSES) ; \
	/c/Windows/System32/tar -C $(PDCURSES) --strip-components=1 -xvf $(CURLPDCDST) ; \
	cd ../src ; \
	fi
endif  # GIT_AVAILABLE
endif  # INTERNET_AVAILABLE

#==========================================
# Soundlib Choices
#==========================================

SNDLIBCHOICES = $(strip $(SOUND_LIBRARIES))

#
# windsound
#
WINDSOUND = $(findstring windsound, $(SNDLIBCHOICES))
ifeq "$(WINDSOUND)" "windsound"
$(info Including windsound integration)
SOUND_WINDSOUND=Y
HAVE_SOUNDLIB=Y
NEED_USERSOUNDS=Y
NEED_SEAUTOMAP=Y
NEED_WAV=Y
#SOUNDLIBINCL +=
SOUNDLIBDEFS += -DSND_LIB_WINDSOUND
SOUNDLIBOBJS += windsound
#WINDSOUNDLIBDIR =
#SOUNDLIBLIBS +=
#WINDSOUNDLIBDLL =
#GAMEDIRDLLS +=
endif

#
# fmod
#
FMOD = $(findstring fmod, $(SNDLIBCHOICES))
ifeq "$(FMOD)" "fmod"
$(info Including fmod integration)
SOUND_FMOD=Y
HAVE_SOUNDLIB=Y
NEED_USERSOUNDS=Y
NEED_SEAUTOMAP=Y
NEED_WAV=Y
FMODROOT = ../lib/fmod/api/core
SOUNDLIBINCL += -I$(FMODROOT)/inc
SOUNDLIBDEFS += -DSND_LIB_FMOD
SOUNDLIBOBJS += fmod
FMODLIBDIR = $(FMODROOT)/lib/$(arch)
ifeq "$(arch)" "x86"
SOUNDLIBLIBS += -L $(FMODLIBDIR)
FMODLIBDLL = fmod_vc.dll
SOUNDLIBLIBS += -lfmod
else
SOUNDLIBLIBS += -L $(FMODLIBDIR)
FMODLIBDLL = fmod_vc.dll
SOUNDLIBLIBS += $(FMODLIBDIR)/$(FMODLIBDLL)
endif
FMODDIR = ../sound/fmod
GAMEDIRDLLS += $(GAMEDIR)/$(FMODLIBDLL)
ifeq "$(arch)" "x86"
FMODLINKLIB = $(FMODLIBDIR)/fmod_vc.lib
else
#x64 mingw32-x64 builds supposedly can link right with the DLL, no import lib
FMODLINKLIB = $(FMODLIBDIR)/$(FMODLIBDLL)
endif
$(info ---------------------------------------------------------------------)
$(info ** NOTES for fmod sound library integration **)
$(info For fmod integration, this Makefile expects:)
$(info fmod include directory    : $(FMODROOT)/inc)
$(info fmod library directory    : $(FMODLIBDIR))
$(info fmod library to link with : $(FMODLINKLIB))
$(info fmod library dll          : $(FMODLIBDIR)/$(FMODLIBDLL))
$(info ---------------------------------------------------------------------)
FMOD_MISSING=
ifeq (,$(wildcard $(FMODROOT)/inc))
FMOD_MISSING += $(FMODROOT)\inc
$(info Error: missing $(FMODROOT)/inc)
endif
ifeq (,$(wildcard $(FMODLIBDIR)))
FMOD_MISSING += $(FMODLIBDIR)
$(info Error: missing $(FMODLIBDIR))
endif
ifeq (,$(wildcard $(FMODLINKLIB)))
FMOD_MISSING += $(FMODLINKLIB)
$(info Error: missing $(FMODLINKLIB))
endif
ifeq (,$(wildcard $(FMODLIBDIR)/$(FMODLIBDLL)))
FMOD_MISSING += $(FMODLIBDIR)/$(FMODLIBDLL)
$(info Error: missing $(FMODLIBDIR)/$(FMODLIBDLL))
endif
ifneq "$(FMOD_MISSING)" ""
$(error Error: Cannot proceed with fmod integration included)
endif
endif

#==========================================
# Soundlib Support
#==========================================

WAVLIST = se_squeak_A se_squeak_B se_squeak_B_flat se_squeak_C \
	se_squeak_D se_squeak_D_flat se_squeak_E \
	se_squeak_E_flat se_squeak_F se_squeak_F_sharp \
	se_squeak_G se_squeak_G_sharp sound_Bell sound_Bugle_A \
	sound_Bugle_B sound_Bugle_C sound_Bugle_D sound_Bugle_E \
	sound_Bugle_F sound_Bugle_G sound_Drum_Of_Earthquake \
	sound_Fire_Horn sound_Frost_Horn sound_Leather_Drum \
	sound_Magic_Harp_A sound_Magic_Harp_B sound_Magic_Harp_C \
	sound_Magic_Harp_D sound_Magic_Harp_E sound_Magic_Harp_F \
	sound_Magic_Harp_G sound_Magic_Flute_A sound_Magic_Flute_B \
	sound_Magic_Flute_C sound_Magic_Flute_D sound_Magic_Flute_E \
	sound_Magic_Flute_F sound_Magic_Flute_G sound_Tooled_Horn_A \
	sound_Tooled_Horn_B sound_Tooled_Horn_C sound_Tooled_Horn_D \
	sound_Tooled_Horn_E sound_Tooled_Horn_F sound_Tooled_Horn_G \
	sound_Wooden_Flute_A sound_Wooden_Flute_B sound_Wooden_Flute_C \
	sound_Wooden_Flute_D sound_Wooden_Flute_E \
	sound_Wooden_Flute_F sound_Wooden_Flute_G \
	sound_Wooden_Harp_A sound_Wooden_Harp_B \
	sound_Wooden_Harp_C sound_Wooden_Harp_D \
	sound_Wooden_Harp_E sound_Wooden_Harp_F \
	sound_Wooden_Harp_G sa2_xplevelup sa2_xpleveldown

WAVS = $(addprefix $(SNDWAVDIR)/, $(addsuffix .wav, $(WAVLIST)))

ifeq "$(HAVE_SOUNDLIB)" "Y"
ifeq "$(NEED_USERSOUNDS)" "Y"
SOUNDLIBDEFS += -DUSER_SOUNDS
endif
ifeq "$(NEED_SEAUTOMAP)" "Y"
SOUNDLIBDEFS += -DSND_SOUNDEFFECTS_AUTOMAP
endif
ifeq "$(NEED_WAV)" "Y"
$(info Built-in sound file integration included)
#RCFLAGS = --include-dir=$(SNDWAVDIR) --define RCWAV
WAV = $(WAVS)
endif   # NEED_WAV
else
$(info No soundlib integration)
endif   # HAVE_SOUNDLIB

#==========================================
# nethackw
#==========================================
COREOBJS = $(addsuffix .o, allmain alloc apply artifact attrib ball bones botl \
	   calendar cfgfiles cmd coloratt cppregex \
	   dbridge decl detect dig display dlb do do_name do_wear \
	   dog dogmove dokick dothrow drawing dungeon \
	   eat end engrave exper explode extralev files fountain \
	   getpos glyphs hack insight invent isaac64 light lock \
	   mail makemon mcastu mdlib mhitm mhitu minion mklev mkmap mkmaze mkobj mkroom \
	   mon mondata monmove monst mplayer mthrowu muse music \
	   nhlobj nhlsel nhlua windsound o_init objects objnam options \
	   pager pickup pline polyself potion pray priest quest questpgr \
	   random read rect region report restore rip rnd role rumors \
	   safeproc save sfbase sfstruct shk shknam sit selvar sounds sp_lev \
	   spell stairs steal steed strutil \
	   symbols sys teleport timeout topten track trap u_init uhitm utf8map \
	   vault version vision weapon were wield windmain windows windsys wizard \
	   wizcmds worm worn write zap $(SOUNDLIBOBJS))

CFLAGSW = $(CFLAGS) $(CFLAGSXTRA) $(SOUNDLIBINCL) $(COMMONDEF) $(DLBFLG) -DTILES -D_WINDOWS -DMSWIN_GRAPHICS -DSAFEPROCS -DNOTTYGRAPHICS $(SOUNDLIBDEFS)
CPPFLAGSW = $(CFLAGS) $(CPPFLAGSXTRA) $(COMMONDEF) $(DLBFLG) -DTILES -D_WINDOWS -DMSWIN_GRAPHICS -DSAFEPROCS -DNOTTYGRAPHICS $(SOUNDLIBDEFS)

ONHW = $(O)nethackw
NHWONLY = $(addsuffix .o, mhaskyn mhdlg mhfont mhinput mhmain mhmap mhmenu \
	  mhmsgwnd mhrip mhsplash mhstatus mhtext mswproc tile NetHackW win10)
NHWOBJS = $(addprefix $(ONHW)/, $(COREOBJS) $(NHWONLY))
DATEW_O  = $(addsuffix .o, $(addprefix $(ONHW)/, date))
TILEFILES = $(addprefix $(WSHR)/, monsters.txt objects.txt other.txt)
BMPS = $(addprefix $(MSWIN)/, $(addsuffix .bmp, mnsel mnselcnt mnunsel petmark pilemark rip splash tiles))
NHWRES = $(ONHW)/winres.o
NHWTARGETS = $(GAMEDIR)/NetHackW.exe

ifneq "$(PDCWINGUI)" ""
CFLAGSW += $(NHCURSESFLAGS)
NHWONLY += $(addsuffix .o, cursdial cursinit cursinvt cursmain cursmesg cursmisc cursstat curswins guitty)
endif

# uncomment for WINCHAIN
#COREOBJS += $(addsuffix .o, wc_chainin wc_chainout wc_trace)

# XXX mess for testing libbacktrace
ifeq "$(CRASHREPORT)" "Y"
CFLAGS += -I/mingw64/include -g -static -gdwarf
LIBS += -L/mingw64/lib -lbacktrace
endif

nethackw: $(NHWTARGETS)

$(GAMEDIR)/NetHackW.exe: $(NHWOBJS) $(NHWRES) $(DATEW_O) \
			 $(LUALIB) $(HLHACKLIB) $(PDCWLIB) | $(GAMEDIR)
	$(ld) $(LDFLAGS) -mwindows $^ $(HLHACKLIB) $(LIBS) -static -lstdc++ \
		$(SOUNDLIBLIBS) -o$@

$(ONHW)/%.o: $(SRC)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@

#       In NetHack 3.7, date.c must be recompiled after any other file is compiled,
#       otherwise the game internal build timestamp (and potentially git hash)
#       will not be accurate.
#       Therefore, date must not be included in COREOBJS (and by extension
#       NHWOBJS, NHWONLY). That allows those to be listed as explicit dependencies
#       to ensure that date.c is always recompiled again after anything else that
#       was just recompiled. date.h is not used in the build of NetHack 3.7.
#
$(ONHW)/date.o: $(SRC)/date.c $(NHWOBJS) | $(ONHW)
	$(cc) $(CFLAGSW) $(GITHASH) $(GITBRANCH) $(GITPREFIX) $< -o$@

$(ONHW)/cppregex.o: $(SSYS)/cppregex.cpp $(NHLUAH) | $(ONHW)
	$(cc) $(CPPFLAGSW) $< -o$@

$(ONHW)/%.o: $(SSYS)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@

ifeq "$(SOUND_WINDSOUND)" "Y"
$(ONHW)/%.o: ../sound/windsound/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@
endif

ifeq "$(SOUND_FMOD)" "Y"
$(ONHW)/%.o: ../sound/fmod/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@
endif

$(ONHW)/%.o: $(MSWSYS)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@

$(ONHW)/%.o: $(MSWIN)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@

$(ONHW)/%.o: $(WCHAIN)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@

$(ONHW)/%.o: $(WSHR)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $< -o$@

$(ONHW)/%.o: $(WCURSES)/%.c $(NHLUAH) | $(ONHW)
	$(cc) $(CFLAGSW) $(PDCINCL) $< -o$@

$(NHWRES): $(MSWIN)/NetHackW.rc $(MSWIN)/NetHackW.exe.manifest \
		$(BMPS) $(WAV) $(MSWIN)/NetHack.ico | $(ONHW)
	$(rc) --include-dir=$(MSWIN) $(RCFLAGS) -DVIA_MAKE --input=$< -o$@

$(MSWIN)/tiles.bmp: $(U)tile2bmp.exe $(TILEFILES)
	$< $@

$(MSWIN)/%.bmp: $(U)uudecode.exe $(MSWIN)/%.uu
	$^
	mv $(notdir $@) $@

$(SNDWAVDIR)/%.wav: $(U)uudecode.exe $(SNDWAVDIR)/%.uu
	$^
	mv $(notdir $@) $@

$(ONHW):
	@mkdir -p $@

CLEAN_DIR += $(ONHW)
CLEAN_FILE += $(NHWTARGETS) $(NHWOBJS) $(NHWRES) $(BMPS) $(WAV)

#==========================================
# nethack
#==========================================
CFLAGSNH = $(CFLAGSU) $(CFLAGSXTRA) $(SOUNDLIBINCL) -DNO_TILE_C -DSAFEPROCS -D_LIB -DWIN32CON $(SOUNDLIBDEFS)
CPPFLAGSNH = $(CFLAGSU) $(CPPFLAGSXTRA) -DNO_TILE_C -DSAFEPROCS -D_LIB -DWIN32CON $(SOUNDLIBDEFS)

ONH = $(O)nethack

NHONLY = consoletty.o getline.o topl.o wintty.o
ifeq "$(ADD_CURSES)" "Y"
NHCURSESFLAGS = -DCURSES_GRAPHICS -DCURSES_UNICODE $(PDCURSESFLAGS) -DPDC_NCMOUSE
CFLAGSNH += $(NHCURSESFLAGS)
NHONLY += $(addsuffix .o, cursdial cursinit cursinvt cursmain cursmesg cursmisc cursstat curswins)
endif

DATE_O  = $(addsuffix .o, $(addprefix $(ONH)/, date))

NHOBJS = $(addprefix $(ONH)/, $(COREOBJS) $(NHONLY))
NHRES = $(ONH)/conres.o
NHTARGET = $(GAMEDIR)/NetHack.exe

nethack: $(NHTARGET)

$(GAMEDIR)/NetHack.exe: $(NHOBJS) $(NHRES) $(DATE_O) $(LUALIB) $(PDCLIB) $(HLHACKLIB) \
	$(SOUNDLIBLIBS) | $(GAMEDIR)
	$(ld) $(LDFLAGS) -mconsole $^ $(HLHACKLIB) $(LIBS) -static -lstdc++ -o$@

$(ONH)/%.o: $(SRC)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

#==========================================
# package
#==========================================
TARGET_CPU = x64
NHV=370
PKGFILES = nethackrc.template Guidebook.txt license NetHack.exe NetHack.txt \
        NetHackW.exe opthelp nhdat370 record symbols sysconf.template
FILESTOZIP = $(addprefix $(GAMEDIR)/, $(PKGFILES))
MAINZIP = $(PkgDir)/nethack-$(NHV)-win-$(TARGET_CPU)-msys2.zip

package: binary $(FILESTOZIP) $(MAINZIP)
       @echo NetHack Windows package created: $(MAINZIP)

$(MAINZIP): $(FILESTOZIP) | $(PkgDir)
	/c/Windows/System32/tar -a -cf $(MAINZIP) -C $(GAMEDIR) $(PKGFILES)
	@echo NetHack Windows package created: $(MAINZIP)

$(PkgDir):
	@mkdir -p $@

CLEAN_DIR += $(PkgDir)
CLEAN_FILE += $(MAINZIP)

#       In NetHack 3.7, date.c must be recompiled after any other file is compiled,
#       otherwise the game internal build timestamp (and potentially git hash)
#       will not be accurate.
#       Therefore, date must not be included in COREOBJS (and by extension
#       NHOBJS). That allows those to be listed as explicit dependencies of date.o
#       to ensure that date.c is always recompiled again after anything else that
#       was just recompiled. date.h is not used in the build of NetHack 3.7.
#
$(ONH)/date.o: $(SRC)/date.c $(NHOBJS) $(NHRES) | $(ONH)
	$(cc) $(CFLAGSNH) $(GITHASH) $(GITBRANCH) $(GITPREFIX) $< -o$@

$(ONH)/cppregex.o: $(SSYS)/cppregex.cpp $(NHLUAH) | $(ONH)
	$(cc) $(CPPFLAGSNH) $< -o$@

$(ONH)/%.o: $(SSYS)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

ifeq "$(SOUND_WINDSOUND)" "Y"
$(ONH)/%.o: ../sound/windsound/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@
endif

ifeq "$(SOUND_FMOD)" "Y"
$(ONH)/%.o: ../sound/fmod/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@
endif

$(ONH)/%.o: $(MSWSYS)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

$(ONH)/%.o: $(MSWIN)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

$(ONH)/%.o: $(WCHAIN)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

$(ONH)/%.o: $(WSHR)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

$(ONH)/%.o: $(TTY)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $< -o$@

$(ONH)/%.o: $(WCURSES)/%.c $(NHLUAH) | $(ONH)
	$(cc) $(CFLAGSNH) $(PDCINCL) $< -o$@

$(NHRES): $(MSWIN)/NetHack.rc $(WAV) $(MSWIN)/NetHack.ico | $(ONH)
	$(rc) --include-dir=$(MSWIN) $(RCFLAGS) --input=$< -o$@

$(ONH):
	@mkdir -p $@

CLEAN_DIR += $(ONH)
CLEAN_FILE += $(NHTARGET) $(NHOBJS) $(NHRES)

#==========================================
#=============== TARGETS ==================
#==========================================

.PHONY: all clean default binary lua makedefs recover $(PDCURSES) $(PDCURSES)w \
	tile2bmp tilemap uudecode dlb nethackw nethack tileutil \
	fetchlua fetchpdcurses

#
#  Everything
#

all: package

TO_BINARY = $(GAMEDIR)/NetHack.exe $(RTARGETS) $(GAMEDIRDLLS) \
	     $(addprefix $(GAMEDIR)/, \
	     $(addsuffix .template, sysconf nethackrc symbols) \
	     Guidebook.txt NetHack.txt license opthelp record)

ifeq "$(HAVE_SOUNDLIB)" "Y"
TO_BINARY += $(addprefix $(GAMEDIR)/, $(addsuffix .wav, $(WAVLIST)))
endif

ifeq "$(USE_LUADLL)" "Y"
TO_BINARY += $(LUADLL)
endif

ifneq "$(SKIP_NETHACKW)" "Y"
TO_BINARY += $(GAMEDIR)/NetHackW.exe
endif

ifeq "$(USE_DLB)" "Y"
TO_BINARY += $(DLB)
endif

binary: fetchlua fetchpdcurses $(TO_BINARY)
ifdef CI_COMPILER
	ls -l $(SRC)
	ls -l $(DAT)
	ls -l $(UTIL)
endif
ifneq "$(USE_DLB)" "Y"
	cp $(DAT)/*.dat $(GAMEDIR)/
endif
	@echo NetHack is up to date.

ifdef SOUND_FMOD
$(GAMEDIR)/$(FMODLIBDLL): $(FMODLIBDIR)/$(FMODLIBDLL)
        cp $< $@
endif

$(GAMEDIR)/symbols.template: $(DAT)/symbols
	cp $< $@

$(GAMEDIR)/NetHack.txt: $(DOC)/nethack.txt
	cp $< $@

$(GAMEDIR)/record:
	touch $@

$(GAMEDIR)/%: $(DAT)/%
	cp $< $@

$(GAMEDIR)/%: $(DOC)/%
	cp $< $@

$(GAMEDIR)/%: $(MSWSYS)/%
	cp $< $@

$(GAMEDIR)/%: $(SNDWAVDIR)/%
	cp $< $@

CLEAN_FILE += $(TO_BINARY)

clean:
	@-rm -f $(CLEAN_FILE)
	@$(foreach dir, $(CLEAN_DIR), \
		if [ -d $(dir) ] ; then rmdir -p --ignore $(dir) ; fi ; )

-include GNUmakefile.depend
-include .depend
# end of file
