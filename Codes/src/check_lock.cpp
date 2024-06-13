#include <fstream>
#include <iostream>
#include <algorithm>
#include <string>
#include <set>
#include <map>

using namespace std;

string log_file = "../log/log.txt";
set<uint64_t> all_lock;
set<uint64_t> memory_check;
set<uint64_t> data_race_addr;
map<uint64_t, set<uint64_t>> variable_lock;

uint64_t hexStringToNumber(const std::string& hexString);
void all_lock_init();
void check_log();




int main() {
    all_lock_init();
    check_log();
    return 0;
}

void all_lock_init() {
    fstream f;
    f.open(log_file, ios::in);
    string op, addr, line_num;
    while (getline(f, op)) {
        getline(f, addr);
        getline(f, line_num);
        if (op == "Add") {
            all_lock.insert(hexStringToNumber(addr));
        }
    }
    f.close();
    // cout << "All Locks are :" << endl;
    // for (const auto& element: all_lock) {
    //     cout << element << endl;
    // }
}

void check_log() {
    fstream f;
    f.open(log_file, ios::in);

    set<uint64_t> current_lock;
    string op, addr, line_num;
    while (getline(f, op)) {
        getline(f, addr);
        getline(f, line_num);
        uint64_t addr_num = hexStringToNumber(addr);
        
        if (op == "Add") {
            current_lock.insert(addr_num);
        }
        if (op == "Remove") {
            current_lock.erase(addr_num);
        }
        if (op == "Load" || op == "Store") {
            if (!memory_check.count(addr_num)) {
                // 第一次遇到这个变量
                variable_lock[addr_num] = all_lock;
                memory_check.insert(addr_num);
            }
            set<uint64_t> tmp;
            set_intersection(
                variable_lock[addr_num].begin(), variable_lock[addr_num].end(), 
                current_lock.begin(), current_lock.end(), 
                inserter(tmp, tmp.begin())
                );
            variable_lock[addr_num] = tmp;
            if (variable_lock[addr_num].size() == 0 && !data_race_addr.count(addr_num)) {
                cout << "Warning: Data Race at line " << line_num << ", addr is " << addr << endl;
                data_race_addr.insert(addr_num);
            }
        }
    }
    f.close();
}

uint64_t hexStringToNumber(const std::string& hexString) {
    try {
        uint64_t number = std::stoull(hexString, nullptr, 16);
        return number;
    } catch (const std::invalid_argument& e) {
        throw std::invalid_argument("Invalid argument: " + hexString);
    } catch (const std::out_of_range& e) {
        throw std::out_of_range("Out of range: " + hexString);
    }
}
