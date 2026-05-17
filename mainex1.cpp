#include <windows.h>
#include <iostream>
#include <string>
#include <vector>

int main() {
    HKEY hKeyRoot = HKEY_CURRENT_USER;
    LPCSTR subKey = "SOFTWARE";
    HKEY hKey;

    // Deschidem cheia cu drepturi de citire
    LONG openStatus = RegOpenKeyExA(hKeyRoot, subKey, 0, KEY_READ, &hKey);

    if (openStatus == ERROR_SUCCESS) {
        std::cout << "subcheile HKEY_CURRENT_USER\\" << subKey << " :\n";
        std::cout << "-----\n";

        DWORD dwIndex = 0;
        char achKey[256];   
        DWORD cbName = 256;    

        while (RegEnumKeyExA(hKey, dwIndex, achKey, &cbName, NULL, NULL, NULL, NULL) == ERROR_SUCCESS) {
            std::cout << dwIndex + 1 << ". " << achKey << "\n";
            
            cbName = 256; 
            dwIndex++;
        }

        RegCloseKey(hKey);
        std::cout << "\nsubchei gasite: " << dwIndex << "\n";
    } else {
        std::cerr << "eroare. cod eroare: " << openStatus << "\n";
    }

    return 0;
}