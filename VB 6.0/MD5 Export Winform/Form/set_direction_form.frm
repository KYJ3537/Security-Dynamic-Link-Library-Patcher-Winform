VERSION 5.00
Begin VB.Form set_direction_form 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  '���� ����
   Caption         =   "�˻��� ������ ���� ��� ����"
   ClientHeight    =   1665
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8415
   BeginProperty Font 
      Name            =   "���� ���"
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
   StartUpPosition =   2  'ȭ�� ���
   Begin VB.CommandButton ok_btn 
      Caption         =   "Ȯ��"
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
      Text            =   "����)C:\Users\TestPC99\Downloads\File"
      Top             =   480
      Width           =   8175
   End
   Begin VB.Label Label1 
      Alignment       =   2  '��� ����
      BackColor       =   &H00FFFFFF&
      Caption         =   "������ ���� ������ ������ ���� ���� ��θ� �Է����ּ���."
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
If txtDir.Text = "����)C:\Users\TestPC99\Downloads\File" Then
    MsgBox "�˻��� ���ϵ��� ���� ��θ� �Է����ּ���.", vbCritical
ElseIf txtDir.Text = "" Then
    MsgBox "�˻��� ���ϵ��� ���� ���� ��θ� �Է����ּ���.", vbCritical
Else
    Me.Hide
    MsgBox txtDir.Text & vbCrLf & vbCrLf & "�� ������ �ִ� ������ �����͸� ��ĵ�� �����մϴ�.", , "�����Ϸ�"
    md5_export_form.Show
End If
End Sub
Private Sub Form_Unload(Cancel As Integer)
End
End Sub
Private Sub txtDir_Click()
If txtDir.Text = "����)C:\Users\TestPC99\Downloads\File" Then
txtDir.Text = ""
End If
End Sub
