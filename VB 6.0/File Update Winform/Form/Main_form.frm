VERSION 5.00
Begin VB.Form Main 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  '없음
   Caption         =   "Cat.s Patcher"
   ClientHeight    =   5640
   ClientLeft      =   -60
   ClientTop       =   -120
   ClientWidth     =   7875
   BeginProperty Font 
      Name            =   "맑은 고딕"
      Size            =   9
      Charset         =   129
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5640
   ScaleWidth      =   7875
   StartUpPosition =   2  '화면 가운데
   Begin VB.Timer Shell_Timer 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   2040
      Top             =   2280
   End
   Begin VB.Timer Load_List_Timer 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   1560
      Top             =   2280
   End
   Begin VB.Timer Download_Timer 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   1080
      Top             =   2280
   End
   Begin VB.ListBox FileName_List 
      Height          =   1410
      Left            =   8640
      TabIndex        =   3
      Top             =   2520
      Visible         =   0   'False
      Width           =   5175
   End
   Begin VB.ListBox GetData_List 
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   9
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1140
      Left            =   8640
      TabIndex        =   0
      Top             =   3960
      Visible         =   0   'False
      Width           =   5175
   End
   Begin VB.Image Image5 
      Height          =   300
      Left            =   885
      Picture         =   "Main_form.frx":0000
      Top             =   4050
      Visible         =   0   'False
      Width           =   6330
   End
   Begin VB.Image Image6 
      Height          =   300
      Left            =   885
      Picture         =   "Main_form.frx":4251
      Top             =   4395
      Visible         =   0   'False
      Width           =   6330
   End
   Begin VB.Image bg_img 
      Height          =   2700
      Left            =   10
      Picture         =   "Main_form.frx":84A2
      Top             =   450
      Width           =   7470
   End
   Begin VB.Image Image3 
      Height          =   315
      Left            =   6400
      Picture         =   "Main_form.frx":2D1F9
      Top             =   5070
      Width           =   825
   End
   Begin VB.Image Image4 
      Height          =   225
      Left            =   7155
      Picture         =   "Main_form.frx":30521
      Top             =   120
      Width           =   225
   End
   Begin VB.Image can2 
      Height          =   315
      Left            =   8760
      Picture         =   "Main_form.frx":33397
      Top             =   720
      Width           =   825
   End
   Begin VB.Image can1 
      Height          =   315
      Left            =   8760
      Picture         =   "Main_form.frx":36584
      Top             =   360
      Width           =   825
   End
   Begin VB.Image can3 
      Height          =   315
      Left            =   8760
      Picture         =   "Main_form.frx":39778
      Top             =   1080
      Width           =   825
   End
   Begin VB.Image x2 
      Height          =   225
      Left            =   9000
      Picture         =   "Main_form.frx":3CAA0
      Top             =   0
      Width           =   225
   End
   Begin VB.Image x1 
      Height          =   225
      Left            =   8760
      Picture         =   "Main_form.frx":3F884
      Top             =   0
      Width           =   225
   End
   Begin VB.Image x3 
      Height          =   225
      Left            =   9240
      Picture         =   "Main_form.frx":42668
      Top             =   0
      Width           =   225
   End
   Begin VB.Image Image2 
      Height          =   450
      Left            =   0
      Top             =   0
      Width           =   7575
   End
   Begin VB.Label FileName_label 
      BackColor       =   &H00FFFFFF&
      Caption         =   "FileName"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   9
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   8640
      TabIndex        =   5
      Top             =   2160
      Visible         =   0   'False
      Width           =   5175
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      BackStyle       =   0  '투명
      Caption         =   "업데이트 기능 구현 용도의 포트폴리오 프로젝트입니다."
      ForeColor       =   &H00666666&
      Height          =   225
      Left            =   360
      TabIndex        =   4
      Top             =   5130
      Width           =   4485
   End
   Begin VB.Label State_Label 
      AutoSize        =   -1  'True
      BackStyle       =   0  '투명
      Caption         =   "데이터 파일 불러오는 중..."
      Height          =   225
      Left            =   360
      TabIndex        =   2
      Top             =   3360
      Width           =   2115
   End
   Begin VB.Label need_update_num_label 
      AutoSize        =   -1  'True
      BackStyle       =   0  '투명
      Caption         =   "현재 필요한 업데이트 파일 갯수 : 0/0"
      Height          =   225
      Left            =   8640
      TabIndex        =   1
      Top             =   1800
      Visible         =   0   'False
      Width           =   5175
   End
   Begin VB.Image Image1 
      Height          =   5505
      Left            =   0
      Picture         =   "Main_form.frx":454DE
      Top             =   0
      Width           =   7500
   End
