# 🔋 Smart DC Load Bank – PIC16F876A Project

> A fully functional, LCD-displaying, MOSFET-driven, PWM-controlled DC load bank designed for testing the true limits of your power supplies.

---

## 🧠 What is a DC Load Bank?

A **DC Load Bank** is a device used to **simulate a real electrical load**. It draws current from a power supply to test how well that supply performs under different levels of stress — like high current or long usage times. This is essential when you're designing or validating power sources such as:

- Bench power supplies
- Battery packs
- Solar systems
- DC adapters

Instead of risking actual devices, a DC load bank safely replicates the load and shows you how stable your source is — including its **voltage regulation** and **current limits**.

---

## 🔧 Project Overview

This project is a **Smart DC Load Bank** built around the **PIC16F876A** microcontroller. It uses a **MOSFET as a variable resistor**, controlled through **PWM (Pulse Width Modulation)** to precisely control how much current is drawn from the power supply.

All real-time parameters — like **voltage**, **current**, **PWM duty cycle**, and **power** — are displayed on a **16x2 LCD screen** for easy monitoring.

---

## ⚙️ Features

| Feature              | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| 🔌 **Load Control**    | PWM-driven MOSFET simulates variable resistive load                         |
| ⚡ **Voltage Sensing** | Analog voltage divider read by ADC (RA0)                                   |
| 🔄 **Current Sensing** | Current measured via **0.1Ω shunt resistor**, calculated in software       |
| 📉 **Duty Cycle Display** | Real-time **PWM duty (%)** shown on LCD                                   |
| 💡 **LCD Feedback**     | 16x2 LCD displays **Voltage (V)**, **Current (A)**, **Duty (%)**, **Power (W)** |
| 🎛️ **User Controls**    | Two buttons (RC6/RC7) to increase/decrease PWM (load level)                |
| 🛠️ **Simulation Ready** | Includes Proteus file + HEX for full offline simulation                    |
| 🧰 **PCB Included**     | Double-sided PCB layout with 3D view                                      |

---

## 🧪 What's in the Repository?

📁 Smart-DC-Load-Bank/
├── main.c # MikroC source code
├── main.hex # Compiled HEX for PIC simulation
├── Smart_DC_Load_Bank.pdsprj # Proteus project file
├── Smart_DC_Load_Bank.pcbdoc # PCB layout (double copper)
├── 3D_PCB_View.png # (Optional) Render of 3D PCB
├── README.md # This file
└── LICENSE # MIT License
## 🧪 Simulation Instructions (Proteus)

1. Open `Smart_DC_Load_Bank.pdsprj` in **Proteus 8 or later**.
2. Make sure `main.hex` is loaded into the **PIC16F876A**.
3. Power up the simulation with a DC source (e.g., 12V).
4. Use the two buttons (RC6/RC7) to change load (PWM duty cycle).
5. Watch the LCD for:
   - 📐 Voltage (V)
   - 🔥 Current (A)
   - 📊 PWM Duty Cycle (%)
   - ⚙️ Power Consumption (W)

---

## 🛠️ Hardware Overview

| Component     | Value/Part        | Function                      |
|---------------|-------------------|-------------------------------|
| MCU           | PIC16F876A        | Controls PWM, reads ADC       |
| MOSFET        | IRFZ44N (example) | Acts as controlled load       |
| Shunt Resistor| 0.1Ω              | Current sensing via voltage drop |
| LCD           | 16x2              | Displays system data          |
| Buttons       | x2                | User control of PWM duty      |
| Regulator     | 7805, etc.        | Powers PIC and logic circuit  |

---

## 📷 Screenshot (Simulation)

> *(You can add a screenshot of your Proteus simulation and LCD display here)*

---

## 📜 License

This project is licensed under the **MIT License** – do whatever you want with proper credit.  
See the [LICENSE](LICENSE) file for full details.

---

## 👤 Author

Developed with 🔧 and 💡 by **[Garablue X](https://github.com/GarablueX)**

📬 For feedback or collaboration, feel free to reach out!
