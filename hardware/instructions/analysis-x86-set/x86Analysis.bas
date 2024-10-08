rem x86 Machine Code Statistics
rem (c) Peter Kankowski, 2004   http://www.smallcode.weblogs.us

Option Explicit
Option Base 0
Dim otype&(4)

Function AnalyzeOp(V As String) As Long
Dim R&, i&
If Mid$(V, 1, 11) = "dword ptr [" Then R = 2: V = Mid$(V, 12, Len(V) - 12)
If Mid$(V, 1, 10) = "word ptr [" Then R = 2: V = Mid$(V, 11, Len(V) - 11)
If Mid$(V, 1, 10) = "byte ptr [" Then R = 2: V = Mid$(V, 11, Len(V) - 11)
If Mid$(V, 1, 1) = "[" Then R = 2: V = Mid$(V, 2, Len(V) - 2)
For i = 1 To Len(V)
  If Mid$(V, i, 1) > "F" Then R = R + 2: AnalyzeOp = R: otype(R) = otype(R) + 1: Exit Function
Next i
R = R + 1
AnalyzeOp = R
otype(R) = otype(R) + 1
End Function

Sub AnalyseFile(FileName As String)
Dim F&, S$, V$, T&, a&, G$, GP&, ops&, o1&, o2&
Dim OpCodes$(), OpCodes2$(), Freqs&(), OO&, lens&(13), ocount&(5), oform&(5)
F = FreeFile
G = Space$(1024)
Open FileName For Input As F
  Do While Not EOF(F)
    Line Input #F, S
    If Left$(S, 12) = "* Referenced" Then T = 1
    If Left$(S, 1) = ":" And T = 1 Then
       S = Mid$(S, 11) 'skip address
       V = RTrim$(Left$(S, 24)) ' V is instruction code
       S = Mid$(S, 25) 'S is mnemonic
       
       a = Len(V) / 2
       lens(a) = lens(a) + 1
       
       a = InStr(S, " ")
       ops = 0
       If a Then
         ops = 1
         V = Mid$(S, a + 1)
         S = Left$(S, a - 1)

           a = InStr(V, ", ")
           If a = 0 Then GoTo ex
           ops = 2
           o1 = AnalyzeOp(Left$(V, a - 1))
           V = Mid$(V, a + 2)

           a = InStr(V, ", ")
           If a = 0 Then GoTo ex
           ops = 3
           AnalyzeOp Left$(V, a - 1)
           V = Mid$(V, a + 2)

           a = InStr(V, ", ")
           If a <> 0 Then ops = 4: GoTo ex2
ex:
         If V = "cl" Then
           If S = "shr" Or S = "shl" Then ops = 1: GoTo ex2
           If S = "shrd" Or S = "shld" Then ops = 2: GoTo ex2
         End If
         o2 = AnalyzeOp(V)
ex2:
         If ops = 2 Then
           If o1 = 2 Then If o2 = 2 Then oform(1) = oform(1) + 1: GoTo ex3
           If o1 = 2 Then If o2 = 3 Or o2 = 4 Then oform(2) = oform(2) + 1: GoTo ex3
           If o1 = 3 Or o1 = 4 Then If o2 = 2 Then oform(3) = oform(3) + 1: GoTo ex3
           If o1 = 2 Then If o2 = 1 Then oform(4) = oform(4) + 1: GoTo ex3
           If o1 = 3 Or o1 = 4 Then If o2 = 1 Then oform(5) = oform(5) + 1: GoTo ex3
ex3:
         End If
       End If
       ocount(ops) = ocount(ops) + 1
       'If (OO Mod 1000) = 0 Then ReDim Preserve OpCodes$(OO + 1000)
       'OpCodes(OO) = S
       'OO = OO + 1
       
       a = GP + Len(S) + 1
       If (GP \ 1024) <> (a \ 1024) Then
          G = G & Space$(1024)
       End If
       Mid$(G, GP + 1) = S & " "
       GP = a
       
       If S = "jmp" Or S = "ret" Then T = 0
    End If
  Loop
Close F

Selection.TypeText "ocount" & vbCrLf
For a = 0 To UBound(ocount)
  Selection.TypeText ocount(a) & vbCrLf
Next a

Selection.TypeText "oform" & vbCrLf
For a = 1 To UBound(oform)
  Selection.TypeText oform(a) & vbCrLf
Next a
End Sub


Sub N()
Dim a&
AnalyseFile "c:\x86Analysis\makensis.alf"
AnalyseFile "c:\x86Analysis\7za.alf"
AnalyseFile "c:\x86Analysis\lame.alf"

Selection.TypeText "otype" & vbCrLf
For a = 1 To UBound(otype)
  Selection.TypeText otype(a) & vbCrLf
Next a
End Sub