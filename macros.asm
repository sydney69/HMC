MACRO MODE val
   lda #$16
   jsr oswrch
   lda #val
   jsr oswrch
ENDMACRO
 
MACRO lsr3
   ; shifts the accumulator left parameter 1 number of times
   lsr A
   lsr A
   lsr A
ENDMACRO
 
MACRO TIMES8 val1,val2
   ; multiply contents of param1 and add result to
   ; contents of param1 and param1+1
   ; uses 9F as scratchpad space
   ; A corrupted, param1 corrupted
   lda #0
   sta $9F    ; clear out hi part of result 
   clc
   asl val1
   rol $9F
   asl val1
   rol $9F
   asl val1
   rol $9F
   ; ok got result of multiplication, now add to param2 contents
   lda val1
   clc
   adc val2
   sta val2
   lda $9F
   adc val2+1
   sta val2+1
ENDMACRO