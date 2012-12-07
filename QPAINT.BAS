DECLARE SUB endscreen ()
DECLARE SUB savecheck ()
DECLARE SUB noload ()
DECLARE SUB clearscreen ()
DECLARE SUB changecolor (change)
DECLARE SUB erasesub (change!, erasetype!)
DECLARE SUB getpic (ok)
DECLARE SUB linechoose (linetype!, change!)
DECLARE SUB loadsub (listbeg, scrolposy, scrolpos, gfxlistmax, change)
DECLARE SUB restoremenu ()
DECLARE SUB savesub ()
DECLARE SUB setup ()

KEY 15, CHR$(160) + "K"
KEY 16, CHR$(160) + "M"
KEY 17, CHR$(160) + "P"
KEY 18, CHR$(160) + "H"
KEY 19, CHR$(161) + "K"
KEY 20, CHR$(161) + "M"
KEY 21, CHR$(161) + "P"
KEY 22, CHR$(161) + "H"

ON KEY(1) GOSUB savefile
ON KEY(2) GOSUB loadfile
ON KEY(3) GOSUB getimage
ON KEY(15) GOSUB moveleft
ON KEY(16) GOSUB moveright
ON KEY(17) GOSUB movedown
ON KEY(18) GOSUB moveup
ON KEY(19) GOSUB drawleft
ON KEY(20) GOSUB drawright
ON KEY(21) GOSUB drawdown
ON KEY(22) GOSUB drawup

DIM SHARED coltabx, coltaby
DIM SHARED xpos, ypos
DIM SHARED col, under1, under2, under3
DIM SHARED cleartxt(1000)
DIM SHARED overflag

CONST false = 0, true = 1

SCREEN 13
setup

KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(15) ON
KEY(16) ON
KEY(17) ON
KEY(18) ON
KEY(19) ON
KEY(20) ON
KEY(21) ON
KEY(22) ON

LET xpos = 171
LET ypos = 2
LET under1 = 255
LET under2 = 255
LET under3 = 255
PSET (xpos, ypos), 0
PSET (xpos + 1, ypos), 0
PSET (xpos, ypos + 1), 0

LET col = 1
LET prevcol = 255
LINE (81, 184)-(151, 193), col, BF
LINE (81, 184)-(151, 193), 10, B

LET drawflag = true

DO
  
   LET keyb$ = INKEY$
  
   IF LCASE$(keyb$) = "c" THEN
      IF eraseflag = false THEN
         CALL changecolor(change)
         CALL restoremenu
      END IF
   END IF

   IF LCASE$(keyb$) = "e" THEN
      IF lineflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      LET lineflag = false
      LET drawflag = false
      IF eraseflag = false THEN LET prevcol = col
      LET col = 255
      LINE (81, 184)-(151, 193), col, BF
      LINE (81, 184)-(151, 193), 10, B
      CALL erasesub(change, erasetype)
      IF erasetype = 1 THEN
         IF eraseflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      END IF
      LET eraseflag = true
      CALL restoremenu
   END IF
  
   IF LCASE$(keyb$) = "d" THEN
      IF lineflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      IF eraseflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      IF eraseflag > 0 THEN
         LET col = prevcol
         LINE (81, 184)-(151, 193), col, BF
         LINE (81, 184)-(151, 193), 10, B
      END IF
      LET lineflag = false
      LET eraseflag = false
      LET drawflag = true
      KEY(19) ON
      KEY(20) ON
      KEY(21) ON
      KEY(22) ON
   END IF

   IF LCASE$(keyb$) = "l" THEN
      IF eraseflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      IF lineflag = false THEN LET lineflag = true
      LET drawflag = false
      IF eraseflag > 0 THEN
         LET col = prevcol
         LINE (81, 184)-(151, 193), col, BF
         LINE (81, 184)-(151, 193), 10, B
      END IF
      LET eraseflag = false
      KEY(19) OFF
      KEY(20) OFF
      KEY(21) OFF
      KEY(22) OFF
      CALL linechoose(linetype, change)
      CALL restoremenu
   END IF
  
   IF LCASE$(keyb$) = "p" THEN
      IF lineflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      IF eraseflag = 2 THEN PSET (lineunderx, lineundery), lineunder
      IF eraseflag > 0 THEN
         LET col = prevcol
         LINE (81, 184)-(151, 193), col, BF
         LINE (81, 184)-(151, 193), 10, B
      END IF
      LET lineflag = false
      LET eraseflag = false
      LET drawflag = false
      KEY(19) OFF
      KEY(20) OFF
      KEY(21) OFF
      KEY(22) OFF
   END IF
  
   IF lineflag > 0 THEN
      IF keyb$ = " " THEN
         LET lineflag = lineflag + 1
         IF lineflag = 2 THEN
            LET line1x = xpos
            LET line1y = ypos
            LET lineunder = under1
            LET lineunderx = xpos
            LET lineundery = ypos
            LET under1 = 0
         ELSEIF lineflag = 3 THEN
            LET line2x = xpos
            LET line2y = ypos
            IF linetype = 1 THEN LINE (line1x, line1y)-(line2x, line2y), col
            IF linetype = 2 THEN LINE (line1x, line1y)-(line2x, line2y), col, B
            IF linetype = 3 THEN LINE (line1x, line1y)-(line2x, line2y), col, BF
            LET lineflag = 1
            LET under1 = col
            IF linetype = 2 OR linetype = 3 THEN
               IF line1x > line2x THEN SWAP line1x, line2x
               IF line1y > line2y THEN SWAP line1y, line2y
               IF line1x = line2x THEN
                  IF ypos = line1y THEN LET under3 = col
               ELSEIF line1y = line2y THEN
                  IF xpos = line1x THEN LET under2 = col
               ELSE
                  IF xpos = line1x AND ypos = line1y THEN
                     LET under2 = col: LET under3 = col
                  ELSEIF xpos = line1x AND ypos = line2y THEN
                     LET under2 = col
                  ELSEIF ypos = line1y AND xpos = line2x THEN
                     LET under3 = col
                  END IF
               END IF
            END IF
            PSET (xpos, ypos), 0
         END IF
      END IF
   ELSEIF drawflag = true OR (eraseflag = true AND erasetype = 1) THEN
      IF keyb$ = " " THEN LET under1 = col
   ELSEIF eraseflag > 0 THEN
      IF keyb$ = " " THEN
         LET eraseflag = eraseflag + 1
         IF eraseflag = 2 THEN
            LET line1x = xpos
            LET line1y = ypos
            LET lineunder = under1
            LET lineunderx = xpos
            LET lineundery = ypos
            LET under1 = 0
         ELSEIF eraseflag = 3 THEN
            LET line2x = xpos
            LET line2y = ypos
            LINE (line1x, line1y)-(line2x, line2y), col, BF
            LET eraseflag = 1
            LET under1 = col
            IF line1x > line2x THEN SWAP line1x, line2x
            IF line1y > line2y THEN SWAP line1y, line2y
               IF line1x = line2x THEN
                  IF ypos = line1y THEN LET under3 = col
               ELSEIF line1y = line2y THEN
                  IF xpos = line1x THEN LET under2 = col
               ELSE
                  IF xpos = line1x AND ypos = line1y THEN
                     LET under2 = col: LET under3 = col
                  ELSEIF xpos = line1x AND ypos = line2y THEN
                     LET under2 = col
                  ELSEIF ypos = line1y AND xpos = line2x THEN
                     LET under3 = col
                  END IF
               END IF
            PSET (xpos, ypos), 0
         END IF
      END IF
   END IF
            
   IF keyb$ = CHR$(27) THEN
      CALL clearscreen
      IF lineflag > 0 THEN LET lineflag = 1
      IF eraseflag > 0 THEN LET eraseflag = 1
      LET under1 = 255
      LET under2 = 255
      LET under3 = 255
   END IF

