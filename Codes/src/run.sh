#!/usr/bin/bash

clang++-12 $(llvm-config-12 --cxxflags --libs) lock_set.cpp -o modify