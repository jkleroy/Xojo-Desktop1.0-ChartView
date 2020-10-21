#tag Class
Protected Class ChartTreemapRow
	#tag Method, Flags = &h0
		Sub AddSerie(S As ChartSerie)
		  Series.Append S
		  total = total + S.TotalValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetupChildren()
		  #if False
		    Dim row As ChartTreemapRow
		    Dim values() As Double
		    Dim indexes() As Integer
		    
		    Dim i, j As Integer
		    
		    For i = 0 to UBound(Series)
		      
		      If Series(i).Values.Ubound>0 then
		        
		        row.Series.Append Series(i)
		        
		        Values = Series(i).GetValues()
		        For j = 0 to UBound(Series(i).Values)
		          values.Append Series(i).Values(j).DoubleValue
		          indexes.Append j
		        Next
		        
		        Values.SortWith(indexes)
		        
		        
		        //Organizing the TreeMap
		        While UBound(Values) > -1
		          
		          current = DispSeries.Pop
		          
		          If row.Worst >= row.Worst(current) then
		            row.AddSerie current
		          else
		            Rows.Append row
		            row.SetupChildren()
		            lastRow = row
		            row = new ChartTreemapRow
		            row.AddSerie Current
		            GrandTotal = GrandTotal - lastRow.total
		            row.GrandTotal = GrandTotal
		            
		            If lastRow.vertical then
		              row.X = lastRow.X + lastRow.Width
		              row.Y = lastRow.Y
		              
		            else
		              row.X = lastRow.X
		              row.Y = lastRow.Y + lastRow.Height
		            End If
		            
		            row.AvailableW = g.Width - row.X
		            row.AvailableH = g.Height - row.Y
		            
		          End If
		        Wend
		        
		        
		      Else
		        
		        Children.Append Nil
		        
		      End If
		      
		    Next
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Worst(S As ChartSerie = Nil) As Single
		  
		  Dim mTotal As Double
		  mTotal = total
		  
		  Dim MasterW, MasterH As Integer
		  Dim Ratio As Single
		  Dim W, H As Single
		  
		  If S is Nil then
		    
		    If AvailableW >= AvailableH then
		      Vertical = True
		      
		      //Calculating Width Height of the Row
		      MasterH = AvailableH
		      MasterW = Round(mTotal / GrandTotal * AvailableW)
		      
		      W = MasterW
		      For i as Integer = 0 to UBound(Series)
		        H = Series(i).TotalValue / mTotal * MasterH
		        If W > H then
		          Ratio = max(Ratio, W/H)
		        else
		          Ratio = max(Ratio, H/W)
		        End If
		      Next
		      
		      
		    Else
		      Vertical = False
		      //Calculating Width Height of the Row
		      MasterW = AvailableW
		      MasterH = Round(mTotal / GrandTotal * AvailableH)
		      
		      H = MasterH
		      For i as Integer = 0 to UBound(Series)
		        
		        W = Series(i).TotalValue / mTotal * MasterW
		        If W > H then
		          Ratio = max(Ratio, W/H)
		        else
		          Ratio = max(Ratio, H/W)
		        End If
		      Next
		      
		    End If
		    
		    Width = MasterW
		    Height = MasterH
		    
		  Else
		    
		    //Calculate with one more Serie
		    mTotal = mTotal + S.TotalValue
		    
		    If AvailableW >= AvailableH then
		      
		      //Calculating Width Height of the Row
		      MasterH = AvailableH
		      MasterW = Round(mTotal / GrandTotal * AvailableW)
		      
		      W = MasterW
		      For i as Integer = 0 to UBound(Series)
		        
		        H = Series(i).TotalValue / mTotal * MasterH
		        If W > H then
		          Ratio = max(Ratio, W/H)
		        else
		          Ratio = max(Ratio, H/W)
		        End If
		      Next
		      
		      
		      H = S.TotalValue / mTotal * MasterH
		      If W > H then
		        Ratio = max(Ratio, W/H)
		      else
		        Ratio = max(Ratio, H/W)
		      End If
		      
		      
		    Else
		      
		      //Calculating Width Height of the Row
		      MasterW = AvailableW
		      MasterH = Round(mTotal / GrandTotal * AvailableH)
		      
		      H = MasterH
		      For i as Integer = 0 to UBound(Series)
		        
		        W = Series(i).TotalValue / mTotal * MasterW
		        If W > H then
		          Ratio = max(Ratio, W/H)
		        else
		          Ratio = max(Ratio, H/W)
		        End If
		      Next
		      
		      
		      W = S.TotalValue / mTotal * MasterW
		      If W > H then
		        Ratio = max(Ratio, W/H)
		      else
		        Ratio = max(Ratio, H/W)
		      End If
		      
		      
		    End If
		  End If
		  
		  Return Ratio
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AvailableH As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		AvailableW As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Children() As ChartTreemapRow
	#tag EndProperty

	#tag Property, Flags = &h0
		GrandTotal As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Height As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Index As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Series() As ChartSerie
	#tag EndProperty

	#tag Property, Flags = &h0
		total As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Vertical As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Width As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		X As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Y As Integer
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
			Name="X"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AvailableW"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AvailableH"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="total"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GrandTotal"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
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
			Name="Vertical"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
