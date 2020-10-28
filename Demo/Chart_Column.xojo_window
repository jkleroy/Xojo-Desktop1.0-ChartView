#tag Window
Begin ContainerControl Chart_Column
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
   Height          =   587
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
   Width           =   965
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
      EraseBackground =   "True"
      FollowAllSeries =   False
      FollowMouse     =   False
      FollowValues    =   False
      Freeze          =   False
      Height          =   482
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      LastError       =   ""
      Left            =   200
      LegendPosition  =   "0"
      LiveRefresh     =   False
      LockBottom      =   True
      LockedInPosition=   True
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
      Top             =   85
      Transparent     =   True
      Type            =   0
      UseFocusRing    =   True
      Visible         =   True
      Width           =   746
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   35
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   200
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Top 4 Billionaires net worth"
      TextAlign       =   1
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   38
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   745
   End
   Begin PopupMenu Ppm_Combine
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Normal\r\nStacked\r\nStacked100"
      Italic          =   False
      Left            =   20
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   334
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   168
   End
   Begin Label Label2
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
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "This example shows a Column and Horizontal Bar chart.\r\nThe data points can be combined in different modes: Normal, Stacked, Stacked100.\r\nSelect an item from the PopupMenu to see the different modes."
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   85
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   168
   End
   Begin Label Label3
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
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
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Combine mode:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   302
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   168
   End
   Begin CheckBox Chk_DataLabel
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Show Labels"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
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
      Scope           =   0
      State           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   383
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   168
   End
   Begin Label Label4
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
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
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Change Orientation:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   422
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   168
   End
   Begin CheckBox Chk_BarChart
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Horizontal"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
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
      Scope           =   0
      State           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   454
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   168
   End
   Begin Label Label5
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   18
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   699
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "source: Forbes.com"
      TextAlign       =   2
      TextColor       =   &c3C3C3C00
      TextFont        =   "System"
      TextSize        =   14.0
      TextUnit        =   0
      Top             =   569
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   246
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  
		  
		  
		  ChartView1.Type = ChartView.TypeColumn
		  
		  ChartView1.Freeze = True
		  ChartView1.LoadFromCSV(Billionaires_csv, False, ";")
		  
		  ChartView1.Axes(1).Title = "Net Worth ($ Billions)"
		  ChartView1.Axes(0).Title = ""
		  ChartView1.Axes(1).MajorGridLine = new ChartLine()
		  ChartView1.Axes(1).MajorGridLine.FillColor = &cEAEAEA
		  
		  ChartView1.setTransparency(10)
		  
		  ChartView1.LegendPosition = ChartView.Position.Right
		  
		  ChartView1.Axes(1).MajorUnit = 5
		  
		  ChartView1.Freeze = False
		  ChartView1.StartAnimation(True, ChartAnimate.kEaseOutBounce)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ChangeType()
		  Chk_DataLabel.Enabled = True
		  
		  If Chk_BarChart.Value then
		    If Ppm_Combine.ListIndex = 0 then
		      ChartView1.Type = ChartView.TypeBar
		    Elseif Ppm_Combine.ListIndex = 1 then
		      ChartView1.Type = ChartView.TypeBarStacked
		    elseif Ppm_Combine.ListIndex = 2 then
		      ChartView1.Type = ChartView.TypeBarStacked100
		    End If
		    
		  else
		    
		    If Ppm_Combine.ListIndex = 0 then
		      ChartView1.Type = ChartView.TypeColumn
		    elseif Ppm_Combine.ListIndex = 1 then
		      ChartView1.Type = ChartView.TypeColumnStacked
		    elseif Ppm_Combine.ListIndex = 2 then
		      
		      ChartView1.Type = ChartView.TypeColumnStacked100
		      Chk_DataLabel.Value = False
		      Chk_DataLabel.Enabled = False
		    End If
		  End If
		  
		  ChartView1.AnimationTime = 1600
		  ChartView1.StartAnimation(True)
		  
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events Ppm_Combine
	#tag Event
		Sub Change()
		  ChangeType()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Chk_DataLabel
	#tag Event
		Sub Action()
		  If me.Value then
		    ChartView1.setDataLabel("", 12, &c0, False, &c0, "\$#.0\ \B")
		    ChartView1.DataLabel.Position = 5
		  else
		    ChartView1.DataLabel = Nil
		  End If
		  
		  ChartView1.Redisplay()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Chk_BarChart
	#tag Event
		Sub Action()
		  ChangeType()
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
