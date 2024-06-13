#include <iostream>
#include <pthread.h>
#define RUN_TIME 3000

int counter = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void* increment(void* arg) {
    for (int i = 0; i < RUN_TIME; ++i) {
        pthread_mutex_lock(&mutex);
        ++counter;
        pthread_mutex_unlock(&mutex);
    }
    return nullptr;
}

void* decrement(void* arg) {
    for (int i = 0; i < RUN_TIME; ++i) {
        --counter;
    }
    return nullptr;
}

int main() {
    pthread_t thread1, thread2;

    pthread_create(&thread1, nullptr, increment, nullptr);
    pthread_create(&thread2, nullptr, decrement, nullptr);

    pthread_join(thread1, nullptr);
    pthread_join(thread2, nullptr);

    std::cout << "Final counter value: " << counter << std::endl;

    return 0;
}
