EnableExplicit

CompilerSelect #PB_Compiler_OS 
  CompilerCase #PB_OS_Linux 
    UsePNGImageDecoder()
CompilerEndSelect  

Global Window_0 = 0

Global Button_A = 1 
Global Button_B = 2
Global Button_C = 3
Global Button_D = 4
Global Button_E = 5
Global Button_F = 6
Global Button_G = 7
Global Button_Dp = 8
Global ListView1 = 9
Global ListView2 = 10
Global InvertBtn = 11
Global BinTB = 12
Global TextBinTB = 13
Global PreBinTB = 14
Global DecTB = 15
Global TextDecTB = 16
Global HexTB = 17
Global TextHexTB = 18
Global PreHexTB = 19
Global BinCopyBtn = 20
Global DecCopyBtn = 21
Global HexCopyBtn = 22
Global CopyBtn = 23
Global PasteBtn = 24
Global ClearBtn = 25
Global Container0 = 26
Global Container1 = 27

Global Dim  SegmentNames.s(7)

Enumeration 
  #Drag_ListView2
EndEnumeration

Enumeration FormFont
  #Font_10
  #Font_12
  #Font_14
EndEnumeration

#Title  = "7Segment to ..."
#FileName = "7SegmentSet.csv"
Structure udtBCG
  State.i
  Text.s
  Fontid.i
  BackColorOn.i
  BackColorOff.i
  TextColor.i
  OnOff.i
EndStructure

; -------------------------------------------------------------------------------------

Procedure DrawColorButton(Gadget, *data.udtBCG)
  Protected dx, dy
  If StartDrawing(CanvasOutput(Gadget))
    With *data
      dx = DesktopScaledX(GadgetWidth(Gadget))
      dy = DesktopScaledY(GadgetHeight(Gadget))
      If \fontid
        DrawingFont(\fontid)
      EndIf
      Select \state
        Case #PB_EventType_MouseEnter
          If \OnOff = 1
            Box(0, 0, dx, dy, \BackColorOn)
          Else
            Box(0, 0, dx, dy, \backcolorOff)
          EndIf    
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, dx, dy, $D0D0D0)
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText((dx-TextWidth(\text))/2,(dy-TextHeight(\text))/2,\text,\textcolor)
      
        Case #PB_EventType_LeftButtonDown
          If \OnOff = 1
            Box(1, 1, dx, dy, \BackColorOn)
          Else
            Box(1, 1, dx, dy, \backcolorOff)
          EndIf       
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(1, 1, dx, dy, $808080)
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText((dx+1-TextWidth(\text))/2,(dy+2-TextHeight(\text))/2,\text,\textcolor)
          
        Case #PB_EventType_LeftButtonUp, #PB_EventType_LeftClick
          If \OnOff = 1
            Box(0, 0, dx, dy, \BackColorOn)
          Else
            Box(0, 0, dx, dy, \backcolorOff)
          EndIf
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, dx, dy, $D0D0D0)
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText((dx-TextWidth(\text))/2,(dy-TextHeight(\text))/2,\text,\textcolor)
          
        Case #PB_EventType_MouseLeave
          If \OnOff = 1
            Box(0, 0, dx, dy, \BackColorOn)
          Else
            Box(0, 0, dx, dy, \backcolorOff)
          EndIf         
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0, 0, dx, dy, $808080)
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText((dx-TextWidth(\text))/2,(dy-TextHeight(\text))/2,\text,\textcolor)
          
      EndSelect
      \state = 0
      StopDrawing()
    EndWith
  EndIf
  
EndProcedure

; -------------------------------------------------------------------------------------

