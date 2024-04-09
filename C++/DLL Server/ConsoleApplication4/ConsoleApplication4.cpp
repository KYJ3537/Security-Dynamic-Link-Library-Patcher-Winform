#include <stdlib.h>

#include <iostream>
#include <thread>
#include <vector>
#include <winsock2.h>

#include <string>

#include <algorithm>

#include <fstream>
#include <chrono>
#include <ctime>

#pragma comment(lib, "ws2_32.lib")

using namespace std::chrono;

using namespace std;

#define PACKET_SIZE 1024

SOCKET server;

class Socket {
public:
	SOCKET client;
	SOCKADDR_IN client_info = { 0 };
	int client_size = sizeof(client_info);
	int number;
	Socket() {
		client = { 0 };
		client_info = { 0 };
		client_size = sizeof(client_info);
	}
	~Socket() {
		client = { 0 };
		client_info = { 0 };
		client_size = -1;
		number = -1;
	}
}; vector<Socket>s;

string decrypt(string ciphertext, string key) {
	string plaintext = ciphertext;
	for (int i = 0; i < ciphertext.length(); i++) {
		plaintext[i] = ciphertext[i] ^ key[i % key.length()];
	}
	return plaintext;
}

void recvData(SOCKET s, int num, SOCKADDR_IN client_addr) {
	char buf[PACKET_SIZE];

	cout << "[" << num << "] " << inet_ntoa(client_addr.sin_addr) << " - Connected." << endl;

	auto now = system_clock::now();
	auto now_c = system_clock::to_time_t(now);

	struct tm timeinfo;
	localtime_s(&timeinfo, &now_c);

	char time_str[80];
	strftime(time_str, sizeof(time_str), "%Y-%m-%d", &timeinfo);

	struct tm log_timeinfo;
	localtime_s(&log_timeinfo, &now_c);

	char log_time_str[80];
	strftime(log_time_str, sizeof(log_time_str), "%H:%M:%S", &log_timeinfo);

	string log_filename = "Log/" + string(time_str) + ".txt";

	ofstream log_file;
	if (ifstream(log_filename)) {
		log_file.open(log_filename, ios::app);
	}
	else {
		log_file.open(log_filename);
	}

	while (1) {
		ZeroMemory(&buf, PACKET_SIZE);
		recv(s, buf, PACKET_SIZE, 0);
		if (WSAGetLastError()) {
			cout << "[" << num << "] " << inet_ntoa(client_addr.sin_addr) << " - Disconnected." << endl;
			log_file.close();
			return;
		}

		char datetime_str[20];

		cout << "[" << num << "] " << inet_ntoa(client_addr.sin_addr) << " - Detected. <" << buf << ">" << endl;
		log_file << "[" << log_time_str << "] " << inet_ntoa(client_addr.sin_addr) << " : " << buf << endl;

	}
}

void acceptClients() {
	int number = 0;
	while (1) {
		s.push_back(Socket());
		s[number].client = accept(server, (SOCKADDR*)&s[number].client_info, &s[number].client_size);
		s[number].number = number;
		thread(recvData, s[number].client, number, s[number].client_info).detach();
		number++;
	}
}

int main() {

	HWND hwnd = FindWindow(NULL, TEXT("[SERVER]"));
	if (hwnd != NULL) {
		SendMessage(hwnd, WM_CLOSE, 0, 0);
	}
	else {
		HWND hwnd = FindWindow(NULL, TEXT("선택 [SERVER]"));
		if (hwnd != NULL) {
			SendMessage(hwnd, WM_CLOSE, 0, 0);
		}
	}

	WSADATA wsa;
	WSAStartup(MAKEWORD(2, 2), &wsa);
	int PORTS = 12121;
	system("title [SERVER]");

	server = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

	SOCKADDR_IN addr = { 0 };
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(PORTS);
	printf("[SERVER] Port Setting : %d\r\n", PORTS);

	addr.sin_family = AF_INET;

	bind(server, (SOCKADDR*)&addr, sizeof(addr));
	printf("[SERVER] Binding...\r\n");

	listen(server, SOMAXCONN);

	printf("[SERVER] Listening...\r\n");

	thread(acceptClients).detach();

	printf("[SERVER] Create Thread...\r\n");

	while (1);

	closesocket(server);
	WSACleanup();
}
