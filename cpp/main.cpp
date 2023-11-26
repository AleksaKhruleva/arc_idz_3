#include <iostream>

#define FILE_BUFF_SIZE 512
char *file_buffer;
size_t file_buffer_len;
#define WORDS_MAX 5
char *words[WORDS_MAX] = {"include", "define", "void", "int", "char"};
int words_count[WORDS_MAX] = {0, 0, 0, 0, 0};

bool iscsymb(char chr) {
    return isalnum(chr) || chr == '_';
}

#define ACS 8
struct {
    int state = 0;
    size_t acs = ACS;
    size_t acl{};
    char act[ACS]{};
} wa;

void func2() {
    wa.act[wa.acl] = '\0';
    std::cout << wa.act << std::endl;
    for (int i = 0; i < WORDS_MAX; ++i) {
        if (strcmp(wa.act, words[i]) == 0) {
            words_count[i]++;
        }
    }
}

void func1() {
    char ch;
    if (file_buffer_len == 0) return;
    for (int i = 0; i < file_buffer_len; ++i) {
        ch = file_buffer[i];
        if (wa.state == 0) {
            if (iscsymb(ch)) {
                wa.act[wa.acl] = ch;
                wa.acl++;
                if (wa.acl == wa.acs) {
                    wa.acl = 0;
                    wa.state = 2;
                }
            } else {
                func2();
                wa.state = 1;
            }
        } else if (wa.state == 1) {
            if (iscsymb(ch)) {
                wa.state = 0;
                wa.acl = 0;
                wa.act[wa.acl] = ch;
                wa.acl++;
            }
        } else if (wa.state == 2) {
            if (iscsymb(ch)) {
            } else {
                wa.state = 0;
                wa.acl = 0;
            }
        }
    }
}

int main() {
    std::cout << "Hello, World!" << std::endl;

    file_buffer = (char *) malloc(FILE_BUFF_SIZE);

    FILE *file = fopen("../../test1.cpp", "rb");

    while ((file_buffer_len = fread(file_buffer, 1, FILE_BUFF_SIZE, file))) {
        std::cout << file_buffer_len << std::endl;
        func1();
    }

    std::cout << words_count[0]
              << "\t" << words_count[1]
              << "\t" << words_count[2]
              << "\t" << words_count[3]
              << "\t" << words_count[4]
              << std::endl;
    return 0;
}
