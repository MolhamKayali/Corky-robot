' ******************************************************************************
' * Title         : CORKY ROBOT.bas                                            *
' * Version       : 1.0                                                        *
' * Last Updated  : 04.25.2014                                                 *
' * Target Board  : Phoenix - REV 1.00                                         *
' * Target MCU    : ATMega128A                                                 *
' * Author        : Molham Kayali                                              *
' * IDE           : BASCOM AVR 2.0.7.0                                         *
' * UNIVERSITY    : Emporia State University                                   *
' * Description   : ESU Hornet Robotics                                        *
' ******************************************************************************
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$regfile = "m128def.dat"
$crystal = 8000000
$baud = 9600


Config Pina.0 = Output : Dc1 Alias Porta.0 : Reset Dc1
Config Pina.1 = Output : Dc2 Alias Porta.1 : Reset Dc2

Config Pina.2 = Output : Dc3 Alias Porta.2 : Reset Dc3
Config Pina.3 = Output : Dc4 Alias Porta.3 : Reset Dc4

Config Adc = Single , Prescaler = Auto , Reference = Avcc
'On Adc Adc_isr
Enable Adc

Config Single = Scientific , Digits = 3

Config Lcdpin = Pin , Db4 = Portc.4 , Db5 = Portc.5 , Db6 = Portc.6 , Db7 = Portc.7 , E = Portg.1 , Rs = Portg.0 , Wr = Portg.2
Config Lcd = 16 * 2

Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Down , Prescale = 1 , Compare B Pwm = Clear Up
Enable Compare1a
Enable Compare1b

Config Pine.4 = Input : Sw Alias Pine.4 : Porte.4 = 1


Dim H As Bit
Dim La As Bit
Dim Ra As Bit
Dim Mcorky As Bit
Dim Rcorky As Bit
Dim Char As String * 1
Dim X_0 As Word
Dim Y_0 As Word
Dim X_1 As Word
Dim Y_1 As Word
Dim X_2 As Word
Dim Y_2 As Word
Dim I As Byte
Dim Last_sec As Byte
Const V_ref = 5
Dim X As Single
Dim Y As Single
Dim X1 As Single
Dim Y1 As Single
Dim X2 As Single
Dim Y2 As Single
Dim Channel As Byte
Dim Count_5s As Byte , Adc_val As Word

Enable Interrupts

Cursor Off Noblink : Cls

Do

   Gosub Read_adc                                           'ADC
   Gosub J1_x_axis : Gosub J1_y_axis
   'Gosub J2_x_axis : Gosub J2_y_axis
   'Gosub J3_x_axis : Gosub J3_y_axis
   'Gosub Display_axis
   'Wait 1
   Gosub Display_axis2
    Wait 1
    Debounce Sw , 0 , Sendall , Sub
   If Ischarwaiting() = 1 Then
      Char = Inkey()
      Lcd Char
   End If
   'Gosub Pwm_value
   Gosub Dc_motor
   'Wait 5
   'Gosub Dc_r_motor
'Wait 5
   'Waitms 250

Loop
End

'--->ADC
Read_adc:
'For I = 0 To 7
X_0 = Getadc(0) : Y_0 = Getadc(1)

'Next I
 Return
  '--->[Read ADC Input Values]
Adc_isr:
   Adc_val = Getadc(0)
   Adc_val = Getadc(1)
   Adc_val = Getadc(2)
   Adc_val = Getadc(3)
   Adc_val = Getadc(4)
   Adc_val = Getadc(5)
Return
 '---Joystick EQUAITION
 '--->[DC voltage 1]
 '22(10/10+39)=4.48
 '4.48/1024=4.375m
 J1_x_axis:
 X = X_0 * V_ref : X = X / 1024
 Print X
 Return
 J2_x_axis:
 X1 = X_1 * V_ref : X1 = X1 / 1024
 Print X1
 Return
 J3_x_axis:
 X2 = X_2 * V_ref : X2 = X2 / 1024
 Print X2
 Return
 '--->[DC current 1]
 J1_y_axis:
 Y = Y_0 * V_ref : Y = Y / 1024
 Print Y
 Return
  '--->[DC current 1]
 J2_y_axis:
 Y1 = Y_1 * V_ref : Y1 = Y1 / 1024
 Print Y1
 Return
 J3_y_axis:
 Y2 = Y_2 * V_ref : Y2 = Y2 / 1024
 Print Y2
 Return

'--->[Display Dc voltage 1  DC current 1]
Display_axis:
   Cls
   Locate 1 , 1 : Lcd " X : " ; X1 ; " X VLT"
   Locate 2 , 1 : Lcd " Y : " ; Y1 ; " Y VLT"
Return
'--->[Speed RPM]
Display_axis2:
   Cls
   Locate 1 , 1 : Lcd "PWM: " ; X ; " RPM"
   Locate 2 , 1 : Lcd "PWM: " ; Y ; " RPM"
Return
Sendall:
   Print "This is RS485 Test Program"
   Print X
   Print Y
   'Set Portd.0
   Waitms 250
Return
'--->PWM
Pwm_value:
   Pwm1a = X_0
   Pwm1b = Y_0
Return
      Return
Dc_motor:

   Reset Dc1 : Reset Dc2 : Reset Dc3 : Reset Dc4            '0
   Waitms 200

   Set Dc1 : Reset Dc2 : Reset Dc3 : Reset Dc4              '1
   Waitms 200

   Reset Dc1 : Set Dc2 : Reset Dc3 : Reset Dc4              '2
   Waitms 200

   Set Dc1 : Set Dc2 : Reset Dc3 : Reset Dc4                '3
   Waitms 200

   Reset Dc1 : Reset Dc2 : Set Dc3 : Reset Dc4              '4
   Waitms 200

   Set Dc1 : Reset Dc2 : Set Dc3 : Reset Dc4                '5
   Waitms 200

'   Reset Dc1 : Set Dc2 : Set Dc3 : Reset Dc4                '6
'   Waitms 200

'   Set Dc1 : Set Dc2 : Set Dc3 : Reset Dc4                  '7
   Waitms 200

   'Reset Dc1 : Reset Dc2 : Reset Dc3 : Set Dc4              '8
   'Waitms 300

   Return

   Dc_r_motor:

   Reset Dc1 : Reset Dc2 : Reset Dc3 : Reset Dc4            '0
   Waitms 200

   Reset Dc1 : Reset Dc2 : Reset Dc3 : Set Dc4              '1
   Waitms 200

   Reset Dc1 : Reset Dc2 : Set Dc3 : Reset Dc4              '2
   Waitms 200

   Reset Dc1 : Reset Dc2 : Set Dc3 : Set Dc4                '3
   Waitms 200

   Reset Dc1 : Set Dc2 : Reset Dc3 : Reset Dc4              '4
   Waitms 200

   Reset Dc1 : Set Dc2 : Reset Dc3 : Set Dc4                '5
   Waitms 200

'   Reset Dc1 : Set Dc2 : Set Dc3 : Reset Dc4                '6
'   Waitms 200

'   Set Dc1 : Set Dc2 : Set Dc3 : Reset Dc4                  '7
   Waitms 200

   'Reset Dc1 : Reset Dc2 : Reset Dc3 : Set Dc4              '8
   'Waitms 300

   Return
