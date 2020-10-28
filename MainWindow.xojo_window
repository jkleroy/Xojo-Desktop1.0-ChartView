#tag Window
Begin Window MainWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   True
   HasBackColor    =   True
   Height          =   642
   ImplicitInstance=   True
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   600
   MinimizeButton  =   True
   MinWidth        =   900
   Placement       =   0
   Resizeable      =   True
   Title           =   "ChartView Demo"
   Visible         =   True
   Width           =   1280
   Begin PagePanel PagePanel1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   642
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelCount      =   11
      Panels          =   ""
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      Top             =   0
      Transparent     =   False
      Value           =   0
      Visible         =   True
      Width           =   1280
   End
   Begin Toolbar1 MainToolbar
      Enabled         =   True
      Index           =   -2147483648
      InitialParent   =   ""
      LockedInPosition=   False
      Scope           =   0
      TabPanelIndex   =   0
      Visible         =   True
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub SelectPage(Page As String)
		  
		  Dim Value As Integer
		  
		  Select Case Page
		  Case "Sales"
		    value = 0
		    
		  Case "Finance"
		    value = 1
		    If cc_Finance is Nil then
		      cc_Finance = New Chart_Finance
		      cc_Finance.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "Olympics"
		    value = 2
		    If cc_Olympics is Nil then
		      cc_Olympics = new Chart_Olympics
		      cc_Olympics.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    else
		      cc_Olympics.Refresh
		    End If
		    
		  Case "Live Data"
		    value = 3
		    If cc_LiveData is Nil then
		      cc_LiveData = new Chart_LiveData
		      cc_LiveData.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		      
		    End If
		    
		  Case "Appearance"
		    value = 4
		    If cc_Appearance is Nil then
		      cc_Appearance = new Chart_Appearance
		      cc_Appearance.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "Column"
		    value = 5
		    If cc_Column is Nil then
		      cc_Column = new Chart_Column
		      cc_Column.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "Line"
		    value = 6
		    If cc_Line is Nil then
		      cc_Line = new Chart_Line
		      cc_Line.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "Scatter"
		    value = 7
		    If cc_Scatter Is Nil Then
		      cc_Scatter = new Chart_Scatter
		      cc_Scatter.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "BoxPlot"
		    value = 8
		    If cc_BoxPlot Is Nil Then
		      cc_BoxPlot = New Chart_BoxPlot
		      cc_BoxPlot.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "Pie"
		    value = 9
		    If cc_Pie is Nil then
		      cc_Pie = new Chart_Pie
		      cc_Pie.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		    End If
		    
		  Case "TreeMap"
		    value = 10
		    If cc_TreeMap is Nil then
		      cc_TreeMap = new Chart_TreeMap
		      cc_TreeMap.EmbedWithinPanel(PagePanel1, Value, 0, 0, PagePanel1.Width, PagePanel1.Height)
		      
		    End If
		    
		  Else
		    Break
		  End Select
		  
		  If PagePanel1.Value <> Value then
		    PagePanel1.Value = Value
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private cc_Appearance As Chart_Appearance
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected cc_BoxPlot As Chart_BoxPlot
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_Column As Chart_Column
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_Finance As Chart_Finance
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_Line As Chart_Line
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_LiveData As Chart_LiveData
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_Olympics As Chart_Olympics
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_Pie As Chart_Pie
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_SalesDashboard As Chart_SalesDashboard
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected cc_Scatter As Chart_Scatter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cc_TreeMap As Chart_TreeMap
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastIndex As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events PagePanel1
	#tag Event
		Sub Open()
		  cc_SalesDashboard = New Chart_SalesDashboard
		  
		  cc_SalesDashboard.EmbedWithinPanel(me, 0, 0, 0, me.Width, me.Height)
		  
		  LastIndex = 3
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MainToolbar
	#tag Event
		Sub Action(item As ToolItem)
		  Select Case Item.Caption
		    
		  Case "Prev"
		    
		    If LastIndex = 3 then
		      SelectPage(me.Item(me.Count-3).Caption)
		      
		      LastIndex = me.Count-3
		    else
		      SelectPage(me.Item(LastIndex-1).Caption)
		      
		      LastIndex = LastIndex-1
		    End If
		    
		    
		    
		  Case "Next"
		    
		    If LastIndex = me.Count-3 then
		      SelectPage(me.Item(3).Caption)
		      
		      LastIndex = 3
		    else
		      SelectPage(me.Item(LastIndex+1).Caption)
		      
		      LastIndex = LastIndex+1
		    End If
		    
		  Case "Purchase", "Donate"
		    
		    ShowURL("https://paypal.me/JeremieLeroy")
		    
		  Else
		    SelectPage(Item.Caption)
		    
		    For i as Integer = 0 to me.Count-1
		      If me.Item(i) = item then
		        LastIndex = i
		        Return
		      End If
		    Next
		    
		  End Select
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
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
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
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
		Name="Interfaces"
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
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
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
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
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
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
