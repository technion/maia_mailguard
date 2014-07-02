<?php

function smarty_function_text_config_row($params, &$smarty)
{
  
      $ret = '<div class="config_row panel1 inny">';
	  $ret .= '<span class="config_key">' . $smarty->_tpl_vars['lang'][text_ . $params['option']]; 
	  $ret .= ' <a href="adminhelp.php#' . $params['option'] . $smarty->_tpl_vars['sid'] .'" target="new">[?]</a>';
	  $ret .= '</span><span class="config_value"><input type="text" name="'. $params['option'] .'" size="12" value="'.           
	          $smarty->_tpl_vars[$params['option']] .'"></span></div>';
		  
      return $ret;
   
}
?>