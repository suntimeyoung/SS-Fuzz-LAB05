#!/usr/bin/bash

# 编译插桩文件
clang++-12 $(llvm-config-12 --cxxflags --libs) lock_set.cpp -o ../bin/modify
chmod +x ../bin/modify

# 编译插桩所用函数
clang++-12 -c func.cpp -o ../bin/func.o

# 编译源文件
clang++-12 -g -S -emit-llvm ../../testcases/data_race_example.cpp -o ../bin/data_race_example.ll
clang++-12 -g -S -emit-llvm ../../testcases/atomicity_violation_example.cpp -o ../bin/atomicity_violation_example.ll

# 修改ll文件
../bin/modify ../bin/data_race_example.ll ../bin/data_race_example_ed.ll
../bin/modify ../bin/atomicity_violation_example.ll ../bin/atomicity_violation_example_ed.ll

# 链接相关文件
clang++-12 -c ../bin/data_race_example_ed.ll -o ../bin/data_race_example_ed.o
clang++-12 -c ../bin/atomicity_violation_example_ed.ll -o ../bin/atomicity_violation_example_ed.o

# 生成可执行文件
clang++-12 ../bin/data_race_example_ed.o ../bin/func.o -o ../bin/data_race_example_ed
clang++-12 ../bin/atomicity_violation_example_ed.o ../bin/func.o -o ../bin/atomicity_violation_example_ed
clang++-12 check_lock.cpp -o ../bin/check_lock

# 清理垃圾
rm ../bin/*.ll
rm ../bin/*.o

# 运行相关可执行文件
echo "======= Testing file of data_race_example_ed ======="
rm ../log/*
echo "1" | ../bin/data_race_example_ed
../bin/check_lock
echo "-----------------------------------------------------"

echo "======= Testing file of atomicity_violation_example_ed ======="
rm ../log/*
echo "1" | ../bin/atomicity_violation_example_ed
../bin/check_lock
echo "-----------------------------------------------------"
