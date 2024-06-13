#!/bin/bash

# 定义编译器
CLANG_COMPILER="clang++-12"

# 定义源文件和可执行文件名称
data_race_source="../../testcases/data_race_example.cpp"
data_race_executable="../bin/data_race_example"

atomicity_violation_source="../../testcases/atomicity_violation_example.cpp"
atomicity_violation_executable="../bin/atomicity_violation_example"

shared_array_source="../../testcases/shared_array_example.cpp"
shared_array_executable="../bin/shared_array_example"

# 检查源文件是否存在
if [ ! -f "$data_race_source" ]; then
  echo "Error: $data_race_source not found!"
  exit 1
fi

if [ ! -f "$atomicity_violation_source" ]; then
  echo "Error: $atomicity_violation_source not found!"
  exit 1
fi

if [ ! -f "$shared_array_source" ]; then
  echo "Error: $shared_array_source not found!"
  exit 1
fi

# 编译源文件
echo "Compiling $data_race_source with $CLANG_COMPILER..."
$CLANG_COMPILER -o $data_race_executable $data_race_source -lpthread
if [ $? -ne 0 ]; then
  echo "Error: Failed to compile $data_race_source"
  exit 1
fi

echo "Compiling $atomicity_violation_source with $CLANG_COMPILER..."
$CLANG_COMPILER -o $atomicity_violation_executable $atomicity_violation_source -lpthread
if [ $? -ne 0 ]; then
  echo "Error: Failed to compile $atomicity_violation_source"
  exit 1
fi

echo "Compiling $shared_array_source with $CLANG_COMPILER..."
$CLANG_COMPILER -o $shared_array_executable $shared_array_source -lpthread
if [ $? -ne 0 ]; then
  echo "Error: Failed to compile $shared_array_source"
  exit 1
fi

# 运行 data_race_example 20次
echo "Running data_race_executable 20 times..."
for i in {1..20}; do
  # echo "Run #$i:"
  echo "3000" | ./$data_race_executable
done

# 运行 atomicity_violation_example 20次
echo "Running atomicity_violation_executable 20 times..."
for i in {1..20}; do
  # echo "Run #$i:"
  echo "3000" | ./$atomicity_violation_executable
done

# 运行 shared_array_example 20次
echo "Running shared_array_example 20 times..."
for i in {1..20}; do
  # echo "Run #$i:"
  echo "5" | ./$shared_array_executable
done

echo "Finished running all tests."
