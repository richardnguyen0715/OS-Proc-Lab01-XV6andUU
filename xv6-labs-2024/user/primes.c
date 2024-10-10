#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


// //Testing in Terminal
// #include<stdio.h>
// #include<stdlib.h>
// #include<unistd.h>
// #include<string.h>


void primes(int cur_pipe)__attribute__((noreturn));

void primes(int cur_pipe){
    int val;
    int c_read = read(cur_pipe, &val, sizeof(val)); // c_read: check_read
    if(c_read == 0){
        close(cur_pipe);
        exit(0);
    }

    printf("prime: %d\n",val);

    int fd[2];
    pipe(fd);
    int pid = fork();

    if(pid < 0){
        printf("Cannot create process! - Error: fork() function failed!");
        exit(0);
    }
    else if(pid == 0){
        close(fd[1]); // Close write pipe.

        primes(fd[0]);

        close(fd[0]);
    }
    else {
        int check_prime;
        close(fd[0]); // Close read pipe.
        int c_read;
        while((c_read = read(cur_pipe, &check_prime, sizeof(check_prime))) > 0){
            if(check_prime % val != 0){
                write(fd[1], &check_prime, sizeof(check_prime));
            }
        }
        if(c_read == -1){
            printf("Error reading from pipe\n");
        }
        close(fd[1]);
        close(cur_pipe);
        wait(0);
        exit(0);
    }
}




int main(){
    int fd[2];
    int c_pipe = pipe(fd); //fd[0]: read | fd[1]: write
    if(c_pipe == -1){
        printf("Cannot create pipe! - Error: pipe() function failed!");
        exit(0);
    }

    int pid = fork();
    
    if(pid < 0){
        printf("RaiseError: Cannot create process!");
        exit(0);
    }
    else if (pid == 0){
        //This is the child process
        close(fd[1]);
        primes(fd[0]);

    }
    else{
        //This is the parent process    
        close(fd[0]);

        for( int i = 2; i <= 280; i++){
            write(fd[1], &i, sizeof(i));
        }

        close(fd[1]);

        wait(0);
    }
    exit(0);
}