Procedure EventHandlerColorButton()
  Protected Gadget, event, *Data.udtBCG
  event = EventType()
  Select event
    Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave, #PB_EventType_LeftButtonDown, 
         #PB_EventType_LeftButtonUp, #PB_EventType_LeftDoubleClick,#PB_EventType_LeftClick
      ; Do
      Gadget = EventGadget()
      *data = GetGadgetData(Gadget)
      If event = #PB_EventType_LeftClick
        If *data\OnOff = 1
          *data\OnOff = 0
        Else
          *data\OnOff = 1
        EndIf
      EndIf
      
      *data\state = event
      DrawColorButton(Gadget, *data)
  EndSelect
  
EndProcedure

; -------------------------------------------------------------------------------------

Procedure ButtonColorGadget(Gadget, x, y, Width, Height, Text.s)
  Protected result, id, *Data.udtBCG
  result = CanvasGadget(Gadget, x, y, Width, Height)
  If result
    If Gadget = #PB_Any
      id = result
    Else
      id = Gadget
    EndIf
    *data = AllocateStructure(udtBCG)
    *data\state = #PB_EventType_MouseLeave
    *data\text = text
    *data\backcolorOn = $C0C0C0
    *data\backcolorOff = $C0C0C0
    *data\textcolor = 0
    *data\OnOff = 0
    SetGadgetData(id, *data)
    DrawColorButton(id, *data)
    BindGadgetEvent(id, @EventHandlerColorButton())
  EndIf 
  ProcedureReturn result  
EndProcedure

; -------------------------------------------------------------------------------------

Procedure SetButtonColor(Gadget, TextColor, BackColorOn, BackColorOff)
  Protected *Data.udtBCG
  
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      *data = GetGadgetData(Gadget)
      If *Data
        *data\state = #PB_EventType_MouseLeave
        If TextColor <> #PB_Ignore : *data\textcolor = TextColor : EndIf
        If BackColorOn <> #PB_Ignore : *Data\backcolorOn = BackColorOn : EndIf
        If BackColorOff <> #PB_Ignore : *Data\backcolorOff = BackColorOff : EndIf
        DrawColorButton(Gadget, *data)
      EndIf
    EndIf
  EndIf

EndProcedure

; -------------------------------------------------------------------------------------

Procedure SetButtonOnOff(Gadget, OnOff)
  Protected *Data.udtBCG  
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      *Data = GetGadgetData(Gadget)
      If *Data
        *Data\state = #PB_EventType_MouseLeave
        *Data\OnOff = OnOff
        DrawColorButton(Gadget, *data)
      EndIf
    EndIf
  EndIf

EndProcedure


; -------------------------------------------------------------------------------------

Procedure SetButtonFont(Gadget, FontID)
  Protected *Data.udtBCG
  
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      *data = GetGadgetData(Gadget)
      If *Data
        *data\state = #PB_EventType_MouseLeave
        *data\fontid = FontID
        DrawColorButton(Gadget, *data)
      EndIf
    EndIf
  EndIf

EndProcedure

; -------------------------------------------------------------------------------------

Procedure SetButtonSize(Gadget, x, y, width, height)
  Protected *Data.udtBCG
  
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      *data = GetGadgetData(Gadget)
      If *Data
        *data\state = #PB_EventType_MouseLeave
        ResizeGadget(Gadget, x, y, width, height)
        DrawColorButton(Gadget, *data)
      EndIf
    EndIf
  EndIf

EndProcedure

; -------------------------------------------------------------------------------------

Procedure DestroyGadget(Gadget)
  Protected *data
  
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      *data = GetGadgetData(Gadget)
      If *Data
        UnbindGadgetEvent(Gadget, @EventHandlerColorButton())
        FreeStructure(*data)
      EndIf
    EndIf
    FreeGadget(Gadget)
  EndIf
    
EndProcedure
; -------------------------------------------------------------------------------------