LOOP UNTIL LCASE$(keyb$) = "q"

savecheck
endscreen
SYSTEM

REM **********************************************************************

moveleft:
IF xpos > 171 THEN
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET xpos = xpos - 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
END IF
RETURN

moveright:
IF xpos < 314 THEN
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET xpos = xpos + 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
END IF
RETURN

movedown:
IF ypos < 89 THEN
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET ypos = ypos + 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
END IF
RETURN

moveup:
IF ypos > 2 THEN
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET ypos = ypos - 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
END IF
RETURN

colorleft:
   IF coltabx > 0 THEN
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 7, B
      LET coltabx = coltabx - 8
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 0, B
      LET col = col - 1
      LINE (81, 184)-(151, 193), col, BF
      LINE (81, 184)-(151, 193), 10, B
      LET change = true
   END IF
RETURN

colorright:
   IF coltabx < 112 THEN
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 7, B
      LET coltabx = coltabx + 8
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 0, B
      LET col = col + 1
      LINE (81, 184)-(151, 193), col, BF
      LINE (81, 184)-(151, 193), 10, B
      LET change = true
   END IF
RETURN

colorup:
   IF coltaby > 0 THEN
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 7, B
      LET coltaby = coltaby - 8
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 0, B
      LET col = col - 15
      LINE (81, 184)-(151, 193), col, BF
      LINE (81, 184)-(151, 193), 10, B
      LET change = true
   END IF
RETURN

colordown:
   IF coltaby < 128 THEN
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 7, B
      LET coltaby = coltaby + 8
      LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 0, B
      LET col = col + 15
      LINE (81, 184)-(151, 193), col, BF
      LINE (81, 184)-(151, 193), 10, B
      LET change = true
   END IF
RETURN

drawleft:
IF xpos > 171 THEN
   LET under1 = col
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET xpos = xpos - 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
   LET under1 = col
END IF
RETURN

drawright:
IF xpos < 314 THEN
   LET under1 = col
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET xpos = xpos + 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
   LET under1 = col
END IF
RETURN

drawdown:
IF ypos < 89 THEN
   LET under1 = col
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET ypos = ypos + 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
   LET under1 = col
END IF
RETURN

drawup:
IF ypos > 2 THEN
   LET under1 = col
   PSET (xpos, ypos), under1
   PSET (xpos + 1, ypos), under2
   PSET (xpos, ypos + 1), under3
   LET ypos = ypos - 1
   LET under1 = POINT(xpos, ypos)
   LET under2 = POINT(xpos + 1, ypos)
   LET under3 = POINT(xpos, ypos + 1)
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
   LET under1 = col
END IF
RETURN

lineup:
IF linetype > 1 THEN LET linetype = linetype - 1
LET change = true
RETURN

linedown:
IF linetype < 3 THEN LET linetype = linetype + 1
LET change = true
RETURN

eraserleft:
LET change = true
LET erasetype = 1
RETURN

eraserright:
LET change = true
LET erasetype = 2
RETURN

getimage:
IF lineflag = 2 THEN PSET (lineunderx, lineundery), lineunder
IF eraseflag = 2 THEN PSET (lineunderx, lineundery), lineunder
CALL getpic(ok)
RETURN

picmenul: LET ok = 1: RETURN
picmenur: LET ok = 2: RETURN

filecheckF3:
LET overflag = false
RESUME NEXT
'53

scrolup:
   IF scrolposy > 135 THEN
      LINE (182, scrolposy)-(291, scrolposy + 8), 0, B
      LET scrolpos = scrolpos - 1
      LET scrolposy = scrolposy - 8
      LET change = true
   ELSEIF listbeg > 1 THEN
      LET listbeg = listbeg - 1
      LET change = true
   END IF
RETURN

scroldown:
   IF scrolposy < 175 AND scrolpos < gfxlistmax - 1 THEN
      LINE (182, scrolposy)-(291, scrolposy + 8), 0, B
      LET scrolpos = scrolpos + 1
      LET scrolposy = scrolposy + 8
      LET change = true
   ELSEIF listbeg + 6 < gfxlistmax THEN
      LET listbeg = listbeg + 1
      LET change = true
   END IF
RETURN

loadfile:
CALL loadsub(listbeg, scrolposy, scrolpos, gfxlistmax, change)
RETURN

savefile:
CALL savesub
RETURN

SUB changecolor (change)

ON KEY(15) GOSUB colorleft
ON KEY(16) GOSUB colorright
ON KEY(17) GOSUB colordown
ON KEY(18) GOSUB colorup
KEY(1) OFF
KEY(2) OFF
KEY(3) OFF
KEY(15) OFF
KEY(16) OFF
KEY(17) OFF
KEY(18) OFF
KEY(19) OFF
KEY(20) OFF
KEY(21) OFF
KEY(22) OFF

LET change = false

LINE (175, 112)-(309, 102), 10, B
LINE (171, 113)-(314, 196), 0, BF

LET y = 9
FOR x = 10 TO 130
   LET y = y + 1
   LINE (177, 114)-(177 + x, 114 + y), 0, BF
   LINE (177, 114)-(177 + x, 114 + y), 10, B
   IF y > 60 THEN LET y = 60
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT

LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 0, B

LINE (185, 150)-(260, 164), col, BF
LINE (185, 150)-(260, 164), 10, B

