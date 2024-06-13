#include <fstream>
#include <iostream>
#include <string>
#include <set>
#include <map>

using namespace std;

string log_file = "../log/log.txt";
set<uint64_t> all_lock;
map<uint64_t, set<uint64_t>> variable_lock;

uint64_t hexStringToNumber(const std::string& hexString);
void all_lock_init();
void check_log();




int main() {
    all_lock_init();

    return 0;
}

void all_lock_init() {
    fstream f;
    f.open(log_file, ios::in);
    string op, addr;
    while (getline(f, op)) {
        getline(f, addr);
        if (op == "Add") {
            all_lock.insert(hexStringToNumber(addr));
        }
    }
    f.close();
    cout << "All Locks are :" << endl;
    for (const auto& element: all_lock) {
        cout << element << endl;
    }
}

void check_log() {
    fstream f;
    f.open(log_file, ios::in);

    set<uint64_t> current_lock;
    string op, addr;
    while (getline(f, op)) {
        getline(f, addr);
        

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
