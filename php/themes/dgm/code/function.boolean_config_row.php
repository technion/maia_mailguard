<?php

function smarty_function_boolean_config_row($params, &$smarty)
{
  
      $ret = '<div class="config_row panel1 inny">';
	  $ret .= '<span class="config_key">' . $smarty->_tpl_vars['lang'][text_ . $params['option']]; 
	  $ret .= ' <a href="adminhelp.php#' . $params['option'] . $smarty->_tpl_vars['sid'] .'" target="new">[?]</a>';
	  $ret .= '</span><span class="config_value"><ul><li><input type="radio" name="'.$params['option'].'" value="Y" ';
	  if ($smarty->_tpl_vars[$params['option']]) {
		  	$ret .= "checked";
	  }
	  $ret .= '>' . $smarty->_tpl_vars['lang']['text_yes'] .'</li>';
	  $ret .= '<li>	<input type="radio" name="' .$params['option'] . '" value="N" ';
	  if (! $smarty->_tpl_vars[$params['option']]) {
		  	$ret .= "checked";
	  }
	  
	  $ret .= '> '. $smarty->_tpl_vars['lang']['text_no'] 
	       . '</li></ul></span></div>';
		  
      return $ret;
   
}
?>