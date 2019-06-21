In order to use these git scripts, you will need to move them to a bin folder on your computer. The way to do this is as follows. 

1. Open up git bash. 
2. Navigate to your user directory using the command:    cd ~ 
3. Make a directory called bin here using:    mkdir bin 
4. Then, you have to export your bin directory to the PATH. This means navigating to C://--> Users--> yourusername. In this folder, you should find a bash history file. It will be called bash_history or .bash_profile and it is just a text file. If it doesn't exist, create it. In the file, add the following line: export PATH=$PATH:/Users/tania/bin.
5. Save and close the file, and close and reopen git bash. This updates the path. 
6. Move the files from the local repository to the bin folder. 
7. To run, in git bash, just type the file name. 
8. As a test, try hello-world. Just typing hello-world in git bash should run the script and give you a prompt. 