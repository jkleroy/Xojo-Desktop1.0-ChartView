#tag Class
Protected Class ChartDataPoint
	#tag Method, Flags = &h0
		Sub Constructor(Serie As ChartSerie, Index As Integer, Label As String, Value As Single)
		  self.Serie = Serie
		  self.Index = Index
		  self.Label = Label
		  self.Value = Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(d As ChartDataPoint) As Integer
		  If d is Nil then
		    If self is Nil then
		       Return 0
		    Else
		      Return 1
		    End If
		  End If
		  
		  
		  If d.Serie = self.Serie and d.Index = self.Index and d.Label = self.Label then
		    
		    Return 0
		    
		  else
		    
		    Return -1
		    
		  End If
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		FillColor As Color = &c000001
	#tag EndProperty

	#tag Property, Flags = &h0
		Index As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Label As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Selected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Serie As ChartSerie
	#tag EndProperty

	#tag Property, Flags = &h0
		Value As Single
	#tag EndProperty


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Label"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000001"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Selected"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
