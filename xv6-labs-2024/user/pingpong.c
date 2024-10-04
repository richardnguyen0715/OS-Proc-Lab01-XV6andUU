#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main()
{   
    int proc = fork();
    int pipe_one[2];
    int pipe_two[2];  
    
    int check_pipe1 = pipe(pipe_one); // Create a parent-to-child pipe
    int check_pipe2 = pipe(pipe_two); // Create a child-to-parent pipe

    if (proc < 0) {
        printf("Cannot create a child process! - Error: fork() function failed!");
        return 0;   
    }
    else if (proc == 0) { // Child process
        if (check_pipe1 == -1 || check_pipe2 == -1) {
            printf("Cannot create pipe! - Error: pipe() function failed!");
            return 0;
        }
        else {
            char mess;

            close(pipe_one[1]); // Close the write end of parent-to-child pipe
            read(pipe_one[0], &mess, 1); // Read from parent-to-child pipe

            printf("%d: received ping\n", getpid());
            
            close(pipe_one[0]); // Close the read end of parent-to-child pipe

            close(pipe_two[0]); // Close the read end of child-to-parent pipe
            write(pipe_two[1], &mess, 1); // Write to child-to-parent pipe
            close(pipe_two[1]); // Close the write end of child-to-parent pipe
        }
    }
    else { // Parent process
        if (check_pipe1 == -1 || check_pipe2 == -1) {
            printf("Cannot create pipe! - Error: pipe() function failed!");
            return 0;
        }
        else {
            char mess = 'T'; // Correct assignment for char type
            
            close(pipe_one[0]); // Close the read end of parent-to-child pipe
            write(pipe_one[1], &mess, 1); // Write to parent-to-child pipe
            close(pipe_one[1]); // Close the write end of parent-to-child pipe

            close(pipe_two[1]); // Close the write end of child-to-parent pipe
            read(pipe_two[0], &mess, 1); // Read from child-to-parent pipe

            printf("%d: received pong\n", getpid());
            
            close(pipe_two[0]); // Close the read end of child-to-parent pipe
        
            wait(0); // Wait for child process to finish
        }
    }
    return 0;
}
