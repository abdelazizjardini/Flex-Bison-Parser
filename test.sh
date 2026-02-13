#!/bin/bash

echo "----------------------------------------"
echo "Starting Build Process"
echo "----------------------------------------"

# 1. GENERATION FLEX
echo "[1] Running Flex..."
flex automate.l
if [ $? -eq 0 ]; then
    echo "✅ Flex execution: SUCCESS"
else
    echo "❌ Flex execution: FAILED"
    exit 1
fi

# 2. GENERATION BISON
echo "[2] Running Bison..."
bison -d parser.y
if [ $? -eq 0 ]; then
    echo "✅ Bison execution: SUCCESS"
else
    echo "❌ Bison execution: FAILED"
    exit 1
fi

# 3. COMPILATION GCC
echo "[3] Compiling with GCC..."
gcc lex.yy.c parser.tab.c semantics/*.c -o automate
if [ $? -eq 0 ]; then
    echo "✅ GCC compilation: SUCCESS"
else
    echo "❌ GCC compilation: FAILED"
    exit 1
fi

# 4. EXECUTION
echo "[4] Running Test..."
./automate < code.a
if [ $? -eq 0 ]; then
    echo "✅ Execution: SUCCESS"
else
    echo "❌ Execution: FAILED"
    exit 1
fi

echo "----------------------------------------"
echo "Build and Test Complete"
echo "----------------------------------------"
