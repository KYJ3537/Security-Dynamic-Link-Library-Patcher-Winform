#include "pch.h"
#include "down.h"

#include <windows.h>
#include <String.h>
#include <string>
#include <iostream>
#include <sstream>
#include <wincrypt.h>
#include <iostream>
#include <string>
#include <thread>

#include <algorithm>

#include <winsock2.h>
#pragma comment(lib, "ws2_32.lib")
#define PACKET_SIZE 1024

using namespace std;

DWORD use = 0;

vector<string> Name_C;

int check_num = 0;

HANDLE file_Thread = NULL;

std::string MyHWID = "NULL";

int getID()
{
    DWORD volume_serial_number;
    DWORD max_component_length;
    DWORD file_system_flags;
    char volume_name_buffer[MAX_PATH];
    DWORD volume_name_size = MAX_PATH;

    if (!GetVolumeInformation(
        "C:\\",                    // 드라이브 문자열
        volume_name_buffer,        // 드라이브 이름 버퍼
        volume_name_size,          // 드라이브 이름 버퍼 크기
        &volume_serial_number,     // 드라이브 고유 번호
        &max_component_length,     // 파일 이름의 최대 길이
        &file_system_flags,        // 파일 시스템 플래그
        NULL,                      // 파일 시스템 이름 버퍼
        0                         // 파일 시스템 이름 버퍼 크기
    ))
    {
        return 1;
    }

    std::stringstream ss;
    ss << std::hex << volume_serial_number;  // 16진수로 변환
    MyHWID = ss.str() + "/";             // std::string으로 변환

    std::cout << MyHWID << std::endl;

    return 0;
}

