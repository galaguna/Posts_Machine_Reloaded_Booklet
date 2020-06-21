# Posts_Machine_Reloaded_Booklet
Code source for the design, implementation and programming of a small and functional CPU prototype based on an improved version of the Post's Machine.

# The Post’s Machine Reloaded: Design, Implementation and Programming of a Small and Functional CPU Prototype

This repository contains the complete original code for both the [first Spanish edition, Open Edition eBook](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/releases/tag/First_Spanish_Edition), in process of be published, and the [first English edition, Open Edition eBook](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/releases/tag/First_English_Edition), in process of be published too.

In the refered booklet, the complete development of the design, implementation and programming of the prototype for a small central processing unit (CPU) is presented, starting with an improved variant of the Post’s Machine. The Post’s Machine is a theoretical development similar to that of Alan Turing, the famous mathematician considered to be one of the fathers of modern computing, although developed by Emil Post in an entirely original and independent way. The Post’s Machine is much simpler than Turing's, therefore, given its relative simplicity, it allows those interested to be introduced, in a clear way, to the basic concepts related to the operation of virtually every modern digital CPU. 

The development of the logical design of the corresponding digital system is explained, it is specified by means of Register Transfer Level (RTL) methodology, its codification is shown with VHDL language and it is implemented with the resources of a low cost FPGA development board. The prototype obtained could be used for the interested parties to experiment, in a very concrete and practical way, the concepts of micro-code, algorithm and programming, both in assembly language and in machine language.
  
Finally, it is demonstrated that it is possible to build, with relatively limited resources, a micro-processed system that allows the acquisition of the necessary knowledge and experience to be introduced in the field of design and application of modern digital systems. Therefore, this work can be used as a reference, both theoretical and practical, for any engineer, or computer and electronics amateurs, who wishes to go deeper into the details of the design and construction of a prototype for a simple but functional microprocessor. The material in this work can even be of great interest, in the academic environment, as a complementary textbook for the Advanced Logical Design, Micro-processing Systems and other related courses.


# Extending the project

To develop your own more elaborate versions of the prototype, please **fork** this. 

You can try de following:

* The specification for the design of the original prototype, given its pedagogical nature, contemplated a maximum code space of 256 nibbles and 256 bits for the data space. It is clear that this limitation can be easily overcome by modifying the code provided.  It should only be taken into account that any extension of these spaces has a direct impact on the number of bits required for the coding of jump instructions (machine code) and, therefore, on the design of the ASMD diagrams for the development of the machine cycles presented in the book.

* The speed of execution is another aspect that can also be modified, this one more immediately. The speed of execution of the prototype presented is very slow only to give the opportunity to observe the progress in the machine cycles. For this purpose, a divider is used for the system clock signal. To accelerate the speed of execution of the prototype, simply occupy another tap of the counter, which is used as a divider for the clock signal, or simply use the system clock signal.

* Finally, it is clear that the machine code of the prototype, as explained in the book, is generated manually by the programmer. It is an interesting challenge to develop an assembler program to generate the machine code from the source code with the instructions in assembler.

# Reading this book

To read this book, click on each of the chapters to read in your browser. 

## Chapters

+ Foreword: '[Foreword](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/01_Foreword.asciidoc)'
+ Glossary: '[Glossary](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/02_Glossary.asciidoc)'
+ Introduction: '[Introduction](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/03_Introduction.asciidoc)'
+ Chapter 1: '[Post’s Machine conceptualization](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/Chapter_01.asciidoc)'
+ Chapter 2: '[Enhanced Post’s Machine (EPM) coding](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/Chapter_02.asciidoc)'
+ Chapter 3: '[EPM logical design](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/Chapter_03.asciidoc)'
+ Chapter 4: '[EPM prototype interface](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/Chapter_04.asciidoc)'
+ Chapter 5: '[Conclusions](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/blob/master/Chapter_05_Conclusions.asciidoc)'
+ Appendix: '[Practical realization of the EPM prototype](https://github.com/bitcoinbook/bitcoinbook/blob/master/I_Appendix.asciidoc)'
+ References: '[Bibliography](https://github.com/bitcoinbook/bitcoinbook/blob/master/II_References.asciidoc)'

# Published

"The Post’s Machine Reloaded: Design, Implementation and Programming of a Small and Functional CPU Prototype" is an translated English version of the original Spanish booklet, "La M&aacute;quina de Post actualizada", that I hope soon will be available in eBook format (Open Edition), for free under compatible CC BY-NC-SA license, at the publisher web page:

* [CopIt-arXives](http://scifunam.fisica.unam.mx/mir/copit/index.html)

The eBook "The Post’s Machine Reloaded", my own English translation from the Spanish Edition, I hope will be soon available, also for free under CC BY-NC-SA license, at the Academia.edu platform: https://www.academia.edu/

# Source

The booklet's source code, found in this repository, is kept synchronized with the referred eBook editions.

## The Post’s Machine Reloaded - Original Spanish Edition: La M&aacute;quina de Post actualizada (Dise&ntilde;o, puesta en marcha y programaci&oacute;n del prototipo de un peque&ntilde;o CPU funcional)

The tag [first_Spanish_edition](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/releases/tag/First_Spanish_Edition) correspond to the Spanish Edition of "The Post’s Machine Reloaded" as published by CopIt-arXives.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">La M&aacute;quina de Post actualizada - Spanish Edition</span> by Gerardo A. Laguna-Sanchez </a> is licensed under a compatible <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 International License</a>.

This "Free Culture" compliant license was adopted by my publisher CopIt-arXives (http://scifunam.fisica.unam.mx/mir/copit/index.html), who understands the value of open editions. Of course, CopIt-arXives is also a strong supporter of this open culture and the sharing of knowledge.

Thank you CopIt-arXives!

## The Post’s Machine Reloaded - Translated English Edition

The tag [first_English_edition](https://github.com/galaguna/Posts_Machine_Reloaded_Booklet/releases/tag/First_English_Edition) correspond to the English Edition of "The Post’s Machine Reloaded" as published by me.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">The Post’s Machine Reloaded - English Edition</span> by Gerardo A. Laguna-Sanchez </a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 International License</a>.

