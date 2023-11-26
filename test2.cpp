#include <iostream>
#include <vector>

using namespace std;

const int ALPHABET_LEN = 26;
const int ASCII_A = 65;

int main() {
    std::string decrypted_string;

    std::string cipher = "ABCXYZ";
//    int shift = 3;
    size_t shift = 3;


    for (char i : cipher) {
        size_t new_value = (((static_cast<int>(i) - ASCII_A - shift) % ALPHABET_LEN) + ALPHABET_LEN) % ALPHABET_LEN + ASCII_A;
        decrypted_string.push_back(static_cast<char>(new_value));
    }
    cout << decrypted_string;
    return 0;
}