
_My_ADC_Init:

;M222.c,26 :: 		void My_ADC_Init() {
;M222.c,27 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;M222.c,28 :: 		ADCON0 = 0x41;
	MOVLW      65
	MOVWF      ADCON0+0
;M222.c,29 :: 		TRISA0_bit = 1;
	BSF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;M222.c,30 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_My_ADC_Init0:
	DECFSZ     R13+0, 1
	GOTO       L_My_ADC_Init0
	DECFSZ     R12+0, 1
	GOTO       L_My_ADC_Init0
	NOP
	NOP
;M222.c,31 :: 		}
L_end_My_ADC_Init:
	RETURN
; end of _My_ADC_Init

_LCD_Setup:

;M222.c,32 :: 		void LCD_Setup() {
;M222.c,33 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;M222.c,34 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;M222.c,35 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;M222.c,36 :: 		}
L_end_LCD_Setup:
	RETURN
; end of _LCD_Setup

_PWM_Init:

;M222.c,38 :: 		void PWM_Init() {
;M222.c,39 :: 		PR2 = 0xFF;
	MOVLW      255
	MOVWF      PR2+0
;M222.c,40 :: 		CCP2CON = 0x0C;
	MOVLW      12
	MOVWF      CCP2CON+0
;M222.c,41 :: 		T2CON = 0x04;
	MOVLW      4
	MOVWF      T2CON+0
;M222.c,42 :: 		TMR2 = 0;
	CLRF       TMR2+0
;M222.c,43 :: 		TRISC1_bit = 0;
	BCF        TRISC1_bit+0, BitPos(TRISC1_bit+0)
;M222.c,44 :: 		}
L_end_PWM_Init:
	RETURN
; end of _PWM_Init

_Set_Duty:

;M222.c,46 :: 		void Set_Duty(unsigned int duty_val) {
;M222.c,47 :: 		if (duty_val > 1023) duty_val = 1023;
	MOVF       FARG_Set_Duty_duty_val+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__Set_Duty23
	MOVF       FARG_Set_Duty_duty_val+0, 0
	SUBLW      255
L__Set_Duty23:
	BTFSC      STATUS+0, 0
	GOTO       L_Set_Duty1
	MOVLW      255
	MOVWF      FARG_Set_Duty_duty_val+0
	MOVLW      3
	MOVWF      FARG_Set_Duty_duty_val+1
L_Set_Duty1:
;M222.c,48 :: 		CCPR2L = duty_val >> 2;
	MOVF       FARG_Set_Duty_duty_val+0, 0
	MOVWF      R0+0
	MOVF       FARG_Set_Duty_duty_val+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      CCPR2L+0
;M222.c,49 :: 		CCP2CON.B1 = (duty_val >> 1) & 0x01;
	MOVF       FARG_Set_Duty_duty_val+0, 0
	MOVWF      R0+0
	MOVF       FARG_Set_Duty_duty_val+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVLW      1
	ANDWF      R0+0, 1
	BTFSC      R0+0, 0
	GOTO       L__Set_Duty24
	BCF        CCP2CON+0, 1
	GOTO       L__Set_Duty25
L__Set_Duty24:
	BSF        CCP2CON+0, 1
L__Set_Duty25:
;M222.c,50 :: 		CCP2CON.B0 = duty_val & 0x01;
	MOVLW      1
	ANDWF      FARG_Set_Duty_duty_val+0, 0
	MOVWF      R0+0
	BTFSC      R0+0, 0
	GOTO       L__Set_Duty26
	BCF        CCP2CON+0, 0
	GOTO       L__Set_Duty27
L__Set_Duty26:
	BSF        CCP2CON+0, 0
L__Set_Duty27:
;M222.c,51 :: 		}
L_end_Set_Duty:
	RETURN
; end of _Set_Duty

_Read_Current:

;M222.c,53 :: 		float Read_Current() {
;M222.c,57 :: 		ADCON0.GO = 1;
	BSF        ADCON0+0, 2
;M222.c,58 :: 		while (ADCON0.GO);
L_Read_Current2:
	BTFSS      ADCON0+0, 2
	GOTO       L_Read_Current3
	GOTO       L_Read_Current2
L_Read_Current3:
;M222.c,60 :: 		adc_val = (ADRESH << 8) + ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;M222.c,62 :: 		v_adc = (adc_val * 5) / 1024.0;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      137
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
;M222.c,63 :: 		v_shunt = v_adc / 0.1;
	MOVLW      205
	MOVWF      R4+0
	MOVLW      204
	MOVWF      R4+1
	MOVLW      76
	MOVWF      R4+2
	MOVLW      123
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
;M222.c,64 :: 		current = v_shunt / 10;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
;M222.c,66 :: 		return current;
;M222.c,67 :: 		}
L_end_Read_Current:
	RETURN
; end of _Read_Current

_LCD_Update:

