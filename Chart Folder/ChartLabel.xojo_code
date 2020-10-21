#tag Class
Protected Class ChartLabel
	#tag Note, Name = Description
		ChartLabel is the class that contains styling and formatting properties for the Legend and data labels in the ChartView.
		
	#tag EndNote

	#tag Note, Name = See Also
		
		ChartView, ChartSerie, ChartAxis
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			The background color of the Label.
		#tag EndNote
		BackColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True the Text is Bold
		#tag EndNote
		Bold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected BorderColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The color for the Marker.
		#tag EndNote
		DefaultMarkerColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			<br/> 
			For Stacked100 display types, the data labels display the value in percentage.If DisplayRealValue is True, it is the real value that is displayed.
		#tag EndNote
		DisplayRealValue As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F6E6C79206170706C69657320746F2050696520636861727473
		DisplayTitleAndValuePie As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The number format of the data.
			
			For TreeMap Charts, use the FormatTitle constant to draw the Series' title instead of the Value.
		#tag EndNote
		Format As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, a BackColor is applied.
		#tag EndNote
		HasBackColor As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True the text is italic.
		#tag EndNote
		Italic As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			The maximum width of the Labels
		#tag EndNote
		maxWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The Text font.
		#tag EndNote
		Private mTextFont As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The Text size.
		#tag EndNote
		Private mTextSize As Single = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The position of the Label regarding the Serie
		#tag EndNote
		Position As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the text has a shadow. Define the color of the shadow with the ShadowColor property.
		#tag EndNote
		Shadow As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Color of the shadow.
		#tag EndNote
		ShadowColor As Color
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Not supported for the moment
		#tag EndNote
		Protected TextAngle As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Text color.
		#tag EndNote
		TextColor As Color
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mTextFont = "" then
			    Return "System"
			  Else
			    return mTextFont
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTextFont = value
			End Set
		#tag EndSetter
		TextFont As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetWeb
			    If mTextSize = 0 then
			      Return 12
			    End If
			  #endif
			  
			  return mTextSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTextSize = value
			End Set
		#tag EndSetter
		TextSize As Single
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			If True the text is underlined
		#tag EndNote
		Underline As Boolean
	#tag EndProperty


	#tag Constant, Name = FormatTitle, Type = String, Dynamic = False, Default = \"Title", Scope = Public
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
			Name="Format"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplayRealValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasBackColor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultMarkerColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
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
			Name="Bold"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="maxWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Position"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplayTitleAndValuePie"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
