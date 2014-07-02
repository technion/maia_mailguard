<?php
require_once ("./locale/$display_language/welcome.php");

$cache_count = count_cache_items($euid);
$smarty->assign('hamcount', array_key_exists('H', $cache_count) ? $cache_count['H']['count'] : 0);
$smarty->assign('spamcount', array_key_exists('S', $cache_count) ? $cache_count['S']['count'] : 0);
$smarty->assign('viruscount', array_key_exists('V', $cache_count) ? $cache_count['V']['count'] : 0);
$smarty->assign('headercount', array_key_exists('B', $cache_count) ? $cache_count['B']['count'] : 0);
$smarty->assign('bannedcount', array_key_exists('F', $cache_count) ? $cache_count['F']['count'] : 0);


 ?>
