#tag Class
Protected Class ChartView
Inherits Canvas
	#tag Event
		Function DragEnter(obj As DragItem, action As Integer) As Boolean
		  #pragma Unused obj
		  #pragma Unused action
		End Function
	#tag EndEvent

	#tag Event
		Sub DragExit(obj As DragItem, action As Integer)
		  #pragma Unused obj
		  #pragma Unused action
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function DragOver(x As Integer, y As Integer, obj As DragItem, action As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused y
		  #pragma Unused obj
		  #pragma Unused action
		End Function
	#tag EndEvent

	#tag Event
		Sub DropObject(obj As DragItem, action As Integer)
		  #pragma Unused obj
		  #pragma Unused action
		End Sub
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub GotFocus()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  #pragma Unused Key
		End Function
	#tag EndEvent

	#tag Event
		Sub KeyUp(Key As String)
		  #pragma Unused Key
		End Sub
	#tag EndEvent

	#tag Event
		Sub LostFocus()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  
		  If Type\100 <> TypePie\100 or EnableSelection = False then
		    #if TargetDesktop
		      Return False
		    #Elseif TargetWeb
		      Return
		    #endif
		  End If
		  
		  //Finding which Pie slice was clicked
		  Dim p As Picture = New Picture(Plot.Width+5, Plot.Height, 32)
		  Dim gp As Graphics = p.Graphics
		  Dim i As Integer
		  Dim SingleSerie As Boolean = (Series.Ubound = 0)
		  Dim R As Integer = Plot.Radius
		  
		  X = X-Plot.Left
		  Y = Y-Plot.top
		  
		  
		  Dim a As ArcShape
		  
		  
		  If SingleSerie then
		    
		    For i = 0 to Series(0).mPts.Ubound
		      
		      a = new ArcShape
		      a.StartAngle = Series(0).mStartAngles(i)
		      a.ArcAngle = Series(0).mArcAngles(i)
		      a.FillColor = &c0
		      a.Width = R
		      a.Height = R
		      a.Segments = 50
		      a.Scale = 1
		      
		      
		      gp.DrawObject(a, Series(0).mPts(i).X, Series(0).mPts(i).Y)
		      
		      If gp.Pixel(X, Y) = &c0 then
		        //Found the slice
		        SelectedSlice(i) = not SelectedSlice(i)
		        LastDataPoint = new ChartDataPoint(Series(0), i, "", Series(0).Values(i))
		        LastDataPoint.selected = SelectedSlice(i)
		        
		        ClosestDataPointChanged(LastDataPoint)
		        Redisplay()
		        
		        #if TargetDesktop
		          Return True
		        #Elseif TargetWeb
		          Return
		        #endif
		      End If
		      
		      gp.ForeColor = &cFFFFFF
		      gp.AAG_FillAll()
		    Next
		    
		  else
		    For i = 0 to Series.Ubound
		      
		      a = new ArcShape
		      a.StartAngle = Series(i).mStartAngles(0)
		      a.ArcAngle = Series(i).mArcAngles(0)
		      a.FillColor = &c0
		      a.Width = R
		      a.Height = R
		      a.Segments = 50
		      a.Scale = 1
		      
		      gp.DrawObject(a, Series(i).mPts(0).X, Series(i).mPts(0).Y)
		      
		      If gp.Pixel(X, Y) = &c0 then
		        //Found the slice
		        SelectedSlice(i) = not SelectedSlice(i)
		        LastDataPoint = new ChartDataPoint(Series(i), i, "", Series(i).Values(0))
		        LastDataPoint.selected = SelectedSlice(i)
		        
		        ClosestDataPointChanged(LastDataPoint)
		        Redisplay()
		        #if TargetDesktop
		          Return True
		        #Elseif TargetWeb
		          Return
		        #endif
		      End If
		      
		      gp.ForeColor = &cFFFFFF
		      gp.AAG_FillAll()
		    Next
		  End If
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  //
		  
		  
		  If LastDataPoint <> Nil then
		    LastDataPoint = Nil
		    me.SafeInvalidate(False)
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  #if TargetDesktop
		    If UBound(me.Axes)<0 or UBound(me.Series)<0 then
		      Return
		    End If
		    
		    Dim i, j, k As Integer
		    
		    If Type >= TypePie then
		      Return
		    End If
		    
		    If FollowValues then
		      
		      If Series.Ubound = -1 then Return
		      
		      If X < Plot.Left or X > Plot.Left + Plot.Width then
		        If LastDataPoint <> Nil then
		          LastDataPoint = Nil
		          Refresh(False)
		          ClosestDataPointChanged(Nil)
		        End If
		        Return
		      End If
		      
		      
		      X = X -Plot.Left
		      Y = Y-Plot.Top
		      
		      Dim ClosestLabel As Integer
		      ClosestLabel = min(Labels.Ubound, Round(X/Axes(0).UnitWidth/Precision)*Precision)
		      
		      Dim cdp As ChartDataPoint
		      If Series.Ubound = 0 then
		        cdp = New ChartDataPoint(Series(0), ClosestLabel/Precision, Labels(ClosestLabel), Series(0).Values(ClosestLabel).SingleValue)
		        
		      else
		        'Dim ClosestSerie As Integer
		        Dim Distance() As Integer
		        Dim S() As Integer
		        
		        For i = 0 to Series.Ubound
		          If Series(i).MarkLine then
		            Continue for i
		          End If
		          
		          If Series(i).mPts.Ubound >= ClosestLabel and Series(i).mPts(ClosestLabel) <> Nil then
		            S.Append i
		            
		            Distance.Append Abs(Y-Series(i).mPTS(ClosestLabel).Y)
		          End If
		        Next
		        
		        If UBound(Distance)>-1 then
		          Distance.SortWith(S)
		          cdp = New ChartDataPoint(Series(S(0)), ClosestLabel/Precision, Labels(ClosestLabel), Series(S(0)).Values(ClosestLabel).SingleValue)
		        End If
		      End If
		      
		      If cdp <> LastDataPoint then
		        LastDataPoint = cdp
		        Refresh(False)
		        ClosestDataPointChanged(cdp)
		      End If
		      Return
		      
		      
		    End If
		    
		    
		    'Dim UnitWidth As Double = me.Axes(0).UnitWidth
		    'Dim strHelp As String
		    'Dim Value As Double
		    'Dim Total As Double
		    X = X - me.Plot.Left
		    
		    Y = Y - me.plot.Top
		    
		    If HelpTag2.Visible then
		      HelpTagVisible = False
		      HelpTagTimer.Period = 10
		    End If
		    
		    Dim PrecisionX, PrecisionY As Integer
		    Dim pt As REALbasic.Point
		    
		    
		    
		    Dim cp As ChartPoint
		    
		    For j = 0 to UBound(Series)
		      If Series(j).MarkLine then
		        Continue for j
		      End If
		      
		      If Series(j).SecondaryAxis then
		        PrecisionX = Ceil((Axes(2).UnitWidth/Axes(2).MajorUnit)/2)
		      else
		        PrecisionX = Ceil((Axes(1).UnitWidth/Axes(1).MajorUnit)/2)
		      End If
		      PrecisionY = max(5, Series(j).MarkerSize)
		      For i = 0 to UBound(Series(j).mPts)
		        
		        pt = Series(j).mPts(i)
		        
		        If pt is Nil then Continue for i
		        
		        If x>=pt.x-PrecisionX and x<=pt.x+PrecisionX then
		          
		          //HelpTag
		          If y>=pt.y-PrecisionY and y<=pt.y+PrecisionY then
		            HelpTag2.Serie = j
		            HelpTag2.Value = i
		            HelpTagVisible = True
		            HelpTagTimer.Enabled = True
		            
		          else
		            if j < UBound(Series) then
		              Continue for j
		            end if
		          End If
		          
		          //FollowMouse
		          If FollowMouse then
		            For k = 0 to UBound(Series)
		              If Series(k).mPts.ubound <i then Continue for k
		              
		              pt = Series(k).mPts(i)
		              
		              If pt is Nil then Continue for k
		              
		              cp = New ChartPoint
		              cp.Serie = k
		              cp.Point = pt.Clone
		              
		              'HighlightPoints.Append cp
		            Next
		            
		            Refresh(False)
		            
		            MouseMove(X, Y, i)
		            
		          End If
		          
		          Return
		        End If
		      Next
		    Next
		    
		    HelpTagVisible = False
		    HelpTag2.Serie = -1
		    HelpTag2.Value = -1
		    
		    Return
		    '
		    '
		    'For i  = 0 to UBound(Labels)
		    '
		    'If x > i*unitWidth and x < (i+1.0)*unitWidth then
		    '
		    'HelpTagVisible = True
		    'HelpTag2.Serie = 0
		    'HelpTag2.Value = i
		    'HelpTagTimer.Enabled = True
		    'Return
		    '
		    '//We found Which column
		    '
		    'strHelp = GetHelpTag(i)
		    '
		    'If strHelp = "" then
		    '
		    'If Ubound(me.Axes(0).Label)>-1 then
		    'strHelp = me.Labels(i)
		    'End If
		    '
		    'For j  = 0 to UBound(Series)
		    'Value = me.GetValue(i,j)
		    'If Series(j).SecondaryAxis and Axes(2).LogarithmicScale then
		    'Value = 10^(log(Value)/log(10))
		    'elseif Series(j).SecondaryAxis=False and Axes(1).LogarithmicScale then
		    'Value = 10^(log(Value)/log(10))
		    'End If
		    'Total = Total + Value
		    'strHelp = strHelp + EndOfLine + me.Series(j).Title + " : " + str(Value)'me.Series(j).Values(i))
		    '
		    'Next
		    '
		    'If (me.Type-1) mod 100 = 0 then
		    'strHelp = strHelp + EndOfLine + "Total: " + str(Total)
		    'End If
		    '
		    'End If
		    '
		    'exit for i
		    'End If
		    'Next
		    
		    'If me.HelpTag <> strHelp then
		    'me.HelpTag = strHelp
		    'End If
		  #endif
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  #pragma Unused deltaX
		  #pragma Unused deltaY
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  #if TargetDesktop
		    #if TargetMacOS then
		      me.EraseBackground = True
		      
		    #else
		      me.EraseBackground = False
		    #endif
		    me.DoubleBuffer = False
		    me.AcceptFocus = False
		    
		  #endif
		  
		  
		  
		  
		  
		  
		  
		  #if TargetDesktop
		    HelpTagTimer = New Timer
		    HelpTagTimer.Enabled = False
		    HelpTagTimer.Mode = Timer.ModeMultiple
		    HelpTagTimer.Period = 500
		    
		    HelpTag2 = new ChartHelpTag
		    
		    AddHandler HelpTagTimer.Action, AddressOf HelptagAction
		  #endif
		  
		  'Margin = 20
		  
		  Init()
		  
		  Precision = 1
		  
		  ShowRangeSelector = True
		  RangeSelectorHeight = 45
		  
		  If Type < TypeColumn then
		    Type = TypeColumn
		  End If
		  
		  LegendPosition = Position.Top
		  Legend = New ChartLabel
		  
		  SetDefaultColors = PaletteGoogle
		  
		  'InitSeries(-1)
		  
		  'BarGapPixel = 1
		  
		  
		  //Month Names
		  SetupLocaleInfo()
		  
		  Open()
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #Pragma Unused areas
		  
		  If Freeze then Return
		  
		  #if TargetWin32
		    Dim lastGDI As Boolean = App.UseGDIPlus
		    App.UseGDIPlus = True
		  #endif
		  
		  Dim gg, gp As Graphics
		  
		  If Plot is nil then Return
		  
		  #if DebugBuild
		    Dim ms As Double = Microseconds
		  #endif
		  
		  If Animate and AnimationInProgress and AnimInit then
		    PaintAnimation1(g)
		    Return
		  End If
		  
		  
		  If LastSize <> Width * Height then
		    #if TargetWin32
		      if not LiveRefresh and System.MouseDown then
		        g.DrawPicture(Buffer, 0, 0)
		        Return
		      end if
		    #endif
		    FullRefresh = True
		    RangeBuffer = Nil
		    LastSize = Width * Height
		  End If
		  
		  #if TargetMacOS
		    FullRefresh = True
		  #endif
		  
		  If FullRefresh or Buffer is Nil then
		    
		    LastSize = Width * Height
		    
		    SetMetrics
		    If HelpTagVisible then
		      HelpTagVisible = False
		    End If
		    
		    '#if TargetWin32
		    If Animate and AnimationInProgress then
		      PaintAnimation1(g)
		      
		      #if TargetWin32
		        App.UseGDIPlus = lastGDI
		      #endif
		      Return
		    End If
		    '#else
		    'AnimationInProgress = False
		    '#endif
		    
		    #if TargetWin32
		      Buffer = New Picture(Width, Height, 32)
		      gg = Buffer.Graphics
		    #else
		      gg = g
		    #endif
		    
		    DrawBackground(gg)
		    
		    me.Plot.Draw(gg)
		    
		    DrawAxis(gg)
		    DrawLegend(gg)
		    
		    
		    If Type >=TypePie then
		      gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		    else
		      gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width+5, Plot.Height)
		    End If
		    
		    If Type = TypeCombo then
		      
		      PlotCombo(gp)
		      
		    elseIf Type\100 = TypeColumn\100 then
		      
		      PlotColumn(gp)
		      
		    Elseif Type = TypeLineSmooth or Type = TypeLineStackedSmooth then
		      
		      PlotSpline(gp)
		      
		    Elseif Type\100 = TypeLine\100 then
		      
		      PlotLine(gp)
		      
		    Elseif Type\100 = TypeArea\100 then
		      
		      PlotArea(gp)
		      
		    Elseif Type\100 = TypeBar\100 Then
		      
		      PlotBar(gp)
		      
		    Elseif Type\100 = TypeScatter\100 then
		      
		      PlotScatter(gp)
		      
		    Elseif Type\100 = TypeTrendTimeLine\100 then
		      
		      PlotTrend(gg)
		      
		    Elseif Type\100 = TypePie\100 then
		      
		      PlotPie(gp)
		      
		      
		    Elseif Type\100 = TypeRadar\100 then
		      
		      PlotRadar(gp)
		      
		    Elseif Type\100 = TypeTreeMap\100 then
		      
		      PlotTreeMap(gp)
		      
		    Elseif Type\100 = TypeBoxPlot\100 Then
		      
		      PlotBoxPlot(gp)
		      
		    End If
		    
		    Dim H As ChartDataPoint
		    Dim Hindex As Integer
		    For i As Integer = 0 to UBound(HighlightPoints)
		      H = HighlightPoints(i)
		      Hindex = Round(H.Index/Precision)
		      If H.Serie.mPts.Ubound >= Hindex and H.Serie.mPts(Hindex) <> Nil then
		        DrawMarker(gp, H.Serie, H.Serie.mPts(Hindex).X, H.Serie.mPts(Hindex).Y, False, True, H.FillColor)
		      End If
		    Next
		    
		    DrawMark(gp)
		    
		    
		    
		    If Border then
		      gg.PenWidth = 1
		      gg.PenHeight = 1
		      gg.ForeColor = BorderColor
		      gg.DrawRect(0, 0, gg.Width, gg.Height)
		    End If
		    
		    FullRefresh = False
		    
		  End If
		  
		  #if TargetWin32
		    g.DrawPicture(Buffer, 0, 0)
		  #endif
		  
		  //Drawing Helptag
		  If ShowHelpTag and HelpTag2 <> Nil and HelpTagVisible then
		    g.ForeColor = Series(HelpTag2.Serie).FillColor
		    DrawMarker(g, Series(HelpTag2.Serie), Plot.left + Series(HelpTag2.Serie).mPts(HelpTag2.Value).X, Plot.Top + Series(HelpTag2.Serie).mPts(HelpTag2.Value).Y, False, True)
		    DrawHelpTag(g, Plot.left + Series(HelpTag2.Serie).mPts(HelpTag2.Value).X, Plot.Top + Series(HelpTag2.Serie).mPts(HelpTag2.Value).Y, HelpTag2.Value, HelpTag2.Serie)
		    
		  End If
		  
		  //Drawing the Marker following the mouse
		  If FollowValues then
		    'If UBound(HighlightPoints)>-1 then
		    'g.ForeColor = Axes(0).ForeColor
		    'Dim x As Integer = HighlightPoints(0).Serie*Axes(0).UnitWidth + Plot.Left
		    'g.DrawLine(X, Plot.Top, X, Plot.Top + Plot.Height)
		    
		    If LastDataPoint <> Nil then
		      
		      If FollowAllSeries then
		        
		        g.ForeColor = BorderColor
		        g.PenWidth = 2
		        g.PenHeight = 2
		        g.DrawLine(Plot.Left + Axes(0).UnitWidth*LastDataPoint.Index, Plot.Top, Plot.Left + Axes(0).UnitWidth*LastDataPoint.Index, Plot.Top + Plot.Height)
		        'g.DrawLine(Plot.Left + LastDataPoint.Serie.mPts(LastDataPoint.Index).X, Plot.Top, Plot.Left + LastDataPoint.Serie.mPts(LastDataPoint.Index).X, Plot.Top + Plot.Height)
		        
		      else
		        
		        g.ForeColor = LastDataPoint.Serie.FillColor
		        DrawMarker(g, LastDataPoint.Serie, Plot.Left + LastDataPoint.Serie.mPts(LastDataPoint.Index).X, _
		        Plot.Top + LastDataPoint.Serie.mPts(LastDataPoint.Index).Y, False, True)
		      End If
		      
		    End If
		    
		    'For i = 0 to UBound(HighlightPoints)
		    'g.ForeColor = Series(HighlightPoints(i).Serie).FillColor
		    'DrawMarker(g, Series(HighlightPoints(i).Serie), Plot.Left + HighlightPoints(i).Point.X, Plot.Top + HighlightPoints(i).Point.Y, False, True)
		    'Next
		  End If
		  
		  #if DebugBuild
		    ms = Microseconds - ms
		    'g.DrawString(str(ms/1000), g.Width-100, 10)
		  #endif
		  
		  
		  
		  #if TargetWin32
		    
		    App.UseGDIPlus = lastGDI
		  #endif
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddMark(Value As Double, Label As String, lineColor As Color, lineWidth As Integer = 1)
		  //ignore in LR
		  //Deprecated version 1.1
		  
		  //Adds a new MarkLine to the plot.
		  //
		  //Mark lines aren't displayed in Pie Charts
		  
		  Marks.Append New ChartMarkLine(Value, Label, lineColor, lineWidth)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddMarkLine(Value As Double, Label As String, lineColor As Color, lineWidth As Integer = 1, labelColor As Color = &c000001)
		  //Adds a new MarkLine to the plot.
		  //
		  //Mark lines aren't displayed in Pie Charts
		  
		  Marks.Append New ChartMarkLine(Value, Label, lineColor, lineWidth, labelColor)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddSerie(S As ChartSerie)
		  //Adds a new ChartSerie to the list of Series and changes the FillColor to use the DefaultColors if the FillColor was not changed before calling this function.
		  
		  
		  If S.FillColor = &c000001 then
		    S.FillColor = DefaultColors((UBound(Series)+1) mod UBound(DefaultColors))
		  End If
		  S.needsCalc = True
		  
		  Series.Append S
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function AlphaColor(C As Color, Alpha As Integer, Force As Boolean = False) As Color
		  #if TargetDesktop and TargetWin32
		    If app.usegdiplus = False then
		      Return C
		    End If
		  #endif
		  
		  If C.Alpha <> 0 and Not Force then
		    Return C
		  End If
		  Return RGB(C.Red, C.Green, C.Blue, Alpha*255.0/100.0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AnimationInit()
		  Dim frameRate As Integer = 40
		  Dim i As Integer
		  
		  AnimMaxFrame = frameRate / (1000 / AnimationTime)
		  
		  Redim AnimTimes(AnimMaxFrame)
		  Redim AnimPercent(AnimMaxFrame)
		  
		  Dim TimePerFrame As Double = 1000 / frameRate
		  
		  #if kDebug
		    System.DebugLog "AnimationInit"
		  #endif
		  
		  For i = 0 to AnimMaxFrame
		    AnimTimes(i) = TimePerFrame * (i+1)
		    AnimPercent(i) = 100*i/AnimMaxFrame
		    
		  Next
		  
		  AnimInit = True
		  
		  Dim gg As Graphics
		  Buffer = New Picture(Width, Height, 32)
		  gg = Buffer.Graphics
		  
		  DrawBackground(gg)
		  DrawAxis(gg)
		  DrawLegend(gg)
		  
		  If Border then
		    gg.ForeColor = BorderColor
		    gg.DrawRect(0, 0, gg.Width, gg.Height)
		  End If
		  
		  AnimstartTime = Microseconds/1000
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BezierX(ByVal t As Single, ByVal x0 As Single, ByVal x1 As Single, ByVal x2 As Single, ByVal x3 As Single) As Single
		  
		  Return Round(x0 * (1 - t) ^ 3 + _
		  x1 * 3 * t * (1 - t) ^ 2 + _
		  x2 * 3 * t ^ 2 * (1 - t) + _
		  x3 * t ^ 3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BezierY(ByVal t As Single, ByVal y0 As Single, ByVal y1 As Single, ByVal y2 As Single, ByVal y3 As Single) As Single
		  Return Round(y0 * (1 - t) ^ 3 + _
		  y1 * 3 * t * (1 - t) ^ 2 + _
		  y2 * 3 * t ^ 2 * (1 - t) + _
		  y3 * t ^ 3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CombSort(ByRef Input() As ChartSerie)
		  //CombSort from smallest to tallest value
		  
		  Const Shrink = 1.3
		  Dim swapped As Boolean
		  Dim i, u, gap As Integer
		  Dim swap As ChartSerie
		  
		  u = UBound(Input())
		  gap = u
		  
		  
		  while gap > 1 or swapped
		    if gap > 1 then
		      gap = gap / shrink
		    End If
		    
		    swapped = False
		    
		    For i = 0 to u-gap
		      If Input(i) > Input(i+gap) then
		        
		        swap = Input(i)
		        Input(i) = Input(i+gap)
		        Input(i+gap) = swap
		        swapped = True
		      End If
		    Next
		    
		  wend
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000, CompatibilityFlags = TargetWeb
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  #if TargetDesktop
		    #if TargetMacOS then
		      me.EraseBackground = True
		    #else
		      me.EraseBackground = False
		    #endif
		    me.DoubleBuffer = False
		    me.AcceptFocus = False
		  #endif
		  
		  
		  
		  
		  DelayedAutoUpdate = New Timer
		  DelayedAutoUpdate.Mode = timer.ModeSingle
		  DelayedAutoUpdate.Period = 10000*(1.0+Rnd)
		  
		  AddHandler DelayedAutoUpdate.Action, AddressOf AutoUpdate
		  
		  
		  'AutoUpdate()
		  
		  
		  
		  'Margin = 20
		  
		  Init()
		  
		  Precision = 1
		  
		  ShowRangeSelector = True
		  RangeSelectorHeight = 45
		  
		  If Type < TypeColumn then
		    Type = TypeColumn
		  End If
		  
		  LegendPosition = Position.Top
		  Legend = New ChartLabel
		  
		  SetDefaultColors = PaletteGoogle
		  
		  'InitSeries(-1)
		  
		  'BarGapPixel = 1
		  
		  
		  //Month Names
		  SetupLocaleInfo()
		  
		  Open()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Correlation() As Double
		  //Source http://www-irma.u-strasbg.fr/~geffray/cours/cours-nantes/coursIUT4.pdf
		  
		  Dim r As Double
		  
		  Dim n As Integer = UBound(Labels)
		  
		  Dim SumXY As Double
		  Dim Xavg, Yavg As Double
		  Dim SumX2, SumY2 As Double
		  
		  Dim X() As Double
		  For i as Integer = 0 to UBound(Axes(0).Label)
		    X.Append val(Axes(0).Label(i))
		  Next
		  
		  Dim XSerie As New ChartSerie
		  XSerie.Data = X()
		  
		  SumXY = Series(0).SumXY(X())
		  
		  Xavg = XSerie.Average
		  Yavg = Series(0).Average
		  
		  SumX2 = XSerie.SumSquared()
		  SumY2 = Series(0).SumSquared
		  
		  r = (SumXY-n*Xavg*Yavg) / Sqrt( (SumX2 - n*Xavg^2) * (SumY2 - n*Yavg^2))
		  
		  Return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteAllMarkLines()
		  //#newinversion 1.3
		  //Removes all marklines
		  
		  ReDim Marks(-1)
		  Redim MarkSeries(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  
		  
		  #if TargetDesktop
		    If mAnimationTimer <> Nil then
		      mAnimationTimer.Mode = Timer.ModeOff
		      
		      RemoveHandler mAnimationTimer.Action, WeakAddressOf mAnimationTimerAction
		      
		      mAnimationTimer = Nil
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawAxis(g As Graphics)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  If Type < TypePie then
		    
		    Dim X, Y, W, H, i, U, DrawLblIndex, LabelX, LabelY As Integer
		    Dim xx, yy As Single
		    Dim xModifier As Single
		    X = Plot.Left
		    Y = Plot.Top
		    W = Plot.Width
		    H = Plot.Height
		    
		    Dim cAxe As ChartAxis
		    Dim cLine As ChartLine
		    Dim cLine2 As ChartLine
		    
		    Dim SwapAxis As Boolean = (Type \ 100 = TypeBar \ 100)
		    Dim lbl, txt As String
		    Dim LabelType As String
		    Dim d As date
		    Dim DrawIdx As Integer
		    
		    Dim minI As Integer
		    If UBound(Axes)>0 then
		      cAxe = Axes(1)
		      If cAxe.MinimumScale < 0 then
		        minI = Floor(cAxe.MinimumScale/cAxe.MajorUnit)*cAxe.MajorUnit
		        BaseDrawY = H + minI*cAxe.UnitWidth/cAxe.MajorUnit
		      else
		        minI = cAxe.MinimumScale
		        BaseDrawY = H
		      End If
		      
		    else
		      BaseDrawY = H
		    End If
		    
		    
		    U = UBound(Labels)
		    
		    Dim gg As Graphics = g.Clip(0, Y, g.Width, g.Height-Y)
		    
		    
		    
		    //-------------------//
		    //     X Axis       //
		    //-----------------//
		    If UBound(Axes)>-1 and Axes(0).Visible then
		      cAxe = Axes(0)
		      LabelType = cAxe.LabelType
		      
		      If cAxe.LabelPosition = cAxe.LabelInPlot then
		        LabelY = BaseDrawY
		      elseif cAxe.LabelPosition = cAxe.LabelBesidePlot then
		        LabelY = H
		      else
		        LabelY = -10000
		      End If
		      
		      gg.ForeColor = cAxe.AxeLine.FillColor
		      gg.PenWidth = cAxe.AxeLine.Width
		      gg.PenHeight = cAxe.AxeLine.Width
		      If cAxe.AxeLine.Visible then
		        If SwapAxis then
		          gg.DrawLine(X, 0, X, H)
		        else
		          gg.DrawLine(X, BaseDrawY, X+W, BaseDrawY)
		        End If
		      End If
		      
		      gg.PenWidth = 1
		      gg.PenHeight = 1
		      
		      cLine = cAxe.MajorGridLine
		      cLine2 = cAxe.MinorGridLine
		      
		      xx = X
		      'yy = BaseDrawY
		      yy=0
		      
		      If CrossesBetweenTickMarks then
		        xModifier = cAxe.UnitWidth/2
		      End If
		      
		      //Getting style of text before the loop
		      gg.Bold = cAxe.LabelStyle.Bold
		      gg.Italic = cAxe.LabelStyle.Italic
		      gg.Underline = cAxe.LabelStyle.Underline
		      gg.TextSize = cAxe.LabelStyle.TextSize
		      gg.TextFont = cAxe.LabelStyle.TextFont
		      
		      Dim LastYear As Integer
		      
		      For i = 0 to U
		        
		        //Drawing Major Grid line
		        If cLine <> Nil and cLine.Visible then
		          gg.ForeColor = cLine.FillColor
		          If SwapAxis then
		            gg.DrawLine(X, yy, X + W, yy)
		          else
		            gg.DrawLine(xx, 0, xx, BaseDrawY)
		          End If
		        End If
		        
		        //Drawing Ticks
		        If cAxe.AxeLine.Visible and cAxe.AxeLine.FillType <> cAxe.AxeLine.FillNone then
		          gg.ForeColor = cAxe.AxeLine.FillColor
		          If i mod cAxe.MajorUnit = 0 or i=U then
		            If SwapAxis then
		              gg.DrawLine(X-3, yy, X+3, yy)
		            else
		              gg.DrawLine(xx, BaseDrawY-3, xx, BaseDrawY+3)
		            End If
		          End If
		        End If
		        
		        //Drawing label
		        If i mod cAxe.LabelInterval = 0 then
		          
		          lbl = Labels(i)
		          
		          If LabelType = "Date" then
		            d = new date
		            try
		              d.SQLDateTime = lbl
		              lbl = mParseDate(D, Axes(0).LabelStyle.Format, "SQLDate", LastYear <> D.Year)
		              LastYear = D.Year
		            Catch
		            End Try
		          End If
		          
		          If LabelTwoLevel and not SwapAxis then
		            //Multi Level Label
		            if DrawLblIndex mod 2 = 1 then
		              gg.DrawString(lbl, xx + xModifier -(gg.StringWidth(lbl))\2, LabelY + 5 + gg.TextHeight*2)
		            else
		              gg.DrawString(lbl, xx + xModifier -(gg.StringWidth(lbl))\2, LabelY + 5 + gg.TextHeight)
		            end if
		            
		          elseif SwapAxis then
		            gg.DrawString(lbl, X-7-gg.StringWidth(lbl), yy + (cAxe.UnitWidth-gg.TextHeight)\2 + gg.TextAscent)
		            
		            //Single Level Label
		          else
		            if i = U and xModifier=0 then
		              gg.DrawString(lbl, min(xx-(gg.StringWidth(lbl))\2, (gg.Width-gg.StringWidth(lbl)-2)), LabelY+5 + gg.TextHeight)
		            else
		              DrawStringCenter(gg, lbl, xx + xModifier, LabelY + 5 + gg.TextHeight)
		              'gg.DrawString(lbl, xx + xModifier -(gg.StringWidth(lbl))\2, LabelY + 5 + gg.TextHeight)
		            end if
		          End If
		          
		          DrawLblIndex = DrawLblIndex + 1
		        End If
		        
		        
		        
		        xx = xx + cAxe.UnitWidth
		        yy = yy + cAxe.UnitWidth
		        
		      Next
		      
		      
		      
		      //Drawing One tick at the end when there is no Data
		      If U=-1 then
		        xx = X+W
		        gg.DrawLine(xx, BaseDrawY-3, xx, BaseDrawY+3)
		        
		      else
		        
		        //Drawing Ticks
		        If cAxe.AxeLine.Visible then
		          gg.ForeColor = cAxe.AxeLine.FillColor
		          If i mod cAxe.MajorUnit = 0 or i=U then
		            If SwapAxis then
		              gg.DrawLine(X-3, yy, X+3, yy)
		            else
		              'gg.DrawLine(xx, BaseDrawY-3, xx, BaseDrawY+3)
		            End If
		          End If
		        End If
		        
		      End If
		      
		      If cAxe.Title <> "" then
		        If SwapAxis then
		          Dim tobj As New StringShape
		          tobj.Bold = True
		          tobj.FillColor = gg.ForeColor
		          tobj.Text = cAxe.Title
		          tobj.TextFont = gg.TextFont
		          tobj.TextSize = gg.TextSize
		          #if TargetDesktop
		            tobj.TextUnit = gg.TextUnit
		          #endif
		          
		          tobj.X = 2+gg.TextHeight
		          tobj.Y = H/2
		          tobj.Rotation = -1.57079633 //-90°
		          gg.DrawObject(tobj, 0, 0)
		        Else
		          gg.Bold = True
		          If LabelTwoLevel then
		            gg.DrawString(cAxe.Title, Plot.Left + (Plot.Width-gg.StringWidth(cAxe.Title))\2, H + 10 + gg.TextHeight*3)
		          else
		            gg.DrawString(cAxe.Title, Plot.Left + (Plot.Width-gg.StringWidth(cAxe.Title))\2, H + 10 + gg.TextHeight*2)
		          End If
		          gg.Bold = False
		        End If
		      End If
		      
		    End If
		    
		    //-------------------//
		    //  Primary Y Axis  //
		    //-----------------//
		    If UBound(Axes)>0 And Axes(1).Visible then
		      cAxe = Axes(1)
		      
		      yy = H
		      xx = X
		      
		      If (Type\100 = TypeScatter\100 or Continuous) and Axes(0).MinimumScale < 0 then
		        xX = xX - Axes(0).UnitWidth*Axes(0).MinimumScale
		      End If
		      
		      
		      If cAxe.LabelPosition = cAxe.LabelInPlot then
		        LabelX = xx
		      elseif cAxe.LabelPosition = cAxe.LabelBesidePlot then
		        LabelX = Plot.Left
		      else
		        LabelX = -10000
		      End If
		      
		      //Drawing Line
		      gg.ForeColor = cAxe.AxeLine.FillColor
		      gg.PenWidth = cAxe.AxeLine.Width
		      gg.PenHeight = cAxe.AxeLine.Width
		      If SwapAxis then
		        gg.DrawLine(X, H, X+W, H)
		      else
		        gg.DrawLine(xx+1-gg.PenHeight, 0, xx+1-gg.PenHeight, H)
		      End If
		      
		      gg.PenWidth = 1
		      gg.PenHeight = 1
		      
		      cLine = cAxe.MajorGridLine
		      cLine2 = cAxe.MinorGridLine
		      
		      If UBound(Series)=-1 and cAxe.MaximumScale = 0 then
		        cAxe.UnitWidth = H
		      End If
		      
		      
		      
		      Dim tmpPercent As String
		      If Type mod 100 = 2 then
		        tmpPercent = "%"
		      End If
		      
		      Dim y1, y2 As Integer
		      Dim unitHeight As Double = cAxe.UnitWidth/cAxe.MajorUnit
		      For i = 0 to cAxe.ZoneStart.Ubound
		        
		        gg.ForeColor = cAxe.ZoneColor(i)
		        y2 = Floor((cAxe.ZoneEnd(i) - cAxe.ZoneStart(i)) * unitHeight - 1)
		        
		        If SwapAxis then
		          y1 = Ceil(gg.Width-cAxe.ZoneEnd(i) * unitHeight)
		          gg.FillRect(y1-y2, 0, y2, H-1)
		          
		        else
		          y1 = Ceil(H - (cAxe.ZoneEnd(i) - minI) * unitHeight)
		          gg.FillRect(xx+1, y1, W-2, y2)
		        End If
		      Next
		      
		      
		      //Getting style of text before the loop
		      gg.Bold = cAxe.LabelStyle.Bold
		      gg.Italic = cAxe.LabelStyle.Italic
		      gg.Underline = cAxe.LabelStyle.Underline
		      gg.TextSize = cAxe.LabelStyle.TextSize
		      gg.TextFont = cAxe.LabelStyle.TextFont
		      
		      For i = minI to cAxe.MaximumScale+cAxe.MajorUnit step cAxe.MajorUnit
		        'For i = minI to cAxe.MaximumScale step cAxe.MajorUnit
		        
		        
		        
		        //CLine
		        If cLine <> Nil then
		          gg.ForeColor = cLine.FillColor
		          if SwapAxis then
		            If Floor(xx) <> Plot.Left then
		              gg.DrawLine(xx, H-3, xx, 0)
		            End If
		          else
		            If Floor(yy) <> BaseDrawY then
		              gg.DrawLine(X+3, yy, W+X, yy)
		            End If
		          End If
		        End If
		        
		        
		        //Drawing Ticks
		        If cAxe.AxeLine.Visible and cAxe.AxeLine.FillType <> ChartLine.FillNone then
		          gg.ForeColor = cAxe.AxeLine.FillColor
		          If SwapAxis then
		            gg.DrawLine(xx, H-3, xx, H+3)
		          else
		            gg.DrawLine(xx-3, yy, xx+3, yy)
		          End If
		        End If
		        
		        
		        //Drawing String
		        gg.ForeColor = cAxe.ForeColor
		        
		        If DrawIdx mod cAxe.LabelInterval = 0 then
		          If cAxe.LogarithmicScale then
		            if i <> 1 then
		              txt = str(10^(i-1)) + tmpPercent + cAxe.LabelStyle.Format
		            else
		              txt = str(i)
		            end if
		          elseIf i<>0 then
		            txt = str(i) + tmpPercent + cAxe.LabelStyle.Format
		          else
		            txt = str(i)
		          End If
		          If SwapAxis then
		            
		            'gg.DrawString(txt, xx + (cAxe.UnitWidth-gg.StringWidth(txt))\2, H + 5 + gg.TextHeight)
		            
		            
		            
		            gg.DrawString(txt, xx-gg.StringWidth(txt)\2, H + 5 + gg.TextHeight)
		            
		            If X+W-xx < 1 then
		              exit for i
		            End If
		          else
		            If yy < 1 then
		              g.ForeColor = cAxe.ForeColor
		              
		              //Getting style of text before the loop
		              g.Bold = cAxe.LabelStyle.Bold
		              g.Italic = cAxe.LabelStyle.Italic
		              g.Underline = cAxe.LabelStyle.Underline
		              g.TextSize = cAxe.LabelStyle.TextSize
		              g.TextFont = cAxe.LabelStyle.TextFont
		              g.DrawString(txt, LabelX-7-g.StringWidth(txt), Y + yy - g.TextHeight\2 + g.TextAscent)
		              exit for i
		            else
		              
		              gg.DrawString(txt, LabelX-7-gg.StringWidth(txt), yy - gg.TextHeight\2 + gg.TextAscent)
		            End If
		          End If
		          
		          
		        End If
		        
		        DrawIdx = DrawIdx + 1
		        
		        yy = yy - axes(1).UnitWidth
		        If SwapAxis then
		          xx = xx + axes(1).UnitWidth
		        End If
		      Next
		      
		      If cAxe.Title <> "" then
		        
		        If SwapAxis then
		          gg.Bold = True
		          gg.DrawString(cAxe.Title, Plot.Left + (Plot.Width-gg.StringWidth(cAxe.Title))\2, gg.Height-gg.TextAscent)
		        else
		          Dim tobj As New StringShape
		          tobj.Bold = True
		          tobj.FillColor = gg.ForeColor
		          tobj.Text = cAxe.Title
		          tobj.TextFont = gg.TextFont
		          tobj.TextSize = gg.TextSize
		          #if TargetDesktop
		            tobj.TextUnit = gg.TextUnit
		          #endif
		          
		          tobj.X = (Plot.Left-gg.TextHeight)\2
		          tobj.Y = H/2
		          tobj.Rotation = -1.57079633 //-90°
		          gg.DrawObject(tobj, 0, 0)
		        End If
		        
		      End If
		      
		    End If
		    
		    //-------------------//
		    // Secondary Y Axis //
		    //-----------------//
		    If UBound(Axes)>1 and Axes(2).Visible then
		      cAxe = Axes(2)
		      
		      If DoubleYAxe = False then
		        If cAxe.MinimumScale < 0 then
		          minI = Floor(cAxe.MinimumScale/cAxe.MajorUnit)*cAxe.MajorUnit
		        else
		          minI = cAxe.MinimumScale
		        End If
		      End If
		      
		      X = Plot.Left + Plot.Width-1
		      
		      //Drawing the Axe line
		      gg.ForeColor = cAxe.AxeLine.FillColor
		      gg.PenWidth = cAxe.AxeLine.Width
		      gg.PenHeight = cAxe.AxeLine.Width
		      gg.DrawLine(X, 0, X, H)
		      
		      gg.PenWidth = cAxe.AxeLine.Width
		      gg.PenHeight = cAxe.AxeLine.Width
		      
		      cLine = Axes(2).MajorGridLine
		      cLine2 = Axes(2).MinorGridLine
		      
		      yy = H
		      
		      Dim tmpPercent As String
		      If Type mod 100 = 2 then
		        tmpPercent = "%"
		      End If
		      
		      Dim y1, y2 As Integer
		      Dim unitHeight As Double = cAxe.UnitWidth
		      For i = 0 to cAxe.ZoneStart.Ubound
		        y1 = H - cAxe.ZoneEnd(i) * unitHeight
		        y2 = (cAxe.ZoneEnd(i) - cAxe.ZoneStart(i)) * unitHeight - 1
		        
		        gg.ForeColor = cAxe.ZoneColor(i)
		        gg.FillRect(X, y1, W, y2)
		      Next
		      
		      
		      //Getting style of text before the loop
		      gg.Bold = cAxe.LabelStyle.Bold
		      gg.Italic = cAxe.LabelStyle.Italic
		      gg.Underline = cAxe.LabelStyle.Underline
		      gg.TextSize = cAxe.LabelStyle.TextSize
		      gg.TextFont = cAxe.LabelStyle.TextFont
		      
		      
		      For i = minI to cAxe.MaximumScale+cAxe.MajorUnit step cAxe.MajorUnit
		        
		        
		        If cLine <> Nil and i<>0 then
		          gg.ForeColor = cLine.FillColor
		          gg.DrawLine(X+3, yy, W+X, yy)
		        End If
		        
		        //Drawing Ticks
		        gg.ForeColor = cAxe.AxeLine.FillColor
		        If cAxe.AxeLine.FillType <> ChartLine.FillNone then
		          
		          'If SwapAxis then
		          'gg.DrawLine(xx, H-3, xx, H+3)
		          'else
		          gg.DrawLine(X-3, yy, X+3, yy)
		          'End If
		        End If
		        
		        
		        txt = str(i) + tmpPercent
		        
		        If yy < 1 then
		          g.ForeColor = cAxe.AxeLine.FillColor
		          g.DrawString(txt, X+7, Y + yy - g.TextHeight\2 + g.TextAscent)
		          exit for i
		        else
		          
		          gg.DrawString(txt, X+7, yy - gg.TextHeight\2 + gg.TextAscent)
		        End If
		        
		        yy = yy - cAxe.UnitWidth
		      Next
		      
		      If cAxe.Title <> "" then
		        
		        Dim tobj As New StringShape
		        tobj.Bold = True
		        tobj.FillColor = gg.ForeColor
		        tobj.Text = cAxe.Title
		        tobj.TextFont = gg.TextFont
		        tobj.TextSize = gg.TextSize
		        #if TargetDesktop
		          tobj.TextUnit = gg.TextUnit
		        #endif
		        
		        tobj.X = gg.Width-gg.TextHeight\2
		        tobj.Y = H/2
		        tobj.Rotation = -1.57079633 //-90°
		        gg.DrawObject(tobj, 0, 0)
		        
		      End If
		      
		      
		    End If
		    
		  Elseif Type\100 = TypeRadar\100 then
		    
		    DrawAxisRadar(g)
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawAxisRadar(g As Graphics)
		  Dim Xc, Yc, X1, Y1, i, ULabels, X, Y As Integer
		  Dim R As Integer
		  Dim xx As Double
		  
		  Xc = Plot.Width\2
		  Yc = Plot.Height\2
		  R = Round(Axes(1).UnitWidth/Axes(1).MajorUnit*Axes(1).MaximumScale)
		  
		  ULabels = UBound(Labels)
		  
		  
		  
		  Const PI=3.14159265358979323846264338327950
		  
		  Dim startA As Double = PieRadarAngle
		  Dim xA As Double = startA
		  Dim DeltaA As Double = 2*PI/(Ulabels+1)
		  
		  Dim gg As Graphics = g.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		  
		  Dim cAxe As ChartAxis
		  Dim cLine As ChartLine
		  
		  //---------------------//
		  // X Axis (circ axis) //
		  //-------------------//
		  If UBound(Axes)>-1 and Axes(0).Visible then
		    cAxe = Axes(0)
		    
		    gg.ForeColor = cAxe.AxeLine.FillColor
		    gg.PenWidth = cAxe.AxeLine.Width
		    gg.PenHeight = cAxe.AxeLine.Width
		    
		    gg.DrawOval(Xc-R, Yc-R, R*2, R*2)
		    
		    gg.PenWidth = 1
		    gg.PenHeight = 1
		    
		    cLine = cAxe.MajorGridLine
		    
		    If cLine <> Nil and cLine.Visible then
		      gg.ForeColor = cLine.FillColor
		      
		      For i = 0 to ULabels
		        
		        X = Xc + cos(xA)*R
		        Y = Yc + sin(xA)*R
		        
		        //Drawing Major Grid line
		        
		        gg.DrawLine(Xc, Yc, X, Y)
		        'gg.DrawString(str(i), X, Y)
		        
		        xA = xA + DeltaA
		      Next
		    End If
		  End If
		  
		  //-------------------//
		  //  Primary Y Axis  //
		  //-----------------//
		  If UBound(Axes)>0 And Axes(1).Visible then
		    cAxe = Axes(1)
		    
		    //Drawing Line
		    gg.ForeColor = cAxe.AxeLine.FillColor
		    gg.PenWidth = cAxe.AxeLine.Width
		    gg.PenHeight = cAxe.AxeLine.Width
		    
		    X = Xc + cos(startA)*R
		    Y = Yc + sin(startA)*R
		    
		    gg.DrawLine(Xc, Yc, X, Y)
		    
		    
		    
		    cLine = cAxe.MajorGridLine
		    
		    If cLine <> Nil and cLine.Visible then
		      gg.ForeColor = cLine.FillColor
		      
		      xx = 0
		      
		      For i = cAxe.MinimumScale to cAxe.MaximumScale-cAxe.MajorUnit step cAxe.MajorUnit
		        
		        R = Round(xx)
		        
		        gg.DrawOval(Xc-R, Yc-R, R*2, R*2)
		        
		        xx = xx + cAxe.UnitWidth
		        
		      Next
		      
		    End If
		    
		    //Drawing Ticks
		    gg.ForeColor = cAxe.AxeLine.FillColor
		    xx = 0
		    Dim c,s As Double
		    For i = cAxe.MinimumScale to cAxe.MaximumScale step cAxe.MajorUnit
		      
		      R = Round(xx)
		      
		      c = cos(startA)
		      s = sin(startA)
		      
		      X = Xc + c*R
		      Y = Yc + s*R
		      
		      X1 = X + cos(startA+PI/2.0)*3
		      Y1 = Y + sin(startA+PI/2.0)*3
		      
		      gg.DrawLine(X, Y, X1, Y1)
		      
		      X1 = X + cos(startA+PI/2.0)*6
		      Y1 = Y + sin(startA+PI/2.0)*6
		      
		      'Dim sX, sY As Integer
		      
		      
		      
		      If Abs(c)<0.15 then
		        
		        If s > 0 then
		          X1 = X1 - gg.StringWidth(str(i))
		        End If
		        
		        
		      ElseIf c>0 then
		        X1 = X1 - gg.StringWidth(str(i))\2
		      elseif c < 0 then
		        X1 = X1 - gg.StringWidth(str(i))
		      End If
		      
		      If s < -0.8 then
		        Y1 = Y1 -gg.TextHeight\2 + gg.TextAscent
		        
		      elseif s > 0.8 then
		        
		        Y1 = Y1 - gg.TextHeight\2 + gg.TextAscent
		        
		      ElseIf Abs(s)<0.15 then
		        Y1 = Y1 + gg.TextAscent
		        
		      ElseIf s>0 then
		        Y1 = Y1 + gg.TextHeight
		      elseif s<0 then
		        //Y1
		      End If
		      gg.DrawString(str(i), X1, Y1)
		      
		      xx = xx + cAxe.UnitWidth
		    Next
		    
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawBackground(g As Graphics)
		  If BackgroundType = BackgroundNone then Return
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  //Buffering of the Buffer for Gradient only
		  If BackgroundBuffer <> Nil and BackgroundBuffer.Width = Width and BackgroundBuffer.Height = Height then
		    g.DrawPicture(BackgroundBuffer, 0, 0)
		    Return
		  End If
		  
		  //This is a hack in the Demo for testing purposes only
		  #If TargetDesktop
		    If BackgroundType = -1 then
		      If me.TrueWindow.Backdrop <> Nil then
		        Dim p As Picture = me.TrueWindow.Backdrop
		        If me.Left < p.Width and me.Top < p.Height then
		          g.DrawPicture p, 0, 0, Width, Height, left, top, Width, Height
		        End If
		      End If
		      
		      Return
		    End If
		  #endif
		  
		  //If no Background color, there is nothing to draw
		  If UBound(BackgroundColor) = -1 then Return
		  
		  //If Only one Background color is defined we fill all.
		  If BackgroundType = BackgroundSolid or UBound(BackgroundColor) = 0 then
		    g.ForeColor = BackgroundColor(0)
		    g.AAG_FillAll()
		    
		    
		    //This will draw a vertical gradient
		  elseif BackgroundType = BackgroundGradient then
		    
		    BackgroundBuffer = New Picture(Width, Height, 32)
		    BackgroundBuffer.graphics.AAG_Gradient(0, 0, g.Width, g.Height, BackgroundColor(0), BackgroundColor(1), True)
		    
		    g.DrawPicture(BackgroundBuffer, 0, 0)
		    
		  Elseif BackgroundType = BackgroundAlternate then
		    
		    If UBound(Axes) < 1 then Return
		    
		    Dim Y As Single = Plot.Top + Plot.Height
		    Dim gb As Graphics
		    
		    #if TargetWeb
		      BackgroundBuffer = New Picture(Width, Height)
		      gb = BackgroundBuffer.Graphics
		      gb.ForeColor = BackgroundColor(0)
		    #else
		      BackgroundBuffer = New Picture(Width, Height, 32)
		      gb = BackgroundBuffer.Graphics
		      gb.ForeColor = BackgroundColor(0)
		      gb.AAG_FillAll()
		    #endif
		    
		    
		    Dim cAxe As ChartAxis = Axes(1)
		    Dim minI As Integer
		    
		    
		    If cAxe.MinimumScale < 0 then
		      minI = Floor(cAxe.MinimumScale/cAxe.MajorUnit)*cAxe.MajorUnit
		    else
		      minI = cAxe.MinimumScale
		    End If
		    
		    Dim UColors As Integer = UBound(BackgroundColor)+1
		    
		    Dim idx As Integer
		    For i As Integer = minI to cAxe.MaximumScale step cAxe.MajorUnit
		      If Y<=Plot.Top then
		        Exit for i
		      End If
		      
		      gb.ForeColor = BackgroundColor(idx mod UColors)
		      
		      //Drawing Line
		      #if TargetWeb
		        gb.FillRect(Plot.Left, Round(Y-axes(1).UnitWidth), Plot.Width, Floor(cAxe.UnitWidth))
		      #else
		        gb.FillRect(Plot.Left, Round(Y-axes(1).UnitWidth), Plot.Width, Ceil(cAxe.UnitWidth))
		      #endif
		      
		      idx = idx + 1
		      Y = Y - axes(1).UnitWidth
		    Next
		    
		    g.DrawPicture(BackgroundBuffer, 0, 0)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawBezier(ByVal gr As Graphics, ByVal start_t As Single, ByVal stop_t As Single, ByVal dt As Single, ByVal pt0 As Realbasic.Point, ByVal pt1 As Realbasic.Point, ByVal pt2 As Realbasic.Point, ByVal pt3 As Realbasic.Point)
		  
		  Dim t, x0, y0, x1, y1 As Single
		  
		  t = start_t
		  x1 = BezierX(t, pt0.X, pt1.X, pt2.X, pt3.X)
		  y1 = BezierY(t, pt0.Y, pt1.Y, pt2.Y, pt3.Y)
		  t = t+dt
		  stop_t = stop_t+dt/2
		  Do until t > stop_t
		    x0 = x1
		    y0 = y1
		    x1 = BezierX(t, pt0.X, pt1.X, pt2.X, pt3.X)
		    y1 = BezierY(t, pt0.Y, pt1.Y, pt2.Y, pt3.Y)
		    gr.DrawLine( x0, y0, x1, y1)
		    t = t+dt
		  Loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawDataLabel(g As Graphics, Serie As ChartSerie, Value As Double, X As Integer, Y As Integer, Width As Integer=0, Height As Integer=0, Mask As Boolean = False, Align As Integer = 0)
		  If DataLabel Is Nil Or AnimationInProgress Then Return
		  
		  Dim strValue As String = Str(Value, DataLabel.Format)
		  
		  If Type\100 = TypeTreeMap\100 and DataLabel.Format = DataLabel.FormatTitle then
		    strValue = Serie.Title
		  End If
		  Dim Wcondense As Integer
		  
		  
		  
		  g.TextSize = DataLabel.TextSize
		  g.TextFont = DataLabel.TextFont
		  
		  Dim w As Single = g.StringWidth(strValue)
		  
		  //Fixing the maximum pixel of the text.
		  If Y-g.TextAscent < 0 then
		    Y = g.TextAscent+1
		  End If
		  
		  If Type\100 = TypeTreeMap\100 then
		    Wcondense = Width
		    If Wcondense-2 <= g.StringWidth(strValue.Left(2)) or Height < Y then
		      Return
		    End If
		  End If
		  
		  
		  
		  If DataLabel.HasBackColor Then
		    If Mask Then
		      g.ForeColor = &c0
		    Else
		      g.ForeColor = DataLabel.BackColor
		    End If
		    g.FillRect(Max(0, Floor(X-w/2)-2), Y-g.TextAscent, Ceil(w)+4, g.TextHeight)
		  End If
		  If DataLabel.Shadow Then
		    If mask Then 
		      g.ForeColor = &c0
		    Else
		      g.ForeColor = DataLabel.ShadowColor
		    End If
		    DrawFullShadow(g, strValue, Max(2, Round(X-w/2)), Y, Wcondense)
		    'g.DrawString(strValue, Round(X-w/2), Y+1)
		  End If
		  If mask Then
		    g.ForeColor = &c0
		  Else
		    g.ForeColor = DataLabel.TextColor
		  End If
		  
		  
		  
		  //Drawing the text
		  If Wcondense>0 then
		    If Align = PositionRight or Align = PositionInside Then
		      g.DrawString(strValue, X-g.StringWidth(strValue), Y, Wcondense, True)
		    Elseif Align = PositionLeft Then
		      g.DrawString(strValue, X, Y, Wcondense, True)
		    Else
		      g.DrawString(strValue, Max(2, Round(X-w/2)), Y, Wcondense, True)
		    End If
		    
		  else
		    If Align = PositionRight or Align = PositionInside Then
		      g.DrawString(strValue, X-g.StringWidth(strValue), Y)
		    Elseif Align = PositionLeft Then
		      g.DrawString(strValue, X, Y)
		    Else
		      g.DrawString(strValue, Max(2, Round(X-w/2)), Y)
		    End If
		    
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawDataLabelPie(g As Graphics, Serie As ChartSerie, Value As Double, X As Integer, Y As Integer, Radius As Single, Angle As Double, Mask As Boolean = False)
		  #Pragma Unused Serie
		  
		  If DataLabel is Nil or AnimationInProgress then Return
		  
		  
		  Dim strValue As String = Str(Value, DataLabel.Format)
		  If DataLabel.DisplayTitleAndValuePie Then
		    strValue = serie.Title + EndOfLine + strValue
		  End If
		  
		  g.TextSize = DataLabel.TextSize
		  g.TextFont = DataLabel.TextFont
		  
		  Dim w As Single = g.StringWidth(strValue)
		  Dim h As Single = g.TextHeight()
		  Dim c, s As Double
		  c = cos(Angle)
		  s = sin(Angle)
		  
		  'Angle = (Angle + 2*PI)/(2*PI)*PI
		  Radius = Radius*1.02
		  
		  If DataLabel.HasBackColor then
		    If Mask then
		      g.ForeColor = &c0
		    else
		      g.ForeColor = DataLabel.BackColor
		    End If
		    g.FillRect(max(0, Floor(X-w/2)-2), Y-g.TextAscent, Ceil(w)+4, g.TextHeight)
		  End If
		  If DataLabel.Shadow then
		    If mask then 
		      g.ForeColor = &c0
		    else
		      g.ForeColor = DataLabel.ShadowColor
		    End If
		    DrawFullShadow(g, strValue, max(2, Round(X-w/2)), Y)
		    'g.DrawString(strValue, Round(X-w/2), Y+1)
		  End If
		  If mask then
		    g.ForeColor = &c0
		  else
		    g.ForeColor = DataLabel.TextColor
		  End If
		  
		  Dim sX, sY As Integer
		  
		  If Abs(c)<0.15 then
		    sx = X + (c*Radius-w)\2
		    
		  ElseIf c>0 then
		    sx = X + c*Radius
		  elseif c < 0 then
		    sx = X + c*Radius - w
		  End If
		  
		  If Abs(s)<0.15 then
		    'sY = Y + h/2
		    sY = Y + (s*Radius-h)\2
		  ElseIf s>0 then
		    sY = Y + s*Radius+h
		  elseif s<0 then
		    sY = Y + s*Radius
		  End If
		  
		  g.DrawString(strValue, sX, sY)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawFullShadow(g As Graphics, str As String, X As Integer, Y As Integer, Width As Integer = 0)
		  
		  If Width = 0 then
		    g.DrawString(str, X-1, Y)
		    g.DrawString(str, X+1, Y)
		    g.DrawString(str, X, Y-1)
		    g.DrawString(str, X, Y+1)
		    
		  else
		    g.DrawString(str, X-1, Y, Width, True)
		    g.DrawString(str, X+1, Y, Width, True)
		    g.DrawString(str, X, Y-1, Width, True)
		    g.DrawString(str, X, Y+1, Width, True)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawHelpTag(g As Graphics, TipX As Integer, TipY As Integer, Index As Integer, Serie As Integer)
		  //#newinversion 1.0
		  
		  
		  'dim mp as new MethodProfiler(CurrentMethodName + "AAA")
		  
		  Dim Top, Bottom, Left, Right As Integer
		  Top = 4
		  Bottom = 8
		  Left = 1
		  Right = 2
		  
		  
		  If HelpTag2.Buffer is Nil then
		    
		    Dim Borderwidth As Integer = 1
		    Dim Arc As Integer = 5
		    'Dim BorderColor As Color = &c79797D
		    'dim BackgroundType As Integer = BackgroundSolid
		    'Dim BackgroundColor1 As Color = &c121218
		    
		    Dim i, idx as Integer
		    'Dim j, idx As Integer
		    Dim Lines() As String
		    Dim Values() As Double
		    Dim Total As Double
		    Dim str As String
		    Dim NilValues() As Boolean
		    Dim isNil As Boolean
		    
		    //Preparing the text
		    str = Labels(Index)
		    If Axes(0).LabelType = "Date" then
		      Dim d As new date
		      d.SQLDateTime = str
		      str = mParseDate(D, Axes(0).LabelStyle.Format, D.SQLDate)
		    End If
		    Lines.Append str
		    
		    
		    If me.Type mod 100 <> TypeColumnStacked mod 100 then
		      Values.Append me.GetValue(Index, Serie)
		      Lines.Append me.Series(Serie).Title + ": " + str(Values(0)) + Axes(1).LabelStyle.Format
		      
		    else
		      For i = 0 to UBound(me.Series)
		        
		        Values.Append me.GetValue(Index, i, isNil, True)
		        NilValues.Append isNil
		        Total = Total + Values(idx)
		        
		        If isNil then
		          Lines.Append me.Series(i).Title + ": _ " + Axes(1).LabelStyle.Format
		        else
		          Lines.Append me.Series(i).Title + ": " + str(Values(Idx)) + Axes(1).LabelStyle.Format
		        End If
		        
		        idx = idx + 1
		      Next
		      
		      If UBound(Series)>0 then
		        Lines.Append "Total: " + str(Total) + Axes(1).LabelStyle.Format
		      End If
		      
		    End If
		    
		    
		    
		    
		    //Setting Width and Height
		    Dim W As Integer, H As Integer
		    w = 60
		    h = 60
		    g.Bold = True
		    g.TextSize = Legend.TextSize
		    For i = 0 to UBound(Lines)
		      w = max(w, g.StringWidth(Lines(i)))
		    Next
		    h = g.TextHeight*(UBound(Lines)+1)
		    
		    
		    w = w + 20 + 2*Borderwidth
		    h = h + 20 + 2*BorderWidth
		    
		    
		    Dim Buffer As Picture = New Picture(W, H, 32)
		    Dim gr As Graphics = Buffer.Graphics
		    
		    Dim X As Integer
		    Dim Y As Integer
		    
		    
		    //Font and size
		    'gr.TextFont = MyStyle.TextFont
		    'gr.TextSize = MyStyle.TextSize
		    'gr.Bold = MyStyle.TextBold
		    
		    Dim ShadowHeight As Integer
		    'If MyStyle.Shadow then
		    'ShadowHeight = 1
		    'End If
		    
		    Dim Rectangle As Picture
		    
		    Rectangle = New Picture(W, H-ShadowHeight, 32)
		    
		    Dim gg As Graphics
		    
		    
		    
		    //Drawing Border
		    gg = Rectangle.Graphics
		    gg.ForeColor = BorderColor
		    gg.AAG_FillAll
		    
		    gr.DrawPicture(Rectangle, 0, 0)
		    
		    
		    
		    
		    //Drawing interior
		    Rectangle = New Picture(gg.Width-BorderWidth*2, gg.Height-BorderWidth*2, 32)
		    gg = Rectangle.mask.Graphics
		    gg.AAG_FillRoundRectA(0, 0, gg.Width, gg.Height, Arc-1, 1, True)
		    
		    
		    gg = Rectangle.Graphics
		    
		    
		    If UBound(BackgroundColor)>-1 then
		      gg.ForeColor = BackgroundColor(0)
		      gg.AAG_FillAll()
		    End If
		    
		    'If MyStyle.BackgroundType = FillSolid then
		    'gg.ForeColor = MyStyle.BackgroundColor1
		    'gg.FillRect(0, 0, gg.Width, gg.Height)
		    '
		    'elseif MyStyle.BackgroundType = FillGradientHorizontal then
		    'gg.AAG_Gradient(0, 0, gg.Width, gg.Height, MyStyle.BackgroundColor1, MyStyle.BackgroundColor2, False)
		    '
		    'elseif MyStyle.BackgroundType = FillGradientVertical then
		    'gg.AAG_Gradient(0, 0, gg.Width, gg.Height, MyStyle.BackgroundColor1, MyStyle.BackgroundColor2, True)
		    '
		    'elseif MyStyle.BackgroundType = FillTexture then
		    'DrawTexture(gg, MyStyle.BackgroundTexture)
		    '
		    'End If
		    
		    
		    
		    gr.DrawPicture Rectangle, BorderWidth, BorderWidth
		    
		    //Drawing Text
		    
		    
		    gg = gr.Clip(BorderWidth+1, BorderWidth, Rectangle.Width-2, gr.Height-BorderWidth*2)
		    
		    'gg.TextFont = MyStyle.TextFont
		    'gg.TextSize = MyStyle.TextSize
		    'gg.bold = MyStyle.TextBold
		    'gg.Italic = MyStyle.TextItalic
		    'gg.Underline = MyStyle.TextUnderline
		    
		    If gg.StringHeight(Join(Lines, EndOfLine), gg.Width-20) <= gg.TextHeight then
		      X = (gg.Width-gg.StringWidth(str))\2
		      Y = (H-gg.StringHeight(Lines(0), gg.Width))\2 + gg.TextAscent-BorderWidth
		    else
		      X = 10
		      Y = g.TextHeight+gg.TextAscent\2-BorderWidth
		      'Y = (H-gg.StringHeight(str, gg.Width))\2 +gg.TextAscent\2-BorderWidth
		    End If
		    
		    'Y = Round((Height-gg.TextHeight)\2) + gg.TextAscent-MyStyle.BorderWidth
		    
		    //Drawing Label
		    gg.ForeColor = Legend.TextColor
		    gg.Bold = True
		    gg.TextSize = 14
		    gg.DrawString(Lines(0), X, Y)
		    gg.Bold = False
		    gg.TextSize = Legend.TextSize
		    Y = Y + g.TextHeight
		    
		    //Not stacked
		    If me.Type mod 100 <> TypeColumnStacked mod 100 or me.type = TypeAreaStepped then
		      
		      
		      gg.ForeColor = me.Series(Serie).FillColor
		      str = me.Series(Serie).Title + ": "
		      gg.DrawString(str, X, Y)
		      
		      X = X + gg.StringWidth(str)
		      
		      gg.ForeColor = me.Axes(1).ForeColor
		      str = str(Values(0)) + me.Axes(1).LabelStyle.Format
		      gg.DrawString(str, X, Y)
		      
		    Else //Data is Stacked
		      
		      Dim xx As Integer
		      
		      For i = 0 to UBound(Series)
		        
		        gg.ForeColor = me.Series(i).FillColor
		        str = me.Series(i).Title + ": "
		        gg.DrawString(str, X, Y)
		        
		        xx = X + gg.StringWidth(str)
		        
		        gg.ForeColor = me.Axes(1).ForeColor
		        If NilValues(i) then
		          str = " _ "
		        else
		          str = str(Values(i)) + me.Axes(1).LabelStyle.Format
		        End If
		        gg.DrawString(str, xx, Y)
		        
		        Y = Y + g.TextHeight
		      Next
		      
		      If UBound(Series)>0 then
		        gg.DrawString(Lines(UBound(Lines)), X, Y)
		      End If
		      
		    End If
		    
		    
		    'If MyStyle.TextShadow then
		    'gg.ForeColor = MyStyle.TextShadowColor
		    'gg.DrawString text, X, Y+MyStyle.TextShadowPos, gg.Width-20
		    'End If
		    
		    
		    
		    'If MyStyle.TailWidth = 0 then
		    'MyStyle.TailWidth = 11
		    'End If
		    'If MyStyle.TailHeight = 0 then
		    'MyStyle.TailHeight = 8
		    'End If
		    
		    
		    Dim Tail As Picture
		    Dim TailX, TailY, TailPosition As Integer
		    
		    If TipY - H-8 > 0 then
		      TailPosition = Bottom
		      If TipX - W\2 < 0 then
		        TailPosition = TailPosition + Left
		        TailX = 3 + 11\2
		      elseif TipX + W\2 > me.Width then
		        TailPosition = TailPosition + Right
		        TailX = W-3-11\2
		      else
		        TailX = W\2
		      End If
		      
		    elseif TipY + H + 8 < me.Height then
		      TailPosition = Top
		      If TipX - W\2 < 0 then
		        TailPosition = TailPosition + Left
		        TailX = 3 + 11\2
		      elseif TipX + W\2 > me.Width then
		        TailPosition = TailPosition + Right
		        TailX = W-3-11\2
		      else
		        TailX = W\2
		      End If
		      
		    else
		      Index = Index
		    End If
		    
		    Tail = New Picture(11, 8, 32)
		    Dim gt As Graphics = Tail.Graphics
		    If UBound(BackgroundColor)>-1 then
		      gt.ForeColor = BackgroundColor(0)
		      gt.AAG_FillAll
		    End If
		    gt.ForeColor = BorderColor
		    If TailPosition >=Bottom then
		      gt.AAG_DrawLineAFill(0, 0, gt.Width/2, gt.Height-borderWidth, 0.5, True)
		      gt.AAG_DrawLineAFill(gt.Width/2, gt.Height-BorderWidth, gt.Width, 0, 0.5, False)
		    else
		      gt.AAG_DrawLineAFill(0, gt.Height-borderWidth, gt.Width/2, 0, 0.5, True)
		      gt.AAG_DrawLineAFill(gt.Width/2, 0, gt.Width, gt.Height-BorderWidth, 0.5, False)
		    End If
		    Dim temp As Picture = New Picture(gt.Width, gt.Height, 32)
		    gg = temp.mask.graphics
		    gg.ForeColor = &cFFFFFF
		    gg.AAG_FillAll
		    gg.ForeColor = &cD0D0D0
		    gg.AAG_DrawLineA(0, 0, gt.Width/2, gt.Height-borderWidth-1)
		    gg.AAG_DrawLineA(gt.Width/2, gt.Height-BorderWidth-1, gt.Width, 0)
		    gt.DrawPicture(temp, 0, 0)
		    
		    HelpTag2.Buffer = New Picture(w, H+Tail.Height-2, 32)
		    Dim gp As Graphics = HelpTag2.Buffer.Graphics
		    If TailPosition >= Bottom then
		      gp.DrawPicture(Buffer, 0, 0)
		      If TailPosition = Bottom then
		        gp.DrawPicture(Tail, (gp.Width-Tail.Width)\2, H-1)
		      elseif TailPosition = Bottom + Right then
		        gp.DrawPicture(Tail, (gp.Width-Tail.Width)-3, H-1)
		      else
		        gp.DrawPicture(Tail, 3, H-1)
		      End If
		    elseif TailPosition >= Top then
		      gp.DrawPicture(Buffer, 0, gp.Height - Buffer.Height)
		      If TailPosition = Top then
		        gp.DrawPicture(Tail, (gp.Width-Tail.Width)\2, 0)
		      elseif TailPosition = Top + Right then
		        gp.DrawPicture(Tail, gp.Width-Tail.Width-3, 0)
		      else
		        gp.DrawPicture(Tail, 3, 0)
		      End If
		    End If
		    
		    
		    gp = HelpTag2.Buffer.Mask.Graphics
		    gp.ForeColor = &cFFFFFF
		    gp.AAG_FillAll()
		    If TailPosition >=Bottom then
		      gp.AAG_FillRoundRectA(0, 0, W, H, arc, 1, True)
		    else
		      gp.AAG_FillRoundRectA(0, gp.Height-Buffer.Height, W, H, arc, 1, True)
		    End If
		    gt.ForeColor = &cFFFFFF
		    gt.AAG_FillAll
		    gt.ForeColor = &c0
		    
		    If TailPosition >=Bottom then
		      gt.FillRect(0, 0, gt.Width, 2)
		      gt.AAG_DrawLineAFill(0, 2, gt.Width/2, gt.Height+1, 0.5, False)
		      gt.AAG_DrawLineAFill(gt.Width/2, gt.Height+1, gt.Width, 2, 0.5, True)
		    else
		      gt.Fillrect(0, gt.height-2, gt.width, 2)
		      gt.AAG_DrawLineAFill(0, gt.Height-2, gt.Width/2, -1, 0.5, False)
		      gt.AAG_DrawLineAFill(gt.Width/2, -1, gt.Width, gt.Height-2, 0.5, True)
		    End If
		    If TailPosition >= Bottom then
		      If TailPosition = Bottom then
		        gp.DrawPicture(Tail, (gp.Width-Tail.Width)\2, H-1)
		      elseif TailPosition = Bottom + Right then
		        gp.DrawPicture(Tail, (gp.Width-Tail.Width)-3, H-1)
		      else
		        gp.DrawPicture(Tail, 3, H-1)
		      End If
		      
		    elseif TailPosition >= Top then
		      If TailPosition = Top then
		        gp.DrawPicture(Tail, (gp.Width-Tail.Width)\2, 0)
		      elseif TailPosition = Top + Right then
		        gp.DrawPicture(Tail, gp.Width-Tail.Width-3, 0)
		      else
		        gp.DrawPicture(Tail, 3, 0)
		      End If
		    End If
		    
		    HelpTag2.TailPosition = TailPosition
		    HelpTag2.TailX = TailX
		    HelpTag2.TailY = TailY
		    
		    
		  End If
		  
		  If HelpTag2.TailPosition >= Bottom then
		    g.DrawPicture(HelpTag2.Buffer, TipX-HelpTag2.TailX, TipY-HelpTag2.Buffer.Height)
		  elseif HelpTag2.TailPosition >= Top then
		    g.DrawPicture(HelpTag2.Buffer, TipX-HelpTag2.TailX, TipY)
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawLegend(g As Graphics)
		  If Type\100 = TypeTreeMap\100 then
		    Return
		    
		  End If
		  
		  If Legend is Nil then
		    Legend = New ChartLabel()
		  End If
		  
		  Dim i As Integer
		  Dim X As Integer
		  Dim Y As Integer
		  Dim U As Integer = UBound(Series)
		  
		  'Dim p As Picture
		  'Dim gp As Graphics
		  Dim txt As String
		  
		  g.TextSize = Legend.TextSize
		  g.TextFont = Legend.TextFont
		  
		  X = Plot.Left
		  
		  
		  //Drawing Title
		  If Title <> "" then
		    txt = Title
		    g.ForeColor = Legend.TextColor
		    g.Bold = True
		    g.TextSize = 14
		    
		    Y =  g.TextAscent
		    
		    If LegendPosition = Position.Top then
		      g.DrawString(Title, X, Y)
		    Else
		      g.DrawString(Title, X + (Plot.Width-g.StringWidth(Title))\2, Y)
		    End If
		  End If
		  
		  If LegendPosition = Position.None or UBound(Series)=-1 then
		    Return
		  End If
		  
		  Y = Plot.Top - 10
		  
		  g.Bold = False
		  
		  If txt <> "" then
		    X = X + g.StringWidth(txt) + 10
		    
		    g.TextSize = Legend.TextSize
		  End If
		  
		  If LegendPosition = Position.BottomHorizontal and Type < TypePie then
		    LegendPosition = Position.Top
		  End If
		  
		  If LegendPosition = Position.Top then
		    
		    
		    If Legend.HasBackColor then
		      g.ForeColor = Legend.BackColor
		      g.FillRect(X-8, Y-g.TextAscent, 10, g.TextHeight+1)
		    End If
		    
		    For i = 0 to U
		      
		      If Type = TypeScatter and Series(i).Type = TypeLine then
		        Continue
		      End If
		      
		      txt = Series(i).Title
		      
		      //Drawing the Marker
		      DrawLegendMarker(g, X, Y, i, txt)
		      
		      g.ForeColor = Legend.TextColor
		      g.DrawString(txt, X, Y)
		      
		      X = X + g.StringWidth(Series(i).Title) + 10
		      
		    Next
		    
		  Elseif LegendPosition = Position.BottomHorizontal then
		    
		    X = Plot.Left
		    Y = Plot.Height + 5
		    
		    If Legend.HasBackColor then
		      g.ForeColor = Legend.BackColor
		      g.FillRect(X-8, Y-g.TextAscent, 10, g.TextHeight+1)
		    End If
		    
		    For i = 0 to U
		      
		      If Type = TypeScatter and Series(i).Type = TypeLine then
		        Continue
		      End If
		      
		      txt = Series(i).Title
		      
		      //Drawing the Marker
		      DrawLegendMarker(g, X, Y, i, txt)
		      
		      g.ForeColor = Legend.TextColor
		      g.DrawString(txt, X, Y)
		      
		      X = X + g.StringWidth(Series(i).Title) + 10
		    Next
		    
		  Elseif LegendPosition = Position.BottomVertical then
		    
		    X = Plot.Left
		    Y = Plot.Height + 5
		    
		    Dim xx As Integer = X
		    
		    For i = 0 to U
		      If Type = TypeScatter and Series(i).Type = TypeLine then
		        Continue
		      End If
		      
		      txt = Series(i).Title
		      
		      //Drawing the Marker
		      DrawLegendMarker(g, xx, Y, i, txt)
		      
		      g.ForeColor = Legend.TextColor
		      g.DrawString(txt, xx, Y)
		      
		      xx = X
		      Y = Y + g.TextHeight + 2
		    Next
		    
		    
		  elseif LegendPosition = Position.Left or LegendPosition = Position.Right then
		    
		    If LegendPosition = Position.Left then
		      X = 10
		    elseif LegendPosition = Position.Right then
		      X = Plot.Left + Plot.Width + 10
		    End If
		    Y = Plot.Top + 10
		    
		    If Legend.HasBackColor then
		      g.ForeColor = Legend.BackColor
		      g.FillRect(X-8, Y-g.TextAscent, 10, g.TextHeight*U+1)
		    End If
		    
		    Dim XX As Integer
		    
		    For i = 0 to U
		      
		      If Type = TypeScatter and Series(i).Type = TypeLine then
		        Continue
		      End If
		      
		      XX = X
		      
		      txt = Series(i).Title
		      
		      //Drawing the Marker
		      DrawLegendMarker(g, XX, Y, i, txt)
		      
		      g.ForeColor = Legend.TextColor
		      g.DrawString(txt, XX, Y)
		      
		      Y = Y + g.TextHeight
		    Next
		    
		    
		    
		    
		  else
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawLegendMarker(g As Graphics, ByRef X As Integer, Y As Integer, i As Integer, txt As String)
		  //This function is called by DrawLegend to draw the LegendMarker in the correct position.
		  
		  Dim intSquare As Integer = g.TextAscent
		  If intSquare = 0 then
		    intSquare = 16
		  End If
		  
		  Dim xType As Integer
		  If type = TypeCombo then
		    xType = Series(i).Type
		  elseif Type = TypeBullet and i = UBound(Series) then
		    xType = TypeLine
		  else
		    xtype = Type
		  End If
		  
		  If xType \ 100 = TypeLine\100 or xType = TypeArea or xType = TypeAreaStacked then
		    //Legend Box backcolor
		    If Legend.HasBackColor then
		      g.ForeColor = Legend.BackColor
		      g.FillRect(X, Y-g.TextAscent, Series(i).MarkerSize/2 + 3 + g.StringWidth(txt)+10, g.TextHeight+1)
		    End If
		    
		    If Series(i).FillType = ChartSerie.FillSolid then
		      g.ForeColor = Series(i).FillColor
		    else
		      g.ForeColor = Legend.DefaultMarkerColor //&c0
		    End If
		    
		    DrawMarker(g, Series(i), X, Y-g.TextAscent\2, True)
		    
		    If Series(i).MarkerType = ChartSerie.MarkerTexture and Series(i).MarkerPicture <> Nil then
		      X = X + Series(i).MarkerPicture.Width+3
		    elseif Type = TypeBullet then
		      X = X + intSquare + 3
		    else
		      X = X + intSquare + 3
		      'X = X + Series(i).MarkerSize/2 + 3
		    End If
		    
		  else
		    
		    //Legend Box backcolor
		    If Legend.HasBackColor then
		      g.ForeColor = Legend.BackColor
		      g.FillRect(X, Y-g.TextAscent, intSquare + 3 + g.StringWidth(txt)+10, g.TextHeight+1)
		    End If
		    
		    Dim p As Picture
		    #if TargetDesktop and TargetWin32
		      If App.UseGDIPlus Then
		        p = New Picture(intSquare, intSquare)
		      else
		        p = New Picture(intSquare, intSquare, 32)
		      End If
		    #Else
		      p = New Picture(intSquare, intSquare)
		    #endif
		    
		    Dim gp As Graphics = p.Graphics
		    if Series(i).FillType = ChartSerie.FillPicture then
		      
		      GetFillPicture(p, Series(i), -1, "Legend", 0, 0)
		      
		    elseIf Series(i).FillType = ChartSerie.FillSolid then
		      gp.ForeColor = Series(i).FillColor
		      gp.AAG_FillAll()
		      
		    else
		      gp.ForeColor = Legend.DefaultMarkerColor //&c0
		      gp.AAG_FillAll()
		    End If
		    
		    #If TargetDesktop and TargetWin32
		      If App.UseGDIPlus then
		        g.Transparency = Series(i).Transparency/100.0
		      Else
		        gp = p.Mask.Graphics
		        gp.Forecolor = TransparencyPercentage(Series(i).Transparency)
		        gp.AAG_FillAll()
		      End If
		    #Else
		      g.Transparency = Series(i).Transparency/100.0
		    #endif
		    'If TargetWin32 and App.UseGDIPlus=False and Series(i).Transparency <> 0 then
		    'gp = p.Mask.Graphics
		    'gp.Forecolor = TransparencyPercentage(Series(i).Transparency)
		    'gp.AAG_FillAll()
		    '
		    'Elseif Series(i).Transparency <> 0 then
		    'g.Transparency = Series(i).Transparency/100.0
		    'End If
		    
		    g.DrawPicture(p, X, Y-intSquare)
		    
		    #if TargetDesktop and TargetWin32
		      If app.UseGDIPlus then
		        g.Transparency = 0.0
		      End If
		    #Else
		      g.Transparency = 0.0
		    #endif
		    
		    
		    X = X + intSquare + 3
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawMark(g As Graphics)
		  //Draws the Mark lines
		  
		  If Type >= TypePie then
		    Return
		  End If
		  
		  
		  Dim i As Integer
		  Dim u As Integer
		  Dim X, Y As Integer
		  Dim UnitHeight As Double
		  Dim lbl As String
		  
		  'Dim SwapAxis As Boolean = (Type \ 100 = TypeBar \ 100)
		  
		  u = UBound(Marks)
		  
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  
		  For i = 0 to u
		    
		    g.ForeColor = Marks(i).FillColor
		    
		    'X = Plot.Left
		    If Axes(1).LogarithmicScale then
		      Y = BaseDrawY-Round((Marks(i).Value-Axes(1).MinimumScale)*UnitHeight)
		    else
		      Y = BaseDrawY-Round((Marks(i).Value-Axes(1).MinimumScale)*UnitHeight)
		      //Remove plot.top
		    End If
		    
		    If Marks(i).Width = 1 then
		      
		      g.DrawLine(X, Y, X+Plot.Width, Y)
		      
		    else
		      
		      Y = Y-(Marks(i).Width-1)\2
		      
		      g.AAG_DrawLineA(X, Y, X+Plot.Width, Y, Marks(i).Width-1)
		      'g.FillRect(X, Y, Plot.Width, Marks(i).Width)
		      
		    End If
		    
		    If Marks(i).Label <> "" then
		      lbl = Marks(i).Label
		      
		      //Correction by Jeremy Cowgar
		      g.ForeColor = Marks(i).LabelColor
		      
		      If Y + g.TextHeight < Plot.Top + Plot.Height then
		        g.DrawString(lbl, X+Plot.Width-5-g.StringWidth(lbl), Y+g.TextAscent+1)
		      else
		        g.DrawString(lbl, X+Plot.Width-5-g.StringWidth(lbl), Y-g.TextHeight+g.TextAscent)
		      End If
		    End If
		  Next
		  
		  Dim oldPrecision As Integer = Precision
		  Precision = 1
		  
		  u = UBound(MarkSeries)
		  For i = 0 to u
		    If not MarkSeries(i).MarkLine then
		      Continue for i
		    End If
		    
		    PlotLine(g, -10-i)
		  Next
		  
		  Precision = oldPrecision
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawMarker(g As Graphics, Serie As ChartSerie, X As Integer, Y As Integer, Legend As Boolean = False, Force As Boolean = False, FillColor As Color = &c000001)
		  //This function draws the markers for LineCharts and AreaCharts and RadarCharts
		  
		  If Serie.MarkerType = Serie.MarkerNone and not Legend and Force = False then
		    Return
		  End If
		  
		  If not Legend and not Force and not Type=TypeScatter then
		    If Axes(0).UnitWidth/Axes(0).MajorUnit < Serie.MarkerSize * 2 then
		      Return
		    End If
		  End If
		  
		  Dim MarkerRadius As Single = Serie.MarkerSize / 2
		  Dim intSquare As Integer = g.TextAscent
		  Dim PenWidth, PenHeight As Integer
		  
		  If Serie.FillType <> Serie.FillPicture and FillColor = &c000001 then
		    g.ForeColor = Serie.FillColor
		  elseif Serie.FillType <> Serie.FillPicture then
		    g.ForeColor = FillColor
		  End If
		  
		  //Transparency for Scatter Charts
		  #If TargetDesktop
		    If Type = TypeScatter and Serie.Transparency <> 0 and (TargetMacOS or TargetLinux) then 'or App.UseGDIPlus
		      g.ForeColor = AlphaColor(g.ForeColor, Serie.Transparency)
		    End If
		  #Elseif TargetWeb
		    //A corriger web peut-etre
		    If Type = TypeScatter and Serie.Transparency <> 0 then
		      g.ForeColor = AlphaColor(g.ForeColor, Serie.Transparency)
		    End If
		  #endif
		  
		  If Legend then //Legend
		    
		    'Dim intSquare As Integer
		    If Type = TypeBullet then
		      g.PenWidth = 2
		      g.PenHeight = 2
		      g.DrawLine(X, Y+(Serie.MarkerSize-g.PenHeight)\2-1, X + intsquare-1, Y+(Serie.MarkerSize-g.PenHeight)\2-1)
		    else
		      g.PenWidth = Serie.LineWeight
		      g.PenHeight = Serie.LineWeight
		      g.DrawLine(X, Y+(Serie.MarkerSize-g.PenHeight)\2-1, X+intsquare, Y+(Serie.MarkerSize-g.PenHeight)\2-1)
		    End If
		    
		    
		    
		  elseIf Serie.MarkerType = Serie.MarkerOval or Force then //Oval
		    
		    #If TargetDesktop
		      If TargetMacOS then 'or App.UseGDIPlus  then
		        PenWidth = g.PenWidth
		        PenHeight = g.PenHeight
		        g.FillOval(Round(X-MarkerRadius+PenWidth/2), Round(Y-MarkerRadius+PenWidth/2), Serie.MarkerSize, Serie.MarkerSize)
		        
		      else
		        g.AAG_FillOvalA(X, Y, MarkerRadius*2, MarkerRadius*2)
		      end if
		    #elseif TargetWeb
		      //A corriger web peutetre
		      PenWidth = g.PenWidth
		      PenHeight = g.PenHeight
		      g.FillOval(Round(X-MarkerRadius+PenWidth/2), Round(Y-MarkerRadius+PenWidth/2), Serie.MarkerSize, Serie.MarkerSize)
		      
		    #endif
		    
		  elseif (Serie.MarkerType = Serie.MarkerSquare) then //Square or (Legend And Serie.MarkerType = Serie.MarkerNone)
		    
		    g.FillRect(Round(X-MarkerRadius), Round(Y-MarkerRadius), MarkerRadius*2, MarkerRadius*2)
		    
		    
		  elseif Serie.MarkerType = Serie.MarkerTexture and Serie.MarkerPicture <> Nil then //Texture
		    
		    If Legend then
		      g.DrawPicture(Serie.MarkerPicture, X, Round(Y-Serie.MarkerPicture.Height/2))
		    else
		      g.DrawPicture(Serie.MarkerPicture, Round(X-Serie.MarkerPicture.Width/2), Round(Y-Serie.MarkerPicture.Height/2))
		    End If
		    
		    
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawStringCenter(g As Graphics, text As String, X As Integer, Y As Integer)
		  text = trim(text)
		  
		  If text.InStr(EndOfLine)=0 then
		    g.DrawString(text, X-g.StringWidth(text)\2, Y)
		    
		  else
		    Dim txt() As String = text.Split(EndOfLine)
		    
		    For i as Integer = 0 to UBound(txt)
		      
		      g.DrawString(txt(i), X-g.StringWidth(txt(i))\2, Y)
		      
		      Y = y + g.TextHeight
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportAsPicture() As Picture
		  //Exports the Current View as a Picture
		  Dim p As Picture
		  
		  If Buffer is nil or not TargetWin32 then
		    
		    #if TargetWeb
		      p = New Picture(Width, Height)
		    #else
		      p = New Picture(Width, Height, 32)
		    #endif
		    Dim gg As Graphics = p.Graphics
		    Dim gp As Graphics
		    
		    LastSize = Width * Height
		    
		    SetMetrics
		    If HelpTagVisible then
		      HelpTagVisible = False
		    End If
		    
		    DrawBackground(gg)
		    
		    me.Plot.Draw(gg)
		    
		    DrawAxis(gg)
		    DrawLegend(gg)
		    
		    
		    If Type >=TypePie then
		      gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		    else
		      gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width+5, Plot.Height)
		    End If
		    
		    If Type = TypeCombo then
		      
		      PlotCombo(gp)
		      
		    elseIf Type\100 = TypeColumn\100 then
		      
		      PlotColumn(gp)
		      
		    Elseif Type = TypeLineSmooth or Type = TypeLineStackedSmooth then
		      
		      PlotSpline(gp)
		      
		    Elseif Type\100 = TypeLine\100 then
		      
		      PlotLine(gp)
		      
		    Elseif Type\100 = TypeArea\100 then
		      
		      PlotArea(gp)
		      
		    Elseif Type\100 = TypeBar\100 then
		      
		      PlotBar(gp)
		      
		    Elseif Type\100 = TypeScatter\100 then
		      
		      PlotScatter(gp)
		      
		    Elseif Type\100 = TypeTrendTimeLine\100 then
		      
		      PlotTrend(gg)
		      
		    Elseif Type\100 = TypePie\100 then
		      
		      PlotPie(gp)
		      
		    Elseif Type\100 = TypeRadar\100 then
		      
		      PlotRadar(gp)
		      
		    Elseif Type\100 = TypeTreeMap\100 then
		      
		      PlotTreeMap(gp)
		      
		    End If
		    
		    Dim H As ChartDataPoint
		    Dim Hindex As Integer
		    For i As Integer = 0 to UBound(HighlightPoints)
		      H = HighlightPoints(i)
		      Hindex = Round(H.Index/Precision)
		      If H.Serie.mPts.Ubound >= Hindex and H.Serie.mPts(Hindex) <> Nil then
		        DrawMarker(gp, H.Serie, H.Serie.mPts(Hindex).X, H.Serie.mPts(Hindex).Y, False, True, H.FillColor)
		      End If
		    Next
		    
		    DrawMark(gp)
		    
		    
		    #if TargetDesktop
		      If Border then
		        gg.PenWidth = 1
		        gg.PenHeight = 1
		        gg.ForeColor = BorderColor
		        gg.DrawRect(0, 0, gg.Width, gg.Height)
		      End If
		    #endif
		    
		  Else
		    
		    p = Picture.FromData(Buffer.GetData(Buffer.FormatPNG))
		    
		  End If
		  
		  Return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = TargetWeb
		Function ExportAsPicture(Width As Integer, Height As Integer) As Picture
		  //Exports the Current View as a Picture with the passed Width, Height.
		  
		  self.Width = Width
		  self.Height = Height
		  
		  Return ExportAsPicture()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExportGraph(p As Picture, Type As Integer = -1)
		  //#newinversion 1.1.0
		  //Exports only the graph to the passed picture.
		  //If Type is -1 then it keeps the same Type as the original graph.
		  
		  #if TargetDesktop and TargetWin32
		    Dim lastGDI As Boolean = App.UseGDIPlus
		    App.UseGDIPlus = True
		  #endif
		  
		  Dim unfreeze As Boolean
		  If me.Freeze = False then
		    me.Freeze = True
		    unfreeze = True
		  End If
		  
		  Plot.Width = p.Width
		  Plot.Height = p.Height
		  
		  BaseDrawY = Plot.Height
		  
		  If Type = -1 then
		    Type = self.Type
		  End If
		  
		  Dim oldType As Integer
		  oldType = self.Type
		  
		  self.Type = Type
		  
		  Recalc(True)
		  
		  Dim gp As Graphics = p.Graphics
		  
		  If Type = TypeCombo then
		    
		    PlotCombo(gp)
		    
		  elseIf Type\100 = TypeColumn\100 then
		    
		    PlotColumn(gp)
		    
		  Elseif Type = TypeLineSmooth or Type = TypeLineStackedSmooth then
		    
		    PlotSpline(gp)
		    
		  Elseif Type\100 = TypeLine\100 then
		    
		    PlotLine(gp)
		    
		  Elseif Type\100 = TypeArea\100 then
		    
		    PlotArea(gp)
		    
		  Elseif Type\100 = TypeBar\100 then
		    
		    PlotBar(gp)
		    
		  Elseif Type\100 = TypeScatter\100 then
		    
		    PlotScatter(gp)
		    
		  Elseif Type\100 = TypeTrendTimeLine\100 then
		    
		    PlotTrend(gp)
		    
		  Elseif Type\100 = TypePie\100 then
		    
		    PlotPie(gp)
		    
		  End If
		  
		  self.Type = oldType
		  
		  If unfreeze then
		    SetMetrics()
		    me.Freeze = False
		    Redisplay()
		  End If
		  
		  #if TargetDesktop and TargetWin32
		    
		    App.UseGDIPlus = lastGDI
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub FrameWorkPropertyChange_()
		  #if TargetWeb
		    //Only send changes to the browser if the Shown event has fired. Otherwise, they should be rendered in the InitialHTML event.
		    If ControlAvailableInBrowser Then
		      Select Case Name
		      Case "Enabled"
		        Dim js As String
		        If value Then
		          js = "Xojo.get('" + Me.ControlID + "').style.opacity = 1; Xojo.get('" + Me.ControlID + "').style.cursor = 'auto';"
		        Else
		          js = "Xojo.get('" + Me.ControlID + "').style.opacity = 0.5; Xojo.get('" + Me.ControlID + "').style.cursor = 'default';"
		        End If
		        ExecuteJavaScript(js)
		        
		        
		      End Select
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetLocaleInfo(type as Integer, mb as MemoryBlock, ByRef retVal as String) As Integer
		  #if TargetWin32
		    
		    Dim LCID As Integer = &H400
		    
		    Soft Declare Function GetLocaleInfoA Lib "kernel32" (Locale As integer, LCType As integer, lpLCData As ptr, cchData As integer) As Integer
		    Soft Declare Function GetLocaleInfoW Lib "kernel32" (Locale As integer, LCType As integer, lpLCData As ptr, cchData As integer) As Integer
		    
		    dim returnValue as Integer
		    dim size as Integer
		    
		    if mb <> nil then size = mb.Size
		    
		    if System.IsFunctionAvailable( "GetLocaleInfoW", "Kernel32" ) then
		      if mb <> nil then
		        returnValue = GetLocaleInfoW( LCID, type, mb, size ) * 2
		        retVal = ReplaceAll( DefineEncoding( mb.StringValue( 0, returnValue ), Encodings.UTF16 ), Chr( 0 ), "" )
		      else
		        returnValue = GetLocaleInfoW( LCID, type, nil, size ) * 2
		      end if
		    else
		      if mb <> nil then
		        returnValue = GetLocaleInfoA( LCID, type, mb, size ) * 2
		        retVal = ReplaceAll( DefineEncoding( mb.StringValue( 0, returnValue ), Encodings.ASCII ), Chr( 0 ), "" )
		      else
		        returnValue = GetLocaleInfoA( LCID, type, nil, size ) * 2
		      end if
		    end if
		    
		    return returnValue
		    
		  #else
		    #Pragma Unused type
		    #Pragma Unused mb
		    #Pragma Unused retVal
		    
		  #endif
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetValue(Index As Integer, Serie As Integer, NoStack As Boolean = False) As Double
		  Dim b As Boolean
		  Return GetValue(Index, Serie, b, NoStack)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetValue(Index As Integer, Serie As Integer, ByRef NilValue As Boolean, NoStack As Boolean = False, Trend As Boolean = False) As Double
		  Dim Idx As Integer = Index
		  Dim Value As Double
		  Dim LogScale As Boolean
		  Dim i As Integer
		  
		  Dim cSerie As ChartSerie
		  If Serie>-1 then
		    cSerie = Series(Serie)
		  elseif Serie<-9 then
		    cSerie = MarkSeries(-Serie-10)
		  End If
		  
		  If cSerie.SecondaryAxis then
		    If Axes(2).LogarithmicScale then
		      LogScale = True
		    End If
		  elseif Axes(1).LogarithmicScale then
		    LogScale = True
		  Elseif Trend then
		    LogScale = True
		  End If
		  
		  NilValue = False
		  
		  If Type = TypeAreaStacked or Type = TypeAreaStepped or Type = TypeLineStacked or Type=TypeLineStackedSmooth then
		    
		    If Continuous then
		      Idx = Axes(0).LabelIndex(Labels(Index))
		      If Idx > -1 then
		        Value = cSerie.Values(Idx)
		      elseif Axes(0).LabelType <> "" then
		        Idx = Index
		        Value = 0.0
		        Return Value
		      else
		        Idx = Index
		        Value = cSerie.Values(Idx)
		      End If
		    else
		      Value = cSerie.Values(Idx)
		    End If
		    
		    If cSerie.Values(Idx).isNull then
		      NilValue = True
		    End If
		    
		    If NoStack then
		      'If LogScale then
		      'Return Log(Value)/Log(10)
		      'else
		      Return Value
		      'End If
		    End If
		    
		    If Value >= 0 then
		      
		      For i = Serie-1 DownTo 0
		        If Series(i).Values(Idx)>0 then
		          Value = Value + Series(i).Values(Idx)
		        End If
		      Next
		      
		    else
		      
		      For i = Serie-1 DownTo 0
		        If Series(i).Values(Idx)<0 then
		          Value = Value + Series(i).Values(Idx)
		        End If
		      Next
		    End If
		    
		    
		  else
		    
		    If Continuous and Type\100 <> TypeScatter\100 then
		      Idx = Axes(0).LabelIndex(Labels(Index))
		      If Idx > -1 then
		        Value = cSerie.Values(Idx)
		        If cSerie.Values(Idx).isNull then
		          NilValue = True
		        End If
		      elseif Axes(0).LabelType <> "" then
		        Value = 0
		      else
		        Idx = Index
		        Value = cSerie.Values(Idx)
		        If cSerie.Values(Idx).isNull then
		          NilValue = True
		        End If
		      End If
		    else
		      If cSerie.Values.Ubound >= Idx Then
		        Value = cSerie.Values(Idx)
		        If cSerie.Values(Idx).isNull then
		          NilValue = True
		        End If
		      Else
		        NilValue = True
		      End If
		    End If
		    
		    If NoStack then
		      'If LogScale then
		      'Return Log(Value)/Log(10)
		      'else
		      Return Value
		      'End If
		    End If
		    
		    
		  End If
		  
		  If AnimationHorizontal then
		    If LogScale then
		      Return Log(Value)/Log(10)
		    else
		      Return Value
		    End If
		  End If
		  
		  If AnimationInProgress and Type<TypePie then
		    Dim animValue As Double
		    If AnimationType = AnimateLinear then
		      animValue = AnimationPercent/100.0
		    else
		      animValue = ChartAnimate.getEaseValue(AnimationType, AnimationPercent, 0, 100.0, 100.0) / 100.0
		    End If
		    
		    If UBound(oldSeries)>= Serie and oldSeries(Serie).Values.Ubound>=Idx and Idx>-1 then
		      Value = Value * animValue + oldSeries(Serie).Values(Idx).DoubleValue * (1.0-animValue)
		    else
		      
		      Value = Value * animValue
		      
		    End If
		  End If
		  
		  If LogScale then
		    Return Log(Value)/Log(10)
		  else
		    Return Value
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetX(Index As Integer, Serie As Integer, ByRef NilValue As Boolean) As Double
		  //#newinversion 1.3
		  //Gets the X value for Scatter charts
		  
		  Dim Idx As Integer = Index
		  Dim Value As Double
		  Dim LogScale As Boolean
		  'Dim i As Integer
		  
		  Dim cSerie As ChartSerie
		  If Serie>-1 then
		    cSerie = Series(Serie)
		  elseif Serie<-9 then
		    cSerie = MarkSeries(-Serie-10)
		  End If
		  
		  
		  if Axes(0).LogarithmicScale then
		    LogScale = True
		  End If
		  
		  NilValue = False
		  
		  If cSerie.X is Nil or cSerie.X.Ubound < Idx then
		    NilValue = True
		    Return 0
		    
		  ElseIf cSerie.X(Idx).isNull then
		    NilValue = True
		    
		  Else
		    
		    Value = Round((cSerie.X(Idx)-Axes(0).MinimumScale) * Axes(0).UnitWidth)
		    
		  End If
		  
		  
		  
		  If LogScale then
		    Return Log(Value)/Log(10)
		  else
		    Return Value
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = TargetHasGUI
		Protected Sub HelptagAction(t As Timer)
		  
		  
		  If HelpTag2.Visible or HelpTagVisible=False then
		    HelpTag2.Visible = False
		    HelpTagVisible = False
		    t.Enabled = False
		    t.Period = 500
		    
		    Refresh(False)
		    
		  else
		    
		    HelpTag2.Buffer = Nil
		    HelpTag2.Visible = True
		    HelpTagVisible = True
		    Refresh(False)
		    t.Period = 5000
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HighlightMaxValue(FillColor As Color = &c0, SerieIndex As Integer = -1)
		  //#newinversion 1.1
		  //This function will set a marker on the maximal value of the selected SerieIndex.<br/>
		  //If SerieIndex = -1 all ChartSeries will have a marker.
		  
		  Dim cdp As ChartDataPoint
		  Dim i As Integer
		  
		  If SerieIndex = -1 then
		    
		    For i = 0 to Series.Ubound
		      
		      //Calculating the Values
		      Series(i).Calc()
		      
		      cdp = New ChartDataPoint(Series(i), Series(i).maxValueIndex, "", Series(i).maxValue)
		      cdp.FillColor = FillColor
		      HighlightPoints.Append cdp
		      
		    Next
		    
		  else
		    
		    i = SerieIndex
		    
		    //Calculating the Values
		    Series(i).Calc()
		    
		    cdp = New ChartDataPoint(Series(i), Series(i).maxValueIndex, "", Series(i).maxValue)
		    cdp.FillColor = FillColor
		    HighlightPoints.Append cdp
		    
		  End If
		  
		  Redisplay()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HighlightMinValue(FillColor As Color = &c0, SerieIndex As Integer = -1)
		  //#newinversion 1.1
		  //This function will set a marker on the minimal value of the selected SerieIndex.<br/>
		  //If SerieIndex = -1 all ChartSeries will have a marker.
		  
		  Dim cdp As ChartDataPoint
		  Dim i As Integer
		  
		  If SerieIndex = -1 then
		    
		    For i = 0 to Series.Ubound
		      
		      //Calculating the Values
		      Series(i).Calc()
		      
		      cdp = New ChartDataPoint(Series(i), Series(i).minValueIndex, "", Series(i).minValue)
		      cdp.FillColor = FillColor
		      HighlightPoints.Append cdp
		      
		    Next
		    
		  else
		    
		    i = SerieIndex
		    
		    //Calculating the Values
		    Series(i).Calc()
		    
		    cdp = New ChartDataPoint(Series(i), Series(i).minValueIndex, "", Series(i).minValue)
		    cdp.FillColor = FillColor
		    HighlightPoints.Append cdp
		    
		  End If
		  
		  Redisplay()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init(Labels As Boolean = False, Marks As Boolean = False, DataLabel As Boolean = False)
		  //Initialises the ChartView but does not reinitialize the ChartSeries.
		  
		  Plot = New ChartPlot
		  
		  Redim Axes(-1)
		  
		  Redim HighlightPoints(-1)
		  
		  Axes.Append New ChartAxis
		  Axes.Append New ChartAxis
		  
		  'ReDim Series(-1)
		  If Marks then
		    DeleteAllMarkLines()
		  End If
		  If Labels then
		    Redim self.Labels(-1)
		    
		  End If
		  
		  If DataLabel then
		    self.DataLabel = Nil
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub InitSeries(Idx As Integer)
		  Dim i As Integer
		  
		  If Animate then
		    Redim oldSeries(-1)
		    
		    If UBound(Series)>-1 then
		      For i = 0 to UBound(Series)
		        oldSeries.Append Series(i).Clone
		      Next
		    End If
		  End If
		  
		  Redim HighlightPoints(-1)
		  
		  Redim Series(Idx)
		  Dim UColors As Integer = UBound(DefaultColors)
		  
		  
		  for i = 0 to Idx //, UBound(DefaultColors))
		    If Series(i) is Nil then
		      Series(i) = New ChartSerie
		      If UColors = -1 then
		        Series(i).FillColor = &c0
		      ElseIf UColors = 0 then
		        Series(i).FillColor = DefaultColors(0)
		      ElseIf i > UColors then
		        Series(i).FillColor = DefaultColors(i mod UColors)
		      Else
		        Series(i).FillColor = DefaultColors(i)
		      End If
		    else
		      Series(i).Init
		    End If
		    
		    
		    
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadFromCSV(Data As String, Init As Boolean = False, Separator As String = ",", ForceFirstColumnAsLabels As Boolean = True, OnlyData As Boolean = False)
		  //Loads the chart from a CSV file.
		  //
		  //If Init is True, the Init function will be called before loading the Data.
		  //The separator can be any character. If ForceFirstColumnAsLabels is True, the First column will be treated as the X-Axis data labels.
		  //If OnlyData is True, it enables only sending values separated by EndOfLine in a single Column.
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  If Trim(Data)="" then
		    LastError = "Empty CSV Data"
		    Return
		  End If
		  
		  If Data.InStr(Separator)=0 and not OnlyData then
		    LastError = "Not valid CSV Data" + EndOfLine + "The specified Separator was not found in the Data."
		    Return
		  End If
		  
		  LastError = ""
		  
		  
		  
		  Dim Lines() As String = ReplaceLineEndings(Data, EndOfLine).Split(EndOfLine)
		  Dim entry As String
		  Dim ULines As Integer = UBound(Lines)
		  
		  Dim Fields As Integer = Lines(0).CountFields(Separator)
		  
		  If Data.CountFields(Separator) < UBound(Lines) and not OnlyData then
		    LastError = "Not valid CSV Data" + EndOfLine + "Too many lines for too few separators."
		    Return
		  End If
		  
		  Dim Type As String
		  Dim HasTitle As Boolean
		  Dim i, j As Integer
		  
		  If Init then
		    self.Init()
		  else
		    For i = 0 to UBound(Axes)
		      Axes(i).Init(True)
		    Next
		  End If
		  
		  
		  If UBound(Lines)>0 then
		    
		    entry = Lines(1).NthField(Separator, 1)
		    
		    If IsNumeric(entry) = False then
		      If mTestDate(entry) <> Nil then
		        Type="Date"
		      else
		        Type = "String"
		      End If
		    elseif ForceFirstColumnAsLabels then
		      If entry.InStr(".")>0 then
		        Type="Double"
		      else
		        Type="Integer"
		      End If
		    End If
		  End If
		  
		  If IsNumeric(Lines(0).NthField(Separator, Fields)) then
		    HasTitle = False
		    'HasTitle = True
		  else
		    HasTitle = True
		  End If
		  
		  
		  If Type<>"" then
		    Redim Axes(1)
		    InitSeries(Fields-2)
		  else
		    InitSeries(Fields-1)
		  End If
		  
		  If me.Type <> TypeCombo then
		    For i = 0 to UBound(Series)
		      Series(i).Type = me.Type
		    Next
		  End If
		  
		  //Series Name
		  If HasTitle then
		    Dim tmp As String
		    If Type <> "" then
		      Axes(0).Title = Lines(0).NthField(Separator, 1)
		      For i = 2 to Fields
		        tmp = Trim(Lines(0).NthField(Separator, i))
		        If tmp.Left(1) = "'" then
		          tmp = tmp.Replace("'", "")
		        End If
		        Series(i-2).Title = tmp
		      Next
		    else
		      For i = 1 to Fields
		        tmp = Trim(Lines(0).NthField(Separator, i))
		        If tmp.Left(1) = "'" then
		          tmp = tmp.Replace("'", "")
		        End If
		        Series(i-1).Title = tmp
		      Next
		    End If
		  End If
		  
		  'Dim D As new Date
		  Dim cAxe As ChartAxis = Axes(0)
		  Dim trimEntry As String
		  Dim startJ As Integer
		  
		  If OnlyData then
		    Startj = 0
		  else
		    Startj = 1
		  End If
		  
		  //Reading Data
		  For j = startj to ULines
		    entry = Lines(j)
		    
		    If Trim(entry) = "" then
		      Continue for j
		    End If
		    
		    For i = 1 to Fields
		      
		      trimEntry = Trim(entry.Nthfield(Separator, i))
		      
		      If i = 1 and Type<> "" then
		        If Type = "String" then
		          cAxe.Label.Append trimEntry
		        elseif Type = "Date" then
		          If Init then
		            cAxe.LabelStyle.Format = "SQLDate"
		          End If
		          cAxe.Label.Append mTestDate(trimEntry) 'entry.Nthfield(Separator, i)
		          
		        elseif Type = "Integer" or Type="Double" then
		          cAxe.Label.Append val(trimEntry)
		        End If
		        
		      else //Type = "" or i>1
		        
		        If trimEntry = "" then
		          If Type <> "" then
		            Series(i-2).Values.append Nil
		          else
		            Series(i-1).Values.append Nil
		          End If
		          
		        else //Value not empty
		          
		          If Type <> "" then
		            Series(i-2).Values.Append val(trimEntry)
		          else
		            Series(i-1).Values.Append val(trimEntry)
		          End If
		        End If
		        
		      End If
		    Next
		    
		  Next
		  
		  If not Freeze then
		    #If TargetDesktop
		      If Animate then
		        StartAnimation(False, AnimationType)
		      else
		        me.Redisplay()
		      End If
		    #Elseif TargetWeb
		      me.Redisplay()
		    #endif
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadFromDB(RS As RecordSet, Init As Boolean = False)
		  //Loads the Chart from a RecordSet
		  //
		  //If Init is True, the Init function will be called before loading the Data.
		  
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  If rs.RecordCount < 0 then Return
		  
		  Dim Fields As Integer = RS.FieldCount
		  
		  Dim Type As String
		  Dim i As Integer
		  
		  If Init then
		    self.Init()
		  else
		    For i = 0 to UBound(Axes)
		      Axes(i).Init(True)
		    Next
		  End If
		  
		  
		  
		  Select Case RS.ColumnType(0)
		  Case 4, 5, 15, 18 //String
		    Type = "String"
		    
		  Case 8, 9, 10 //Date
		    Type = "Date"
		  End Select
		  
		  If Type <> "" then
		    Redim Axes(1)
		    InitSeries(Fields-2)
		  else
		    InitSeries(Fields-1)
		  End If
		  
		  If me.Type <> TypeCombo then
		    For i = 0 to UBound(Series)
		      Series(i).Type = me.Type
		    Next
		  End If
		  
		  //Series Name
		  If Type <> "" then
		    Axes(0).Title = RS.IdxField(1).Name
		    For i = 2 to RS.FieldCount
		      Series(i-2).Title = RS.IdxField(i).Name
		    Next
		  else
		    For i = 1 to RS.FieldCount
		      Series(i-1).Title = RS.IdxField(i).Name
		    Next
		  End If
		  
		  
		  //Reading Data
		  While not RS.EOF
		    
		    For i = 1 to RS.FieldCount
		      
		      If i = 1 and Type <> "" then
		        If Type = "String" then
		          Axes(0).Label.Append RS.IdxField(i).StringValue
		        elseif Type = "Date" then
		          Axes(0).Label.Append RS.IdxField(i).DateValue
		        End If
		        
		        
		      else
		        
		        If Type <> "" then
		          If RS.IdxField(i).Value is Nil then
		            Series(i-2).Values.Append Nil
		          Else
		            Series(i-2).Values.Append RS.IdxField(i).DoubleValue
		          End If
		        else
		          If RS.IdxField(i).Value is Nil then
		            Series(i-1).Values.Append Nil
		          Else
		            Series(i-1).Values.Append RS.IdxField(i).DoubleValue
		          End If
		        End If
		        
		      End If
		    Next
		    
		    RS.MoveNext
		  Wend
		  
		  me.Redisplay()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadFromJSON(Data As String, Init As Boolean = False)
		  #Pragma Unused init
		  
		  #if RBVersion > 2013
		    Dim js As new JSONItem
		    
		    js.Load(Data)
		    
		    If js.HasName("title") then
		      Title = js.Value("title")
		    End If
		    
		    Dim jsChild, jsChildren, jsChildren2, jsData As JSONItem
		    Dim i, j As Integer
		    
		    Dim cs As ChartSerie
		    
		    jsChildren = js.Lookup("children", Nil)
		    If jsChildren is Nil then
		      System.DebugLog("The json item doesn't contain any children node")
		      Return
		    End If
		    
		    InitSeries(jsChildren.Count-1)
		    
		    For i = 0 to jsChildren.Count-1
		      jsChild = jsChildren.Child(i)
		      
		      cs = Series(i)
		      
		      //Title of the ChartSerie
		      If jsChild.HasName("title") then
		        cs.Title = jsChild.Value("title")
		      End If
		      
		      
		      //Color
		      If jsChild.HasName("color") then
		        cs.FillColor = &cFF0000
		      End If
		      
		      If jsChild.HasName("children") then
		        jsChildren2 = jsChild.Child("children")
		        For j = 0 to jsChildren2.Count-1
		          
		          jsData = jsChildren2.Child(j)
		          
		          If jsData.HasName("label") then
		            cs.Labels.Append jsData.Value("label")
		          Elseif jsData.HasName("name") then
		            cs.Labels.Append jsData.Value("name")
		          End If
		          
		          cs.Values.Append jsData.Lookup("value", Nil)
		        Next
		      End If
		      
		      
		    Next
		    
		  #else
		    #if DebugBuild
		      MsgBox("LoadFromJSON function isn't available in RealStudio")
		    #endif
		    
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = TargetHasGUI
		Sub LoadFromListbox(List As Listbox, Init As Boolean = False, ForceFirstColumnAsLabels As Boolean = True)
		  //Loads the chart directly from a Listbox.
		  //
		  //If Init is True, the Init function will be called before loading the Data.
		  //If ForceFirstColumnAsLabels is True, the First column will be treated as the X-Axis data labels.
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  If List.ColumnCount = 0 then
		    LastError = "Empty Listbox"
		    Return
		  End If
		  If List.ListCount = 0 then
		    LastError = "Empty Listbox"
		    Return
		  End If
		  
		  
		  LastError = ""
		  Dim LastData As String = me.ToCSV_Internal()
		  
		  Dim entry As String
		  Dim Fields As Integer = List.ColumnCount-1
		  
		  Dim Type As String
		  Dim HasTitle As Boolean
		  Dim i, j As Integer
		  
		  #if DebugBuild
		    'Dim tmp As String
		  #endif
		  
		  If Init then
		    self.Init()
		  else
		    For i = 0 to UBound(Axes)
		      Axes(i).Init(True)
		    Next
		  End If
		  
		  
		  entry = List.Cell(0, 0)
		  
		  If IsNumeric(entry) = False then
		    If mTestDate(entry) <> Nil then
		      Type="Date"
		    else
		      Type = "String"
		    End If
		  elseif ForceFirstColumnAsLabels then
		    If entry.InStr(".")>0 then
		      Type="Double"
		    else
		      Type="Integer"
		    End If
		  End If
		  
		  If List.HasHeading then
		    'If IsNumeric(Lines(0).NthField(Separator, Fields)) then
		    HasTitle = False
		  else
		    HasTitle = True
		  End If
		  
		  
		  If Type<>"" then
		    Redim Axes(1)
		    InitSeries(Fields-1)
		  else
		    InitSeries(Fields)
		  End If
		  
		  If me.Type <> TypeCombo then
		    For i = 0 to UBound(Series)
		      Series(i).Type = me.Type
		    Next
		  End If
		  
		  //Series Name
		  If HasTitle then
		    If Type <> "" then
		      Axes(0).Title = List.Heading(0)
		      For i = 1 to Fields
		        Series(i-1).Title = Trim(List.Heading(i))
		      Next
		    else
		      For i = 0 to Fields
		        Series(i).Title = Trim(List.Heading(i))
		      Next
		    End If
		  End If
		  
		  'Dim D As new Date
		  
		  //Reading Data
		  For i = 0 to List.ListCount-1
		    
		    For j = 0 to Fields
		      
		      
		      If j = 0 and Type<> "" then
		        If Type = "String" then
		          Axes(0).Label.Append List.Cell(i, j)
		        elseif Type = "Date" then
		          If Init then
		            Axes(0).LabelStyle.Format = "SQLDate"
		          End If
		          Axes(0).Label.Append mTestDate(Trim(List.Cell(i, j))) 'entry.Nthfield(Separator, i)
		          
		          
		        elseif Type = "Integer" or Type="Double" then
		          Axes(0).Label.Append val(List.Cell(i, j))
		        End If
		        
		      else
		        If List.Cell(i,j).Trim = "" then
		          If Type <> "" then
		            Series(j-1).Values.append Nil
		          else
		            Series(j).Values.append Nil
		          End If
		        else
		          If Type <> "" then
		            Series(j-1).Values.Append val(List.Cell(i, j))
		          else
		            Series(j).Values.Append val(List.Cell(i, j))
		          End If
		        End If
		        
		      End If
		    Next
		    
		  Next
		  
		  If not Freeze then
		    If Animate then
		      if LastData <> me.ToCSV_Internal then
		        StartAnimation(False, AnimationType)
		      end if
		    else
		      me.Redisplay()
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = TargetWeb
		Sub LoadFromWebListbox(List As WebListbox, Init As Boolean = False, ForceFirstColumnAsLabels As Boolean = True)
		  //Loads the chart directly from a Listbox.
		  //
		  //If Init is True, the Init function will be called before loading the Data.
		  //If ForceFirstColumnAsLabels is True, the First column will be treated as the X-Axis data labels.
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  If List.ColumnCount = 0 then
		    LastError = "Empty Listbox"
		    Return
		  End If
		  If List.RowCount = 0 then
		    LastError = "Empty Listbox"
		    Return
		  End If
		  
		  
		  LastError = ""
		  Dim LastData As String = me.ToCSV_Internal()
		  
		  Dim entry As String
		  Dim Fields As Integer = List.ColumnCount-1
		  
		  Dim Type As String
		  Dim HasTitle As Boolean
		  Dim i, j As Integer
		  
		  #if DebugBuild
		    Dim tmp As String
		  #endif
		  
		  If Init then
		    self.Init()
		  else
		    For i = 0 to UBound(Axes)
		      Axes(i).Init(True)
		    Next
		  End If
		  
		  
		  entry = List.Cell(0, 0)
		  
		  If IsNumeric(entry) = False then
		    If mTestDate(entry) <> Nil then
		      Type="Date"
		    else
		      Type = "String"
		    End If
		  elseif ForceFirstColumnAsLabels then
		    If entry.InStr(".")>0 then
		      Type="Double"
		    else
		      Type="Integer"
		    End If
		  End If
		  
		  If List.HasHeading then
		    'If IsNumeric(Lines(0).NthField(Separator, Fields)) then
		    HasTitle = False
		  else
		    HasTitle = True
		  End If
		  
		  
		  If Type<>"" then
		    Redim Axes(1)
		    InitSeries(Fields-1)
		  else
		    InitSeries(Fields)
		  End If
		  
		  If me.Type <> TypeCombo then
		    For i = 0 to UBound(Series)
		      Series(i).Type = me.Type
		    Next
		  End If
		  
		  //Series Name
		  If HasTitle then
		    If Type <> "" then
		      Axes(0).Title = List.Heading(0)
		      For i = 1 to Fields
		        Series(i-1).Title = Trim(List.Heading(i))
		      Next
		    else
		      For i = 0 to Fields
		        Series(i).Title = Trim(List.Heading(i))
		      Next
		    End If
		  End If
		  
		  Dim D As new Date
		  
		  //Reading Data
		  For i = 0 to List.RowCount-1
		    
		    For j = 0 to Fields
		      
		      
		      If j = 0 and Type<> "" then
		        If Type = "String" then
		          Axes(0).Label.Append List.Cell(i, j)
		        elseif Type = "Date" then
		          If Init then
		            Axes(0).LabelStyle.Format = "SQLDate"
		          End If
		          Axes(0).Label.Append mTestDate(Trim(List.Cell(i, j))) 'entry.Nthfield(Separator, i)
		          
		          
		        elseif Type = "Integer" or Type="Double" then
		          Axes(0).Label.Append val(List.Cell(i, j))
		        End If
		        
		      else
		        If List.Cell(i,j).Trim = "" then
		          If Type <> "" then
		            Series(j-1).Values.append Nil
		          else
		            Series(j).Values.append Nil
		          End If
		        else
		          If Type <> "" then
		            Series(j-1).Values.Append val(List.Cell(i, j))
		          else
		            Series(j).Values.Append val(List.Cell(i, j))
		          End If
		        End If
		        
		      End If
		    Next
		    
		  Next
		  
		  me.Redisplay()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = not TargetWeb
		Private Sub mAnimationTimerAction(caller As Timer)
		  caller.Period = 0
		  'AnimIdx = AnimIdx + 1
		  
		  'me.Invalidate(False)
		  me.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MovingAverage(Index As Integer, Period As Integer = 10)
		  //Source http://en.wikipedia.org/wiki/Moving_average
		  
		  Dim i As Integer
		  
		  
		  Dim Yavg As Double
		  
		  Dim cs As new ChartSerie
		  
		  
		  Dim U As Integer = UBound(Series(Index).Values)
		  For i = 0 to U
		    
		    If i < Period then
		      If Series(Index).Values(i) <> Nil then
		        Yavg = Yavg + Series(Index).Values(i).DoubleValue/Period
		      End If
		      
		      cs.Values.Append Nil
		    Else
		      
		      If Series(Index).Values(i) <> Nil then
		        Yavg = Yavg + Series(Index).Values(i).DoubleValue/Period
		      Else
		        Break
		      End If
		      If Series(Index).Values(i-Period) <> Nil then
		        Yavg = Yavg - Series(Index).Values(i-Period).DoubleValue/Period
		      Else
		        Break
		      End If
		      
		      cs.Values.Append Yavg
		    End If
		  Next
		  
		  
		  cs.FillColor = Series(0).FillColor
		  cs.Type = me.TypeLine
		  cs.MarkerType = cs.MarkerNone
		  cs.LineWeight = 2
		  cs.MarkLine = True
		  
		  me.MarkSeries.Append cs
		  
		  me.Redisplay
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mParseDate(D As Date, Format As String, Default As String = "", ChangeYear As Boolean = False) As String
		  If D is Nil then Return ""
		  
		  If Format = "" then
		    If Default = "" then Return D.LongDate
		    
		    Format = Default
		  End If
		  
		  Dim text As String = Format
		  
		  //Default formats
		  If text.InStr("Long Date")>0 then
		    text = text.Replace("Long Date", D.LongDate)
		  elseif text.InStr("longdate")>0 then
		    text = text.Replace("Longdate", D.LongDate)
		  elseif text.InStr("Short Date")>0 then
		    text = text.Replace("Short Date", D.ShortDate)
		  elseif text.InStr("ShortDate")>0 then
		    text = text.Replace("Shortdate", D.ShortDate)
		  elseif text.InStr("Abbreviated Date")>0 then
		    text = text.Replace("Abbreviated Date", D.AbbreviatedDate)
		  elseif text.InStr("AbbreviatedDate")>0 then
		    text = text.Replace("AbbreviatedDate", D.AbbreviatedDate)
		  elseif text.InStr("SQLDateTime")>0 then
		    text = text.Replace("SQLDateTime", D.SQLDateTime)
		  elseif text.InStr("SQLDate")>0 then
		    text = text.Replace("SQLDate", D.SQLDate)
		  End If
		  
		  If text <> Format then
		    Return Text
		  End If
		  
		  Dim Chars() As String = Format.Split("")
		  
		  Dim i As Integer
		  Dim u As Integer = UBound(Chars)
		  For i = u DownTo 1
		    If left(Chars(i), 1) = Chars(i-1) or chars(i-1) = "\" or chars(i-1)="?" then
		      Chars(i-1) = Chars(i-1) + Chars(i)
		      Chars.Remove(i)
		    End If
		  Next
		  
		  u = UBound(Chars)
		  For i = 0 to u
		    text = Chars(i)
		    
		    If text.left(1) = "\" then
		      Chars(i) = mid(text, 2)
		      Continue for i
		    End If
		    
		    //Day
		    If text.InStr("dddd")>0 then
		      text = text.Replace("dddd", DayNames(D.DayOfWeek))
		    elseif text.InStrB("l")>0 then
		      
		      text = text.ReplaceB("l", DayNames(D.DayOfWeek))
		    ElseIf text.InStr("ddd")>0 then
		      text = text.Replace("ddd", DayNames(D.DayOfWeek).Left(3))
		    ElseIf text.InStr("d")>0 then
		      text = text.Replace("d", Format(D.Day, "00"))
		    elseif text.InStr("j")>0 then
		      text = text.Replace("j", str(D.Day))
		    ElseIf text.InStr("mmmm")>0 then
		      text = text.Replace("mmmm", MonthNames(D.Month))
		    elseif text.InStr("mm")>0 then
		      text = text.Replace("mm", Format(D.Month, "00"))
		    elseif text.InStrB("m")>0 then
		      text = text.Replace("m", Format(D.Month, "00"))
		    elseif text.InStrB("n")>0 then
		      text = text.ReplaceB("n", str(D.Month))
		    elseif text.InStrB("N")>0 then
		      text = text.ReplaceB("N", str((D.DayOfWeek+7-1) mod 7))
		    elseif text.InStrB("M")>0 then
		      text = text.ReplaceB("M", MonthNames(D.Month).Left(3))
		    elseif text.InStrB("F")>0 then
		      text = text.ReplaceB("F", MonthNames(D.Month))
		    elseif text.InStrB("w")>0 then
		      text = text.ReplaceB("w", str(D.DayOfWeek))
		    elseif text.InStr("W")>0 then
		      text = text.ReplaceB("W", str(D.WeekOfYear))
		    elseif text.InStr("z")>0 then
		      text = text.Replace("z", str(D.DayOfYear))
		    elseif text.InStr("t")>0 then
		      Dim DD As Date = New Date(D)
		      DD.day = 1
		      DD.Month = DD.Month+1
		      DD.Day = DD.Day-1
		      text = text.Replace("t", str(DD.Day))
		    elseif text.InStr("?y")>0 then
		      If ChangeYear then
		        if text.InStr("yyyy")>0 then
		          text = text.Replace("?yyyy", str(D.Year))
		        elseif text.InStr("?yy")>0 then
		          text = text.Replace("?yy", mid(str(D.Year), 3))
		        elseif text.InStrB("?Y")>0 then
		          text = text.ReplaceB("?Y", str(D.Year))
		        elseif text.InStrB("?y")>0 then
		          text = text.ReplaceB("?y", str(D.Year))
		        end if
		      else
		        text = ""
		      End If
		    elseif text.InStr("yyyy")>0 then
		      text = text.Replace("yyyy", str(D.Year))
		    elseif text.InStr("yy")>0 then
		      text = text.Replace("yy", mid(str(D.Year), 3))
		    elseif text.InStrB("Y")>0 then
		      text = text.ReplaceB("Y", str(D.Year))
		    elseif text.InStrB("y")>0 then
		      text = text.ReplaceB("y", str(D.Year))
		    End If
		    
		    Chars(i) = text
		  Next
		  
		  Return Join(Chars(), "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mTestDate(DateString As String) As Date
		  Dim D As New Date
		  
		  If DateString.CountFields(":")>1 and Len(DateString)<12 then Return Nil
		  
		  If ParseDate(DateString, D) then Return D
		  
		  DateString = Trim(DateString)
		  
		  If IsNumeric(DateString.left(4)) = False or IsNumeric(DateString.Mid(6, 2)) = False or IsNumeric(DateString.Mid(9, 2)) = False then
		    Return Nil
		  End If
		  
		  If len(DateString) = 10 then
		    try
		      D.SQLDate = DateString + " 00:00:00"
		    Catch UnsupportedFormatException
		      Return Nil
		    End Try
		    
		    If D <> Nil then
		      Return D
		    End If
		    
		  elseif len(DateString) = 19 then
		    
		    try
		      D.SQLDateTime = DateString
		    Catch UnsupportedFormatException
		      Return Nil
		    end try
		    
		    If D <> Nil then
		      Return D
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub OrderFXA(ByRef fxs() As FigureShape, ByRef fxa() As Double)
		  Const PI=3.14159265358979323846264338327950
		  
		  Const Shrink = 1.3
		  Dim swapped As Boolean
		  Dim i, u, gap As Integer
		  Dim swapfx As FigureShape
		  Dim swapa As Double
		  
		  
		  u = UBound(fxa())
		  gap = u
		  
		  Dim okToSwap As Boolean
		  
		  while gap > 1 or swapped
		    if gap > 1 then
		      gap = gap / shrink
		    End If
		    
		    swapped = False
		    
		    For i = 0 to u-gap
		      If fxa(i) < PI*0.5 and fxa(i) > fxa(i+gap) then
		        okToSwap = True
		      Elseif fxa(i) < PI*0.5 and fxa(i+gap) > PI*1.5 then
		        okToSwap = True
		      Elseif fxa(i) < PI*0.5 and fxa(i+gap) > PI*0.5 then
		        okToSwap = True
		      Elseif fxa(i) > PI*0.5 and fxa(i) < PI*1.5 and fxa(i) < fxa(i+gap) then
		        okToSwap = true
		      Else
		        okToSwap = False
		      End If
		      
		      If (okToSwap) then
		        
		        swapa = fxa(i)
		        swapfx = fxs(i)
		        fxa(i) = fxa(i+gap)
		        fxa(i+gap) = swapa
		        fxs(i) = fxs(i+gap)
		        fxs(i+gap)=swapfx
		        swapped = True
		      End If
		    Next
		    
		  wend
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = TargetHasGUI
		Protected Sub PaintAnimation(g As Graphics)
		  #If False
		    Dim gg, gp As Graphics
		    
		    Buffer = New Picture(Width, Height, 32)
		    gg = Buffer.Graphics
		    
		    DrawBackground(gg)
		    DrawAxis(gg)
		    DrawLegend(gg)
		    
		    Dim frameRate As Integer = 60
		    Dim Times() As Double
		    Dim Percent() As Integer
		    Dim i, MaxFrame As Integer
		    MaxFrame = frameRate / (1000 / AnimationTime)
		    Redim Times(MaxFrame)
		    Redim Percent(MaxFrame)
		    Dim currentTime As Double
		    Dim TimePerFrame As Double = 1000 / frameRate
		    
		    For i = 0 to MaxFrame
		      Times(i) = TimePerFrame * (i+1)
		      Percent(i) = 100*i/MaxFrame
		      
		    Next
		    
		    If Border then
		      gg.ForeColor = BorderColor
		      gg.DrawRect(0, 0, gg.Width, gg.Height)
		    End If
		    
		    //This improves performance by not drawing the Axis and Legend each time
		    Dim Buffer2 As Picture = New Picture(Width, Height, 32)
		    gg = Buffer2.Graphics
		    
		    
		    
		    Dim startTime As Double = Microseconds/1000
		    
		    //To calculate Actual FPS
		    'Dim LastFrame As Double = Microseconds
		    
		    For i = 0 to MaxFrame
		      
		      currentTime = Microseconds / 1000
		      
		      If i<MaxFrame and i>0 and currentTime - startTime > Times(i) then
		        Continue for i
		      End If
		      While i>0 and currentTime-startTime <  Times(i-1)
		        App.DoEvents (max(1, Times(i-1) - (currentTime-startTime)-1))
		        currentTime = Microseconds / 1000
		      Wend
		      
		      AnimationPercent = Percent(i)
		      
		      gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width+5, Plot.Height)
		      
		      //Flushing the buffered Axis and Legend
		      gg.DrawPicture(Buffer, 0, 0)
		      
		      If Type = TypeCombo then
		        
		        PlotCombo(gp)
		        
		      ElseIf Type\100 = TypeColumn\100 then
		        
		        PlotColumn(gp)
		        
		      Elseif Type = TypeLineSmooth or Type = TypeLineStackedSmooth then
		        
		        PlotSpline(gp)
		        
		      Elseif Type\100 = TypeLine\100 then
		        
		        PlotLine(gp)
		        
		      Elseif Type\100 = TypeArea\100 then
		        
		        PlotArea(gp)
		        
		      Elseif Type\100 = TypeBar\100 then
		        
		        PlotBar(gp)
		        
		      Elseif Type\100 = TypeScatter\100 then
		        
		        PlotScatter(gp)
		        
		      Elseif Type\100 = TypeTrendTimeLine\100 then
		        
		        PlotTrend(gp)
		        
		      Elseif Type\100 = TypePie\100 then
		        
		        PlotPie(gp)
		        
		      Elseif Type\100 = TypeRadar\100 then
		        
		        PlotRadar(gp)
		        
		      End If
		      
		      DrawMark(gg)
		      
		      
		      
		      //Drawing FPS
		      '#if DebugBuild
		      'gp.ForeColor = &c0
		      'gp.DrawString(str(1000/((Microseconds-LastFrame)/1000), "#.0") + " fps", g.Width-100, 10)
		      '#endif
		      
		      
		      g.DrawPicture(Buffer2, 0, 0)
		      
		      'LastFrame = Microseconds
		      
		    Next
		    
		    FullRefresh = True
		    
		    AnimationInProgress = False
		    AnimationFinished()
		    
		    Refresh(False)
		    
		  #else
		    #Pragma Unused g
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = TargetHasGUI
		Protected Sub PaintAnimation1(g As Graphics)
		  
		  
		  If not AnimInit then
		    AnimationInit()
		  End If
		  
		  Dim gg, gp As Graphics
		  
		  
		  
		  //This improves performance by not drawing the Axis and Legend each time
		  #if TargetWin32
		    Dim Buffer2 As Picture = New Picture(Width, Height, 32)
		    gg = Buffer2.Graphics
		  #else
		    gg = g
		  #endif
		  
		  
		  Dim currentTime As Double
		  
		  currentTime = Microseconds / 1000
		  
		  While AnimIdx<AnimMaxFrame and AnimIdx >= 0 and currentTime - AnimStartTime > AnimTimes(AnimIdx)
		    AnimIdx = AnimIdx + 1
		  Wend
		  
		  If AnimIdx <= AnimMaxFrame then
		    
		    If AnimIdx > 0 and currentTime-AnimStartTime < AnimTimes(AnimIdx-1) then
		      AnimIdx = AnimIdx - 1
		      mAnimationTimer.Mode = timer.ModeSingle
		      Return
		    End If
		    'While i>0 and currentTime-startTime <  Times(i-1)
		    'App.DoEvents (max(1, Times(i-1) - (currentTime-startTime)-1))
		    'currentTime = Microseconds / 1000
		    'Wend
		    
		    #if kDebug
		      System.DebugLog str(AnimIdx) + "/" + str(AnimMaxFrame)
		    #endif
		    
		    #if DebugBuild
		      Dim drawtime As Double = Microseconds
		    #endif
		    
		    AnimationPercent = AnimPercent(AnimIdx)
		    
		    gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width+5, Plot.Height)
		    
		    //Flushing the buffered Axis and Legend
		    gg.DrawPicture(Buffer, 0, 0)
		    
		    If Type = TypeCombo then
		      
		      PlotCombo(gp)
		      
		    ElseIf Type\100 = TypeColumn\100 then
		      
		      PlotColumn(gp)
		      
		    Elseif Type = TypeLineSmooth or Type = TypeLineStackedSmooth then
		      
		      PlotSpline(gp)
		      
		    Elseif Type\100 = TypeLine\100 then
		      
		      PlotLine(gp)
		      
		    Elseif Type\100 = TypeArea\100 then
		      
		      PlotArea(gp)
		      
		    Elseif Type\100 = TypeBar\100 then
		      
		      PlotBar(gp)
		      
		    Elseif Type\100 = TypeScatter\100 then
		      
		      PlotScatter(gp)
		      
		    Elseif Type\100 = TypeTrendTimeLine\100 then
		      
		      PlotTrend(gp)
		      
		    Elseif Type\100 = TypePie\100 then
		      
		      PlotPie(gp)
		      
		    Elseif Type\100 = TypeRadar\100 then
		      
		      PlotRadar(gp)
		      
		    End If
		    
		    DrawMark(gg)
		    
		    
		    
		    //Drawing FPS
		    '#if DebugBuild
		    'gp.ForeColor = &c0
		    'gp.DrawString(str(1000/((Microseconds-LastFrame)/1000), "#.0") + " fps", g.Width-100, 10)
		    '#endif
		    
		    #if TargetWin32
		      g.DrawPicture(Buffer2, 0, 0)
		    #endif
		    
		    #if DebugBuild
		      drawtime = (Microseconds-drawtime)/1000
		      'g.DrawString(str(drawtime), g.Width-100, 10)
		    #endif
		    
		  End If
		  
		  'LastFrame = Microseconds
		  
		  mAnimationTimer.Mode = timer.ModeSingle
		  
		  If AnimIdx >= AnimMaxFrame then
		    
		    mAnimationTimer.Mode = timer.ModeOff
		    FullRefresh = True
		    
		    AnimationInProgress = False
		    AnimationFinished()
		    
		    
		    me.Refresh(False)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotArea(g As Graphics, OneSerie As Integer = -1, Trend As Boolean = False)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  
		  //All Charts Variables
		  Dim UnitWidth, UnitHeight As Double
		  Dim nSeries As Integer = UBound(Series)
		  Dim i, j, X, Y, H As Integer
		  Dim Type As Integer
		  Dim StartSerie As Integer
		  If OneSerie>-1 then
		    Type = me.Series(OneSerie).Type
		    StartSerie = OneSerie
		    nSeries = OneSerie
		  else
		    Type = self.Type
		  End If
		  
		  If Trend then
		    H = g.Height
		  else
		    H = BaseDrawY
		  End If
		  UnitWidth = Axes(0).UnitWidth
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  
		  If trend then
		    UnitHeight = (g.height-2)/Axes(1).MaximumScale
		  End If
		  
		  Dim ShiftValue As Boolean
		  If Axes(1).LogarithmicScale = False and Axes(1).MinimumScale > 0 then
		    ShiftValue = True
		  End If
		  
		  
		  //Column & Area Variables
		  Dim Value As Double
		  Dim NilValue As Boolean
		  Dim LastNilValue As Boolean
		  Dim ULabels As Integer
		  ULabels = UBound(Labels)
		  
		  Dim FillPic As Picture
		  
		  //Area Specific Variables
		  Dim LastX As Integer
		  Dim LastY As Integer
		  Dim Points() As Integer
		  
		  
		  Dim TempType As Integer
		  
		  If Type\100 = TypeArea\100 then
		    TempType = Type
		  else
		    If Type = TypeTrendAreaStepped then
		      TempType = TypeAreaStepped
		    End If
		  End If
		  
		  
		  
		  If Trend then Precision = 1.0 '2.0
		  
		  
		  If tempType = TypeArea then
		    
		    For j = StartSerie to nSeries
		      
		      Redim Series(j).mPts(-1)
		      Redim Points(-1)
		      Points.Append 0
		      
		      If Trend then
		        g.ForeColor = &c505050
		      else
		        g.ForeColor = Series(j).FillColor
		      End If
		      
		      
		      For i = 0 to ULabels step Precision
		        
		        Value = GetValue(i, j, NilValue, False)
		        
		        
		        
		        If CrossesBetweenTickMarks then
		          X = Round(UnitWidth * i + UnitWidth/2)
		        else
		          X = Round(UnitWidth * i)
		        End If
		        If ShiftValue then
		          Y = H - Round((Value-Axes(1).MinimumScale)*UnitHeight)
		        else
		          Y = H - Round(Value*UnitHeight)
		        End If
		        
		        If i = ULabels or i+Precision>ULabels then
		          X = min(X, Plot.Width-1)
		        End If
		        
		        If LastNilValue and not NilValue then
		          Points.Append X
		          Points.Append H
		          LastNilValue = False
		          
		        End If
		        
		        If NilValue then
		          
		          Series(j).mPts.append Nil
		          
		          Points.Append LastX
		          Points.Append H
		          
		          Points.Append X
		          Points.Append H
		          
		          LastNilValue = True
		        else
		          
		          Series(j).mPts.append New REALbasic.Point(X, Y)
		          
		          Points.Append X
		          Points.Append Y
		        End If
		        
		        LastX = X
		        LastY = Y
		        
		      Next
		      
		      Points.Append X
		      'Points.Append Plot.Width-1
		      Points.Append H
		      Points.Append 0
		      Points.Append H
		      
		      If Series(j).FillType = ChartSerie.FillSolid then
		        
		        If Series(j).Transparency=0 then
		          //No transparency
		          g.FillPolygon Points
		        else
		          
		          #If TargetDesktop
		            if TargetMacOS then 'or (TargetWin32 and App.UseGDIPlus) Then
		              g.ForeColor = AlphaColor(g.ForeColor, Series(j).Transparency)
		              g.FillPolygon Points
		            else
		              FillPic = New Picture(g.Width, g.Height, 32)
		              Dim gf As Graphics = FillPic.Graphics
		              gf.ForeColor = Series(j).FillColor
		              gf.FillRect(0, 0, gf.Width, gf.Height)
		              
		              //Select the mask
		              gf = FillPic.Mask.Graphics
		              gf.ForeColor = &cFFFFFF
		              gf.FillRect(0, 0, gf.Width, gf.Height)
		              
		              //Draw the polygon
		              gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		              gf.FillPolygon Points
		              
		              g.DrawPicture(FillPic, 0, 0)
		            end if
		          #elseif TargetWeb
		            //A corriger web peut-etre
		            g.ForeColor = AlphaColor(g.ForeColor, Series(j).Transparency)
		            g.FillPolygon Points
		          #endif
		          
		        End If
		        
		        
		      else //FillPicture
		        
		        FillPic = New Picture(g.Width, g.Height, 32)
		        GetFillPicture(FillPic, Series(j), -1, "", 0, 0)
		        
		        Dim gf As Graphics = FillPic.Mask.Graphics
		        gf.ForeColor = &cFFFFFF
		        gf.FillRect(0, 0, gf.Width, gf.Height)
		        
		        gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		        gf.FillPolygon Points
		        
		        g.DrawPicture(FillPic, 0, 0)
		      End If
		      
		      
		    Next
		    
		    For j = StartSerie to nSeries
		      If Series(j).BorderWidth>0 then
		        PlotLine(g, j, True)
		      End If
		    Next
		    'If Series(0).BorderWidth>0 then
		    'PlotLine(g)
		    'End If
		    
		    
		    //----------//
		    //  Stacked //
		    //----------//
		  Elseif tempType = TypeAreaStacked or TempType = TypeAreaStepped then
		    Dim gf As Graphics
		    
		    For j = nSeries DownTo StartSerie
		      
		      Redim Points(-1)
		      Points.Append 0
		      
		      me.Series(j).Type = TempType
		      
		      If Trend then
		        g.ForeColor = &c505050
		      else
		        g.ForeColor = Series(j).FillColor
		      End If
		      
		      
		      For i = 0 to ULabels step Precision
		        
		        Value = GetValue(i, j, NilValue, False, Trend)
		        
		        X = Round(UnitWidth * i)
		        Y = H - Round(Value*UnitHeight) 'max(1, Round(Value*UnitHeight))
		        
		        If i = ULabels then
		          X = min(X, Plot.Width-1)
		        End If
		        
		        If LastNilValue and not NilValue then
		          Points.Append X
		          Points.Append H
		          LastNilValue = False
		          
		        End If
		        
		        If NilValue then
		          
		          Points.Append LastX
		          Points.Append H
		          
		          Points.Append X
		          Points.Append H
		          
		          LastNilValue = True
		        else
		          
		          Points.Append X
		          Points.Append Y
		        End If
		        
		        LastX = X
		        LastY = Y
		        
		        If tempType = TypeAreaStepped then
		          LastX = Round(UnitWidth*(i+1)*Precision)
		          Points.Append LastX
		          Points.Append Y
		        End If
		        
		      Next
		      
		      Points.Append Plot.Width-1
		      Points.Append H
		      Points.Append 0
		      Points.Append H
		      
		      If Series(j).Transparency=0 then
		        //No transparency
		        g.FillPolygon Points
		      else
		        
		        If j<nSeries then
		          gf.ForeColor = &cFFFFFF
		          gf.FillPolygon Points
		          g.DrawPicture(FillPic, 0, 0)
		        End If
		        
		        FillPic = New Picture(g.Width, g.Height, 32)
		        gf = FillPic.Graphics
		        gf.ForeColor = Series(j).FillColor
		        gf.FillRect(0, 0, gf.Width, gf.Height)
		        gf = FillPic.Mask.Graphics
		        gf.ForeColor = &cFFFFFF
		        gf.FillRect(0, 0, gf.Width, gf.Height)
		        'If Series(j).BorderWidth=0 then
		        //No border
		        gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		        gf.FillPolygon Points
		        'else
		        //Has a border
		        //To do
		        'gf.ForeColor = &c0
		        'gf.FillPolygon Points
		        'Dim gclip As Graphics = gf.Clip(0, Series(j).BorderWidth+1, gf.Width, gf.Height)
		        'gclip.ForeColor = TransparencyPercentage(Series(j).Transparency)
		        'gclip.FillPolygon Points
		        'End If
		        If j=0 then
		          g.DrawPicture(FillPic, 0, 0)
		        End If
		      End If
		      
		      X = X
		      
		      If Series(j).BorderWidth>0 then
		        PlotLine(g, j, False)
		      End If
		      
		    Next
		    
		    
		    
		    'Elseif tempType = TypeAreaStacked or TempType = TypeAreaStepped then
		    '
		    'For j = nSeries DownTo 0
		    '
		    'Redim Points(-1)
		    'Points.Append 0
		    '
		    'If Trend then
		    'g.ForeColor = &c505050
		    'else
		    'g.ForeColor = Series(j).FillColor
		    'End If
		    '
		    '
		    'For i = 0 to U step Precision
		    '
		    'Value = GetValue(i, j)
		    '
		    'X = Round(UnitWidth * i)
		    'Y = H - Round(Value*UnitHeight) 'max(1, Round(Value*UnitHeight))
		    '
		    'Points.Append X
		    'Points.Append Y
		    '
		    'If tempType = TypeAreaStepped then
		    'Points.Append Round(UnitWidth*(i+1)*Precision)
		    'Points.Append Y
		    'End If
		    '
		    'Next
		    '
		    'Points.Append g.Width-1
		    'Points.Append H
		    'Points.Append 0
		    'Points.Append H
		    '
		    'If Series(j).Transparency=0 then
		    '//No transparency
		    'g.FillPolygon Points
		    'else
		    'FillPic = New Picture(g.Width, g.Height, 32)
		    'Dim gf As Graphics = FillPic.Graphics
		    'gf.ForeColor = Series(j).FillColor
		    'gf.FillRect(0, 0, gf.Width, gf.Height)
		    'gf = FillPic.Mask.Graphics
		    'gf.ForeColor = &cFFFFFF
		    'gf.FillRect(0, 0, gf.Width, gf.Height)
		    ''If Series(j).BorderWidth=0 then
		    '//No border
		    'gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		    'gf.FillPolygon Points
		    ''else
		    '//Has a border
		    '//To do
		    ''gf.ForeColor = &c0
		    ''gf.FillPolygon Points
		    ''Dim gclip As Graphics = gf.Clip(0, Series(j).BorderWidth+1, gf.Width, gf.Height)
		    ''gclip.ForeColor = TransparencyPercentage(Series(j).Transparency)
		    ''gclip.FillPolygon Points
		    ''End If
		    'g.DrawPicture(FillPic, 0, 0)
		    'End If
		    '
		    'X = X
		    'Next
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotBar(g As Graphics, OneSerie As Integer = -1)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  
		  //All Charts Variables
		  Dim UnitWidth, UnitHeight, SecondUnitHeight As Double
		  Dim nSeries As Integer = UBound(Series)
		  Dim i, j, X, H, W As Integer
		  Dim lblX, lblY As Integer
		  Dim Y As Double
		  'Dim MinusY As Double
		  Dim gg As Graphics = g
		  Dim Type As Integer
		  Dim StartSerie As Integer
		  If OneSerie>-1 then
		    Type = me.Series(OneSerie).Type
		    StartSerie = OneSerie
		    nSeries = OneSerie
		  else
		    Type = self.Type
		  End If
		  
		  H = Plot.Width
		  'H = BaseDrawY
		  W = 0
		  UnitWidth = Axes(0).UnitWidth
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  If UBound(Axes)>1 then
		    SecondUnitHeight = Axes(2).UnitWidth / Axes(2).MajorUnit
		  End If
		  
		  
		  Dim ShiftValue As Boolean
		  If Axes(1).LogarithmicScale = False and Axes(1).MinimumScale > 0 then
		    ShiftValue = True
		  End If
		  
		  //Column & Area Variables
		  Dim Value As Double
		  Dim NilValue As Boolean
		  'Dim strValue As String
		  Dim U As Integer
		  U = UBound(Labels)
		  
		  Dim FillPic As Picture
		  Dim gf As Graphics
		  
		  //Column Specific Variables
		  Dim Offset As Integer
		  Dim ColumnWidth As Integer
		  Dim ColumnWidth_backup As Integer
		  
		  Dim v() As Double
		  
		  //If UnitWidth is very small, there is no offset
		  If UnitWidth < 5 then
		    Offset = 0
		  else
		    Offset = Round(UnitWidth *1/10)
		  End If
		  
		  
		  
		  
		  If Type = TypeBar or Type = TypeBullet then //Simple columns
		    
		    //Setting ColumnWidth
		    //ColumnWidth is at least 1 px
		    If OneSerie>-1 then
		      If UnitWidth < 4 then
		        ColumnWidth = max(1, UnitWidth)
		      else
		        ColumnWidth = UnitWidth * 8.0/10.0
		      End If
		      
		    else
		      If UnitWidth < 4 then
		        ColumnWidth = max(1, UnitWidth / (nSeries+1))
		      else
		        If BarOverLapRatio=0.0 then
		          If Type = TypeBullet then
		            ColumnWidth = (UnitWidth-4) / nSeries * 8.0/10.0
		          else
		            ColumnWidth = UnitWidth / (nSeries+1) * 8.0/10.0 ' * (1.0 + BarOverLapRatio)
		          End If
		        else
		          ColumnWidth = UnitWidth * 8.0/10.0 * (1/BarOverLapRatio) / (1/BarOverLapRatio*(nSeries+1)-nSeries)
		        End If
		        
		      End If
		    End If
		    
		    If DataLabel <> Nil then
		      gg.TextSize = DataLabel.TextSize
		      gg.TextFont = DataLabel.TextFont
		    End If
		    
		    ColumnWidth_backup = ColumnWidth
		    
		    //Going through all values
		    For i = 0 to U
		      
		      //Going through all series
		      For j = StartSerie to nSeries
		        
		        
		        
		        //Retrieving Value
		        Value = GetValue(i, j, NilValue, False)
		        
		        If NilValue then Continue for j
		        
		        
		        If ShiftValue then
		          Value = Value - Axes(1).MinimumScale
		        End If
		        
		        If Value = 0 then
		          Continue for j
		        End If
		        
		        If OneSerie>-1 then
		          X = Round(Offset + UnitWidth * i)
		        else
		          X = Round(Offset + UnitWidth * i + j * ColumnWidth-(ColumnWidth*BarOverLapRatio))
		        End If
		        
		        If j = nSeries and Type = TypeBullet then
		          If ColumnWidth > 2 then
		            X = X + 2
		            ColumnWidth = min(ColumnWidth, 2)
		          End If
		        End If
		        
		        If Series(j).SecondaryAxis = False then
		          If Value>0 then
		            Y = max(1, Round(Value*UnitHeight))
		            W = 1
		          else
		            Y = min(-1, Round(Value*UnitHeight))
		            W = -1
		          End If
		        else
		          If Value>0 then
		            Y = max(1, Round(Value*SecondUnitHeight))
		            W = 1
		          else
		            Y = min(-1, Round(Value*SecondUnitHeight))
		            W=-1
		          End If
		        End If
		        
		        //Drawing
		        If Series(j).FillType = ChartSerie.FillSolid then
		          gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		          gg.FillRect(W, X, Y, ColumnWidth)
		          
		        elseif Series(j).FillType = ChartSerie.FillPicture then
		          FillPic = New Picture(Abs(Y), ColumnWidth, 32)
		          
		          If Series(j).Transparency > 0 then
		            gf = FillPic.Mask.Graphics
		            gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		            gf.AAG_FillAll()
		          End If
		          
		          GetFillPicture(FillPic, Series(j), i, Labels(i), W, X)
		          
		          
		          gg.DrawPicture(FillPic, W, X)
		          
		        End If
		        
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress and (Type=TypeBar Or (Type=TypeBullet and j<nSeries)) then
		          If DataLabel.Position = PositionRight then
		            lblX = Plot.Width-5
		            lblY = X + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		          elseif DataLabel.Position = PositionLeft then
		            If gg.StringWidth(str(Value, DataLabel.Format)) > Y then
		              lblX = W+Y+2
		            else
		              lblX = W+2
		            End If
		            lblY = X + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		          else //Inside
		            If gg.StringWidth(str(Value, DataLabel.Format)) > Y then
		              lblX = W+Y+2+gg.StringWidth(str(Value, DataLabel.Format))
		            else
		              lblX = W+Y-2
		            End If
		            lblY = X + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		          End If
		          
		          
		          DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y), False, DataLabel.Position)
		        End If
		        
		        If j = nSeries and Type = TypeBullet then
		          ColumnWidth = ColumnWidth_backup
		        End If
		        
		      Next
		    Next
		    
		  Elseif Type = TypeBarStacked then
		    
		    ColumnWidth = UnitWidth * 8/10
		    
		    Dim MinusX As Integer
		    Dim xx As Integer
		    
		    //Going through all values
		    For i = 0 to U
		      
		      Y = Round(Offset + UnitWidth * i)
		      X = 1
		      MinusX = -1
		      
		      
		      
		      
		      //Going through all series
		      For j = StartSerie to nSeries
		        
		        //Retrieving Value
		        Value = GetValue(i, j)
		        
		        If Value = 0.0 then
		          Continue for j
		        End If
		        
		        
		        If Value>0 then
		          W = max(1, Round(Value*UnitHeight))
		          xx = X
		        else
		          W = min(-1, -Round(Value*UnitHeight))
		          xx = MinusX
		        End If
		        
		        
		        //Drawing
		        If Series(j).FillType = ChartSerie.FillSolid then
		          gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		          gg.FillRect(xx, Y, W, ColumnWidth)
		          
		        Elseif Series(j).FillType = ChartSerie.FillPicture then
		          FillPic = New Picture(Abs(W), ColumnWidth, 32)
		          
		          If Series(j).Transparency > 0 then
		            gf = FillPic.Mask.Graphics
		            gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		            gf.AAG_FillAll()
		          End If
		          
		          GetFillPicture(FillPic, Series(j), i, Labels(i), W, X)
		          gg.DrawPicture(FillPic, xx, Y)
		          
		        End If
		        
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          if DataLabel.Position = PositionLeft then
		            'If gg.StringWidth(str(Value, DataLabel.Format)) > W then
		            lblX = xx+2
		            'else
		            'lblX = W+2
		            'End If
		            
		            lblY = Y + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		            
		            DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y), False, PositionLeft)
		            
		          else //Force PositionInside
		            
		            lblX = X+W-2
		            lblY = Y + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		            
		            DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y), False, PositionInside)
		            
		          End If
		        End If
		        
		        
		        If W>=0 then
		          X = X + W '-Round(Value/MaxValue*H)
		        else
		          MinusX = MinusX - W
		        End If
		      Next
		    next
		    
		  Elseif Type = TypeBarStacked100 then
		    Dim TotalValue As Double
		    ColumnWidth = UnitWidth * 8/10
		    
		    Dim xx As Integer
		    
		    If DataLabel <> Nil then
		      gg.TextSize = DataLabel.TextSize
		      gg.TextFont = DataLabel.TextFont
		    End If
		    
		    //Going through all values
		    For i = 0 to U
		      
		      Y = Round(Offset + UnitWidth * i)
		      X = 0
		      
		      
		      TotalValue = 0.0
		      
		      Redim v(-1)
		      Redim v(nSeries)
		      
		      //Going through all series
		      For j = StartSerie to nSeries
		        
		        //Retrieving Value and Summing values
		        v(j) = GetValue(i, j) 'Series(j).Values(i)
		        TotalValue = TotalValue + v(j)
		        
		      Next
		      
		      If TotalValue = 0 then
		        Continue for i
		      End If
		      
		      //Drawing for each serie
		      For j = 0 to nSeries
		        
		        If V(j)=0.0 then
		          Continue for j
		        End If
		        
		        
		        Value = V(j)/TotalValue
		        
		        W =  Round(Value*H)
		        
		        //Preventing OutOfBoundsException
		        If Abs(W)>2^15-1 then
		          Continue for j
		        End If
		        
		        xx = X
		        
		        //Drawing
		        If Series(j).FillType = ChartSerie.FillSolid then
		          gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		          gg.FillRect(xx, Y, W, ColumnWidth)
		          
		        Elseif Series(j).FillType = ChartSerie.FillPicture then
		          FillPic = New Picture(Abs(W), ColumnWidth, 32)
		          
		          If Series(j).Transparency > 0 then
		            gf = FillPic.Mask.Graphics
		            gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		            gf.AAG_FillAll()
		          End If
		          
		          GetFillPicture(FillPic, Series(j), i, Labels(i), W, X)
		          gg.DrawPicture(FillPic, xx, Y)
		          
		        End If
		        
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          if DataLabel.Position = PositionLeft then
		            'If gg.StringWidth(str(Value, DataLabel.Format)) > W then
		            lblX = xx+2
		            'else
		            'lblX = W+2
		            'End If
		            
		            lblY = Y + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		            
		            DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y), False, PositionLeft)
		            
		          else //Force PositionInside
		            
		            lblX = X+W-2
		            lblY = Y + (ColumnWidth-gg.TextHeight)\2 + gg.TextAscent
		            
		            DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y), False, PositionInside)
		            
		          End If
		        End If
		        
		        
		        
		        X = X + W
		      next
		      
		    Next
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PlotBar_old(g As Graphics)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  
		  //All Charts Variables
		  Dim UnitWidth, UnitHeight As Double
		  Dim nSeries As Integer = UBound(Series)
		  Dim i, j, X, Y, H, W As Integer
		  Dim gg As Graphics
		  
		  
		  W = Plot.Width
		  UnitWidth = Axes(0).UnitWidth/Axes(0).MajorUnit
		  UnitHeight = Axes(1).UnitWidth
		  gg = g.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		  
		  
		  //Column & Area Variables
		  Dim Value As Double
		  Dim U As Integer
		  U = UBound(Labels)
		  
		  
		  
		  //Column Specific Variables
		  Dim Offset As Integer
		  Dim ColumnWidth As Integer
		  
		  Dim v() As Double
		  
		  Offset = Round(UnitWidth *1/10)
		  
		  If Type = TypeBar then //Simple columns
		    
		    ColumnWidth = UnitWidth / (nSeries+1) * 8/10
		    
		    
		    //Going through all values
		    For i = 0 to U
		      
		      
		      //Going through all series
		      For j = 0 to nSeries
		        
		        //Retrieving Value
		        Value = GetValue(i, j)
		        
		        If Value = 0 then
		          Continue for j
		        End If
		        
		        
		        Y = Round(Offset + UnitWidth * i) + j * ColumnWidth
		        
		        //Drawing
		        gg.ForeColor = Series(j).FillColor
		        gg.FillRect(0, Y, max(0, Round(Value*UnitHeight)), ColumnWidth) '-Round(Value/MaxValue*H))
		        
		        
		      Next
		    Next
		    
		  Elseif Type = TypeBarStacked then
		    
		    ColumnWidth = UnitWidth * 8/10
		    
		    //Going through all values
		    For i = 0 to U
		      
		      X = 0
		      Y = Round(Offset + UnitWidth * i)
		      
		      //Going through all series
		      For j = 0 to nSeries
		        
		        //Retrieving Value
		        Value = GetValue(i, j)
		        
		        If Value = 0 then
		          Continue for j
		        End If
		        
		        
		        //Drawing
		        gg.ForeColor = Series(j).FillColor
		        gg.FillRect(X, Y, max(0, Round(Value*UnitHeight)), ColumnWidth) '-Round(Value/MaxValue*H))
		        
		        X = X + Round(Value*UnitHeight) '-Round(Value/MaxValue*H)
		      Next
		    next
		    
		  Elseif Type = TypeBarStacked100 then
		    Dim TotalValue As Double
		    ColumnWidth = UnitWidth * 8/10
		    
		    
		    For i = 0 to U
		      
		      X = Round(Offset + UnitWidth * i)
		      Y = H
		      
		      TotalValue = 0.0
		      
		      Redim v(-1)
		      Redim v(nSeries)
		      
		      //Going through all series
		      For j = 0 to nSeries
		        
		        //Retrieving Value and Summing values
		        v(j) = GetValue(i, j) 'Series(j).Values(i)
		        TotalValue = TotalValue + v(j)
		        
		      Next
		      
		      If TotalValue = 0 then
		        Continue for i
		      End If
		      
		      //Drawing for each serie
		      For j = 0 to nSeries
		        
		        gg.ForeColor = Series(j).FillColor
		        gg.FillRect(X, Y, ColumnWidth, -max(1, Round(V(j)/TotalValue*H)))
		        
		        Y = Y - Round(V(j)/TotalValue*H)
		      next
		      
		    Next
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotBoxPlot(g As Graphics)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  
		  
		  
		  //All Charts Variables
		  Dim UnitWidth, UnitHeight, SecondUnitHeight As Double
		  Dim nSeries As Integer = UBound(Series)
		  Dim i, j, X, H As Integer
		  'Dim lblX, lblY As Integer
		  Dim Y As Double
		  'Dim MinusY As Double
		  Dim gg As Graphics = g
		  Dim StartSerie As Integer
		  
		  
		  
		  
		  H = Plot.Height
		  H = BaseDrawY
		  'UnitWidth = Axes(0).UnitWidth
		  UnitWidth = gg.Width/(Series.Ubound+1)
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  If UBound(Axes)>1 then
		    SecondUnitHeight = Axes(2).UnitWidth / Axes(2).MajorUnit
		  End If
		  
		  
		  Dim ShiftValue As Boolean
		  If Axes(1).LogarithmicScale = False and Axes(1).MinimumScale > 0 then
		    ShiftValue = True
		  End If
		  
		  //Column & Area Variables
		  Dim Value As Double
		  Dim NilValue As Boolean
		  Dim lastY As Double
		  'Dim strValue As String
		  Dim U As Integer
		  U = UBound(Labels)
		  
		  'Dim FillPic As Picture
		  'Dim gf As Graphics
		  
		  //Column Specific Variables
		  Dim Offset As Integer
		  Dim ColumnWidth As Integer
		  
		  'Dim v() As Double
		  
		  //If UnitWidth is very small, there is no offset
		  If UnitWidth < 5 then
		    Offset = 0
		  else
		    Offset = Round(UnitWidth *1/10)
		  End If
		  
		  Dim AntiAliased As Boolean
		  #if TargetDesktop
		    If TargetWin32 then ' and not App.UseGDIPlus then
		      AntiAliased = False
		    else
		      AntiAliased = true
		    End If
		  #elseif TargetWeb
		    AntiAliased = true
		  #endif
		  
		  
		  
		  
		  
		  //Setting ColumnWidth
		  //ColumnWidth is at least 1 px
		  
		  If UnitWidth < 4 then
		    ColumnWidth = max(1, UnitWidth)
		  Else
		    ColumnWidth = UnitWidth * 8.0/10.0
		  End If
		  
		  
		  
		  If DataLabel <> Nil then
		    gg.TextSize = DataLabel.TextSize
		    gg.TextFont = DataLabel.TextFont
		  End If
		  
		  
		  //Going through all series
		  For j = StartSerie To nSeries
		    
		    X = Round(Offset + UnitWidth * j)
		    lastY = 0
		    
		    //Going through all values
		    For i = 0 to U
		      
		      
		      
		      //Retrieving Value
		      Value = GetValue(i, j, NilValue, False)
		      
		      If NilValue then Continue for j
		      
		      
		      If ShiftValue then
		        Value = Value - Axes(1).MinimumScale
		      End If
		      
		      
		      
		      If Value = 0 Then
		        Continue For i
		      End If
		      
		      
		      
		      
		      'If Series(j).SecondaryAxis = False Then
		      'If Value>0 then
		      'Y = Max(1, Round(Value*UnitHeight))
		      'else
		      'Y = min(-1, Round(Value*UnitHeight))
		      'End If
		      'Else
		      
		      Y = H - Round((Value)*UnitHeight)
		      'If Value>0 then
		      'Y = Max(1, Round(Value*SecondUnitHeight))
		      'else
		      'Y = min(-1, Round(Value*SecondUnitHeight))
		      'End If
		      'End If
		      
		      
		      
		      gg.ForeColor = Series(j).FillColor
		      
		      //Horizontal line
		      If i = 0 Or i = 4 Then
		        
		        gg.DrawLine(X-ColumnWidth/2, Y, X+ColumnWidth/2, Y)
		        
		      End If
		      
		      //Vertical line
		      If i = 1 Or i = 4 Then
		        gg.DrawLine(X, lastY, X, Y)
		      End If
		      
		      
		      If i = 2 Or i = 3 Then
		        gg.DrawRect(X-ColumnWidth/2, y, ColumnWidth, lastY-y)
		        
		      End If
		      
		      If i = 2 Then
		        'gg.PenWidth = 2
		        gg.PenHeight = 2
		        gg.DrawLine(X-ColumnWidth/2, Y, X+ColumnWidth/2, Y)
		        'gg.PenWidth = 1
		        gg.PenHeight = 1
		      End If
		      
		      
		      //Additional datapoints
		      If i > 4 Then
		        
		        Dim sz As Integer = Min(ColumnWidth/2, 3)
		        
		        gg.DrawOval(X-sz, Y-sz, sz*2, sz*2)
		      End If
		      
		      
		      
		      //Drawing DataLabel
		      'If DataLabel <> Nil And Not AnimationInProgress Then
		      'lblX = Round(X + (ColumnWidth)/2)
		      '
		      'If Value>=0.0 then
		      'If H-Y < gg.TextAscent then
		      'lblY = H-Y + gg.TextAscent
		      'else
		      'lblY = H-Y-1
		      'End If
		      'else
		      'If H-Y+gg.TextHeight>Plot.Height then
		      'lblY = H-Y-1
		      'else
		      'lblY = H-Y+gg.TextAscent
		      'End If
		      'End If
		      'DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y))
		      'End If
		      
		      lastY = Y
		      
		    Next
		  Next
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotColumn(g As Graphics, OneSerie As Integer = - 1, MoreSeries As Integer = - 1)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  
		  
		  
		  //All Charts Variables
		  Dim UnitWidth, UnitHeight, SecondUnitHeight As Double
		  Dim nSeries As Integer = UBound(Series)
		  Dim i, j, X, H As Integer
		  Dim lblX, lblY As Integer
		  Dim Y As Double
		  Dim MinusY As Double
		  Dim gg As Graphics = g
		  Dim Type As Integer
		  Dim StartSerie As Integer
		  If OneSerie>-1 then
		    Type = me.Series(OneSerie).Type
		    StartSerie = OneSerie
		    If MoreSeries = -1 then
		      nSeries = OneSerie
		    Else
		      nSeries = MoreSeries + OneSerie
		    End If
		  else
		    Type = self.Type
		  End If
		  
		  H = Plot.Height
		  H = BaseDrawY
		  UnitWidth = Axes(0).UnitWidth
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  If UBound(Axes)>1 then
		    SecondUnitHeight = Axes(2).UnitWidth / Axes(2).MajorUnit
		  End If
		  
		  
		  Dim ShiftValue As Boolean
		  If Axes(1).LogarithmicScale = False and Axes(1).MinimumScale > 0 then
		    ShiftValue = True
		  End If
		  
		  //Column & Area Variables
		  Dim Value As Double
		  Dim NilValue As Boolean
		  'Dim strValue As String
		  Dim U As Integer
		  U = UBound(Labels)
		  
		  Dim FillPic As Picture
		  Dim gf As Graphics
		  
		  //Column Specific Variables
		  Dim Offset As Integer
		  Dim ColumnWidth As Integer
		  
		  Dim v() As Double
		  
		  //If UnitWidth is very small, there is no offset
		  If UnitWidth < 5 then
		    Offset = 0
		  else
		    Offset = Round(UnitWidth *1/10)
		  End If
		  
		  Dim AntiAliased As Boolean
		  #if TargetDesktop
		    If TargetWin32 then ' and not App.UseGDIPlus then
		      AntiAliased = False
		    else
		      AntiAliased = true
		    End If
		  #elseif TargetWeb
		    AntiAliased = true
		  #endif
		  
		  
		  
		  If Type = TypeColumn then //Simple columns
		    
		    //Setting ColumnWidth
		    //ColumnWidth is at least 1 px
		    If OneSerie>-1 and nSeries = OneSerie then
		      If UnitWidth < 4 then
		        ColumnWidth = max(1, UnitWidth)
		      else
		        ColumnWidth = UnitWidth * 8.0/10.0
		      End If
		      
		    else
		      If UnitWidth < 4 then
		        ColumnWidth = max(1, UnitWidth / (nSeries+1))
		      else
		        If BarOverLapRatio=0.0 then
		          ColumnWidth = UnitWidth / (nSeries+1) * 8.0/10.0 ' * (1.0 + BarOverLapRatio)
		        else
		          ColumnWidth = UnitWidth * 8.0/10.0 * (1/BarOverLapRatio) / (1/BarOverLapRatio*(nSeries+1)-nSeries)
		        End If
		        
		      End If
		    End If
		    
		    If DataLabel <> Nil then
		      gg.TextSize = DataLabel.TextSize
		      gg.TextFont = DataLabel.TextFont
		    End If
		    
		    
		    //Going through all values
		    For i = 0 to U
		      
		      
		      //Going through all series
		      For j = StartSerie to nSeries
		        
		        //Retrieving Value
		        Value = GetValue(i, j, NilValue, False)
		        
		        If NilValue then Continue for j
		        
		        
		        If ShiftValue then
		          Value = Value - Axes(1).MinimumScale
		        End If
		        
		        If Value = 0 then
		          Continue for j
		        End If
		        
		        If OneSerie>-1 and StartSerie = nSeries then
		          X = Round(Offset + UnitWidth * i)
		        else
		          X = Round(Offset + UnitWidth * i + j * ColumnWidth-(ColumnWidth*BarOverLapRatio))
		        End If
		        If Series(j).SecondaryAxis = False then
		          If Value>0 then
		            Y = max(1, Round(Value*UnitHeight))
		          else
		            Y = min(-1, Round(Value*UnitHeight))
		          End If
		        else
		          If Value>0 then
		            Y = max(1, Round(Value*SecondUnitHeight))
		          else
		            Y = min(-1, Round(Value*SecondUnitHeight))
		          End If
		        End If
		        
		        //Drawing
		        If Series(j).Transparency = 0 then //No transparency
		          
		          If Series(j).FillType = ChartSerie.FillSolid then
		            gg.ForeColor = Series(j).FillColor
		            If Y<0 then
		              gg.FillRect(X, H, ColumnWidth, -Y)
		            else
		              gg.FillRect(X, H-Y, ColumnWidth, Y)
		            End If
		          elseif Series(j).FillType = ChartSerie.FillPicture then
		            FillPic = New Picture(ColumnWidth, Abs(Y), 32)
		            GetFillPicture(FillPic, Series(j), i, Labels(i), X, H-Y)
		            gg.DrawPicture(FillPic, X, H-Max(0,Y))
		          End If
		          
		        else //Has transparency
		          
		          #If TargetDesktop
		            if Series(j).FillType = ChartSerie.FillSolid and TargetMacOS then '(TargetMacOS or App.UseGDIPlus) Then
		              gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		              If Y<0 then
		                gg.FillRect(X, H, ColumnWidth, -Y)
		              else
		                gg.FillRect(X, H-Y, ColumnWidth, Y)
		              End If
		              
		            else
		              
		              FillPic = New Picture(ColumnWidth, Abs(Y), 32)
		              gf = FillPic.Mask.Graphics
		              gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		              gf.AAG_FillAll()
		              
		              If Series(j).FillType = ChartSerie.FillSolid then
		                gf = FillPic.Graphics
		                gf.ForeColor = Series(j).FillColor
		                gf.AAG_FillAll
		              elseif Series(j).FillType = ChartSerie.FillPicture then
		                GetFillPicture(FillPic, Series(j), i, Labels(i), X, H-Y)
		              End If
		              
		              gg.DrawPicture(FillPic, X, H-max(0,Y))
		            end if
		          #Elseif TargetWeb
		            //A corriger web peut-etre
		            If Series(j).FillType = ChartSerie.FillSolid then
		              gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		              If Y<0 then
		                gg.FillRect(X, H, ColumnWidth, -Y)
		              else
		                gg.FillRect(X, H-Y, ColumnWidth, Y)
		              End If
		            Else
		              FillPic = New Picture(ColumnWidth, Abs(Y), 32)
		              gf = FillPic.Mask.Graphics
		              gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		              gf.AAG_FillAll()
		              GetFillPicture(FillPic, Series(j), i, Labels(i), X, H-Y)
		              gg.DrawPicture(FillPic, X, H-max(0,Y))
		            End If
		          #endif
		          
		        End If
		        
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          lblX = Round(X + (ColumnWidth)/2)
		          
		          If Value>=0.0 then
		            If H-Y < gg.TextAscent then
		              lblY = H-Y + gg.TextAscent
		            else
		              lblY = H-Y-1
		            End If
		          else
		            If H-Y+gg.TextHeight>Plot.Height then
		              lblY = H-Y-1
		            else
		              lblY = H-Y+gg.TextAscent
		            End If
		          End If
		          DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Abs(Y))
		        End If
		        
		        
		      Next
		    Next
		    
		  Elseif Type = TypeColumnStacked then
		    
		    ColumnWidth = UnitWidth * 8/10
		    
		    Dim yy As Double
		    
		    //Going through all values
		    For i = 0 to U
		      
		      X = Round(Offset + UnitWidth * i)
		      Y = H
		      MinusY = H
		      
		      //Going through all series
		      For j = StartSerie to nSeries
		        
		        //Retrieving Value
		        Value = GetValue(i, j)
		        
		        If Value = 0.0 then
		          Continue for j
		        End If
		        
		        yy = Value*UnitHeight
		        
		        
		        //Drawing
		        If Antialiased or Series(j).Transparency = 0 then //No transparency
		          
		          If Series(j).FillType = ChartSerie.FillSolid then
		            gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		            If Value>0 then
		              gg.FillRect(X, Y-yy, ColumnWidth, max(1, Ceil(yy)))
		            else
		              gg.FillRect(X, Floor(MinusY), ColumnWidth, max(0, Ceil(Abs(yy))))
		            End If
		          elseif Series(j).FillType = ChartSerie.FillPicture then
		            FillPic = New Picture(ColumnWidth, max(1, yy), 32)
		            GetFillPicture(FillPic, Series(j), i, Labels(i), X, Y-yy)
		            If Series(j).Transparency > 0 then
		              gf = FillPic.Mask.Graphics
		              gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		              gf.AAG_FillAll()
		            End If
		            
		            If Value>0 then
		              gg.DrawPicture(FillPic, X, Y-yy)
		            else
		              gg.DrawPicture(FillPic, X, Floor(MinusY))
		            End If
		          End If
		          
		        else //Has transparency
		          
		          FillPic = New Picture(ColumnWidth, Ceil(Abs(yy)), 32)
		          gf = FillPic.Mask.Graphics
		          gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		          gf.AAG_FillAll()
		          
		          If Series(j).FillType = ChartSerie.FillSolid then
		            gf = FillPic.Graphics
		            gf.ForeColor = Series(j).FillColor
		            gf.AAG_FillAll
		          elseif Series(j).FillType = ChartSerie.FillPicture then
		            GetFillPicture(FillPic, Series(j), i, Labels(i), X, Y-yy)
		          End If
		          
		          If Value>0 then
		            gg.DrawPicture(FillPic, X, Y-yy)
		          else
		            gg.DrawPicture(FillPic, X, Floor(MinusY))
		          End If
		        End If
		        
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          lblX = Round(X + (ColumnWidth)/2)
		          
		          If Value>=0 then
		            lblY = Y-yy+g.TextAscent
		          else
		            lblY = Floor(MinusY)+Abs(yy)-1
		          End If
		          
		          DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, Ceil(Abs(yy)))
		        End If
		        
		        
		        If yy>=0 then
		          Y = Y - yy '-Round(Value/MaxValue*H)
		        else
		          MinusY = MinusY - yy
		        End If
		      Next
		    next
		    
		  Elseif Type = TypeColumnStacked100 then
		    Dim TotalValue As Double
		    ColumnWidth = UnitWidth * 8/10
		    
		    Dim yy As Integer
		    
		    If DataLabel <> Nil then
		      gg.TextSize = DataLabel.TextSize
		      gg.TextFont = DataLabel.TextFont
		    End If
		    
		    //Going through all values
		    For i = 0 to U
		      
		      X = Round(Offset + UnitWidth * i)
		      Y = H
		      
		      TotalValue = 0.0
		      
		      Redim v(-1)
		      Redim v(nSeries)
		      
		      //Going through all series
		      For j = StartSerie to nSeries
		        
		        //Retrieving Value and Summing values
		        v(j) = GetValue(i, j) 'Series(j).Values(i)
		        TotalValue = TotalValue + v(j)
		        
		      Next
		      
		      If TotalValue = 0 then
		        Continue for i
		      End If
		      
		      //Drawing for each serie
		      For j = 0 to nSeries
		        
		        If V(j)=0.0 then
		          Continue for j
		        End If
		        
		        
		        Value = V(j)/TotalValue
		        
		        yy =  Round(Value*H)
		        
		        //Preventing OutOfBoundsException
		        If Abs(yy)>2^15-1 then
		          Continue for j
		        End If
		        
		        //Drawing
		        If Series(j).Transparency = 0 then //No transparency
		          
		          If Series(j).FillType = ChartSerie.FillSolid then
		            gg.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		            gg.ForeColor = Series(j).FillColor
		            If Value>0 then
		              gg.FillRect(X, Y-yy, ColumnWidth, max(1, Ceil(yy)))
		            else
		              gg.FillRect(X, Floor(MinusY), ColumnWidth, max(0, Ceil(Abs(yy))))
		            End If
		          elseif Series(j).FillType = ChartSerie.FillPicture then
		            FillPic = New Picture(ColumnWidth, max(1, yy), 32)
		            GetFillPicture(FillPic, Series(j), i, Labels(i), X, Y-yy)
		            
		            If Value>0 then
		              gg.DrawPicture(FillPic, X, Y-yy)
		            else
		              gg.DrawPicture(FillPic, X, Floor(MinusY))
		            End If
		          End If
		          
		        else //Has transparency
		          FillPic = New Picture(ColumnWidth, Ceil(Abs(yy)), 32)
		          gf = FillPic.Mask.Graphics
		          gf.ForeColor = TransparencyPercentage(Series(j).Transparency)
		          gf.AAG_FillAll()
		          
		          If Series(j).FillType = ChartSerie.FillSolid then
		            gf = FillPic.Graphics
		            gf.ForeColor = Series(j).FillColor
		            gf.AAG_FillAll
		          elseif Series(j).FillType = ChartSerie.FillPicture then
		            GetFillPicture(FillPic, Series(j), i, Labels(i), X, Y-yy)
		          End If
		          
		          If Value>0 then
		            gg.DrawPicture(FillPic, X, Y-yy)
		          else
		            gg.DrawPicture(FillPic, X, Floor(MinusY))
		          End If
		        End If
		        
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          lblX = Round(X + (ColumnWidth)/2)
		          lblY = Y-yy+g.TextAscent
		          'If H-yy < gg.TextAscent then
		          'lblY = H-Y + gg.TextAscent
		          'else
		          'lblY = Y-yy
		          'End If
		          If DataLabel.DisplayRealValue then
		            DrawDataLabel(g, Series(j), Value*TotalValue, lblX, lblY, ColumnWidth, max(1, yy))
		          else
		            DrawDataLabel(g, Series(j), Value, lblX, lblY, ColumnWidth, max(1, yy))
		          End If
		        End If
		        
		        
		        
		        Y = Y - yy
		      next
		      
		    Next
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotCombo(gp As Graphics)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  Dim DrawnTypes As New Dictionary
		  
		  Dim i As Integer, Useries As Integer
		  Useries = UBound(Series)
		  
		  Dim ColumnSeries() As Integer
		  
		  For i = 0 to Useries
		    
		    If Series(i).MarkLine then
		      Continue for i
		    End If
		    
		    If UBound(ColumnSeries)>-1 and Series(i).Type\100 <> TypeColumn\100 and not DrawnTypes.HasKey(TypeColumn) then
		      Dim FirstColumn As Integer = ColumnSeries(0)
		      ColumnSeries.Remove(0)
		      
		      PlotColumn(gp, FirstColumn, UBound(ColumnSeries)+1)
		      Redim ColumnSeries(-1)
		      DrawnTypes.Value(TypeColumn) = True
		    End If
		    
		    If Series(i).Type\100 = TypeColumn\100 then
		      
		      ColumnSeries.Append i
		      
		      'If DrawnTypes.HasKey(TypeColumn) then Continue
		      
		      'PlotColumn(gp, i)
		      'DrawnTypes.Value(TypeColumn) = True
		      
		    Elseif Series(i).Type = TypeLineSmooth or Series(i).type = TypeLineStackedSmooth then
		      
		      PlotSpline(gp, i)
		      
		    Elseif Series(i).Type\100 = TypeLine\100 then
		      
		      PlotLine(gp, i)
		      
		    Elseif Series(i).Type\100 = TypeArea\100 then
		      
		      PlotArea(gp, i)
		      
		      'Elseif Series(i).Type\100 = TypeBar\100 then
		      
		      'PlotBar(gg)
		      
		    End If
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotLine(g As Graphics, OneSerie As Integer = -1, UseCurrentPts As Boolean = False)
		  
		  Dim UnitWidth As Double
		  Dim UnitHeight, UnitHeightsecondary, mUnitHeight As Double
		  
		  Dim nSeries As Integer = UBound(Series)
		  Dim Offset As Integer
		  Dim i, j, X, Y, ULabels As Integer
		  Dim H As Integer
		  Dim maximum As Double
		  Dim Type As Integer
		  Dim cSerie As ChartSerie
		  Dim StartSerie As Integer
		  If OneSerie>-1 then
		    Type = me.Series(OneSerie).Type
		    StartSerie = OneSerie
		    nSeries = OneSerie
		  Elseif OneSerie<-9 then
		    StartSerie = OneSerie
		    nSeries = OneSerie
		  else
		    Type = self.Type
		  End If
		  
		  'Dim startScale As Integer = Axes(0).MinimumScale
		  'Dim endScale As Integer = Axes(0).MaximumScale
		  
		  
		  H = BaseDrawY
		  UnitWidth = Axes(0).UnitWidth
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  If UBound(Axes) > 1 then
		    UnitHeightsecondary = Axes(2).UnitWidth/Axes(2).MajorUnit
		  End If
		  
		  Dim Value As Double
		  Dim NilValue, NilXValue As Boolean
		  Dim LastNilValue As Boolean
		  'Dim LastForeColor As Color
		  Dim LastX As Integer
		  Dim LastY As Integer
		  Dim ShiftValue As Double
		  'If Axes(1).LogarithmicScale = False and Axes(1).MinimumScale <> 0 then
		  'ShiftValue = True
		  'End If
		  
		  ULabels = UBound(Labels)
		  If ULabels = -1 then Return
		  
		  'Dim Precision As Double = 1.0
		  'Precision = max(1, Round(0.5/Axes(0).UnitWidth))
		  
		  
		  
		  Offset = UnitWidth *1/10
		  
		  'Dim MarkerRadius As Single = 4.5
		  
		  Dim FillPic As Picture
		  Dim gg As Graphics
		  //Keeping the color of the line as it is reset by DrawDataLabel
		  Dim origColor As Color
		  
		  
		  For j = StartSerie to nSeries
		    
		    If j>-1 then
		      cSerie = Series(j)
		    elseif j<-9 then
		      cSerie = MarkSeries(-j-10)
		    End If
		    
		    If not UseCurrentPts then
		      Redim cSerie.mPts(-1)
		    End If
		    
		    ShiftValue = 0.0
		    
		    If cSerie.SecondaryAxis then
		      maximum = maxValueSecondary
		      mUnitHeight = UnitHeightsecondary
		      If Axes(2).LogarithmicScale = False and Axes(2).MinimumScale <> 0 then
		        'ShiftValue = Axes(2).MinimumScale
		      End If
		    else
		      maximum = maxValue
		      mUnitHeight = UnitHeight
		      If Axes(1).LogarithmicScale = False and Axes(1).MinimumScale <> 0 then
		        'ShiftValue = Axes(1).MinimumScale
		      End If
		    End If
		    
		    If cSerie.FillType = ChartSerie.FillPicture then
		      FillPic = New Picture(g.Width, g.Height, 32)
		      GetFillPicture(FillPic, cSerie, -1, "", 0, 0)
		      gg = FillPic.mask.graphics
		      gg.ForeColor = &cFFFFFF
		      gg.AAG_FillAll()
		      gg.ForeColor = &c0
		      
		      //Fix for AreaStepped
		      g.ForeColor = cSerie.FillColor
		    else
		      gg = g
		      gg.ForeColor = cSerie.FillColor
		    End If
		    gg.PenWidth = cSerie.LineWeight
		    gg.PenHeight = cSerie.LineWeight
		    
		    origColor = gg.ForeColor
		    
		    
		    If Type <> TypeAreaStepped and Type <> TypeTrendAreaStepped then //Regular lines
		      
		      For i = 0 to ULabels Step Precision
		        
		        If UseCurrentPts then
		          
		          If cSerie.mPts(i/Precision) is Nil then
		            LastNilValue = True
		            Continue for i
		            
		          else
		            
		            X = cSerie.mPts(i/Precision).X
		            Y = cSerie.mPts(i/Precision).Y
		            NilValue = False
		          End If
		          
		        else
		          Value = GetValue(i, j, NilValue, False)
		          
		          X = GetX(i, j, NilXValue)
		          If NilXValue then
		            If CrossesBetweenTickMarks then
		              X = Round(UnitWidth * i + UnitWidth/2)
		            else
		              X = Round(UnitWidth * i)
		            End If
		          End If
		          
		          'If ShiftValue then
		          Y = H - Round((Value)*mUnitHeight) //Round((Value-ShiftValue)*mUnitHeight)
		          'else
		          'Y = H - Round(Value*mUnitHeight)
		          'End If
		          
		          If NilValue then
		            cSerie.mPts.append Nil
		            LastNilValue = True
		            Continue for i
		          else
		            cSerie.mPts.append New REALbasic.Point(X, Y)
		          End If
		        End If
		        
		        If not LastNilValue and i>0 then
		          'If App.UseGDIPlus or TargetMacOS then
		          
		          If cSerie.Shadow then
		            gg.ForeColor = cSerie.ShadowColor
		            gg.DrawLine(LastX, LastY+gg.PenHeight, X, Y+gg.PenHeight)
		            gg.ForeColor = origColor
		          End If
		          
		          gg.AAG_DrawDottedLineA(LastX, LastY, X, Y, 3, 1)
		          'gg.DrawLine(LastX, LastY, X, Y)
		          'else
		          'gg.AAG_DrawLineA(LastX, LastY, X, Y, cSerie.LineWeight)
		          'End If
		        End If
		        
		        //Drawing Marker
		        DrawMarker(gg, cSerie, X, Y)
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          If UseCurrentPts then
		            Value = GetValue(i, j, NilValue, False)
		          End If
		          If cSerie.FillType = ChartSerie.FillPicture then
		            DrawDataLabel(gg, cSerie, Value, X, Y-cSerie.MarkerSize, 1, 1, true)
		            DrawDataLabel(Fillpic.Graphics, cSerie, Value, X, Y-cSerie.MarkerSize, 1, 1)
		          else
		            DrawDataLabel(gg, cSerie, Value, X, Y-cSerie.MarkerSize, 1, 1)
		          End If
		        End If
		        
		        //Set the color again as it was changed by DrawDataLabel
		        gg.ForeColor = origColor
		        
		        
		        LastNilValue = NilValue
		        
		        LastX = X
		        LastY = Y
		        
		      Next
		      
		      If cSerie.FillType = ChartSerie.FillPicture then
		        g.DrawPicture(FillPic, 0, 0)
		      End If
		      
		    else //Countour lines
		      
		      If UseCurrentPts then
		        LastX = cSerie.mPts(0).X
		        LastY = cSerie.mPts(0).Y
		        
		      else
		        Value = GetValue(0,j, NilValue, False)
		        
		        If CrossesBetweenTickMarks then
		          LastX = Round(UnitWidth/2)
		        else
		          LastX = 0
		        End If
		        
		        'If ShiftValue then
		        'LastY = H - Round((Value-Axes(1).MinimumScale)*mUnitHeight)
		        'else
		        'LastY = H - Round(Value*mUnitHeight)
		        'End If
		        LastY = H - Round((Value-ShiftValue)*mUnitHeight)
		      End If
		      
		      //Keeping the color of the line as it is reset by DrawDataLabel
		      origColor = gg.ForeColor
		      
		      
		      If NilValue then
		        If not UseCurrentPts then
		          cSerie.mPts.Append Nil
		        End If
		      else
		        If not UseCurrentPts then
		          cSerie.mPts.append New REALbasic.Point(LastX, LastY)
		        End If
		        
		        
		        //Drawing the first Marker
		        If Type <> TypeAreaStepped and Type <> TypeTrendAreaStepped then
		          DrawMarker(gg, cSerie, LastX, LastY)
		        End If
		        
		        //Drawing DataLabel
		        If DataLabel <> Nil and not AnimationInProgress then
		          If UseCurrentPts then
		            Value = GetValue(i, j)
		          End If
		          If cSerie.FillType = ChartSerie.FillPicture then
		            DrawDataLabel(gg, cSerie, Value, LastX, LastY-cSerie.MarkerSize, 1, 1, true)
		            DrawDataLabel(Fillpic.Graphics, cSerie, Value, LastX, LastY-cSerie.MarkerSize, 1, 1)
		          else
		            DrawDataLabel(gg, cSerie, Value, LastX, LastY-cSerie.MarkerSize, 1, 1)
		          End If
		        End If
		        
		        //Set the color again as it was changed by DrawDataLabel
		        gg.ForeColor = origColor
		        
		      End If
		      
		      LastNilValue = NilValue
		      
		      
		      LastX = 0
		      
		      For i = 1 to ULabels Step Precision
		        
		        Value = GetValue(i, j, NilValue, False)
		        
		        
		        'If CrossesBetweenTickMarks then
		        'X = Round(UnitWidth * i + UnitWidth/2)
		        'else
		        X = Round(UnitWidth * i)
		        'End If
		        
		        Y = H - Round(Value*mUnitHeight)
		        
		        If not NilValue then
		          
		          #if TargetDesktop
		            If TargetMacOS then 'or App.UseGDIPlus then
		              g.DrawLine(LastX, LastY, X, LastY)
		              g.DrawLine(X, LastY, X, Y)
		            else
		              g.AAG_DrawLineA(LastX, LastY, X, LastY, cSerie.LineWeight)
		              g.AAG_DrawLineA(X, LastY, X, Y, cSerie.LineWeight)
		            End If
		          #elseif TargetWeb
		            //A Corriger web peutetre
		            g.DrawLine(LastX, LastY, X, LastY)
		            g.DrawLine(X, LastY, X, Y)
		          #endif
		          
		          LastNilValue = NilValue
		          
		          
		          //Do not draw marker
		          
		          
		          //Drawing DataLabel
		          If DataLabel <> Nil and not AnimationInProgress then
		            'If UseCurrentPts then
		            'Value = GetValue(i, cSerie)
		            'End If
		            If cSerie.FillType = ChartSerie.FillPicture then
		              DrawDataLabel(gg, cSerie, Value, X+UnitWidth\2, Y-cSerie.MarkerSize, 1, 1, true)
		              DrawDataLabel(Fillpic.Graphics, cSerie, Value, X+UnitWidth\2, Y-cSerie.MarkerSize, 1, 1)
		            else
		              DrawDataLabel(gg, cSerie, Value, X+UnitWidth\2, Y-cSerie.MarkerSize, 1, 1)
		              gg.ForeColor = cSerie.FillColor
		            End If
		          End If
		        End If
		        
		        
		        LastX = X
		        LastY = Y
		        
		      Next
		      
		      //Drawing last line
		      X = Round(UnitWidth * (ULabels+1))
		      #if TargetDesktop
		        If TargetMacOS then 'or App.UseGDIPlus then
		          g.DrawLine(LastX, LastY, X, LastY)
		        else
		          g.AAG_DrawLineA(LastX, LastY, X, LastY, cSerie.LineWeight)
		        End If
		      #elseif TargetWeb
		        //A corriger web peutetre
		        g.DrawLine(LastX, LastY, X, LastY)
		      #endif
		      
		    End If
		    
		  Next
		  
		  'elseif Type = TypeLineStacked then
		  
		  
		  
		  'Elseif Type = TypeColumnStacked then
		  '
		  'ColumnWidth = UnitWidth * 8/10
		  '
		  'For i = startScale to endScale
		  '
		  'X = Round(Offset + UnitWidth * i)
		  'Y = H
		  '
		  'For j = 0 to nSeries
		  '
		  'v() = cSerie.Values
		  'Value = v(i)
		  '
		  'g.ForeColor = cSerie.FillColor
		  'g.FillRect(X, Y, ColumnWidth, -Round(Value/MaxValue*H))
		  '
		  'Y = Y -Round(Value/MaxValue*H)
		  'Next
		  'next
		  '
		  'Elseif Type = TypeColumnStacked100 then
		  'Dim TotalValue As Double
		  'ColumnWidth = UnitWidth * 8/10
		  '
		  '
		  'For i = startScale to endScale
		  '
		  'X = Round(Offset + UnitWidth * i)
		  'Y = H
		  '
		  'TotalValue = 0.0
		  '
		  'Redim v(-1)
		  'Redim v(nSeries)
		  '
		  'For j = 0 to nSeries
		  '
		  'v(j) = cSerie.Values(i)
		  'TotalValue = TotalValue + v(j)
		  '
		  'Next
		  '
		  'For j = 0 to nSeries
		  '
		  'g.ForeColor = cSerie.FillColor
		  'g.FillRect(X, Y, ColumnWidth, -Round(V(j)/TotalValue*H))
		  '
		  'Y = Y - Round(V(j)/TotalValue*H)
		  'next
		  '
		  'Next
		  
		  'End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotPie(g As Graphics)
		  
		  
		  Dim X, Y As Integer
		  'Dim R As Integer
		  Dim Rx, Ry As Integer
		  
		  
		  X = g.Width\2
		  Y = g.Height\2
		  
		  Dim texth As Integer
		  Dim textw As Integer
		  If DataLabel <> Nil then
		    g.TextSize = DataLabel.TextSize
		    g.TextFont = DataLabel.TextFont
		    texth = g.TextHeight()
		    textw = DataLabel.maxWidth
		  End If
		  
		  
		  Rx = (Min(g.Width-textw*2,g.height-texth*2)-30)*.95
		  
		  
		  If AnimationInProgress Then
		    If AnimationType = AnimateLinear Then
		      Rx = Rx*AnimationPercent/100.0
		    Else
		      Rx = Rx*ChartAnimate.getEaseValue(AnimationType, AnimationPercent, 0, 100.0, 100.0) / 100.0
		    End If
		  End If
		  
		  If Type = TypePie3D then
		    
		    Ry = Rx*.8
		    Y = texth + Ry*0.6
		  else
		    
		    Ry = Rx
		    Y = texth + Ry/2
		  End If
		  
		  Plot.Radius = Rx
		  
		  
		  Dim mDoughnutRadius As Integer
		  If DoughnutRadius>=1 then
		    mDoughnutRadius = min(DoughnutRadius, Rx\2-10)
		  else
		    mDoughnutRadius = Rx*DoughnutRadius/2.0
		  End If
		  
		  Const PI=3.14159265358979323846264338327950
		  
		  
		  Dim startA As Double = wrapto2PI(PieRadarAngle)
		  Dim TotalValue As Double
		  Dim a As ArcShape
		  Dim v() As Double
		  Dim j As Integer
		  Dim uValues As Integer
		  Dim ang() As Double
		  
		  
		  TotalValue = 0.0
		  
		  Redim v(-1)
		  
		  
		  //Going through all series
		  
		  
		  Redim v(Series.Ubound)
		  uValues = UBound(v)
		  Redim ang(uValues)
		  For j = 0 To uValues
		    
		    //Initializing saved data
		    Redim Series(j).mPts(0)
		    Redim Series(j).mStartAngles(0)
		    Redim Series(j).mArcAngles(0)
		    
		    //Retrieving Value and Summing values
		    v(j) = GetValue(0, j) 
		    TotalValue = TotalValue + v(j)
		  Next
		  
		  
		  Redim SelectedSlice(uValues)
		  
		  
		  If TotalValue=0 Then Return
		  
		  
		  Dim gp As Graphics
		  Dim ForceAntiAlias As Boolean
		  Dim tmp As Picture
		  If BackgroundType > BackgroundNone Then
		    ForceAntiAlias = True
		    tmp = New Picture(g.Width, g.Height, 32)
		    gp = tmp.Graphics
		    //Rx = Rx+5
		  Else
		    
		    gp = g
		  End If
		  
		  Dim mpts() As REALbasic.Point
		  Redim mpts(uValues)
		  Dim mColors() As REALbasic.Point
		  Redim mColors(uValues)
		  
		  If Type = TypePie3D then
		    Dim fx As FigureShape
		    Dim xA, yA As Integer
		    Dim fxs() As FigureShape
		    Dim fxa() As Double
		    
		    For j = 0 to uValues
		      
		      
		      
		      a = New ArcShape
		      a.StartAngle = startA
		      a.ArcAngle = 2.0*PI*v(j)/TotalValue
		      
		      a.FillColor = AlphaColor(Series(j).FillColor, Series(0).Transparency)
		      a.FillColor = RGB(a.FillColor.Red*.8, a.FillColor.Green*.8, a.FillColor.Blue*.8)
		      
		      
		      a.Border = 0
		      a.BorderWidth = 0.0
		      a.BorderColor = &cFF0000
		      a.Width = Rx
		      a.Height = Ry
		      a.Segments = 10000
		      a.Scale = 1
		      
		      ang(j) = startA
		      
		      If SelectedSlice(j) Then
		        a.X = X+Cos((ang(j)+startA+a.ArcAngle)/2.0)*(Rx*0.05)
		        a.Y = Y+20+Sin((ang(j)+startA+a.ArcAngle)/2.0)*(Ry*0.05)
		        
		      Else
		        a.X = X
		        a.Y = Y+20
		      End If
		      
		      xA = Round(X+Cos(startA)*Rx/2.0)
		      yA = Round(Y+Sin(startA)*Ry/2.0)
		      
		      
		      
		      //Saving the data
		      Series(j).mPts(0) = New REALbasic.Point(Round(a.X+Cos(startA)*Rx/2.0), Round(a.Y+Sin(startA)*Ry/2.0))
		      
		      'g.ForeColor = a.FillColor
		      'g.DrawLine(Series(j).mPts(0).X, Series(j).mPts(0).Y, Series(j).mPts(0).X, Series(j).mPts(0).Y-20)
		      
		      
		      gp.DrawObject(a, 0, 0)
		      
		      
		      
		      
		      
		      
		      fx = new FigureShape
		      If SelectedSlice(j) then
		        xA = Round(a.X+Cos(startA)*Rx/2.0)
		        yA = Round(a.Y-20.0+Sin(startA)*Ry/2.0)
		      End If
		      fx.AddLine(a.X, a.Y-20, xA, yA)
		      fx.AddLine(xA, yA, xA, yA+20)
		      fx.AddLine(xA, yA+20, a.X, a.Y)
		      fx.FillColor = a.FillColor
		      fxs.Append fx
		      fxa.Append startA
		      
		      startA = wrapto2PI(startA + a.ArcAngle)
		      
		      fx = new FigureShape
		      If SelectedSlice(j) then
		        xA = Round(a.X+Cos(startA)*Rx/2.0)
		        yA = Round(a.Y-20.0+Sin(startA)*Ry/2.0)
		      Else
		        xA = Round(a.X+Cos(startA)*Rx/2.0)
		        yA = Round(a.Y-20.0+Sin(startA)*Ry/2.0)
		      End If
		      fx.AddLine(a.X, a.Y-20, xA, yA)
		      fx.AddLine(xA, yA, xA, yA+20)
		      fx.AddLine(xA, yA+20, a.X, a.Y)
		      fx.FillColor = a.FillColor
		      fxs.Append fx
		      fxa.Append startA - 0.00001
		    Next
		    
		    startA = wrapto2PI(PieRadarAngle)
		    
		    OrderFXA(fxs, fxa)
		    For j = 0 to UBound(fxs)
		      fx = fxs(j)
		      gp.DrawObject(fx, 0, 0)
		    Next
		  End If
		  
		  
		  For j = 0 To uValues
		    
		    If v(j) = 0.0 then Continue for j
		    
		    
		    
		    
		    
		    a = New ArcShape
		    a.StartAngle = startA
		    a.ArcAngle = 2.0*PI*v(j)/TotalValue
		    
		    If v(j) = TotalValue then
		      g.ForeColor = AlphaColor(Series(j).FillColor, Series(0).Transparency)
		      
		      g.FillOval(X-Rx/2.0, Y-Ry/2.0, Rx, Ry)
		      
		    Else
		      
		      a.FillColor = AlphaColor(Series(j).FillColor, Series(0).Transparency)
		      
		      
		      a.Border = 0
		      a.BorderWidth = 0.0
		      a.BorderColor = &cFF0000
		      a.Width = Rx
		      a.Height = Ry
		      a.Segments = 10000
		      a.Scale = 1
		      
		      
		      ang(j) = startA
		      
		      If SelectedSlice(j) Then
		        a.X = X+Cos((ang(j)+startA+a.ArcAngle)/2.0)*(Rx*0.05)
		        a.Y = Y+Sin((ang(j)+startA+a.ArcAngle)/2.0)*(Ry*0.05)
		        
		      Else
		        a.X = X
		        a.Y = Y
		      End If
		      
		      //Saving the data
		      
		      Series(j).mPts(0) = New REALbasic.Point(a.X, a.Y)
		      Series(j).mStartAngles(0) = startA
		      Series(j).mArcAngles(0) = a.ArcAngle
		      
		      
		      
		      //Drawing the object
		      If Series(j).FillType = ChartSerie.FillPicture then
		        Dim p As Picture = New Picture(g.Width, g.Height, 32)
		        a.FillColor = &c0
		        p.Mask.Graphics.ForeColor = &cFFFFFF
		        p.Mask.Graphics.AAG_FillAll()
		        p.Mask.Graphics.DrawObject(a, 0, 0)
		        GetFillPicture(p, Series(j), 0, "", a.X, a.Y)
		        gp.DrawPicture(p, 0, 0)
		      else
		        gp.DrawObject(a, 0, 0)
		      End If
		    End If
		    
		    
		    If Not AnimationInProgress and DataLabel <> Nil then
		      If SelectedSlice(j) then
		        DrawDataLabelPie(gp, Series(j), v(j), X, Y, (Ry*1.09)/2, (ang(j)+startA+a.ArcAngle)/2.0, ForceAntiAlias)
		      else
		        DrawDataLabelPie(gp, Series(j), v(j), X, Y, Ry/2, (ang(j)+startA+a.ArcAngle)/2.0, ForceAntiAlias)
		      End If
		    End If
		    
		    startA = startA + a.ArcAngle
		    
		  Next
		  
		  If ForceAntiAlias Then
		    gp = tmp.Mask.Graphics
		    gp.ForeColor = &cFFFFFF
		    gp.AAG_FillAll
		    gp.ForeColor = &c0
		    'R = R-5
		    gp.AAG_FillOvalA(X, Y, Rx, Ry, 1)
		    
		    //Drawing separation lines
		    gp.ForeColor = &cFFFFFF
		    For j = 0 To uValues
		      
		      gp.DrawLine(X, Y, X+Cos(ang(j))*Rx/2.0, Y+Sin(ang(j))*Ry/2.0)
		      
		    Next
		    
		    If Type = TypeDougnut Then
		      gp.ForeColor = &cFFFFFF
		      gp.AAG_FillOvalA(X, Y, mDoughnutRadius*2, mDoughnutRadius*2, 1)
		    End If
		    
		    g.DrawPicture(tmp, 0, 0)
		    
		  Else
		    g.ForeColor = &cFFFFFF
		    
		    If Type = TypeDougnut Then
		      g.FillOval(X-mDoughnutRadius, Y-mDoughnutRadius, mDoughnutRadius*2, mDoughnutRadius*2)
		    End If
		    
		    For j = 0 To uValues
		      
		      If Type = TypeDougnut and SelectedSlice(j) then
		        a = new ArcShape
		        a.StartAngle = Series(j).mStartAngles(0)-0.05
		        a.ArcAngle = Series(j).mArcAngles(0)+0.1
		        a.FillColor = &cffffff
		        
		        a.Border = 0
		        a.BorderWidth = 0.0
		        a.BorderColor = &cFF0000
		        a.Width = mDoughnutRadius*2
		        a.Height = mDoughnutRadius*2
		        a.X = Series(j).mPts(0).X
		        a.Y = Series(j).mPts(0).Y
		        a.Segments = 10000
		        
		        g.DrawObject(a, 0, 0)
		      End If
		      
		      If Type <> TypePie3D then
		        g.DrawLine(X, Y, X+Cos(ang(j))*Rx/2.0, Y+Sin(ang(j))*Ry/2.0)
		      End If
		      
		    Next
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotPie_old(g As Graphics)
		  
		  #if False
		    
		    Dim X, Y As Integer
		    Dim R As Integer
		    
		    
		    X = g.Width\2
		    Y = g.Height\2
		    
		    Dim texth As Integer
		    Dim textw As Integer
		    If DataLabel <> Nil then
		      g.TextSize = DataLabel.TextSize
		      g.TextFont = DataLabel.TextFont
		      texth = g.TextHeight()
		      textw = DataLabel.maxWidth
		    End If
		    
		    
		    R = (Min(g.Width-textw*2,g.height-texth*2)-30)*.95
		    
		    If AnimationInProgress Then
		      If AnimationType = AnimateLinear Then
		        R = R*AnimationPercent/100.0
		      Else
		        R = R*ChartAnimate.getEaseValue(AnimationType, AnimationPercent, 0, 100.0, 100.0) / 100.0
		      End If
		    End If
		    
		    Plot.Radius = R
		    
		    Y = texth + R/2
		    
		    Dim mDoughnutRadius As Integer
		    If DoughnutRadius>=1 then
		      mDoughnutRadius = min(DoughnutRadius, R\2-10)
		    else
		      mDoughnutRadius = R*DoughnutRadius/2.0
		    End If
		    
		    Const PI=3.14159265358979323846264338327950
		    
		    
		    Dim startA As Double = PieRadarAngle
		    Dim TotalValue As Double
		    Dim a As ArcShape
		    Dim v() As Double
		    Dim j As Integer
		    Dim uValues As Integer
		    Dim ang() As Double
		    
		    Dim is3D As Boolean = True
		    
		    TotalValue = 0.0
		    
		    Redim v(-1)
		    
		    
		    //Going through all series
		    
		    
		    Redim v(Series.Ubound)
		    uValues = UBound(v)
		    Redim ang(uValues)
		    For j = 0 To uValues
		      
		      //Initializing saved data
		      Redim Series(j).mPts(0)
		      Redim Series(j).mStartAngles(0)
		      Redim Series(j).mArcAngles(0)
		      
		      //Retrieving Value and Summing values
		      v(j) = GetValue(0, j) 
		      TotalValue = TotalValue + v(j)
		    Next
		    
		    
		    Redim SelectedSlice(uValues)
		    
		    
		    If TotalValue=0 Then Return
		    
		    
		    Dim gp As Graphics
		    Dim ForceAntiAlias As Boolean
		    Dim tmp As Picture
		    If BackgroundType > BackgroundNone Then
		      ForceAntiAlias = True
		      tmp = New Picture(g.Width, g.Height, 32)
		      gp = tmp.Graphics
		      R = R+5
		    Else
		      
		      gp = g
		    End If
		    
		    
		    For j = 0 To uValues
		      
		      
		      a = New ArcShape
		      a.StartAngle = startA
		      a.ArcAngle = 2.0*PI*v(j)/TotalValue
		      
		      a.FillColor = AlphaColor(Series(j).FillColor, Series(0).Transparency)
		      
		      
		      a.Border = 0
		      a.BorderWidth = 0.0
		      a.BorderColor = &cFF0000
		      a.Width = R
		      a.Height = R
		      a.Segments = 10000
		      a.Scale = 1
		      
		      ang(j) = startA
		      
		      If SelectedSlice(j) Then
		        a.X = X+Cos((ang(j)+startA+a.ArcAngle)/2.0)*(R*0.05)
		        a.Y = Y+Sin((ang(j)+startA+a.ArcAngle)/2.0)*(R*0.05)
		        
		      Else
		        a.X = X
		        a.Y = Y
		      End If
		      
		      //Saving the data
		      
		      Series(j).mPts(0) = New REALbasic.Point(a.X, a.Y)
		      Series(j).mStartAngles(0) = startA
		      Series(j).mArcAngles(0) = a.ArcAngle
		      
		      
		      
		      //Drawing the object
		      If Series(j).FillType = ChartSerie.FillPicture then
		        Dim p As Picture = New Picture(g.Width, g.Height, 32)
		        a.FillColor = &c0
		        p.Mask.Graphics.ForeColor = &cFFFFFF
		        p.Mask.Graphics.AAG_FillAll()
		        p.Mask.Graphics.DrawObject(a, 0, 0)
		        GetFillPicture(p, Series(j), 0, "", a.X, a.Y)
		        gp.DrawPicture(p, 0, 0)
		      else
		        gp.DrawObject(a, 0, 0)
		      End If
		      
		      
		      If Not AnimationInProgress and DataLabel <> Nil then
		        If SelectedSlice(j) then
		          DrawDataLabelPie(gp, Series(j), v(j), X, Y, (R*1.09)/2, (ang(j)+startA+a.ArcAngle)/2.0, ForceAntiAlias)
		        else
		          DrawDataLabelPie(gp, Series(j), v(j), X, Y, R/2, (ang(j)+startA+a.ArcAngle)/2.0, ForceAntiAlias)
		        End If
		      End If
		      
		      startA = startA + a.ArcAngle
		      
		    Next
		    
		    If ForceAntiAlias Then
		      gp = tmp.Mask.Graphics
		      gp.ForeColor = &cFFFFFF
		      gp.AAG_FillAll
		      gp.ForeColor = &c0
		      R = R-5
		      gp.AAG_FillOvalA(X, Y, R, R, 1)
		      
		      //Drawing separation lines
		      gp.ForeColor = &cFFFFFF
		      For j = 0 To uValues
		        
		        gp.DrawLine(X, Y, X+Cos(ang(j))*R/2.0, Y+Sin(ang(j))*R/2.0)
		        
		      Next
		      
		      If Type = TypeDougnut Then
		        gp.ForeColor = &cFFFFFF
		        gp.AAG_FillOvalA(X, Y, mDoughnutRadius*2, mDoughnutRadius*2, 1)
		      End If
		      
		      g.DrawPicture(tmp, 0, 0)
		      
		    Else
		      g.ForeColor = &cFFFFFF
		      
		      If Type = TypeDougnut Then
		        g.FillOval(X-mDoughnutRadius, Y-mDoughnutRadius, mDoughnutRadius*2, mDoughnutRadius*2)
		      End If
		      
		      For j = 0 To uValues
		        
		        If Type = TypeDougnut and SelectedSlice(j) then
		          a = new ArcShape
		          a.StartAngle = Series(j).mStartAngles(0)-0.05
		          a.ArcAngle = Series(j).mArcAngles(0)+0.1
		          a.FillColor = &cffffff
		          
		          a.Border = 0
		          a.BorderWidth = 0.0
		          a.BorderColor = &cFF0000
		          a.Width = mDoughnutRadius*2
		          a.Height = mDoughnutRadius*2
		          a.X = Series(j).mPts(0).X
		          a.Y = Series(j).mPts(0).Y
		          a.Segments = 10000
		          
		          g.DrawObject(a, 0, 0)
		        End If
		        
		        'g.DrawLine(X, Y, X+Cos(ang(j))*R/2.0, Y+Sin(ang(j))*R/2.0)
		        
		      Next
		    End If
		    
		    
		  #else
		    #Pragma Unused g
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotRadar(g As Graphics, OneSerie As Integer = -1, UseCurrentPts As Boolean = False)
		  
		  Dim nSeries As Integer = UBound(Series)
		  Dim ULabels As Integer = UBound(Labels)
		  If ULabels = -1 then Return
		  
		  Dim Xc, Yc As Integer
		  Dim R As Integer
		  Dim mType As Integer = Type
		  
		  
		  Xc = g.Width\2
		  Yc = g.Height\2
		  
		  Dim texth As Integer
		  Dim textw As Integer
		  If DataLabel <> Nil then
		    g.TextSize = DataLabel.TextSize
		    g.TextFont = DataLabel.TextFont
		    texth = g.TextHeight()
		    textw = DataLabel.maxWidth
		  End If
		  
		  
		  R = Min(g.Width-textw*2,g.height-texth*2)-20
		  
		  If AnimationInProgress Then
		    If AnimationType = AnimateLinear Then
		      R = R*AnimationPercent/100.0
		    Else
		      R = R*ChartAnimate.getEaseValue(AnimationType, AnimationPercent, 0, 100.0, 100.0) / 100.0
		    End If
		  End If
		  
		  Const PI=3.14159265358979323846264338327950
		  
		  
		  Dim startA As Double = PieRadarAngle
		  'Dim TotalValue As Double
		  'Dim a As ArcShape
		  'Dim v() As Double
		  Dim i, j As Integer
		  
		  Dim Value As Double
		  Dim NilValue As Boolean
		  Dim LastNilValue As Boolean
		  Dim X, Y As Integer
		  Dim FirstX, FirstY As Integer
		  Dim FirstNilValue As Boolean
		  Dim LastX, LastY As Integer
		  Dim DeltaA As Double = 2*PI/(Ulabels+1)
		  Dim UnitHeight As Double = Axes(1).UnitWidth/Axes(1).MajorUnit
		  Dim StartSerie As Integer
		  Dim Points() As Integer
		  
		  If Type = TypeRadarFill then
		    Points.Append 0
		  End If
		  
		  If OneSerie > -1 then
		    StartSerie = OneSerie
		    nSeries = OneSerie
		    mType = TypeRadar
		  End If
		  
		  //Going through all series
		  For j = StartSerie to nSeries
		    
		    If mType = TypeRadarFill then
		      Redim Points(-1)
		      Points.Append 0
		    End If
		    
		    If not UseCurrentPts then
		      Redim Series(j).mPts(-1)
		    End If
		    
		    
		    g.PenWidth = Series(j).LineWeight
		    g.PenHeight = Series(j).LineWeight
		    
		    FirstNilValue = False
		    
		    For i = 0 to ULabels
		      
		      //Setting the color again as it is changed  by DrawMarker
		      g.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		      
		      If UseCurrentPts then
		        If Series(j).mPts(i) is Nil then
		          LastNilValue = True
		          Continue for i
		        End If
		        X = Series(j).mPts(i).X
		        Y = Series(j).mPts(i).Y
		        
		        g.ForeColor = AlphaColor(Series(j).FillColor, 0, True)
		        
		      else
		        Value = GetValue(i, j, NilValue, False)
		        
		        If NilValue then
		          If i = 0 then
		            FirstNilValue = True
		          End If
		          LastNilValue = True
		          startA = startA + DeltaA
		          Series(j).mPts.append Nil
		          
		          Continue for i
		        End If
		        
		        X = Xc + cos(startA)*Value*UnitHeight
		        Y = Yc + sin(startA)*Value*UnitHeight
		        
		        Series(j).mPts.append New REALbasic.Point(X, Y)
		      End If
		      
		      If i=0 then
		        //Drawing Marker
		        DrawMarker(g, Series(j), X, Y)
		        
		        if mType = TypeRadarFill Then
		          Points.Append X
		          Points.Append Y
		        end if
		        
		        FirstX = X
		        FirstY = Y
		        
		      ElseIf not LastNilValue and i>0 then
		        
		        If mType = TypeRadar then
		          g.DrawLine(LastX, LastY, X, Y)
		        elseif mType = TypeRadarFill Then
		          Points.Append X
		          Points.Append Y
		        End If
		        
		        //Drawing Marker
		        DrawMarker(g, Series(j), X, Y)
		        
		      Elseif LastNilValue then
		        
		        //Drawing Marker
		        DrawMarker(g, Series(j), X, Y)
		        
		      End If
		      
		      LastNilValue = NilValue
		      LastX = X
		      LastY = Y
		      
		      startA = startA + DeltaA
		      
		    Next
		    
		    if mType = TypeRadarFill Then
		      //Setting the color again as it is changed  by DrawMarker
		      g.ForeColor = AlphaColor(Series(j).FillColor, Series(j).Transparency)
		      g.FillPolygon Points()
		      
		      If Series(j).BorderWidth > 0 then
		        PlotRadar(g, j, True)
		      End If
		    else
		      
		      If not LastNilValue and not FirstNilValue then
		        
		        g.DrawLine(LastX, LastY, FirstX, FirstY)
		        
		      End If
		    end if
		    
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1001
		Protected Sub PlotScatter(g As Graphics, OneSerie As Integer = -1)
		  
		  
		  Dim UnitWidth As Double
		  Dim UnitHeight As Double
		  
		  Dim nSeries As Integer = UBound(Series)
		  Dim Offset As Integer
		  Dim i, j, X, Y, U As Integer
		  Dim H As Integer
		  Dim maximum As Double
		  Dim Type As Integer
		  Dim StartSerie As Integer
		  If OneSerie>-1 then
		    Type = me.Series(OneSerie).Type
		    StartSerie = OneSerie
		    nSeries = OneSerie
		  else
		    Type = self.Type
		  End If
		  
		  'Dim startScale As Integer = Axes(0).MinimumScale
		  'Dim endScale As Integer = Axes(0).MaximumScale
		  
		  
		  H = BaseDrawY
		  UnitWidth = Axes(0).UnitWidth/Axes(0).MajorUnit
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  
		  Dim Value As Double
		  Dim NilValue As Boolean
		  'Dim LastNilValue As Boolean
		  
		  Dim ShiftValue As Boolean = Axes(1).MinimumScale > 0
		  
		  
		  
		  Offset = UnitWidth *1/10
		  
		  'Dim MarkerRadius As Single = 4.5
		  
		  Dim FillPic As Picture
		  Dim gg As Graphics
		  
		  
		  For j = StartSerie to nSeries
		    
		    //Plotting the TrendLine if any
		    If Series(j).MarkLine then
		      Continue for j
		    End If
		    
		    
		    U = UBound(Series(j).Values)
		    
		    Redim Series(j).mPts(-1)
		    If U = -1 then Continue for j
		    
		    If Series(j).SecondaryAxis then
		      maximum = maxValueSecondary
		    else
		      maximum = maxValue
		    End If
		    
		    If Series(j).FillType = ChartSerie.FillPicture then
		      FillPic = New Picture(g.Width, g.Height, 32)
		      GetFillPicture(FillPic, Series(j), -1, "", 0, 0)
		      gg = FillPic.mask.graphics
		      gg.ForeColor = &cFFFFFF
		      gg.AAG_FillAll()
		      gg.ForeColor = &c0
		    else
		      gg = g
		      gg.ForeColor = Series(j).FillColor
		    End If
		    gg.PenWidth = Series(j).LineWeight
		    gg.PenHeight = Series(j).LineWeight
		    
		    
		    
		    For i = 0 to U Step Precision
		      
		      Value = GetValue(i, j, NilValue, False)
		      
		      If NilValue then 
		        Series(j).mPts.append Nil
		        Continue for i
		      End If
		      
		      X = Round((Axes(0).Label(i).DoubleValue-Axes(0).MinimumScale) * UnitWidth)
		      
		      If ShiftValue then
		        Y = H - Round((Value-Axes(1).MinimumScale)*UnitHeight)
		      else
		        Y = H - Round(Value*UnitHeight)
		      End If
		      
		      
		      Series(j).mPts.append New REALbasic.Point(X, Y)
		      
		      
		      //Drawing Marker
		      DrawMarker(gg, Series(j), X, Y)
		      
		    Next
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotSpline(g As Graphics, OneSerie As Integer = -1)
		  
		  
		  Dim UnitWidth As Double
		  Dim UnitHeight As Double
		  
		  Dim nSeries As Integer = UBound(Series)
		  Dim Offset As Integer
		  Dim i, j, X, Y, U, UPts As Integer
		  Dim H As Integer
		  Dim maximum As Double
		  Dim Type As Integer
		  Dim StartSerie As Integer
		  If OneSerie>-1 then
		    Type = me.Series(OneSerie).Type
		    StartSerie = OneSerie
		    nSeries = OneSerie
		  else
		    Type = self.Type
		  End If
		  
		  'Dim startScale As Integer = Axes(0).MinimumScale
		  'Dim endScale As Integer = Axes(0).MaximumScale
		  
		  'Dim gg As Graphics = g.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		  
		  H = BaseDrawY
		  UnitWidth = Axes(0).UnitWidth
		  UnitHeight = Axes(1).UnitWidth/Axes(1).MajorUnit
		  
		  Dim Value As Double
		  Dim NilValue As Boolean
		  'Dim LastNilValue As Boolean
		  Dim idx As Integer
		  
		  U = UBound(Labels)
		  If U = -1 then Return
		  
		  Dim Precision As Double = 1.0
		  
		  Offset = UnitWidth *1/10
		  
		  'Dim MarkerRadius As Single = 4.5
		  
		  Dim A As Single = (0.5 / 0.5 * 0.175) 'Csng(Tension / 0.5 * 0.175)
		  Dim pt, pt_before, pt_after, pt_after2, Di, DiPlus1 As REALbasic.Point
		  Dim p1, p2, p3, p4 As REALbasic.Point
		  
		  For j = StartSerie to nSeries
		    
		    If Series(j).SecondaryAxis then
		      maximum = maxValueSecondary
		    else
		      maximum = maxValue
		    End If
		    
		    g.ForeColor = Series(j).FillColor
		    g.PenHeight = 1
		    g.PenWidth = 1
		    
		    
		    Value = GetValue(0,j, NilValue, False)
		    
		    Dim m_Pts() As REALbasic.Point
		    Dim Values() As Double
		    
		    Values.Append Value
		    
		    If AnimationInProgress and AnimationHorizontal then
		      If UBound(oldSeries)>=j and oldSeries(j).Values.Ubound>=-1 then
		        If CrossesBetweenTickMarks then
		          X = Round(UnitWidth/2)-AnimationPercent*UnitWidth/100.0
		        else
		          X = -AnimationPercent*UnitWidth/100.0
		        End If
		        Y = H - Round(oldSeries(j).Values(0)*UnitHeight)
		        
		        m_Pts.Append New REALbasic.Point(X, Y)
		      else
		        x=x
		      End If
		    End If
		    
		    If CrossesBetweenTickMarks then
		      X = Round(UnitWidth/2)
		    else
		      X = 0
		    End If
		    Y = H - Round(Value*UnitHeight)
		    
		    If AnimationInProgress and AnimationHorizontal then
		      X = X + (100.0-AnimationPercent)*UnitWidth/100.0
		    End If
		    
		    If not NilValue then
		      m_pts.Append New REALbasic.Point(X, Y)
		    End If
		    
		    //Preparing Points
		    
		    //Test
		    Dim c As CurveShape
		    'Dim pts As REALbasic.Point
		    
		    
		    For i = 1 to U Step Precision
		      
		      Value = GetValue(i, j, NilValue, False)
		      
		      Values.Append Value
		      
		      If CrossesBetweenTickMarks then
		        X = Round(UnitWidth * i + UnitWidth/2)
		      else
		        X = Round(UnitWidth * i)
		      End If
		      
		      Y = H - Round(Value*UnitHeight)
		      
		      If AnimationInProgress and AnimationHorizontal then
		        X = X + (100.0-AnimationPercent)*UnitWidth/100.0
		      End If
		      
		      If not NilValue then
		        m_pts.Append New REALbasic.Point(X, Y)
		      else
		        m_Pts.Append Nil
		      End If
		    Next
		    
		    
		    
		    UPTs = UBound(m_pts)-1
		    For i = 0 to UPts
		      
		      If m_Pts(i) is Nil then Continue for i
		      pt = m_Pts(i).Clone
		      
		      
		      idx = Max(i-1, 0)
		      If m_Pts(idx) is Nil then
		        pt_before = pt.Clone
		      else
		        pt_before = m_Pts(Max(i - 1, 0)).Clone
		      End If
		      
		      idx = Min(i+1, m_Pts.Ubound)
		      If m_Pts(idx) is Nil then
		        pt_after = pt.Clone
		        pt_after2 = pt.Clone
		      else
		        pt_after = m_Pts(idx).Clone
		        
		        idx = Min(i+2, m_Pts.Ubound)
		        if m_Pts(idx) is Nil then
		          pt_after2 = pt_after.Clone
		        else
		          pt_after2 = m_Pts(idx).Clone
		        end if
		      End If
		      
		      p1 = pt.Clone
		      p4 = pt_after.Clone
		      
		      Di = New REALbasic.Point
		      Di.X = pt_after.X - pt_before.X
		      Di.Y = pt_after.Y - pt_before.Y
		      p2 = new REALbasic.Point
		      p2.X = pt.X + A * Di.X
		      p2.Y = pt.Y + A * Di.Y
		      
		      DiPlus1 = new REALbasic.Point
		      DiPlus1.X = pt_after2.X - p1.X
		      DiPlus1.Y = pt_after2.Y - p1.Y
		      p3 = new REALbasic.Point
		      p3.X = pt_after.X - A * DiPlus1.X
		      p3.Y = pt_after.Y - A * DiPlus1.Y
		      
		      'DrawBezier(g, p1, p2, p3, p4)
		      'DrawBezier(g, 0, 1, 0.05, p1, p2, p3, p4)
		      
		      //test
		      c = new CurveShape
		      c.X = p1.X
		      c.Y = p1.Y
		      c.Order = 2
		      c.ControlX(0) = p2.X
		      c.ControlY(0) = p2.Y
		      c.ControlX(1) = p3.X
		      c.ControlY(1) = p3.Y
		      c.X2 = p4.X
		      c.Y2 = p4.Y
		      
		      
		      'g.ForeColor = &cFF0000
		      c.BorderWidth=Series(j).LineWeight+0.5
		      c.BorderColor=Series(j).FillColor
		      g.DrawObject(c, 0, 0)
		      
		      //Draw marker points
		      'g.FillRect(p2.X, p2.Y, 3,3)
		      'g.FillRect(p3.X, p3.Y, 3,3)
		      
		      
		      //Drawing Marker
		      g.ForeColor = Series(j).FillColor
		      DrawMarker(g, Series(j), m_Pts(i).X, m_Pts(i).Y)
		      
		      //Drawing DataLabel
		      If DataLabel <> Nil and not AnimationInProgress then
		        'If Series(j).FillType = ChartSerie.FillPicture then
		        'DrawDataLabel(gg, Series(j), Value, X, Y-Series(j).MarkerSize, 1, 1, true)
		        'DrawDataLabel(Fillpic.Graphics, Series(j), Value, X, Y-Series(j).MarkerSize, 1, 1)
		        'else
		        DrawDataLabel(g, Series(j), Values(i), m_Pts(i).X, m_Pts(i).Y-Series(j).MarkerSize, 1, 1)
		        'End If
		      End If
		    Next
		    
		    g.ForeColor = Series(j).FillColor
		    DrawMarker(g, Series(j), m_Pts(UPts+1).X, m_Pts(UPts+1).Y)
		    //Drawing DataLabel
		    If DataLabel <> Nil and not AnimationInProgress then
		      'If Series(j).FillType = ChartSerie.FillPicture then
		      'DrawDataLabel(gg, Series(j), Value, X, Y-Series(j).MarkerSize, 1, 1, true)
		      'DrawDataLabel(Fillpic.Graphics, Series(j), Value, X, Y-Series(j).MarkerSize, 1, 1)
		      'else
		      DrawDataLabel(g, Series(j), Values(UPts+1), m_Pts(UPts+1).X, m_Pts(UPts+1).Y-Series(j).MarkerSize, 1, 1)
		      'End If
		    End If
		    
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotTreeMap(g As Graphics, OneSerie As Integer = -1)
		  //Source: http://www.win.tue.nl/~vanwijk/stm.pdf
		  
		  
		  Dim nSeries As Integer = UBound(Series)
		  
		  If nSeries = -1 then Return
		  
		  
		  Dim StartSerie As Integer
		  Dim i, j As Integer
		  
		  If OneSerie > -1 then
		    StartSerie = OneSerie
		    nSeries = OneSerie
		    mType = TypeRadar
		  End If
		  
		  Dim DispSeries() As ChartSerie
		  Dim GrandTotal As Double
		  For j = StartSerie to nSeries
		    DispSeries.Append Series(j)
		    
		    If Series(j).needsCalc then Series(j).Calc
		    GrandTotal = GrandTotal + Series(j).TotalValue
		    
		  Next
		  
		  CombSort(DispSeries)
		  
		  
		  Dim current As ChartSerie
		  
		  Dim lastW, lastH As Integer
		  Dim X, Y As Integer
		  
		  Dim Rows() As ChartTreemapRow
		  Dim row As New ChartTreemapRow
		  
		  row.X = 0
		  row.Y = 0
		  row.AvailableW = g.Width
		  row.AvailableH = g.Height
		  row.GrandTotal = GrandTotal
		  
		  row.AddSerie DispSeries.Pop
		  
		  Dim lastRow As ChartTreemapRow
		  
		  //Organizing the TreeMap
		  While UBound(DispSeries) > -1
		    
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
		  
		  Call row.Worst
		  Rows.Append row
		  
		  Dim gc As Graphics
		  
		  //Drawing the TreeMap(s)
		  For i = 0 to UBound(Rows)
		    row = Rows(i)
		    X = row.X
		    Y = row.Y
		    nSeries = row.Series.Ubound
		    For j = 0 to nSeries
		      current = row.Series(j)
		      
		      
		      g.ForeColor = AlphaColor(current.FillColor, current.Transparency)
		      
		      If row.Vertical then
		        lastH = Round(current.TotalValue/row.total*row.Height)
		        If j = nSeries then
		          g.FillRect(X, Y, row.Width-1, g.Height-Y)
		        else
		          g.FillRect(X, Y, row.Width-1, lastH-1)
		        End If
		        
		        gc = g.Clip(X, Y, row.Width, lastH)
		        DrawDataLabel(gc, current, current.TotalValue, 0, 0, row.Width, lastH)
		        'g.ForeColor = &cFFFFFF
		        'g.DrawString(Current.Title, X+5, g.TextHeight+Y+5)
		        
		        Y = Y + lastH
		      Else
		        lastW = Round(current.TotalValue / row.total * row.Width)
		        If j = nSeries then
		          g.FillRect(X, Y, g.Width-X, row.Height-1)
		        else
		          g.FillRect(X, Y, lastW-1, row.Height-1)
		        End If
		        
		        gc = g.Clip(X, Y, lastW, row.Height)
		        DrawDataLabel(gc, current, current.TotalValue, 0, 0, lastW, row.Height)
		        
		        'g.ForeColor = &cFFFFFF
		        'g.DrawString(Current.Title, X+5, g.TextHeight +Y+5)
		        
		        X = X + lastW
		        
		        
		      End If
		      
		    Next
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PlotTrend(g As Graphics)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  
		  //All Charts Variables
		  'Dim nSeries As Integer = UBound(Series)
		  Dim  H As Integer
		  Dim gg As Graphics
		  
		  H = Plot.Height
		  
		  gg = g.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		  
		  
		  //Column & Area Variables
		  'Dim Value As Double
		  Dim U As Integer
		  U = UBound(Labels)
		  
		  
		  //Area Specific Variables
		  'Dim LastX As Integer
		  'Dim LastY As Integer
		  'Dim Points() As Integer
		  
		  
		  'Dim AreaPic As Picture
		  'Dim Surf As RGBSurface
		  'Dim MaskG As Graphics
		  
		  If Type = TypeTrendTimeLine then
		    
		    
		    
		    
		    
		  elseif Type = TypeTrendAreaStepped then
		    
		    Dim RangePlot As New ChartPlot
		    RangePlot.Left = Plot.Left
		    RangePlot.Top = Plot.Top + Plot.Height+5
		    RangePlot.Width = Plot.Width
		    RangePlot.Height = RangeSelectorHeight
		    
		    If RangeBuffer is Nil then
		      
		      RangeBuffer = New Picture(RangePlot.Width, RangePlot.Height, 32)
		      Dim gr As Graphics = RangeBuffer.Graphics
		      
		      PlotArea(gr, 0, True)
		    End If
		    
		    g.DrawPicture(RangeBuffer, RangePlot.Left, RangePlot.Top)
		    
		    
		    PlotArea(gg)
		    
		    
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Recalc(ForExport As Boolean = False)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  Dim i As Integer
		  Dim USeries As Integer = UBound(Series)
		  Dim ULabel As Integer
		  Dim idx As Double
		  
		  If USeries = -1 then Return
		  
		  minValue = 2^31-1
		  maxValue = 0
		  minValueSecondary = minValue
		  maxValueSecondary = 0
		  Dim txt As String
		  Dim percent As String
		  Dim Stacked100 As Boolean
		  Dim Delta As Integer
		  Dim SwapAxis As Boolean = (Type \ 100 = TypeBar \ 100)
		  Dim PriorityValue As Integer
		  If SwapAxis then
		    PriorityValue = Plot.Width
		  elseif Type\100 = TypeRadar\100 then
		    PriorityValue = Min(Plot.Width,Plot.height)\2-10
		  else
		    PriorityValue = Plot.Height
		  End If
		  
		  Redim Labels(-1)
		  
		  Dim p As Picture = New Picture(1, 1, 32)
		  Dim gp As Graphics = p.Graphics
		  
		  Dim cAxe As ChartAxis
		  
		  If not Continuous then
		    i = i
		  End If
		  
		  If Type mod 100 = 1 or Type=TypeAreaStepped or Type=TypeLineStackedSmooth then
		    //Stacked
		    Dim j As Integer
		    
		    Dim Count As Integer
		    Dim PosVal, NegVal As Double
		    For i = 0 to USeries
		      Series(i).Calc
		      If Series(i).SecondaryAxis and UBound(Axes)<2 then
		        Axes.Append New ChartAxis
		      End If
		    Next
		    Count = Series(0).Count
		    
		    For i = 0 to Count-1
		      PosVal = 0
		      NegVal = 0
		      
		      For j = 0 to USeries
		        If Series(j).Values(i)>0 then
		          PosVal = PosVal + Series(j).Values(i)
		        else
		          NegVal = NegVal + Series(j).Values(i)
		        End If
		      Next
		      
		      minValue = min(minValue, NegVal)
		      maxValue = max(maxValue, PosVal)
		    Next
		    
		  elseif type mod 100 = 2 then
		    //Stacked 100
		    minValue = 0
		    maxValue = 100
		    
		    percent = "%"
		    'Stacked100 = True
		    
		  else
		    
		    //Finding max and min values
		    For i = 0 to USeries
		      Series(i).Calc
		      
		      If Series(i).SecondaryAxis and UBound(Axes)<2 then
		        Axes.Append New ChartAxis
		      End If
		      
		      If Series(i).SecondaryAxis then
		        minValueSecondary = min(minValueSecondary, Series(i).minValue)
		        maxValueSecondary = max(maxValueSecondary, Series(i).maxValue)
		      else
		        minValue = min(minValue, Series(i).minValue)
		        maxValue = max(maxValue, Series(i).maxValue)
		      End If
		    Next
		    
		  End If
		  
		  
		  //Cross type
		  If Axes(0).Crosses = ChartAxis.CrossAutomatic then
		    
		    If Type\100 = TypeColumn\100 then
		      CrossesBetweenTickMarks = True
		      
		    Elseif Type\100 = TypeLine\100 then
		      CrossesBetweenTickMarks = False
		      
		    Elseif Type = TypeAreaStepped then
		      CrossesBetweenTickMarks = True
		      
		    Elseif Type\100 = TypeArea\100 then
		      CrossesBetweenTickMarks = False
		      
		    Elseif Type\100 = TypeBar\100 then
		      CrossesBetweenTickMarks = True
		      
		    Elseif Type\100 = TypeCombo\100 then
		      
		      CrossesBetweenTickMarks = False
		      
		      For i = 0 to USeries
		        If Series(i).Type = TypeColumn then
		          CrossesBetweenTickMarks = True
		          exit for i
		        End If
		      Next
		      
		    End If
		  End If
		  
		  If Type\100 = TypeScatter\100 then
		    CrossesBetweenTickMarks = False
		  End If
		  
		  If DoubleYAxe and Axes.Ubound > 1 then
		    Redim Axes(1)
		  End If
		  
		  If Type\100 = TypePie\100 Then
		    
		    If DataLabel <> Nil then
		      DataLabel.maxWidth = 0
		      gp.TextSize = DataLabel.TextSize
		      gp.TextFont = DataLabel.TextFont
		      gp.Bold = DataLabel.Bold
		      
		      Dim strValue As String
		      
		      For i = 0 to UBound(Series)
		        
		        If Series(i).Values.ubound > -1 then
		          strValue = str(Series(i).values(0).DoubleValue, DataLabel.Format)
		          
		          DataLabel.maxWidth = max(DataLabel.maxWidth, gp.StringWidth(strValue))
		          
		        End If
		      Next
		    End If
		    
		    
		  Else
		    
		    For i = 0 to UBound(Axes)
		      Axes(i).Init
		    Next
		    
		    cAxe = Axes(0)
		    
		    Dim xType As String
		    If ( UBound(cAxe.Label)>-1 and Continuous ) or Type\100 = TypeScatter\100 then
		      xType = cAxe.LabelType
		    End If
		    
		    If xType <> "" or Type\100 = TypeScatter\100 then //Continuous
		      
		      Dim minX, maxX As Double
		      minX = 2^64-1 
		      
		      ULabel = UBound(cAxe.Label)
		      
		      If xType = "Date" then
		        Dim D As new Date
		        Dim DateStep As String = cAxe.DateStep
		        
		        'Dim mp As new MethodProfiler("xDate")
		        For i = 0 to ULabel
		          
		          If minX > cAxe.Label(i).DateValue.Totalseconds then
		            minX = cAxe.Label(i).DateValue.Totalseconds 
		          End If
		          If maxX < cAxe.Label(i).DateValue.TotalSeconds then
		            maxX = cAxe.Label(i).DateValue.TotalSeconds
		          End If
		          
		        Next
		        'mp = Nil
		        
		        
		        //Continuous Date
		        If Continuous then
		          idx = minX
		          While idx <= maxX
		            D.TotalSeconds = idx
		            Labels.Append D.SQLDateTime
		            
		            If DateStep <> "" then
		              Select Case DateStep
		              Case "second", "s"
		                idx = idx + 1
		              Case "minute"
		                idx = idx + 60
		              Case "hour", "h"
		                idx = idx + 3600
		              Case "day", "d"
		                idx = idx + 86400
		              Case "month"
		                D.Month = D.Month + 1
		                idx = D.TotalSeconds
		              Case "year", "y"
		                D.Year = D.Year + 1
		                idx = D.TotalSeconds
		              End Select
		            End If
		          Wend
		          
		        else //Discrete
		          
		          For i = 0 to ULabel
		            Labels.Append cAxe.Label(i).StringValue
		          Next
		          
		        End If
		        
		        
		      else //Not Type Date
		        
		        Dim vvv As Double
		        For i = 0 to ULabel
		          vvv = cAxe.Label(i).DoubleValue
		          If minX > cAxe.Label(i).DoubleValue then
		            minX = cAxe.Label(i).DoubleValue
		          End If
		          If maxX < cAxe.Label(i).DoubleValue then
		            maxX = cAxe.Label(i).DoubleValue
		          End If
		          
		        Next
		        
		        //Continuous values
		        If Continuous or Type\100 = TypeScatter\100 then
		          
		          //Updating values for better display
		          Dim BestScale As Single  = maxX - minX
		          Dim cnt, Multi10 As Integer
		          
		          If cAxe.LogarithmicScale then
		            BestScale = 10^Ceil(log(BestScale)/log(10))
		            
		          Else
		            
		            While BestScale >= 10
		              BestScale = BestScale/10
		              cnt = cnt + 1
		            Wend
		            
		          End If
		          
		          If cAxe.MajorUnitIsAuto then
		            cAxe.LabelInterval = 10^cnt
		          End If
		          
		          Multi10 = 10^cnt
		          
		          minX = Floor((minX-Multi10)/Multi10)*Multi10
		          maxX = Ceil((maxX+Multi10)/Multi10)*Multi10
		          
		          
		          
		          idx = Floor(minX)
		          
		          While idx <= maxX
		            
		            Labels.Append str(idx)
		            
		            idx = idx + cAxe.MajorUnit
		            
		          Wend
		          
		        else //Discrete
		          
		          For i = 0 to ULabel
		            Labels.Append cAxe.Label(i).StringValue
		          Next
		          
		        End If
		        
		      End If
		      
		      
		      cAxe.MinimumScale = minX
		      cAxe.MaximumScale = maxX
		      
		      cAxe.MinimumScaleIsAuto = True
		      cAxe.MaximumScaleIsAuto = True
		      
		      
		      
		      
		    else //Always discrete
		      
		      If cAxe.MaximumScaleIsAuto then
		        cAxe.MaximumScale = Series(0).Count-1
		      End If
		      If cAxe.MinimumScaleIsAuto then
		        cAxe.MinimumScale = 0
		        cAxe.MinimumScaleIsAuto = True
		      End If
		      
		      
		      If UBound(cAxe.Label)>-1 then
		        ULabel = UBound(cAxe.Label)
		        Redim Labels(ULabel)
		        
		        //Getting correct string for Label for numeric values
		        If cAxe.LabelType = "Double" then
		          For i = 0 to ULabel
		            Labels(i) = str(cAxe.Label(i).DoubleValue)
		          Next
		        else
		          
		          For i = 0 to ULabel
		            Labels(i) = cAxe.Label(i)
		          Next
		        End If
		        
		      else  //No Label defined
		        
		        ULabel = Series(0).Count-1
		        Redim Labels(ULabel)
		        
		        For i = 1 to ULabel+1
		          Labels(i-1) = str(i)
		        Next
		      End If
		      
		    End If
		    
		    //Setting all Y axes max and min values
		    If Axes(1).MaximumScaleIsAuto then
		      Axes(1).MaximumScale = max(maxValue, 0)
		      Axes(1).MaximumScaleIsAuto = True
		    End If
		    If Axes(1).MinimumScaleIsAuto then
		      If Axes(1).LogarithmicScale then
		        Axes(1).MinimumScale = 1
		      else
		        Axes(1).MinimumScale = min(0, minValue)
		      End If
		      Axes(1).MinimumScaleIsAuto = True
		    End If
		    
		    If UBound(Axes)>=2 then
		      If Axes(2).MaximumScaleIsAuto then
		        Axes(2).MaximumScale = max(0, maxValueSecondary)
		        Axes(2).MaximumScaleIsAuto = True
		      End If
		      If Axes(2).MinimumScaleIsAuto then
		        If Axes(2).LogarithmicScale then
		          Axes(2).MinimumScale = 0
		        else
		          Axes(2).MinimumScale = min(0, minValueSecondary)
		        End If
		        Axes(2).MinimumScaleIsAuto = True
		      End If
		    End If
		    
		    If Type\100 = TypeColumn\100 then
		      
		      If not Continuous and cAxe.MinimumScaleIsAuto then
		        cAxe.MinimumScale = 0
		      End If
		      
		      
		      If cAxe.MajorGridLine <> Nil Then
		        If cAxe.MajorGridLine.Filltype = ChartLine.FillAutomatic then
		          cAxe.MajorGridLine.Width = 0
		        End If
		      End If
		      If cAxe.MinorGridLine <> Nil then
		        If cAxe.MinorGridLine.Filltype = ChartLine.FillAutomatic then
		          cAxe.MinorGridLine.Width = 0
		        End If
		      End If
		      
		      If Axes(1).MajorGridLine is Nil then
		        'Axes(1).MajorGridLine = New ChartLine
		      End If
		      'If Axes(1).MajorGridLine.Filltype = ChartLine.FillAutomatic then
		      'Axes(1).MajorGridLine.Width = 1
		      'Axes(1).MajorGridLine.FillColor = &c0
		      'End If
		      If Axes(1).MinorGridLine <> Nil then
		        If Axes(1).MinorGridLine.Filltype = ChartLine.FillAutomatic then
		          Axes(1).MinorGridLine.Width = 0
		        End If
		      End If
		      
		      
		      
		    End If
		    
		    ULabel = UBound(Labels)
		    
		    //Setting up X Axis
		    //Do not use PriorityValue
		    If SwapAxis then
		      If Type < TypeArea or Type = TypeAreaStepped then
		        cAxe.UnitWidth = Plot.Height / (ULabel+1)
		      else
		        cAxe.UnitWidth = Plot.Height / ULabel
		      End If
		    else
		      If Type < TypeArea or Type = TypeAreaStepped then
		        cAxe.UnitWidth = Plot.Width / (ULabel+1)
		      else
		        cAxe.UnitWidth = Plot.Width / ULabel
		      End If
		    End If
		    
		    gp.Bold = cAxe.LabelStyle.Bold
		    gp.Italic = cAxe.LabelStyle.Italic
		    gp.Underline = cAxe.LabelStyle.Underline
		    gp.TextSize = cAxe.LabelStyle.TextSize
		    gp.TextFont = cAxe.LabelStyle.TextFont
		    
		    
		    
		    //Setting Plot Height depending on Labels
		    If ForExport = False and cAxe.LabelType = "Date" then
		      Dim d As new date
		      
		      Try
		        If SwapAxis then //Bar Chart
		          
		          Dim maxWidth As Integer
		          For i = 0 to ULabel
		            
		            maxWidth = max(maxWidth, gp.StringWidth(mParseDate(D, cAxe.LabelStyle.Format, D.SQLDate)))
		            
		          Next
		          
		          Plot.Left = Plot.Left + maxWidth
		          Plot.Width = Plot.Width - maxWidth
		          
		          
		        else //Not Bar chart
		          For i = 0 to ULabel step cAxe.LabelInterval
		            //Testing the width of all Labels to check that it isn't larger than UnitWidth
		            //If the width is larger, the labels are displayed on two levels.
		            
		            d.SQLDateTime = Labels(i)
		            '#if DebugBuild
		            'Dim strw As Integer = gp.StringWidth(mParseDate(D, cAxe.LabelStyle.Format, D.SQLDate))
		            'Dim availw As Integer = (cAxe.UnitWidth*Max(1, cAxe.LabelInterval)-6)
		            '#endif
		            
		            If gp.StringWidth(mParseDate(D, cAxe.LabelStyle.Format, D.SQLDate)) > (cAxe.UnitWidth*Max(1, cAxe.LabelInterval)-6) then
		              LabelTwoLevel = True
		              Plot.Height = Plot.Height-gp.TextHeight
		              exit for i
		            End If
		          Next
		        End If
		      Catch
		        
		      End Try
		      
		    elseif ForExport = False Then
		      
		      If SwapAxis then
		        Dim maxWidth As Integer
		        For i = 0 to ULabel
		          
		          maxWidth = max(maxWidth, gp.StringWidth(Labels(i)))
		          
		        Next
		        
		        Plot.Left = Plot.Left + maxWidth
		        Plot.Width = Plot.Width - maxWidth
		        
		      else //Not Bar chart
		        
		        For i = 0 to ULabel step cAxe.LabelInterval
		          //Testing the width of all Labels to check that it isn't larger than UnitWidth
		          //If the width is larger, the labels are displayed on two levels.
		          
		          If gp.StringWidth(Labels(i)) > (cAxe.UnitWidth*Max(1, cAxe.LabelInterval)-10) then
		            LabelTwoLevel = True
		            Plot.Height = Plot.Height-gp.TextHeight
		            exit for i
		          End If
		          
		        Next 
		        
		      End If
		    End If
		    
		    //Do not comment this, the plot size was changed above
		    If SwapAxis then
		      PriorityValue = Plot.Width
		    else
		      PriorityValue = Plot.Height
		    End If
		    
		    
		    
		    //Setting up All Y axis
		    For i = 1 to UBound(Axes)
		      cAxe = Axes(i)
		      txt = percent + cAxe.LabelStyle.Format
		      
		      gp.Bold = cAxe.LabelStyle.Bold
		      gp.Italic = cAxe.LabelStyle.Italic
		      gp.Underline = cAxe.LabelStyle.Underline
		      gp.TextSize = cAxe.LabelStyle.TextSize
		      gp.TextFont = cAxe.LabelStyle.TextFont
		      
		      If cAxe.MajorUnitIsAuto And ForExport = False then
		        
		        If Stacked100 then
		          cAxe.MajorUnit = 100
		          
		          If Type = TypeBarStacked100 then
		            cAxe.UnitWidth = Plot.Width
		          else
		            cAxe.UnitWidth = Plot.Height
		          End If
		          
		        else
		          
		          Dim BestScale As Single
		          Dim cnt As Integer
		          
		          
		          BestScale = cAxe.MaximumScale - cAxe.MinimumScale
		          
		          If cAxe.LogarithmicScale then
		            BestScale = 10^Ceil(log(BestScale)/log(10))
		            
		          Else
		            
		            While BestScale >= 10
		              BestScale = BestScale/10
		              cnt = cnt + 1
		            Wend
		            
		          End If
		          
		          cAxe.MajorUnit = 10^cnt
		          
		          
		          
		          
		          If cAxe.LogarithmicScale then
		            cAxe.UnitWidth = PriorityValue / (log(BestScale)/log(10))
		          else
		            If cAxe.MinimumScale<0 then
		              cAxe.UnitWidth = PriorityValue / (Floor(BestScale+2))
		            else
		              cAxe.UnitWidth = PriorityValue / (Floor(BestScale+1))
		            End If
		          End If
		          
		          
		        End If
		        
		        If not cAxe.LogarithmicScale then
		          
		          Dim oldUnit, oldWidth As Double
		          
		          If cAxe.UnitWidth < 20 then
		            cAxe.MajorUnit = cAxe.MajorUnit*10
		            cAxe.UnitWidth = cAxe.UnitWidth*10
		          End If
		          
		          While cAxe.UnitWidth > 30 and cAxe.MajorUnit > 1
		            oldUnit = cAxe.MajorUnit
		            oldWidth = cAxe.UnitWidth
		            
		            If str(cAxe.MajorUnit).Left(1) = "5" then
		              cAxe.MajorUnit = cAxe.MajorUnit /5*2
		              'cAxe.UnitWidth= cAxe.UnitWidth / 5*2
		            else
		              cAxe.MajorUnit = cAxe.MajorUnit / 2
		              'cAxe.UnitWidth = cAxe.UnitWidth / 2
		            End If
		            
		            'If Type \ 100 = TypeBar \ 100 then
		            'If minValue<0 then
		            'If cAxe.MinimumScaleIsAuto and cAxe.MaximumScaleIsAuto then
		            'cAxe.UnitWidth = Plot.Width / Ceil((maxValue-minValue)/cAxe.MajorUnit)
		            'elseif cAxe.MinimumScaleIsAuto then
		            'cAxe.UnitWidth = Plot.Width / Ceil((cAxe.MaximumScale-minValue)/cAxe.MajorUnit)
		            'elseif cAxe.MaximumScaleIsAuto then
		            'cAxe.UnitWidth = Plot.Width / Ceil((maxValue-cAxe.MinimumScale)/cAxe.MajorUnit)
		            'else
		            'If cAxe.MaximumScaleIsAuto then
		            'cAxe.UnitWidth = Plot.Width / Ceil(maxValue/cAxe.MajorUnit)
		            'else
		            'cAxe.UnitWidth = Plot.Width / Ceil(cAxe.MaximumScale/cAxe.MajorUnit)
		            'End If
		            'End If
		            '
		            'else //Not Bar Chart
		            
		            If cAxe.MinimumScale < 0 then
		              'If minValue<0 then
		              'cAxe.UnitWidth = Plot.Height / Ceil((maxValue-minValue) / cAxe.MajorUnit)
		              cAxe.UnitWidth = PriorityValue / (Ceil(cAxe.MaximumScale/cAxe.MajorUnit) - Floor(cAxe.MinimumScale / cAxe.MajorUnit))
		            else
		              cAxe.UnitWidth = PriorityValue / Ceil((cAxe.MaximumScale-cAxe.MinimumScale) / cAxe.MajorUnit)
		              'cAxe.UnitWidth = Plot.Height / Ceil(maxValue/cAxe.MajorUnit)
		            End If
		            'End If
		            
		            If cAxe.UnitWidth < 20 then
		              cAxe.MajorUnit = oldUnit
		              cAxe.UnitWidth = oldWidth
		              exit while
		            End If
		          Wend
		          
		          
		        End If
		        
		        
		        cAxe.MajorUnitIsAuto = True
		        
		      else //MajorUnit not Auto
		        
		        //Setting up UnitWidth
		        If cAxe.MinimumScale < 0 then
		          cAxe.UnitWidth = PriorityValue / (Ceil(cAxe.MaximumScale/cAxe.MajorUnit) - Floor(cAxe.MinimumScale / cAxe.MajorUnit))
		          
		        else
		          cAxe.UnitWidth = PriorityValue / Ceil((cAxe.MaximumScale-cAxe.MinimumScale) / cAxe.MajorUnit)
		          
		        End If
		        
		      End If 
		      
		      
		      If ForExport = False then
		        If SwapAxis then
		          'Dim a As Integer = gp.stringWidth(str(Floor(cAxe.MaximumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt)+10
		          'Dim b As Integer = cAxe.UnitWidth*Max(1, cAxe.LabelInterval)
		          While cAxe.Labelinterval < 100 and gp.stringWidth(str(Floor(cAxe.MaximumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt)+10 > cAxe.UnitWidth*Max(1, cAxe.LabelInterval)
		            cAxe.LabelInterval = cAxe.LabelInterval + 1
		          Wend
		          
		        elseif Type < TypePie then
		          If i = 1 then //Axes 1
		            If cAxe.MinimumScale<0 then
		              Delta = gp.StringWidth(str(Floor(cAxe.MinimumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt) + 7
		            End if
		            
		            'dim def As Double = Ceil(cAxe.MaximumScale/cAxe.MajorUnit) * cAxe.MajorUnit
		            'dim abc As Double = gp.StringWidth(str(Ceil(cAxe.MaximumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt) + 5
		            Delta = max(Delta, gp.StringWidth(str(Ceil(cAxe.MaximumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt) + 7)
		            
		            Plot.Left = Plot.Left + Delta
		            Plot.Width = Plot.Width - Delta
		          else
		            If cAxe.MinimumScale<0 then
		              Delta = gp.StringWidth(str(Floor(cAxe.MinimumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt) + 7
		            End if
		            
		            Delta = 10 + max(Delta, gp.StringWidth(str(Ceil(cAxe.MaximumScale/cAxe.MajorUnit) * cAxe.MajorUnit)+txt)) + 7
		            Plot.Width = Plot.Width - Delta
		          End If
		        End If
		      End If
		      
		      
		    Next
		    
		    If DoubleYAxe then
		      Axes.Append Axes(1)
		      
		      Plot.Width = Plot.Width - Delta
		    End If
		    
		    //Setting X axis again if needed
		    If SwapAxis then
		      If CrossesBetweenTickMarks = False then
		        Axes(0).UnitWidth = Plot.Height / UBound(Labels)
		      else
		        Axes(0).UnitWidth = Plot.Height / (UBound(Labels)+1)
		      End If
		    Else
		      if CrossesBetweenTickMarks=False then
		        Axes(0).UnitWidth = Plot.Width / UBound(Labels)
		      else
		        Axes(0).UnitWidth = Plot.Width / (UBound(Labels)+1)
		      End If
		    End If
		    
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Redisplay()
		  //Refreshes the entire view
		  
		  FullRefresh = True
		  
		  If Freeze then Return
		  
		  #If TargetDesktop
		    Invalidate(False)
		  #elseif TargetWeb
		    Dim p As Picture = me.ExportAsPicture()
		    
		    WebPic = New WebPicture(p)
		    
		    If ControlAvailableInBrowser() Then
		      ExecuteJavascript("var myElem = Xojo.get('" + me.ControlID + "_img');" + _
		      "if (myElem == null) {" + _
		      "Xojo.get('" + me.ControlID + "').innerHTML = ""<img id='" + me.ControlID + "_img' src='" + WebPic.URL + "'>"";" + _
		      "}else{" + _
		      "myElem.src = '" + WebPic.URL + "';" + _
		      "};")
		      
		    End If
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SafeInvalidate(EraseBackground As Boolean)
		  #If TargetWeb
		    
		    me.Picture = me.ExportAsPicture
		    
		  #Else
		    
		    me.Invalidate(EraseBackground)
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setDataLabel(TextFont As String = "System", TextSize As Single = 10, TextColor As Color = &c0, Shadow As Boolean = False, ShadowColor As Color = &cFFFFFF, Format As String = "0", HasBackColor As Boolean = False, BackColor As Color = &cFFFFFF)
		  //Sets up the data labels.
		  
		  If DataLabel is Nil then
		    DataLabel = New ChartLabel
		    
		  End If
		  
		  DataLabel.TextFont = TextFont
		  DataLabel.TextSize = TextSize
		  DataLabel.TextColor = TextColor
		  DataLabel.Shadow = Shadow
		  DataLabel.ShadowColor = ShadowColor
		  DataLabel.Format = Format
		  DataLabel.HasBackColor = HasBackColor
		  DataLabel.BackColor = BackColor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub setDataLabelFormat(Format As String)
		  //Sets up the data labels.
		  
		  setDataLabel("System", 10, &c0, False, &cFFFFFF, Format)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setDefaultColors(Assigns Palette As Integer)
		  //Sets the DefaultColors used to display several Series of data.
		  //The following Class constants can be used:
		  //**PaletteGoogle (default)
		  //**PaletteOffice2010
		  //**PaletteWindows8
		  
		  Select Case Palette
		    
		  Case PaletteGoogle
		    
		    Redim DefaultColors(-1)
		    
		    DefaultColors.Append &c3366CC
		    DefaultColors.Append &cDC3912
		    DefaultColors.Append &cFF9900
		    DefaultColors.Append &c109618
		    DefaultColors.Append &c990099
		    DefaultColors.Append &c0099C6
		    DefaultColors.Append &cDD4477
		    DefaultColors.Append &c66AA00
		    DefaultColors.Append &cB82E2E
		    DefaultColors.Append &c316395
		    DefaultColors.Append &c994499
		    DefaultColors.Append &c22AA99
		    DefaultColors.Append &cAAAA11
		    DefaultColors.Append &c6633CC
		    
		  Case PaletteOffice2010
		    
		    Redim DefaultColors(-1)
		    
		    DefaultColors.Append &c40699c
		    DefaultColors.Append &c9e413e
		    DefaultColors.Append &c7f9a48
		    DefaultColors.Append &c695185
		    DefaultColors.Append &c3c8da3
		    DefaultColors.Append &ccc7b38
		    DefaultColors.Append &c4f81bd
		    DefaultColors.Append &cc0504d
		    DefaultColors.Append &c9bbb59
		    DefaultColors.Append &c8064a2
		    DefaultColors.Append &c4bacc6
		    DefaultColors.Append &cf79646
		    DefaultColors.Append &caabad7
		    
		  Case PaletteWindows8
		    
		    Redim DefaultColors(-1)
		    
		    DefaultColors.Append &cf4b300
		    DefaultColors.Append &c78ba00
		    DefaultColors.Append &c2773ed
		    DefaultColors.Append &cae113e
		    DefaultColors.Append &c00c140
		    DefaultColors.Append &cff991d
		    DefaultColors.Append &cff2e13
		    DefaultColors.Append &cff1d77
		    DefaultColors.Append &caa3fff
		    DefaultColors.Append &c20aeff
		    DefaultColors.Append &c91d100
		    DefaultColors.Append &ce1b700
		    DefaultColors.Append &cff76bc
		    DefaultColors.Append &c00a4a5
		    DefaultColors.Append &cff7d23
		    
		  Case PaletteArctic
		    
		    Redim DefaultColors(-1)
		    
		    DefaultColors.Append &c8FCAEE
		    DefaultColors.Append &c4CA9D7
		    DefaultColors.Append &c1E7BA9
		    DefaultColors.Append &cBDC1C5
		    DefaultColors.Append &c8C8C8C
		    DefaultColors.Append &cCF1C1F
		    DefaultColors.Append &cF0484B
		    DefaultColors.Append &cFF867F
		    
		  Case PaletteForest
		    
		    Redim DefaultColors(-1)
		    
		    DefaultColors.Append &cADB827
		    DefaultColors.Append &cF1A54C
		    DefaultColors.Append &cA66940
		    DefaultColors.Append &cDB6340
		    DefaultColors.Append &cDCA063
		    DefaultColors.Append &c8BA041
		    DefaultColors.Append &cC09366
		    DefaultColors.Append &cF2BE4B
		    
		  Case PaletteRainbow
		    
		    Redim DefaultColors(-1)
		    
		    DefaultColors.Append &c1171CA
		    DefaultColors.Append &c3294DA
		    DefaultColors.Append &c45B5B2
		    DefaultColors.Append &c8CC221
		    DefaultColors.Append &cAFDA3D
		    DefaultColors.Append &cE3DA20
		    DefaultColors.Append &cF58E13
		    DefaultColors.Append &cE03D0B
		    
		  Else
		    
		    Raise New OutOfBoundsException
		    
		  End Select
		  
		  
		  
		  If UBound(Series) > -1 Then
		    Dim UColors As Integer = UBound(DefaultColors)
		    Dim i As Integer
		    For i = 0 To UBound(Series) //, UBound(DefaultColors))
		      
		      If i > UColors Then
		        Series(i).FillColor = DefaultColors(i Mod UColors)
		      Else
		        Series(i).FillColor = DefaultColors(i)
		      End If
		    Next
		  End If
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetMetrics()
		  
		  Dim intW, intH, intT, intL As Integer
		  
		  Dim xMargin As Integer = Margin
		  If Border then
		    xMargin = xMargin + 2
		  End If
		  
		  intW = me.Width-xMargin*2
		  intH = me.Height-xMargin*2
		  intT = xMargin
		  intL = xMargin
		  
		  Dim SwapAxis As Boolean = (Type \ 100 = TypeBar \ 100)
		  Dim TextHeight As Integer
		  Dim TextAscent As Integer
		  Dim p As Picture = New Picture(1, 1, 32)
		  Dim g As Graphics = p.Graphics
		  
		  If Axes(0) <> Nil and Axes(0).LabelStyle <> Nil then
		    
		    g.TextSize = Axes(0).LabelStyle.TextSize
		    g.TextFont = Axes(0).LabelStyle.textFont
		    
		    TextHeight = g.TextHeight
		    TextAscent = g.TextAscent
		  End If
		  
		  If TextHeight > 0 and Type<TypePie then
		    intH = intH - TextHeight
		  End If
		  
		  LabelTwoLevel = False
		  
		  If Type\100 = TypeTreeMap\100 then
		    LegendPosition = Position.None
		  End If
		  
		  If LegendPosition = Position.Top then
		    intT = intT + 10
		    intH = intH - 10
		    
		  elseif LegendPosition = Position.Right or LegendPosition = Position.Left then
		    Dim extraWidth As Integer
		    'Dim txt As String
		    g.TextSize = Legend.TextSize
		    g.TextFont = Legend.TextFont
		    
		    Dim X, i As Integer
		    
		    For i = 0 to UBound(Series)
		      X = 0
		      If Series(i).MarkerType = ChartSerie.MarkerTexture and Series(i).MarkerPicture <> Nil then
		        X = X + Series(i).MarkerPicture.Width+3
		      else
		        
		        X = X + g.TextAscent + 3
		        
		        'X = X + Series(i).MarkerSize/2 + 3
		        
		      End If
		      X = X + g.StringWidth(Series(i).Title)
		      extraWidth = max(extraWidth, X)
		    Next
		    
		    If LegendPosition = Position.Right then
		      intW = intW-extraWidth
		    elseif LegendPosition = Position.Left Then
		      intW = intW-extraWidth-10
		      intL = intL + extraWidth+10
		    End If
		    
		    
		  elseif LegendPosition = Position.BottomHorizontal then
		    intH = intH - 30
		  End If
		  
		  If Type \ 100 = TypeTrendAreaStepped \ 100 then
		    intH = intH-40
		    
		  End If
		  
		  //Offset if there is a Title
		  If Type < TypePie then
		    If (SwapAxis and Axes(1).Title <> "") Or (SwapAxis=False and Axes(0).Title <> "") then
		      
		      If TextHeight <> 0 then
		        intH = intH-TextHeight
		      else
		        intH = intH - 20
		      End If
		      
		    End If
		  End If
		  
		  
		  'If Title <> "" then
		  
		  
		  Plot.Width = intW
		  Plot.Height = intH
		  Plot.Left = intL
		  Plot.Top = intT
		  
		  If Type >= TypePie Then
		    Plot.Height = min(intW, intH)
		  End If
		  
		  Recalc()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setPieRadarStartAngle(value As Double, Radians As Boolean = False)
		  //#newinversion 1.2
		  //Sets the Value of the Start angle for Pie and Radar charts.
		  //By default, the value is in Degrees. If you need to set the value in Radians set the Radians parameter to True.
		  
		  If Radians then
		    
		    PieRadarAngle = wrapto2PI(value)
		    
		  else
		    
		    Const PI=3.14159265358979323846264338327950
		    
		    PieRadarAngle = wrapto2PI(value * PI / 180.0)
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setTransparency(Value As Integer)
		  //Sets the given transparency value to all Series
		  //0 is completely opaque, 100 is completely transparent
		  Dim i As Integer
		  For i = 0 to UBound(Series)
		    
		    Series(i).Transparency = Value
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupCSS_()
		  #if TargetWeb
		    styles(0).value("visibility") = "visible" // Every WebSDK control needs this
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupHTML_()
		  #if TargetWeb
		    Return "<div id=""" + self.ControlID + """></div>"
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupLocaleInfo()
		  #if TargetWin32
		    
		    Dim i, ret As Integer
		    Dim retVal As String
		    Dim mb as new MemoryBlock( 2048 )
		    
		    //Day Names
		    Const LOCALE_SDAYNAME1 = 42'&h0000002A
		    Const LOCALE_SDAYNAME2 = &h0000002B
		    Const LOCALE_SDAYNAME3 = &h0000002C
		    Const LOCALE_SDAYNAME4 = &h0000002D
		    Const LOCALE_SDAYNAME5 = &h0000002E
		    Const LOCALE_SDAYNAME6 = &h0000002F
		    Const LOCALE_SDAYNAME7 = &h00000030
		    dim dayConst( 7 ) as Integer
		    dayConst = Array( LOCALE_SDAYNAME1, LOCALE_SDAYNAME2, LOCALE_SDAYNAME3, _
		    LOCALE_SDAYNAME4, LOCALE_SDAYNAME5, LOCALE_SDAYNAME6, LOCALE_SDAYNAME7 )
		    
		    for i = 0 to 6
		      ret = GetLocaleInfo( dayConst( i ), mb, retVal )
		      DayNames((i+1) mod 7 +1) = Titlecase ( ConvertEncoding(retVal, Encodings.UTF8) )
		    next
		    
		    //Month Names
		    Const LOCALE_SMONTHNAME1 = 56'&h00000038
		    Const LOCALE_SMONTHNAME2 = &h00000039
		    Const LOCALE_SMONTHNAME3 = &h0000003A
		    Const LOCALE_SMONTHNAME4 = &h0000003B
		    Const LOCALE_SMONTHNAME5 = &h0000003C
		    Const LOCALE_SMONTHNAME6 = &h0000003D
		    Const LOCALE_SMONTHNAME7 = &h0000003E
		    Const LOCALE_SMONTHNAME8 = &h0000003F
		    Const LOCALE_SMONTHNAME9 = &h00000040
		    Const LOCALE_SMONTHNAME10 = &h00000041
		    Const LOCALE_SMONTHNAME11 = &h00000042
		    Const LOCALE_SMONTHNAME12 = &h00000043
		    Const LOCALE_SMONTHNAME13 = &h0000100E
		    dim monthConst( 13 ) as Integer
		    monthConst = Array( LOCALE_SMONTHNAME1, LOCALE_SMONTHNAME2, LOCALE_SMONTHNAME3, _
		    LOCALE_SMONTHNAME4, LOCALE_SMONTHNAME5, LOCALE_SMONTHNAME6, LOCALE_SMONTHNAME7, _
		    LOCALE_SMONTHNAME8, LOCALE_SMONTHNAME9, LOCALE_SMONTHNAME10, LOCALE_SMONTHNAME11, _
		    LOCALE_SMONTHNAME12, LOCALE_SMONTHNAME13 )
		    
		    ReDim MonthNames(12)
		    for i = 0 to 11
		      ret = GetLocaleInfo( monthConst( i ), mb, retVal )
		      MonthNames(i+1) = Titlecase( ConvertEncoding(retVal, Encodings.UTF8) )
		    next
		    
		    //Day of Week
		    Const LOCALE_IFIRSTDAYOFWEEK  = &h100C
		    ret = GetLocaleInfo( LOCALE_IFIRSTDAYOFWEEK, mb, retVal )
		    'FirstDayOfWeek = (Val( retVal ) + 1) mod 7 + 1
		    
		  #else
		    
		    Dim D As New Date
		    
		    For i as integer = 0 to 6
		      DayNames(D.DayOfWeek) = D.LongDate.NthField(" ", 1).Replace(",", "")
		      D.Day = D.Day + 1
		    Next
		    
		    D.Day = 1
		    D.Month = 1
		    Dim MonthField As Integer
		    If IsNumeric(D.LongDate.NthField(" ", 2)) then
		      MonthField = 3
		    else
		      MonthField = 2
		    End If
		    For i as Integer = 1 to 12
		      MonthNames(i) = TitleCase(D.LongDate.NthField(" ", MonthField)).Replace(",", "")
		      D.Month = D.Month + 1
		    Next
		    
		    'FirstDayOfWeek = 1 //Monday
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = TargetHasGUI
		Sub StartAnimation(From0 As Boolean = False, AnimationType As Integer = -1)
		  //This function is similar to Redisplay but with Animation.
		  //
		  //If From0 is True, the animation will start as if no previous Data was loaded.
		  //Use the Animation constants to specify the type of animation to use.
		  
		  'FullRefresh = True
		  'Freeze = False
		  'Refresh(False)
		  'Return
		  
		  If mAnimationTimer <> Nil and mAnimationTimer.Mode = timer.ModeMultiple then
		    Return
		  End If
		  
		  Animate = True
		  FullRefresh = True
		  AnimationInProgress = True
		  AnimIdx = 0
		  AnimInit = False
		  
		  If AnimationType > -1 then
		    self.AnimationType = AnimationType
		  End If
		  
		  If From0 then
		    Redim oldSeries(-1)
		  End If
		  
		  
		  Freeze = False
		  
		  
		  If mAnimationTimer is Nil Then
		    mAnimationTimer = New Timer
		    mAnimationTimer.Period = 1
		    
		    AddHandler mAnimationTimer.Action, AddressOf mAnimationTimerAction
		    
		  End If
		  
		  #if kDebug
		    System.DebugLog "Start Animation"
		  #endif
		  'mAnimationTimer.Mode = Timer.ModeMultiple
		  mAnimationTimer.Mode = timer.ModeSingle
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToCSV(Separator As String = ", ") As String
		  //Exports all data in CSV format.
		  
		  
		  Dim CSV As String = me.ToCSV_Internal(Separator)
		  
		  If CSV = "" then
		    System.DebugLog("Ubound(Series) = -1")
		  End If
		  
		  Return CSV
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToCSV_Internal(Separator As String = ", ") As String
		  //Exports all data in CSV format.
		  
		  Dim i, j As Integer
		  Dim USeries As Integer
		  Dim UValues As Integer
		  
		  USeries = UBound(Series)
		  If UBound(Series) < 0 then
		    
		    Return ""
		  End If
		  UValues = UBound(Series(0).Values)
		  
		  Dim Data() As String
		  Dim Lines() As String
		  
		  Dim HasLabels As Boolean
		  If Axes(0).LabelType <> "" then
		    HasLabels = True
		  End If
		  
		  If Axes(0).Title <> "" or Series(0).Title <> "" then
		    
		    If HasLabels then
		      Data.Append Axes(0).Title
		    End If
		    For i = 0 to USeries
		      Data.Append Series(i).Title
		    Next
		    Lines.Append Join(Data, Separator)
		  End If
		  
		  
		  For i = 0 to UValues
		    
		    Redim Data(-1)
		    If HasLabels then
		      Data.Append Axes(0).Label(i)
		    End If
		    
		    For j = 0 to USeries
		      
		      Data.Append str(Series(j).Values(i).DoubleValue)
		      
		    Next
		    
		    Lines.Append Join(Data, Separator)
		  Next
		  
		  Return Join(Lines, EndOfLine)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TransparencyPercentage(v As Integer) As Color
		  v = v / 100 * 255
		  
		  Return RGB(v, v, v)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TrendLine(Index As Integer, AddTrendLine As Boolean = True) As Pair
		  #Pragma Unused AddTrendLine
		  
		  //Displays a Trendline in the chart.
		  
		  //Source http://www-irma.u-strasbg.fr/~geffray/cours/cours-nantes/coursIUT4.pdf
		  
		  Dim a, b As Double
		  
		  Dim n As Integer = UBound(Labels)
		  
		  Dim SumXY As Double
		  Dim Xavg, Yavg As Double
		  Dim SumX2, SumY2 As Double
		  Dim i As Integer
		  
		  Dim X() As Double
		  For i = 0 to UBound(Axes(0).Label)
		    If IsNumeric(Axes(0).Label(i).StringValue) then
		      X.Append val(Axes(0).Label(i))
		    Else
		      X.Append i
		    End If
		  Next
		  
		  Dim XSerie As New ChartSerie
		  XSerie.Data = X()
		  
		  SumXY = Series(Index).SumXY(X())
		  
		  Xavg = XSerie.Average
		  Yavg = Series(Index).Average
		  
		  SumX2 = XSerie.SumSquared()
		  SumY2 = Series(Index).SumSquared
		  
		  a = (SumXY-n*Xavg*Yavg) / (SumX2 - n*Xavg^2)
		  b = Yavg - a*Xavg
		  
		  X.Sort
		  
		  Dim cs As new ChartSerie
		  Dim v() As Variant
		  Redim v(UBound(X))
		  cs.Values.Append a*X(0)+b
		  cs.Values.Append a*X(UBound(v))+b
		  
		  cs.X.Append X(0)
		  cs.X.Append X(UBound(v))
		  
		  cs.FillColor = Series(0).FillColor
		  cs.Type = me.TypeLine
		  cs.MarkerType = cs.MarkerNone
		  cs.LineWeight = 2
		  cs.MarkLine = True
		  
		  me.MarkSeries.Append cs
		  
		  me.Redisplay
		  
		  Return a:b
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function wrapto2PI(angle As Double) As Double
		  Const PI=3.14159265358979323846264338327950
		  
		  while (angle > 2.0 * PI)
		    angle = angle - 2.0 * PI
		  wend
		  while (angle < 0)
		    angle = angle + 2.0 * PI
		  wend
		  return angle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub _OldDrawAxis()
		  #if False
		    Dim mp As new MethodProfiler(CurrentMethodName)
		    
		    If Type < TypePie then
		      
		      Dim X, Y, W, H, i, U As Integer
		      Dim xx, yy As Double
		      X = Plot.Left
		      Y = Plot.Top
		      W = Plot.Width
		      H = Plot.Height
		      
		      Dim cAxe As ChartAxis
		      Dim cLine As ChartLine
		      Dim cLine2 As ChartLine
		      
		      Dim minI As Integer
		      If UBound(Axes)>0 then
		        cAxe = Axes(1)
		        If cAxe.MinimumScale < 0 then
		          minI = Floor(cAxe.MinimumScale/cAxe.MajorUnit)*cAxe.MajorUnit
		        else
		          minI = 0
		        End If
		        
		        BaseDrawY = H - minI*cAxe.UnitWidth
		      else
		        BaseDrawY = H
		      End If
		      
		      Dim SwapAxis As Boolean = (Type \ 100 = TypeBar \ 100)
		      
		      Dim lbl, txt As String
		      
		      U = UBound(Labels)
		      
		      Dim gg As Graphics = g.Clip(0, Y, g.Width, g.Height-Y)
		      
		      Dim LabelType As String
		      
		      If UBound(Axes)>-1 then
		        cAxe = Axes(0)
		        LabelType = cAxe.LabelType
		        
		        gg.ForeColor = &c0
		        If SwapAxis then
		          gg.DrawLine(X, 0, X, H)
		        else
		          gg.DrawLine(X, BaseDrawY, X+W, BaseDrawY)
		        End If
		        
		        cLine = Axes(0).MajorGridLine
		        cLine2 = Axes(0).MinorGridLine
		        
		        xx = X
		        yy = Y
		        
		        For i = 0 to U
		          gg.ForeColor = &c0 //a corriger
		          If SwapAxis then
		            gg.DrawLine(X-3, yy, X+3, yy)
		          else
		            gg.DrawLine(xx, BaseDrawY-3, xx, BaseDrawY+3)
		          End If
		          
		          //Drawing label
		          If i mod Axes(0).LabelInterval = 0 then
		            lbl = Labels(i)
		            
		            If LabelType = "Date" then
		              Dim d As new date
		              d.SQLDateTime = lbl
		              lbl = mParseDate(D, Axes(0).LabelStyle, D.SQLDate)
		            End If
		            
		            
		            If LabelTwoLevel and not SwapAxis then
		              //Multi Level Label
		              if i mod 2 = 1 then
		                gg.DrawString(lbl, xx + (cAxe.UnitWidth-gg.StringWidth(lbl))\2, BaseDrawY + 5 + gg.TextHeight*2)
		              else
		                gg.DrawString(lbl, xx + (cAxe.UnitWidth-gg.StringWidth(lbl))\2, BaseDrawY + 5 + gg.TextHeight)
		              end if
		            else
		              //Single Level Label
		              If SwapAxis then
		                gg.DrawString(lbl, -X, yy)
		              else
		                gg.DrawString(lbl, xx + (Axes(0).UnitWidth-gg.StringWidth(lbl))\2, BaseDrawY + 5 + gg.TextHeight)
		              End If
		            End If
		            
		          End If
		          
		          If cLine <> Nil then
		            gg.ForeColor = cLine.FillColor
		            If SwapAxis then
		              gg.DrawLine(X, yy, X + W, yy)
		            else
		              gg.DrawLine(xx, 0, xx, H)
		            End If
		          End If
		          
		          xx = xx + cAxe.UnitWidth
		          yy = yy + cAxe.UnitWidth
		          
		        Next
		        
		        If cAxe.Title <> "" then
		          gg.Bold = True
		          If LabelTwoLevel then
		            gg.DrawString(cAxe.Title, Plot.Left + (Plot.Width-gg.StringWidth(cAxe.Title))\2, H + 10 + gg.TextHeight*3)
		          else
		            gg.DrawString(cAxe.Title, Plot.Left + (Plot.Width-gg.StringWidth(cAxe.Title))\2, H + 10 + gg.TextHeight*2)
		          End If
		          gg.Bold = False
		        End If
		        
		      End If
		      
		      //Primary Y Axis
		      If UBound(Axes)>0 then
		        cAxe = Axes(1)
		        
		        gg.ForeColor = &c0
		        If SwapAxis then
		          gg.DrawLine(X, H, X+W, H)
		        else
		          gg.DrawLine(X, 0, X, H)
		        End If
		        
		        cLine = cAxe.MajorGridLine
		        cLine2 = cAxe.MinorGridLine
		        
		        yy = H
		        xx = X
		        
		        Dim tmpPercent As String
		        If Type mod 100 = 2 then
		          tmpPercent = "%"
		        End If
		        
		        Dim y1, y2 As Integer
		        Dim unitHeight As Double = cAxe.UnitWidth
		        For i = 0 to cAxe.ZoneStart.Ubound
		          
		          gg.ForeColor = cAxe.ZoneColor(i)
		          y2 = Floor((cAxe.ZoneEnd(i) - cAxe.ZoneStart(i)) * unitHeight - 1)
		          
		          If SwapAxis then
		            y1 = Ceil(gg.Width-cAxe.ZoneEnd(i) * unitHeight)
		            gg.FillRect(y1-y2, 0, y2, H-1)
		            
		          else
		            y1 = Ceil(H - cAxe.ZoneEnd(i) * unitHeight)
		            gg.FillRect(X+1, y1, W-2, y2)
		          End If
		        Next
		        
		        
		        If cAxe.MinimumScale < 0 then
		          i = i
		        End If
		        For i = minI to cAxe.MaximumScale+cAxe.MajorUnit step cAxe.MajorUnit
		          
		          If cLine <> Nil and i<>0 then
		            gg.ForeColor = cLine.FillColor
		            if SwapAxis then
		              gg.DrawLine(xx, H-3, xx, H+3)
		            else
		              gg.DrawLine(X+3, yy, W+X, yy)
		            End If
		          End If
		          
		          gg.ForeColor = &c0
		          If SwapAxis then
		            gg.DrawLine(xx, H-3, xx, H+3)
		          else
		            gg.DrawLine(X-3, yy, X+3, yy)
		          End If
		          
		          
		          txt = str(i) + tmpPercent
		          If SwapAxis then
		            
		            gg.DrawString(txt, xx + (cAxe.UnitWidth-gg.StringWidth(txt))\2, H + 5 + gg.TextHeight)
		          else
		            If yy < 1 then
		              g.DrawString(txt, X-7-g.StringWidth(txt), Y + yy - g.TextHeight\2 + g.TextAscent)
		              exit for i
		            else
		              
		              gg.DrawString(txt, X-7-gg.StringWidth(txt), yy - gg.TextHeight\2 + gg.TextAscent)
		            End If
		          End If
		          
		          
		          
		          yy = yy - axes(1).UnitWidth
		          xx = xx - axes(1).UnitWidth
		        Next
		      End If
		      
		      //Secondary Y Axis
		      If UBound(Axes)>1 then
		        cAxe = Axes(2)
		        
		        X = Plot.Left + Plot.Width-1
		        
		        gg.ForeColor = &c0
		        gg.DrawLine(X, 0, X, H)
		        
		        cLine = Axes(2).MajorGridLine
		        cLine2 = Axes(2).MinorGridLine
		        
		        yy = H
		        
		        Dim tmpPercent As String
		        If Type mod 100 = 2 then
		          tmpPercent = "%"
		        End If
		        
		        Dim y1, y2 As Integer
		        Dim unitHeight As Double = cAxe.UnitWidth
		        For i = 0 to cAxe.ZoneStart.Ubound
		          y1 = H - cAxe.ZoneEnd(i) * unitHeight
		          y2 = (cAxe.ZoneEnd(i) - cAxe.ZoneStart(i)) * unitHeight - 1
		          
		          gg.ForeColor = cAxe.ZoneColor(i)
		          gg.FillRect(X, y1, W, y2)
		        Next
		        
		        For i = 0 to Axes(1).MaximumScale+Axes(2).MajorUnit step Axes(2).MajorUnit
		          
		          If cLine <> Nil and i<>0 then
		            gg.ForeColor = cLine.FillColor
		            gg.DrawLine(X+3, yy, W+X, yy)
		          End If
		          
		          gg.ForeColor = &c0
		          gg.DrawLine(X-3, yy, X+3, yy)
		          
		          
		          txt = str(i) + tmpPercent
		          
		          If yy < 1 then
		            g.DrawString(txt, X-7-g.StringWidth(txt), Y + yy - g.TextHeight\2 + g.TextAscent)
		            exit for i
		          else
		            
		            gg.DrawString(txt, X-7-gg.StringWidth(txt), yy - gg.TextHeight\2 + gg.TextAscent)
		          End If
		          
		          
		          
		          yy = yy - axes(1).UnitWidth
		        Next
		        
		        
		      End If
		      
		      
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub _OldPaint()
		  #if False
		    If Freeze then Return
		    
		    Dim gg, gp As Graphics
		    
		    If Plot is nil then Return
		    
		    #if DebugBuild
		      Dim ms As Double = Microseconds
		    #endif
		    
		    If LastSize <> Width * Height then
		      FullRefresh = True
		      RangeBuffer = Nil
		      LastSize = Width * Height
		    End If
		    
		    If FullRefresh or  Buffer is Nil then
		      
		      Buffer = New Picture(Width, Height, 32)
		      
		      LastSize = Width * Height
		      
		      SetMetrics
		      
		      
		      gg = Buffer.Graphics
		      
		      DrawLegend(gg)
		      DrawAxis(gg)
		      
		      gp = gg.Clip(Plot.Left, Plot.Top, Plot.Width, Plot.Height)
		      
		      If Type\100 = TypeColumn\100 then
		        
		        PlotColumn(gg)
		        
		      Elseif Type\100 = TypeLine\100 then
		        
		        PlotLine(gp)
		        
		      Elseif Type\100 = TypeArea\100 then
		        
		        PlotArea(gp)
		        
		      Elseif Type\100 = TypeBar\100 then
		        
		        PlotBar(gg)
		        
		      Elseif Type\100 = TypeTrendTimeLine\100 then
		        
		        PlotTrend(gg)
		        
		      Elseif Type\100 = TypePie\100 then
		        
		        PlotPie(gp)
		        
		      End If
		      
		      DrawMark(gg)
		      
		      If Border then
		        gg.ForeColor = &c0
		        gg.DrawRect(0, 0, gg.Width, gg.Height)
		      End If
		      
		      FullRefresh = False
		      
		    End If
		    
		    
		    g.DrawPicture(Buffer, 0, 0)
		    
		    #if DebugBuild
		      ms = Microseconds - ms
		      g.DrawString(str(ms/1000), g.Width-100, 10)
		    #endif
		  #endif
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AnimationFinished()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ClosestDataPointChanged(Data As ChartDataPoint)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetFillPicture(ByRef p As Picture, Serie As ChartSerie, Index As Integer, Label As String, DrawX As Integer, DrawY As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetHelpTag(Idx As Integer) As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseMove(X As Integer, Y As Integer, ValueIndex As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event UpdateAvailable()
	#tag EndHook


	#tag Note, Name = History
		===Version 1.5.2 - Released ===
		*New
		**Pie charts: display serie title next to value
		
		===Version 1.5.0 - Released 2015-02-02===
		*New
		**Chart Type: TreeMap
		**LoadFromJSON function
		**Backward compatibility for RealStudio 2011r4
		*Fix:
		**Drawing on the Secondary Axis
		**AddZone works correctly when minimum Value isn't 0
		**AddMark works correctly when minimum Value isn't 0
		**ExportAsPicture on MacOS and Linux
		**OutOfBoundsException when a ChartSerie has no values
		
		
		===Version 1.4.2 - Released 2014-08-22===
		*Fix:
		**Registration for Web Applications
		**Rendering on Windows Target
		
		===Version 1.4.1 - Released 2014-08-06===
		*New:
		**TypePie3D
		**WebChartView is now a WebControlWrapper
		
		===Version 1.4 - Released 2014-07-25===
		*New:
		**Updated for Web Applications
		
		===Version 1.3 - Released 2014-04-25===
		*New:
		**Chart Type: Scatter
		**Chart View is now Retina compatible.
		**Animation is optimized and works on MacOS
		**Drawing optimizations
		**Smoother drawing on Windows
		**Display a Linear regression line on Scatter charts (TrendLine)
		**Display a Moving Average line
		*Fix:
		**ToCSV with empty data
		**LoadFromListbox when no data was previously loaded
		
		===Version 1.2 - Released 2013-11-27===
		*New:
		**Chart Types: ComboChart, PieChart, DoughnutChart, RadarChart
		**Improved HelpTags and LineSmooth performance
		**AnimationFinished event
		**Empty value is not treated as 0 but as missing value.
		**Logarithmic (base 10) scale on Vertical Axis
		**ChartSerie function Average, to calculate the average value of the Serie.
		**ExportGraph function, exports the Chart in the passed picture. This can be used for Sparklines
		**StartAnimation now takes a AnimationType property. Check the ChartAnimate constants.
		**BackgroundAlternate constant
		**ChartSerie TotalValue property, the sum of all values.
		*Fix:
		**TypeColumnStacked with negative values and transparency.
		*Improved:
		**Improved speed of drawing Area charts up to 60%
		
		
		===Version 1.0 - Released 2013-05-06===
		First public release of the ChartView
		*Features:
		**Chart Types:
		***Column, ColumnStacked, ColumnStacked100
		***Line, LineStacked, LineSmooth
		***Area, AreaStacked, AreaStepped
		
		
		
	#tag EndNote

	#tag Note, Name = Notes
		
		===Defining the default colors===
		The default colors for each Chartserie is entirely customizable.
		
		*The quick way:
		In the ChartView.open event use one of the following lines:
		
		<source lang="realbasic">
		me.setDefaultColors = me.PaletteGoogle
		me.setDefaultColors = me.PaletteOffice2010
		me.setDefaultColors = me.PaletteWindows8
		</source>
		
		
		*The advanced way:
		In the ChartView.open event:
		
		<source lang="realbasic">
		Redim me.DefaultColors(-1) //Deleting all DefaultColors
		
		me.DefaultColors.append &cFF0000 //red
		me.DefaultColors.append &c00FF00 //green
		me.DefaultColors.append &cFF0000 //purple
		...
		</source>
		
		
		===Changing display options when loading Data===
		When using one of the following functions:
		*LoadFromCSV
		*LoadFromDB
		*LoadFromListbox
		
		The ChartView automatically refreshes the display.<br>
		If you need to edit the display before refreshing, you can use the following code:
		
		<source lang="realbasic">
		me.Freeze = True //This freezes the display until you unfreeze it
		me.LoadFromListbox(Listbox1)
		
		//Edit the ChartSerie colors
		For i = 0 to Ubound(me.Series)
		
		  If i = 0 then
		    me.Series(i).FillColor = &cFF0000
		  Elseif i = 1 then
		    me.Series(i).FillColor = &c00FF00
		  Elseif i = 2 then
		    me.Series(i).FillColor = &c0000FF
		
		  //And so on for all series
		  End If
		Next i
		
		//Edit the Y Axis
		me.Axes(0).MinimumScale = 10
		
		me.Freeze = False //Unfreeze the display
		
		If me.Animate then
		  me.StartAnimation()
		else
		  me.Redisplay()
		End If
		</source>
	#tag EndNote

	#tag Note, Name = See Also
		[[ChartAxis]], [[ChartHelpTag]], [[ChartLabel]], [[ChartLine]], [[ChartMarkLine]], [[ChartPlot]], [[ChartSerie]] classes.
		
	#tag EndNote

	#tag Note, Name = ToDo
		#ignore in LR
		
		
		-Logarithmic axis
		
		-Timeline
		
		-Pie chart
		->Done
		
		-Radar chart
		->Done
		
		-MouseOver
		
		-Export
		
		-Print ?
		
		-Zoom in/out
		
		AnimationHorizontal
		
		-Shades behind graphs like here: 
		http://www.gizmodo.fr/2013/05/15/part-marche-iphone.html
		->Done for Line graphs
		
		
		LabelIntervalIsAuto
		
		
		If you absolutely need to display several series, you will need to organize your data like this:
		
		X    Serie 1    Serie 2
		100    10    20
		101    11
		102        19
		103    20    15
		104    22
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			If True, the Chart will animate when loading Data.
			If previous data was already loaded in the ChartView, the animation will animate from the previous value to the new one.
			
			Use the AnimationTime property to set the duration of the Animation.
		#tag EndNote
		Animate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			To do!
		#tag EndNote
		AnimationHorizontal As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected AnimationInProgress As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected AnimationPercent As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Duration of animation in milliseconds.
			Default is 800ms.
		#tag EndNote
		AnimationTime As Integer = 800
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			The last used animation.
		#tag EndNote
		Protected AnimationType As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private AnimIdx As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private AnimInit As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private AnimMaxFrame As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private AnimPercent() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private AnimStartTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private AnimTimes() As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The different Axes of the ChartView.
		#tag EndNote
		Axes() As ChartAxis
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected BackgroundBuffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Background colors of the ChartView.
			If the dimension of the Array is 1, and BackgroundType is BackgroundGradient, the background will be drawn as a vertical gradient.
		#tag EndNote
		BackgroundColor() As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The filling type of the Background.
			The following Class constants can be used:
			**BackgroundNone
			**BackgroundSolid
			**BackgroundGradient
		#tag EndNote
		BackgroundType As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Not in use for the moment
			To do
		#tag EndNote
		Private BarGapPixel As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			To do
		#tag EndNote
		Private BarOverLapRatio As Double
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			The 0 horizontal line isn't always at Plot.Height
			This property keeps the Y value in pixels of this line.
		#tag EndNote
		Protected BaseDrawY As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, a Border is drawn around the ChartView.
			The Color of the Border can be set using the BorderColor property.
		#tag EndNote
		Border As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Color of the Border.
		#tag EndNote
		BorderColor As Color = &c828790
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Buffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The major axis of a chart can be either discrete or continuous.
			When using a discrete axis, the data points of each series are evenly spaced across the axis, according to their row index.
			
			When using a continuous axis, the data points are positioned according to their domain value.
		#tag EndNote
		Continuous As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CrossesBetweenTickMarks As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The DataLabel formatting properties.
		#tag EndNote
		DataLabel As ChartLabel
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The names of each day of Week, starting by Sunday.
			DayNames(1) = Sunday
			DayNames(7) = Saturday
		#tag EndNote
		DayNames(7) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The default colors used to display every different ChartSerie.
			
			Use the SetDefaultColor function with the Palette constants to update the DefaultColors.
		#tag EndNote
		DefaultColors() As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Handles the AutoUpdate after the app is open.
		#tag EndNote
		Private DelayedAutoUpdate As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		DisplaySelectionBar As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1
			If True, the Y Axis is displayed left and right of the Chart.
		#tag EndNote
		DoubleYAxe As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			The radius of the transparent circle inside the Doughnut.
			If the Value is greater than 1 then it is considered as an amount of Pixels.
			If the Value is smaller than 1 then it is considered as a percentage.
		#tag EndNote
		DoughnutRadius As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			
			This property only applies to Pie charts for the moment.
			If True, a Pie slice can be selected by clicking on it.
		#tag EndNote
		EnableSelection As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			If True and FollowValues is True, a vertical bar is displayed instead of a Marker on a single ChartSerie.
		#tag EndNote
		FollowAllSeries As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			//newinversion 1.1
			If True, when moving the mouse around the graph, the closest Marker will be highlighted.
		#tag EndNote
		FollowMouse As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			//newinversion 1.2
			If True, when moving the mouse around the graph, the closest Marker will be highlighted.
		#tag EndNote
		FollowValues As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the ChartView will not refresh its contents.
			
			Set this property to True before calling LoadFromCSV or LoadFromRecordset if you need to do some setup before displaying the Chart.
		#tag EndNote
		Freeze As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected FullRefresh As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HelpTag2 As ChartHelpTag
	#tag EndProperty

	#tag Property, Flags = &h1, CompatibilityFlags = not TargetWeb
		Protected HelpTagTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HelpTagVisible As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HighlightPoints() As ChartDataPoint
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Labels() As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LabelTwoLevel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			The datapoint the mouse is closest to.
		#tag EndNote
		Protected LastDataPoint As ChartDataPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			When loading Data to the ChartView, in the event of incorrect Data, the LastError property contains information about this error.
		#tag EndNote
		LastError As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Legend styling
		#tag EndNote
		Legend As ChartLabel
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The position of the Legend.
			
			As of version 1.0 of the ChartView, only PositionNone and PositionTop are accepted.
			
			Since version 1.4.1, the LegendPosition is now an Enumeration.
		#tag EndNote
		LegendPosition As Position
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the ChartView will refresh when its containing window is being resized.
			
			The Default is false in order to improve performance.
		#tag EndNote
		LiveRefresh As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0, CompatibilityFlags = not TargetWeb
		mAnimationTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1
			The Margin in pixels for top, left, bottom and right.
			The Default Value is 20
		#tag EndNote
		Margin As Integer = 20
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This property holds all MarkLines which are horizontal lines displayed in the Chart.
			
			A MarkLine can be used for displaying a Minimal target for example.
		#tag EndNote
		Marks() As ChartMarkLine
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Array of Series of the ChartView.
		#tag EndNote
		MarkSeries() As ChartSerie
	#tag EndProperty

	#tag Property, Flags = &h21
		Private maxValue As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private maxValueSecondary As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private minValue As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private minValueSecondary As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Month names from MonthNames(1)=January to MonthNames(12)=December.
			
			On Windows, the MonthNames are automatically retrieved.
			On Macintosh and Linux, the ChartView will try to retrieve the MonthNames using Date.LongDate.
		#tag EndNote
		MonthNames(12) As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The Chart Type.
			Use the Class Constants Type... to define the Type of the Chart.
		#tag EndNote
		Private mType As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected oldSeries() As ChartSerie
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			The Start angle for Pie and Radar Charts.
			The angle is in Radians. If you need to set the value in degrees, use the setPieRadarStartAngle function.
		#tag EndNote
		PieRadarAngle As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Plot area of the ChartView.
		#tag EndNote
		Plot As ChartPlot
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1
			When Precision = 1, all values are drawn.
			The more you increase Precision, the less values will be displayed.
		#tag EndNote
		Precision As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected RangeBuffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected RangeSelectorHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.2
			Holds the selected Pie slices
		#tag EndNote
		SelectedSlice() As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Array of Series of the ChartView.
		#tag EndNote
		Series() As ChartSerie
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.1.0
			If True, Custom HelpTags are displayed when moving the mouse inside the plot area.
		#tag EndNote
		ShowHelpTag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ShowRangeSelector As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Chart Title.
		#tag EndNote
		Title As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mType = value
			  BackgroundBuffer = Nil
			End Set
		#tag EndSetter
		Type As Integer
	#tag EndComputedProperty


	#tag Constant, Name = AnimateBounce, Type = Double, Dynamic = False, Default = \"29", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AnimateLinear, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BackgroundAlternate, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BackgroundGradient, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BackgroundNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BackgroundSolid, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JavascriptNamespace, Type = String, Dynamic = False, Default = \"jly.WebChartView", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDebug, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOpenSource, Type = Boolean, Dynamic = False, Default = \"True", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kProductKey, Type = String, Dynamic = False, Default = \"ChartView", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kReleaseDate, Type = Double, Dynamic = False, Default = \"20171106", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.6.0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LayoutEditorIcon, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAAMgAAACCCAIAAACM+RDDAAAEJGlDQ1BJQ0MgUHJvZmlsZQAAOBGFVd9v21QUPolvUqQWPyBYR4eKxa9VU1u5GxqtxgZJk6XtShal6dgqJOQ6N4mpGwfb6baqT3uBNwb8AUDZAw9IPCENBmJ72fbAtElThyqqSUh76MQPISbtBVXhu3ZiJ1PEXPX6yznfOec7517bRD1fabWaGVWIlquunc8klZOnFpSeTYrSs9RLA9Sr6U4tkcvNEi7BFffO6+EdigjL7ZHu/k72I796i9zRiSJPwG4VHX0Z+AxRzNRrtksUvwf7+Gm3BtzzHPDTNgQCqwKXfZwSeNHHJz1OIT8JjtAq6xWtCLwGPLzYZi+3YV8DGMiT4VVuG7oiZpGzrZJhcs/hL49xtzH/Dy6bdfTsXYNY+5yluWO4D4neK/ZUvok/17X0HPBLsF+vuUlhfwX4j/rSfAJ4H1H0qZJ9dN7nR19frRTeBt4Fe9FwpwtN+2p1MXscGLHR9SXrmMgjONd1ZxKzpBeA71b4tNhj6JGoyFNp4GHgwUp9qplfmnFW5oTdy7NamcwCI49kv6fN5IAHgD+0rbyoBc3SOjczohbyS1drbq6pQdqumllRC/0ymTtej8gpbbuVwpQfyw66dqEZyxZKxtHpJn+tZnpnEdrYBbueF9qQn93S7HQGGHnYP7w6L+YGHNtd1FJitqPAR+hERCNOFi1i1alKO6RQnjKUxL1GNjwlMsiEhcPLYTEiT9ISbN15OY/jx4SMshe9LaJRpTvHr3C/ybFYP1PZAfwfYrPsMBtnE6SwN9ib7AhLwTrBDgUKcm06FSrTfSj187xPdVQWOk5Q8vxAfSiIUc7Z7xr6zY/+hpqwSyv0I0/QMTRb7RMgBxNodTfSPqdraz/sDjzKBrv4zu2+a2t0/HHzjd2Lbcc2sG7GtsL42K+xLfxtUgI7YHqKlqHK8HbCCXgjHT1cAdMlDetv4FnQ2lLasaOl6vmB0CMmwT/IPszSueHQqv6i/qluqF+oF9TfO2qEGTumJH0qfSv9KH0nfS/9TIp0Wboi/SRdlb6RLgU5u++9nyXYe69fYRPdil1o1WufNSdTTsp75BfllPy8/LI8G7AUuV8ek6fkvfDsCfbNDP0dvRh0CrNqTbV7LfEEGDQPJQadBtfGVMWEq3QWWdufk6ZSNsjG2PQjp3ZcnOWWing6noonSInvi0/Ex+IzAreevPhe+CawpgP1/pMTMDo64G0sTCXIM+KdOnFWRfQKdJvQzV1+Bt8OokmrdtY2yhVX2a+qrykJfMq4Ml3VR4cVzTQVz+UoNne4vcKLoyS+gyKO6EHe+75Fdt0Mbe5bRIf/wjvrVmhbqBN97RD1vxrahvBOfOYzoosH9bq94uejSOQGkVM6sN/7HelL4t10t9F4gPdVzydEOx83Gv+uNxo7XyL/FtFl8z9ZAHF4bBsrEwAAAAlwSFlzAAALEwAACxMBAJqcGAAAEu9JREFUeAHtXX1wE9e1313ZsQik2GA+WlP7ESxZsmE6eSU0IZDG5Vv+JKV90zYTCJMAiSExIYEkZN4fTXkFY75MCE5eShOm02lfH2BbNtiGZNIUmL7gliRgayWbOpjPBFxDHBcZrN13dlcfq5W02l3tykJ7dzzeu+ee+7vn/Pbo3KvV3l28tbUVQxtiQG0GUgBw1qxZasMiPF0zcPz4cULXBCDnNWOAyVg0TWuGj4B1ygDKWDo98Vq7jQJLa4Z1ih8tsPD2X37/vpHs9uQfWY4Ckl8cxCVLdEqvft2OEljU/xxK2d8/MDDQ//7iA8uZSDrzy6dqTPtA8tdXOlf8x5+AOSkS/RKsV8+jBBbxk9dfK2C4IX5aXoa5yPb2Q3UO2+KfgGTqktLJ9rqDBgkSLrHplWJ9+h0lsPyk0O1kp7m0fJqDJC2WqYwYL7CYmFDriC4564dBBb0wwFxuiL7h7W88scX6Sn8+/b8YZmYCK+gChRRJoJOZM2d+9tlngWNIflOn1tfX8yWonJgMpKWlZWRkSLFN0nWsP/18Zk3uvms/ZS540ZjLcYaiC3AoQXRJk1A0HRgOT5w4wVk2atSob775RoqVSCdxGJB41TP6UHjmjR8853n32h+WML7RFovF6yN91tGFmaz51uiSqYGoShyCkCWaMhAlsKgDTzxyqPjPXFSBIXTB4jJ8xxsHoHj2gL27ePFiSoIkaNzU1B0EnigMiM6x8PZf/bqBclEzRm3h7H18X//+/9y35vsPjxq1jDBv+OvfmTQ2TYIkUdxFdsSLARxum4HZdLy6C+oHzbGC6Eiig5MnT0YZCpPIWeRKXBlAgRVXuvXTGTPHoihquBwexq6Hy2Wd9Isylk5OdLzdRIEVb8Z10h8KLJ2c6Hi7iQIr3ozrpD8UWDo50fF2EwVWvBnXSX8osHRyouPtpqTbZrQzSuI9GNoZcFcgnzp1SpmdDz74oLKGsbdCGSt2DhFCGAaiBxZ1YOno0Q9tdngb0+SmH4z2bhnTN5FwqxXh+NWMDFb0ZB2HFyoJ0zUSJTMDooHFxkdWA10qZKDs/f6bsPW1bbTQWPsby980vQuHJ9d3rvoZc6tWqEQIgI6TnQHRwKKsr3/Sd+V3ZWIkEI5D9eSi8h+DTv6Pi3Ma6+sMIRLRTsTAUd1dy4Cyc16/9D4Y+tjxEe9wOvPyfOt2zLBupyNE0n7X0oMMV8qA6B2k4UBxy8b/u7kRato3PTzzoSctA5DPzBZYexh0h0SoJIA1e/bszz//nDuG8IQCWqUTYCdcaXBwMJw4uuz69evRleRopKamcqcsaiMJlxsodjUOLLQJvnU9//WXSqq2kme5dTt0WT4TW4yKdyVPQEIHt/344485s9LT02/cuBHVRKQAi66UkTB27FhlDUVaCeMggqqyoZAHBut2zN5DuoPsxEwWWLcTLLGya6l5bVAx+RlQHlgHnljRZCops+aXl+O7Nh0EqjoONp4vKi/zWIWS4FSX/KQiDzFMdI6FOzbNeGSrk5k92WemV5nWn/zb4gMPeiUEHLa9BpcbsI2/WT3jkfT05azkcRgKC0IkiGqOgYJ3Lkeion3FdyJV3Y1yZpXOjBkzhsV0Hc6xlAVWW1ubshM0ffp0ZQ1jbPXJJ5+IZqwY4ZOlubJoSBbvFfqhfI6lsEPUTB8MJHPGilum6b01dM1N997y9A5SvbfoXrenz03fcHtu3KJuDtL9bk+/mxocEg0oml7W0nt/eqopI8WSkZKfkZqWIvbAi6V/jzghe//fI07jRC1QuVLCdSyVewyCk3hRJKiNGgfK+w2+mvfQ/isDblg9JxYEnL0ERo80Ev1u3jdkPxSOYzh+6vwg/PmdG/8tIic9ZTIbatg3RI7Rc4/BXylW4LvGL4u10aAuETPW1P++EsnTs898O1JVuBluloiyh6ZvDhn6hvBx91uv/4vqdUOyof4JacZN3YR8c8vTf4v6150QAAgC3sYGCp6Wgt1nJO4zGkan4ekjiHSjIcOIj0nDx4wgMtOIsUZD5gg8cwRDdZBrfig2wjY+lt7ZN9R94875G0NffU2xf7dP9dxme5sI/zPS7kxIu/1toyfLGGoWz6bIxVCKlp2OSNF7D1zyIyn4EpCIgeX3R82CPz2woKs+m+CmfL6TfSId3ZuKhQkvXwORQPepSNizEfYz871+VfcQ5ei7Q/Z5uFDr+nKgbzCV+yO/9msldMFHbkIbGWSch6K+ctPXblHX3R5+prlwNX3Ak9J/G781RASCxt/Unx5YCadgJIZGpFDjM0aONuLpRmKM0TB2BCQYIvNeItNoGDeCGG/EDQQRlGb8gFoWjCnEA+PSHhjn7aOtrfu2BzvvNpx3p15yp15xG8ivR0bqn0tCXtcuX+e7NvBP47dSqdEpnowUGv4bgjmJBKhMnvCBFZxpZrx3JXL+COIamA0TXj6SgvN8jk+s+V5xhoMJlmmkB/4wzA1WLjvNczaYIqPBA44zf7exvi8Fg2bQT4dAkXYOD39ghQ78GMYb+IM/VVxUhc00A1e+EHwcRSYQ2hHKR/7i50v5h9LL//b796Urw8Sfr1z7vS8jTR8vXO3lJ3WRDx4fUFl5+ANLlt0imaZtkPko+7Ygrn1ChXvFaUZhfzE3gzFuTCo1JhWbnmXkg7W1neMfQlm7zx4TWMP4yJdYuo6lLZ9ftXD4mDGW1TJpGHHusowl64Tx05v0hj1PPCVdma+Z/bvf8g81LStzTVOTBODoJx0BIehQHQaiZyz60FOZT3euP358g5XpEiccmx56dBtzL03Jvr73yuCqswSJLGMT/+Moy51EVtaOarGMBRHzXzPHZTfQxTxu2jeteGvKO729vX956VzFLw5BjRQJDwAVdcGAWGDRlPW1k9cu7oflEt4NQq3OTi4oXwzH+Y/bcg7X1xskSMQ68UGjfXIxIPOc4yQs9jLDugkYE/MtuViX0xFdQqLlX8kVNFK8iT7HCkHJDVnsJUUSgCksLPQv/4JlJEuWLJkwYYLNZgtoSCsJVvjcvs39XiutMU9LiHNHcLWapypaFOCA7m2VoFRzLWaKUlJS4On8ojR4K5nAEr+5wlsLO1jXxfx60EWepUutvlbSJIyWb/vwww+5YmZmJix8O336tK9G3l6wwO2ee+6R196nLcD5OjXVVyNvL8CBxmpBqeWaKjjeeIjGjcyhkLbk+Zd2tTu7sFyzNbokDy3/inYakq9eZmBR1tJSfPdm5stgR93h80WlsNgruiRokXTycYg8CsOAaGARjl8/Mj4z45lGzFE1O3P8w5vhoUUFr739XNdKGMUK621H9zNfD6VIwvSMREnNgOjknbK+euKrV/n+w1SJ5gm5mRNfLZKED4LKOmBANGPpwH/kokYMoMDSiFi9w0a/3KApQ8xFDP6lCDmdCRoKDqUjCRoKDhXjQEO1oBINRwonKGNJYQnpyGYABZZsylADKQygwJLCEtKRzQAKLNmUoQZSGECBJYUlpCObARRYsilDDaQwMPyXG6RYGVZH8ZdwAVqi4YB5iWaSAntQxhKEGTpUhwEUWOrwiFAEDKDAEhCCDtVhQHZg0c4ts8d7t4kztzjBDJzcPGsiK1rewC1tD5WoYy1CuWsYkB1YrGfF7177CrarJzfkwR1/m1fuzd0Lhx+tO7dmKXsPYIjkruEDGaoSA8oCi9c5TjbYnfNLy0FkLbdlH7Y3ECESNZ/QwesaFROYAWWB1fj0OBj6Ht1KMuOg02U25zOxg1vzYEGYixRKnL6XaCYwD8g0lRlgrmPJeyaJ6eU/X30ZWjmqCgsfXW6+XoLBkgoLg4HjzP2j7DWPYAlU8m57nzdv3pkzZzg/IDwVL//q7+/nQLj/d5SutRLiDCl8HJkAB6y6oxKUaq7FTJHBYDAagx6NxD8F/LLorcl8xZBy/quVRdt3uJhs1OXswEosfI1QSaD26NGj3MHEiROvXr366aefBurklEaO5D3VDsPAZzmtA7oCnD6VcKADtaDUck0tnAB3kUvKhsIAHk1bzCbvIe1gF4TB68CCJXnsyulAG1TSAQPKA+vgU88dybWV5uWVluB7quqAK0fdkR5bcYknRMIbB3VAKXKRYUDeUIgTzs2zCne4mEghcl/86MR6M43hr9SumlU4ceIqVlIOb//KD5EgsvXGgLzAoqm8DR9f3uAniV3sFSSMIPG3QAWdMKB8KNQJQchNZQwwGUvBTRHKOgttFUvXsbTlW5JoOCqekWF0DWUsfoyhsmoMoMBSjUoExGcABRafDVRWjQEUWKpRiYD4DKDA4rOByqoxgAJLNSoREJ8BFFh8NlBZNQbQdSzVLuOpddEIzq1aUMOIgzKWap9RBMRnAAUWnw1UVo0BFFiqUYmA+AxoE1i4o+qxSd9htmca0UoKPt+6KWsSWB1Vq9+esufy5cvH1v7jheX1WpO5bNkyVbpAOKrQyIFoEFi4o7HJOa+YeWeYtWRh9pFGrZNWa2urKowgHFVo5EA0uNyAu1wuk8XCftW1mqdgh8kOuihoqUXAflBi9QIS6SV+QxaGe8a8dACvpkY4gM5HlmWWvyFX8B/KAuEboBaOdAPk3UEqGTc3D17HGuFEL1y40L/8KysrSzKmmGJC4PB8idUeH1SsOD7O1MKZNm1ac3OzD1Vsr1FgwXsMseIIWcpvGXh76dIlMeuk1SEccZ7U4ke8F0GtBnMs2pwrWP7Fvkxa0DE6TG4GtAgsS2kRvrea+TJINjRfWFRUHGFMhGXQqpCLcMRpVIsf8V4EtTh8FSooUPuFgji55YfzajopYkrlsb+8nBchsASmoMOkYaC9vV2bORZt2fDRBe8qMRRVSRMvchzRYCiU0z3STVYGNLiOlaxUIb/kMIAylhy2kK5kBlBgSaYKKcphAAWWHLaQrmQGEimwCPszk+ZsJ2P4GknYV0z67iTfNr8KHmUZskXthQUxPd0gaNlRPXeSUvPqV+SEAgrwwx+qbkxU98PbIVuaSIEl2/gwDWjM/OKxCxfZrXV9hB+VwrQLEgFIdveuoBAn7Dt3Mo8eV7DRzuqazgWF/wgGlAykrjGSu41VMdkCK1Y+fO3hV6nmhkAkUfWNHxUtWuSrlbV32JsNi16stOF8QFkIKhojq99YlJnAYp49mwgb+3JoGqPBlroVOdyAZnq6njENb4BRcmv1Sk44fwsZ3l4eQkDBufVH3sFxRSP4yupQndWcMAwUq2B+8fmcmu2MPmwYuXV718p1RcCViHkrV82ZNIntItA309beRC8oNVtKFnia7E7GOa871XavYV4bWB+FIHKNwciqwuxnD3kt8NSvzP7hVm+nnMxPEdvdNo5If1kiz174iDsgKkEzVmltdw9sl956rLlmh4v55OCY6x3SBrLze4o6dm8/HMFwUNsxN5vbKuDnSkPjyjnNRccYsPN78JotDBbo1FRjey/09HzwwtDuCg6f6YO/USVFtpYm5nUIGOa0t1ILi+FdCb4trHndk/f09NTaBM/F9LfNK5lPNDf6kmBYG0AYHkS6MaR5XeWiY012zlJ7U3NR5TqTnFkr2CCFZx8TEfcRzk9E/ThV0PZnmeDIeu6Ir0OYaqx6CR79jeHlRYuwc85w83KoBbW1bBhBJO2Bm1hJ5znMyYVaTkVTdydzYkHnhbdZuk3rnrd1dTEPfg6zla5b7dq5rRPHGra9aYbTAwHp28Kat6DM7KsP7MmGFoOthDm1lLnEhtdWe095WBtAGBYE4KQbA/w81tzEfPAMjYfJ1ZXMqx1kbGCDFJ6jImrzW2HUbsUVOrfNq6BrL/bYMNfWwgpxXQm1ttqL/ETSGGhCuFydNBZp6sTkmAp7I3bEufqttwONMOnmGRp37oJHlc/N3u1vDqe8xOY/goK4DX5N6cZ4ite+UFO5xXU/UfNF0Zuy0pW/t9gLCZSx6LqmlinMiEOTXV1TTAwjTntLZ2w+WuBlGUe4EdAPBNm+pZ4dX5325s6FRYv9NcEFyvxSZe7OZ3d5U46vUrp54FHzlOc/gDGX2y4ee97UzA2vUm3wdQoJT7oxltIFnubtO4/QofnPTzJGm02mTi5bg9A/Mvg7jLGQGBnL0Lgqq+IwM4rtZeKpbO3qnfPnfHeXwWxbEGZ4keOyp7j2A+fcOd6cMWLhHudv4P0Z5sndFdnZzLBYsrtHOCviweNla9dsxwo2mDHezAmEEs2DKY7F1hLIGZS52GYugwnQ4+FsiPb+AxnGmNatMU1+maqp5bMnIJlmZmM5Fdn2Ndi9RbZIWZtHhrwicz+WxaLweo+8rpC2nwH4SpG1y3Ls6Fr+iffXqlFoWDW5ZVE3M8scjo0kyQQaCoeDgSTts3Pbbqfsabu6XKDbZtTlUxoa+84q2qN4WVfkXnBn9dyFu12mypbWXO6SXWRdTWuYoTAvj3eJRtPeELg+GHA6nWgo1MepjruXKLDiTrk+OkSBpY/zHHcvUWDFnXJ9dMh8K4Splj6cRV7Gj4H/B3oQXnuSXHL0AAAAAElFTkSuQmCC", Scope = Private
	#tag EndConstant

	#tag Constant, Name = NavigatorIcon, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAEJGlDQ1BJQ0MgUHJvZmlsZQAAOBGFVd9v21QUPolvUqQWPyBYR4eKxa9VU1u5GxqtxgZJk6XtShal6dgqJOQ6N4mpGwfb6baqT3uBNwb8AUDZAw9IPCENBmJ72fbAtElThyqqSUh76MQPISbtBVXhu3ZiJ1PEXPX6yznfOec7517bRD1fabWaGVWIlquunc8klZOnFpSeTYrSs9RLA9Sr6U4tkcvNEi7BFffO6+EdigjL7ZHu/k72I796i9zRiSJPwG4VHX0Z+AxRzNRrtksUvwf7+Gm3BtzzHPDTNgQCqwKXfZwSeNHHJz1OIT8JjtAq6xWtCLwGPLzYZi+3YV8DGMiT4VVuG7oiZpGzrZJhcs/hL49xtzH/Dy6bdfTsXYNY+5yluWO4D4neK/ZUvok/17X0HPBLsF+vuUlhfwX4j/rSfAJ4H1H0qZJ9dN7nR19frRTeBt4Fe9FwpwtN+2p1MXscGLHR9SXrmMgjONd1ZxKzpBeA71b4tNhj6JGoyFNp4GHgwUp9qplfmnFW5oTdy7NamcwCI49kv6fN5IAHgD+0rbyoBc3SOjczohbyS1drbq6pQdqumllRC/0ymTtej8gpbbuVwpQfyw66dqEZyxZKxtHpJn+tZnpnEdrYBbueF9qQn93S7HQGGHnYP7w6L+YGHNtd1FJitqPAR+hERCNOFi1i1alKO6RQnjKUxL1GNjwlMsiEhcPLYTEiT9ISbN15OY/jx4SMshe9LaJRpTvHr3C/ybFYP1PZAfwfYrPsMBtnE6SwN9ib7AhLwTrBDgUKcm06FSrTfSj187xPdVQWOk5Q8vxAfSiIUc7Z7xr6zY/+hpqwSyv0I0/QMTRb7RMgBxNodTfSPqdraz/sDjzKBrv4zu2+a2t0/HHzjd2Lbcc2sG7GtsL42K+xLfxtUgI7YHqKlqHK8HbCCXgjHT1cAdMlDetv4FnQ2lLasaOl6vmB0CMmwT/IPszSueHQqv6i/qluqF+oF9TfO2qEGTumJH0qfSv9KH0nfS/9TIp0Wboi/SRdlb6RLgU5u++9nyXYe69fYRPdil1o1WufNSdTTsp75BfllPy8/LI8G7AUuV8ek6fkvfDsCfbNDP0dvRh0CrNqTbV7LfEEGDQPJQadBtfGVMWEq3QWWdufk6ZSNsjG2PQjp3ZcnOWWing6noonSInvi0/Ex+IzAreevPhe+CawpgP1/pMTMDo64G0sTCXIM+KdOnFWRfQKdJvQzV1+Bt8OokmrdtY2yhVX2a+qrykJfMq4Ml3VR4cVzTQVz+UoNne4vcKLoyS+gyKO6EHe+75Fdt0Mbe5bRIf/wjvrVmhbqBN97RD1vxrahvBOfOYzoosH9bq94uejSOQGkVM6sN/7HelL4t10t9F4gPdVzydEOx83Gv+uNxo7XyL/FtFl8z9ZAHF4bBsrEwAAAAlwSFlzAAAROQAAETkBG9mTRgAAAbhJREFUOBGlUr8vBFEQnpn39irkiEQhiEIr0Sn1On+BSuX/ELX4JyR6Uag0FxqRSIRGLxIRDrtvxjdv79wjrjKbfTszOz+++eYR/VN4TL77rfx3uUPV6ny1SyJLxlYzcSTTm1gGFfoo2QyxbAuzNCNB9lmkGsUJjSswiqECpPGzJe2SAJ3hBx4pIkvVs9rMwcl1toMFAXQKQOLNZVwBH2E4RtY/3wglMI5b3ts/LCDip3hBvZqi9TQ9uUeNsglx6lPNj/UBLfOrvVOXW1Q583eB7JyYrNaeOp2NTqVog5aoQpbOcfQdxGC4HDscwWviPcoFE1HfmuTynpLWmpoEtj4RAzw57/uIK5tnx+gxB78vrCN6enF/t3272LyED8EEYFskhJzxK9l9EbvdcsW5ETNKHBeThEMkkhpoGnLpa/tDoqk2+aoopgRANn0JcCrCAaDd9x+JQ1dE4SDMDL4t+NenBDOZHCBosSHcF2gEVkdipk4voCo6ebdCAOLbLvUc4qUGEgXtXVevDQ1bi8AfwZxflxzouvtht2svLhJ4s+sSAewH0tQDCw2Sgr+uw98zpYfcGFy3TfXkC9MgxjTCDgOvAAAAAElFTkSuQmCC", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PaletteArctic, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PaletteForest, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PaletteGoogle, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PaletteOffice2010, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PaletteRainbow, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PaletteWindows8, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PositionBottom, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PositionInside, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PositionLeft, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PositionNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PositionRight, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PositionTop, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ShowStyleProperty, Type = Boolean, Dynamic = False, Default = \"True", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = TypeArea, Type = Double, Dynamic = False, Default = \"300", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeAreaStacked, Type = Double, Dynamic = False, Default = \"301", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeAreaStepped, Type = Double, Dynamic = False, Default = \"303", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeBar, Type = Double, Dynamic = False, Default = \"400", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeBarStacked, Type = Double, Dynamic = False, Default = \"401", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeBarStacked100, Type = Double, Dynamic = False, Default = \"402", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeBoxPlot, Type = Double, Dynamic = False, Default = \"800", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeBullet, Type = Double, Dynamic = False, Default = \"403", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeColumn, Type = Double, Dynamic = False, Default = \"100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeColumnRange, Type = Double, Dynamic = False, Default = \"104", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeColumnStacked, Type = Double, Dynamic = False, Default = \"101", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeColumnStacked100, Type = Double, Dynamic = False, Default = \"102", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeCombo, Type = Double, Dynamic = False, Default = \"500", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeDougnut, Type = Double, Dynamic = False, Default = \"1301", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeLine, Type = Double, Dynamic = False, Default = \"200", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeLineSmooth, Type = Double, Dynamic = False, Default = \"203", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeLineStacked, Type = Double, Dynamic = False, Default = \"201", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeLineStackedSmooth, Type = Double, Dynamic = False, Default = \"204", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypePie, Type = Double, Dynamic = False, Default = \"1300", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypePie3D, Type = Double, Dynamic = False, Default = \"1310", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeRadar, Type = Double, Dynamic = False, Default = \"1400", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeRadarFill, Type = Double, Dynamic = False, Default = \"1401", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeScatter, Type = Double, Dynamic = False, Default = \"600", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeTreeMap, Type = Double, Dynamic = False, Default = \"1500", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeTrendAreaStepped, Type = Double, Dynamic = False, Default = \"701", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = TypeTrendTimeLine, Type = Double, Dynamic = False, Default = \"700", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = Position, Type = Integer, Flags = &h0
		None
		  Top
		  Left
		  Right
		  BottomHorizontal
		BottomVertical
	#tag EndEnum


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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Continuous"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastError"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c828790"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Freeze"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Animate"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AnimationTime"
			Visible=true
			Group="Behavior"
			InitialValue="800"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CrossesBetweenTickMarks"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LiveRefresh"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AnimationHorizontal"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FollowMouse"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FollowValues"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowHelpTag"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplaySelectionBar"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FollowAllSeries"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Precision"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Margin"
			Visible=true
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleYAxe"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoughnutRadius"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnableSelection"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PieRadarAngle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LegendPosition"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Position"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - Top"
				"2 - Left"
				"3 - Right"
				"4 - BottomHorizontal"
				"5 - BottomVertical"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
