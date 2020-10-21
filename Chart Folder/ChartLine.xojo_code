#tag Class
Protected Class ChartLine
	#tag Method, Flags = &h0
		Sub Constructor()
		  //The default constructor.
		  
		  FillType = FillAutomatic
		  FillColor = &c0
		  Width = 1
		  Visible = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lineColor As Color, lineWidth As Integer = 1, lineType As Integer = 1)
		  //The other Constructor syntax.
		  
		  FillColor = lineColor
		  Width = lineWidth
		  FillType = lineType
		End Sub
	#tag EndMethod


	#tag Note, Name = Constants
		
		FillNone | 0
		FillSolid | 1
		FillAutomatic | 3
	#tag EndNote

	#tag Note, Name = Description
		
		ChartLine is the class used to define ChartAxis lines (the Axis, the MajorGridLines, the MinorGridLines).
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			The color used to fill the line when Filltype = FillSolid.
		#tag EndNote
		FillColor As Color = &c000000
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The type of fill for the line.
			See the class constants for the different values this property can take.
		#tag EndNote
		FillType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If the line is Visible
		#tag EndNote
		Visible As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The width of the line. The default is 1.
		#tag EndNote
		Width As Integer
	#tag EndProperty


	#tag Constant, Name = FillAutomatic, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillGradient, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FillNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillSolid, Type = Double, Dynamic = False, Default = \"1", Scope = Public
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
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillType"
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
			Name="Visible"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