Procedure ListViewGadgetMove(Gadget, Source, Dest)
  Protected i, ItemText$, ItemData, Source$, SourceData
  Source$ = GetGadgetItemText(Gadget, Source)
  SourceData = GetGadgetItemData(Gadget, Source)
  
  If Source = -1
    ProcedureReturn 
  EndIf
  If Dest = -1   
    Dest = CountGadgetItems(Gadget) - 1
  EndIf  
  If Source < Dest
    For i = Source To Dest - 1
      ItemText$ = GetGadgetItemText(Gadget, i + 1)
      ItemData  = GetGadgetItemData(Gadget, i + 1)
      SetGadgetItemText(Gadget, i, ItemText$)
      SetGadgetItemData(Gadget, i, ItemData)
    Next
  Else
    For i = Source To Dest + 1 Step - 1
      ItemText$ = GetGadgetItemText(Gadget, i - 1)
      ItemData  = GetGadgetItemData(Gadget, i - 1)
      SetGadgetItemText(Gadget, i, ItemText$)
      SetGadgetItemData(Gadget, i, ItemData)
    Next
  EndIf
  SetGadgetItemText(Gadget, i, Source$)
  SetGadgetItemData(Gadget, i, SourceData)
EndProcedure

; -------------------------------------------------------------------------------------

Procedure SetOutputTB()
  Protected Dec, i, z, OutText.s , *Data.udtBCG, OrderSegName.s
  OutText=""
  For i = 0 To 7
    OrderSegName=GetGadgetItemText(ListView2, i)
    For z =1 To 8
      If SegmentNames(z-1)=OrderSegName
        *data = GetGadgetData(z)
        If GetGadgetState(InvertBtn) 
          If *data\OnOff = 1
            OutText = OutText + "0"
          Else
            OutText = OutText + "1"
          EndIf        
        Else
          OutText = OutText + Str(*data\OnOff)
        EndIf
        Break
      EndIf
    Next z 
  Next i
  Dec = Val("%" + OutText)
  SetGadgetText(BinTB, OutText)
  SetGadgetText(DecTB, Str(Dec))
  SetGadgetText(HexTB,RSet(Hex(Dec), 2, "0"))
EndProcedure

; -------------------------------------------------------------------------------------

Procedure SetSegmentButton(Bin.s)
  Protected  i, z, v, b, Dec, OrderSegName.s
  For i = 0 To 7
    OrderSegName=GetGadgetItemText(ListView2, i)
    For z =1 To 8
      If SegmentNames(z-1)=OrderSegName
        b = Val(Mid(Bin,i+1,1))
        If GetGadgetState(InvertBtn) 
          If b = 1
            v = 0
          Else
            v = 1
          EndIf        
        Else
          v = b
        EndIf
        SetButtonOnOff(z,v) 
        Break
      EndIf
    Next z 
  Next i
  Dec = Val("%" + Bin)
  SetGadgetText(BinTB, Bin)
  SetGadgetText(DecTB, Str(Dec))
  SetGadgetText(HexTB,RSet(Hex(Dec), 2, "0"))
EndProcedure

; -------------------------------------------------------------------------------------

Procedure CopyBtnClick()
  If GetGadgetState(BinCopyBtn) 
    SetClipboardText(GetGadgetText(PreBinTB) + GetGadgetText(BinTB))
  ElseIf GetGadgetState(DecCopyBtn)
    SetClipboardText(GetGadgetText(DecTB))
  ElseIf GetGadgetState(HexCopyBtn)
    SetClipboardText(GetGadgetText(PreHexTB) +GetGadgetText(HexTB))
  EndIf
EndProcedure

; -------------------------------------------------------------------------------------

