EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 1
Title "IDE RAM A500"
Date "2020-05-07"
Rev "0.1"
Comp "FLACO 2020 - Unknown licence, see projects below"
Comment1 "Inspired by original design and code of ide68k v425 by Mika Leinonen"
Comment2 "http://www.mkl211015.altervista.org/ide/ide68k.html"
Comment3 "Additional RAM idea inspired by Sector101"
Comment4 "https://blog.sector101.co.uk/2019/07/20/amiga-500-2mb-handwired-fastram-expansion/"
$EndDescr
$Comp
L CPU_NXP_68000:68000D U1
U 1 1 5E917DF0
P 7850 4100
F 0 "U1" H 7150 6500 50  0000 L CNN
F 1 "68000D socket" H 7150 6400 50  0000 L CNN
F 2 "Sassa:DIP-64_W22.86mm_BigPads1.4" H 7850 4100 50  0001 C CNN
F 3 "https://www.nxp.com/docs/en/reference-manual/MC68000UM.pdf" H 7850 4100 50  0001 C CNN
	1    7850 4100
	1    0    0    -1  
$EndComp
$Comp
L CPLD_Xilinx:XC95144XL-TQ100 U2
U 1 1 5E91A142
P 4350 4100
F 0 "U2" H 3550 6750 50  0000 L CNN
F 1 "XC95144XL-TQ100" H 3200 6650 50  0000 L CNN
F 2 "Package_QFP:TQFP-100_14x14mm_P0.5mm" H 4350 4100 50  0001 C CNN
F 3 "https://www.xilinx.com/support/documentation/data_sheets/ds056.pdf" H 4350 4100 50  0001 C CNN
	1    4350 4100
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x22_Odd_Even J7
U 1 1 5E920A2E
P 10800 3500
F 0 "J7" H 10850 4717 50  0000 C CNN
F 1 "IDE" H 10850 4626 50  0000 C CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_2x22_P2.00mm_Vertical" H 10800 3500 50  0001 C CNN
F 3 "~" H 10800 3500 50  0001 C CNN
	1    10800 3500
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:SPX3819M5-L-3-3 U3
U 1 1 5E93BE54
P 14050 7250
F 0 "U3" H 14050 7592 50  0000 C CNN
F 1 "SPX3819M5-L-3-3" H 14050 7501 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 14050 7575 50  0001 C CNN
F 3 "https://www.exar.com/content/document.ashx?id=22106&languageid=1033&type=Datasheet&partnumber=SPX3819&filename=SPX3819.pdf&part=SPX3819" H 14050 7250 50  0001 C CNN
	1    14050 7250
	1    0    0    -1  
$EndComp
Text Label 6850 1900 2    50   ~ 0
CLK7
Text Label 6850 5400 2    50   ~ 0
_RST
Text Label 6850 4900 2    50   ~ 0
_DTACK
Text Label 8850 6000 0    50   ~ 0
_AS
Text Label 8850 6300 0    50   ~ 0
RW
Text Label 8850 6100 0    50   ~ 0
_UDS
Text Label 8850 6200 0    50   ~ 0
_LDS
$Comp
L power:GND #PWR010
U 1 1 5E946FB2
P 7850 6500
F 0 "#PWR010" H 7850 6250 50  0001 C CNN
F 1 "GND" H 7855 6327 50  0000 C CNN
F 2 "" H 7850 6500 50  0001 C CNN
F 3 "" H 7850 6500 50  0001 C CNN
	1    7850 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 6500 7850 6500
Connection ~ 7850 6500
$Comp
L power:+5V #PWR09
U 1 1 5E949A73
P 7850 1700
F 0 "#PWR09" H 7850 1550 50  0001 C CNN
F 1 "+5V" H 7865 1873 50  0000 C CNN
F 2 "" H 7850 1700 50  0001 C CNN
F 3 "" H 7850 1700 50  0001 C CNN
	1    7850 1700
	1    0    0    -1  
$EndComp
Text Label 8850 1900 0    50   ~ 0
A1
Text Label 8850 2000 0    50   ~ 0
A2
Text Label 8850 2100 0    50   ~ 0
A3
Text Label 8850 2200 0    50   ~ 0
A4
Text Label 8850 2300 0    50   ~ 0
A5
Text Label 8850 2400 0    50   ~ 0
A6
Text Label 8850 2500 0    50   ~ 0
A7
Text Label 8850 2600 0    50   ~ 0
A8
Text Label 8850 2700 0    50   ~ 0
A9
Text Label 8850 2800 0    50   ~ 0
A10
Text Label 8850 2900 0    50   ~ 0
A11
Text Label 8850 3000 0    50   ~ 0
A12
Text Label 8850 3100 0    50   ~ 0
A13
Text Label 8850 3200 0    50   ~ 0
A14
Text Label 8850 3300 0    50   ~ 0
A15
Text Label 8850 3400 0    50   ~ 0
A16
Text Label 8850 3500 0    50   ~ 0
A17
Text Label 8850 3600 0    50   ~ 0
A18
Text Label 8850 3700 0    50   ~ 0
A19
Text Label 8850 3800 0    50   ~ 0
A20
Text Label 8850 3900 0    50   ~ 0
A21
Text Label 8850 4000 0    50   ~ 0
A22
Text Label 8850 4100 0    50   ~ 0
A23
Text Label 8850 4300 0    50   ~ 0
D0
Text Label 8850 4400 0    50   ~ 0
D1
Text Label 8850 4500 0    50   ~ 0
D2
Text Label 8850 4600 0    50   ~ 0
D3
Text Label 8850 4700 0    50   ~ 0
D4
Text Label 8850 4800 0    50   ~ 0
D5
Text Label 8850 4900 0    50   ~ 0
D6
Text Label 8850 5000 0    50   ~ 0
D7
Text Label 8850 5100 0    50   ~ 0
D8
Text Label 8850 5200 0    50   ~ 0
D9
Text Label 8850 5300 0    50   ~ 0
D10
Text Label 8850 5400 0    50   ~ 0
D11
Text Label 8850 5500 0    50   ~ 0
D12
Text Label 8850 5600 0    50   ~ 0
D13
Text Label 8850 5700 0    50   ~ 0
D14
Text Label 8850 5800 0    50   ~ 0
D15
Wire Wire Line
	7950 1700 7850 1700
