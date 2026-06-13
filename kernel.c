int strlen(const char* str){
    int len = 0;

    while (str[len]) {
        len++;
    }

    return len;
}

static inline unsigned char inb(unsigned short port){
    unsigned char result;

    __asm__ volatile (
        "inb %1, %0"
        : "=a"(result)
        : "Nd"(port)
    );

    return result;
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

    char keyboard_map[128] = {
        0,
        27,
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
        '-', '=',
        '\b',
        '\t',
        'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
        '[', ']',
        '\n',
        0,
        'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
        ';', '\'',
        '`',
        0,
        '\\',
        'z', 'x', 'c', 'v', 'b', 'n', 'm',
        ',', '.', '/',
        0,
        '*',
        0,
        ' '
    };

    int cursor = len; 
    
    unsigned char ultima_tecla = 0;

    while (1)
    {
       if (inb(0x64) & 1) {
           unsigned char scancode = inb(0x60);

           if (scancode & 0x80) {
               ultima_tecla = 0;
           } 
           else if (scancode < 128 && scancode != ultima_tecla) {
                ultima_tecla = scancode;
                char c = keyboard_map[scancode];
                
                if (c) {
                    video_memory[cursor * 2] = c;
                    video_memory[cursor * 2 + 1] = 0x0F;
                    cursor++;
                }
           }
       }
       
       if (cursor >= 80 * 25) {
           cursor = 0;
       }
    }
}