Procedure PasteBtnClick()
  Protected i, ClipText.s, T.s , Tt.s
  Protected Dim ValidHex.s(15)
  For i = 0 To 9
    ValidHex(i) = Str(i)
  Next i
  ValidHex(10) = "a":ValidHex(11) = "b":ValidHex(12) = "c":ValidHex(13) = "d":ValidHex(14) = "e":ValidHex(15) = "f"
  ClipText = LCase(GetClipboardText())
  If Len(ClipText) >= 8 
    T = Right(ClipText,8)
    If Len(ReplaceString(ReplaceString(T, "1",""),"0",""))=0 
      SetSegmentButton(T)
    EndIf
  ElseIf Len(ClipText) = 4 
    If FindString(ClipText,"0x") = 1
      Tt = Right(ClipText,2)
      For i = 0 To 15
        Tt = ReplaceString(Tt, ValidHex(i),"")
      Next i
      If Len(Tt) = 0
        Tt = "$" + Right(ClipText,2)
        T = RSet(Bin(Val(Tt)),8,"0")
      SetSegmentButton(T)
      EndIf      
    EndIf
  ElseIf Len(ClipText) <= 3
    Tt = ClipText
     For i = 0 To 9
        Tt = ReplaceString(Tt, ValidHex(i),"")
      Next i
      If Len(Tt) = 0
        T = RSet(Bin(Val(ClipText)),8,"0")
        SetSegmentButton(T)
      EndIf  
  EndIf  
EndProcedure

; -------------------------------------------------------------------------------------

Procedure ClearBtnClick()
  Protected i , v 
  If GetGadgetState(InvertBtn)
    v = 1
  Else
    v=0
  EndIf
  For i =1 To 8
    SetButtonOnOff(i,v)  
  Next i  
  SetOutputTB()
EndProcedure

; -------------------------------------------------------------------------------------

