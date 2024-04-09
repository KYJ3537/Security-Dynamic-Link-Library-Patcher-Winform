Attribute VB_Name = "WindowRgn_Module"
Public Declare Function SetWindowRgn Lib "User32" (ByVal hwnd As Long, _
   ByVal hRgn As Long, ByVal bRedraw As Long) As Long
Public Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal X1 As Long, _
             ByVal Y1 As Long, ByVal X2 As Long, _
             ByVal Y2 As Long, ByVal X3 As Long, _
             ByVal Y3 As Long) As Long
Public Declare Function CreateEllipticRgn Lib "gdi32" (ByVal X1 As Long, _
    ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
