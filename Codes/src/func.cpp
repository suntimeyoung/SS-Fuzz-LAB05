#include <iostream>
#include <fstream>
#include <pthread.h>

using namespace std;

pthread_mutex_t mutex_file_rw = PTHREAD_MUTEX_INITIALIZER;
fstream f;

extern "C" void memoryLoadHook(void* addr, int line_num) {
    // cout << "Memory Load at: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Load\n" << addr << "\n" << line_num << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}

extern "C" void memoryStoreHook(void* addr, int line_num) {
    // cout << "Memory Store at: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Store\n" << addr << "\n" << line_num << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}

extern "C" void lockAddHook(void* addr, int line_num) {
    // cout << "Lock Add on: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Add\n" << addr << "\n" << line_num << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}

extern "C" void lockRemoveHook(void* addr, int line_num) {
    // cout << "Lock Remove on: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Remove\n" << addr << "\n" << line_num << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}