Connection ~ 7850 1700
$Comp
L power:+5V #PWR013
U 1 1 5E962832
P 13250 7150
F 0 "#PWR013" H 13250 7000 50  0001 C CNN
F 1 "+5V" H 13265 7323 50  0000 C CNN
F 2 "" H 13250 7150 50  0001 C CNN
F 3 "" H 13250 7150 50  0001 C CNN
	1    13250 7150
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR028
U 1 1 5E962E41
P 14900 7150
F 0 "#PWR028" H 14900 7000 50  0001 C CNN
F 1 "+3.3V" H 14915 7323 50  0000 C CNN
F 2 "" H 14900 7150 50  0001 C CNN
F 3 "" H 14900 7150 50  0001 C CNN
	1    14900 7150
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 5E963578
P 13400 7250
F 0 "C2" H 13492 7296 50  0000 L CNN
F 1 "10u" H 13492 7205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 13400 7250 50  0001 C CNN
F 3 "~" H 13400 7250 50  0001 C CNN
	1    13400 7250
	1    0    0    -1  
$EndComp
Wire Wire Line
	13750 7150 13400 7150
Connection ~ 13400 7150
Wire Wire Line
	13400 7150 13250 7150
Wire Wire Line
	13750 7250 13750 7150
Connection ~ 13750 7150
Wire Wire Line
	14350 7150 14550 7150
Wire Wire Line
	13400 7350 13400 7550
Wire Wire Line
	13250 7550 13400 7550
$Comp
L Device:C_Small C6
U 1 1 5E96573B
P 14550 7250
F 0 "C6" H 14642 7296 50  0000 L CNN
F 1 "10u" H 14642 7205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 14550 7250 50  0001 C CNN
F 3 "~" H 14550 7250 50  0001 C CNN
	1    14550 7250
	1    0    0    -1  
$EndComp
Connection ~ 14550 7150
Wire Wire Line
	14550 7150 14900 7150
Wire Wire Line
	14550 7350 14550 7550
Wire Wire Line
	14550 7550 14050 7550
Connection ~ 14050 7550
$Comp
L power:GND #PWR014
U 1 1 5E9664A6
P 13250 7550
F 0 "#PWR014" H 13250 7300 50  0001 C CNN
F 1 "GND" H 13255 7377 50  0000 C CNN
F 2 "" H 13250 7550 50  0001 C CNN
F 3 "" H 13250 7550 50  0001 C CNN
	1    13250 7550
	1    0    0    -1  
$EndComp
Connection ~ 13400 7550
Wire Wire Line
	13400 7550 14050 7550
$Comp
L power:+3.3V #PWR04
U 1 1 5E97C3B4
P 4050 1400
F 0 "#PWR04" H 4050 1250 50  0001 C CNN
F 1 "+3.3V" H 4065 1573 50  0000 C CNN
F 2 "" H 4050 1400 50  0001 C CNN
F 3 "" H 4050 1400 50  0001 C CNN
	1    4050 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 1400 4550 1400
Connection ~ 4050 1400
Connection ~ 4150 1400
Wire Wire Line
	4150 1400 4050 1400
Connection ~ 4250 1400
Wire Wire Line
	4250 1400 4150 1400
Connection ~ 4350 1400
Wire Wire Line
	4350 1400 4250 1400
Connection ~ 4450 1400
Wire Wire Line
	4450 1400 4350 1400
Connection ~ 4550 1400
Wire Wire Line
	4550 1400 4450 1400
$Comp
L power:GND #PWR05
U 1 1 5E97FE94
P 4050 6800
F 0 "#PWR05" H 4050 6550 50  0001 C CNN
F 1 "GND" H 4055 6627 50  0000 C CNN
F 2 "" H 4050 6800 50  0001 C CNN
F 3 "" H 4050 6800 50  0001 C CNN
	1    4050 6800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 6800 4650 6800
Connection ~ 4050 6800
Connection ~ 4150 6800
Wire Wire Line
	4150 6800 4050 6800
Connection ~ 4250 6800
Wire Wire Line
	4250 6800 4150 6800
Connection ~ 4350 6800
Wire Wire Line
	4350 6800 4250 6800
Connection ~ 4450 6800
Wire Wire Line
	4450 6800 4350 6800
Connection ~ 4550 6800
Wire Wire Line
	4550 6800 4450 6800
Connection ~ 4650 6800
Wire Wire Line
	4650 6800 4550 6800