LINE (185, 132)-(260, 146), 10, B

KEY(15) ON
KEY(16) ON
KEY(17) ON
KEY(18) ON

DO
   LOCATE 16, 24
   PRINT "Current Color:";
   LOCATE 18, 26
   IF col MOD 15 <> 0 THEN
      PRINT RIGHT$(STR$(col MOD 15), LEN(STR$(col MOD 15)) - 1);
   ELSE
      PRINT "15";
   END IF
   IF col MOD 15 = 0 THEN
      PRINT ","; RIGHT$(STR$(INT(col / 15)), LEN(STR$(INT(col / 15))) - 1); "  "
   ELSE
      PRINT ","; RIGHT$(STR$(INT(col / 15) + 1), LEN(STR$(INT(col / 15 + 1))) - 1); "  "
   END IF

   IF change = true THEN
      LINE (185, 150)-(260, 164), col, BF
      LINE (185, 150)-(260, 164), 10, B
      LET change = false
   END IF

LOOP WHILE INKEY$ <> CHR$(13)

LINE (8 + coltabx, 8 + coltaby)-(8 + coltabx + 8, 8 + coltaby + 8), 7, B

ON KEY(15) GOSUB moveleft
ON KEY(16) GOSUB moveright
ON KEY(17) GOSUB movedown
ON KEY(18) GOSUB moveup
KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(19) ON
KEY(20) ON
KEY(21) ON
KEY(22) ON

END SUB

SUB clearscreen
   LINE (171, 2)-(314, 89), 255, BF
   LET xpos = 171
   LET ypos = 2
   PSET (xpos, ypos), 0
   PSET (xpos + 1, ypos), 0
   PSET (xpos, ypos + 1), 0
END SUB

SUB endscreen
DIM temp(2000)

LINE (80, 50)-(220, 150), 7, BF
LINE (80, 50)-(220, 150), 10, B
LINE (81, 150)-(220, 150), 120
LINE (220, 51)-(220, 150), 120
LINE (94, 52)-(200, 90), 0, BF
LOCATE 9, 13
PRINT " Qpaint V.90 "
LOCATE 10, 13
PRINT " ----------- "
GET (94, 62)-(200, 80), temp
LINE (81, 51)-(219, 149), 7, BF
LINE (97, 57)-(203, 85), 0, BF
PUT (97, 62), temp, PSET
LINE (97, 57)-(203, 85), 10, B
LINE (98, 85)-(203, 85), 120
LINE (203, 58)-(203, 85), 120
END SUB

SUB erasesub (change, erasetype)
DIM txt(1000)

KEY(1) OFF
KEY(2) OFF
KEY(3) OFF
KEY(15) OFF
KEY(16) OFF
KEY(17) OFF
KEY(18) OFF
KEY(19) OFF
KEY(20) OFF
KEY(21) OFF
KEY(22) OFF

ON KEY(15) GOSUB eraserleft
ON KEY(16) GOSUB eraserright

LET erasetype = 1
LET change = true

LINE (175, 128)-(309, 118), 10, B
GET (175, 128)-(309, 118), txt
LINE (171, 101)-(314, 196), 0, BF

LET x = 118
DO UNTIL x = 102
   LINE (171, 101)-(314, 196), 0, BF
   PUT (175, x), txt, PSET
   LET x = x - 1
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
LOOP

LET y = 9
FOR x = 10 TO 130
   LET y = y + 1
   LINE (177, 116)-(177 + x, 116 + y), 0, BF
   LINE (177, 116)-(177 + x, 116 + y), 10, B
   IF y > 56 THEN LET y = 56
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT

LOCATE 16, 24
PRINT "Choose Eraser:"

LINE (200, 143)-(220, 153), 7, BF
LINE (200, 143)-(220, 153), 6, B

dot = 1

FOR x = 0 TO 20
   IF dot = 3 THEN
      PSET (260 + x, 143), 0
      PSET (280 - x, 153), 0
   ELSE
      PSET (260 + x, 143), 7
      PSET (280 - x, 153), 7
   END IF
   IF dot = 4 THEN LET dot = 1
   dot = dot + 1
NEXT

FOR x = 0 TO 10
   IF dot = 3 THEN
      PSET (260, 143 + x), 0
      PSET (280, 153 - x), 0
   ELSE
      PSET (260, 143 + x), 7
      PSET (280, 153 - x), 7
   END IF
   IF dot = 4 THEN LET dot = 1
   dot = dot + 1
NEXT

KEY(15) ON
KEY(16) ON

DO
   IF change = true THEN
      IF erasetype = 1 THEN
         LINE (195, 138)-(225, 158), 15, B
         LINE (255, 138)-(285, 158), 0, B
      ELSE
         LINE (195, 138)-(225, 158), 0, B
         LINE (255, 138)-(285, 158), 15, B
      END IF
      LET change = false
   END IF
LOOP UNTIL INKEY$ = CHR$(13)

ON KEY(15) GOSUB moveleft
ON KEY(16) GOSUB moveright

KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(17) ON
KEY(18) ON

IF erasetype = 1 THEN
   KEY(19) ON
   KEY(20) ON
   KEY(21) ON
   KEY(22) ON
END IF

END SUB

SUB getpic (ok)

KEY(1) OFF
KEY(2) OFF
KEY(3) OFF
KEY(15) OFF
KEY(16) OFF
KEY(17) OFF
KEY(18) OFF
KEY(19) OFF
KEY(20) OFF
KEY(21) OFF
KEY(22) OFF

ON ERROR GOTO filecheckF3
LET overflag = true

DIM txt(1000)
DIM text$(1 TO 8)

LET ok = 1

LET text$(1) = "P": LET text$(2) = "R": LET text$(3) = "E"
LET text$(4) = "V": LET text$(5) = "I": LET text$(6) = "E"
LET text$(7) = "W"

LINE (175, 158)-(309, 168), 10, B
GET (175, 158)-(309, 168), txt
LINE (171, 101)-(314, 196), 0, BF

LET x = 158

DO UNTIL x = 102
   LINE (171, 101)-(314, 196), 0, BF
   PUT (175, x), txt, PSET
   LET x = x - 1
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
LOOP

LET y = 9
FOR x = 10 TO 130
   LET y = y + 1
   LINE (177, 116)-(177 + x, 116 + y), 0, BF
   LINE (177, 116)-(177 + x, 116 + y), 10, B
   IF y > 70 THEN LET y = 70
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT

LOCATE 17, 24
PRINT "Select"
LOCATE 18, 24
PRINT "Coordinates"
LOCATE 20, 24
PRINT "(100 X 80 MAX)"

