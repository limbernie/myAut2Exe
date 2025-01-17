Attribute VB_Name = "modWHXAPI"
'        WinHex API 1.1 Declarations for Visual Basic
'
'        Copyright � 2001-2003 Stefan Fleischmann
'        Modified by Alexander Asyabrik
'        Requires an existing installation of WinHex 10.1
'        or later and a professional WinHex license.
'
'        Needs to be included in another Visual Basic project.
'        Cannot be used as a Visual Basic project on its own.
'
'        May need adjustment depending on the Visual Basic
'        version you are using.


'----------------------------------------------------------------------
'        This declarations fully valid for VB5,VB6

'        Copyright � 2002 Alexander Asyabrik
 

Public Declare Function WHX_Init Lib "lib\whxapi.dll" (ByVal APIVersion As Long) As Long
Public Declare Function WHX_Done Lib "lib\whxapi.dll" () As Long

Public Declare Function WHX_Open Lib "lib\whxapi.dll" (ByVal lpResName As String) As Long
Public Declare Function WHX_Create Lib "lib\whxapi.dll" (ByVal lpResName As String, ByVal Count As Long) As Long
Public Declare Function WHX_Close Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_CloseAll Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_NextObj Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_Save Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_SaveAll Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_SaveAs Lib "lib\whxapi.dll" (ByVal lpNewFileName As String) As Long
Public Declare Function WHX_OpenEx Lib "lib\whxapi.dll" (ByVal lpResName As String, ByVal Param As Long) As Long

Public Declare Function WHX_Read Lib "lib\whxapi.dll" (ByRef lpBuffer As Byte, ByVal Bytes As Long) As Long
Public Declare Function WHX_ReadString Lib "lib\whxapi.dll" Alias "WHX_Read" (ByVal lpBuffer As String, ByVal Bytes As Long) As Long

Public Declare Function WHX_Write Lib "lib\whxapi.dll" (ByRef lpBuffer As Byte, ByVal Bytes As Long) As Long
Public Declare Function WHX_WriteString Lib "lib\whxapi.dll" Alias "WHX_Write" (ByVal lpBuffer As String, ByVal Bytes As Long) As Long

Public Declare Function WHX_GetSize Lib "lib\whxapi.dll" (ByRef Size As Currency) As Long
Public Declare Function WHX_Goto Lib "lib\whxapi.dll" (ByVal Ofs As Currency) As Long
Public Declare Function WHX_Move Lib "lib\whxapi.dll" (ByVal Ofs As Currency) As Long
Public Declare Function WHX_CurrentPos Lib "lib\whxapi.dll" (ByRef Ofs As Currency) As Long
Public Declare Function WHX_SetBlock Lib "lib\whxapi.dll" (ByVal Ofs1 As Currency, ByVal Ofs2 As Currency) As Long
'
Public Declare Function WHX_Copy Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_CopyIntoNewFile Lib "lib\whxapi.dll" (ByVal lpNewFileName As String) As Long
Public Declare Function WHX_Cut Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_Remove Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_Paste Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_WriteClipboard Lib "lib\whxapi.dll" () As Long

Public Declare Function WHX_Find Lib "lib\whxapi.dll" (ByVal Data As String, ByVal lpOptions As String) As Long
Public Declare Function WHX_Replace Lib "lib\whxapi.dll" (ByVal Data1 As String, ByVal Data2 As String, ByVal lpOptions As String) As Long
Public Declare Function WHX_WasFound Lib "lib\whxapi.dll" () As Long
Public Declare Function WHX_WasFoundEx Lib "lib\whxapi.dll" () As Long

Public Declare Function WHX_Convert Lib "lib\whxapi.dll" (ByVal Format1 As String, ByVal Format2 As String) As Long
Public Declare Function WHX_Encrypt Lib "lib\whxapi.dll" (ByVal Key As String, ByVal Algorithm As Long) As Long
Public Declare Function WHX_Decrypt Lib "lib\whxapi.dll" (ByVal Key As String, ByVal Algorithm As Long) As Long

Public Declare Function WHX_GetCurObjName Lib "lib\whxapi.dll" (ByVal ObjName As String) As Long
Public Declare Function WHX_SetFeedbackLevel Lib "lib\whxapi.dll" (ByVal Level As Long) As Long
Public Declare Function WHX_GetLastError Lib "lib\whxapi.dll" (ByVal MsgBuffer As String) As Long
Public Declare Function WHX_SetLastError Lib "lib\whxapi.dll" (ByVal MsgBuffer As String) As Long
Public Declare Function WHX_GetStatus Lib "lib\whxapi.dll" (ByVal lpInstPath As String, ByRef lpWHXVersion As Long, ByRef lpWHXSubVersion As Long, ByRef lpReserved As Long) As Long


'=====================================
'Added for special conversion routines
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDst As Any, ByVal pSrc As String, ByVal ByteLen As Long)
Private Declare Sub ZeroMemory Lib "kernel32" Alias "RtlZeroMemory" (Destination As Any, ByVal Length As Long)


'This function put valid numbers for LONGLONG param
' My copyright :)
Public Function VB2API(pos As Currency) As Currency
   VB2API = pos / 10000
End Function

'This function translate LONGLONG param to valid VB numbers
' My copyright :)
Public Function API2VB(pos As Currency) As Currency
   API2VB = pos * 10000
End Function


'This function translate byte array to valid VB unicode string
Public Function ChangeToStringUni(Bytes() As Byte) As String
    Dim temp As String
    temp = StrConv(Bytes, vbUnicode)
    ChangeToStringUni = temp
End Function

'Changes a Visual Basic unicode string to the byte array
'Returns True if it truncates str
Public Function ChangeBytes(ByVal str As String, Bytes() As Byte) As Boolean
    Dim lenBs As Long 'length of the byte array
    Dim lenStr As Long 'length of the string
    lenBs = UBound(Bytes) - LBound(Bytes)
    lenStr = LenB(StrConv(str, vbFromUnicode))
    If lenBs > lenStr Then
        CopyMemory Bytes(0), str, lenStr
        ZeroMemory Bytes(lenStr), lenBs - lenStr
    ElseIf lenBs = lenStr Then
        CopyMemory Bytes(0), str, lenStr
    Else
        CopyMemory Bytes(0), str, lenBs ' string truncated
        ChangeBytes = True
    End If
End Function
