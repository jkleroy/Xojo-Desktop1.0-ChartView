#tag Module
Protected Module AntialiasedGraphics
	#tag Method, Flags = &h0
		Sub AAG_AngleGradient(extends g as Graphics, X As Integer, Y As Integer, Width As Integer, Height As Integer, StartColor As Color = &c0, EndColor As Color = &cFFFFFF)
		  //A corriger pour l'angle
		  
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Dim p As Picture
		  If AntiAliased then
		    p = New Picture(Width, Height)
		  Else
		    p = New Picture(Width, Height, 32)
		  End If
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  
		  #If DebugBuild
		    Dim breaki As Integer = -1, breakj As Integer = -1
		  #endif
		  
		  s = p.RGBSurface
		  
		  Dim length As Double
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim ratio, endratio As Single
		  Dim Max As Single = Sqrt(Width*Width + Height*Height)
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      
		      #If DebugBuild
		        If i = breaki and j = breakj then break
		      #endif
		      
		      length = Sqrt(i*i+j*j)
		      
		      // Determine the current line's color
		      ratio = ((max-length)/max)
		      endratio = 1.0-ratio
		      
		      s.Pixel(i,j) = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		      
		    next
		  next
		  
		  g.DrawPicture(p, X, Y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawDottedLineA(extends g As Graphics, x1 As Double, y1 As Double, x2 As Double, y2 As Double, DotLength As Single = 1.0, DeltaLength As Single=1.0, Weight As Single= 1.0, ShadeLength As Single = 1.0)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  'dim mp As new MethodProfiler2(CurrentMethodName)
		  
		  Dim Width, Height As Integer
		  
		  Width = Abs(x2 - x1)+1
		  Height = Abs(y2 - y1)+1
		  
		  If (Width = 1 or Height = 1) And Ceil(x1)=Floor(x1) And Floor(y1)=Ceil(y1) then
		    Width = Width + Ceil(ShadeLength)*2
		    Height = Height + Ceil(ShadeLength)*2
		    
		  End If
		  
		  If Width>16000 or Height > 16000 then Return
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  Dim gp As Graphics = p.Graphics
		  
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  
		  gp = p.Mask.Graphics
		  gp.ForeColor = &cFFFFFF
		  gp.FillRect(0, 0, Width, Height)
		  
		  Dim s As RGBSurface = p.Mask.RGBSurface
		  Dim i, j as integer
		  
		  If Height = 1 then
		    Width = Width-1
		    
		    DotLength = Round(DotLength)
		    DeltaLength = Round(DeltaLength)
		    
		    If DotLength = 1.0 then
		      For i = 0 to Width step DeltaLength
		        
		        s.Pixel(i, 0) = &c0
		        
		      Next
		      
		    else //DotLength >1.0
		      gp.ForeColor = &c0
		      For i = 0 to Width step DeltaLength+DotLength
		        gp.DrawLine(i, 0, i+DotLength, 0)
		      Next
		    End If
		    
		  elseif Width = 1 then
		    Height = Height-1
		    
		    DotLength = Round(DotLength)
		    DeltaLength = Round(DeltaLength)
		    
		    If DotLength = 1.0 then
		      gp.Pixel(0, i) = &c0
		      
		      For i = 0 to Height step DeltaLength
		        
		        s.Pixel(0, i) = &c0
		        
		      Next
		      
		    else //DotLength>1.0
		      gp.ForeColor = &c0
		      For i = 0 to Height step DeltaLength+DotLength
		        gp.DrawLine(0, i, 0, i+DotLength)
		      Next
		    End If
		    
		  else
		    
		    
		    
		    
		    Dim a, b, u As Double
		    //y=a*x+b
		    If x1-X2 = 0 then
		      a = -1
		    else
		      a = (Y1 - Y2) / (X1 - X2)
		    End If
		    If a < 0 then
		      b = Height-1
		    End If
		    u = Sqrt(a^2 + 1)
		    
		    
		    Dim length, length2 As Double
		    Dim tmpC As Double
		    
		    Dim ColW As Integer = 255
		    Dim ColStart As Integer = 0
		    
		    
		    Height = Height - 1
		    Width = Width - 1
		    
		    Weight = Weight/2
		    Dim Total As Single = Weight + ShadeLength
		    Dim Drawn As Boolean
		    
		    If x2>x1 and y2>y1 then //Going down-right
		      
		      Dim start As Integer = 0
		      
		      For j = 0 to Height
		        Drawn = False
		        For i = start to Width
		          length = Abs(a * i - j + b) / u
		          
		          
		          If length > Total then
		            //Improves performance
		            If Drawn then
		              Continue for j
		            else
		              Continue for i
		            End If
		            
		          elseif length <= Weight then
		            tmpC = ColStart
		            If not Drawn then
		              start = max(0, i)
		              Drawn = true
		            End If
		          Else
		            tmpC = max(0, ((length-Weight) / ShadeLength) * ColW + ColStart)
		            If not Drawn then
		              start = max(0, i)
		              Drawn = true
		            End If
		          End If
		          
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        Next
		      Next
		      
		    else //going down-left
		      
		      Dim finish As Integer = Width
		      
		      For j = 0 to Height
		        Drawn = False
		        For i = finish DownTo 0
		          length = Abs(a * i - j + b) / u
		          length2 = Sqrt(i^2+j^2)
		          
		          'If length2 - Floor((length2 / (DotLength+DeltaLength))*(DotLength+DeltaLength) > DotLength then
		          '//Improves performance
		          'If Drawn then
		          'Continue for j
		          'else
		          'Continue for i
		          'End If
		          'End If
		          
		          If length > Total then
		            //Improves performance
		            If Drawn then
		              Continue for j
		            else
		              Continue for i
		            End If
		          elseif length <= Weight then
		            tmpC = ColStart
		            If not Drawn then
		              finish = min(Width, i)
		              Drawn = true
		            End If
		          Else
		            tmpC = max(0, ((length-Weight) / ShadeLength) * ColW + ColStart)
		            If not Drawn then
		              finish = min(Width, i)
		              Drawn = true
		            End If
		          End If
		          
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        Next
		      Next
		    End If
		    
		    
		  End If
		  
		  g.DrawPicture(p, min(x1, x2), min(y1,y2))
		  
		  If KeepInBuffer then
		    Buffer = p
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawDottedRect(extends g As Graphics, x1 As Double, y1 As Double, w As Double, h As Double, DotLength As Single = 1.0, DeltaLength As Single=1.0, Weight As Single= 1.0, ShadeLength As Single = 1.0)
		  
		  Dim x2, y2 As Double
		  
		  x2 = x1+w-1
		  y2 = y1+h-1
		  
		  //Horizontal
		  KeepInBuffer = True
		  g.AAG_DrawDottedLineA(x1, y1, x2, y1, DotLength, DeltaLength, Weight, ShadeLength)
		  g.DrawPicture(Buffer, min(x1, x2), y2)
		  'g.DrawDottedLineA(x1, y2, x2, y2, DotLength, DeltaLength, Weight, ShadeLength)
		  
		  g.AAG_DrawDottedLineA(x1, y1, x1, y2, DotLength, DeltaLength, Weight, ShadeLength)
		  g.DrawPicture(Buffer, x2, min(y1,y2))
		  'g.DrawDottedLineA(x2, y1, x2, y2, DotLength, DeltaLength, Weight, ShadeLength)
		  
		  Buffer = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawDottedRoundRectA(extends g As graphics, X As Double, Y As Double, Width As Double, Height As Double, Arc As Double)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  Arc = min(Arc, Width/2, Height/2)
		  
		  Dim ExteriorColor As Color = &cFFFFFF, CenterColor As Color = &c0
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  Dim X1,Y1,X2,Y2 As Double
		  Dim X1a,Y1a,X2a,Y2a As Double
		  X1 = 0
		  Y1 = 0
		  X2 = Width-1
		  Y2 = Height-1
		  
		  X1a = X1+Arc
		  X2a = X2-Arc
		  Y1a = Y1+Arc
		  Y2a = Y2 -Arc
		  
		  #If DebugBuild
		    Dim breaki As Integer = -1, breakj As Integer = -1
		  #endif
		  
		  Dim ShadeLength As Double
		  If Arc < 5 then
		    ShadeLength = Sqrt(Arc)
		  else
		    ShadeLength = 2.5
		  End If
		  ' = 2.1 'Sqrt(Arc)
		  
		  s = p.mask.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  Dim Last As Boolean
		  
		  for j = 0 to pH
		    If j mod 2 = 1 then
		      last = True
		    else
		      last = False
		    End If
		    for i = 0 to pW
		      last = not last
		      
		      #If DebugBuild
		        If i = breaki and j = breakj then break
		      #endif
		      
		      If last then
		        s.Pixel(i,j) = ExteriorColor
		        Continue for i
		      End If
		      
		      If i>=X1a and i<=X2a and (j=Y1 or j=Y2) then
		        s.Pixel(i,j)=CenterColor
		      elseif j>=Y1a and j<=Y2a and (i=X1 or i=X2) then
		        s.Pixel(i,j)=CenterColor
		      Elseif (i>=X1 and i<X1a and j>=Y1 and j<Y1a) or (i<=X2 and i>X2a and j>=Y1 and j<Y1a) or (i>=X1 and i<X1a and j<=Y2 and j>Y2a) or (i<=X2 and i>X2a and j<=Y2 and j>Y2a) then
		        
		        length = Min(Sqrt((X1a-i)^2+(Y1a-j)^2), Sqrt((X2a-i)^2+(Y1a-j)^2), Sqrt((X2a-i)^2+(Y2a-j)^2), Sqrt((X1a-i)^2+(Y2a-j)^2))
		        
		        If length = Arc then
		          s.Pixel(i,j) = CenterColor
		        elseif length<Arc then
		          length = 2*Arc - length+1
		          tmpC = ((length-Arc+1) / (ShadeLength)) * ColW + ColStart + length
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        elseif length<=Arc+ShadeLength then
		          
		          tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        else
		          s.Pixel(i,j) = ExteriorColor
		        End If
		      else
		        s.Pixel(i,j) = ExteriorColor
		      End If
		    next
		  next
		  
		  #If DebugBuild and Debug
		    s.Pixel(X1a,Y1a)= &c0
		    s.Pixel(X2a,Y2a) = &c0
		    s.Pixel(X1a,Y2a)= &c0
		    s.Pixel(X2a,Y1a) = &c0
		  #endif
		  
		  g.DrawPicture(p, X, Y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawLineA(extends g As Graphics, x1 As Double, y1 As Double, x2 As Double, y2 As Double, Weight As Single= 1.0, ShadeLength As Single = 1.0)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  
		  
		  Dim Width, Height As Integer
		  
		  Width = Abs(x2 - x1)+1
		  Height = Abs(y2 - y1)+1
		  
		  If (Width = 1 or Height = 1) And Ceil(x1)=Floor(x1) And Floor(y1)=Ceil(y1) then
		    Width = Width + Ceil(ShadeLength)*2
		    Height = Height + Ceil(ShadeLength)*2
		    
		    If (Width = 1 or Height = 1) then
		      g.PenWidth = Weight
		      g.PenHeight = Weight
		      g.DrawLine(x1, y1, x2, y2)
		      Return
		    End If
		  End If
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  Dim gp As Graphics = p.Graphics
		  
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  
		  gp = p.Mask.Graphics
		  gp.ForeColor = &cFFFFFF
		  gp.FillRect(0, 0, Width, Height)
		  
		  Dim s As RGBSurface = p.Mask.RGBSurface
		  
		  Dim i, j as integer
		  Dim a, b, u As Double
		  //y=a*x+b
		  If x1-X2 = 0 then
		    a = -1
		  else
		    a = (Y1 - Y2) / (X1 - X2)
		  End If
		  If a < 0 then
		    b = Height-1
		  End If
		  u = Sqrt(a^2 + 1)
		  
		  
		  Dim length As Double
		  Dim tmpC As Double
		  
		  Dim ColW As Integer = 255
		  Dim ColStart As Integer = 0
		  
		  
		  Height = Height - 1
		  Width = Width - 1
		  
		  Weight = Weight/2
		  Dim Total As Single = Weight + ShadeLength
		  Dim Drawn As Boolean
		  
		  If x2>x1 and y2>y1 then //Going down-right
		    
		    Dim start As Integer = 0
		    
		    For j = 0 to Height
		      Drawn = False
		      For i = start to Width
		        length = Abs(a * i - j + b) / u
		        
		        
		        If length > Total then
		          //Improves performance
		          If Drawn then
		            Continue for j
		          else
		            Continue for i
		          End If
		          
		        elseif length <= Weight then
		          tmpC = ColStart
		          If not Drawn then
		            start = max(0, i)
		            Drawn = true
		          End If
		        Else
		          tmpC = max(0, ((length-Weight) / ShadeLength) * ColW + ColStart)
		          If not Drawn then
		            start = max(0, i)
		            Drawn = true
		          End If
		        End If
		        
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Next
		    Next
		    
		  else //going down-left
		    
		    Dim finish As Integer = Width
		    
		    For j = 0 to Height
		      Drawn = False
		      For i = finish DownTo 0
		        length = Abs(a * i - j + b) / u
		        
		        
		        If length > Total then
		          //Improves performance
		          If Drawn then
		            Continue for j
		          else
		            Continue for i
		          End If
		        elseif length <= Weight then
		          tmpC = ColStart
		          If not Drawn then
		            finish = min(Width, i)
		            Drawn = true
		          End If
		        Else
		          tmpC = max(0, ((length-Weight) / ShadeLength) * ColW + ColStart)
		          If not Drawn then
		            finish = min(Width, i)
		            Drawn = true
		          End If
		        End If
		        
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Next
		    Next
		  End If
		  
		  g.DrawPicture(p, min(x1, x2), min(y1,y2))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawLineAFill(extends g As Graphics, x1 As Double, y1 As Double, x2 As Double, y2 As Double, ShadeLength As Double = 1, FillLeft As Boolean = False)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Dim Width, Height As Integer
		  
		  Width = Abs(x2 - x1)+1
		  Height = Abs(y2 - y1)+1
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  Dim gp As Graphics = p.Graphics
		  
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  If (Width = 1 or Height = 1) And Ceil(x1)=Floor(x1) And Floor(y1)=Ceil(y1) then
		    g.DrawPicture(p, x1, y1)
		    Return
		  End If
		  
		  gp = p.Mask.Graphics
		  gp.ForeColor = &cFFFFFF
		  gp.FillRect(0, 0, Width, Height)
		  
		  Dim s As RGBSurface = p.Mask.RGBSurface
		  
		  Dim i, j as integer
		  Dim a, b, u As Double
		  //y=a*x+b
		  If x1-X2 = 0 then
		    a = -1
		  else
		    a = (Y1 - Y2) / (X1 - X2)
		  End If
		  If a < 0 then
		    b = Height-1
		  End If
		  u = Sqrt(a^2 + 1)
		  
		  Dim ExteriorColor As Color = &cFFFFFF, CenterColor As Color = &c0
		  Dim length As Double
		  Dim tmpC As Double
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  Height = Height - 1
		  Width = Width - 1
		  
		  Dim FillNegative As Boolean
		  If a > 0 and FillLeft then
		    FillNegative = True
		  elseif a > 0 and not FillLeft then
		    FillNegative = False
		  elseif a < 0 and FillLeft then
		    FillNegative = False
		  else
		    FillNegative = True
		  End If
		  
		  
		  For j = 0 to Height
		    For i = 0 to Width
		      length = (a * i - j + b) / u
		      
		      If not FillNegative then
		        If length > 0 then
		          length = 0
		        else
		          length = Abs(length)
		        End If
		      End If
		      
		      If length > ShadeLength then
		        tmpC = ColStart + ColW
		      Else
		        tmpC = max(0, (length / ShadeLength) * ColW + ColStart)
		      End If
		      s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		    Next
		  Next
		  
		  g.DrawPicture(p, min(x1, x2), min(y1,y2))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawLineB(extends g As Graphics, X1 As Double, Y1 As Double, X2 As Double, Y2 As Double)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Dim Width, Height As Integer
		  
		  Width = Abs(x2 - x1)+1
		  Height = Abs(y2 - y1)+1
		  
		  If Floor(X1) <> Floor(X2) and Floor(Y1) <> Floor(Y2) then
		    g.AAG_DrawLineA(X1, Y1, X2, Y2)
		    Return
		  End If
		  
		  If (Width = 1 or Height = 1) And Ceil(x1)=Floor(x1) And Floor(y1)=Ceil(y1) then
		    g.DrawLine(X1, Y1, X2, Y2)
		    Return
		  End If
		  
		  Dim p As Picture
		  If Width = 1 then
		    Width = 2
		  elseif Height = 1 then
		    Height = 2
		  End If
		  p = New Picture(Width, Height, 32)
		  Dim gp As Graphics = p.Graphics
		  
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  gp = p.Mask.Graphics
		  
		  Dim tmpC As Integer
		  Dim a As Double
		  If Width = 2 then
		    a = X1-Floor(X1)
		    tmpC = 255 * a
		    gp.ForeColor = RGB(tmpC, tmpC, tmpC)
		    gp.DrawLine(0, 0, 0, Height)
		    
		    tmpC = 255 * (1-a)
		    gp.ForeColor = RGB(tmpC, tmpC, tmpC)
		    gp.DrawLine(1, 0, 1, Height)
		  elseif Height = 2 then
		    a = Y1-Floor(Y1)
		    tmpC = 255 * a
		    gp.ForeColor = RGB(tmpC, tmpC, tmpC)
		    gp.DrawLine(0, 0, Width, 0)
		    
		    tmpC = 255 * (1-a)
		    gp.ForeColor = RGB(tmpC, tmpC, tmpC)
		    gp.DrawLine(0, 1, Width, 1)
		  End If
		  
		  g.DrawPicture(p, Floor(min(X1, X2)), Floor(min(Y1, Y2)))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawOvalA(extends g As Graphics, X As Integer, Y As Integer, Width As Double, Height As Double, ShadeLength As Double = -1)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  
		  If Shadelength = -1 then
		    ShadeLength = 1
		  End If
		  
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, gp.Width, gp.Height)
		  
		  
		  
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.mask.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  Dim ExteriorColor As Color = &cFFFFFF
		  Dim CenterColor As Color = &c0
		  
		  Dim ColW As Integer = 255
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, 0)
		  Else
		    ColStart = min(ExteriorColor.Red, 0)
		  End If
		  
		  
		  'Dim fx1, fx2, fy1, fy2 As Double
		  'fx1 = Width/2-Sqrt((Width/2)^2-(Height/2)^2)
		  'fx2 = Width/2+Sqrt((Width/2)^2-(Height/2)^2)
		  'fy1 = Height/2
		  'fy2 = fy1
		  
		  Dim fx1, fx2, fy1, fy2 As Double
		  Dim Arc As Double
		  If Height > Width then
		    fx1 = pW/2
		    fx2 = fx1
		    fy1 = pH/2-Sqrt((pH/2)^2-(pW/2)^2)
		    fy2 = pH/2+Sqrt((pH/2)^2-(pW/2)^2)
		    Arc = fy1+fy2
		  else
		    fx1 = pW/2-Sqrt((pW/2)^2-(pH/2)^2)
		    fx2 = pW/2+Sqrt((pW/2)^2-(pH/2)^2)
		    fy1 = pH/2
		    fy2 = fy1
		    Arc = fx1 + fx2
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      length = Sqrt((fx1-i)^2.0+(fy1-j)^2.0)+Sqrt((fx2-i)^2.0+(fy2-j)^2.0)
		      
		      
		      If length= Arc then
		        s.Pixel(i,j)=CenterColor
		      ElseIf length < Arc and length >= Arc-ShadeLength then
		        tmpC = ((Arc-length) / ShadeLength) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Elseif length > Arc and length<=Arc+ShadeLength then
		        tmpC = ((length-Arc) / ShadeLength) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Else
		        s.Pixel(i,j)=ExteriorColor
		      End If
		    next
		  next
		  
		  g.DrawPicture(p, X-Width\2, Y-Height\2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_DrawRoundRectA(extends g As graphics, X As Double, Y As Double, Width As Double, Height As Double, Arc As Double, ShadeLength As Double = -1)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  
		  
		  If Arc<1 then
		    g.DrawRect(X, Y, Width, Height)
		  End If
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  Arc = min(Arc, Width/2, Height/2)
		  
		  Dim ExteriorColor As Color = &cFFFFFF, CenterColor As Color = &c0
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  Dim X1,Y1,X2,Y2 As Double
		  Dim X1a,Y1a,X2a,Y2a As Double
		  X1 = 0
		  Y1 = 0
		  X2 = Width-1
		  Y2 = Height-1
		  
		  X1a = X1+Arc
		  X2a = X2-Arc
		  Y1a = Y1+Arc
		  Y2a = Y2 -Arc
		  
		  #If DebugBuild
		    Dim breaki As Integer = -1, breakj As Integer = -1
		  #endif
		  
		  If Shadelength = -1 then
		    If Arc < 5 then
		      ShadeLength = Sqrt(Arc)
		    else
		      ShadeLength = 2.5
		    End If
		  End If
		  
		  s = p.mask.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      #If DebugBuild
		        If i = breaki and j = breakj then break
		      #endif
		      
		      If i>=X1a and i<=X2a and (j=Y1 or j=Y2) then
		        s.Pixel(i,j)=CenterColor
		      elseif j>=Y1a and j<=Y2a and (i=X1 or i=X2) then
		        s.Pixel(i,j)=CenterColor
		      Elseif (i>=X1 and i<X1a and j>=Y1 and j<Y1a) or (i<=X2 and i>X2a and j>=Y1 and j<Y1a) or (i>=X1 and i<X1a and j<=Y2 and j>Y2a) or (i<=X2 and i>X2a and j<=Y2 and j>Y2a) then
		        
		        length = Min(Sqrt((X1a-i)^2+(Y1a-j)^2), Sqrt((X2a-i)^2+(Y1a-j)^2), Sqrt((X2a-i)^2+(Y2a-j)^2), Sqrt((X1a-i)^2+(Y2a-j)^2))
		        
		        If length = Arc then
		          s.Pixel(i,j) = CenterColor
		        elseif length<Arc then
		          If Width>=Height and (j=Y1 or j=Y2) then
		            s.Pixel(i,j) = CenterColor
		          elseif Height>Width and (i=X1 or i=X2) then
		            s.Pixel(i,j) = CenterColor
		          else
		            length = 2*Arc - length+1
		            'tmpC = ((length-Arc+1) / (ShadeLength)) * ColW + ColStart + length
		            tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		            s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		          End If
		        elseif length<=Arc+ShadeLength then
		          
		          tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        else
		          s.Pixel(i,j) = ExteriorColor
		        End If
		      else
		        s.Pixel(i,j) = ExteriorColor
		      End If
		    next
		  next
		  
		  #If DebugBuild and Debug
		    s.Pixel(X1a,Y1a)= &c0
		    s.Pixel(X2a,Y2a) = &c0
		    s.Pixel(X1a,Y2a)= &c0
		    s.Pixel(X2a,Y1a) = &c0
		  #endif
		  
		  g.DrawPicture(p, X, Y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillAll(extends g As Graphics)
		  g.FillRect(0, 0, g.Width, g.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillCircleA(extends g As Graphics, X As Integer, Y As Integer, Arc As Double, ShadeLength As Double = -1)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Arc = Arc - 0.5
		  If Shadelength = -1 then
		    ShadeLength = Sqrt(Arc)
		  End If
		  Dim c As Double = (Arc+ShadeLength)*2.0
		  
		  Dim p As Picture = New Picture(Ceil(c)+1, Ceil(c)+1, 32)
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, gp.Width, gp.Height)
		  
		  c = p.Width/2 - 1
		  
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.mask.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  Dim ExteriorColor As Color = &cFFFFFF
		  Dim CenterColor As Color = &c0
		  
		  Dim ColW As Integer = 255
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, 0)
		  Else
		    ColStart = min(ExteriorColor.Red, 0)
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      length = Sqrt((c-i)^2.0+(c-j)^2.0)
		      
		      If length<= Arc then
		        s.Pixel(i,j)=CenterColor
		      Elseif length<=Arc+ShadeLength then
		        tmpC = ((length-Arc) / ShadeLength) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Else
		        s.Pixel(i,j)=ExteriorColor
		      End If
		    next
		  next
		  
		  g.DrawPicture(p, X-c-1, Y-c-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillOvalA(extends g As Graphics, X As Integer, Y As Integer, Width As Double, Height As Double, ShadeLength As Double = -1)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  
		  If Shadelength = -1 then
		    ShadeLength = 1
		  End If
		  If Width <= 0 or Height <=0 then
		    Return
		  End If
		  
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, gp.Width, gp.Height)
		  
		  
		  
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.mask.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  Dim ExteriorColor As Color = &cFFFFFF
		  Dim CenterColor As Color = &c0
		  
		  Dim ColW As Integer = 255
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, 0)
		  Else
		    ColStart = min(ExteriorColor.Red, 0)
		  End If
		  
		  
		  Dim fx1, fx2, fy1, fy2 As Double
		  Dim Arc As Double
		  If Height > Width then
		    fx1 = pW/2
		    fx2 = fx1
		    fy1 = pH/2-Sqrt((pH/2)^2-(pW/2)^2)
		    fy2 = pH/2+Sqrt((pH/2)^2-(pW/2)^2)
		    Arc = fy1+fy2
		  else
		    fx1 = pW/2-Sqrt((pW/2)^2-(pH/2)^2)
		    fx2 = pW/2+Sqrt((pW/2)^2-(pH/2)^2)
		    fy1 = pH/2
		    fy2 = fy1
		    Arc = fx1 + fx2
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      length = Sqrt((fx1-i)^2.0+(fy1-j)^2.0)+Sqrt((fx2-i)^2.0+(fy2-j)^2.0)
		      
		      
		      If length<= Arc then
		        s.Pixel(i,j)=CenterColor
		      Elseif length<=Arc+ShadeLength then
		        tmpC = ((length-Arc) / ShadeLength) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Else
		        s.Pixel(i,j)=ExteriorColor
		      End If
		    next
		  next
		  
		  g.DrawPicture(p, X-Width\2, Y-Height\2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillRoundRectA(extends g As graphics, X As Double, Y As Double, Width As Double, Height As Double, Arc As Double=10000, Shadelength As Double = -1, Mask As Boolean = False)
		  'dim mp as new MethodProfiler(CurrentMethodName)
		  
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Arc = min(Arc, Width/2, Height/2)
		  
		  'If App.UseGDIPlus then
		  'If Mask then
		  'g.ForeColor = &cFFFFFF
		  'g.FillRect(X, Y, Width, Height)
		  'g.ForeColor = &c0
		  'End If
		  'g.FillRoundRect(X, Y, Width, Height, Arc, Arc)
		  'Return
		  'End If
		  
		  If Arc<1 then
		    If Mask then
		      g.ForeColor = &c0
		    End If
		    g.FillRect(X, Y, Width, Height)
		    Return
		  End If
		  
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.FillRect(0,0, Width, Height)
		  
		  
		  
		  Dim ExteriorColor As Color = &cFFFFFF, CenterColor As Color = &c0
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  Dim X1,Y1,X2,Y2 As Double
		  Dim X1a,Y1a,X2a,Y2a As Double
		  X1 = 0
		  Y1 = 0
		  X2 = Width-1
		  Y2 = Height-1
		  
		  X1a = X1+Arc
		  X2a = X2-Arc
		  Y1a = Y1+Arc
		  Y2a = Y2 -Arc
		  
		  #If DebugBuild
		    'Dim breaki As Integer = 1, breakj As Integer = 26
		  #endif
		  
		  If Shadelength = -1 then
		    If Arc < 5 then
		      ShadeLength = Sqrt(Arc)
		    else
		      ShadeLength = 2.5
		    End If
		  End If
		  
		  s = p.mask.RGBSurface
		  
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  Dim inRange As Boolean
		  
		  If Height >= Width then
		    for j = 0 to Y1a-1
		      for i = 0 to X2
		        
		        If i>=X1 and i<X1a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y1a-j)^2)
		        elseif i<=X2 and i>X2a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y1a-j)^2)
		        ElseIf i>=X1 and i<X1a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y2a-j)^2)
		        elseif i<=X2 and i>X2a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y2a-j)^2)
		        else 
		          length = 0
		        End if
		        
		        If inRange then
		          If length <=Arc then
		            s.Pixel(i,j) = CenterColor
		          elseif length<=Arc+ShadeLength then
		            tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		            s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		          else
		            s.Pixel(i,j) = ExteriorColor
		          End If
		        End If
		      next
		    next
		    
		    'p.Mask.Graphics.FillRect(0, Y1a+1, Width, Height-Arc*2)
		    
		    for j = Y2a+1 to Y2
		      for i = 0 to X2
		        
		        If i>=X1 and i<X1a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y1a-j)^2)
		        elseif i<=X2 and i>X2a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y1a-j)^2)
		        elseIf i>=X1 and i<X1a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y2a-j)^2)
		        elseif i<=X2 and i>X2a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y2a-j)^2)
		        else
		          length = 0
		        End if
		        
		        If inRange then
		          If length <=Arc then
		            s.Pixel(i,j) = CenterColor
		          elseif length<=Arc+ShadeLength then
		            tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		            s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		          else
		            s.Pixel(i,j) = ExteriorColor
		          End If
		        End If
		      next
		    next
		    
		  else
		    
		    for j = 0 to Y2
		      for i = 0 to X1a
		        
		        If i>=X1 and i<X1a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y1a-j)^2)
		        elseif i<=X2 and i>X2a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y1a-j)^2)
		        ElseIf i>=X1 and i<X1a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y2a-j)^2)
		        elseif i<=X2 and i>X2a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y2a-j)^2)
		        else
		          length = 0
		        End if
		        
		        If inRange then
		          If length <=Arc then
		            s.Pixel(i,j) = CenterColor
		          elseif length<=Arc+ShadeLength then
		            tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		            s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		          else
		            s.Pixel(i,j) = ExteriorColor
		          End If
		        End If
		      next
		    next
		    
		    'p.Mask.Graphics.FillRect(X1a, 0, Width-Arc*2, Height)
		    
		    for j = 0 to Y2
		      for i = X2a+1 to X2
		        
		        If i>=X1 and i<X1a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y1a-j)^2)
		        elseif i<=X2 and i>X2a and j>=Y1 and j<Y1a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y1a-j)^2)
		        ElseIf i>=X1 and i<X1a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X1a-i)^2+(Y2a-j)^2)
		        elseif i<=X2 and i>X2a and j<=Y2 and j>Y2a then
		          inRange = True
		          length = Sqrt((X2a-i)^2+(Y2a-j)^2)
		        else
		          length = 0
		        End if
		        
		        If inRange then
		          If length <=Arc then
		            s.Pixel(i,j) = CenterColor
		          elseif length<=Arc+ShadeLength then
		            tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		            s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		          else
		            s.Pixel(i,j) = ExteriorColor
		          End If
		        End If
		      next
		    next
		  End If
		  
		  If Mask then
		    g.DrawPicture(p.Mask, X, Y)
		  else
		    g.DrawPicture(p, X, Y)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillRoundRectAFast(extends g As graphics, X As Double, Y As Double, Width As Double, Height As Double, Arc As Double=10000, Shadelength As Double = -1, Mask As Boolean, ByRef Buffer As Picture)
		  'g.AAG_FillRoundRectA(X, Y, Width, Height, Arc, Shadelength, Mask)
		  'Return
		  
		  If Arc <= 0 then
		    g.FillRect(X, Y, Width, Height)
		    Return
		  End If
		  
		  If Buffer is Nil then
		    Buffer = New Picture(Arc*2, Arc*2, 32)
		    Dim gp As Graphics = Buffer.Graphics
		    
		    gp.ForeColor = g.ForeColor
		    gp.AAG_FillRoundRectA(0,0, gp.Width, gp.Height, Arc, Shadelength, Mask)
		  End If
		  
		  
		  //top left corner
		  g.DrawPicture(Buffer, X, Y, Arc, Arc)
		  //top right corner
		  g.DrawPicture(Buffer, X+Width-Arc, Y, Buffer.Width-Arc, Arc, Arc, 0)
		  
		  //Bottom left corner
		  g.DrawPicture(Buffer, X, Y+Height-Arc, Arc, Buffer.Height-Arc, 0, Arc)
		  //Bottom right corner
		  g.DrawPicture(Buffer, X+Width-Arc, Y+Height-Arc, Buffer.Width-Arc, Buffer.Height-Arc, Arc, Arc)
		  
		  If Mask = False then
		    
		    g.FillRect(X+Arc, Y, Width-2*Arc, Arc)
		    g.FillRect(X, Y+Arc, Width, Height-Arc*2)
		    
		    g.FillRect(X+Arc, Y+Height-Arc, Width-2*Arc, Arc)
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillSliceA(extends g As Graphics, Xc As Single, Yc As Single, X1 As Single, Y1 As Single, X2 As Single, Y2 As Single)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Dim w, h As Integer
		  Dim Arc As Double = Sqrt((Xc-X1)^2+(Yc-Y1)^2)
		  w = max(max(Xc, X1, X2) - min(Xc, X1, X2), Arc)
		  h = max(max(Yc, Y1, Y2) - min(Yc, Y1, Y2), Arc)
		  
		  Dim minX, minY As Integer
		  minX = min(Xc, X1, X2)
		  minY = min(Yc, Y1, Y2)
		  
		  
		  
		  Dim Shadelength As Single
		  If Shadelength = -1 then
		    ShadeLength = Sqrt(Arc)
		  End If
		  
		  If w<1 or h<1 then Return
		  if w=1 then
		    g.DrawLine(min(Xc, X1, X2), min(Yc, Y1, Y2), min(Xc, X1, X2), max(Yc, Y1, Y2))
		    Return
		  elseif h=1 then
		    g.DrawLine(min(Xc, X1, X2), min(Yc, Y1, Y2), max(Xc, X1, X2), min(Yc, Y1, Y2))
		    Return
		  end if
		  
		  Dim p As Picture = New Picture(w, h, 32)
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = g.ForeColor
		  gp.AAG_FillAll()
		  
		  Xc = Xc-minX
		  Yc = Yc -minY
		  
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.mask.RGBSurface
		  
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  Dim ExteriorColor As Color = &cFFFFFF
		  Dim CenterColor As Color = &c0
		  
		  Dim ColW As Integer = 255
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, 0)
		  Else
		    ColStart = min(ExteriorColor.Red, 0)
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      length = Sqrt((Xc-i)^2.0+(Yc-j)^2.0)
		      
		      If length<= Arc then
		        s.Pixel(i,j)=CenterColor
		      Elseif length<=Arc+ShadeLength then
		        tmpC = ((length-Arc) / ShadeLength) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Else
		        s.Pixel(i,j)=ExteriorColor
		      End If
		    next
		  next
		  
		  g.DrawPicture(p, minX, minY)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_FillTore(extends g As Graphics, X As Integer, Y As Single, Width As Integer, Height As Integer, ToreWidth As Integer, StartA As Single = 0, EndA As Single = 360, RoundBorder As Boolean = False)
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return
		  
		  Const PI=3.14159265358979323846264338327950
		  
		  
		  Dim p As Picture = New Picture(g.Width, g.Height, 32)
		  Dim gp As Graphics = p.Graphics
		  
		  gp.ForeColor = g.forecolor
		  gp.fillrect(0, 0, g.width, g.height)
		  
		  gp = p.Mask.graphics
		  
		  gp.ForeColor = &cFFFFFF
		  gp.FillRect(0, 0, gp.Width, gp.Height)
		  
		  gp.ForeColor = &c0
		  gp.FillOval(X, Y, Width, Height)
		  
		  
		  gp.ForeColor = &cFFFFFF
		  gp.FillOval(X+ToreWidth, Y + ToreWidth, Width-2*ToreWidth, Height-2*ToreWidth)
		  
		  If StartA = 0.0 and EndA = 360.0 then
		    
		    g.drawPicture(p, 0, 0)
		    
		    
		  Else
		    
		    StartA = StartA/180.0*PI-PI/2
		    EndA = EndA/180.0*PI-PI/2
		    
		    Dim radius As Single
		    radius = Width/2-ToreWidth/2
		    
		    Dim fx As New FigureShape
		    Dim xA, yA As Single
		    fx.AddLine(X, Y, X+Width/2, Y)
		    fx.AddLine(X+Width/2, Y, X+Width/2, Y+Height/2)
		    
		    xA = X+Width/2 + cos(EndA)*Width
		    yA = Y+Height/2 + sin(EndA)*Height
		    
		    fx.AddLine(X+Width/2, Y+Height/2, xA, yA)
		    If EndA < PI/8 then
		      fx.AddLine(xA, yA, X+Width, Y)
		      fx.AddLine(X+Width, Y, X+Width, Y+Height)
		      fx.AddLine(X+Width, Y+Height, X, Y+Height)
		      
		    ElseIf EndA < 2*PI/3 then
		      fx.AddLine(xA, yA, X+Width, Y+Height)
		      fx.AddLine(X+Width, Y+Height, X, Y+Height)
		    Elseif EndA < PI/3 then
		      fx.AddLine(xA, yA, X, Y+Height)
		    End If
		    
		    fx.BorderColor = &cFFFFFF
		    fx.FillColor = &cFFFFFF
		    gp.DrawObject(fx, 0, 0)
		    
		    If RoundBorder then
		      gp.ForeColor = &c0
		      gp.FillOval(X+round(Width/2-ToreWidth/2), Y, ToreWidth+1, ToreWidth+1)
		      
		      xA = X+Width/2 + cos(EndA)*radius
		      yA = Y+Height/2 + sin(EndA)*radius
		      gp.FillOval(round(xA-ToreWidth/2), round(yA-ToreWidth/2), ToreWidth+1, ToreWidth+1)
		      
		    End If
		    
		    
		    g.drawPicture(p, 0, 0)
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = not TargetWeb
		Function AAG_GetWindowColor(c As RectControl) As Color
		  #if RBVersion>2009 then
		    If c.TrueWindow.HasBackColor then
		      Return c.TrueWindow.BackColor
		  #else
		    If c.Window.HasBackColor then
		      Return c.Window.BackColor
		  #endif
		  Else
		    #if TargetMacOS
		      //A corriger?
		      Return &cEDEDED
		    #else
		      Return FillColor()
		    #endif
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_Gradient(extends g as graphics, X As Integer, Y As Integer, Width As Integer, Height As Integer, startColor as color = &c0, endColor as color = &cFFFFFF, Vertical As Boolean = True)
		  //modified gradient code, original code: Seth Willits
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  If not Registered then Return
		  
		  dim i as integer, ratio, endratio as Single
		  Dim gg As Graphics = g.Clip(X, Y, Width, Height)
		  
		  
		  Dim length As Integer
		  
		  // Draw the gradient
		  If Vertical then
		    length = Height-1
		    for i = 0 to length
		      
		      // Determine the current line's color
		      ratio = ((length-i))/length
		      endratio = (i/length)
		      
		      gg.ForeColor = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		      
		      gg.DrawLine(0, i, Width-1, i)
		      
		    next
		  else
		    length = Width-1
		    for i = 0 to length
		      
		      // Determine the current line's color
		      ratio = ((length-i))/length
		      endratio = (i/length)
		      
		      gg.ForeColor = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		      
		      gg.DrawLine(i, 0, i, Height-1)
		      
		    next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_gradientAngle(extends g As Graphics, X As Integer, Y As Integer, Angle As Double, Length As Double, startColor as color = &c0, endColor as color = &cFFFFFF, Precision As Integer = 3, Fill As Boolean = False)
		  //Draws a gradient where the center point is X,Y
		  //The angle determines the direction of the gradient.
		  //Length is the Length of the gradient.
		  
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  'dim mp As new MethodProfiler(CurrentMethodName)
		  
		  If not Registered then Return
		  
		  Dim p As Picture
		  If AntiAliased then
		    p = New Picture(g.Width, g.Height)
		  Else
		    p = new Picture(g.Width, g.Height, 32)
		  End If
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = endColor
		  gp.AAG_FillAll()
		  
		  Const PI=3.14159265358979323846264338327950
		  
		  Angle = Angle mod 360.0
		  
		  //Special Angle cases
		  If Angle = 0.0 or Angle = 180.0then
		    g.AAG_Gradient(X, Y, Length, Length, startColor, endColor, True)
		    Return
		  elseif Angle = 90.0 or Angle = 270.0 then
		    g.AAG_Gradient(X, Y, Length, Length, startColor, endColor, False)
		    Return
		  End If
		  
		  
		  
		  Dim x2, y2 As Double
		  
		  x2 = X+1
		  y2 = Y-Tan(PI*Angle/180.0)
		  
		  Dim a, b As Double
		  //y=a*x+b
		  a = (Y - Y2) / (X - X2)
		  b = a*(-X)+Y
		  
		  If Fill and b>0 then
		    gp.ForeColor = startColor
		    gp.FillRect(0, 0, gp.Width, Floor(b))
		  End If
		  
		  
		  'u = Sqrt(a^2 + 1)
		  
		  
		  Dim i, j As Integer
		  Dim ratio, endratio As Single
		  Dim d As Double
		  Dim Drawn As Boolean
		  
		  Dim Width, Height As Integer
		  Width = p.Width-1
		  Height = p.Height-1
		  Dim LastRed As Integer
		  
		  If Precision > 1 then
		    
		    For j = 0 to Height step Precision
		      Drawn = False
		      LastRed = 256
		      For i = 0 to Width step Precision
		        d = Abs(a * i - j + b) '/ u
		        
		        If d > Length then
		          If Drawn then
		            Continue for j
		          else
		            Continue for i
		          End If
		          
		        else
		          
		          If not Drawn then
		            Drawn = True
		          End If
		          
		          ratio = ((length-d))/length
		          endratio = (d/length)
		          
		          gp.ForeColor = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		          If Fill then
		            If j<b then
		              gp.ForeColor = startColor
		              gp.FillRect(0, j, gp.Width, Precision)
		            ElseIf LastRed < gp.ForeColor.Red then
		              gp.ForeColor = startColor
		              gp.FillRect(i, j, gp.Width-i, Precision)
		              LastRed = 256
		              Continue for j
		            else
		              LastRed = gp.ForeColor.Red
		            End If
		          End If
		          gp.FillRect(i,j, precision, precision)
		          's.Pixel(i, j) = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		          
		        End If
		      Next
		    Next
		    
		    
		  else
		    
		    Dim s As RGBSurface
		    s = p.RGBSurface
		    
		    Dim c As Color
		    
		    For j = 0 to Height
		      Drawn = False
		      LastRed = 256
		      For i = 0 to Width
		        d = Abs(a * i - j + b)
		        
		        If d > Length then
		          If Drawn then
		            Continue for j
		          else
		            Continue for i
		          End If
		          
		        else
		          
		          If not Drawn then
		            Drawn = True
		          End If
		          
		          ratio = ((length-d))/length
		          endratio = (d/length)
		          
		          c = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		          
		          If Fill then
		            If j<b then
		              gp.ForeColor = startColor
		              gp.DrawLine(0, j, gp.Width-1, j)
		            ElseIf LastRed < c.Red then
		              gp.ForeColor = startColor
		              gp.DrawLine(i, j, gp.Width-1, j)
		              LastRed = 256
		              Continue for j
		            else
		              LastRed = c.Red
		            End If
		          End If
		          
		          'gp.ForeColor = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		          'gp.FillRect(i,j, precision, precision)
		          s.Pixel(i, j) = c
		          
		        End If
		      Next
		    Next
		    
		  End If
		  
		  'gp.ForeColor = &cFF0000
		  'gp.DrawLine(0, b, gp.Width, b)
		  
		  g.DrawPicture(p, 0, 0)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_gradientExp(Extends g as graphics, start as integer, length as integer, startColor as color, endColor as color, Vertical As Boolean = True)
		  //modified gradient code, original code: Seth Willits
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  if not Registered then Return
		  
		  dim i as integer, ratio, endratio, ln as Single
		  ln = length / log(length + 1)
		  Dim a As Single
		  
		  // Draw the gradient
		  for i = start to start + length
		    
		    // Determine the current line's color
		    a = i - start
		    endratio = (exp(a/ln)-1.0)/length
		    ratio = 1.0 - endratio
		    
		    g.ForeColor = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		    
		    // Draw the step
		    If Vertical then
		      g.DrawLine 0, i, g.Width, i
		      
		    Else
		      g.DrawLine i, 0, i, g.Height
		    End If
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AAG_GradientRadial(extends g As Graphics, X As Integer, Y As Integer, Length As Double, startColor as color = &c0, endColor as color = &cFFFFFF, Precision As Integer = 3)
		  //Draw a radial gradient where the center is located at X,Y
		  //The length represents the radius of the Gradient.
		  //
		  //startColor is the center color of the gradient.
		  //endColor is the exterior color of the gradient.
		  //Precision enables better performance. The higher the precision, the better the performance but the gradient might appear as stepped instead of smooth.
		  
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  if not Registered then Return
		  
		  Dim p As Picture = New Picture(min(g.Width, Length + X), min(g.Height, Length + Y), 32)
		  Dim gp As Graphics = p.Graphics
		  gp.ForeColor = endColor
		  gp.AAG_FillAll()
		  
		  Dim s As RGBSurface
		  s = p.RGBSurface
		  
		  Dim Width, Height As Integer
		  Width = p.Width-1
		  Height = p.Height-1
		  
		  Dim i, j As Integer
		  Dim ratio, endratio As Single
		  Dim d As Double
		  Dim Drawn As Boolean
		  
		  If Precision > 1 then
		    
		    //Better performance
		    For j = 0 to Height step precision
		      Drawn = False
		      For i = 0 to Width step precision
		        
		        d = Sqrt((x-i)^2.0+(y-j)^2.0)
		        
		        If d > Length then
		          If Drawn then
		            Continue for j
		          else
		            Continue for i
		          End If
		          
		        else
		          
		          If not Drawn then
		            Drawn = True
		          End If
		          
		          ratio = ((length-d))/length
		          endratio = (d/length)
		          
		          gp.ForeColor = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		          gp.FillRect(i,j, precision, precision)
		          
		        End If
		      Next
		    Next
		    
		  else
		    
		    //Better gradient
		    For j = 0 to Height step precision
		      Drawn = False
		      For i = 0 to Width step precision
		        
		        d = Sqrt((x-i)^2.0+(y-j)^2.0)
		        
		        If d > Length then
		          If Drawn then
		            Continue for j
		          else
		            Continue for i
		          End If
		          
		        else
		          
		          If not Drawn then
		            Drawn = True
		          End If
		          
		          ratio = ((length-d))/length
		          endratio = (d/length)
		          
		          s.Pixel(i, j) = RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		        End If
		      Next
		    Next
		    
		  End If
		  
		  g.DrawPicture(p, 0, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AAG_OvalShade(p As Picture, X As Double, Y As Double, Width As Double, Height As Double, ShadeLength As Double = -1, CenterColor As Color = &c0, ExteriorColor As Color = &cFFFFFF) As Picture
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  If not Registered then Return Nil
		  
		  'dim mp as new MethodProfiler(CurrentMethodName)
		  
		  If X = p.Width/2 then
		    X = X-0.5
		  End If
		  If Y = p.Height/2 then
		    Y = Y-0.5
		  End If
		  
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width-1
		  pH = p.Height-1
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  
		  Dim fx1, fx2, fy1, fy2 As Double
		  Dim Arc As Double
		  If Height > Width then
		    fx1 = X
		    fx2 = X
		    fy1 = Y-Sqrt((Height/2)^2-(Width/2)^2)
		    fy2 = Y+Sqrt((Height/2)^2-(Width/2)^2)
		    Arc = fy1+fy2
		  else
		    fx1 = X-Sqrt((Width/2)^2-(Height/2)^2)
		    fx2 = X+Sqrt((Width/2)^2-(Height/2)^2)
		    fy1 = Y
		    fy2 = Y
		    Arc = fx1-(X-Width/2) + fx2-(X-Width/2)
		  End If
		  
		  
		  If ShadeLength = -1 then
		    ShadeLength = Sqrt((fx1)^2.0+(fy1)^2.0)+Sqrt((fx2)^2.0+(fy2)^2.0)-Arc
		  End If
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      length = Sqrt((fx1-i)^2.0+(fy1-j)^2.0)+Sqrt((fx2-i)^2.0+(fy2-j)^2.0)
		      
		      If length<= Arc then
		        s.Pixel(i,j)=CenterColor
		      Elseif length<=Arc+ShadeLength then
		        tmpC = ((length-Arc) / ShadeLength) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Else
		        s.Pixel(i,j)=ExteriorColor
		      End If
		    next
		  next
		  Return P
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AAG_RoundRectShade(p As Picture, X1 As Double, Y1 As Double, X2 As Double, Y2 As Double, Arc As Double, ShadeLength As Double, CenterColor As Color = &c0, ExteriorColor As Color = &cFFFFFF) As Picture
		  If not Registered then Return Nil
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width
		  pH = p.Height
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      If i>=X1 and i<=X2 and j>=Y1 and j<=Y2 then
		        s.Pixel(i,j)=CenterColor
		      Else
		        if i>=X1 and i<=X2 then
		          length = Min(Abs(Y1-j), Abs(j-Y2))
		        Elseif j>=Y1 and j<=Y2 then
		          length = Min(Abs(X1-i), Abs(i-X2))
		        Else
		          length = Min(Sqrt((X1-i)^2+(Y1-j)^2), Sqrt((X2-i)^2+(Y1-j)^2), Sqrt((X2-i)^2+(Y2-j)^2), Sqrt((X1-i)^2+(Y2-j)^2))
		        End If
		        
		        
		        if length<=Arc+ShadeLength then
		          tmpC = ((length-Arc) / ShadeLength) * ColW + ColStart + length * 12
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        Else
		          s.Pixel(i,j)=ExteriorColor
		        End If
		      End If
		    next
		  next
		  
		  Return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AAG_RoundShade(p As Picture, X As Double, Y As Double, Arc As Double, ShadeArc As Double, CenterColor As Color = &c0, ExteriorColor As Color = &cFFFFFF) As Picture
		  If not Registered then Return Nil
		  
		  'dim mp as new MethodProfiler(CurrentMethodName)
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  s = p.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width
		  pH = p.Height
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  If X = pW / 2 then
		    X = X - 0.5
		  End If
		  If Y = pH / 2 then
		    Y = Y - 0.5
		  End If
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      length = Sqrt((X-i)^2+(Y-j)^2)
		      
		      If length<= Arc then
		        s.Pixel(i,j)=CenterColor
		      Elseif length<=Arc+ShadeArc then
		        tmpC = ((length-Arc) / ShadeArc) * ColW + ColStart
		        s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		      Else
		        s.Pixel(i,j)=ExteriorColor
		      End If
		    next
		  next
		  
		  Return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function AAG_TriangleShade(p As Picture, X1 As Double, Y1 As Double, X2 As Double, Y2 As Double, X3 As Double, Y3 As Double, ShadeLength As Double, CenterColor As Color = &c0, ExteriorColor As Color = &cFFFFFF) As Picture
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  
		  If not Registered then Return Nil
		  
		  s = p.RGBSurface
		  
		  Dim pW, pH As Integer
		  pW = p.Width
		  pH = p.Height
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  Dim a1, a2, c1, c2, u1, u2 As Double
		  a1 = (Y1 - Y3) / (X1 - X3)
		  a2 = (Y2 - Y3) / (X2 - X3)
		  c1 = (Y3 * X1 - Y1 * X3) / (X1 - X3)
		  c2 = (Y3 * X2 - Y2 * X3) / (X2 - X3)
		  u1 = Sqrt(a1^2 + 1)
		  u2 = Sqrt(a2^2 + 1)
		  
		  
		  for j = 0 to pH
		    for i = 0 to pW
		      
		      //Start of superior part
		      If j<Y1 and i>=X1 and i<=X2 then
		        length = Min(Abs(Y1-j), Abs(j-Y2))
		        
		      Elseif j<=Y1 and (i<X1 or i>X2) then
		        length = Min(Sqrt((X1-i)^2+(Y1-j)^2), Sqrt((X2-i)^2+(Y2-j)^2))
		        //end of superior part
		        
		      ElseIf j=Y1 and i>=X1 and i<=X2 then
		        s.Pixel(i,j)=CenterColor
		        Continue for i
		        
		      Elseif j>Y3 then
		        length = Sqrt((X3-i)^2+(Y3-j)^2)
		        
		      Else
		        
		        If i < X3 then
		          length = min((a1 * i - j + c1) / u1, 0)
		          length = Abs(length)
		        Elseif i > X3 then
		          length = min((a2 * i - j + c2) / u2, 0)
		          length = Abs(length)
		        Else
		          length = 0
		        End If
		      End If
		      
		      If length > ShadeLength then
		        tmpC = ColStart + ColW
		      Else
		        tmpC = (length / ShadeLength) * ColW + ColStart
		      End If
		      s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		    next
		  next
		  
		  Return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Hash2(s As String, P As UInt16) As Uint16
		  
		  
		  dim R as integer
		  
		  for i as integer = 1 to s.Len
		    
		    dim B as string = s.Mid( i, 1 )
		    dim ascB as integer = asc( B )
		    
		    R = Bitwise.ShiftLeft( R, 4 )
		    
		    R = R + ascB
		    
		    R = R mod P
		  next
		  
		  return val(str(R).Right(1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RoundRectA(Width As Double, Height As Double, Arc As Double, CenterColor As Color = &c0, ExteriorColor As Color = &cFFFFFF) As Picture
		  #If kUsePragmas
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  
		  
		  Dim p As Picture = New Picture(Width, Height, 32)
		  Dim g As Graphics
		  g.ForeColor = CenterColor
		  g.FillRect(0,0, Width, Height)
		  
		  Arc = min(Arc, Width/2, Height/2)
		  
		  Dim s As RGBSurface
		  Dim i, j As Integer
		  Dim X1,Y1,X2,Y2 As Double
		  Dim X1a,Y1a,X2a,Y2a As Double
		  X1 = 0
		  Y1 = 0
		  X2 = Width-1
		  Y2 = Height-1
		  
		  X1a = X1+Arc
		  X2a = X2-Arc
		  Y1a = Y1+Arc
		  Y2a = Y2 -Arc
		  
		  #If DebugBuild
		    'Dim breaki As Integer = -1, breakj As Integer = -1
		  #endif
		  
		  Dim ShadeLength As Double = Sqrt(Arc)
		  
		  s = p.RGBSurface
		  
		  Dim length As Double
		  Dim tmpC As Integer
		  
		  Dim ColW As Integer = ExteriorColor.red - CenterColor.red
		  Dim ColStart As Integer
		  If ColW<0 then
		    ColStart = max(ExteriorColor.Red, CenterColor.Red)
		  Else
		    ColStart = min(ExteriorColor.Red, CenterColor.Red)
		  End If
		  
		  Dim inRange As Boolean
		  
		  for j = 0 to Y2
		    for i = 0 to X2
		      inRange = False
		      
		      #If DebugBuild
		        'If i = breaki and j = breakj then break
		      #endif
		      
		      If i>=X1 and i<X1a and j>=Y1 and j<Y1a then
		        inRange = True
		        length = Sqrt((X1a-i)^2+(Y1a-j)^2)
		      elseif i<=X2 and i>X2a and j>=Y1 and j<Y1a then
		        inRange = True
		        length = Sqrt((X2a-i)^2+(Y1a-j)^2)
		      ElseIf i>=X1 and i<X1a and j<=Y2 and j>Y2a then
		        inRange = True
		        length = Sqrt((X1a-i)^2+(Y2a-j)^2)
		      elseif i<=X2 and i>X2a and j<=Y2 and j>Y2a then
		        inRange = True
		        length = Sqrt((X2a-i)^2+(Y2a-j)^2)
		      End if
		      
		      If inRange then
		        If length <=Arc then
		          s.Pixel(i,j) = CenterColor
		        elseif length<=Arc+ShadeLength then
		          tmpC = ((length-Arc) / (ShadeLength)) * ColW + ColStart + length
		          s.Pixel(i,j)=RGB(tmpC, tmpC, tmpC)
		        else
		          s.Pixel(i,j) = ExteriorColor
		        End If
		      End If
		    next
		  next
		  
		  #If DebugBuild and Debug
		    s.Pixel(X1a,Y1a)= &cCCCCCC
		    s.Pixel(X2a,Y2a) = &cCCCCCC
		    s.Pixel(X1a,Y2a)= &cCCCCCC
		    s.Pixel(X2a,Y1a) = &cCCCCCC
		  #endif
		  
		  Return p
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  #If TargetWeb
			    Return True
			  #elseif TargetDesktop
			    #if TargetMacOS
			      Return True
			    #elseif TargetLinux
			      Return True
			    #elseif TargetWin32
			      If App.useGDIPlus Then
			        Return True
			      Else
			        Return False
			      End If
			    #endif
			  #endif
			End Get
		#tag EndGetter
		Protected AntiAliased As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Buffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected KeepInBuffer As Boolean
	#tag EndProperty


	#tag Constant, Name = Debug, Type = Boolean, Dynamic = False, Default = \"False", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kProductKey, Type = String, Dynamic = False, Default = \"AntialiasedGraphics", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kReleaseDate, Type = Double, Dynamic = False, Default = \"20140417", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kUsePragmas, Type = Boolean, Dynamic = False, Default = \"True", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Double, Dynamic = False, Default = \"1.2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Registered, Type = Boolean, Dynamic = False, Default = \"True", Scope = Private
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
	#tag EndViewBehavior
End Module
#tag EndModule
