CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

{{

Propeller Quick Start Board                                                 

              74125       330Ω
     P0  ────────────────── NeoPixel DIN
      
  +5 In  ──────────┐
    GND  ───────┐  │
                 │  │
                 │  │
2A Wall Wart     │  │
                 │  │
     +5  ────────┼──┻─────────┳─ NeoPixel +5
                 │     1000µF  
    GND  ────────┻────────────┻─ NeoPixel GND

}}

CON
    PIN_NEO = 0

VAR
    long palBuf[4*256]
    byte pixBuf[144*4]

OBJ    
    
    NEOStrip : "NeoPixelStrip"
    PST      : "Parallax Serial Terminal"          
    
PUB Main | x,c

  ' Go ahead and drive the pixel plate data line low. The driver
  ' will too, but it might be a little while before it gets called.
  ' If we wait then the first pixel will show random data.
  dira[PIN_NEO] := 1
  outa[PIN_NEO] := 0
  
  NEOStrip.init
  repeat x from 0 to 144*4
    byte[@pixBuf+x] :=0
  NEOStrip.draw(1,@palBuf,@pixBuf,PIN_NEO, 144)

  PauseMSec(2_000) ' Time to activate terminal

  PST.start(115200)

  repeat
    c := PST.charIn      
    CASE c
      "X" :
        NEOStrip.draw(2,@datPalette, @datBuffer, PIN_NEO, 28)


     
PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)  

DAT

' 144 pixels

datPalette
 long $00_00_00_00
 long $00_00_00_10
 long $00_00_10_00
 long $00_10_00_00

datBuffer

 byte 0,1,2,3
 byte 0,1,2,3
 byte 0,0,1,1
 byte 2,2,3,3
 byte 1,1,1,1
 byte 2,2,2,2
 byte 3,3,3,3
              