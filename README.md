<!-- HEADERS -->
<h1 align="center">
  <b> 
    Multiplicador serie
  </b>
</h1>

- [🎯 Objetivos](https://github.com/jorgeloopzz/Multipliier#-objetivos)
- [✖️ Proceso de la multiplicación](https://github.com/jorgeloopzz/Multipliier#%EF%B8%8F-proceso-de-la-multiplicaci%C3%B3n)
- [📓 Definición del data-path](https://github.com/jorgeloopzz/Multipliier#-definici%C3%B3n-del-data-path)
  - [🔢 Contador](https://github.com/jorgeloopzz/Multipliier#-contador)
- [🕹️ Definición de la unidad de control](https://github.com/jorgeloopzz/Multipliier#%EF%B8%8F-definici%C3%B3n-de-la-unidad-de-control)
- [🔲 Esquema general del multiplicador](https://github.com/jorgeloopzz/Multipliier#-esquema-general-del-multiplicador)
- [📟 Simulación en Quartus](https://github.com/jorgeloopzz/Multipliier#-simulaci%C3%B3n-en-quartus)
- [🛠️ Implementación en la placa](https://github.com/jorgeloopzz/Multipliier#%EF%B8%8F-implementaci%C3%B3n-en-la-placa)

&nbsp;

# 🎯 Objetivos

El objetivo general de este proyecto es la realización de un multiplicador serie e implementarlo en la tarjeta DE10-Lite. El multiplicador tomará dos datos de 4 bits (X e Y) y los multiplicará.

&nbsp;

# ✖️ Proceso de la multiplicación

El resultado estará formado por una "parte alta" y una "parte baja" de 4 bits, la unión de ambas partes será el número final. Para llegar a dicho valor, se emplea el siguiente algoritmo:

- Al iniciar la operación, a la parte alta se le asigna 0 y a la parte baja el valor de Y.
- Si el bit menos significativo de la parte baja es 0, se realiza un desplazamiento a la derecha de la parte alta añadiendo un 0 al principio, quedando al final un número de 5 bits.
- En caso contrario, se realiza la misma operación, pero a la parte alta se le suma el valor de X.
- Este algoritmo hay que hacerlo un total de 4 veces (sin contar la inicialización) y es realizado por la **ALU**.

<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/tabla.png">

&nbsp;

# 📓 Definición del data-path

El circuito para implementar esas operaciones estará formado por 2 registros que almacenen X y el resultado final, la unidad aritmético lógica y 2 multiplexores que unirán parte alta y baja, formando el siguiente diagrama de bloques:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/data-path.png">

## 🔢 Contador

¿Y cómo controlamos los pasos que tiene que hacer el data-path? El final de la multiplicación se maneja mediante una señal de salida _done_ que se pone a 1 cuando acaba. En la [descripición VHDL](https://github.com/jorgeloopzz/Multipliier/blob/main/quartus/multiplier_datapath.vhd) hay que añadir un [contador](https://github.com/jorgeloopzz/Multipliier/blob/main/quartus/contador_k.vhd) no mostrado en la imagen. Este contador ya viene definido para que cuenta hasta 4, por lo que conectamos su RCO, _fin_cuenta_, a la señal de salida para que se ponga a 1 cuando termine de contar.

&nbsp;

# 🕹️ Definición de la unidad de control

La unidad de control del multiplicador se realizará mediante una MEF que siga el siguiente diagrama de estados:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/MEF.png">

Esta genera las señales por las que se inicia el producto (**inicio**) y se empieza el proceso de multiplicación (**enable**). El contador mencionado antes, empieza a contar en el estado de **mult**, por lo tanto, su _enable_ debe estar a 1 cuando cuando **inicio** y **enable** tienen los valores correspondientes.

&nbsp;

# 🔲 Esquema general del multiplicador

El circuito multiplicador estará constituido por la unidad de control y por la unidad de data-path, según se muestra en la siguiente imagen:

&nbsp;
<img src="https://raw.githubusercontent.com/jorgeloopzz/Multipliier/main/assets/esquema.png">

&nbsp;

# 📟 Simulación en Quartus

Primero crearemos un proyecto, seleccionando las siguientes [opciones](https://www.iuma.ulpgc.es/roberto/ed/practicas/Quartus_tutorial.html#abrir-quartusii-y-crear-un-proyecto) que he usado en las prácticas de la asignatura. Luego se añade la carpeta quartus al proyecto y se debe declarar a `multiplier_top.vhd` como top-level entity. La simulación se hará con el siguiente procedimiento:

1. Crear un nuevo fichero de formas de onda con el University Wafeform VWF (Waveform.vwf).
2. Introducir todos los pines del circuito en el diagrama de formas de onda.
3. Establecer el tiempo de simulación en 500 ns.
4. Seleccionar para _x_in_, _y_in_ y _p_out_ el radix como “Unsigned Decimal” y darles un valor arbitrario para multiplicarlos.
5. Establecer una señal de reloj de 20 MHz y el resto de las señales tal como aparece en la imagen siguiente:

> Imagen

6. Realizar la simulación y comprobar que el resultado es el siguiente, donde se observa que al multiplicar 9x9 el resultado es 81.

> Imagen

7. También se pueden realizar simulaciones en EDAPlayground usando el [testbench](https://github.com/jorgeloopzz/Multipliier/blob/main/quartus/testbench.vhd).

> Este apartado se indica de forma distinta en la [página web](https://www.iuma.ulpgc.es/roberto/ed/Trabajos_Asignatura/T1_multiplicador/trabajo-multiplicador.html) del trabajo, pero así evitamos manejar las señales **inicio** y **enable** dándole los valores manualmente, sino que será la máquina de control la que se ocupe de ellas, y de paso comprobamos su correcto funcionamiento.

&nbsp;

# 🛠️ Implementación en la placa

Añadiremos la carpeta utils-display al proyecto, que contiene los archivos para representar los datos en BCD. Declaramos `TrabajoPR1_multiplicador.vhd` como top-level entity, que define los leds que deben encenderse en la placa. Luego haremos la asignación de pines importando el fichero `TrabajoPR1_multiplicador.qsf`, es importante que se encuentre dentro de la carpeta de trabajo. La conexión de los pines se muestra en la siguiente imagen:

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
