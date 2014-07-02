<table border="0" cellspacing="0" cellpadding="0"><tr>
<td class="topbanner4" align="center">
<a href="javascript:itemAction('{$return_route}{$msid}id={$id}', 'spam')"
              onmouseover="show_tooltip(this, event, '{$lang.link_report}')"
              onmouseout="hide_tooltip()">
{if $use_icons} 
<img src="{$template_dir}images/report-spam.png" border="0" alt="{$lang.link_view_decoded}" /><br />
  {/if}
    {$lang.link_report}
       </a>
       &nbsp;&nbsp;&nbsp;
 </td><td align="center">
          <a href="javascript:itemAction('{$return_route}{$msid}id={$id}', 'ham')"
              onmouseover="show_tooltip(this, event, '{$lang.link_confirm_ham}')"
              onmouseout="hide_tooltip()">
{if $use_icons} 
<img src="{$template_dir}images/rescue-item.png" border="0" alt="{$lang.link_view_decoded}" /><br />
  {/if}
         {$lang.link_confirm_ham}
       </a>
       &nbsp;&nbsp;&nbsp;
 </td><td align="center">      
          <a href="javascript:itemAction('{$return_route}{$msid}id={$id}', 'delete')"
              onmouseover="show_tooltip(this, event, '{$lang.link_delete}')"
              onmouseout="hide_tooltip()">
{if $use_icons} 
<img src="{$template_dir}images/delete-item.png" border="0" alt="{$lang.link_view_decoded}" /><br />
  {/if}
         {$lang.link_delete}
       </a>
       &nbsp;&nbsp;&nbsp;
</td>       
 <td align="center">

 {capture name="raw_link" assign="raw_link"}{$return_route}{$msid}id={$id}&cache_type={$cache_type}&raw={/capture} 

{if ! $raw}
<a href="{$raw_link}y&amp;height=350&amp;width=700" {if $ajax} class="thickbox"{/if} 
              onmouseover="show_tooltip(this, event, '{$lang.link_view_raw}')"
              onmouseout="hide_tooltip()">
  {if $use_icons}
<img src="{$template_dir}images/view-raw.png" border="0"
    alt="{$lang.link_view_raw}" /><br />
  {/if}
 {$lang.link_view_raw}
</a>
{else}
<a href="{$raw_link}n&amp;height=350&amp;width=700" {if $ajax} class="thickbox"{/if} 
   onmouseover="show_tooltip(this, event, '{$lang.link_view_decoded}')"
   onmouseout="hide_tooltip()">
  {if $use_icons} 
<img src="{$template_dir}images/view-decoded.png" border="0" alt="{$lang.link_view_decoded}" /><br />
  {/if}
{$lang.link_view_decoded}
</a>
{/if}
</td>
<td align="center">
	<a href="javascript:itemAction('{$return_route}{$msid}id={$id}', 'resend')"
          onmouseover="show_tooltip(this, event, '{$lang.link_resend}')"
          onmouseout="hide_tooltip()">
	  {if $use_icons} 
	<img src="{$template_dir}images/redo.png" border="0" alt="{$lang.link_resend}" /><br />
	  {/if}
	{$lang.link_resend}
	</a>
</td>
</tr>
</table>