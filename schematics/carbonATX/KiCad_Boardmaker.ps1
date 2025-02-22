
$newline="`r`n"
#atx defines one hole as 0,0. Everything is relative to that hole.
$c1,$c2,$c3,$c4,$c5=0,58.42,78.74,124.46,281.940 #cols
$r1,$r2,$r3,$r4=0,22.86,154.94,227.33 #rows

$Holes=@($c1,$r1),($c2,$r1),($c3,$r1),($c4,$r1),       
                                                ($c5,$r2), #the pin behind the IO is always offset on its own row
        ($c1,$r3),($c2,$r3),($c3,$r3),($c4,$r3),($c5,$r3),
        ($c1,$r4),($c2,$r4),($c3,$r4),($c4,$r4),($c5,$r4)
#spacing above is aesthetic, but "aligned". Not all holes may exist in every board.

#edge offsets based on ATX
    $boardEdgeHoleoffsetY=10.16
    $boardEdgeHoleoffsetX=-16.51 

#offsets from the 0,0 hole. The board will have the "back" at the top, so y is the offset from the back of the board (but actually the hole).
    $slotwidth=20.32
    #isa $slot0centreline=132.08
   # $slot0centreline=146.375
    $slot0centreline=146.35

#pin1 offsets from 0,0
    $ISApin1offsetY=15.24
    $PCIpin1offsetY=31.12
    $AGPpin1offsetY=56.7
    $PCIEpin1offsetY=35.306 

#centreline offsets from OG isa slot centreline
#not reqd    $ISApin1offsetX=0
   # $PCIcentrelineoffsetX=14.2748
   # $AGPcentrelineoffsetX=14.2748
   # $PCIEcentrelineoffsetX=14.2748 
   $ISAcentreoffsetX=6.0452

#define sizes
#the datum is inconvenient here, easier to use the top-rear corner as the fixed point for all board edges.
#The ATX bottom corner is 0,0 -.65",-.4".
#in mm, -16.5,10.15. Therefore the top corner is -16.5+305mm,10.15 = 288.5,10.5
$PCBstartX,$PCBstartY=288.5,-10.5
$boardtypes=($null,$null,$null,$null),
            ("ATX",305,244,8),
            ("MicroAtx",244,244,5),
            ("FlexATX",229,191,4),
            ("MiniDTX",203,170,3),
            ("MiniITX",170,170,1) | ForEach {[pscustomobject]@{
                Size=$_[0]
                Width=$_[1]
                Length=$_[2]
                Slots=$_[3]
                }
            }
$slottypes=@("","1xPCIE","4xPCIE","8xPCIE","16xPCIE","3vAGP","1.5vAGP","UniversalAGP","5vPCI","3vPCI","16bISA","8bISA","Empty")


#defaultboard
$brdindex=1
#default slots
$slotno=@($slottypes[0],$slottypes[6],$slottypes[9],$slottypes[5],$slottypes[4],$slottypes[3],$slottypes[2],$slottypes[11],$slottypes[10]) #na because index=0 and I prefer 1


#
$kicadpcbheader='(kicad_pcb(version 20240108)(generator "pcbnew")(generator_version "8.0")(paper "A0" portrait)'+$newline
$kicadboardfooter='(stroke(width 0.2)(type default))(fill none)(layer "Edge.Cuts")))'+$newline #who knows? It might change


#hole
Function fboardhole {
    param ( [string[]]$hx, $hy )
    $locs=@("0"),("1"),("0 2.921"),("0 -2.921"),("2.921 0"),("-2.921 0"),("2.0828 2.0828"),("-2.0828 2.0828"),("2.0828 -2.0828"),("-2.0828 -2.0828")
    $fill1='" thru_hole circle (at '
    $fill2=') (size 0.6 0.6) (drill 0.5) (layers "*.Cu" "*.Mask")(remove_unused_layers no))'+$newline
    $bhole='(footprint "HOLE"(layer "F.Cu")(at ' +$hx+ ' ' +$hy+ ' 0)'+$newline
    $bhole+='  (pad "" thru_hole circle (at 0 0) (size 7 7) (drill 3.9624) (layers "*.Cu" "*.Mask")(remove_unused_layers no))'+$newline
    For ($i=2; $i -le 9; $i++){
        $bhole+='  (pad "' +$fill1+ $locs[$i]+ $fill2
    }
    $bhole+='  (fp_circle (center 0 0) (end 3.8 0)(stroke (width 0.05))(layer "F.CrtYd")))'+$newline
    return $bhole
}

