CXX=     clang++
OS!=     uname

.if $(OS) == "NetBSD"
LOCALBASE?= /usr/pkg
CXX=     g++
.elif $(OS) == "OpenBSD"
LOCALBASE?= /usr/local
CXX=     clang++
.elif $(OS) == "FreeBSD" || $(OS) == "DragonFly"
LOCALBASE?= /usr/local
.else
LOCALBASE?= /usr/local
.endif

CXXFLAGS+= -std=c++17 -Wall -Wextra -O2 -I$(LOCALBASE)/include

CLANG_FORMAT?= clang-format
TARGET=  bitftk
SRC=     test.cpp

.PHONY: all run clean format format-check

all: $(TARGET)

$(TARGET): $(SRC) bitfake2.hpp
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET)

run: $(TARGET)
	./$(TARGET)

format:
	@command -v $(CLANG_FORMAT) >/dev/null 2>&1 || \
		{ echo "Error: $(CLANG_FORMAT) is not installed."; exit 1; }
	find . -type f \( -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.cxx" \
		-o -name "*.h" -o -name "*.hh" -o -name "*.hpp" -o -name "*.hxx" \) \
		-not -path "./.git/*" | xargs $(CLANG_FORMAT) -i

format-check:
	@command -v $(CLANG_FORMAT) >/dev/null 2>&1 || \
		{ echo "Error: $(CLANG_FORMAT) is not installed."; exit 1; }
	find . -type f \( -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.cxx" \
		-o -name "*.h" -o -name "*.hh" -o -name "*.hpp" -o -name "*.hxx" \) \
		-not -path "./.git/*" | xargs $(CLANG_FORMAT) --dry-run --Werror

clean:
	rm -f $(TARGET)
