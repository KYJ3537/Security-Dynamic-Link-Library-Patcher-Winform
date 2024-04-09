VERSION 5.00
Begin VB.Form set_direction_form 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  '단일 고정
   Caption         =   "검사할 파일의 폴더 경로 설정"
   ClientHeight    =   1665
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8415
   BeginProperty Font 
      Name            =   "맑은 고딕"
      Size            =   9
      Charset         =   129
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "set_direction_form.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1665
   ScaleWidth      =   8415
   StartUpPosition =   2  '화면 가운데
   Begin VB.CommandButton ok_btn 
      Caption         =   "확인"
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   920
      Width           =   8175
   End
   Begin VB.TextBox txtDir 
      Height          =   330
      Left            =   120
      TabIndex        =   0
      Text            =   "예시)C:\Users\TestPC99\Downloads\File"
      Top             =   480
      Width           =   8175
   End
   Begin VB.Label Label1 
      Alignment       =   2  '가운데 맞춤
      BackColor       =   &H00FFFFFF&
      Caption         =   "데이터 값을 추출할 파일의 상위 폴더 경로를 입력해주세요."
      ForeColor       =   &H00FF0000&
      Height          =   615
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   8175
   End
End
Attribute VB_Name = "set_direction_form"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub ok_btn_Click()
If txtDir.Text = "예시)C:\Users\TestPC99\Downloads\File" Then
    MsgBox "검사할 파일들이 속한 경로를 입력해주세요.", vbCritical
ElseIf txtDir.Text = "" Then
    MsgBox "검사할 파일들이 속한 폴더 경로를 입력해주세요.", vbCritical
Else
    Me.Hide
    MsgBox txtDir.Text & vbCrLf & vbCrLf & "이 폴더에 있는 파일의 데이터만 스캔이 가능합니다.", , "설정완료"
    md5_export_form.Show
End If
End Sub
Private Sub Form_Unload(Cancel As Integer)
End
End Sub
Private Sub txtDir_Click()
If txtDir.Text = "예시)C:\Users\TestPC99\Downloads\File" Then
txtDir.Text = ""
End If
End Sub