NoConn ~ 6850 3600
NoConn ~ 6850 3700
NoConn ~ 6850 3800
NoConn ~ 6850 4700
NoConn ~ 6850 5300
NoConn ~ 6850 2200
NoConn ~ 6850 2300
NoConn ~ 6850 2400
NoConn ~ 6850 2600
NoConn ~ 6850 2800
NoConn ~ 6850 2700
NoConn ~ 6850 3100
NoConn ~ 6850 3200
NoConn ~ 6850 3300
Text Notes 13150 8000 0    50   ~ 0
CPLD decoupling
Text Notes 14550 8000 0    50   ~ 0
RAM decoupling
Text Label 3350 2700 2    50   ~ 0
CLK7
Text Label 3350 4000 2    50   ~ 0
_DTACK
Text Label 3350 4600 2    50   ~ 0
D1
Text Label 3350 2900 2    50   ~ 0
_RST
Text Label 3350 4100 2    50   ~ 0
RW
Text Label 3350 4200 2    50   ~ 0
_LDS
Text Label 3350 4300 2    50   ~ 0
_UDS
Text Label 3350 4400 2    50   ~ 0
_AS
Text Label 10600 2500 2    50   ~ 0
_DRESET
$Comp
L power:GND #PWR018
U 1 1 5E9ADB45
P 11100 2500
F 0 "#PWR018" H 11100 2250 50  0001 C CNN
F 1 "GND" V 11105 2372 50  0000 R CNN
F 2 "" H 11100 2500 50  0001 C CNN
F 3 "" H 11100 2500 50  0001 C CNN
	1    11100 2500
	0    -1   -1   0   
$EndComp
Text Label 10600 2600 2    50   ~ 0
DD7
Text Label 10600 2700 2    50   ~ 0
DD6
Text Label 10600 2800 2    50   ~ 0
DD5
Text Label 10600 2900 2    50   ~ 0
DD4
Text Label 10600 3000 2    50   ~ 0
DD3
Text Label 10600 3100 2    50   ~ 0
DD2
Text Label 10600 3200 2    50   ~ 0
DD1
Text Label 10600 3300 2    50   ~ 0
DD0
Text Label 11100 2600 0    50   ~ 0
DD8
Text Label 11100 2700 0    50   ~ 0
DD9
Text Label 11100 2800 0    50   ~ 0
DD10
Text Label 11100 2900 0    50   ~ 0
DD11
Text Label 11100 3000 0    50   ~ 0
DD12
Text Label 11100 3100 0    50   ~ 0
DD13
Text Label 11100 3200 0    50   ~ 0
DD14
Text Label 11100 3300 0    50   ~ 0
DD15
$Comp
L power:GND #PWR015
U 1 1 5E9B42D1
P 10600 3400
F 0 "#PWR015" H 10600 3150 50  0001 C CNN
F 1 "GND" V 10605 3272 50  0000 R CNN
F 2 "" H 10600 3400 50  0001 C CNN
F 3 "" H 10600 3400 50  0001 C CNN
	1    10600 3400
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR019
U 1 1 5E9B4AE3
P 11100 3500
F 0 "#PWR019" H 11100 3250 50  0001 C CNN
F 1 "GND" V 11105 3372 50  0000 R CNN
F 2 "" H 11100 3500 50  0001 C CNN
F 3 "" H 11100 3500 50  0001 C CNN
	1    11100 3500
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR020
U 1 1 5E9B50D2
P 11100 3600
F 0 "#PWR020" H 11100 3350 50  0001 C CNN
F 1 "GND" V 11105 3472 50  0000 R CNN
F 2 "" H 11100 3600 50  0001 C CNN
F 3 "" H 11100 3600 50  0001 C CNN
	1    11100 3600
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR021
U 1 1 5E9B54F5
P 11100 3700
F 0 "#PWR021" H 11100 3450 50  0001 C CNN
F 1 "GND" V 11105 3572 50  0000 R CNN
F 2 "" H 11100 3700 50  0001 C CNN
F 3 "" H 11100 3700 50  0001 C CNN
	1    11100 3700
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR023
U 1 1 5E9B58ED
P 11100 3900
F 0 "#PWR023" H 11100 3650 50  0001 C CNN
F 1 "GND" V 11105 3772 50  0000 R CNN
F 2 "" H 11100 3900 50  0001 C CNN
F 3 "" H 11100 3900 50  0001 C CNN
	1    11100 3900
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR024
U 1 1 5E9B5D7D
P 11100 4400
F 0 "#PWR024" H 11100 4150 50  0001 C CNN
F 1 "GND" V 11105 4272 50  0000 R CNN
F 2 "" H 11100 4400 50  0001 C CNN
F 3 "" H 11100 4400 50  0001 C CNN
	1    11100 4400
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR017
U 1 1 5E9B61FB
P 10600 4600
F 0 "#PWR017" H 10600 4350 50  0001 C CNN
F 1 "GND" V 10605 4472 50  0000 R CNN
F 2 "" H 10600 4600 50  0001 C CNN
F 3 "" H 10600 4600 50  0001 C CNN
	1    10600 4600
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR025
U 1 1 5E9B68ED
P 11100 4500
F 0 "#PWR025" H 11100 4350 50  0001 C CNN
F 1 "+5V" V 11115 4628 50  0000 L CNN
F 2 "" H 11100 4500 50  0001 C CNN
F 3 "" H 11100 4500 50  0001 C CNN
	1    11100 4500
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR016
U 1 1 5E9B7B0D
P 10600 4500
F 0 "#PWR016" H 10600 4350 50  0001 C CNN
F 1 "+5V" V 10615 4628 50  0000 L CNN
F 2 "" H 10600 4500 50  0001 C CNN
F 3 "" H 10600 4500 50  0001 C CNN
	1    10600 4500
	0    -1   -1   0   