LINE (180, 118)-(304, 166), 10, B

LOCATE 23, 24
PRINT "(ESC) to cancel"
LINE (180, 184)-(304, 174), 10, B

KEY(15) ON
KEY(16) ON
KEY(17) ON
KEY(18) ON

LET coord = 1

DO
LET keyb$ = INKEY$
IF keyb$ = " " THEN
   IF coord < 2 THEN
      LET coord = coord + 1
   ELSE
      IF xpos <> line1x AND ypos <> line1y THEN
         LET coord = coord + 1
      ELSE
         GOTO nopress
      END IF
   END IF
   IF coord = 2 THEN
      LET line1x = xpos
      LET line1y = ypos
      LET lineunder = under1
      LET under1 = 0
   ELSEIF coord = 3 THEN
      LET line2x = xpos
      LET line2y = ypos
      PSET (line1x, line1y), lineunder
      PSET (xpos, ypos), under1
      PSET (xpos + 1, ypos), under2
      PSET (xpos, ypos + 1), under3
      IF line1x > line2x THEN SWAP line1x, line2x
      IF line1y > line2y THEN SWAP line1y, line2y
     
      LET xlength = line2x - line1x + 1
      LET ylength = line2y - line1y + 1
      LET arraylength = xlength * ylength
      LET arraylength = arraylength + 4

      DIM image(arraylength)
      GET (line1x, line1y)-(line2x, line2y), image
      LINE (171, 101)-(314, 196), 0, BF
      PUT (171, 101), image
      PSET (xpos, ypos), 0
      PSET (xpos + 1, ypos), 0
      PSET (xpos, ypos + 1), 0
   END IF
END IF

nopress:
IF coord > 1 THEN
   IF ABS(xpos - line1x) > 98 THEN
      IF SGN(xpos - line1x) = -1 THEN
         KEY(15) OFF
      ELSE
         KEY(16) OFF
      END IF
   ELSE
      KEY(15) ON
      KEY(16) ON
   END IF
   IF ABS(ypos - line1y) > 78 THEN
      IF SGN(ypos - line1y) = -1 THEN
         KEY(18) OFF
      ELSE
         KEY(17) OFF
      END IF
   ELSE
      KEY(17) ON
      KEY(18) ON
   END IF
END IF
LOOP UNTIL coord = 3 OR keyb$ = CHR$(27)

KEY(15) OFF
KEY(16) OFF
KEY(17) OFF
KEY(18) OFF

IF coord = 3 THEN
  
   ON KEY(15) GOSUB picmenul
   ON KEY(16) GOSUB picmenur
  
   LINE (170, 100)-(271, 181), 10, B
   FOR x = 1 TO 7
      LOCATE 14 + x, 37
      PRINT text$(x)
   NEXT
   LINE (280, 108)-(302, 170), 10, B
  
   LOCATE 23, 36
   PRINT "OK!"
   LINE (275, 173)-(307, 184), 10, B
   GET (275, 173)-(307, 184), txt
   LET y = 0
   DO
      LINE (275, 173)-(307, 195), 0, BF
      LET y = y + 1
      PUT (275, 173 + y), txt, PSET
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   LOOP UNTIL y = 11
   LET x = 275
   DO
      LINE (180, 184)-(307, 195), 0, BF
      LET x = x - 1
      PUT (x, 184), txt, PSET
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   LOOP UNTIL x = 185
  
   LOCATE 23, 36
   PRINT "NO!"
   LINE (275, 173)-(307, 184), 10, B
   GET (275, 173)-(307, 184), txt
   LET y = 0
   DO
      LINE (275, 173)-(307, 195), 0, BF
      LET y = y + 1
      PUT (275, 173 + y), txt, PSET
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   LOOP UNTIL y = 11
   LET x = 275
   DO
      LINE (225, 184)-(307, 195), 0, BF
      LET x = x - 1
      PUT (x, 184), txt, PSET
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   LOOP UNTIL x = 225
  
   FOR x = 1 TO 20
      LINE (291, 170)-(291, 170 + x), 10
      FOR i = 1 TO 750: NEXT
   NEXT
   FOR x = 1 TO 34
      LINE (291, 190)-(291 - x, 190), 10
      FOR i = 1 TO 750: NEXT
   NEXT
   FOR x = 1 TO 8
      LINE (225, 190)-(225 - x, 190), 10
      FOR i = 1 TO 750: NEXT
   NEXT
  
   KEY(15) ON
   KEY(16) ON
  
   DO
   IF ok = 1 THEN
      PAINT (186, 185), 7, 10
      PAINT (226, 185), 8, 10
      PAINT (192, 189), 7, 10     '(O)k
      PAINT (241, 189), 8, 10     'n(O)
   ELSEIF ok = 2 THEN
      PAINT (186, 185), 8, 10
      PAINT (226, 185), 7, 10
      PAINT (192, 189), 8, 10     '(O)k
      PAINT (241, 189), 7, 10     'n(O)
   END IF
   LOOP UNTIL INKEY$ = CHR$(13)
  
   ON KEY(15) GOSUB moveleft
   ON KEY(16) GOSUB moveright
   IF ok = 1 THEN
      FOR x = 1 TO 97
         LINE (170, 100)-(315, 100 + x), 0, BF
         LINE (170, 100)-(315, 100 + x), 10, B
         IF x / 2 = INT(x / 2) THEN
            WAIT &H3DA, 8
            WAIT &H3DA, 8, 8
         END IF
      NEXT
     
      LOCATE 14, 24
      PRINT "Dir: C:\qpaint\"
      LINE (175, 113)-(309, 102), 10, B
      LOCATE 17, 25
      PRINT "File Name:"
      LINE (180, 137)-(289, 126), 10, B
      LOCATE 19, 26
      PRINT "--------"
      LINE (180, 153)-(289, 142), 10, B
      LOCATE 21, 27
      PRINT ".gfx"
      LINE (205, 169)-(250, 158), 10, B
    
      FOR x = 1 TO 5
         LINE (300, 113)-(300, 113 + x), 10
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 125
         LINE (300, 118)-(300 - x, 118), 10
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 13
         LINE (175, 118)-(175, 118 + x), 10
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 5
         LINE (175, 131)-(175 + x, 131), 10
         FOR i = 1 TO 500: NEXT
      NEXT

      FOR x = 1 TO 11
         LINE (289, 131)-(289 + x, 131), 10
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 16
         LINE (300, 131)-(300, 131 + x), 10
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 11
         LINE (300, 147)-(300 - x, 147), 10
         FOR i = 1 TO 500: NEXT
      NEXT

      LET name$ = ""
      DO
         LET temp$ = INPUT$(1)
         LET temp$ = UCASE$(temp$)
         IF (ASC(temp$) >= 48 AND ASC(temp$) <= 57) OR (ASC(temp$) >= 65 AND ASC(temp$) <= 90) THEN
            IF LEN(name$) < 8 THEN
               LET name$ = name$ + temp$
               LOCATE 19, 26
               PRINT SPC(8);
               LOCATE 19, 26
               PRINT name$
            END IF
         ELSEIF temp$ = CHR$(8) AND LEN(name$) > 0 THEN
            LET name$ = LEFT$(name$, LEN(name$) - 1)
            LOCATE 19, 26
            PRINT SPC(8);
            LOCATE 19, 26
            PRINT name$
         END IF
      LOOP UNTIL temp$ = CHR$(13) AND LEN(name$) > 0
    
      FOR x = 1 TO 7
         LINE (180, 147)-(180 - x, 147)
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 16
         LINE (173, 147)-(173, 147 + x)
         FOR i = 1 TO 500: NEXT
      NEXT
      FOR x = 1 TO 32
         LINE (173, 163)-(173 + x, 163)
         FOR i = 1 TO 500: NEXT
      NEXT
    
      LET address$ = "c:\qpaint\" + name$ + ".gfx"
      OPEN address$ FOR INPUT AS 1
         INPUT #1, a
      CLOSE
    
      IF overflag = true THEN
         LOCATE 23, 24
         PRINT "Overwrite? Y/N"
         LINE (175, 185)-(309, 174), 10, B
       
         FOR x = 1 TO 15
            LINE (250, 163)-(250 + x, 163), 10
            FOR i = 1 TO 1250: NEXT
         NEXT
         FOR x = 1 TO 11
            LINE (265, 163)-(265, 163 + x), 10
            FOR i = 1 TO 1250: NEXT
         NEXT
       
         LET cont$ = ""
         DO UNTIL LCASE$(cont$) = "n" OR LCASE$(cont$) = "y"
            LET cont$ = INPUT$(1)
         LOOP
       
         IF LCASE$(cont$) = "n" THEN GOTO dontoverwrite
       
         LET x = 175
         DO UNTIL x = 309
            LET x = x + 1
            LINE (175, 185)-(x, 174), 0, BF
            LINE (x, 185)-(x, 174), 10
            LINE (175, 185)-(309, 174), 10, B
            WAIT &H3DA, 8
            WAIT &H3DA, 8, 8
         LOOP
       
         LOCATE 23, 25
         PRINT "Save Complete"
         LINE (175, 185)-(309, 174), 10, B
         SLEEP 2

         GOTO contsave
      ELSE
      
      LOCATE 23, 25
      PRINT "Save Complete"
      LINE (175, 185)-(309, 174), 10, B
   
      FOR x = 1 TO 15
         LINE (250, 163)-(250 + x, 163), 10
         FOR i = 1 TO 1250: NEXT
      NEXT
      FOR x = 1 TO 11
         LINE (265, 163)-(265, 163 + x), 10
         FOR i = 1 TO 1250: NEXT
      NEXT
      SLEEP 2

