<html>
	<head/>
	<body>

<?php
	echo '<h1>CPU info</h1>';
	$cpuinfo = `cat /proc/cpuinfo`;
	echo nl2br($cpuinfo);
	
	echo '<h1>Kernel cmdline</h1>';
	$cmdline = `cat /proc/cmdline`;
	echo nl2br($cmdline);

	echo '<h1>Root device</h1>';
	$root = `mount | grep ' / '`;
	echo nl2br($root);
?>

	</body>
</html>
