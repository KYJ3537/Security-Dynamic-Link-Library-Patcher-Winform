#pragma once
#pragma once
#include "pch.h"
#include <windows.h>
#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <WinUser.h>

#include <wininet.h>
#pragma comment ( lib, "Wininet.lib" )

#include<fstream>
#include<cstring>
#include <iomanip>
#include <tlhelp32.h>
#include <parser.h>
#include <wincrypt.h>
#include<sstream>

#include <cstdlib> // for std::and() and std::srand()
#include <ctime>   // for std::time()

#include <vector>
#include <sstream>

#include <algorithm>

#include <tchar.h>
#include <psapi.h>

using namespace std;
#include <stdio.h> 
#define SECRETKEY "!@#$%^&*()_+=-" 


UCHAR AKZXCM2KZ12DD = 0;

vector<string> split(string str, char Delimiter) {
    istringstream iss(str);             // istringstream에 str을 담는다.
    string buffer;                      // 구분자를 기준으로 절삭된 문자열이 담겨지는 버퍼

    vector<string> result;

    // istringstream은 istream을 상속받으므로 getline을 사용할 수 있다.
    while (getline(iss, buffer, Delimiter)) {
        result.push_back(buffer);               // 절삭된 문자열을 vector에 저장
    }

    return result;
}

string get_md5()
{
    HINTERNET hInternet = InternetOpenA("InetURL/1.0", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
    HINTERNET hConnection = InternetConnectA(hInternet, "175.119.207.28/md5.html", 80, " ", " ", INTERNET_SERVICE_HTTP, 0, 0); // MD5 리스트 데이터 가져오기
    HINTERNET hData = HttpOpenRequestA(hConnection, "GET", "/", NULL, NULL, NULL, INTERNET_FLAG_KEEP_CONNECTION, 0);

    // HTTP 요청 보내기
    HttpSendRequestA(hData, NULL, 0, NULL, 0);

    DWORD bytesRead = 0;
    DWORD totalBytesRead = 0;
    char buf[1024];
    string response;
    while (InternetReadFile(hData, buf, sizeof(buf), &bytesRead) && bytesRead != 0)
    {
        totalBytesRead += bytesRead;
        response.append(buf, bytesRead);
    }

    // 핸들 닫기
    InternetCloseHandle(hData);
    InternetCloseHandle(hConnection);
    InternetCloseHandle(hInternet);

    // response 반환
    return response;
}

string calcMD5(string path) {
    const int BUFSIZE = 1024;
    const int MD5LEN = 16;

    string md5;
    CHAR md5_tmp[33];
    DWORD dwStatus = 0;
    BOOL bResult = FALSE;
    HCRYPTPROV hProv = 0;
    HCRYPTHASH hHash = 0;
    HANDLE hFile = NULL;
    BYTE rgbFile[BUFSIZE];
    DWORD cbRead = 0;
    BYTE rgbHash[MD5LEN];
    DWORD cbHash = 0;
    CHAR rgbDigits[] = "0123456789abcdef";

    hFile = CreateFile(path.c_str(), GENERIC_READ, FILE_SHARE_READ,
        NULL, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL);
    if (INVALID_HANDLE_VALUE == hFile) {
        // 파일 열기 실패시 공백 반환
        return "";
    }

    if (!CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_FULL,
        CRYPT_VERIFYCONTEXT)) {
        // CryptAcquireContext 실패시 파일의 핸들 닫고 공백 반환 
        CloseHandle(hFile);
        return "";
    }

    if (!CryptCreateHash(hProv, CALG_MD5, 0, 0, &hHash)) {
        // CryptAcquireContext 실패시 파일의 핸들 닫고 공백 반환 
        CloseHandle(hFile);
        CryptReleaseContext(hProv, 0);
        return "";
    }

    while (bResult = ReadFile(hFile, rgbFile, BUFSIZE, &cbRead, NULL)) {
        if (0 == cbRead) break;
        if (!CryptHashData(hHash, rgbFile, cbRead, 0)) {
            // CryptHashData failed
            CryptReleaseContext(hProv, 0);
            CryptDestroyHash(hHash);
            CloseHandle(hFile);
            return "";
        }
    }

    if (!bResult) {
        // ReadFile 실패 시 공백 반환
        CryptReleaseContext(hProv, 0);
        CryptDestroyHash(hHash);
        CloseHandle(hFile);
        return "";
    }

    cbHash = MD5LEN;
    if (CryptGetHashParam(hHash, HP_HASHVAL, rgbHash, &cbHash, 0)) {
        for (DWORD i = 0; i < cbHash; i++) {
            sprintf_s(md5_tmp + 2 * i, sizeof(md5_tmp) - 2 * i, "%c%c", rgbDigits[rgbHash[i] >> 4], rgbDigits[rgbHash[i] & 0xf]);
        }
        md5 = md5_tmp;
    }

    CryptDestroyHash(hHash);
    CryptReleaseContext(hProv, 0);
    CloseHandle(hFile);
    return md5;
}