contsave:
      DEF SEG = VARSEG(image(0))
      BSAVE address$, 0, arraylength
      DEF SEG
     
      FOR x = 1 TO 97
         LINE (170, 100)-(315, 100 + x), 0, BF
         LINE (170, 100)-(315, 100 + x), 10, B
         IF x / 2 = INT(x / 2) THEN
            WAIT &H3DA, 8
            WAIT &H3DA, 8, 8
         END IF
      NEXT
  
      LET text$(1) = "I": LET text$(2) = "M": LET text$(3) = "G"
      LET text$(4) = " ": LET text$(5) = "D": LET text$(6) = "A"
      LET text$(7) = "T": LET text$(8) = "A"
     
      LOCATE 15, 24
      PRINT "File: "
      LOCATE 17, 24
      PRINT name$; ".gfx"
      LOCATE 19, 24
      PRINT "Array Size:"
      LOCATE 21, 24
      PRINT RIGHT$(STR$(arraylength), LEN(STR$(arraylength)) - 1)
      LOCATE 23, 24
      PRINT "256 Colors"
      LINE (180, 121)-(289, 110), 10, B
      LINE (180, 137)-(289, 126), 10, B
      LINE (180, 153)-(289, 142), 10, B
      LINE (180, 169)-(289, 158), 10, B
      LINE (180, 185)-(289, 174), 10, B
     
      LINE (296, 108)-(317, 178), 0, BF
      FOR x = 1 TO 8
         LOCATE 14 + x, 39
         PRINT text$(x)
      NEXT
      LINE (296, 108)-(317, 178), 10, B
     
      LINE (289, 115)-(296, 115), 10
      LINE (180, 115)-(175, 115), 10
      LINE (175, 115)-(175, 131), 10
      LINE (175, 131)-(180, 131), 10
      LINE (289, 131)-(296, 131), 10
      LINE (296, 147)-(289, 147), 10
      LINE (180, 147)-(175, 147), 10
      LINE (175, 147)-(175, 163), 10
      LINE (175, 163)-(180, 163), 10
      LINE (289, 163)-(296, 163), 10
      LINE (306, 178)-(306, 180), 10
      LINE (289, 180)-(306, 180), 10
     
      LET cont$ = INPUT$(1)
     
      FOR x = 1 TO 97
         LINE (170, 100)-(315, 100 + x), 0, BF
         LINE (316, 100)-(317, 100 + x), 7, BF
         LINE (170, 100)-(315, 100 + x), 10, B
         IF x / 2 = INT(x / 2) THEN
            WAIT &H3DA, 8
            WAIT &H3DA, 8, 8
         END IF
      NEXT

      LOCATE 14, 23
      PRINT "(C)-Change Color"
      LOCATE 15, 23
      PRINT "(D)-Draw"
      LOCATE 16, 23
      PRINT "(E)-Erase"
      LOCATE 17, 23
      PRINT "(L)-Line"
      LOCATE 18, 23
      PRINT "(Q)-Quit"
      LOCATE 19, 23
      PRINT "(F1)-Save"
      LOCATE 20, 23
      PRINT "(F2)-Load"
      LOCATE 21, 23
      PRINT "(F3)-Capture"
      LOCATE 22, 23
      PRINT "(F4)-Export"
      LOCATE 23, 23
      PRINT "(TAB)-Custom"
      PUT (176, 184), cleartxt
      END IF
   END IF
ELSE
   IF coord = 2 THEN PSET (line1x, line1y), lineunder
   CALL restoremenu
END IF

