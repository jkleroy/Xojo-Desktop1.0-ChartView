#tag Window
Begin ContainerControl Chart_LiveData
   AllowAutoDeactivate=   True
   AllowFocus      =   False
   AllowFocusRing  =   False
   AllowTabs       =   True
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   DoubleBuffer    =   False
   Enabled         =   True
   EraseBackground =   True
   HasBackgroundColor=   False
   Height          =   585
   InitialParent   =   ""
   Left            =   32
   LockBottom      =   True
   LockLeft        =   True
   LockRight       =   True
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Tooltip         =   ""
   Top             =   32
   Transparent     =   True
   Visible         =   True
   Width           =   955
   Begin ChartView ChartView1
      AcceptFocus     =   False
      AcceptTabs      =   False
      Animate         =   False
      AnimationHorizontal=   False
      AnimationTime   =   800
      AutoDeactivate  =   True
      Backdrop        =   0
      BackgroundType  =   0
      Border          =   False
      BorderColor     =   &c82879000
      Continuous      =   False
      CrossesBetweenTickMarks=   False
      DisplaySelectionBar=   False
      DoubleBuffer    =   False
      DoubleYAxe      =   False
      DoughnutRadius  =   0.0
      Enabled         =   True
      EnableSelection =   False
      EraseBackground =   True
      FollowAllSeries =   False
      FollowMouse     =   False
      FollowValues    =   False
      Freeze          =   False
      Height          =   275
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      LastError       =   ""
      Left            =   200
      LegendPosition  =   ""
      LiveRefresh     =   False
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Margin          =   20
      PieRadarAngle   =   0.0
      Precision       =   0
      Scope           =   0
      ShowHelpTag     =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Title           =   ""
      Top             =   14
      Transparent     =   True
      Type            =   0
      UseFocusRing    =   True
      Visible         =   True
      Width           =   735
   End
   Begin ChartView ChartView2
      AcceptFocus     =   False
      AcceptTabs      =   False
      Animate         =   False
      AnimationHorizontal=   False
      AnimationTime   =   800
      AutoDeactivate  =   True
      Backdrop        =   0
      BackgroundType  =   0
      Border          =   False
      BorderColor     =   &c82879000
      Continuous      =   False
      CrossesBetweenTickMarks=   False
      DisplaySelectionBar=   False
      DoubleBuffer    =   False
      DoubleYAxe      =   False
      DoughnutRadius  =   0.0
      Enabled         =   True
      EnableSelection =   False
      EraseBackground =   True
      FollowAllSeries =   False
      FollowMouse     =   False
      FollowValues    =   False
      Freeze          =   False
      Height          =   264
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      LastError       =   ""
      Left            =   200
      LegendPosition  =   ""
      LiveRefresh     =   True
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Margin          =   20
      PieRadarAngle   =   0.0
      Precision       =   0
      Scope           =   0
      ShowHelpTag     =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Title           =   ""
      Top             =   301
      Transparent     =   True
      Type            =   0
      UseFocusRing    =   True
      Visible         =   True
      Width           =   735
   End
   Begin Timer Timer1
      Index           =   -2147483648
      InitialParent   =   ""
      LockedInPosition=   False
      Mode            =   0
      Period          =   200
      Scope           =   0
      TabPanelIndex   =   "0"
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   205
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "This example demonstrates real-time data for process monitoring. The ChartView is refreshed with new data every 200 milliseconds."
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   168
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Activate()
		  Timer1.Mode = timer.ModeMultiple
		End Sub
	#tag EndEvent

	#tag Event
		Sub Deactivate()
		  
		  Timer1.Mode = timer.ModeOff
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  
		  
		  
		  ChartView2.Type = ChartView.TypeArea
		  
		  ChartView2.Freeze = True
		  ChartView2.LoadFromCSV(LiveData_csv, False, ";")
		  
		  ChartView2.setTransparency(50)
		  ChartView2.Series(0).MarkerType = ChartSerie.MarkerNone
		  ChartView2.Series(0).LineWeight = 3
		  ChartView2.Axes(1).MaximumScale = 7000
		  ChartView2.Axes(0).LabelInterval = 2
		  
		  
		  ChartView2.Freeze = False
		  ChartView2.Redisplay()
		  
		  Timer1.Mode = Timer.ModeMultiple
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub GetNewData()
		  Dim d As new Date
		  
		  Labels.Append str(d.Hour, "00") + ":" + str(d.Minute, "00") + ":" + str(d.Second, "00") + "." + str(Ticks-(Floor(Ticks/10)*10))
		  
		  Dim r As new Random
		  Dim v As Integer = r.InRange(750, 1750)
		  
		  If v mod 10 = 0 then
		    Values.Append ""
		  else
		    
		    Values.Append v
		  End If
		  
		  If UBound(Labels)>25 then
		    Labels.Remove(0)
		    Values.Remove(0)
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Labels() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Values() As Variant
	#tag EndProperty


#tag EndWindowCode

#tag Events ChartView1
	#tag Event
		Sub Open()
		  me.Title = "Messages Sent / Received"
		  me.Type = ChartView.TypeLine
		  me.Axes(0).LabelInterval = 3
		  me.Axes(1).MinimumScale = 500
		  me.Axes(1).MaximumScale = 2000
		  me.Axes(1).MajorUnit = 500
		  
		  'Break
		  //Needs to fix
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ChartView2
	#tag Event
		Sub Open()
		  me.Title = "Site Activity by Time of Day"
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Timer1
	#tag Event
		Sub Action()
		  
		  
		  If UBound(Labels)=-1 then
		    For i as Integer = 0 to 25
		      GetNewData()
		    Next
		  else
		    GetNewData
		  End If
		  
		  
		  
		  Dim Data As String
		  Dim Lines() As String
		  
		  For i as integer = 0 to UBound(Labels)
		    Lines.Append Labels(i) + ";" + str(Values(i))
		  Next
		  
		  Data = Join(Lines, EndOfLine)
		  
		  ChartView1.Freeze = True
		  ChartView1.LoadFromCSV(Data, False, ";")
		  
		  ChartView1.Series(0).MarkerType = ChartSerie.MarkerNone
		  ChartView1.Series(0).LineWeight = 2
		  'ChartView1.AnimationHorizontal = True
		  ChartView1.Freeze = False
		  ChartView1.Redisplay()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="AllowAutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Tooltip"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DoubleBuffer"
		Visible=true
		Group="Windows Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="InitialParent"
		Visible=false
		Group="Position"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabPanelIndex"
		Visible=false
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabStop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EraseBackground"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
