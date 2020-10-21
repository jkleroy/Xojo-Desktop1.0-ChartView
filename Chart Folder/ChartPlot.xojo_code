#tag Class
Protected Class ChartPlot
	#tag Method, Flags = &h0
		Sub Constructor()
		  FillType = FillNone
		  FillColor = &cFFFFFF
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  If FillType = FillNone then Return
		  
		  Dim gg As Graphics
		  Dim p As Picture
		  
		  If Transparency > 0 and FillType<>FillNone then
		    
		    p = New Picture(Width, Height, 32)
		    gg = p.Mask.Graphics
		    gg.ForeColor = RGB(255*Transparency/100, 255*Transparency/100, 255*Transparency/100)
		    gg.FillRect(0, 0, Width, Height)
		    gg = p.Graphics
		    
		  elseif FillType <> FillNone then
		    
		    gg = g.Clip(Left, Top, Width, Height)
		    
		  End If
		  
		  If FillType = FillSolid then
		    
		    gg.ForeColor = FillColor
		    gg.FillRect(0, 0, Width, Height)
		    
		  elseif FillType = FillGradient then
		    
		    //Gradient code
		    
		  End If
		  
		  If Transparency > 0 and FillType <> FillNone then
		    
		    g.DrawPicture(p, Left, Top)
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		#tag Note
			The color use to fill the Plot area when Filltype = FillSolid.
		#tag EndNote
		FillColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The 
		#tag EndNote
		FillType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		GradientColor() As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		Height As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Left As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			For Pi and Radar Charts the Radius needs to be saved.
		#tag EndNote
		Radius As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Top As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Transparency As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Width As Integer
	#tag EndProperty


	#tag Constant, Name = FillGradient, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FillNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillSolid, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.3.0", Scope = Public
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
			Name="FillType"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
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
			Name="Radius"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
