#line 1 "C:/Users/GarablueX/Desktop/MC2/M222.c"
sbit LCD_RS at RB1_bit;
sbit LCD_EN at RB0_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB1_bit;
sbit LCD_EN_Direction at TRISB0_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

unsigned int duty = 600;
float current = 0.0;


void PWM_Init();
void Set_Duty( duty);
float Read_Current();
void LCD_Setup();
void LCD_Update();
void Check_Buttons();

void My_ADC_Init() {
 ADCON1 = 0x80;
 ADCON0 = 0x41;
 TRISA0_bit = 1;
 delay_ms(50);
}
void LCD_Setup() {
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
}

void PWM_Init() {
 PR2 = 0xFF;
 CCP2CON = 0x0C;
 T2CON = 0x04;
 TMR2 = 0;
 TRISC1_bit = 0;
}

void Set_Duty(unsigned int duty_val) {
 if (duty_val > 1023) duty_val = 1023;
 CCPR2L = duty_val >> 2;
 CCP2CON.B1 = (duty_val >> 1) & 0x01;
 CCP2CON.B0 = duty_val & 0x01;
}

float Read_Current() {
 unsigned int adc_val;
 float v_adc, v_shunt, current;

 ADCON0.GO = 1;
 while (ADCON0.GO);

 adc_val = (ADRESH << 8) + ADRESL;

 v_adc = (adc_val * 5) / 1024.0;
 v_shunt = v_adc / 0.1;
 current = v_shunt / 10;

 return current;
}

char txt[16];

void LCD_Update() {
 float power;

 Lcd_Out(1, 1, "PWM:");
 IntToStr(duty, txt);
 Lcd_Out_CP(txt);
 Lcd_Out(2, 1, "CUR:");
 FloatToStr(current, txt);
 txt[5] = '\0';
 Lcd_Out_CP(txt);
 Lcd_Out_CP("A");
 Lcd_Out(3,1,"Saif Abd'essayed");


}

void Check_Buttons() {
 if (PORTC.RC6 == 1) {
 Delay_ms(30);
 duty += 15;
 if (duty > 1023) duty = 1023;
 Set_Duty(duty);
 while (PORTC.RC6 == 1);

 }

 if (PORTC.RC7 == 1) {
 Delay_ms(30);
 if (PORTC.RC7 == 1) {
 if (duty >= 10) duty -= 15;
 else duty = 0;
 Set_Duty(duty);
 while (PORTC.RC7 == 1);
 }
 }
}

void main() {
 TRISC6_bit = 1;
 TRISC7_bit = 1;

 LCD_Setup();
 My_ADC_Init();
 PWM_Init();
 Set_Duty(duty);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 while (1) {
 Check_Buttons();
 current = Read_Current();
 LCD_Update();
 Delay_ms(50);
 }
}
