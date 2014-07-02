<?php
function smarty_function_count($params, &$smarty)
{
  if (empty($params['var'])) {
        $smarty->trigger_error("assign: missing 'var' parameter");
        return;
  }
  $result = count($params['var']);
  
  if (empty($params['assign'])) {
       return $result;
  } else {
    $smarty->assign($params['assign'], $result);
  }
}
?>