$EndComp
NoConn ~ 11100 3400
NoConn ~ 10600 3500
Text Notes 11250 3400 0    50   ~ 0
KEY, no pin
$Comp
L power:GND #PWR022
U 1 1 5E9B97F2
P 11100 3800
F 0 "#PWR022" H 11100 3550 50  0001 C CNN
F 1 "GND" V 11105 3672 50  0000 R CNN
F 2 "" H 11100 3800 50  0001 C CNN
F 3 "" H 11100 3800 50  0001 C CNN
	1    11100 3800
	0    -1   -1   0   
$EndComp
Text Notes 11400 3800 0    50   ~ 0
CSEL, cut for slave
NoConn ~ 11100 4100
Text Label 11100 4200 0    50   ~ 0
DA2
Text Label 11100 4300 0    50   ~ 0
_CS1
Text Label 10600 4300 2    50   ~ 0
_CS0
Text Label 5350 5300 0    50   ~ 0
_CS0
Text Label 5350 5400 0    50   ~ 0
_CS1
Text Label 5350 5700 0    50   ~ 0
DA2
Text Label 10600 4200 2    50   ~ 0
DA0
Text Label 10600 4100 2    50   ~ 0
DA1
Text Label 5350 5900 0    50   ~ 0
DA1
Text Label 5350 5600 0    50   ~ 0
DA0
Text Label 5350 2900 0    50   ~ 0
A17
Text Label 5350 5800 0    50   ~ 0
A18
Text Label 5350 5500 0    50   ~ 0
A19
Text Label 5350 5200 0    50   ~ 0
A20
Text Label 5350 4600 0    50   ~ 0
A21
Text Label 5350 4500 0    50   ~ 0
A22
Text Label 5350 4400 0    50   ~ 0
A23
Text Label 3350 4500 2    50   ~ 0
D0
Text Label 3350 4700 2    50   ~ 0
D2
Text Label 3350 4800 2    50   ~ 0
D3
Text Label 3350 4900 2    50   ~ 0
D4
Text Label 5350 1700 0    50   ~ 0
D5
Text Label 5350 1800 0    50   ~ 0
D6
Text Label 5350 1900 0    50   ~ 0
D7
Text Label 5350 2000 0    50   ~ 0
D8
Text Label 5350 2100 0    50   ~ 0
D9
Text Label 5350 2200 0    50   ~ 0
D10
Text Label 5350 2300 0    50   ~ 0
D11
Text Label 5350 2400 0    50   ~ 0
D12
Text Label 5350 2500 0    50   ~ 0
D13
Text Label 5350 2600 0    50   ~ 0
D14
Text Label 5350 4000 0    50   ~ 0
D15
Text Label 3350 3000 2    50   ~ 0
_DRESET
Text Label 3350 5900 2    50   ~ 0
DD7
Text Label 3350 5700 2    50   ~ 0
DD6
Text Label 3350 5500 2    50   ~ 0
DD5
Text Label 3350 5300 2    50   ~ 0
DD4
Text Label 3350 5100 2    50   ~ 0
DD3
Text Label 5350 3700 0    50   ~ 0
DD2
Text Label 5350 3500 0    50   ~ 0
DD1
Text Label 5350 3300 0    50   ~ 0
DD0
Text Label 3350 6000 2    50   ~ 0
DD8
Text Label 3350 5800 2    50   ~ 0
DD9
Text Label 3350 5600 2    50   ~ 0
DD10
Text Label 3350 5400 2    50   ~ 0
DD11
Text Label 3350 5200 2    50   ~ 0
DD12
Text Label 5350 3800 0    50   ~ 0
DD13
Text Label 5350 3600 0    50   ~ 0
DD14
Text Label 5350 3400 0    50   ~ 0
DD15
Text Label 10600 3600 2    50   ~ 0
_DIOW
Text Label 10600 3700 2    50   ~ 0
_DIOR
Text Label 10600 3800 2    50   ~ 0
IORDY
Text Label 10600 3900 2    50   ~ 0
_DMACK
Text Label 10600 4000 2    50   ~ 0
INTRQ
Text Label 5350 3200 0    50   ~ 0
_DIOW
Text Label 5350 3100 0    50   ~ 0
_DIOR
Text Label 5350 3000 0    50   ~ 0
IORDY
Text Label 5350 6000 0    50   ~ 0
INTRQ
Text Label 10600 4400 2    50   ~ 0
_ACTIVE
Text Label 5350 4900 0    50   ~ 0
_ACTIVE
Text Label 4700 8400 2    50   ~ 0
_OVR
Text Label 4700 8300 2    50   ~ 0
_INT2
Text Label 3350 2400 2    50   ~ 0
_OVR
Text Label 5350 4800 0    50   ~ 0
_INT2
Text Label 5350 4700 0    50   ~ 0
_OVR
Text Label 5350 4200 0    50   ~ 0
LED-
Text Label 5350 4300 0    50   ~ 0
LED+
Text Label 5350 4100 0    50   ~ 0
LED
Text Label 3350 3100 2    50   ~ 0
NINT2
$Comp
L Connector_Generic:Conn_01x02 J2
U 1 1 5EB7C95E
P 3600 8300
F 0 "J2" H 3680 8292 50  0000 L CNN
F 1 "LED" H 3680 8201 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 3600 8300 50  0001 C CNN
F 3 "~" H 3600 8300 50  0001 C CNN
	1    3600 8300
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small RLED1
U 1 1 5EB7E3AE
P 3050 8150
F 0 "RLED1" H 3109 8196 50  0000 L CNN
F 1 "330" H 3109 8105 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" H 3050 8150 50  0001 C CNN
F 3 "~" H 3050 8150 50  0001 C CNN
	1    3050 8150
	1    0    0    -1  
