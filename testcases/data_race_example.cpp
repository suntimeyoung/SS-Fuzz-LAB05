#include <iostream>
#include <pthread.h>

int counter = 0;
int run_time;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void* increment(void* arg) {
    for (int i = 0; i < run_time; ++i) {
        pthread_mutex_lock(&mutex);
        ++counter;
        pthread_mutex_unlock(&mutex);
    }
    return nullptr;
}

void* decrement(void* arg) {
    for (int i = 0; i < run_time; ++i) {
        --counter;
    }
    return nullptr;
}

int main() {
    std::cin >> run_time;
    pthread_t thread1, thread2;

    pthread_create(&thread1, nullptr, increment, nullptr);
    pthread_create(&thread2, nullptr, decrement, nullptr);

    pthread_join(thread1, nullptr);
    pthread_join(thread2, nullptr);

    std::cout << "Final counter value: " << counter << std::endl;

    return 0;
}