Function fBuildSlot {
    param ( [string[]]$type, $slotx, $sloty )
    $rect="(fp_rect (start " , ") (end ", ')(fill none)(layer "F.CrtYd")))'+$newline
    $NPTH=$null
    if ($type -eq "empty") {
        return $null
    }
    switch ( $type) {
        "3vAGP" {
            $rows=@("A",1,0.991,0,11,31),("A",2,2.997,0.991,10,31),("B",1,-2.997,0,11,31),("B",2,-0.991,0.991,10,31) #row,pinno,x,y,skippin,pinsinrow
            $pinspace=1.981
            $skipspace=3.962
            $skipnums=4
            $rowpins=31 
            $PIncrement=2
            $border="-4.5 -5.08","4.5 69.464" # start xy, end xy
            $NPTH=@("0 -3.15",2),("0 22.504",2),("0 67.534",2) #mounting hole x,y,size
            $sloty=$AGPpin1offsety
        }
        "1.5vAGP" { 
            $rows=@("A",1,0.991,0,21,31),("A",2,2.997,0.991,20,31),("B",1,-2.997,0,21,31),("B",2,-0.991,0.991,20,31) #row,pinno,x,y,skippin,pinsinrow
            $pinspace=1.981
            $skipspace=3.962
            $skipnums=4
            $rowpins=31 
            $PIncrement=2
            $border="-4.5 -5.08","4.5 69.464" # start xy, end xy
            $NPTH=@("0 -3.15",2),("0 41.88",2),("0 67.534",2) #mounting hole x,y,size
            $sloty=$AGPpin1offsety
        }
        "UniversalAGP" { 
            $rows=@("A",1,0.991,0,11,33),("A",2,2.997,0.991,10,33),("B",1,-2.997,0,11,33),("B",2,-0.991,0.991,10,33) #row,pinno,x,y,skippin,pinsinrow
            $pinspace=1.981
            $skipspace=0
            $skipnums=0
            $rowpins=31 
            $PIncrement=2
            $border="-4.5 -5.08","4.5 69.464" # start xy, end xy
            $NPTH=@("0 -3.15",2),("0 67.534",2) #mounting hole x,y,size
            $sloty=$AGPpin1offsety
        }
        "3vPCI" { 
            $rows=@("A",1,3.81,0,6,30),("A",2,1.27,1.27,5,30),("B",1,-1.27,0,6,30),("B",2,-3.81,1.27,5,30) #row,pinno,x,y,skippin,pinsinrow
            $pinspace=2.54
            $skipspace=2.54
            $skipnums=2
            $rowpins=31 
            $PIncrement=2
            $border="-4.5 -5.08","4.5 80.575" # start xy, end xy
            $NPTH=@("0 14.605",2),("0 79.375",2) #mounting hole x,y,size
            $sloty=$PCIpin1offsety
        }
        "5vPCI" { 
            $rows=@("A",1,3.81,0,25,30),("A",2,1.27,1.27,24,30),("B",1,-1.27,0,25,30),("B",2,-3.81,1.27,24,30)
            $pinspace=2.54
            $skipspace=2.54
            $skipnums=2
            $PIncrement=2
            $border="-4.65 -5.08","4.5 80.19"
            $NPTH=@("0 -1.905",2.44),("0 62.865",2.44)
            $sloty=$PCIpin1offsety
        }   
        "1xPCIE" { 
            $rows=@("A",1,1.25,0,6,9),("A",2,3.25,1.016,5,9),("B",1,-1.25,0,6,9),("B",2,-3.25,1.016,5,9) #row,pinno,x,y,skippin
            $pinspace=2
            $skipspace=2
            $skipnums=0
            $PIncrement=2
            $border="-4.5 -5.08","4.5 22.8"
            $NPTH=@('0 11.65',2.35),('0 20.8',2.35)
            $sloty=$PCIEpin1offsety
        }
        "4xPCIE" { 
            $rows=@("A",1,1.25,0,6,16),("A",2,3.25,1.016,5,16),("B",1,-1.25,0,6,16),("B",2,-3.25,1.016,5,16) #row,pinno,x,y,skippin
            $pinspace=2
            $skipspace=2
            $skipnums=0
            $PIncrement=2
            $border="-4.5 -5.08","4.5 36.81"
            $NPTH=@('0 11.65',2.35),('0 34.81',2.35)
            $sloty=$PCIEpin1offsety
        }
        "8xPCIE" { 
            $rows=@("A",1,1.25,0,6,25),("A",2,3.25,1.016,5,25),("B",1,-1.25,0,6,25),("B",2,-3.25,1.016,5,25) #row,pinno,x,y,skippin
            $pinspace=2
            $skipspace=2
            $skipnums=0
            $PIncrement=2
            $border="-4.5 -5.08","4.5 53.8"
            $NPTH=@('0 11.65',2.35),('0 51.8',2.35)
            $sloty=$PCIEpin1offsety
        }
        "16xPCIE" { 
            $rows=@("A",1,1.25,0,6,41),("A",2,3.25,1.016,5,41),("B",1,-1.25,0,6,41),("B",2,-3.25,1.016,5,41) #row,pinno,x,y,skippin
            $pinspace=2
            $skipspace=2
            $skipnums=0
            $PIncrement=2
            $border="-4.5 -5.08","4.5 86.8"
            $NPTH=@('0 11.65',2.35),('0 84.8',2.35)
            $sloty=$PCIEpin1offsety
        }
        "8bISA" {
            $rows=@("A",1,2.54,0,31,31),("B",1,-2.54,0,31,31)  
            $pinspace=2.54
            $skipspace=0
            $skipnums=0
            $PIncrement=1
            $border=@("-4.5 -5.08","4.5 80.73")
            $sloty=$ISApin1offsety
        }
        "16bISA" {
            $rows=@("A",1,2.54,0,31,49),("B",1,-2.54,0,31,49) 
            $pinspace=2.54
            $skipspace=7.62
            $skipnums=0
            $PIncrement=1
            $border="-4.5 -5.08","4.5 133.26"
            $sloty=$ISApin1offsety
        }
    }

    $Slot='(footprint "' +$type+ '"(layer "F.Cu")(at ' +$slotX+ ' ' +$slotY+ ' 0)'
    #$SLOT='(footprint "'+ $type +'"(version 20240108) (generator "myne") (generator_version "8.0")'"+ $newline
    foreach ($hole in $NPTH) {  
        $SLOT+='  (pad "" np_thru_hole circle (at '+ $hole[0] +' 0) (size '+$hole[1]+" "+ $hole[1]+') (drill '+ $hole[1]+') (layers "*.Cu" "*.Mask"))'+ $newline
    }
    foreach ($row in $rows) {
        $pinletter=$row[0]
        $pinno=$row[1]
        [decimal]$pinx=$row[2]
        [decimal]$piny=$row[3]
        $skippin=$row[4]
        $pinsinrow=$row[5]
        
        For ($i=1; $i -le $pinsinrow; $i++){
           $SLOT+='  (pad "'+$pinletter +$pinno + '" thru_hole circle (at '+$pinx +" "+ $piny +') (size 1.5 1.5) (drill 1.016) (layers "*.Cu" "*.Mask"))'+$newline
           $piny+=$pinspace
           if ($i -eq $skippin) {$piny+=$skipspace; $pinno+=$skipnums }
           $pinno+= $PIncrement
        }
    }
    $SLOT+="  "+ $rect[0] + $border[0] + $rect[1] + $border[1] + $rect[2]+$newline
    return $SLOT
}

