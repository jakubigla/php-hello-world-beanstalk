<?php

var_dump($argv);

$zip = new ZipArchive();
$filename = "./" . $argv[2] . "-" . $argv[1] . ".zip";

if ($zip->open($filename, ZipArchive::CREATE)!==TRUE) {
    exit("cannot open <$filename>\n");
}

$zip->addFile("index.php");
echo "numfiles: " . $zip->numFiles . "\n";
echo "status:" . $zip->status . "\n";
$zip->close();
?>