End
Attribute VB_Name = "Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Implements IBindStatusCallback

Option Explicit

Private Hash As New MD5Hash
Private strFile As String
Private bytBlock() As Byte
Private Declare Sub sleep Lib "kernel32.dll" Alias "Sleep" (ByVal dwMilliseconds As Long)
Dim DownNum As Integer

Private Declare Function SetWindowPos Lib "User32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Private Const HWND_TOPMOST = -1
Private Const SWP_NOSIZE = &H1
Private Const SWP_NOMOVE = &H2
Private Const SWP_SHOWWINDOW = &H40

Private Declare Function SendMessage Lib "User32" Alias "SendMessageA" _
(ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Sub ReleaseCapture Lib "User32" ()
Const WM_NCLBUTTONDOWN = &HA1
Const HTCAPTION = 2
Dim MyAddress As String
Dim Form_TitleName As String
Dim Progreess_Image_Width As Integer
Private Declare Function URLDownloadToFile Lib "urlmon" Alias "URLDownloadToFileA" (ByVal pCaller As Long, ByVal szURL As String, ByVal szFileName As String, ByVal dwReserved As Long, ByVal lpfnCB As Long) As Long
Sub IBindStatusCallback_GetBindInfo( _
grfBINDF As olelib.BINDF, _
pbindinfo As olelib.BINDINFO)
' Not used
End Sub
Function IBindStatusCallback_GetPriority() As Long
' Not used
End Function
Sub IBindStatusCallback_OnStartBinding( _
ByVal dwReserved As Long, _
ByVal pib As olelib.IBinding)
' Not used
End Sub
Sub IBindStatusCallback_OnDataAvailable( _
ByVal grfBSCF As olelib.BSCF, _
ByVal dwSize As Long, _
pformatetc As olelib.FORMATETC, _
pstgmed As olelib.STGMEDIUM)
' Not used
End Sub
Sub IBindStatusCallback_OnLowResource( _
ByVal reserved As Long)
' Not used
End Sub
Sub IBindStatusCallback_OnObjectAvailable( _
riid As olelib.UUID, _
ByVal punk As stdole.IUnknown)
' Not used
End Sub
Sub IBindStatusCallback_OnStopBinding( _
ByVal hresult As Long, ByVal szError As Long)
' Not used
End Sub
Private Sub LoadList()
On Error Resume Next
    Dim httpReq As New WinHttpRequest
    Dim strUrl As String
    Dim strHtml As String
    Dim arrData() As String
    Dim i As Integer
    
    ' 웹페이지 URL 설정
    strUrl = "http://" + MyAddress + "/md5.html" '
    
    ' WinHttpRequest를 사용하여 웹페이지 소스 가져오기
    httpReq.Open "GET", strUrl, False
    httpReq.Send
    strHtml = httpReq.ResponseText
    
    'MsgBox strHtml '가져온 내용 메세지박스 테스트
    
    ' 가져온 소스를 라인별로 분리하여 GetData_List에 등록
    arrData() = Split(strHtml, vbCrLf)
    For i = 0 To UBound(arrData)
        If Not arrData(i) = "" Then
            GetData_List.AddItem arrData(i)
        End If
    Next i
    
    '파일 검사 시작
    Scan
    
End Sub
Private Sub Form_Load()
On Error Resume Next

Dim Result As Long
Dim imgUrl As String

'폼 안의 내용 설정
Progreess_Image_Width = 6330

Me.Width = Image1.Width + 10
Me.Height = Image1.Height + 10
Image5.Width = 0
Image6.Width = 0

Form_TitleName = "Update Part"
MyAddress = "175.119.207.28"

'폼 라운드 둥글게
Result = CreateRoundRectRgn(0, 0, Me.Width / Screen.TwipsPerPixelX, _
             Me.Height / Screen.TwipsPerPixelY, 9, 9)
SetWindowRgn Me.hwnd, Result, True

'프로세스 종료
EndProcess

'필요 다운로드 파일 개수 초기화
DownNum = 0

'데이터 가져오는 함수를 가진 타이머 작동
Load_List_Timer.Enabled = True

End Sub
Private Sub Form_Resize()
Me.Width = Image1.Width + 10
Me.Height = Image1.Height + 10
End Sub
Private Sub EndProcess()
On Error Resume Next

    ' WMI를 사용하여 ProjectTest.exe 프로세스 종료
    Dim wmiService As Object
    Set wmiService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")

    Dim processList As Object
    Set processList = wmiService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'ProjectTest.exe'")

    Dim process As Object
    For Each process In processList
        process.Terminate
    Next

    ' Shell 함수를 사용하여 ProjectTest.exe 프로세스가 실행 중이면 강제 종료
    Shell "taskkill /f /im ProjectTest.exe", vbHide
End Sub
Private Sub DownloadList()
On Error Resume Next

Dim str As String

Dim i As Integer
Dim Downstatus As Integer
Dim TotalWidth As Integer

Downstatus = 0
TotalWidth = Int(Progreess_Image_Width / DownNum)

Image5.Visible = True
Image6.Visible = True

For i = 0 To FileName_List.ListCount
    str = FileName_List.List(i)
    
    If InStr(str, "\") > 0 Then
        str = Right(str, Len(str) - InStrRev(str, "\"))
    End If

    FileName_label.Caption = str
    URLDownloadToFileW Me, "http://" & MyAddress & "/File/" & FileName_List.List(i), App.Path & "\" & FileName_List.List(i), 0&, Me
    
    Downstatus = Downstatus + 1
    Image6.Width = i * TotalWidth
    
    need_update_num_label.Caption = "현재 필요한 업데이트 파일 갯수 : " & i & "/" & DownNum
    
    DoEvents
    
Next i

Image6.Width = Progreess_Image_Width
State_Label.Caption = "모든 파일을 최신버전으로 업데이트했습니다 !"
Shell_Timer.Enabled = True
'End
End Sub
Private Sub Scan()
On Error Resume Next
Dim i As Long
Dim HashString As String

Dim SameString As String
State_Label.Caption = "모든 파일을 검사하고 있습니다."
For i = 0 To GetData_List.ListCount

    Dim item As String
    item = GetData_List.List(i)
    
    ' [를 기준으로 자르기
    Dim tokens1() As String
    tokens1 = Split(item, "[")
    Dim leftPart As String
    leftPart = tokens1(0)
    
    ' ]를 기준으로 자르기
    Dim tokens2() As String
    tokens2 = Split(tokens1(1), "]")
    Dim rightPart As String
    rightPart = tokens2(0)
    
    If SameString = leftPart Then
    Else
        HashString = Hash.HashFile(App.Path & "\" & leftPart)
        If HashString = rightPart Then
        Else
            FileName_List.AddItem leftPart
        End If
    End If
    
    SameString = leftPart
    DoEvents
    
Next i

DownNum = FileName_List.ListCount

If DownNum = 0 Then
State_Label.Caption = "현재 파일이 모두 최신 상태입니다 !"
Else
need_update_num_label.Caption = "현재 필요한 업데이트 파일 갯수 : 0/" & DownNum
Download_Timer.Enabled = True
End If
End Sub
Private Sub Form_Unload(Cancel As Integer)
'작업 중인 것을 중지하고 완전 종료
End
End Sub
Private Sub IBindStatusCallback_OnProgress(ByVal ulProgress As Long, ByVal ulProgressMax As Long, ByVal ulStatusCode As olelib.BINDSTATUS, ByVal szStatusText As Long)
    ' 다운로드 받을 파일 사이트가 0을 초과할때.
    If ulProgressMax > 0 Then
        ' 퍼센테이지
        Dim percent As Single
        percent = Int((ulProgress / ulProgressMax) * 100)
        If FileName_label.Caption = "" Then
            State_Label.Caption = "다운로드 데이터 정리 중..."
            Image5.Width = Int((ulProgress / ulProgressMax) * Progreess_Image_Width)
        Else
            State_Label.Caption = FileName_label.Caption & " 파일 다운로드 : " & percent & "%"
            Image5.Width = Int((ulProgress / ulProgressMax) * Progreess_Image_Width)
        End If
    End If
    DoEvents
End Sub
Private Sub Image3_Click()
    If MsgBox("정말로 종료하시겠습니까?", vbYesNo, Form_TitleName) = vbYes Then
        End
    Else
    End If
End Sub
Private Sub Image4_Click()
    If MsgBox("정말로 종료하시겠습니까?", vbYesNo, Form_TitleName) = vbYes Then
        End
    Else
    End If
End Sub
Private Sub Download_Timer_Timer()
On Error Resume Next
If DownNum > 0 Then
    If MsgBox("현재 " & DownNum & "개의 파일 업데이트가 필요합니다." & vbCrLf & "업데이트를 진행하시겠습니까?" & vbCrLf & vbCrLf & "아니오를 누를 시 프로그램이 종료됩니다.", vbYesNo, Form_TitleName) = vbYes Then
        SetTopMost Me.hwnd
        DownloadList
    Else
        End
    End If
End If
Download_Timer.Enabled = False
End Sub
Private Sub SetTopMost(ByVal hwnd As Long)
On Error Resume Next
    ' hwnd 매개변수는 폼의 윈도우 핸들
    ' 창을 최상위 윈도우로 설정
    SetWindowPos hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE Or SWP_SHOWWINDOW
End Sub
Private Sub Load_List_Timer_Timer()
On Error Resume Next
LoadList
Load_List_Timer.Enabled = False
End Sub
Private Sub Shell_Timer_Timer()
On Error Resume Next
If MsgBox("메인 프로젝트를 실행하시겠습니까?", vbYesNo, "안내") = vbYes Then
Shell App.Path & "\ProjectTest.exe", vbNormalFocus
Unload Me
Else
Shell_Timer.Enabled = False
End If
End Sub
Private Sub bg_img_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
'버튼 상태 돌리기
    Image4.Picture = x3.Picture
    Image3.Picture = can3.Picture
End Sub
Private Sub Image2_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim lngReturnValue As Long
    Image4.Picture = x3.Picture
    Image3.Picture = can3.Picture
 If Button = 1 Then
  Call ReleaseCapture
  lngReturnValue = SendMessage(Me.hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&)
 End If
End Sub
Private Sub Image1_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
'버튼 상태 돌리기
    Image4.Picture = x3.Picture
    Image3.Picture = can3.Picture
End Sub
Private Sub Label3_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
'버튼 상태 돌리기
    Image4.Picture = x3.Picture
    Image3.Picture = can3.Picture
End Sub
Private Sub State_Label_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
'버튼 상태 돌리기
    Image4.Picture = x3.Picture
    Image3.Picture = can3.Picture
End Sub

Private Sub Image4_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Image4.Picture = x1.Picture
End Sub

Private Sub Image4_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Image4.Picture = x2.Picture
End Sub '
Private Sub Image4_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Image4.Picture = x3.Picture
End Sub

Private Sub Image4_MouseHover(Index As Integer)
    Image4.Picture = x1.Picture
End Sub

Private Sub Image4_MouseLeave(Index As Integer)
    Image4.Picture = x3.Picture
End Sub

Private Sub Image4_MouseCaptureChanged()
    Image4.Picture = x2.Picture
End Sub
''''''
Private Sub Image3_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Image3.Picture = can1.Picture
End Sub

Private Sub Image3_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Image3.Picture = can2.Picture
End Sub '
Private Sub Image3_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    Image3.Picture = can3.Picture
End Sub

Private Sub Image3_MouseHover(Index As Integer)
    Image3.Picture = can1.Picture
End Sub

Private Sub Image3_MouseLeave(Index As Integer)
    Image3.Picture = can3.Picture
End Sub

Private Sub Image3_MouseCaptureChanged()
    Image3.Picture = can2.Picture
End Sub