function togglebrd {
    param ([int]$index, [int]$indexmax)
    if (($index+1) -ge $indexmax) { 
        return 1
    } else {
        return $index+1
    }
}

function toggleslot {
    param ($slotx, [int]$indexmax, $var )
    for ($i=1; $i -le $indexmax; $i++) {
        if ($slotx -eq $var[$i]) {
            $j=$i+1
            if ($j -lt $indexmax) { 
                return $var[$j]
            } else {
              return $var[1]
            }
         }
    }
}


function Show-Menu {
    param (
    [string]$Title = ‘Choose specifications’
    )
    cls
    Write-Host “================ $Title ================”  
    Write-Host “    Board Type: " $boardtypes[$brdindex].size
    Write-Host “       L x W  : " $boardtypes[$brdindex].width "x" $boardtypes[$brdindex].length
    Write-Host “       Slots  : " $boardtypes[$brdindex].slots
    for ($i=1; $i -le $boardtypes[$brdindex].slots; $i++) { 
        Write-Host "           Slot $i type:" $slotno[$i]
    }
    Write-Host “================ $Title ================”  
    Write-host 
    Write-host "B = change board type."
    Write-host "Numbers 1-8 = change slot type."
    Write-host 
    Write-host "Board types: " $boardtypes.size
    Write-Host "Slot types:  " $slottypes 
    Write-Host
    Write-Host "Note, there are only 7 real slots, but ISA can share."
    Write-Host "ISA cannot use Slot 1, The rest cannot use Slot 8"    
    Write-Host "There are no protections for overlapping slots."
    Write-Host 
    Write-Host “Press ‘F’ to finish.”
    Write-Host
 
 }


