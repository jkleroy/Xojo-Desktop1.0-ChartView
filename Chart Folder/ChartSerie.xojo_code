#tag Class
Protected Class ChartSerie
	#tag Method, Flags = &h0
		Function Average() As Double
		  //#newinversion 1.1
		  //Calculates the Average Value of the ChartSerie
		  
		  
		  
		  Dim i As Integer
		  Dim v As Double
		  Dim count As Double = UBound(Values)
		  
		  Dim cnt As Integer
		  
		  For i = 0 to Count
		    If Values(i).IsNull then Continue
		    
		    v = Values(i) + v
		    cnt = cnt + 1
		    
		  Next
		  
		  Return v/(cnt)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Calc()
		  //Calculates the minValue and maxValue of the ChartSerie
		  
		  
		  If needsCalc then
		    
		    Dim i As Integer
		    Dim v As Double
		    minValue = 2^32
		    maxValue = -2^32
		    minValueIndex = -1
		    maxValueIndex = -1
		    For i = 0 to Count-1
		      If Values(i).IsNull then Continue
		      
		      v = Values(i)
		      
		      TotalValue = TotalValue + v
		      
		      If v < minValue then
		        minValue = v
		        minValueIndex = i
		      End If
		      If v > maxValue then
		        maxValue = v
		        maxValueIndex = i
		      End If
		      
		    Next
		    
		    If Count = 0 then
		      maxValue = 0
		      minValue = 0
		    End If
		    
		    needsCalc = False
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Clone() As ChartSerie
		  //Creates a duplicate of the ChartSerie
		  
		  Dim c As New ChartSerie
		  
		  c.BorderWidth = BorderWidth
		  c.FillColor = FillColor
		  c.FillType = FillType
		  c.LineWeight = LineWeight
		  If MarkerPicture<> Nil then
		    c.MarkerPicture = New Picture(MarkerPicture.Width, MarkerPicture.Height, MarkerPicture.Depth)
		    c.MarkerPicture.Graphics.DrawPicture(MarkerPicture, 0, 0)
		  End If
		  c.MarkerSize = MarkerSize
		  c.maxValue = maxValue
		  c.minValue = minValue
		  c.needsCalc = needsCalc
		  c.SecondaryAxis = SecondaryAxis
		  c.Title = Title
		  c.Transparency = Transparency
		  
		  Dim i, U As Integer
		  U = UBound(Values)
		  For i = 0 to U
		    c.Values.Append Values(i)
		  Next
		  
		  Return C
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  needsCalc = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Data() As Variant
		  //Returns all Data as a Variant.
		  
		  Return Values
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Data(assigns v As Variant)
		  //Assigns new Data to the ChartSerie.
		  
		  'Values = v
		  needsCalc = True
		  
		  If v.IsArray And (v.ArrayElementType = Variant.TypeInt32 or v.ArrayElementType = Variant.typeInt64) Then
		    
		    Dim a() As Integer
		    a() = v
		    
		    For i as Integer = 0 to UBound(a)
		      Values.Append a(i)
		    Next
		    
		  elseIf v.IsArray then
		    
		    Dim a() As Double
		    a() = v
		    
		    For i as Integer = 0 to UBound(a)
		      Values.Append a(i)
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetValues2() As Variant
		  //Returns all Values as a Variant.
		  
		  Return Values
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init()
		  //Initializes the ChartSerie by deleting all stored Values.
		  
		  Redim Values(-1)
		  minValue = 0.0
		  maxValue = 0.0
		  needsCalc = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_compare(s As ChartSerie) As Integer
		  If s is Nil then
		    If self is Nil then
		      Return 0
		    Else
		      Return 1
		    End If
		  End If
		  
		  If s.needsCalc then
		    s.Calc()
		  End If
		  If self.needsCalc then
		    self.Calc()
		  End If
		  
		  If self.TotalValue = s.TotalValue then
		    Return 0
		  End If
		  If self.TotalValue > s.TotalValue then
		    Return 1
		  End If
		  If self.TotalValue < s.TotalValue then
		    Return -1
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetValues2(assigns v As Variant)
		  //Assigns new values to the ChartSerie.
		  
		  'Values = v
		  needsCalc = True
		  
		  If v.IsArray and v.ArrayElementType = Variant.TypeInteger then
		    
		    Dim a() As Integer
		    a() = v
		    
		    For i as Integer = 0 to UBound(a)
		      Values.Append a(i)
		    Next
		    
		  elseIf v.IsArray then
		    
		    Dim a() As Double
		    a() = v
		    
		    For i as Integer = 0 to UBound(a)
		      Values.Append a(i)
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SumSquared() As Double
		  //#newinversion 1.3
		  //Calculates the Sum of squared Values of the ChartSerie
		  
		  
		  
		  Dim i As Integer
		  Dim v As Double
		  Dim count As Double = UBound(Values)
		  
		  
		  
		  For i = 0 to Count
		    If Values(i).IsNull then Continue
		    
		    v = Values(i)^2 + v
		  Next
		  
		  Return v
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SumXY(X() As Double) As Double
		  //#newinversion 1.3
		  //Calculates the Sum of XiYi Values of the ChartSerie
		  
		  
		  
		  Dim i As Integer
		  Dim v As Double
		  Dim count As Double = UBound(Values)
		  
		  
		  For i = 0 to Count
		    If Values(i).IsNull then Continue
		    
		    v = Values(i)*X(i) + v
		    
		  Next
		  
		  Return v
		  
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Class Constants
		
		FillNone
		FillSolid
		FillPicture
		
		MarkerNone
		MarkerOval
		MarkerSquare
		MarkerTexture
	#tag EndNote

	#tag Note, Name = Description
		
		ChartSerie holds the values to display in the [[ChartView]] for one serie.
		It also contains all drawing options 
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			The width of the border for ChartRadarFill, ChartArea and ChartAreaStepped view types.
		#tag EndNote
		BorderWidth As Integer = 1
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The number of values in the ChartSerie.
		#tag EndNote
		#tag Getter
			Get
			  return UBound(Values)+1
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			The display color of the ChartSerie.
		#tag EndNote
		FillColor As Color = &c000001
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Defines the type of fill used for all charts except ChartLine.
			See the Fill... class constants in the description of ChartSerie.
		#tag EndNote
		FillType As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		Labels() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Weight of the line. This property defaults to 1px.
		#tag EndNote
		LineWeight As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#ignore in LR
		#tag EndNote
		mArcAngles() As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If MarkerType = MarkerTexture, this property holds the texture that will be used to draw the Marker.
		#tag EndNote
		MarkerPicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Size of the Marker for Line Charts and Area Charts.
			Default value is 9 pixels.
		#tag EndNote
		MarkerSize As Integer = 9
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Type of the Marker.
			Use the Class Constants MarkerNone, MarkerOval, MarkerSquare and MarkerTexture.
		#tag EndNote
		MarkerType As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.3
			If True, this means that the ChartSerie is treated as a Markline.
		#tag EndNote
		MarkLine As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			After calling the Calc function, this property holds the maximum value.
		#tag EndNote
		maxValue As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1
			The Index for the maximal value
		#tag EndNote
		maxValueIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			After calling the Calc function, this property holds the minimum value.
		#tag EndNote
		minValue As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1
			The Index for the minimal value
		#tag EndNote
		minValueIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#ignore in LR
		#tag EndNote
		mPts() As REALbasic.Point
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#ignore in LR
		#tag EndNote
		mStartAngles() As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#ignore in LR
		#tag EndNote
		needsCalc As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the ChartSerie will use the second Y axis.
		#tag EndNote
		SecondaryAxis As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			
			This property only applies to Line charts.
			If True, the lines have a shadow.
			Use ShadowColor to define the color and Alpha.
		#tag EndNote
		Shadow As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			
			This property only applies to Line charts.
			If Shadow is True, the shadow will be displayed using this color.
		#tag EndNote
		ShadowColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The ChartSerie's title.
		#tag EndNote
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1
			After calling the Calc function, this property holds the sum of all Values
		#tag EndNote
		TotalValue As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Transparency of the ChartSerie's fillcolor.
			
			Use a value between 0 (completely opaque) to 100 (completely transparent).
		#tag EndNote
		Transparency As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1.0
			For ComboCharts, the type of chart is directly defined in the ChartSerie.
		#tag EndNote
		Type As Integer = 100
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Values of the ChartSerie.
		#tag EndNote
		Values() As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.3
			For Scatter charts the X value needs to be defined.
		#tag EndNote
		X() As Variant
	#tag EndProperty


	#tag Constant, Name = FillNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillPicture, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillSolid, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Double, Dynamic = False, Default = \"1.3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MarkerNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MarkerOval, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MarkerSquare, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MarkerTexture, Type = Double, Dynamic = False, Default = \"5", Scope = Public
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
			Name="minValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="maxValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="needsCalc"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineWeight"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparency"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SecondaryAxis"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillType"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MarkerType"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MarkerSize"
			Visible=false
			Group="Behavior"
			InitialValue="9"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MarkerPicture"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="minValueIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="maxValueIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TotalValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Shadow"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShadowColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MarkLine"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
