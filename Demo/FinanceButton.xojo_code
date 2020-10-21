#tag Class
Protected Class FinanceButton
Inherits Canvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  If Active then Return False
		  
		  
		  Dim i As Integer
		  
		  For i = 0 to self.Window.ControlCount-1
		    
		    If self.Window.Control(i) isa FinanceButton then
		      FinanceButton(self.Window.Control(i)).Active = False
		    End If
		    
		  Next
		  
		  
		  Action()
		  Active = True
		  
		  Refresh(False)
		  
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  MouseOver = True
		  
		  Refresh(False)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  MouseOver = False
		  
		  Refresh(False)
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #Pragma Unused areas
		  
		  If Active and ChartPic <> Nil then
		    
		    Dim p As Picture
		    Dim Scale As Integer = ScalingFactor
		    If Scale > 1 then
		      p = New Picture(Width*2, Height*2, 32)
		      
		    else
		      p = New Picture(Width, Height, 32)
		    End If
		    
		    Dim gp As Graphics = p.Graphics
		    gp.DrawPicture(ChartPic, 0, 0, gp.Width, gp.Height, 0, 0, ChartPic.Width, ChartPic.Height)
		    
		    
		    gp = p.Mask.graphics
		    gp.ForeColor = &cFFFFFF
		    gp.AAG_FillAll
		    'p.Mask(True).Graphics.ForeColor = &cFFFFFF
		    If TargetWin32 then 'and App.UseGDIPlus=False then
		      gp.AAG_FillRoundRectA(0, 0, Width, Height, 8, -1, True)
		    else
		      gp.ForeColor = &c0
		      gp.FillRoundRect(0, 0, gp.Width, gp.Height, 8*scale, 8*scale)
		    End If
		    
		    g.DrawPicture(p, 0, 0, g.Width, g.Height, 0, 0, p.Width, p.Height)
		    
		    
		  else
		    
		    
		    
		    g.ForeColor = &c3366CC
		    If TargetWin32 then 'and App.UseGDIPlus = False then
		      g.AAG_FillRoundRectA(0, 0, g.Width, g.Height, 8)
		    else
		      g.FillRoundRect(0, 0, g.Width, g.Height, 8, 8)
		    End If
		    
		    g.ForeColor = &cFFFFFF
		    
		    g.TextSize = 16
		    g.Bold = True
		    g.DrawString(Caption, (g.Width - g.StringWidth(Caption))\2, (g.Height-g.TextHeight)\2 + g.TextAscent)
		    
		    If MouseOver then
		      If TargetWin32 then 'and App.UseGDIPlus = False then
		        g.AAG_DrawRoundRectA(2, 2, g.Width-4, g.Height-4, 8)
		      else
		        g.DrawRoundRect(2, 2, g.Width-4, g.Height-4, 8, 8)
		      End If
		    End If
		    
		    
		    
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Push()
		  Active = True
		  
		  Action()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ScalingFactor() As Single
		  #If TargetCocoa Then
		    Try
		      Soft Declare Function BackingScaleFactor Lib "AppKit" Selector "backingScaleFactor" (target As Integer) As Double
		      Return BackingScaleFactor(me.TrueWindow.Handle)
		    Catch e As ObjCException
		      Return 1
		    End Try
		  #Else
		    Return 1
		  #Endif
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Action()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mActive
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mActive = value
			  
			  Refresh(False)
			End Set
		#tag EndSetter
		Active As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ChartPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mActive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MouseOver As Boolean
	#tag EndProperty


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
			InitialValue="True"
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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
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
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
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
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group=""
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Caption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Active"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ChartPic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MouseOver"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
