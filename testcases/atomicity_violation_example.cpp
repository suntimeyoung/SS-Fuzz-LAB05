#include <iostream>
#include <pthread.h>
#define RUN_TIME 3000

int value = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void* add(void* arg) {
    for (int i = 0; i < RUN_TIME; ++i) {
        pthread_mutex_lock(&mutex);
        int temp = value;
        temp = temp + 1;
        value = temp;
        pthread_mutex_unlock(&mutex);
    }
    return nullptr;
}

void* subtract(void* arg) {
    for (int i = 0; i < RUN_TIME; ++i) {
        int temp = value;
        temp = temp - 1;
        value = temp;
    }
    return nullptr;
}

int main() {
    pthread_t thread1, thread2;

    pthread_create(&thread1, nullptr, add, nullptr);
    pthread_create(&thread2, nullptr, subtract, nullptr);

    pthread_join(thread1, nullptr);
    pthread_join(thread2, nullptr);

    std::cout << "Final value: " << value << std::endl;

    return 0;
}
