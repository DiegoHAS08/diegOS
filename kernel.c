int strlen(const char* str){
    int len = 0;

    while (str[len]) {
        len++;
    }

    return len;
}

void kernel_main(){


    char* video_memory = (char*) 0xB8000;

    const char* str = "Bem vindo ao diegOS!";

    int len = strlen(str);

    for(int i = 0; i < 80 * 25 * 2; i += 2) {

        video_memory[i] = ' ';
        video_memory[i+1] = 0x07;
    }

    for (int i = 0; i < len; i++) {

        video_memory[i * 2] = str[i];

        video_memory[i * 2 + 1] = 0x0A;

    }
}