<?php

    $img = imagecreatefrompng('graphics/bgr.png');
    $width = imagesx($img);
    $height = imagesy($img);
    echo "Image: $width x $height\n";
    $tiles_dx = intval($width / 16);
    $tiles_dy = intval($height / 16);
    echo "Tiles: $tiles_dx x $tiles_dy\n";
    
    // tiles array
    $tilesArray = Array();
    // tiles map
    $tilesMap = Array();
    
    // scan image and create map and array
    for ($tiley=0; $tiley<$tiles_dy; $tiley++)
    {
        for ($tilex=0; $tilex<$tiles_dx; $tilex++)
        {
            // create a tile
	    $tile = Array();
	    for ($y=0; $y<16; $y++)
            {
		for ($x2=0; $x2<4; $x2++)
		{
                    $res = 0; 
	            for ($x=0; $x<4; $x++)
                    {
                        $py = $tiley*16 + $y;
		        $px = $tilex*16 + $x2*4 + $x;
		        $res = ($res >> 2) & 0xFFFF;
                        $rgb_index = imagecolorat($img, $px, $py);
                        $rgba = imagecolorsforindex($img, $rgb_index);
                        $r = $rgba['red'];
                        $g = $rgba['green'];
                        $b = $rgba['blue'];
		        if ($r > 127) $res = $res | 0b11000000;
                        if ($g > 127) $res = $res | 0b10000000;
                        if ($b > 127) $res = $res | 0b01000000;
                    }
                    array_push($tile, $res);
	        } 
            }
	    // now check do we already have this tile
            $found = -1;
	    for ($i=0; $i<count($tilesArray); $i++)
            {
		$diff = array_diff_assoc($tile, $tilesArray[$i]);
                if (count($diff) == 0) {
                    $found = $i;
		    break;
                }
	    }
	    // if not found - add to tilesArray
	    if ($found < 0) {
		$found = array_push($tilesArray, $tile) - 1;
	    }
	    // add to tilesMap
	    array_push($tilesMap, $found);
        }
    }
    
    echo "Total tiles in map: ".count($tilesMap)."\n";
    echo "Different tiles count: ".count($tilesArray)."\n";
    
    ////////////////////////////////////////////////////////////////////////////
    
    echo "Writing tiles map ...\n";
    $f = fopen ("bgr.mac", "w");
    fputs($f, "BgrData:\n\t.byte\t");
    $total = count($tilesMap);
    for ($i=0; $i<$total; $i++)
    {
	fputs($f, decoct($tilesMap[$i]));
	if ($i%16 != 15) fputs($f, ", "); 
	  else if ($i<($total-1)) fputs($f, "\n\t.byte\t");
    }
    fputs($f, "\n\n");


    echo "Writing tiles data ...\n";
    fputs($f, "TilesAddr:\n");
    for ($t=0; $t<count($tilesArray); $t++)
    {
	$tile = $tilesArray[$t];
	fputs($f, "TilesData".str_pad("".$t, 3, "0", STR_PAD_LEFT).":\n");
	fputs($f, "\t.byte\t");
	for ($i=0; $i<4*16; $i++)
	{
	    fputs($f, decoct($tile[$i]));
	    if ($i<(4*16-1)) fputs($f, ", "); else fputs($f, "\n");
	}
    }
    fputs($f, "\n\n");

    fclose($f);
    
?>