$EndComp
Text Label 3050 8400 2    50   ~ 0
LED
Wire Wire Line
	3400 8400 3050 8400
$Comp
L power:+3.3V #PWR03
U 1 1 5EB7FA7F
P 3050 8050
F 0 "#PWR03" H 3050 7900 50  0001 C CNN
F 1 "+3.3V" H 3065 8223 50  0000 C CNN
F 2 "" H 3050 8050 50  0001 C CNN
F 3 "" H 3050 8050 50  0001 C CNN
	1    3050 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 8300 3050 8300
Wire Wire Line
	3050 8300 3050 8250
$Comp
L Connector_Generic:Conn_01x06 J6
U 1 1 5EB8156E
P 6300 7250
F 0 "J6" H 6380 7242 50  0000 L CNN
F 1 "JTAG" H 6380 7151 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" H 6300 7250 50  0001 C CNN
F 3 "~" H 6300 7250 50  0001 C CNN
	1    6300 7250
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR06
U 1 1 5EB82831
P 6100 7050
F 0 "#PWR06" H 6100 6900 50  0001 C CNN
F 1 "+3.3V" H 6115 7223 50  0000 C CNN
F 2 "" H 6100 7050 50  0001 C CNN
F 3 "" H 6100 7050 50  0001 C CNN
	1    6100 7050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 5EB82EC2
P 6100 7150
F 0 "#PWR07" H 6100 6900 50  0001 C CNN
F 1 "GND" V 6105 7022 50  0000 R CNN
F 2 "" H 6100 7150 50  0001 C CNN
F 3 "" H 6100 7150 50  0001 C CNN
	1    6100 7150
	0    1    1    0   
$EndComp
Text Label 5350 6200 0    50   ~ 0
TDI
Text Label 5350 6300 0    50   ~ 0
TMS
Text Label 5350 6400 0    50   ~ 0
TCK
Text Label 5350 6500 0    50   ~ 0
TDO
Text Label 6100 7250 2    50   ~ 0
TCK
Text Label 6100 7350 2    50   ~ 0
TDO
Text Label 6100 7450 2    50   ~ 0
TDI
Text Label 6100 7550 2    50   ~ 0
TMS
$Comp
L Diode:BAT54A D1
U 1 1 5EB87EB4
P 7850 8350
F 0 "D1" H 7850 8575 50  0000 C CNN
F 1 "BAT54A" H 7850 8484 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 7925 8475 50  0001 L CNN
F 3 "http://www.diodes.com/_files/datasheets/ds11005.pdf" H 7730 8350 50  0001 C CNN
	1    7850 8350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 5EB891F6
P 7850 8550
F 0 "#PWR08" H 7850 8300 50  0001 C CNN
F 1 "GND" H 7855 8377 50  0000 C CNN
F 2 "" H 7850 8550 50  0001 C CNN
F 3 "" H 7850 8550 50  0001 C CNN
	1    7850 8550
	1    0    0    -1  
$EndComp
Text Label 8150 8350 0    50   ~ 0
_DIOW
Text Label 7550 8350 2    50   ~ 0
_DIOR
$Comp
L Connector_Generic:Conn_01x02 J1
U 1 1 5EB8A8AA
P 1800 8450
F 0 "J1" H 1880 8442 50  0000 L CNN
F 1 "power" H 1880 8351 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1800 8450 50  0001 C CNN
F 3 "~" H 1800 8450 50  0001 C CNN
	1    1800 8450
	1    0    0    1   
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5EB8B457
P 1600 8350
F 0 "#PWR01" H 1600 8200 50  0001 C CNN
F 1 "+5V" H 1615 8523 50  0000 C CNN
F 2 "" H 1600 8350 50  0001 C CNN
F 3 "" H 1600 8350 50  0001 C CNN
	1    1600 8350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5EB8BB26
P 1600 8450
F 0 "#PWR02" H 1600 8200 50  0001 C CNN
F 1 "GND" H 1605 8277 50  0000 C CNN
F 2 "" H 1600 8450 50  0001 C CNN
F 3 "" H 1600 8450 50  0001 C CNN
	1    1600 8450
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J4
U 1 1 5EB8C6DB
P 4900 8300
F 0 "J4" H 4980 8292 50  0000 L CNN
F 1 "INT2OVR" H 4980 8201 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 4900 8300 50  0001 C CNN
F 3 "~" H 4900 8300 50  0001 C CNN
	1    4900 8300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 5EB9F6AF
P 14800 8300
F 0 "C7" H 14892 8346 50  0000 L CNN
F 1 "100n" H 14892 8255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 14800 8300 50  0001 C CNN
F 3 "~" H 14800 8300 50  0001 C CNN
	1    14800 8300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C1
