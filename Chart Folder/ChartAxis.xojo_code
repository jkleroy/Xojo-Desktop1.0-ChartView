#tag Class
Protected Class ChartAxis
	#tag Method, Flags = &h0
		Sub AddZone(startValue As Double, endValue As Double, colorValue As Color)
		  //Adds a zone to the Axis. <br/>
		  //A zone is displayed behind the plot to limit a lower and upper bound value.
		  
		  ZoneStart.Append startValue
		  ZoneEnd.Append endValue
		  ZoneColor.Append colorValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  //#Ignore in LR
		  
		  MaximumScaleIsAuto = True
		  MinimumScaleIsAuto = True
		  MajorUnitIsAuto = True
		  
		  AutoLabel = True
		  AxeLine = New ChartLine
		  LabelPosition = LabelBesidePlot
		  LabelStyle = New ChartLabel
		  
		  Visible = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init(Full As Boolean = False)
		  //Initializes the ChartAxis.<br/>
		  //If Full is True, all Labels are also initialized.
		  
		  LabelIdx = New Dictionary
		  
		  If Full then
		    Redim Label(-1)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LabelIndex(Index As String) As Integer
		  //Returns the Index for the passed String value.
		  
		  If LabelIdx.HasKey(Index) then
		    Return LabelIdx.Value(Index)
		  End If
		  
		  Dim start As Integer
		  If LabelIdx.Count >0 then
		    start = max(0, LabelIdx.Value(LabelIdx.Key(LabelIdx.Count-1)))
		  End If
		  
		  If LabelType = "Date" then
		    
		    For i as Integer = start to UBound(Label)
		      
		      If Index = Label(i).DateValue.SQLDate Then
		        
		        LabelIdx.Value(Index) = i
		        
		        Return i
		        
		      End If
		    Next
		    
		  ElseIf LabelType = "DateTime" then
		    
		    For i as Integer = start to UBound(Label)
		      
		      If Index = Label(i).DateValue.SQLDateTime Then
		        
		        LabelIdx.Value(Index) = i
		        
		        Return i
		        
		      End If
		    Next
		    
		  elseif LabelType = "Integer" then
		    
		    For i as Integer = start to UBound(Label)
		      
		      If val(Index) = Label(i).IntegerValue then
		        LabelIdx.Value(Index) = i
		        
		        Return i
		        
		      End If
		    Next
		    
		  elseif LabelType = "Double" then
		    
		    For i as Integer = start to UBound(Label)
		      
		      If val(Index) = Label(i).DoubleValue then
		        LabelIdx.Value(Index) = i
		        
		        Return i
		        
		      End If
		    Next
		    
		  else //LabelType = String
		    
		    
		    For i as Integer = start to UBound(Label)
		      
		      If Index = Label(i).StringValue then
		        LabelIdx.Value(Index) = i
		        
		        Return i
		        
		      End If
		    Next
		    
		    
		  End If
		  
		  LabelIdx.Value(Index) = -1
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFillColor(C As Color)
		  //Sets the AxeLine color and Text labels color (ChartAxis.ForeColor).
		  
		  AxeLine.FillColor = C
		  ForeColor = C
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AutoLabel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The ChartLine used to draw the Axis.
		#tag EndNote
		AxeLine As ChartLine
	#tag EndProperty

	#tag Property, Flags = &h0
		Crosses As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mCrossesAt
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCrossesAt = value
			  Crosses = CrossCustom
			End Set
		#tag EndSetter
		CrossesAt As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			For continuous values on dates, this defines the minimal step.<br/>
			Accepted values are:<br>
			"second", "s"<br>
			"minute"<br>
			"hour", "h"<br>
			"day", "d"<br>
			"year", "y"<br>
		#tag EndNote
		DateStep As String = "day"
	#tag EndProperty

	#tag Property, Flags = &h0
		ForeColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		Label() As Variant
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LabelIdx As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLabelInterval
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLabelInterval = value
			  LabelIntervalIsAuto = False
			End Set
		#tag EndSetter
		LabelInterval As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		LabelIntervalIsAuto As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1.0
			The position of the Label.
			
			Use the class constants
			*LabelNone
			*LabelBesidePlot
			*LabelInPlot
			
			to set the position of the Label.<br>
			The default is LabelBesidePlot.
			
		#tag EndNote
		LabelPosition As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LabelStyle As ChartLabel
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If UBound(Label)=-1 then
			    Return ""
			  End If
			  
			  'Dim a As Integer = Label(0).Type
			  
			  Select Case Label(0).Type
			  Case Variant.TypeDate
			    Dim D As new Date
			    try
			      D.SQLDateTime = Label(0)
			      Return "Date"
			    Catch UnsupportedFormatException
			      Return ""
			    end try
			    'Return "Date"
			  Case Variant.TypeDouble, Variant.TypeCurrency, Variant.TypeInteger, Variant.TypeSingle
			    Return "Double"
			  Case Variant.TypeArray
			    Return "Array"
			  Case Variant.TypeBoolean
			    Return "boolean"
			  Case Variant.TypeCFStringRef
			    Return "CFStringRef"
			  Case Variant.TypeColor
			    Return ""
			  Case Variant.TypeCString
			    Return ""
			  Case Variant.TypeCurrency
			    Return ""
			  Case Variant.TypeDate
			    Return ""
			  Case Variant.TypeDouble
			    Return ""
			  Case Variant.TypeInteger
			    Return ""
			  Case Variant.TypeNil
			    Return ""
			  Case Variant.TypeObject
			    Return ""
			  Case Variant.TypeOSType
			    Return ""
			  Case Variant.TypePString
			    Return ""
			  Case Variant.TypePtr
			    Return ""
			  Case Variant.TypeSingle
			    Return ""
			  Case Variant.TypeString
			    
			    If Label(0).StringValue.len = 19 then
			      Dim D As new Date
			      try
			        D.SQLDateTime = Label(0)
			        Return "Date"
			      Catch UnsupportedFormatException
			        Return ""
			      end try
			    else
			      Return ""
			    End If
			  Case Variant.TypeStructure
			    Return ""
			  Case Variant.TypeWindowPtr
			    Return ""
			  Case Variant.TypeWString
			    Return ""
			  else
			    Return ""
			  End Select
			End Get
		#tag EndGetter
		LabelType As String
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected LogarithmicBase As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1.0
			If True, the Axis uses a logarithmic base 10 scale.
		#tag EndNote
		LogarithmicScale As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MajorGridLine As ChartLine
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMajorUnit
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMajorUnit = value
			  MajorUnitIsAuto = False
			End Set
		#tag EndSetter
		MajorUnit As Single
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		MajorUnitIsAuto As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMaximumScale
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMaximumScale = value
			  MaximumScaleIsAuto = False
			End Set
		#tag EndSetter
		MaximumScale As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		MaximumScaleIsAuto As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCrossesAt As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMinimumScale
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMinimumScale = value
			  MinimumScaleIsAuto = False
			End Set
		#tag EndSetter
		MinimumScale As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		MinimumScaleIsAuto As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MinorGridLine As ChartLine
	#tag EndProperty

	#tag Property, Flags = &h0
		MinorUnit As Single = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLabelInterval As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLabelType As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The Major Unit.
		#tag EndNote
		Private mMajorUnit As Single = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMaximumScale As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMinimumScale As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The PlotMode property defines the AxisPlotMode used by the axis to plot the data. Possible values are BetweenTicks, OnTicks, OnTicksPadded, where:
			**BetweenTicks plots points in the middle of the range, defined by two ticks.
			**OnTicks plots the points over each tick.
			**OnTicksPadded plots points over each tick with half a step padding applied on both ends of the axis.
		#tag EndNote
		Private PlotMode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Size As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Title of the Axis
		#tag EndNote
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Width in Pixels for 1 unit
		#tag EndNote
		UnitWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Visible As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ZoneColor() As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		ZoneEnd() As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ZoneStart() As Double
	#tag EndProperty


	#tag Constant, Name = CrossAutomatic, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CrossCustom, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CrossMaximum, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CrossMinimum, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.1.0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LabelBesidePlot, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LabelInPlot, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LabelNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PlotBetweenTicks, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PlotOnTicks, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PlotOnTicksPadded, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumScaleIsAuto"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumScaleIsAuto"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Crosses"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CrossesAt"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumScale"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumScale"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Size"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UnitWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoLabel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MajorUnit"
			Visible=false
			Group="Behavior"
			InitialValue="1.0"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinorUnit"
			Visible=false
			Group="Behavior"
			InitialValue="1.0"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MajorUnitIsAuto"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LabelType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DateStep"
			Visible=false
			Group="Behavior"
			InitialValue="day"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LabelInterval"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LabelIntervalIsAuto"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForeColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LogarithmicScale"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LabelPosition"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
