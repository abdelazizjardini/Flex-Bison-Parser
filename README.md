# Finite Automaton Language Compiler

A complete compiler implementation for defining and verifying finite state automata using a custom domain-specific language. Built with Flex (lexical analyzer) and Bison (parser), with semantic analysis and automaton execution capabilities.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Language Syntax](#language-syntax)
- [Examples](#examples)
- [Technical Details](#technical-details)
- [Building from Source](#building-from-source)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project implements a compiler for a specialized language designed to define and verify finite state automata (FSA). The compiler performs lexical analysis, syntax parsing, semantic validation, and automaton execution to verify whether given strings are accepted by the defined automaton.

**Key Capabilities:**
- Define automata with custom alphabets, states, and transitions
- Validate automaton definitions (semantic checks)
- Execute automata to verify if strings are accepted or rejected
- Comprehensive error reporting with line numbers

## ✨ Features

- **Lexical Analysis**: Tokenizes automaton definitions using Flex
- **Syntax Parsing**: Validates grammar using Bison-generated parser
- **Semantic Validation**:
  - Verifies initial state exists in state set
  - Validates all final states are declared
  - Checks transition symbols belong to alphabet
  - Ensures transition states are properly defined
- **Automaton Execution**: Simulates automaton behavior on input strings
- **Error Reporting**: Clear error messages with line numbers
- **Comment Support**: Single-line comments using `#`

## 📁 Project Structure

```
elgh_jard_proj/
├── automate.l              # Flex lexical analyzer definition
├── parser.y                # Bison parser grammar
├── semantics/              # Semantic analysis modules
│   ├── ast.h              # Abstract Syntax Tree definitions
│   ├── ast.c              # AST implementation
│   ├── semantic.h         # Semantic analyzer header
│   ├── semantic.c         # Semantic validation & execution
│   ├── table.h            # Symbol table (if used)
│   └── table.c            # Symbol table implementation
├── code.a                  # Example automaton definition
├── code_test.a            # Additional test cases
├── test.sh                # Build and test script
├── automate.exe           # Compiled executable (Windows)
├── lex.yy.c               # Generated lexer (auto-generated)
├── parser.tab.c           # Generated parser (auto-generated)
└── parser.tab.h           # Parser header (auto-generated)
```

## 🔧 Requirements

### Software Dependencies

- **GCC** (GNU Compiler Collection)
- **Flex** (Fast Lexical Analyzer) - version 2.5.35 or higher
- **Bison** (GNU Parser Generator) - version 3.0 or higher
- **Bash** (for build script)

### Installation on Different Systems

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install flex bison gcc
```

**macOS:**
```bash
brew install flex bison gcc
```

**Windows:**
- Install MinGW or use WSL (Windows Subsystem for Linux)
- Or use Cygwin with flex, bison, and gcc packages

## 🚀 Installation

1. **Clone or extract the project:**
```bash
unzip projet_version_final.zip
cd elgh_jard_proj
```

2. **Make the build script executable:**
```bash
chmod +x test.sh
```

3. **Build the project:**
```bash
./test.sh
```

Or build manually:
```bash
# Generate lexer
flex automate.l

# Generate parser
bison -d parser.y

# Compile
gcc lex.yy.c parser.tab.c semantics/*.c -o automate
```

## 💻 Usage

### Basic Execution

```bash
./automate < code.a
```

### Create Your Own Automaton

1. Create a new `.a` file (e.g., `myautomaton.a`)
2. Define your automaton using the language syntax (see below)
3. Run the compiler:
```bash
./automate < myautomaton.a
```

## 📝 Language Syntax

### General Structure

```
automate <AutomatonName> {
    alphabet = {<symbol1>, <symbol2>, ...};
    etats = {<state1>, <state2>, ...};
    initial = <initialState>;
    finaux = {<finalState1>, <finalState2>, ...};
    transitions = {
        <sourceState> : <symbol> -> <destState>;
        ...
    };
}
verifier <AutomatonName> "<string>";
```

### Keywords (Case-Insensitive)

- `automate` - Declares an automaton
- `alphabet` - Defines the input alphabet
- `etats` - Defines the set of states
- `initial` - Specifies the initial state
- `finaux` - Specifies final/accepting states
- `transitions` - Defines state transitions
- `verifier` - Verifies if a string is accepted

### Syntax Rules

1. **Identifiers**: Start with a letter, followed by letters/digits (e.g., `q0`, `state1`, `NomAutomate`)
2. **Symbols**: Single alphanumeric characters (e.g., `a`, `b`, `0`, `1`)
3. **Strings**: Enclosed in double quotes (e.g., `"ab"`, `"101"`)
4. **Comments**: Lines starting with `#` are ignored
5. **Delimiters**: 
   - `{` `}` for blocks
   - `,` for list separation
   - `;` for statement termination
   - `:` for transition source
   - `->` for transition arrow

## 📚 Examples

### Example 1: Simple Binary String Acceptor

```
automate BinaryAcceptor {
    alphabet = {0, 1};
    etats = {q0, q1, q2};
    initial = q0;
    finaux = {q2};
    transitions = {
        q0 : 0 -> q1;
        q1 : 1 -> q2;
    };
}
verifier BinaryAcceptor "01";
```

**Expected Output:**
```
--- Verifications Semantiques ---
Automate sémantiquement VALIDE.
--- Execution mot: "01" ---
Etat depart: q0
Transition: q0 --(0)--> q1
Transition: q1 --(1)--> q2
Etat final atteint: q2
Resultat: ACCEPTE
```

### Example 2: Multi-Character Alphabet

```
automate MultiChar {
    alphabet = {a, b, c};
    etats = {q0, q1, q2};
    initial = q0;
    finaux = {q2};
    transitions = {
        q0 : a -> q1;
        q1 : b -> q2;
        q2 : c -> q0;
    };
}
verifier MultiChar "ab";
verifier MultiChar "abc";
```

### Example 3: Rejection Case

```
automate Rejector {
    alphabet = {x, y};
    etats = {s0, s1};
    initial = s0;
    finaux = {s1};
    transitions = {
        s0 : x -> s1;
    };
}
verifier Rejector "xy";  # Will be rejected (no transition s1:y)
```

## 🔍 Technical Details

### Abstract Syntax Tree (AST)

The compiler builds an AST with the following node types:
- `AST_PROGRAMME` - Root program node
- `AST_ALPHABET` - Alphabet definition
- `AST_ETATS` - States definition
- `AST_INITIAL` - Initial state
- `AST_FINAUX` - Final states
- `AST_TRANSITION` - Transition rules
- `AST_COMMAND` - Verification commands
- `AST_ID` - Identifier
- `AST_SYMBOLE` - Symbol
- `AST_CHAINE` - String literal

### Semantic Validation

The semantic analyzer performs these checks:

1. **Initial State Validation**: Ensures the initial state is declared in the state set
2. **Final States Validation**: Verifies all final states exist in the state set
3. **Transition Validation**:
   - Source state exists
   - Destination state exists
   - Transition symbol is in the alphabet

### Execution Model

The automaton executor:
1. Starts in the initial state
2. Processes each symbol in the input string sequentially
3. Follows transitions based on current state and input symbol
4. Accepts if it reaches a final state after processing all symbols
5. Rejects if:
   - No transition exists for current (state, symbol) pair
   - Final state is not reached after processing entire string

## 🛠️ Building from Source

### Manual Build Steps

```bash
# Step 1: Generate lexer
flex automate.l
# Creates: lex.yy.c

# Step 2: Generate parser
bison -d parser.y
# Creates: parser.tab.c, parser.tab.h

# Step 3: Compile all sources
gcc lex.yy.c parser.tab.c semantics/ast.c semantics/semantic.c semantics/table.c -o automate

# Step 4: Run
./automate < code.a
```

### Using the Test Script

The `test.sh` script automates the entire build process:

```bash
chmod +x test.sh
./test.sh
```

The script will:
1. Run Flex to generate the lexer
2. Run Bison to generate the parser
3. Compile with GCC
4. Execute tests
5. Report status at each step

## 🐛 Troubleshooting

### Common Errors

**"CARACTERE INATTENDU"**
- **Cause**: Invalid character in input
- **Solution**: Check for typos, ensure all symbols are alphanumeric

**"Erreur syntaxique ligne X"**
- **Cause**: Syntax error in automaton definition
- **Solution**: Verify syntax matches the language specification, check for missing semicolons or brackets

**"L'etat initial 'X' n'est pas declare dans les etats"**
- **Cause**: Initial state not in state set
- **Solution**: Add the state to the `etats` declaration

**"Symbole 'X' hors alphabet"**
- **Cause**: Transition uses undefined symbol
- **Solution**: Add the symbol to the `alphabet` declaration

**"Blocage: Pas de transition pour (state, symbol)"**
- **Cause**: Missing transition for the given state-symbol pair
- **Solution**: Add the required transition or verify input string

### Build Issues

**"flex: command not found"**
```bash
# Install flex
sudo apt-get install flex  # Ubuntu/Debian
brew install flex          # macOS
```

**"bison: command not found"**
```bash
# Install bison
sudo apt-get install bison # Ubuntu/Debian
brew install bison         # macOS
```

**Compilation warnings about `yywrap`**
- These are typically harmless, but you can add `-lfl` flag:
```bash
gcc lex.yy.c parser.tab.c semantics/*.c -o automate -lfl
```

## 📄 License

This project is provided as-is for educational purposes.

## 👥 Authors

Project: Automaton Language Compiler (elgh_jard_proj)

## 🙏 Acknowledgments

- Built using GNU Flex and Bison
- Implements classic compiler design patterns
- Follows formal automata theory principles

---

**For questions or issues, please check the error messages carefully - they include line numbers and specific details about what went wrong.**