U 1 1 5EB9FF78
P 13100 8300
F 0 "C1" H 13192 8346 50  0000 L CNN
F 1 "100n" H 13192 8255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 13100 8300 50  0001 C CNN
F 3 "~" H 13100 8300 50  0001 C CNN
	1    13100 8300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 5EBA1394
P 13450 8300
F 0 "C3" H 13542 8346 50  0000 L CNN
F 1 "100n" H 13542 8255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 13450 8300 50  0001 C CNN
F 3 "~" H 13450 8300 50  0001 C CNN
	1    13450 8300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5EBA19AB
P 13800 8300
F 0 "C4" H 13892 8346 50  0000 L CNN
F 1 "100n" H 13892 8255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 13800 8300 50  0001 C CNN
F 3 "~" H 13800 8300 50  0001 C CNN
	1    13800 8300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 5EBA206C
P 14150 8300
F 0 "C5" H 14242 8346 50  0000 L CNN
F 1 "100n" H 14242 8255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 14150 8300 50  0001 C CNN
F 3 "~" H 14150 8300 50  0001 C CNN
	1    14150 8300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR026
U 1 1 5EBA266C
P 14800 8200
F 0 "#PWR026" H 14800 8050 50  0001 C CNN
F 1 "+5V" H 14815 8373 50  0000 C CNN
F 2 "" H 14800 8200 50  0001 C CNN
F 3 "" H 14800 8200 50  0001 C CNN
	1    14800 8200
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR011
U 1 1 5EBA2C75
P 13100 8200
F 0 "#PWR011" H 13100 8050 50  0001 C CNN
F 1 "+3.3V" H 13115 8373 50  0000 C CNN
F 2 "" H 13100 8200 50  0001 C CNN
F 3 "" H 13100 8200 50  0001 C CNN
	1    13100 8200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 5EBA3342
P 13100 8400
F 0 "#PWR012" H 13100 8150 50  0001 C CNN
F 1 "GND" H 13105 8227 50  0000 C CNN
F 2 "" H 13100 8400 50  0001 C CNN
F 3 "" H 13100 8400 50  0001 C CNN
	1    13100 8400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR027
U 1 1 5EBA3941
P 14800 8400
F 0 "#PWR027" H 14800 8150 50  0001 C CNN
F 1 "GND" H 14805 8227 50  0000 C CNN
F 2 "" H 14800 8400 50  0001 C CNN
F 3 "" H 14800 8400 50  0001 C CNN
	1    14800 8400
	1    0    0    -1  
$EndComp
Wire Wire Line
	14150 8200 13800 8200
Connection ~ 13100 8200
Connection ~ 13450 8200
Wire Wire Line
	13450 8200 13100 8200
Connection ~ 13800 8200
Wire Wire Line
	13800 8200 13450 8200
Wire Wire Line
	14150 8400 13800 8400
Connection ~ 13100 8400
Connection ~ 13450 8400
Wire Wire Line
	13450 8400 13100 8400
Connection ~ 13800 8400
Wire Wire Line
	13800 8400 13450 8400
Text Notes 2750 3150 2    50   ~ 0
Secondary INT2 is not connected\nto the primary one 
$Comp
L power:+5V #PWR033
U 1 1 5EBF903A
P 14350 2200
F 0 "#PWR033" H 14350 2050 50  0001 C CNN
F 1 "+5V" H 14365 2373 50  0000 C CNN
F 2 "" H 14350 2200 50  0001 C CNN
F 3 "" H 14350 2200 50  0001 C CNN
	1    14350 2200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR032
U 1 1 5EBFAB37
P 14250 5100
F 0 "#PWR032" H 14250 4850 50  0001 C CNN
F 1 "GND" H 14255 4927 50  0000 C CNN
F 2 "" H 14250 5100 50  0001 C CNN
F 3 "" H 14250 5100 50  0001 C CNN
	1    14250 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	14350 5100 14250 5100