Procedure SaveSettings()
  Protected OutPut.s, i
  OutPut =""
  For i = 0 To 7
    OutPut= OutPut  + GetGadgetItemText(ListView2, i) + ";"
  Next i
  If GetGadgetState(InvertBtn) 
    Output = Output + "1;"
  Else
    Output = Output + "0;"
  EndIf
  If GetGadgetState(BinCopyBtn)
    Output = Output + "0"
  ElseIf  GetGadgetState(DecCopyBtn)
    Output = Output + "1"
  ElseIf GetGadgetState(HexCopyBtn)
    Output = Output + "2"
  EndIf
  Output = Output + ";" + GetGadgetText(PreBinTB)
  If CreateFile(0, GetCurrentDirectory() + #FileName)
    WriteStringN(0, OutPut)
    CloseFile(0)
  EndIf
EndProcedure

; -------------------------------------------------------------------------------------

Procedure DrawWindow()
  Protected Event, EventType, EventGadget, DragGadget, DragItem, TargetItem, i, z, Str.s, T.s, F, loadDefaultOrder  
  SegmentNames(7)="Dp":SegmentNames(6)="G":SegmentNames(5)="F":SegmentNames(4)="E":SegmentNames(3)="D":SegmentNames(2)="C":SegmentNames(1)="B":SegmentNames(0)="A"
  
  If OpenWindow(Window_0, 100, 100, 430, 305, #Title , #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Linux  
        gtk_window_set_icon_(WindowID(Window_0), ImageID(CatchImage(#PB_Any,?LINUXICON)))
    CompilerEndSelect   
    
    loadDefaultOrder = 1
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows   
         LoadFont(#Font_10, "Arial", 10, #PB_Font_HighQuality)
         LoadFont(#Font_12, "Arial", 12 , #PB_Font_HighQuality)
         LoadFont(#Font_14, "Arial", 14 , #PB_Font_HighQuality)
      CompilerCase #PB_OS_Linux   
        LoadFont(#Font_10, "Sans", 8, #PB_Font_HighQuality)
        LoadFont(#Font_12, "Sans", 10 , #PB_Font_HighQuality)  
    CompilerEndSelect 

    
    ButtonColorGadget(Button_A, 37, 15, 100, 25, "A")
    ButtonColorGadget(Button_B, 137, 40, 25, 100, "B")
    ButtonColorGadget(Button_C, 137, 165, 25, 100, "C")
    ButtonColorGadget(Button_D, 37, 265, 100, 25, "D")
    ButtonColorGadget(Button_E, 11, 165, 25, 100, "E")
    ButtonColorGadget(Button_F, 11, 40, 25, 100, "F")
    ButtonColorGadget(Button_G, 36, 140, 100, 25, "G")
    ButtonColorGadget(Button_Dp, 177, 260, 35, 35, "Dp")
    
    For i=1 To 8
      SetButtonColor(i, $FFFFFF, $0000FF,$000000 )
      SetButtonFont(i, FontID(#Font_10))
    Next i
    
    ContainerGadget(Container0, 172, 15, 40, 210, #PB_Container_BorderLess | #PB_Container_Flat)
    ListViewGadget(ListView1, 0, 0, 20, 210)
    CloseGadgetList()
    ContainerGadget(Container1, 193, 15, 40, 210, #PB_Container_BorderLess | #PB_Container_Flat)
    ListViewGadget(ListView2, 0, 0, 40, 210)
    CloseGadgetList()
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows
        SetGadgetFont(ListView1, FontID(#Font_14))
        SetGadgetFont(ListView2, FontID(#Font_14))
      CompilerCase #PB_OS_Linux 
        SetGadgetFont(ListView1, FontID(#Font_12))
        SetGadgetFont(ListView2, FontID(#Font_12))
    CompilerEndSelect
    DisableGadget(ListView1, 1) 
    
    For i = 7 To 0 Step -1
      AddGadgetItem(listview1, -1, Str(i))
    Next i
    EnableGadgetDrop(ListView2, #PB_Drop_Private, #PB_Drag_Move, #Drag_Listview2)
    
    CheckBoxGadget(InvertBtn, 350, 10, 50, 24, "Invert")
    
    TextGadget(TextBinTB, 310, 25, 24, 16, "Bin")
    SetGadgetFont(TextBinTB, FontID(#Font_12))
    
    StringGadget(PreBinTB, 245, 47, 37, 20, "0%")   
    SetGadgetFont(PreBinTB, FontID(#Font_10))
    
    StringGadget(BinTB, 282, 45, 85, 24, "00000000", #PB_String_ReadOnly)
    SetGadgetFont(BinTB, FontID(#Font_12))    
    
    TextGadget(TextDecTB, 310, 75, 30, 16, "Dec")
    SetGadgetFont(TextDecTB, FontID(#Font_12))
    
    StringGadget(DecTB, 282, 95, 85, 24, "0", #PB_String_ReadOnly)
    SetGadgetFont(DecTB, FontID(#Font_12))    
    
    TextGadget(TextHexTB, 310, 125, 30, 16, "Hex")
    SetGadgetFont(TextHexTB, FontID(#Font_12))
    
    StringGadget(PreHexTB, 245, 147, 37, 20, "0x", #PB_String_ReadOnly)    
    SetGadgetFont(PreHexTB, FontID(#Font_10))
    
    StringGadget(HexTB, 282, 145, 85, 24, "00", #PB_String_ReadOnly)
    SetGadgetFont(HexTB, FontID(#Font_12))
    
    If GadgetHeight(PreBinTB, #PB_Gadget_ActualSize) < GadgetHeight(PreBinTB, #PB_Gadget_RequiredSize)
      ResizeGadget(PreBinTB, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(PreBinTB, #PB_Gadget_RequiredSize))
    EndIf
    
    If GadgetHeight(BinTB, #PB_Gadget_ActualSize) < GadgetHeight(BinTB, #PB_Gadget_RequiredSize)
      ResizeGadget(BinTB, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(BinTB, #PB_Gadget_RequiredSize))
    EndIf
    
    If GadgetHeight(DecTB, #PB_Gadget_ActualSize) < GadgetHeight(DecTB, #PB_Gadget_RequiredSize)
      ResizeGadget(DecTB, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(DecTB, #PB_Gadget_RequiredSize))
    EndIf
    
    If GadgetHeight(PreHexTB, #PB_Gadget_ActualSize) < GadgetHeight(PreHexTB, #PB_Gadget_RequiredSize)
      ResizeGadget(PreHexTB, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(PreHexTB, #PB_Gadget_RequiredSize))
    EndIf
    
    If GadgetHeight(HexTB, #PB_Gadget_ActualSize) < GadgetHeight(HexTB, #PB_Gadget_RequiredSize)
      ResizeGadget(HexTB, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(HexTB, #PB_Gadget_RequiredSize))
    EndIf
       
    ResizeGadget(PreHexTB, #PB_Ignore, GadgetY(HexTB) + (GadgetHeight(HexTB, #PB_Gadget_ActualSize) -GadgetHeight(PreHexTB, #PB_Gadget_ActualSize) )/2, #PB_Ignore, #PB_Ignore)
    
    ResizeGadget(PreBinTB, #PB_Ignore, GadgetY(BinTB) + (GadgetHeight(BinTB, #PB_Gadget_ActualSize) -GadgetHeight(PreBinTB, #PB_Gadget_ActualSize) )/2, #PB_Ignore, #PB_Ignore)
    
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows
        SetGadgetColor(BinTB, #PB_Gadget_BackColor, RGB(255,255,255))
        SetGadgetColor(DecTB, #PB_Gadget_BackColor, RGB(255,255,255))
        SetGadgetColor(PreHexTB, #PB_Gadget_BackColor, RGB(255,255,255))
        SetGadgetColor(HexTB, #PB_Gadget_BackColor, RGB(255,255,255))
    CompilerEndSelect 
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows
        OptionGadget(BinCopyBtn, 372, 47, 60, 16, "Copy")
        OptionGadget(DecCopyBtn, 372, 97, 60, 16, "Copy")
        OptionGadget(HexCopyBtn, 372, 147, 60, 16, "Copy")
      CompilerCase #PB_OS_Linux
        OptionGadget(BinCopyBtn, 365, 47, 60, 16, "Copy")
        OptionGadget(DecCopyBtn, 365, 97, 60, 16, "Copy")
        OptionGadget(HexCopyBtn, 365, 147, 60, 16, "Copy")
    CompilerEndSelect
    SetGadgetState(BinCopyBtn, 1) 
    

    If GadgetHeight(BinCopyBtn, #PB_Gadget_ActualSize) < GadgetHeight(BinCopyBtn, #PB_Gadget_RequiredSize)
      ResizeGadget(BinCopyBtn, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(BinCopyBtn, #PB_Gadget_RequiredSize))
    EndIf
    
    If GadgetHeight(DecCopyBtn, #PB_Gadget_ActualSize) < GadgetHeight(DecCopyBtn, #PB_Gadget_RequiredSize)
      ResizeGadget(DecCopyBtn, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(DecCopyBtn, #PB_Gadget_RequiredSize))
    EndIf
    
    If GadgetHeight(HexCopyBtn, #PB_Gadget_ActualSize) < GadgetHeight(HexCopyBtn, #PB_Gadget_RequiredSize)
      ResizeGadget(HexCopyBtn, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(HexCopyBtn, #PB_Gadget_RequiredSize))
    EndIf
    
    ResizeGadget(BinCopyBtn, #PB_Ignore, GadgetY(BinTB) + (GadgetHeight(BinTB, #PB_Gadget_ActualSize) -GadgetHeight(BinCopyBtn, #PB_Gadget_ActualSize) )/2, #PB_Ignore, #PB_Ignore)
    ResizeGadget(DecCopyBtn, #PB_Ignore, GadgetY(DecTB) + (GadgetHeight(DecTB, #PB_Gadget_ActualSize) -GadgetHeight(DecCopyBtn, #PB_Gadget_ActualSize) )/2, #PB_Ignore, #PB_Ignore)
    ResizeGadget(HexCopyBtn, #PB_Ignore, GadgetY(HexTB) + (GadgetHeight(HexTB, #PB_Gadget_ActualSize) -GadgetHeight(HexCopyBtn, #PB_Gadget_ActualSize) )/2, #PB_Ignore, #PB_Ignore)

    ButtonGadget(CopyBtn, 255, 235, 80, 30, "Copy")
    ButtonGadget(PasteBtn, 340, 235, 80, 30, "Paste")
    ButtonGadget(ClearBtn, 255, 270, 165, 30, "Clear")
    SetGadgetFont(CopyBtn, FontID(#Font_12))    
    SetGadgetFont(PasteBtn, FontID(#Font_12))   
    SetGadgetFont(ClearBtn, FontID(#Font_12))
    If ReadFile(0, GetCurrentDirectory() + #FileName)
      Repeat 
        Str = ReadString(0)   
      Until Eof(0)  
      CloseFile(0)     
      If CountString(Str,";")  = 10   
        For i = 1 To 8
          T=LCase(StringField(Str,i,";"))
          F = 0
          For z = 0 To 7
            If LCase(SegmentNames(z)) = t
              AddGadgetItem(listview2, -1, SegmentNames(z))
              F = 1
              Break
            EndIf
          Next z
          If F = 0
            ClearGadgetItems(listview2)
            loadDefaultOrder = 0
            Break
          EndIf
        Next i
        
        If StringField(Str,9,";") = "1"          
          SetGadgetState(InvertBtn, 1)
        EndIf
        Select  StringField(Str,10,";")
          Case "0"
            SetGadgetState(BinCopyBtn, 1)
          Case "1"
            SetGadgetState(DecCopyBtn, 1)
          Case "2"
            SetGadgetState(HexCopyBtn, 1)
        EndSelect
        SetGadgetText(PreBinTB, StringField(Str,11,";")) 
      Else
        loadDefaultOrder = 0
      EndIf
    Else
      loadDefaultOrder = 0
    EndIf
    
    If loadDefaultOrder = 0
      For i = 7 To 0 Step -1
        AddGadgetItem(listview2, -1, SegmentNames(i))
      Next i
    EndIf
    SetOutputTB()
    
    Repeat
      Event = WaitWindowEvent()
      EventType = EventType()
      EventGadget = EventGadget()
      Select event
        Case #PB_Event_CloseWindow
          SaveSettings()
        Case #PB_Event_Menu
          Select EventMenu()
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget
            Case Button_A, Button_B, Button_C, Button_D, Button_E, Button_F, Button_G, Button_Dp
              Select EventType
                Case #PB_EventType_LeftClick
                  SetOutputTB()
              EndSelect
            Case CopyBtn
              Select EventType
                Case #PB_EventType_LeftClick
                  CopyBtnClick()
              EndSelect
            Case PasteBtn
              Select EventType
                Case #PB_EventType_LeftClick
                  PasteBtnClick()
              EndSelect
            Case ClearBtn
              Select EventType
                Case #PB_EventType_LeftClick
                  ClearBtnClick()
              EndSelect
            Case ListView2
              Select EventType
                Case #PB_EventType_DragStart
                  DragGadget = EventGadget   
                  DragItem = GetGadgetState(DragGadget)
                  If DragGadget = listview2
                    DragPrivate(#Drag_Listview2, #PB_Drag_Move)
                  EndIf
              EndSelect
            Case InvertBtn
              SetOutputTB()
          EndSelect
          
        Case #PB_Event_GadgetDrop
          EventGadget = GetActiveGadget()
          TargetItem = GetGadgetState(EventGadget)
          If EventDropPrivate() = #Drag_Listview2 
            ListViewGadgetMove(EventGadget, DragItem, TargetItem)
            SetOutputTB()
          EndIf
      EndSelect
      
    Until Event = #PB_Event_CloseWindow  
  EndIf
  
  For i=1 To 8
  DestroyGadget(i)
  Next i
EndProcedure

DrawWindow()
CompilerSelect #PB_Compiler_OS 
  CompilerCase #PB_OS_Linux 
    DataSection
      LINUXICON: : IncludeBinary "linux.png"
    EndDataSection
CompilerEndSelect      
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 590
; FirstLine = 556
; Folding = ---
; EnableXP
; DPIAware
; UseIcon = Icon.ico
; Executable = Win\7Segment to_x64.exe