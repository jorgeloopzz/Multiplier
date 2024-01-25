<!-- HEADERS -->
<h1 align="center">
  <b> 
    Serial Multiplier
  </b>
</h1>

<h1>
  <a href="https://github.com/jorgeloopzz/Multipliier/blob/main/README.es.md">
    🇪🇸
  </a>
  <a href="https://github.com/jorgeloopzz/Multipliier/blob/main/README.md">
    🇬🇧
  </a>
</h1>

- [🎯 Objectives](https://github.com/jorgeloopzz/Multipliier#-objectives)
- [✖️ Multiplication Process](https://github.com/jorgeloopzz/Multipliier#️-multiplication-process)
- [📓 Definition of the Data-Path](https://github.com/jorgeloopzz/Multipliier#-definition-of-the-data-path)
  - [🔢 Counter](https://github.com/jorgeloopzz/Multipliier#-counter)
- [🕹️ Definition of the Control Unit](https://github.com/jorgeloopzz/Multipliier#️-definition-of-the-control-unit)
- [🔲 General Scheme of the Multiplier](https://github.com/jorgeloopzz/Multipliier#-general-scheme-of-the-multiplier)
- [🛠️ Implementation on the Board](https://github.com/jorgeloopzz/Multipliier#️-implementation-on-the-board)

&nbsp;

# 🎯 Objectives

The general objective of this project is to create a serial multiplier and implement it on the DE10-Lite board. The multiplier will take two 4-bit data (X and Y) and multiply them.

&nbsp;

# ✖️ Multiplication Process

The result will consist of a "high part" and a "low part" of 4 bits each, and the union of both parts will be the final number. To obtain this value, the following algorithm is used:

- At the start of the operation, the high part is assigned 0, and the low part is assigned the value of Y.
- If the least significant bit of the low part is 0, a right shift of the high part is performed by adding a 0 at the beginning, resulting in a 5-bit number.
- Otherwise, the same operation is performed, but the value of X is added to the high part.
- This algorithm must be repeated a total of 4 times (excluding initialization) and is performed by the **ALU**.

<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/tabla.png">

&nbsp;

# 📓 Definition of the Data-Path

The circuit to implement these operations will consist of 2 registers that store X and the final result, the arithmetic logic unit, and 2 multiplexers that will join the high and low parts, forming the following block diagram:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/data-path.png">

## 🔢 Counter

And how do we control the steps that the data-path has to take? The end of the multiplication is managed by an output signal _done_ that is set to 1 when it finishes. In the [VHDL description](https://github.com/jorgeloopzz/Multipliier/blob/main/quartus/multiplier_datapath.vhd), you need to add a [counter](https://github.com/jorgeloopzz/Multipliier/blob/main/quartus/contador_k.vhd) not shown in the image. This counter is already defined to count up to 4, so you connect its RCO, _fin_cuenta_, to the output signal to set it to 1 when it finishes counting.

&nbsp;

# 🕹️ Definition of the Control Unit

The control unit of the multiplier will be implemented through a FSM following the following state diagram:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/MEF.png">

It generates the signals to start the product (**start**) and initiate the multiplication process (**enable**). The aforementioned counter starts counting in the **mult** state, so its _enable_ must be set to 1 when **start** and **enable** have the corresponding values.

&nbsp;

# 🔲 General Scheme of the Multiplier

The multiplier circuit will consist of the control unit and the data-path unit, as shown in the following image:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/esquema.png">

&nbsp;

# 🛠️ Implementation on the Board

We will add the utils-display folder to the project, which contains the files to represent the data in BCD. Declare `TrabajoPR1_multiplicador.vhd` as the top-level entity, defining the LEDs that should light up on the board. Then, assign the pins by importing the file `TrabajoPR1_multiplicador.qsf`, and it is important that it is located within the working folder. The pin connection is shown in the following image:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/placa.jpeg">

&nbsp;

|                                           4 X 2                                            |                                           8 X 2                                            |
| :----------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------: |
| <img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/4x2.jpeg"> | <img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/8x2.jpeg"> |

<div align="center">
  <a href="https://eite.ulpgc.es/index.php/es/">
   <img src="https://www.ulpgc.es/sites/default/files/ArchivosULPGC/identidad-corporativa/NuevoLogo/eite_hc.png" width=300>
  </a>
  <a href="https://www.diea.ulpgc.es/">
    <img src="https://www.ulpgc.es/sites/default/files/ArchivosULPGC/identidad-corporativa/NuevoLogo/dingelectronica_hc.png" width=300>
  </a>
  <a href="https://www.ulpgc.es/">
    <img src="https://www.ulpgc.es/sites/default/files/ArchivosULPGC/identidad-corporativa/Logo%2025%20Aniversario/logo_ulpgc_horizontal_acronimo_2t.png" width=200>
  </a>
</div>