dontoverwrite:
IF cont$ = "n" OR ok = 2 THEN CALL restoremenu

KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(15) ON
KEY(16) ON
KEY(17) ON
KEY(18) ON
KEY(19) ON
KEY(20) ON
KEY(21) ON
KEY(22) ON
CLOSE

END SUB

SUB linechoose (linetype, change)

DIM txt(1000)
KEY(1) OFF
KEY(2) OFF
KEY(3) OFF
KEY(15) OFF
KEY(16) OFF
ON KEY(17) GOSUB linedown
ON KEY(18) GOSUB lineup

LET linetype = 1
LET change = false

LINE (175, 136)-(309, 126), 10, B
GET (175, 136)-(309, 126), txt
LINE (171, 101)-(314, 196), 0, BF

LET x = 126

DO UNTIL x = 102
   LINE (171, 101)-(314, 196), 0, BF
   PUT (175, x), txt, PSET
   LET x = x - 1
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
LOOP

LET y = 9
FOR x = 10 TO 110
   LET y = y + 1
   LINE (177, 116)-(177 + x, 116 + y), 0, BF
   LINE (177, 116)-(177 + x, 116 + y), 10, B
   IF y > 46 THEN LET y = 46
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT


LINE (187, 121)-(275, 131), 7, B

LINE (190, 126)-(272, 126), 10
LINE (190, 138)-(272, 142), 10, B
LINE (190, 152)-(272, 156), 10, BF

DO
IF change = true THEN
   LET change = false
   IF linetype = 1 THEN
      LINE (187, 121)-(275, 131), 7, B
      LINE (187, 135)-(275, 145), 0, B
      LINE (187, 149)-(275, 159), 0, B
   ELSEIF linetype = 2 THEN
      LINE (187, 121)-(275, 131), 0, B
      LINE (187, 135)-(275, 145), 7, B
      LINE (187, 149)-(275, 159), 0, B
   ELSEIF linetype = 3 THEN
      LINE (187, 121)-(275, 131), 0, B
      LINE (187, 135)-(275, 145), 0, B
      LINE (187, 149)-(275, 159), 7, B
   END IF
END IF
LOOP UNTIL INKEY$ = CHR$(13)

KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(15) ON
KEY(16) ON
ON KEY(17) GOSUB movedown
ON KEY(18) GOSUB moveup

END SUB

SUB loadsub (listbeg, scrolposy, scrolpos, gfxlistmax, change)

KEY(1) OFF
KEY(2) OFF
KEY(3) OFF
KEY(15) OFF
KEY(16) OFF
KEY(17) ON
KEY(18) ON
KEY(19) OFF
KEY(20) OFF
KEY(21) OFF
KEY(22) OFF

DIM txt(1000)

LINE (175, 150)-(309, 160), 10, B
GET (175, 150)-(309, 160), txt
LINE (171, 101)-(314, 196), 0, BF

LET x = 150

DO UNTIL x = 102
   LINE (171, 101)-(314, 196), 0, BF
   PUT (175, x), txt, PSET
   LET x = x - 1
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
LOOP

LET y = 9
FOR x = 10 TO 131
   LET y = y + 1
   LINE (177, 116)-(177 + x, 116 + y), 0, BF
   LINE (177, 116)-(177 + x, 116 + y), 10, B
   IF y > 72 THEN LET y = 72
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT

ON KEY(17) GOSUB scroldown
ON KEY(18) GOSUB scrolup

DIM savefile(13140)
DIM gfxlist$(0 TO 640)

LET listbeg = 1
LET scrolpos = 1
LET scrolposy = 135

SHELL "dir c:\qpaint > c:\qpaint\dir.tem"
OPEN "c:\qpaint\dir.tem" FOR INPUT AS #1
file$ = INPUT$(LOF(1), 1)

FOR x = 1 TO LOF(1)
   temp$ = MID$(file$, x, 4)
   IF temp$ = " PIC" THEN
      gfxlist = gfxlist + 1
      gfxlist$(gfxlist) = MID$(file$, x - 8, 12)
   END IF
NEXT x

FOR x = 1 TO 640
   IF gfxlist$(x) = "" THEN
      gfxlistmax = x
      x = 640
   END IF
NEXT x
IF gfxlistmax = 0 THEN CALL noload: GOTO endsub

FOR z = 1 TO gfxlistmax
   FOR a = 1 TO gfxlistmax - 1 - z
      IF gfxlist$(a) > gfxlist$(a + 1) THEN
         SWAP gfxlist$(a), gfxlist$(a + 1)
      END IF
   NEXT
NEXT

LOCATE 16, 25
PRINT "ESC - Cancel"
GET (190, 120)-(294, 126), txt
LINE (190, 120)-(294, 126), 0, BF

PUT (181, 122), txt

LINE (180, 133)-(305, 187), 10, B
LINE (293, 133)-(293, 187), 10
LINE (293, 142)-(305, 178), 10, B

LINE (296, 139)-(302, 139), 10
LINE (296, 139)-(299, 136), 10
LINE (302, 139)-(299, 136), 10
PAINT (299, 137), 10, 10
LINE (296, 181)-(302, 181), 10
LINE (296, 181)-(299, 184), 10
LINE (302, 181)-(299, 184), 10
PAINT (299, 183), 10, 10

LET tabdown = 18
FOR x = listbeg TO listbeg + 5
   LOCATE tabdown, 24
   PRINT gfxlist$(x)
   LET tabdown = tabdown + 1
NEXT x
LINE (182, scrolposy)-(291, scrolposy + 8), 1, B

DO
   LET keyb$ = INKEY$
   IF change = true THEN LET change = false: GOSUB restoremenu
LOOP UNTIL keyb$ = CHR$(13) OR keyb$ = CHR$(27)
IF keyb$ = CHR$(27) THEN GOTO endsub

LET file$ = gfxlist$(listbeg + scrolpos - 1)
LET file1$ = LEFT$(file$, INSTR(file$, " ") - 1)
LET file2$ = RIGHT$(file$, 3)
LET file$ = "c:\qpaint\" + file1$ + "." + file2$

DEF SEG = VARSEG(savefile(0))
BLOAD file$, 0
DEF SEG

PUT (171, 2), savefile, PSET
GOTO endsub

restoremenu:
   LET tabdown = 18
   FOR x = listbeg TO listbeg + 5
      LOCATE tabdown, 24
      PRINT gfxlist$(x)
      LET tabdown = tabdown + 1
   NEXT x
   LINE (182, scrolposy)-(291, scrolposy + 8), 1, B
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
RETURN

endsub:
CLOSE

