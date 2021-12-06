onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /SAMtest/str
add wave -noupdate -format Logic /SAMtest/mode
add wave -noupdate -format Logic /SAMtest/clk
add wave -noupdate -format Logic /SAMtest/reset
add wave -noupdate -format Logic /SAMtest/msg
add wave -noupdate -format Logic /SAMtest/frame
add wave -noupdate -format Literal /SAMtest/seed
add wave -noupdate -format Literal /SAMtest/idle_cycles
add wave -noupdate -format Literal /SAMtest/key_length
add wave -noupdate -format Literal /SAMtest/counter
add wave -noupdate -format Literal /SAMtest/counter2
add wave -noupdate -format Literal /SAMtest/counter3
add wave -noupdate -format Literal /SAMtest/n
add wave -noupdate -format Literal /SAMtest/d
add wave -noupdate -format Literal /SAMtest/capsN
add wave -noupdate -format Literal /SAMtest/counterones
add wave -noupdate -format Literal /SAMtest/counterzeros
add wave -noupdate -format Literal /SAMtest/sent
add wave -noupdate -format Logic /SAMtest/state
add wave -noupdate -format Literal /SAMtest/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {463 ns} 0}
WaveRestoreZoom {0 ns} {836 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 220
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
