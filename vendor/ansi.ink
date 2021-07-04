` ANSI terminal escape codes `

Esc := ''

Backspace := ''
MoveCursor := (x, y) => Esc + '[' + string(y) + ';' + string(x) + 'f'
MoveColumn := x => Esc + '[' + string(x) + 'G'

Home := Esc + '[H'
Reset := Esc + MoveColumn(0)

Clear := Esc + '[2J' + Home
ClearLine := Esc + '[2K' + Reset
ClearLastLine := Esc + '[0F' + ClearLine

` color sequences `

Weight := {
	Regular: 0
	Bold: 1
	Dim: 2
}
Color := {
	Black: 30
	Red: 31
	Green: 32
	Yellow: 33
	Blue: 34
	Magenta: 35
	Cyan: 36
	White: 37
	Gray: 90
	Reset: 0
}
Background := {
	Black: 40
	Red: 41
	Green: 42
	Yellow: 43
	Blue: 44
	Magenta: 45
	Cyan: 46
	White: 47
	Gray: 100
	Reset: 0
}

style := (t, c) => s => Esc + '[' + string(t) + ';' + string(c) + 'm' + s + Esc + '[0;0m'

` shorthand functions `

Black := style(Weight.Regular, Color.Black)
Red := style(Weight.Regular, Color.Red)
Green := style(Weight.Regular, Color.Green)
Yellow := style(Weight.Regular, Color.Yellow)
Blue := style(Weight.Regular, Color.Blue)
Magenta := style(Weight.Regular, Color.Magenta)
Cyan := style(Weight.Regular, Color.Cyan)
White := style(Weight.Regular, Color.White)
Gray := style(Weight.Regular, Color.Gray)

Bold := style(Weight.Bold, Color.Reset)
BoldBlack := style(Weight.Bold, Color.Black)
BoldRed := style(Weight.Bold, Color.Red)
BoldGreen := style(Weight.Bold, Color.Green)
BoldYellow := style(Weight.Bold, Color.Yellow)
BoldBlue := style(Weight.Bold, Color.Blue)
BoldMagenta := style(Weight.Bold, Color.Magenta)
BoldCyan := style(Weight.Bold, Color.Cyan)
BoldWhite := style(Weight.Bold, Color.White)
BoldGray := style(Weight.Bold, Color.Gray)

Dim := style(Weight.Dim, Color.Reset)
DimBlack := style(Weight.Dim, Color.Black)
DimRed := style(Weight.Dim, Color.Red)
DimGreen := style(Weight.Dim, Color.Green)
DimYellow := style(Weight.Dim, Color.Yellow)
DimBlue := style(Weight.Dim, Color.Blue)
DimMagenta := style(Weight.Dim, Color.Magenta)
DimCyan := style(Weight.Dim, Color.Cyan)
DimWhite := style(Weight.Dim, Color.White)
DimGray := style(Weight.Dim, Color.Gray)