KILL "c:\qpaint\dir.tem"

CALL restoremenu

ON KEY(17) GOSUB movedown
ON KEY(18) GOSUB moveup

KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(15) ON
KEY(16) ON
KEY(17) ON
KEY(18) ON
KEY(19) ON
KEY(20) ON
KEY(21) ON
KEY(22) ON

PSET (xpos, ypos), 0
PSET (xpos + 1, ypos), 0
PSET (xpos, ypos + 1), 0

END SUB

SUB noload

LOCATE 19, 26
PRINT "No File to"
LOCATE 20, 29
PRINT "Load"
LINE (190, 137)-(289, 166), 10, B
SLEEP 5

END SUB

SUB restoremenu

FOR x = 1 TO 97
   LINE (170, 100)-(315, 100 + x), 0, BF
   LINE (170, 100)-(315, 100 + x), 10, B
   IF x / 2 = INT(x / 2) THEN
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   END IF
NEXT

LOCATE 14, 23
PRINT "(C)-Change Color"
LOCATE 15, 23
PRINT "(D)-Draw"
LOCATE 16, 23
PRINT "(E)-Erase"
LOCATE 17, 23
PRINT "(L)-Line"
LOCATE 18, 23
PRINT "(Q)-Quit"
LOCATE 19, 23
PRINT "(F1)-Save"
LOCATE 20, 23
PRINT "(F2)-Load"
LOCATE 21, 23
PRINT "(F3)-Capture"
LOCATE 22, 23
PRINT "(F4)-Export"
LOCATE 23, 23
PRINT "(TAB)-Custom"
PUT (176, 184), cleartxt

END SUB

SUB savecheck
DIM temp(2000)
DIM temp2(2000)

GET (170, 50)-(220, 90), temp2
LINE (80, 50)-(220, 150), 7, BF
LINE (80, 50)-(220, 150), 10, B
LINE (81, 150)-(220, 150), 120
LINE (220, 51)-(220, 150), 120
LINE (94, 52)-(200, 90), 0, BF
LOCATE 9, 13
PRINT " Save Before "
LOCATE 10, 13
PRINT "  Quitting?  "
GET (94, 62)-(200, 80), temp
LINE (81, 51)-(219, 149), 7, BF
LINE (97, 57)-(203, 85), 0, BF
PUT (97, 62), temp, PSET
LINE (97, 57)-(203, 85), 10, B
LINE (98, 85)-(203, 85), 120
LINE (203, 58)-(203, 85), 120


'IF choice = 2 THEN GOTO endit
'PUT (170, 50), temp2, PSET
'LINE (80, 50)-(220, 150), 7, BF
'LINE (80, 50)-(220, 150), 10, B
'LINE (81, 150)-(220, 150), 120
'LINE (220, 51)-(220, 150), 120
'LINE (94, 52)-(200, 90), 0, BF
'LOCATE 9, 13
'PRINT " Save Before "
'LOCATE 10, 13
'PRINT "  Quitting?  "
'GET (94, 62)-(200, 80), temp
'LINE (81, 51)-(219, 149), 7, BF
'LINE (97, 57)-(203, 85), 0, BF
'PUT (97, 62), temp, PSET
'LINE (97, 57)-(203, 85), 10, B
'LINE (98, 85)-(203, 85), 120
'LINE (203, 58)-(203, 85), 120

endit:
END SUB

SUB savesub

DIM savefile(13140)
PSET (xpos, ypos), under1
PSET (xpos + 1, ypos), under2
PSET (xpos, ypos + 1), under3
GET (171, 2)-(314, 89), savefile
PSET (xpos, ypos), 0
PSET (xpos + 1, ypos), 0
PSET (xpos, ypos + 1), 0

ON ERROR GOTO filecheckF3
LET overflag = true

KEY(1) OFF
KEY(2) OFF
KEY(3) OFF
KEY(15) OFF
KEY(16) OFF
KEY(17) OFF
KEY(18) OFF
KEY(19) OFF
KEY(20) OFF
KEY(21) OFF
KEY(22) OFF

DIM txt(1000)

LINE (175, 142)-(309, 152), 10, B
GET (175, 142)-(309, 152), txt
LINE (171, 101)-(314, 196), 0, BF

LET x = 142

DO UNTIL x = 102
   LINE (171, 101)-(314, 196), 0, BF
   PUT (175, x), txt, PSET
   LET x = x - 1
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
LOOP

LET y = 9
FOR x = 10 TO 130
   LET y = y + 1
   LINE (177, 116)-(177 + x, 116 + y), 0, BF
   LINE (177, 116)-(177 + x, 116 + y), 10, B
   IF y > 72 THEN LET y = 72
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT

LINE (193, 126)-(291, 136), 0, BF
LOCATE 17, 27
PRINT "Save File?"
GET (193, 126)-(291, 136), txt
LINE (193, 126)-(291, 136), 0, BF
PUT (186, 126), txt
LINE (190, 126)-(291, 136), 10, B
LOCATE 19, 29
PRINT "Y/N"
GET (210, 142)-(271, 152), txt
LINE (210, 142)-(271, 152), 0, BF
PUT (213, 142), txt
LINE (210, 142)-(271, 152), 10, B
LINE (240, 142)-(240, 136), 10

LET cont$ = ""
DO UNTIL LCASE$(cont$) = "y" OR LCASE$(cont$) = "n"
   LET cont$ = INPUT$(1)
LOOP
IF LCASE$(cont$) = "n" THEN GOTO endsave

FOR x = 1 TO 97
   LINE (170, 100)-(315, 100 + x), 0, BF
   LINE (170, 100)-(315, 100 + x), 10, B
   IF x / 2 = INT(x / 2) THEN
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   END IF
NEXT

LOCATE 14, 24
PRINT "Dir: C:\qpaint\"
LINE (175, 113)-(309, 102), 10, B
LOCATE 17, 25
PRINT "File Name:"
LINE (180, 137)-(289, 126), 10, B
LOCATE 19, 26
PRINT "--------"
LINE (180, 153)-(289, 142), 10, B
LOCATE 21, 27
PRINT ".pic"
LINE (205, 169)-(250, 158), 10, B
    
FOR x = 1 TO 5
   LINE (300, 113)-(300, 113 + x), 10
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 125
   LINE (300, 118)-(300 - x, 118), 10
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 13
   LINE (175, 118)-(175, 118 + x), 10
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 5
   LINE (175, 131)-(175 + x, 131), 10
   FOR i = 1 TO 500: NEXT
NEXT