Connection ~ 14250 5100
Text Label 14950 4400 0    50   ~ 0
A1
Text Label 14950 2900 0    50   ~ 0
A3
Text Label 14950 3000 0    50   ~ 0
A4
Text Label 14950 3100 0    50   ~ 0
A5
Text Label 14950 3200 0    50   ~ 0
A6
Text Label 14950 3300 0    50   ~ 0
A7
Text Label 14950 3400 0    50   ~ 0
A8
Text Label 14950 3500 0    50   ~ 0
A9
Text Label 14950 3600 0    50   ~ 0
A10
Text Label 14950 2500 0    50   ~ 0
A11
Text Label 14950 2600 0    50   ~ 0
A12
Text Label 14950 2700 0    50   ~ 0
A13
Text Label 14950 3700 0    50   ~ 0
A14
Text Label 14950 3800 0    50   ~ 0
A15
Text Label 14950 3900 0    50   ~ 0
A16
Text Label 14950 4000 0    50   ~ 0
A17
Text Label 14950 4100 0    50   ~ 0
A18
Text Label 14950 4200 0    50   ~ 0
A19
Text Label 14950 4300 0    50   ~ 0
A20
Text Label 14950 2800 0    50   ~ 0
A2
Text Label 13750 2500 2    50   ~ 0
D0
Text Label 13750 2600 2    50   ~ 0
D1
Text Label 13750 2700 2    50   ~ 0
D2
Text Label 13750 2800 2    50   ~ 0
D3
Text Label 13750 2900 2    50   ~ 0
D4
Text Label 13750 3000 2    50   ~ 0
D5
Text Label 13750 3100 2    50   ~ 0
D6
Text Label 13750 3200 2    50   ~ 0
D7
Text Label 13750 4000 2    50   ~ 0
D8
Text Label 13750 3900 2    50   ~ 0
D9
Text Label 13750 3800 2    50   ~ 0
D10
Text Label 13750 3700 2    50   ~ 0
D11
Text Label 13750 3600 2    50   ~ 0
D12
Text Label 13750 3500 2    50   ~ 0
D13
Text Label 13750 3400 2    50   ~ 0
D14
Text Label 13750 3300 2    50   ~ 0
D15
Text Label 13750 4700 2    50   ~ 0
_UDS
Text Label 13750 4600 2    50   ~ 0
_LDS
Text Label 13750 4300 2    50   ~ 0
RW
$Comp
L power:GND #PWR029
U 1 1 5E9A4700
P 13750 4200
F 0 "#PWR029" H 13750 3950 50  0001 C CNN
F 1 "GND" H 13755 4027 50  0000 C CNN
F 2 "" H 13750 4200 50  0001 C CNN
F 3 "" H 13750 4200 50  0001 C CNN
	1    13750 4200
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR031
U 1 1 5E9A6783
P 13750 4800
F 0 "#PWR031" H 13750 4650 50  0001 C CNN
F 1 "+5V" H 13765 4973 50  0000 C CNN
F 2 "" H 13750 4800 50  0001 C CNN
F 3 "" H 13750 4800 50  0001 C CNN
	1    13750 4800
	0    -1   -1   0   
$EndComp
Text Notes 12550 4750 0    50   ~ 0
two CE signals for 4MB
Text Label 12850 4500 2    50   ~ 0
RAM2CE
Text Label 13750 4500 2    50   ~ 0
RAM1CE
$Comp
L power:GND #PWR030
U 1 1 5E9EA2A6
P 13750 4400
F 0 "#PWR030" H 13750 4150 50  0001 C CNN
F 1 "GND" H 13755 4227 50  0000 C CNN
F 2 "" H 13750 4400 50  0001 C CNN
F 3 "" H 13750 4400 50  0001 C CNN
	1    13750 4400
	0    1    1    0   
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J3
U 1 1 5EA0AE89
P 3600 9000
F 0 "J3" H 3680 8992 50  0000 L CNN
F 1 "LED2" H 3680 8901 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 3600 9000 50  0001 C CNN
F 3 "~" H 3600 9000 50  0001 C CNN
	1    3600 9000
	1    0    0    -1  
$EndComp
Text Label 4700 8750 2    50   ~ 0
NINT2
Text Label 3400 9000 2    50   ~ 0
LED+
Text Label 3400 9100 2    50   ~ 0
LED-
$Comp
L Connector_Generic:Conn_01x01 J5
U 1 1 5EA13E28
P 4900 8750
F 0 "J5" H 4980 8792 50  0000 L CNN
F 1 "INT2" H 4980 8701 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 4900 8750 50  0001 C CNN
F 3 "~" H 4900 8750 50  0001 C CNN
	1    4900 8750
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5EA342C3
P 7850 6500
F 0 "#FLG0101" H 7850 6575 50  0001 C CNN
F 1 "PWR_FLAG" V 7850 6627 50  0000 L CNN
F 2 "" H 7850 6500 50  0001 C CNN
F 3 "~" H 7850 6500 50  0001 C CNN
	1    7850 6500
	0    -1   -1   0   
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5EA351B5
P 7950 1700
F 0 "#FLG0102" H 7950 1775 50  0001 C CNN
F 1 "PWR_FLAG" V 7950 1828 50  0000 L CNN
F 2 "" H 7950 1700 50  0001 C CNN
F 3 "~" H 7950 1700 50  0001 C CNN
	1    7950 1700
	0    1    1    0   
$EndComp
Connection ~ 7950 1700
Text Notes 11200 4000 0    50   ~ 0
_IOCS16
NoConn ~ 11100 4000
Text Notes 11200 4100 0    50   ~ 0
PDIAG
Text Notes 11200 4600 0    50   ~ 0
_TYPE
NoConn ~ 11100 4600
$Comp
L Device:R_Small R1
U 1 1 5EA5B09E
P 9150 8450
F 0 "R1" H 9209 8496 50  0000 L CNN
F 1 "10k" H 9209 8405 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" H 9150 8450 50  0001 C CNN
F 3 "~" H 9150 8450 50  0001 C CNN
	1    9150 8450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R2
U 1 1 5EA5BA88
P 9400 8450
F 0 "R2" H 9459 8496 50  0000 L CNN
F 1 "10k" H 9459 8405 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" H 9400 8450 50  0001 C CNN
F 3 "~" H 9400 8450 50  0001 C CNN
	1    9400 8450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R3
U 1 1 5EA5BF7B
P 9650 8450
F 0 "R3" H 9709 8496 50  0000 L CNN
F 1 "10k" H 9709 8405 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" H 9650 8450 50  0001 C CNN
F 3 "~" H 9650 8450 50  0001 C CNN
	1    9650 8450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R4
U 1 1 5EA5C4C4
P 10600 8450
F 0 "R4" H 10659 8496 50  0000 L CNN
F 1 "4k7" H 10659 8405 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" H 10600 8450 50  0001 C CNN
F 3 "~" H 10600 8450 50  0001 C CNN
	1    10600 8450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R5
