Sub Rows_ColumnName_Format()

'    Fix this code accordingly
'    Some column titles are hidden
'    Creates nice and clean aging report from the raw data using Excel VBA Macro

'    Change Column Names
    Range("A1").FormulaR1C1 = "Some Name"
    Range("B1").FormulaR1C1 = "Some Name"
    Range("C1").FormulaR1C1 = "Some Name"
    Range("D1").FormulaR1C1 = "Some Name"
    Range("E1").FormulaR1C1 = "Some Name"
    Range("F1").FormulaR1C1 = "Some Name"
    Range("G1").FormulaR1C1 = "Some Name"
    Range("H1").FormulaR1C1 = "Some Name"
    Range("I1").FormulaR1C1 = "Some Name"
    Range("J1").FormulaR1C1 = "Some Date"
    Range("K1").FormulaR1C1 = "Some Date"
    Range("L1").FormulaR1C1 = "Some Date"
    Range("M1").FormulaR1C1 = "Some Date"
    Range("N1").FormulaR1C1 = "Some Date"
    
'    Accounting Format
    Columns("I:M").NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"
    Columns("N:N").NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"
    Range("A1").Select

'    Freeze Top Row
    With ActiveWindow
        .SplitColumn = 0
        .SplitRow = 1
    End With
    ActiveWindow.FreezePanes = True
    Range("A1").Select
    
End Sub

Sub Subtotal_Totals()

'    Apply Subtotal
    Columns("A:M").Select
    Selection.Subtotal GroupBy:=1, Function:=xlSum, TotalList:=Array(9, 10, 11, 12, 13), Replace:=True, PageBreaks:=False, SummaryBelowData:=True
    ActiveSheet.Outline.ShowLevels RowLevels:=2
    Range("A1").Select
    
'    Count Rows
    Dim lRow As Long
        lRow = Cells(Rows.Count, 1).End(xlUp).Row
    
'    Add "Totals" Column
    Range("O1").Select
    ActiveCell.FormulaR1C1 = "Totals"
    
'    Find the First Row of the Subtotal
    ActiveCell.Offset(1, 0).Select
    Do Until ActiveCell.EntireRow.Hidden = False
        ActiveCell.Offset(1, 0).Select
    Loop
    
'    Add Totals to the Visible Cells Only
    ActiveSheet.Range(ActiveCell, Cells(lRow, 15)).Select
    Selection.SpecialCells(xlCellTypeVisible).Select
    Selection.FormulaR1C1 = "=SUM(RC[-6]:RC[-2])"
    Selection.Font.Size = 12
    Range("A1").Select
    
End Sub

Sub Table_Size()

'    Count Rows And Columns
    Dim lRow As Long
    Dim lCol As Long

        lRow = Cells(Rows.Count, 1).End(xlUp).Row
        lCol = Cells(1, Columns.Count).End(xlToLeft).Column

'    Apply Table Format to the Data
    ActiveSheet.ListObjects.Add(xlSrcRange, Range(Cells(1, 1), Cells(lRow, lCol)), , xlYes).Name = "AgingTable"
    ActiveWorkbook.TableStyles.Add ("Aging_Report")
    
    With ActiveWorkbook.TableStyles("Aging_Report").TableStyleElements(xlHeaderRow).Font
        .FontStyle = "Bold"
        .ThemeColor = xlThemeColorDark1
    End With
    
    With ActiveWorkbook.TableStyles("Aging_Report").TableStyleElements(xlRowStripe2).Interior
        .Color = 15329769
    End With
    
    ActiveSheet.ListObjects("AgingTable").TableStyle = "Aging_Report"

'    Adjust Size of the Columns
    Rows("1:1").RowHeight = 25
    Rows("1:1").Select
    
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = False
'        .Orientation = 0
'        .AddIndent = False
'        .IndentLevel = 0
'        .ShrinkToFit = False
'        .ReadingOrder = xlContext
'        .MergeCells = False
    End With
    
'    Bold the Visible Cells
    Columns("I:O").Select
    Selection.SpecialCells(xlCellTypeVisible).Select
    Selection.Font.Bold = True
    
    ActiveWindow.DisplayGridlines = False
'    ActiveSheet.ListObjects("AgingTable").ShowTableStyleRowStripes = False
    
    Range("A1").Select
    ActiveCell.Offset(1, 0).Select
    Do Until ActiveCell.EntireRow.Hidden = False
        ActiveCell.Offset(1, 0).Select
    Loop
    
    ActiveSheet.Range(ActiveCell, Cells(lRow, lCol)).SpecialCells(xlCellTypeVisible).Select
    
    With Selection.Interior
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = -0.15
        .PatternTintAndShade = 0
    End With

    Range("AgingTable[#Headers]").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    
    Range(Cells(lRow, 1), Cells(lRow, 15)).Font.Size = 12
    Columns("N:N").Font.Bold = True
    Range("A1").Select
    
End Sub

Sub Add_Buttons()

    Rows("1:1").Select
    Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
    Selection.RowHeight = 24.75
    Range("A1").Select
    
    ActiveSheet.Buttons.Add(63, 0, 463, 24.75).Select
    Selection.OnAction = "Show_Details"
    Selection.Characters.Text = "Show Details"
    With Selection.Characters(Start:=1, Length:=12).Font
        .Name = "Calibri"
        .FontStyle = "Bold"
        .Size = 12
    End With
    
    Range("A3").Select
    Selection.AutoFilter
    
    Cells.Columns.AutoFit
    ActiveWindow.DisplayHeadings = False
    Range("A1").Select
    
    Range("A1:O1").Select
    With Selection
        .MergeCells = False
    End With
    Selection.Merge
    
End Sub

Sub Show_Details()

    ActiveSheet.Outline.ShowLevels RowLevels:=3
    ActiveSheet.Buttons("Button 1").Text = "Close Detail"
    ActiveSheet.Shapes("Button 1").OnAction = "Close_Details"
    
End Sub

Sub Close_Details()

    ActiveSheet.Outline.ShowLevels RowLevels:=2
    ActiveSheet.Buttons("Button 1").Text = "Show Detail"
    ActiveSheet.Shapes("Button 1").OnAction = "Show_Details"

End Sub

Sub Z_Aging_Report()

    Workbooks.Open Filename:="C:\FoxTemp\AgingRawData.xls"
    
    Call Rows_ColumnName_Format
    Call Subtotal_Totals
    Call Table_Size
    Call Add_Buttons
    
    Windows("Macro_AgingSubtotalsByClient.XLSB").Activate
    ActiveWindow.Close

'    ChDir "C:\Users\Someone\Desktop"
'    ActiveWorkbook.SaveAs Filename:="C:\Users\Someone\Desktop\SomeTitle.xlsx", _
'        FileFormat:=xlOpenXMLWorkbook, CreateBackup:=False

End Sub