FOR x = 1 TO 11
   LINE (289, 131)-(289 + x, 131), 10
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 16
   LINE (300, 131)-(300, 131 + x), 10
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 11
   LINE (300, 147)-(300 - x, 147), 10
   FOR i = 1 TO 500: NEXT
NEXT

LET name$ = ""
DO
   LET temp$ = INPUT$(1)
   LET temp$ = UCASE$(temp$)
   IF (ASC(temp$) >= 48 AND ASC(temp$) <= 57) OR (ASC(temp$) >= 65 AND ASC(temp$) <= 90) THEN
      IF LEN(name$) < 8 THEN
         LET name$ = name$ + temp$
         LOCATE 19, 26
         PRINT SPC(8);
         LOCATE 19, 26
         PRINT name$
      END IF
   ELSEIF temp$ = CHR$(8) AND LEN(name$) > 0 THEN
      LET name$ = LEFT$(name$, LEN(name$) - 1)
      LOCATE 19, 26
      PRINT SPC(8);
      LOCATE 19, 26
      PRINT name$
   END IF
LOOP UNTIL temp$ = CHR$(13) AND LEN(name$) > 0
     
FOR x = 1 TO 7
   LINE (180, 147)-(180 - x, 147)
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 16
   LINE (173, 147)-(173, 147 + x)
   FOR i = 1 TO 500: NEXT
NEXT
FOR x = 1 TO 32
   LINE (173, 163)-(173 + x, 163)
   FOR i = 1 TO 500: NEXT
NEXT
    
LET address$ = "c:\qpaint\" + name$ + ".pic"
OPEN address$ FOR INPUT AS 1
INPUT #1, a
CLOSE
    
IF overflag = true THEN
   LOCATE 23, 24
   PRINT "Overwrite? Y/N"
   LINE (175, 185)-(309, 174), 10, B
  
   FOR x = 1 TO 15
      LINE (250, 163)-(250 + x, 163), 10
      FOR i = 1 TO 1250: NEXT
   NEXT
   FOR x = 1 TO 11
      LINE (265, 163)-(265, 163 + x), 10
      FOR i = 1 TO 1250: NEXT
   NEXT
       
   LET cont$ = ""
   DO UNTIL LCASE$(cont$) = "n" OR LCASE$(cont$) = "y"
      LET cont$ = INPUT$(1)
   LOOP
       
   IF LCASE$(cont$) = "n" THEN GOTO endsave
       
   LET x = 175
   DO UNTIL x = 309
      LET x = x + 1
      LINE (175, 185)-(x, 174), 0, BF
      LINE (x, 185)-(x, 174), 10
      LINE (175, 185)-(309, 174), 10, B
      WAIT &H3DA, 8
      WAIT &H3DA, 8, 8
   LOOP
       
   LOCATE 23, 25
   PRINT "Save Complete"
   LINE (175, 185)-(309, 174), 10, B
   FOR i = 1 TO 2500: NEXT

   GOTO contsave1
ELSE
contsave1:
   DEF SEG = VARSEG(savefile(0))
   BSAVE address$, 0, 13140
   DEF SEG
    
   LOCATE 23, 25
   PRINT "Save Complete"
   LINE (175, 185)-(309, 174), 10, B
   
   FOR x = 1 TO 15
      LINE (250, 163)-(250 + x, 163), 10
      FOR i = 1 TO 1250: NEXT
   NEXT
   FOR x = 1 TO 11
      LINE (265, 163)-(265, 163 + x), 10
      FOR i = 1 TO 1250: NEXT
   NEXT
END IF

endsave:
CALL restoremenu

KEY(1) ON
KEY(2) ON
KEY(3) ON
KEY(15) ON
KEY(16) ON
KEY(17) ON
KEY(18) ON
KEY(19) ON
KEY(20) ON
KEY(21) ON
KEY(22) ON
CLOSE

PSET (xpos, ypos), 0
PSET (xpos + 1, ypos), 0
PSET (xpos, ypos + 1), 0

END SUB

SUB setup

DIM txt(1000)
COLOR 10

PRINT "Current:"
GET (0, 0)-(110, 7), txt
PRINT "(ESC)-Clear/New"
GET (0, 8)-(120, 15), cleartxt

CLS
PALETTE 0, 59 + (256 * 33) + (65535 * 35)

LINE (7, 7)-(129, 145), 10, B
LINE (1, 1)-(163, 176), 10, B
LINE (170, 1)-(315, 90), 10, B
LINE (170, 100)-(315, 197), 10, B
LINE (1, 180)-(163, 197), 10, B
PAINT (0, 0), 7, 10
PAINT (8, 8), 7, 10
PAINT (171, 2), 255, 10

PUT (10, 185), txt

LOCATE 14, 23
PRINT "(C)-Change Color"
LOCATE 15, 23
PRINT "(D)-Draw"
LOCATE 16, 23
PRINT "(E)-Erase"
LOCATE 17, 23
PRINT "(L)-Line"
LOCATE 18, 23
PRINT "(Q)-Quit"
LOCATE 19, 23
PRINT "(F1)-Save"
LOCATE 20, 23
PRINT "(F2)-Load"
LOCATE 21, 23
PRINT "(F3)-Capture"
LOCATE 22, 23
PRINT "(F4)-Export"
LOCATE 23, 23
PRINT "(TAB)-Custom"
PUT (176, 184), cleartxt

yd = 8
xd = 8
FOR T = 1 TO 17
   FOR y = yd + 1 TO yd + 7
      FOR col = cd + 1 TO cd + 15
         FOR x = xd + 1 TO xd + 7
            PSET (x, y), col
         NEXT
         xd = xd + 8
      NEXT
   xd = 8
   NEXT
   yd = yd + 8
   cd = cd + 15
   WAIT &H3DA, 8
   WAIT &H3DA, 8, 8
NEXT

FOR x = 2 TO 18
   LOCATE x, 19
   LINE (129, x * 8 - 4)-(135, x * 8 - 4), 10
   PRINT RIGHT$(STR$(x - 1), LEN(STR$(x - 1)) - 1)
NEXT

GET (143, 7)-(158, 145), txt
LINE (143, 7)-(158, 145), 0, BF
PUT (138, 7), txt

FOR x = 1 TO 15
   LOCATE 20, x + 1
   PRINT MID$(STR$(x), 2, 1)
   LINE (x * 8 + 4, 145)-(x * 8 + 4, 150), 10
NEXT
FOR x = 10 TO 15
   LOCATE 21, x + 1
   PRINT RIGHT$(STR$(x), 1)
NEXT

GET (7, 152)-(126, 167), txt
LINE (7, 152)-(126, 167), 0, BF
PUT (9, 153), txt

END SUB

