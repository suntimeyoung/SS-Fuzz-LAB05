#include <iostream>
#include <fstream>
#include <pthread.h>

using namespace std;

pthread_mutex_t mutex_file_rw = PTHREAD_MUTEX_INITIALIZER;
fstream f;

extern "C" void memoryLoadHook(void* addr) {
    cout << "Memory Load at: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Load " << addr << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}

extern "C" void memoryStoreHook(void* addr) {
    cout << "Memory Store at: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Store " << addr << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}

extern "C" void lockAddHook(void* addr) {
    cout << "Lock Add on: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Add " << addr << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}

extern "C" void lockRemoveHook(void* addr) {
    cout << "Lock Remove on: " << addr << endl;
    pthread_mutex_lock(&mutex_file_rw);
    f.open("../log/log.txt", ios::out | ios::app);
    f << "Remove " << addr << endl;
    f.close();
    pthread_mutex_unlock(&mutex_file_rw);
}