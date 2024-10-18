#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void primes(int cur_pipe)__attribute__((noreturn));

void primes(int cur_pipe) {
    int prime;
    if (read(cur_pipe, &prime, sizeof(prime)) == 0) {
        close(cur_pipe);
        exit(0);
    }

    // Print the prime number
    printf("prime %d\n", prime);

    int fd[2];
    if (pipe(fd) < 0) {
        printf("Error creating pipe\n");
        close(cur_pipe);
        exit(1);
    }

    int num;
    int pid = fork();
    if (pid == 0) {
        // Child process to handle next prime filtering
        close(fd[1]);  // Close write end in child
        close(cur_pipe);  // Close current pipe in child, You got a buffer overflow if you not close this pip
        primes(fd[0]); // Recursive call
    } else {
        // Parent process filters numbers
        close(fd[0]);  // Close read end in parent

        while (read(cur_pipe, &num, sizeof(num)) > 0) {
            // Only pass numbers that are not divisible by the current prime
            if (num % prime != 0) {
                if (write(fd[1], &num, sizeof(num)) < 0) {
                    printf("Error writing to pipe\n");
                    break;
                }
            }
        }

        // Close pipes
        close(fd[1]);
        close(cur_pipe);
        wait(0);  // Wait for child process
        exit(0);  // Exit after child finishes
    }
}

int main() {
    int fd[2];
    if (pipe(fd) < 0) {
        printf("Error creating initial pipe\n");
        exit(1);
    }

    int pid = fork();
    if (pid == 0) {
        // Child process to handle prime numbers
        close(fd[1]);  // Close write end of the pipe in child
        primes(fd[0]); // Start the prime number filtering
    } else {
        // Parent process generates numbers and writes them to the pipe
        close(fd[0]);  // Close read end of the pipe in parent

        for (int i = 2; i <= 280; i++) {
            if (write(fd[1], &i, sizeof(i)) < 0) {
                printf("Error writing to pipe\n");
                break;
            }
        }

        close(fd[1]);  // Close write end after sending all numbers
        wait(0);       // Wait for child process to finish
    }

    exit(0);
}
