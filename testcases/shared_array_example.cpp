#include <iostream>
#include <pthread.h>
#include <unistd.h>
#define MAX_THREADS 100

using namespace std;

const int ARRAY_SIZE = 10;
int shared_array[ARRAY_SIZE]; // 共享数组

void* set_elements(void* arg) {
    int thread_id = *((int*)arg);
    for (int i = 0; i < ARRAY_SIZE; ++i) {
        usleep(1);
        shared_array[i] = thread_id;
    }
    return nullptr;
}

int main() {
    int num_threads;
    cin >> num_threads;
    pthread_t threads[MAX_THREADS];
    int thread_ids[MAX_THREADS];

    for (int i = 0; i < num_threads; ++i) {
        thread_ids[i] = i + 1;
        if (pthread_create(&threads[i], nullptr, set_elements, &thread_ids[i]) != 0) {
            cerr << "Error creating thread " << i + 1 << endl;
            return 1;
        }
    }

    for (int i = 0; i < num_threads; ++i) {
        if (pthread_join(threads[i], nullptr) != 0) {
            cerr << "Error joining thread " << i + 1 << endl;
            return 1;
        }
    }

    cout << "Final values in shared_array: ";
    for (int i = 0; i < ARRAY_SIZE; ++i) {
        cout << shared_array[i] << " ";
    }
    cout << endl;

    return 0;
}
