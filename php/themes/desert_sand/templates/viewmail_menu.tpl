{capture name="raw_link" assign="raw_link"}{$return_route}{$msid}id={$id}&cache_type={$cache_type}&raw={/capture}
<div class="buttonwrapper topbanner4">
<a class="squarebutton hambutton" href="#" onclick="itemAction('{$return_route}{$msid}id={$id}', 'ham'); return false;"><span>{$actionlang.0}</span></a>
 <a class="squarebutton spambutton" href="#" onclick="itemAction('{$return_route}{$msid}id={$id}', 'spam'); return false;"><span>{$actionlang.1}</span></a>
 <a class="squarebutton deletebutton" href="#" onclick="itemAction('{$return_route}{$msid}id={$id}', 'delete'); return false;"><span>{$actionlang.2}</span></a> 
 <a class="squarebutton resendbutton" href="#" onclick="itemAction('{$return_route}{$msid}id={$id}', 'resend'); return false;"><span>{$lang.button_resend}</span></a> 
{if ! $raw}
<a class="squarebutton rawbutton{if $ajax} thickbox{/if}" href="{$raw_link}y"><span>{$lang.link_view_raw}</span></a>
{else}
<a class="squarebutton decodebutton{if $ajax} thickbox{/if}" href="{$raw_link}n"><span>{$lang.link_view_decoded}</span></a>
{/if}
  </div>