U 1 1 5EA5C9C5
P 10850 8450
F 0 "R5" H 10909 8496 50  0000 L CNN
F 1 "4k7" H 10909 8405 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" H 10850 8450 50  0001 C CNN
F 3 "~" H 10850 8450 50  0001 C CNN
	1    10850 8450
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0101
U 1 1 5EA5D71A
P 9150 8350
F 0 "#PWR0101" H 9150 8200 50  0001 C CNN
F 1 "+3.3V" H 9165 8523 50  0000 C CNN
F 2 "" H 9150 8350 50  0001 C CNN
F 3 "" H 9150 8350 50  0001 C CNN
	1    9150 8350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5EA5DE79
P 10600 8550
F 0 "#PWR0102" H 10600 8300 50  0001 C CNN
F 1 "GND" H 10605 8377 50  0000 C CNN
F 2 "" H 10600 8550 50  0001 C CNN
F 3 "" H 10600 8550 50  0001 C CNN
	1    10600 8550
	1    0    0    -1  
$EndComp
Wire Wire Line
	10850 8550 10600 8550
Connection ~ 10600 8550
Wire Wire Line
	9650 8350 9400 8350
Connection ~ 9150 8350
Connection ~ 9400 8350
Wire Wire Line
	9400 8350 9150 8350
Text Label 9100 8650 2    50   ~ 0
IORDY
Text Label 9100 8750 2    50   ~ 0
_DMACK
Text Label 9100 8850 2    50   ~ 0
_ACTIVE
Wire Wire Line
	9400 8550 9400 8750
Wire Wire Line
	9400 8750 9100 8750
Wire Wire Line
	9650 8550 9650 8850
Wire Wire Line
	9650 8850 9100 8850
Wire Wire Line
	9150 8550 9150 8650
Wire Wire Line
	9150 8650 9100 8650
Text Label 10550 8200 2    50   ~ 0
DD7
Text Label 10550 8100 2    50   ~ 0
INTRQ
Wire Wire Line
	10550 8200 10600 8200
Wire Wire Line
	10600 8200 10600 8350
Wire Wire Line
	10550 8100 10850 8100
Wire Wire Line
	10850 8100 10850 8350
NoConn ~ 14350 7250
NoConn ~ 7800 3950
$Comp
L Connector:TestPoint TP1
U 1 1 5EA78871
P 12850 4500
F 0 "TP1" V 12804 4688 50  0000 L CNN
F 1 "RAM2 CE" V 12895 4688 50  0000 L CNN
F 2 "TestPoint:TestPoint_Pad_D1.0mm" H 13050 4500 50  0001 C CNN
F 3 "~" H 13050 4500 50  0001 C CNN
	1    12850 4500
	0    1    1    0   
$EndComp
Text Notes 2750 2450 2    50   ~ 0
OVR also connected\non 59, this is normal
Text Label 3350 3300 2    50   ~ 0
_RST
Text Notes 2850 3300 2    50   ~ 0
This RST is actually a passthrough to ease PCB routing
$Comp
L Connector:TestPoint TP2
U 1 1 5EB07645
P 3350 3200
F 0 "TP2" V 3304 3388 50  0000 L CNN
F 1 "IO3" V 3395 3388 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 3550 3200 50  0001 C CNN
F 3 "~" H 3550 3200 50  0001 C CNN
	1    3350 3200
	0    -1   -1   0   
$EndComp
$Comp
L Sassa:CY62177ESL-55ZXI U4
U 1 1 5EA454C2
P 14350 3600
F 0 "U4" H 14000 4950 50  0000 C CNN
F 1 "CY62177ESL-55ZXI" H 13900 4850 50  0000 C CNN
F 2 "Package_SO:TSOP-I-48_18.4x12mm_P0.5mm" H 15400 2150 50  0001 C CNN
F 3 "https://www.cypress.com/part/cy62177esl-55zxi" H 14050 4050 50  0001 C CNN
	1    14350 3600
	1    0    0    -1  
$EndComp
Text Label 3350 2600 2    50   ~ 0
RAM2CE
Text Label 3350 2500 2    50   ~ 0
RAM1CE
Text Label 3350 3400 2    50   ~ 0
A2
Text Label 3350 2200 2    50   ~ 0
A3
Text Label 3350 2100 2    50   ~ 0
A4
Text Label 3350 2000 2    50   ~ 0
A12
Text Label 3350 1900 2    50   ~ 0
A13
Text Label 3350 1800 2    50   ~ 0
A14
Text Label 3350 1700 2    50   ~ 0
A15
Text Label 3350 3800 2    50   ~ 0
A16
Text Label 14950 4500 0    50   ~ 0
A21
Text Notes 13400 5600 0    50   ~ 0
Warning : LDS, UDS and data lines are swapped\nto simplify routing
Text Label 3350 3500 2    50   ~ 0
A6
Text Label 3350 3600 2    50   ~ 0
A5
Text Label 3350 3700 2    50   ~ 0
A1
NoConn ~ 5350 5100
Text Label 3350 2300 2    50   ~ 0
_DTACK
Text Notes 10450 6050 0    50   ~ 0
TODO : Clockport ?
Text Notes 13200 5900 0    50   ~ 0
PCB ready for CY62177ESL\nhowever due to the price of this chip only CY62167ELL are tested.\nStay away from low voltage versions of this chip.
$EndSCHEMATC
