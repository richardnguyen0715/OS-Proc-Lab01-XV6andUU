#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void primes(int cur_pipe)__attribute__((noreturn));

void primes(int cur_pipe) {
    int val;
    int c_read = read(cur_pipe, &val, sizeof(val));
    if (c_read == 0) {
        close(cur_pipe);
        exit(0);
    } else if (c_read < 0) {
        printf("Error reading initial value from pipe\n");
        close(cur_pipe);
        exit(1);
    }

    printf("prime: %d\n", val);

    int check_prime;
    while (read(cur_pipe, &check_prime, sizeof(check_prime)) > 0) {
        if (check_prime % val != 0) {
            printf("prime: %d\n", check_prime); // Print prime directly
        }
    }

    close(cur_pipe);
    exit(0);
}

int main() {
    int fd[2];
    if (pipe(fd) < 0) {
        printf("Cannot create pipe! - Error: pipe() function failed!\n");
        exit(1);
    }

    int pid = fork();
    if (pid < 0) {
        printf("RaiseError: Cannot create process!\n");
        exit(1);
    } else if (pid == 0) {
        // This is the child process
        close(fd[1]); // Close write end of pipe in the child
        primes(fd[0]); // Start the prime number filtering
    } else {
        // This is the parent process
        close(fd[0]); // Close read end of pipe in the parent

        for (int i = 2; i <= 280; i++) {
            if (write(fd[1], &i, sizeof(i)) < 0) {
                printf("Error writing to pipe\n");
                break;
            }
        }

        close(fd[1]); // Close write end after sending all numbers
        wait(0); // Wait for the child process to finish
    }

    exit(0);
}