;M222.c,71 :: 		void LCD_Update() {
;M222.c,74 :: 		Lcd_Out(1, 1, "PWM:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_M222+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;M222.c,75 :: 		IntToStr(duty, txt);
	MOVF       _duty+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _duty+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;M222.c,76 :: 		Lcd_Out_CP(txt);
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;M222.c,77 :: 		Lcd_Out(2, 1, "CUR:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_M222+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;M222.c,78 :: 		FloatToStr(current, txt);
	MOVF       _current+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       _current+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       _current+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       _current+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _txt+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;M222.c,79 :: 		txt[5] = '\0';
	CLRF       _txt+5
;M222.c,80 :: 		Lcd_Out_CP(txt);
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;M222.c,81 :: 		Lcd_Out_CP("A");
	MOVLW      ?lstr3_M222+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;M222.c,82 :: 		Lcd_Out(3,1,"Saif Abd'essayed");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_M222+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;M222.c,85 :: 		}
L_end_LCD_Update:
	RETURN
; end of _LCD_Update

_Check_Buttons:

;M222.c,87 :: 		void Check_Buttons() {
;M222.c,88 :: 		if (PORTC.RC6 == 1) {
	BTFSS      PORTC+0, 6
	GOTO       L_Check_Buttons4
;M222.c,89 :: 		Delay_ms(30);
	MOVLW      78
	MOVWF      R12+0
	MOVLW      235
	MOVWF      R13+0
L_Check_Buttons5:
	DECFSZ     R13+0, 1
	GOTO       L_Check_Buttons5
	DECFSZ     R12+0, 1
	GOTO       L_Check_Buttons5
;M222.c,90 :: 		duty += 15;
	MOVLW      15
	ADDWF      _duty+0, 0
	MOVWF      R1+0
	MOVF       _duty+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _duty+0
	MOVF       R1+1, 0
	MOVWF      _duty+1
;M222.c,91 :: 		if (duty > 1023) duty = 1023;
	MOVF       R1+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__Check_Buttons31
	MOVF       R1+0, 0
	SUBLW      255
L__Check_Buttons31:
	BTFSC      STATUS+0, 0
	GOTO       L_Check_Buttons6
	MOVLW      255
	MOVWF      _duty+0
	MOVLW      3
	MOVWF      _duty+1
L_Check_Buttons6:
;M222.c,92 :: 		Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_Set_Duty_duty_val+0
	MOVF       _duty+1, 0
	MOVWF      FARG_Set_Duty_duty_val+1
	CALL       _Set_Duty+0
;M222.c,93 :: 		while (PORTC.RC6 == 1);
L_Check_Buttons7:
	BTFSS      PORTC+0, 6
	GOTO       L_Check_Buttons8
	GOTO       L_Check_Buttons7
L_Check_Buttons8:
;M222.c,95 :: 		}
L_Check_Buttons4:
;M222.c,97 :: 		if (PORTC.RC7 == 1) {
	BTFSS      PORTC+0, 7
	GOTO       L_Check_Buttons9
;M222.c,98 :: 		Delay_ms(30);
	MOVLW      78
	MOVWF      R12+0
	MOVLW      235
	MOVWF      R13+0
L_Check_Buttons10:
	DECFSZ     R13+0, 1
	GOTO       L_Check_Buttons10
	DECFSZ     R12+0, 1
	GOTO       L_Check_Buttons10
;M222.c,99 :: 		if (PORTC.RC7 == 1) {
	BTFSS      PORTC+0, 7
	GOTO       L_Check_Buttons11
;M222.c,100 :: 		if (duty >= 10) duty -= 15;
	MOVLW      0
	SUBWF      _duty+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Check_Buttons32
	MOVLW      10
	SUBWF      _duty+0, 0
L__Check_Buttons32:
	BTFSS      STATUS+0, 0
	GOTO       L_Check_Buttons12
	MOVLW      15
	SUBWF      _duty+0, 1
	BTFSS      STATUS+0, 0
	DECF       _duty+1, 1
	GOTO       L_Check_Buttons13
L_Check_Buttons12:
;M222.c,101 :: 		else duty = 0;
	CLRF       _duty+0
	CLRF       _duty+1
L_Check_Buttons13:
;M222.c,102 :: 		Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_Set_Duty_duty_val+0
	MOVF       _duty+1, 0
	MOVWF      FARG_Set_Duty_duty_val+1
	CALL       _Set_Duty+0
;M222.c,103 :: 		while (PORTC.RC7 == 1);
L_Check_Buttons14:
	BTFSS      PORTC+0, 7
	GOTO       L_Check_Buttons15
	GOTO       L_Check_Buttons14
L_Check_Buttons15:
;M222.c,104 :: 		}
L_Check_Buttons11:
;M222.c,105 :: 		}
L_Check_Buttons9:
;M222.c,106 :: 		}
L_end_Check_Buttons:
	RETURN
; end of _Check_Buttons

_main:

;M222.c,108 :: 		void main() {
;M222.c,109 :: 		TRISC6_bit = 1;
	BSF        TRISC6_bit+0, BitPos(TRISC6_bit+0)
;M222.c,110 :: 		TRISC7_bit = 1;
	BSF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;M222.c,112 :: 		LCD_Setup();
	CALL       _LCD_Setup+0
;M222.c,113 :: 		My_ADC_Init();
	CALL       _My_ADC_Init+0
;M222.c,114 :: 		PWM_Init();
	CALL       _PWM_Init+0
;M222.c,115 :: 		Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_Set_Duty_duty_val+0
	MOVF       _duty+1, 0
	MOVWF      FARG_Set_Duty_duty_val+1
	CALL       _Set_Duty+0
;M222.c,117 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;M222.c,118 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;M222.c,120 :: 		while (1) {
L_main16:
;M222.c,121 :: 		Check_Buttons();
	CALL       _Check_Buttons+0
;M222.c,122 :: 		current = Read_Current();
	CALL       _Read_Current+0
	MOVF       R0+0, 0
	MOVWF      _current+0
	MOVF       R0+1, 0
	MOVWF      _current+1
	MOVF       R0+2, 0
	MOVWF      _current+2
	MOVF       R0+3, 0
	MOVWF      _current+3
;M222.c,123 :: 		LCD_Update();
	CALL       _LCD_Update+0
;M222.c,124 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	DECFSZ     R12+0, 1
	GOTO       L_main18
	NOP
	NOP
;M222.c,125 :: 		}
	GOTO       L_main16
;M222.c,126 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