vector<string> get_hd_lines()
{
    HINTERNET hInternet = InternetOpenA("InetURL/1.0", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
    HINTERNET hConnection = InternetConnectA(hInternet, "175.119.207.28/hwid.html", 80, " ", " ", INTERNET_SERVICE_HTTP, 0, 0); // 블락 등록한 하드번호 리스트 가져오기
    HINTERNET hData = HttpOpenRequestA(hConnection, "GET", "/", NULL, NULL, NULL, INTERNET_FLAG_KEEP_CONNECTION, 0);

    // Send the HTTP request.
    HttpSendRequestA(hData, NULL, 0, NULL, 0);

    // Read the response and store it in a vector of strings.
    DWORD bytesRead = 0;
    DWORD totalBytesRead = 0;
    char buf[1024];
    vector<string> response;
    string line;
    while (InternetReadFile(hData, buf, sizeof(buf), &bytesRead) && bytesRead != 0)
    {
        for (DWORD i = 0; i < bytesRead; i++)
        {
            if (buf[i] == '\n')
            {
                response.push_back(line);
                line.clear();
            }
            else if (buf[i] != '\r')
            {
                line += buf[i];
            }
        }
        totalBytesRead += bytesRead;
    }
    if (!line.empty())
    {
        response.push_back(line);
    }

    // Close the handles.
    InternetCloseHandle(hData);
    InternetCloseHandle(hConnection);
    InternetCloseHandle(hInternet);

    // Return the response lines.
    return response;
}

BOOL injectedThread() {
    while (true) {
        *(DWORD*)(0x009BC898) = 0x8B510B6A;
        Sleep(100);
    }
}

string encrypt(string plaintext, string key) {
    string ciphertext = plaintext;
    for (int i = 0; i < plaintext.length(); i++) {
        ciphertext[i] = plaintext[i] ^ key[i % key.length()];
    }
    return ciphertext;
}

static BOOL CALLBACK enumWindowCallback(HWND hWnd, LPARAM lparam) {
    SOCKET* server = (SOCKET*)lparam;

    int length = GetWindowTextLength(hWnd);
    char buffer[1024];
    GetWindowText(hWnd, buffer, length + 1);
    std::string windowTitle(buffer);

    if (IsWindowVisible(hWnd) && length != 0) {

        //윈도우 타이틀 해당 단어 검출 시
        if (windowTitle.find("Packet") != string::npos ||
            windowTitle.find("Trainer") != string::npos ||
            windowTitle.find("oopscrasher") != string::npos ||
            windowTitle.find("Engine") != string::npos ||
            windowTitle.find("injector") != string::npos ||
            windowTitle.find("Injecter") != string::npos ||
            windowTitle.find("Sniff") != string::npos ||
            windowTitle.find("Macro") != string::npos ||
            windowTitle.find("AutoHotkey") != string::npos ||
            windowTitle.find("매크로") != string::npos ||
            windowTitle.find("치트") != string::npos ||
            windowTitle.find("Hacker") != string::npos ||
            windowTitle.find("리소스 모니터") != string::npos ||
            windowTitle.find("Cheat") != string::npos ||
            windowTitle.find("DDOS") != string::npos ||
            windowTitle.find("스니퍼") != string::npos ||
            windowTitle.find("메크로") != string::npos) {

            // 인터넷 창은 예외
            if (windowTitle.find("Edge") != string::npos || windowTitle.find("Chrome") != string::npos) {
            } else {
                //아니라면
                int a = 0;
                for (int i = 0; i < Name_C.size(); i++) {
                    if (Name_C[i] == windowTitle) {
                        a = 1;
                    }
                    Sleep(10);
                }
                if (a == 0 && windowTitle != "") {
                    Name_C.push_back(windowTitle);
                    std::string tempmsg = MyHWID + windowTitle;

                    char sendmsg[1024];
                    memset(sendmsg, 0, sizeof(sendmsg));
                    size_t length = tempmsg.length();
                    if (length > 1023) {
                        length = 1023;
                    }
                    memcpy(sendmsg, tempmsg.c_str(), length);
                    //하드디스크 고유 번호와 인터넷 창 이름을 서버에 보내기
                    send(*server, sendmsg, length, 0);

                    Sleep(5000);
                    check_num = 8;
                    down::Make_Error();
                }
            }
        }
        Sleep(10);
    }
    return TRUE;
}

DWORD WINAPI ThreadServer(LPVOID IParam) {

    vector<string> hd_lines = get_hd_lines();

    for (const string& line : hd_lines) {
        if (line + "/" == MyHWID) {
            check_num = 6;
            down::Make_Error();
        }
    }

    down::Mutex_Execute(); //뮤텍스

    return 0;
}

DWORD WINAPI ThreadCheck(LPVOID IParam) {
    while (true) {
        if (check_num == 0) {
        } else {
            down::Make_Error();
        }
        Sleep(5000);
    }
}

DWORD WINAPI ThreadFileCheck(LPVOID IParam) {
    int i = 0;
    while (i < 5) {
        if (down::Check_File() == 99) {
            down::Patcher();
            check_num = 1;
            down::Make_Error();
        }
        Sleep(60000);
        ++i;
    }
    return 0;
}

DWORD WINAPI ThreadCheat(LPVOID IParam) {
    SOCKET server = INVALID_SOCKET;
    WSADATA wsa;
    int result;

    // 소켓 초기화

    result = WSAStartup(MAKEWORD(2, 2), &wsa);
    if (result != 0) {
        // 오류 시 에러 함수 호출
        check_num = 2;
        down::Make_Error();
        return 1;
    }

    // 소켓 만들기
    server = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (server == INVALID_SOCKET) {
        // 오류 시 에러 함수 호출
        check_num = 3;
        down::Make_Error();
        WSACleanup();
        return 1;
    }

    struct hostent* host = gethostbyname("175.119.207.28"); // 소켓 연결할 아이피
    if (host == NULL) {
        // 오류 시 에러 함수 호출
        check_num = 4;
        down::Make_Error();
        closesocket(server);
        WSACleanup();
        return 1;
    }
    struct in_addr** addr_list = (struct in_addr**)host->h_addr_list;
    char* ip = inet_ntoa(*addr_list[0]);

    SOCKADDR_IN addr = { 0 };
    addr.sin_addr.s_addr = inet_addr(ip);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(12121);

    // 서버에 소켓 접속 시도
    result = connect(server, (SOCKADDR*)&addr, sizeof(addr));
    if (result == SOCKET_ERROR) {
        // 오류 시 에러 함수 호출
        check_num = 5;
        down::Make_Error();
        closesocket(server);
        WSACleanup();
        return 1;
    }

    // 윈도우 창 이름 감지 함수 호출 루프문
    while (true) {
        EnumWindows(enumWindowCallback, (LPARAM)&server);
        Sleep(1000);
    }

    // cleanup resources
    closesocket(server);
    WSACleanup();

    return 0;
}

__declspec(dllexport) BOOL APIENTRY DllMain(HMODULE hModule,
        DWORD  ul_reason_for_call,
        LPVOID lpReserved
    )
    {
        HANDLE hThread = NULL;
        HANDLE cThread = NULL;
        HANDLE srThread = NULL;
        HANDLE fThread = NULL;

        switch (ul_reason_for_call)
        {
        case DLL_PROCESS_ATTACH:
            
            //하드디스크 고유 번호 얻기
            getID();

            srThread = CreateThread(NULL, 0, ThreadCheck, NULL, 0, NULL);
            CloseHandle(srThread);
            hThread = CreateThread(NULL, 0, ThreadServer, NULL, 0, NULL);
            CloseHandle(hThread);
            fThread = CreateThread(NULL, 0, ThreadFileCheck, NULL, 0, NULL);
            cThread = CreateThread(NULL, 0, ThreadCheat, NULL, 0, NULL);

        case DLL_THREAD_ATTACH:
        case DLL_THREAD_DETACH:
        case DLL_PROCESS_DETACH:
            break;
        }
        return TRUE;
    }

