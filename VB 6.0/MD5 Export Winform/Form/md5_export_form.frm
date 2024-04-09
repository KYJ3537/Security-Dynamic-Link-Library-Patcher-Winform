VERSION 5.00
Begin VB.Form md5_export_form 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  '���� ����
   Caption         =   "���� ��ĵ"
   ClientHeight    =   6240
   ClientLeft      =   -15
   ClientTop       =   375
   ClientWidth     =   12990
   BeginProperty Font 
      Name            =   "���� ���"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "md5_export_form.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   OLEDropMode     =   1  '����
   ScaleHeight     =   6240
   ScaleWidth      =   12990
   StartUpPosition =   2  'ȭ�� ���
   Begin VB.CommandButton load_data_btn 
      Caption         =   "����� ������ �� �ߺ� ��� ���� �� �ҷ�����"
      Height          =   615
      Left            =   1560
      OLEDropMode     =   1  '����
      TabIndex        =   8
      Top             =   120
      Width           =   2775
   End
   Begin VB.CommandButton copy_btn 
      Caption         =   "Ŭ������� ����"
      Height          =   615
      Left            =   5160
      OLEDropMode     =   1  '����
      TabIndex        =   7
      Top             =   120
      Width           =   7725
   End
   Begin VB.TextBox md5_full 
      Height          =   5240
      Left            =   5160
      MultiLine       =   -1  'True
      OLEDropMode     =   1  '����
      ScrollBars      =   2  '����
      TabIndex        =   6
      Top             =   840
      Width           =   7700
   End
   Begin VB.TextBox txtSingle 
      Height          =   330
      Left            =   120
      OLEDropMode     =   1  '����
      TabIndex        =   5
      Top             =   840
      Width           =   4935
   End
   Begin VB.ListBox file_List 
      Height          =   4785
      Left            =   120
      OLEDropMode     =   1  '����
      TabIndex        =   4
      Top             =   1290
      Width           =   4935
   End
   Begin VB.CommandButton start_btn 
      Caption         =   "��ĵ ����"
      Height          =   615
      Left            =   120
      OLEDropMode     =   1  '����
      TabIndex        =   3
      Top             =   120
      Width           =   1335
   End
   Begin VB.CommandButton clear_btn 
      Caption         =   "û��"
      Height          =   615
      Left            =   4440
      OLEDropMode     =   1  '����
      TabIndex        =   2
      Top             =   120
      Width           =   615
   End
   Begin VB.TextBox txtMD5 
      Height          =   2955
      Left            =   15120
      MultiLine       =   -1  'True
      OLEDropMode     =   1  '����
      ScrollBars      =   2  '����
      TabIndex        =   1
      Top             =   1320
      Visible         =   0   'False
      Width           =   1755
   End
   Begin VB.TextBox txtName 
      Height          =   2955
      Left            =   13320
      MultiLine       =   -1  'True
      OLEDropMode     =   1  '����
      ScrollBars      =   2  '����
      TabIndex        =   0
      Top             =   1320
      Visible         =   0   'False
      Width           =   1755
   End
End
Attribute VB_Name = "md5_export_form"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Hash As New MD5Hash
Private strFile As String
Private bytBlock() As Byte
Private Declare Sub sleep Lib "kernel32.dll" Alias "Sleep" (ByVal dwMilliseconds As Long)
Private Sub start_btn_Click()
On Error Resume Next
Dim i As Long
Dim abc As Long

For i = 0 To file_List.ListCount

    If i = file_List.ListCount - 1 Then
        md5_full.Text = md5_full.Text & Split(file_List.List(i), set_direction_form.txtDir.Text & "\")(1) & "[" & Hash.HashFile(file_List.List(i)) & "]"
    Else
        md5_full.Text = md5_full.Text & Split(file_List.List(i), set_direction_form.txtDir.Text & "\")(1) & "[" & Hash.HashFile(file_List.List(i)) & "]" & vbCrLf
    End If
    
    abc = i + 1
    
    Me.Caption = "���� ��ĵ [" & abc & "/" & file_List.ListCount + 1 & "]"
    
DoEvents
sleep 0&

Next i
End Sub
Private Sub clear_btn_Click()

file_List.Clear
txtName.Text = ""
txtMD5.Text = ""
md5_full.Text = ""
Me.Caption = "���� ��ĵ"

End Sub

Private Sub copy_btn_Click()
If md5_full.Text <> "" Then
    Clipboard.Clear
    Clipboard.SetText md5_full.Text
    MsgBox "Ŭ������� �����߽��ϴ�."
End If
End Sub
Private Sub load_data_btn_Click()
Dim httpReq As New WinHttpRequest
Dim strUrl As String
Dim strHtml As String
Dim arrData() As String
Dim i As Integer
Dim setData As Object
Dim key As Variant

' Scripting.Dictionary Ŭ������ setData ��ü ����
Set setData = CreateObject("Scripting.Dictionary")

If Not file_List.ListCount = 0 Then
    MsgBox "�����͸� �ҷ����� ���� û�Ҹ� ���ּ���."
    Exit Sub
End If

' �������� URL ����
strUrl = "http://175.119.207.28/md5.html"

' WinHttpRequest�� ����Ͽ� �������� �ҽ� ��������
httpReq.Open "GET", strUrl, False
httpReq.Send
strHtml = httpReq.ResponseText

' ������ �ҽ��� ���κ��� �и��Ͽ� setData�� �߰�
arrData() = Split(strHtml, vbCrLf)
For i = 0 To UBound(arrData)
    If Not arrData(i) = "" Then
        setData(set_direction_form.txtDir.Text & "\" & Left(arrData(i), InStr(arrData(i), "[") - 1)) = ""
    End If
Next i

' setData�� �ִ� �����͸� file_List�� �߰�
file_List.Clear
For Each key In setData
    file_List.AddItem key
Next key

MsgBox "������ �ִ� �����͸� �ҷ��Խ��ϴ�."
End Sub
Private Sub Form_Load()
Me.Hide
set_direction_form.Show
End Sub
Private Sub Form_Unload(Cancel As Integer)
End
End Sub
Private Sub file_List_DblClick()
txtSingle.Text = Hash.HashFile(file_List.Text)
End Sub
Private Sub file_List_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
On Error Resume Next
Dim b As Long
Dim XY As Long

b = 0

For XY = 1 To Data.Files.Count
    If Left$(Data.Files(XY), Len(set_direction_form.txtDir.Text)) = set_direction_form.txtDir.Text Then
    Else
        MsgBox "���� ���� : " & Data.Files(XY) & vbCrLf & vbCrLf & set_direction_form.txtDir.Text & " ��ο� �ִ� ���ϸ� �߰��� �� �ֽ��ϴ�."
        Exit Sub
    End If
    file_List.AddItem Data.Files(XY)
    b = b + 1
    
    '����ȭ/���� ����
    DoEvents
    sleep 0&
    
Next XY
 
Me.Caption = "���� ��ĵ - ��� �巡�׷� �߰� ���� ���� : " & b

End Sub

