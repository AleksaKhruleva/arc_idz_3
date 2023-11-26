#include <iostream>
using namespace std;

int main() {
    string str = "        s     ";
    cout << str << endl;
    if (str.length() == 0) {
        return true;
    }
    uint64_t ind_s = 0;
    uint64_t ind_e = str.length() - 1;
    while (ind_s < ind_e) {
        if (str[ind_s] == ' ') {
            ++ind_s;
            continue;
        }
        if (str[ind_e] == ' ') {
            --ind_e;
            continue;
        }
        if (str[ind_s] != str[ind_e]) {
            return false;
        }
        ++ind_s;
        --ind_e;
    }
    return true;
}