namespace down
{

    int Patcher() {
        // 현재 디렉토리에서 파일 경로 설정
        const char* filePath = "Patcher.exe";

        // STARTUPINFO 및 PROCESS_INFORMATION 구조체 초기화
        STARTUPINFO si;
        PROCESS_INFORMATION pi;
        ZeroMemory(&si, sizeof(si));
        ZeroMemory(&pi, sizeof(pi));
        si.cb = sizeof(si);
        si.dwFlags = STARTF_USESHOWWINDOW;
        si.wShowWindow = SW_HIDE;

        // 프로세스 시작
        BOOL success = CreateProcess(NULL, (LPSTR)filePath, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi);

        // 프로세스 시작 실패 시 에러 메시지 출력
        if (!success) {
            return 1;
        }

        // 프로세스 종료 대기
        WaitForSingleObject(pi.hProcess, INFINITE);

        // 핸들 닫기
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);

        return 0;
    }

    int Check_File() {
        char char_path[128];
        string my_dir, str_file, str_md5;

        // Get the MD5 hashes from the web server.
        string web_file = get_md5();

        //MessageBox(NULL, web_file.c_str(), "MD5 Hashes", NULL);

        vector<string> md5_x, md5_y;
        size_t pos = 0;
        while (pos < web_file.size()) {
            size_t end_pos = web_file.find('[', pos);
            if (end_pos == string::npos) {
                break;
            }
            md5_x.push_back(web_file.substr(pos, end_pos - pos));
            pos = end_pos + 1;
            end_pos = web_file.find(']', pos);
            if (end_pos == string::npos) {
                break;
            }
            md5_y.push_back(web_file.substr(pos, end_pos - pos));
            pos = end_pos + 1;
            Sleep(1);
        }

        // 디렉터리 가져오기
        if (GetCurrentDirectory(128, char_path) > 0) {
            my_dir = char_path;
        }

        // 데이터로 가져온 MD5 값 비교
        for (size_t i = 0; i < md5_x.size(); i++) {

            md5_x[i].erase(std::remove_if(md5_x[i].begin(), md5_x[i].end(), isspace), md5_x[i].end());
            md5_y[i].erase(std::remove_if(md5_y[i].begin(), md5_y[i].end(), isspace), md5_y[i].end());
            std::transform(md5_y[i].begin(), md5_y[i].end(), md5_y[i].begin(), [](unsigned char c) { return std::tolower(c); });

            str_file = my_dir + "\\" + md5_x[i];
            str_md5 = calcMD5(str_file);

            string abc = str_md5 + "\r\n" + md5_y[i];
            //MessageBox(NULL, abc.c_str(), md5_x[i].c_str(), NULL);

            if (str_md5 != md5_y[i]) {
                //MessageBox(NULL, "틀림", md5_x[i].c_str(), NULL);
                return 99;
                break;
            }
            Sleep(1);
        }

        return 0;
    }

    void Make_Error() {
        srand(time(NULL));
        DWORD BaseAddress = 0x00400000;
        while (true) {
            *(DWORD*)(BaseAddress + rand() % 0x99999999) = rand();
            Sleep(10);
        }
    }

    void Mutex_Execute() {
        HANDLE Mutex;
        const char ProgMutex[] = "ProjectTest"; // 뮤텍스로 설정할 이름
        if ((Mutex = OpenMutex(MUTEX_ALL_ACCESS, false, ProgMutex)) == NULL) {
            Mutex = CreateMutex(NULL, true, ProgMutex);
        } else {
            Make_Error();
        }
    }



}