do
 {
            Show-Menu
            $input = Read-Host “Please make a selection”
            $item=$input[0]
            $action=$input[1]

            If ($action -eq $null) { 
                switch ($item)
                {
                ‘b’ { $brdindex = togglebrd $brdindex $boardtypes.Count}
                '1' { $slotno[1]=toggleslot $slotno[1] $slottypes.count $slottypes}  
                '2' { $slotno[2]=toggleslot $slotno[2] $slottypes.count $slottypes} 
                '3' { $slotno[3]=toggleslot $slotno[3] $slottypes.count $slottypes}  
                '4' { $slotno[4]=toggleslot $slotno[4] $slottypes.count $slottypes}  
                '5' { $slotno[5]=toggleslot $slotno[5] $slottypes.count $slottypes}  
                '6' { $slotno[6]=toggleslot $slotno[6] $slottypes.count $slottypes}  
                '7' { $slotno[7]=toggleslot $slotno[7] $slottypes.count $slottypes}  
                '8' { $slotno[8]=toggleslot $slotno[8] $slottypes.count $slottypes}  
                }
            }
            
 }
 until ($input -eq ‘f’)

 
 
 #write file

#edgecuts coords
$fileout=$kicadpcbheader

$PCBendX=$PCBstartX-$boardtypes[$brdindex].width
$PCBendY=$PCBstartY+$boardtypes[$brdindex].length
$pcbedge='(gr_rect(start ' + $PCBstartX+' '+$PCBstartY + ') (end ' +$PCBendX+' '+$PCBendY +')' + $kicadboardfooter


 for ($i=1; $i -le $boardtypes[$brdindex].slots; $i++) {
    $slottype=$slotno[$i]
    $partX=$slot0centreline-( $slotwidth*$i )

    switch ($slottype) {
        "3vPCI" { $partY=$PCIpin1offsetY }
        "5vPCI" { $partY=$PCIpin1offsetY }   
        "1xPCIE" { $partY=$PCIEpin1offsety }
        "4xPCIE" { $partY=$PCIEpin1offsety }
        "8xPCIE" { $partY=$PCIEpin1offsety }
        "16xPCIE" { $partY=$PCIEpin1offsety }
        "3vAGP" { $partY=$AGPpin1offsetY }
        "1.5vAGP" { $partY=$AGPpin1offsetY }
        "UniversalAGP" { $partY=$AGPpin1offsetY }
        "8bISA" { $partX+=$ISAcentreoffsetx;  $partY= $ISApin1offsetY }
        "16bISA" { $partX+=$ISAcentreoffsetx; $partY= $ISApin1offsetY }
    }
    $fileout+=(fBuildSlot $slottype $partX $party)


 }

foreach ($hole in $holes) {
    $x=$hole[0]
    $y=$hole[1]
    if ($x -gt $PCBendX -and $y -lt $PCBendY) {
        $fileout+=(fboardhole $x, $y)
    }
}
$ioarea='(gr_rect (start 131.9784 -12.5)(end 290.7284 12.5)(stroke(width 0.05)(type default))(fill none)(layer "F.CrtYd"))'+$newline
$fileout+=$ioarea
$fileout+=$pcbedge




$filename=".\" + $boardtypes[$brdindex].size + ".kicad_pcb"
$fileout | out-file $filename -encoding ascii

Write-host $filename written